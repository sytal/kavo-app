import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Thin HTTP wrapper around the Laravel backend's `/api/v1` routes
/// (see routes/api.php in the sytal-coffee project). Auth is Sanctum
/// personal-access-token based: register/login return a `token`, which is
/// stored on-device and sent back as `Authorization: Bearer <token>` on
/// every authenticated call.
///
/// Base URL: on a real device/physical phone (like the one this was tested
/// on) `127.0.0.1` means *the phone itself*, not the dev machine, so the
/// LAN IP of the machine running `php artisan serve` is required. An
/// Android *emulator* (not a real device) would instead use `10.0.2.2`.
/// Change [baseUrl] below if the backend's LAN IP changes, or to the
/// production URL once Hostinger hosting is sorted out.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  /// Set per build: `flutter build apk --dart-define=API_BASE_URL=https://example.com/api/v1`.
  /// Without it the web build talks to the host it was opened from (port
  /// 8011), and mobile builds fall back to the dev machine's LAN address.
  static const String _defined = String.fromEnvironment('API_BASE_URL');
  static final String baseUrl = _defined.isNotEmpty
      ? _defined
      : kIsWeb
          ? '${Uri.base.scheme}://${Uri.base.host}:8011/api/v1'
          : 'http://192.168.100.13:8011/api/v1';

  /// Scheme + host + port of the backend, e.g. "http://192.168.100.13:8011".
  static String get serverOrigin => baseUrl.replaceFirst(RegExp(r'/api/v1/?$'), '');

  /// Turns an image path/URL from the API into one this device can load:
  /// "/uploads/x.jpg" or "http://127.0.0.1:8011/uploads/x.jpg" both become
  /// `<serverOrigin>/uploads/x.jpg`.
  static String resolveMediaUrl(String url) {
    if (url.startsWith('/')) return '$serverOrigin$url';
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return url;
    final path = uri.hasQuery ? '${uri.path}?${uri.query}' : uri.path;
    return '$serverOrigin$path';
  }

  String? _token;
  bool _loaded = false;

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _loaded = true;
  }

  Future<void> setToken(String? token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.remove('auth_token');
    } else {
      await prefs.setString('auth_token', token);
    }
  }

  Future<bool> get isAuthenticated async {
    await _ensureLoaded();
    return _token != null;
  }

  Future<Map<String, String>> _headers({bool auth = false}) async {
    await _ensureLoaded();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<ApiResponse> get(String path, {bool auth = false}) async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl$path'), headers: await _headers(auth: auth))
          .timeout(const Duration(seconds: 15));
      return ApiResponse.fromHttp(res);
    } catch (e) {
      return ApiResponse.networkError(e.toString());
    }
  }

  Future<ApiResponse> post(String path, Map<String, dynamic> body, {bool auth = false}) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: await _headers(auth: auth),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
      return ApiResponse.fromHttp(res);
    } catch (e) {
      return ApiResponse.networkError(e.toString());
    }
  }
}

class ApiResponse {
  final int statusCode;
  final dynamic data;
  final String? networkErrorMessage;

  ApiResponse({required this.statusCode, required this.data, this.networkErrorMessage});

  bool get ok => statusCode >= 200 && statusCode < 300;
  bool get isNetworkError => networkErrorMessage != null;

  /// Pulls a readable message out of Laravel's standard error shapes:
  /// `{"message": "..."}` or `{"errors": {"field": ["msg", ...]}}`.
  String get errorMessage {
    if (networkErrorMessage != null) {
      return 'Could not reach the server. Check your connection and that the backend is reachable at ${ApiClient.baseUrl}.';
    }
    if (data is Map && data['errors'] is Map) {
      final errors = (data['errors'] as Map).values.expand((v) => v is List ? v : [v]);
      if (errors.isNotEmpty) return errors.first.toString();
    }
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return 'Something went wrong (HTTP $statusCode).';
  }

  static ApiResponse fromHttp(http.Response res) {
    dynamic decoded;
    try {
      decoded = res.body.isNotEmpty ? jsonDecode(res.body) : null;
    } catch (_) {
      decoded = null;
    }
    return ApiResponse(statusCode: res.statusCode, data: decoded);
  }

  static ApiResponse networkError(String message) =>
      ApiResponse(statusCode: 0, data: null, networkErrorMessage: message);
}
