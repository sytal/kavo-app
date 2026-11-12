import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens a link (https, tel:, mailto:) outside the app; shows a message if
/// nothing on the phone can handle it.
Future<void> openLink(BuildContext context, String url) async {
  final ok = url.isNotEmpty && await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open this link.')));
  }
}
