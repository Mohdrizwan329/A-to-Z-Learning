import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AccessibilityService extends GetxService {
  final GetStorage _box = GetStorage();

  // Font settings
  final RxBool dyslexiaFontEnabled = false.obs;
  final RxDouble fontScale = 1.0.obs;
  final RxDouble lineSpacing = 1.5.obs;
  final RxDouble letterSpacing = 0.0.obs;

  // Color settings
  final RxBool colorBlindModeEnabled = false.obs;
  final Rx<ColorBlindType> colorBlindType = ColorBlindType.none.obs;
  final RxBool highContrastEnabled = false.obs;
  final RxBool reduceAnimationsEnabled = false.obs;

  // Visual settings
  final RxBool largeButtonsEnabled = false.obs;
  final RxBool boldTextEnabled = false.obs;
  final RxBool underlinkLinksEnabled = false.obs;

  // Audio settings
  final RxBool screenReaderOptimized = false.obs;
  final RxBool hapticFeedbackEnabled = true.obs;
  final RxDouble voiceSpeed = 1.0.obs;

  // Reading aids
  final RxBool readingGuideEnabled = false.obs;
  final RxBool focusModeEnabled = false.obs;

  Future<AccessibilityService> init() async {
    await _loadSettings();
    return this;
  }

  Future<void> _loadSettings() async {
    dyslexiaFontEnabled.value = _box.read<bool>('a11y_dyslexia_font') ?? false;
    fontScale.value = _box.read<double>('a11y_font_scale') ?? 1.0;
    lineSpacing.value = _box.read<double>('a11y_line_spacing') ?? 1.5;
    letterSpacing.value = _box.read<double>('a11y_letter_spacing') ?? 0.0;

    colorBlindModeEnabled.value = _box.read<bool>('a11y_color_blind') ?? false;
    final colorBlindIndex = _box.read<int>('a11y_color_blind_type') ?? 0;
    colorBlindType.value = ColorBlindType.values[colorBlindIndex];
    highContrastEnabled.value = _box.read<bool>('a11y_high_contrast') ?? false;
    reduceAnimationsEnabled.value = _box.read<bool>('a11y_reduce_animations') ?? false;

    largeButtonsEnabled.value = _box.read<bool>('a11y_large_buttons') ?? false;
    boldTextEnabled.value = _box.read<bool>('a11y_bold_text') ?? false;
    underlinkLinksEnabled.value = _box.read<bool>('a11y_underline_links') ?? false;

    screenReaderOptimized.value = _box.read<bool>('a11y_screen_reader') ?? false;
    hapticFeedbackEnabled.value = _box.read<bool>('a11y_haptic') ?? true;
    voiceSpeed.value = _box.read<double>('a11y_voice_speed') ?? 1.0;

    readingGuideEnabled.value = _box.read<bool>('a11y_reading_guide') ?? false;
    focusModeEnabled.value = _box.read<bool>('a11y_focus_mode') ?? false;
  }

  Future<void> _saveSettings() async {
    await _box.write('a11y_dyslexia_font', dyslexiaFontEnabled.value);
    await _box.write('a11y_font_scale', fontScale.value);
    await _box.write('a11y_line_spacing', lineSpacing.value);
    await _box.write('a11y_letter_spacing', letterSpacing.value);

    await _box.write('a11y_color_blind', colorBlindModeEnabled.value);
    await _box.write('a11y_color_blind_type', colorBlindType.value.index);
    await _box.write('a11y_high_contrast', highContrastEnabled.value);
    await _box.write('a11y_reduce_animations', reduceAnimationsEnabled.value);

    await _box.write('a11y_large_buttons', largeButtonsEnabled.value);
    await _box.write('a11y_bold_text', boldTextEnabled.value);
    await _box.write('a11y_underline_links', underlinkLinksEnabled.value);

    await _box.write('a11y_screen_reader', screenReaderOptimized.value);
    await _box.write('a11y_haptic', hapticFeedbackEnabled.value);
    await _box.write('a11y_voice_speed', voiceSpeed.value);

    await _box.write('a11y_reading_guide', readingGuideEnabled.value);
    await _box.write('a11y_focus_mode', focusModeEnabled.value);
  }

  // Font helpers
  String get fontFamily => dyslexiaFontEnabled.value ? 'OpenDyslexic' : 'Roboto';

  TextStyle applyAccessibility(TextStyle style) {
    return style.copyWith(
      fontFamily: fontFamily,
      fontSize: (style.fontSize ?? 14) * fontScale.value,
      height: lineSpacing.value,
      letterSpacing: letterSpacing.value,
      fontWeight: boldTextEnabled.value ? FontWeight.bold : style.fontWeight,
    );
  }

  // Color blind safe colors
  Color getAccessibleColor(Color original) {
    if (!colorBlindModeEnabled.value) return original;

    switch (colorBlindType.value) {
      case ColorBlindType.protanopia:
        return _adjustForProtanopia(original);
      case ColorBlindType.deuteranopia:
        return _adjustForDeuteranopia(original);
      case ColorBlindType.tritanopia:
        return _adjustForTritanopia(original);
      case ColorBlindType.none:
        return original;
    }
  }

  Color _adjustForProtanopia(Color c) {
    // Replace reds with blues/purples
    final r = (c.r * 255).round();
    final g = (c.g * 255).round();
    final b = (c.b * 255).round();
    if (r > 200 && g < 100 && b < 100) {
      return Color.fromRGBO(100, g, 200, c.a);
    }
    return c;
  }

  Color _adjustForDeuteranopia(Color c) {
    // Replace greens with blues
    final r = (c.r * 255).round();
    final g = (c.g * 255).round();
    final b = (c.b * 255).round();
    if (g > 200 && r < 100 && b < 100) {
      return Color.fromRGBO(r, 100, 200, c.a);
    }
    return c;
  }

  Color _adjustForTritanopia(Color c) {
    // Replace blues/yellows
    final r = (c.r * 255).round();
    final g = (c.g * 255).round();
    final b = (c.b * 255).round();
    if (b > 200 && r < 100 && g < 100) {
      return Color.fromRGBO(100, 200, b, c.a);
    }
    return c;
  }

  // Color blind safe palette
  List<Color> get colorBlindSafePalette {
    if (!colorBlindModeEnabled.value) {
      return [
        const Color(0xFFFF6B6B),
        const Color(0xFF4ECDC4),
        const Color(0xFF45B7D1),
        const Color(0xFF96CEB4),
        const Color(0xFFFFEAA7),
        const Color(0xFFDDA0DD),
      ];
    }

    // Color blind safe palette (Okabe-Ito palette)
    return [
      const Color(0xFF0072B2), // Blue
      const Color(0xFFE69F00), // Orange
      const Color(0xFF009E73), // Green
      const Color(0xFFF0E442), // Yellow
      const Color(0xFF56B4E9), // Sky Blue
      const Color(0xFFD55E00), // Vermillion
      const Color(0xFFCC79A7), // Pink
    ];
  }

  // Button sizing
  double get buttonHeight => largeButtonsEnabled.value ? 60 : 48;
  double get iconSize => largeButtonsEnabled.value ? 32 : 24;
  EdgeInsets get buttonPadding => largeButtonsEnabled.value
      ? const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
      : const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  // Animation duration
  Duration get animationDuration => reduceAnimationsEnabled.value
      ? Duration.zero
      : const Duration(milliseconds: 300);

  // Setters with save
  Future<void> setDyslexiaFont(bool enabled) async {
    dyslexiaFontEnabled.value = enabled;
    await _saveSettings();
  }

  Future<void> setFontScale(double scale) async {
    fontScale.value = scale.clamp(0.8, 1.5);
    await _saveSettings();
  }

  Future<void> setLineSpacing(double spacing) async {
    lineSpacing.value = spacing.clamp(1.0, 2.5);
    await _saveSettings();
  }

  Future<void> setLetterSpacing(double spacing) async {
    letterSpacing.value = spacing.clamp(0.0, 3.0);
    await _saveSettings();
  }

  Future<void> setColorBlindMode(bool enabled, {ColorBlindType? type}) async {
    colorBlindModeEnabled.value = enabled;
    if (type != null) colorBlindType.value = type;
    await _saveSettings();
  }

  Future<void> setHighContrast(bool enabled) async {
    highContrastEnabled.value = enabled;
    await _saveSettings();
  }

  Future<void> setReduceAnimations(bool enabled) async {
    reduceAnimationsEnabled.value = enabled;
    await _saveSettings();
  }

  Future<void> setLargeButtons(bool enabled) async {
    largeButtonsEnabled.value = enabled;
    await _saveSettings();
  }

  Future<void> setBoldText(bool enabled) async {
    boldTextEnabled.value = enabled;
    await _saveSettings();
  }

  Future<void> setHapticFeedback(bool enabled) async {
    hapticFeedbackEnabled.value = enabled;
    await _saveSettings();
  }

  Future<void> setVoiceSpeed(double speed) async {
    voiceSpeed.value = speed.clamp(0.5, 2.0);
    await _saveSettings();
  }

  Future<void> setReadingGuide(bool enabled) async {
    readingGuideEnabled.value = enabled;
    await _saveSettings();
  }

  Future<void> setFocusMode(bool enabled) async {
    focusModeEnabled.value = enabled;
    await _saveSettings();
  }

  // Reset all settings
  Future<void> resetToDefaults() async {
    dyslexiaFontEnabled.value = false;
    fontScale.value = 1.0;
    lineSpacing.value = 1.5;
    letterSpacing.value = 0.0;
    colorBlindModeEnabled.value = false;
    colorBlindType.value = ColorBlindType.none;
    highContrastEnabled.value = false;
    reduceAnimationsEnabled.value = false;
    largeButtonsEnabled.value = false;
    boldTextEnabled.value = false;
    underlinkLinksEnabled.value = false;
    screenReaderOptimized.value = false;
    hapticFeedbackEnabled.value = true;
    voiceSpeed.value = 1.0;
    readingGuideEnabled.value = false;
    focusModeEnabled.value = false;
    await _saveSettings();
  }
}

enum ColorBlindType {
  none,
  protanopia,   // Red-blind
  deuteranopia, // Green-blind
  tritanopia,   // Blue-blind
}

extension ColorBlindTypeExtension on ColorBlindType {
  String get displayName {
    switch (this) {
      case ColorBlindType.none:
        return 'None';
      case ColorBlindType.protanopia:
        return 'Protanopia (Red-blind)';
      case ColorBlindType.deuteranopia:
        return 'Deuteranopia (Green-blind)';
      case ColorBlindType.tritanopia:
        return 'Tritanopia (Blue-blind)';
    }
  }
}
