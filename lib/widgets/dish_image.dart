import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../theme/app_colors.dart';

/// Shows a dish photo from either the bundled assets (offline fallback menu)
/// or the backend (live menu). Server URLs are re-pointed at the API host the
/// app actually talks to — the API builds them from its own APP_URL, which
/// may be "127.0.0.1" and unreachable from a phone. Missing or broken images
/// fall back to a branded placeholder instead of an error box.
class DishImage extends StatelessWidget {
  final String image;
  final BoxFit fit;

  const DishImage(this.image, {super.key, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) return const _Placeholder();

    if (image.startsWith('http') || image.startsWith('/')) {
      final url = ApiClient.resolveMediaUrl(image);
      return Image.network(
        url,
        // Keyed by URL so a filtered/re-ordered grid never shows the previous
        // occupant's photo in a reused slot (seen with <img> on web).
        key: ValueKey(url),
        fit: fit,
        // Web builds: plain <img> fallback when the server sends no CORS
        // headers for static files (php artisan serve doesn't). No effect
        // on Android/iOS.
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        errorBuilder: (_, _, _) => const _Placeholder(),
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : const ColoredBox(color: AppColors.surfaceAlt),
      );
    }

    return Image.asset('assets/images/$image', fit: fit, errorBuilder: (_, _, _) => const _Placeholder());
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surfaceAlt,
      child: Center(child: Icon(Icons.restaurant_rounded, color: AppColors.foregroundMuted, size: 32)),
    );
  }
}
