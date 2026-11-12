import 'dart:convert';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import 'api_client.dart';

/// Applies the colour theme chosen in Admin > Appearance (GET /api/v1/theme)
/// before the first frame. The last theme is cached so the app opens in the
/// right colours even offline; a fresh copy is fetched (max ~2s) each launch.
class ThemeLoader {
  static const _cacheKey = 'theme_cache_v1';

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    Map? theme;
    try {
      final res = await ApiClient.instance.get('/theme').timeout(const Duration(seconds: 2));
      if (res.ok && res.data is Map && res.data['data'] is Map) {
        theme = res.data['data'] as Map;
        await prefs.setString(_cacheKey, jsonEncode(theme));
      }
    } catch (_) {}
    if (theme == null) {
      final cached = prefs.getString(_cacheKey);
      if (cached != null) {
        try {
          theme = jsonDecode(cached) as Map;
        } catch (_) {}
      }
    }
    if (theme == null) return;

    final mode = theme['mode']?.toString() ?? 'auto';
    final light = mode == 'light' ||
        (mode == 'auto' && PlatformDispatcher.instance.platformBrightness == Brightness.light);
    final palette = theme[light ? 'light' : 'dark'];
    if (palette is Map) AppColors.apply(palette, light: light);
  }
}
