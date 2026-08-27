import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jiyan_learning/services/app_settings_service.dart';

/// Applies Dark and Eye-Friendly mode to the whole app.
///
/// Every screen here paints its own gradient rather than reading a
/// [ThemeData], so a `themeMode` switch reaches dialogs and pickers but leaves
/// the 190-odd hand-coloured pages exactly as bright as they were. A filter
/// over the finished frame reaches all of them, which is what a parent
/// flipping "Dark Mode" at bedtime is actually asking for.
class AppTintShell extends StatelessWidget {
  const AppTintShell({super.key, required this.child});

  final Widget child;

  /// Pulls everything towards black without flattening it to grey: the colours
  /// stay recognisable, at roughly half brightness.
  static const List<double> _dark = <double>[
    0.52, 0, 0, 0, 0, //
    0, 0.52, 0, 0, 0, //
    0, 0, 0.55, 0, 0, //
    0, 0, 0, 1, 0, //
  ];

  /// Warm, low-blue -- the same idea as a night-light filter.
  static const List<double> _warm = <double>[
    1.0, 0, 0, 0, 12, //
    0, 0.94, 0, 0, 6, //
    0, 0, 0.76, 0, 0, //
    0, 0, 0, 1, 0, //
  ];

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppSettingsService>()) return child;
    final settings = Get.find<AppSettingsService>();

    return Obx(() {
      if (settings.isDarkMode.value) {
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix(_dark),
          child: child,
        );
      }
      if (settings.isEyeFriendlyMode.value) {
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix(_warm),
          child: child,
        );
      }
      return child;
    });
  }
}
