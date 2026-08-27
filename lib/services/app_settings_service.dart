import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// App Settings Service - Manages theme, dark mode, language, and other app-wide settings
class AppSettingsService extends GetxService {
  static AppSettingsService get to => Get.find<AppSettingsService>();

  final GetStorage _storage = GetStorage();

  // Keys for storage
  static const String kDarkMode = 'dark_mode_enabled';
  static const String kEyeFriendlyMode = 'eye_friendly_mode';
  static const String kLanguage = 'app_language';
  static const String kBackgroundMusic = 'background_music_enabled';
  static const String kSoundEffects = 'sound_effects_enabled';
  static const String kVoicePronunciation = 'voice_pronunciation_enabled';
  static const String kFontSize = 'font_size';

  // Observable settings
  final RxBool isDarkMode = false.obs;
  final RxBool isEyeFriendlyMode = false.obs;
  final RxString currentLanguage = 'en'.obs;
  final RxBool isBackgroundMusicEnabled = true.obs;
  final RxBool isSoundEffectsEnabled = true.obs;
  final RxBool isVoicePronunciationEnabled = true.obs;
  final RxDouble fontSize = 1.0.obs; // 1.0 = normal, 1.2 = large, 0.9 = small

  // Theme colors for different modes
  static const Map<String, List<Color>> lightThemeGradients = {
    'primary': [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
    'appBar': [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
    'card': [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
  };

  static const Map<String, List<Color>> darkThemeGradients = {
    'primary': [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
    'appBar': [Color(0xFF2d2d44), Color(0xFF1a1a2e)],
    'card': [Color(0xFF2d2d44), Color(0xFF1f1f32)],
  };

  static const Map<String, List<Color>> eyeFriendlyGradients = {
    'primary': [Color(0xFFFFF8E1), Color(0xFFFFECB3), Color(0xFFFFE082)],
    'appBar': [Color(0xFF8D6E63), Color(0xFFA1887F)],
    'card': [Color(0xFFFFFDE7), Color(0xFFFFF9C4)],
  };

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _applyThemeMode();
  }

  /// The theme to start in, read straight off storage.
  ///
  /// `GetMaterialApp` needs this before any service is looked up, so it reads
  /// the stored value rather than the observable.
  static ThemeMode startupThemeMode() {
    final dark = GetStorage().read<bool>(kDarkMode) ?? false;
    return dark ? ThemeMode.dark : ThemeMode.light;
  }

  /// Keeps Material's own surfaces -- dialogs, pickers, text fields -- in step
  /// with the switch. The screens' own gradients are handled by AppTintShell.
  void _applyThemeMode() {
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void _loadSettings() {
    isDarkMode.value = _storage.read<bool>(kDarkMode) ?? false;
    isEyeFriendlyMode.value = _storage.read<bool>(kEyeFriendlyMode) ?? false;
    currentLanguage.value = _storage.read<String>(kLanguage) ?? 'en';
    isBackgroundMusicEnabled.value = _storage.read<bool>(kBackgroundMusic) ?? true;
    isSoundEffectsEnabled.value = _storage.read<bool>(kSoundEffects) ?? true;
    isVoicePronunciationEnabled.value = _storage.read<bool>(kVoicePronunciation) ?? true;
    fontSize.value = _storage.read<double>(kFontSize) ?? 1.0;
  }

  // Toggle Dark Mode
  Future<void> toggleDarkMode() async {
    isDarkMode.value = !isDarkMode.value;
    if (isDarkMode.value) {
      isEyeFriendlyMode.value = false;
      await _storage.write(kEyeFriendlyMode, false);
    }
    await _storage.write(kDarkMode, isDarkMode.value);
    _applyThemeMode();
  }

  // Toggle Eye-Friendly Mode
  Future<void> toggleEyeFriendlyMode() async {
    isEyeFriendlyMode.value = !isEyeFriendlyMode.value;
    if (isEyeFriendlyMode.value) {
      isDarkMode.value = false;
      await _storage.write(kDarkMode, false);
    }
    await _storage.write(kEyeFriendlyMode, isEyeFriendlyMode.value);
  }

  // Set Dark Mode
  Future<void> setDarkMode(bool value) async {
    isDarkMode.value = value;
    if (value) {
      isEyeFriendlyMode.value = false;
      await _storage.write(kEyeFriendlyMode, false);
    }
    await _storage.write(kDarkMode, value);
    _applyThemeMode();
  }

  // Set Eye-Friendly Mode
  Future<void> setEyeFriendlyMode(bool value) async {
    isEyeFriendlyMode.value = value;
    if (value) {
      isDarkMode.value = false;
      await _storage.write(kDarkMode, false);
    }
    await _storage.write(kEyeFriendlyMode, value);
  }

  // Set Language
  Future<void> setLanguage(String langCode) async {
    currentLanguage.value = langCode;
    await _storage.write(kLanguage, langCode);
  }

  // Toggle Background Music
  Future<void> toggleBackgroundMusic() async {
    isBackgroundMusicEnabled.value = !isBackgroundMusicEnabled.value;
    await _storage.write(kBackgroundMusic, isBackgroundMusicEnabled.value);
  }

  // Toggle Sound Effects
  Future<void> toggleSoundEffects() async {
    isSoundEffectsEnabled.value = !isSoundEffectsEnabled.value;
    await _storage.write(kSoundEffects, isSoundEffectsEnabled.value);
  }

  // Toggle Voice Pronunciation
  Future<void> toggleVoicePronunciation() async {
    isVoicePronunciationEnabled.value = !isVoicePronunciationEnabled.value;
    await _storage.write(kVoicePronunciation, isVoicePronunciationEnabled.value);
  }

  // Set Font Size
  Future<void> setFontSize(double size) async {
    fontSize.value = size;
    await _storage.write(kFontSize, size);
  }

  // Get current theme gradients
  Map<String, List<Color>> get currentThemeGradients {
    if (isEyeFriendlyMode.value) return eyeFriendlyGradients;
    if (isDarkMode.value) return darkThemeGradients;
    return lightThemeGradients;
  }

  // Get background gradient
  List<Color> get backgroundGradient => currentThemeGradients['primary']!;

  // Get appBar gradient
  List<Color> get appBarGradient => currentThemeGradients['appBar']!;

  // Get text color based on theme
  Color get primaryTextColor {
    if (isDarkMode.value) return Colors.white;
    if (isEyeFriendlyMode.value) return Color(0xFF3E2723);
    return Color(0xFF2D3436);
  }

  Color get secondaryTextColor {
    if (isDarkMode.value) return Colors.white70;
    if (isEyeFriendlyMode.value) return Color(0xFF5D4037);
    return Color(0xFF636E72);
  }

  // Get card background color
  Color get cardBackgroundColor {
    if (isDarkMode.value) return Color(0xFF2d2d44);
    if (isEyeFriendlyMode.value) return Color(0xFFFFFDE7);
    return Colors.white;
  }

  // Available languages
  static const List<Map<String, String>> availableLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिंदी'},
    {'code': 'ta', 'name': 'Tamil', 'nativeName': 'தமிழ்'},
    {'code': 'te', 'name': 'Telugu', 'nativeName': 'తెలుగు'},
    {'code': 'mr', 'name': 'Marathi', 'nativeName': 'मराठी'},
    {'code': 'gu', 'name': 'Gujarati', 'nativeName': 'ગુજરાતી'},
    {'code': 'bn', 'name': 'Bengali', 'nativeName': 'বাংলা'},
  ];
}
