import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// The one place the support address lives.
///
/// It used to be typed out inside the help and terms screens, so changing it
/// meant remembering every copy.
class SupportContact {
  SupportContact._();

  static const String email = 'jiyanmohd224146@gmail.com';

  /// Opens the device's mail app with the address, subject and a short
  /// template already filled in. Returns false when no mail app answers, so
  /// the caller can fall back to showing the address to copy.
  static Future<bool> composeEmail({
    String subject = 'Jiyan Learning - Help',
    String body = '',
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: _query({'subject': subject, if (body.isNotEmpty) 'body': body}),
    );

    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('No mail app could be opened: $e');
      return false;
    }
  }

  /// `Uri` encodes query parts with `+` for spaces, which mail apps show
  /// literally; percent-encoding is what they expect.
  static String _query(Map<String, String> params) => params.entries
      .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
