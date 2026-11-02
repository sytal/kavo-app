import 'dart:convert';
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
/// Change [baseUrl] below if the backend's LAN IP changes.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const String baseUrl = 'http://192.168.100.13:8011/api/v1';

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
