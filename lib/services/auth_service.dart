import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import 'api_client.dart';

/// App-wide auth state, backed by the Laravel Sanctum token endpoints
/// (/api/v1/register, /api/v1/login, /api/v1/me, /api/v1/logout). Holds the
/// current user in memory + persists the token on-device so sign-in
/// survives an app restart. Widgets listen via `AnimatedBuilder` /
/// `ListenableBuilder` on `AuthService.instance`.
class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  bool _bootstrapped = false;

  /// Call once at app start to restore a saved session, if any.
  Future<void> bootstrap() async {
    if (_bootstrapped) return;
    _bootstrapped = true;
    if (!await ApiClient.instance.isAuthenticated) return;

    final res = await ApiClient.instance.get('/me', auth: true);
    if (res.ok && res.data is Map) {
      _currentUser = AppUser.fromJson(res.data['user'] as Map<String, dynamic>);
      notifyListeners();
    } else {
      // Saved token is no longer valid (expired/revoked) — clear it.
      await ApiClient.instance.setToken(null);
    }
  }

  Future<String?> login(String email, String password) async {
    final res = await ApiClient.instance.post('/login', {
      'email': email,
      'password': password,
    });

    if (!res.ok) return res.errorMessage;

    final token = res.data['token'] as String;
    await ApiClient.instance.setToken(token);
    _currentUser = AppUser.fromJson(res.data['user'] as Map<String, dynamic>);
    notifyListeners();
    return null; // success
  }

  Future<String?> register(String name, String email, String password) async {
    final res = await ApiClient.instance.post('/register', {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
    });

    if (!res.ok) return res.errorMessage;

    final token = res.data['token'] as String;
    await ApiClient.instance.setToken(token);
    _currentUser = AppUser.fromJson(res.data['user'] as Map<String, dynamic>);
    notifyListeners();
    return null; // success
  }

  Future<void> logout() async {
    await ApiClient.instance.post('/logout', {}, auth: true);
    await ApiClient.instance.setToken(null);
    _currentUser = null;
    notifyListeners();
  }
}
