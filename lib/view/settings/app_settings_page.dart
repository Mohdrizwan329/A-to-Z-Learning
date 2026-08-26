import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/app_settings_service.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  AppSettingsService get settingsService {
    if (!Get.isRegistered<AppSettingsService>()) {
      Get.put(AppSettingsService(), permanent: true);
    }
    return Get.find<AppSettingsService>();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Settings',
      emoji: '⚙️',
      body: Obx(
        () => SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme Section
              _buildSectionTitle("🎨 Theme", settingsService),
              SizedBox(height: 12.h),
              Container(
                decoration: BoxDecoration(
                  color: settingsService.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Theme Preview
                    Container(
                      height: 120.h,
                      margin: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: settingsService.backgroundGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Text(
                          settingsService.isEyeFriendlyMode.value
                              ? "👁️ Eye-Friendly Mode"
                              : settingsService.isDarkMode.value
                              ? "🌙 Dark Mode"
                              : "☀️ Light Mode",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: settingsService.isDarkMode.value
                                ? Colors.white
                                : settingsService.isEyeFriendlyMode.value
                                ? Colors.brown.shade800
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    _buildThemeOption(
                      icon: "☀️",
                      title: "Light Mode",
                      subtitle: "Bright and colorful",
                      isSelected:
                          !settingsService.isDarkMode.value &&
                          !settingsService.isEyeFriendlyMode.value,
                      onTap: () {
                        TtsService.to.speak('Light Mode');
                        settingsService.setDarkMode(false);
                        settingsService.setEyeFriendlyMode(false);
                      },
                      settingsService: settingsService,
                    ),
                    Divider(height: 1.h, color: Colors.grey.shade200),
                    _buildThemeOption(
                      icon: "🌙",
                      title: "Dark Mode",
                      subtitle: "Easy on the eyes at night",
                      isSelected: settingsService.isDarkMode.value,
                      onTap: () {
                        TtsService.to.speak('Dark Mode');
                        settingsService.setDarkMode(true);
                      },
                      settingsService: settingsService,
                    ),
                    Divider(height: 1.h, color: Colors.grey.shade200),
                    _buildThemeOption(
                      icon: "👁️",
                      title: "Eye-Friendly Mode",
                      subtitle: "Warm colors, reduced strain",
                      isSelected: settingsService.isEyeFriendlyMode.value,
                      onTap: () {
                        TtsService.to.speak('Eye-Friendly Mode');
                        settingsService.setEyeFriendlyMode(true);
                      },
                      settingsService: settingsService,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Audio Section
              _buildSectionTitle("🔊 Audio", settingsService),
              SizedBox(height: 12.h),
              Container(
                decoration: BoxDecoration(
                  color: settingsService.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      icon: "🎵",
                      title: "Background Music",
                      subtitle: "Play relaxing music",
                      value: settingsService.isBackgroundMusicEnabled.value,
                      onChanged: (_) => settingsService.toggleBackgroundMusic(),
                      settingsService: settingsService,
                    ),
                    Divider(height: 1.h, color: Colors.grey.shade200),
                    _buildSwitchTile(
                      icon: "🔔",
                      title: "Sound Effects",
                      subtitle: "Tap and action sounds",
                      value: settingsService.isSoundEffectsEnabled.value,
                      onChanged: (_) => settingsService.toggleSoundEffects(),
                      settingsService: settingsService,
                    ),
                    Divider(height: 1.h, color: Colors.grey.shade200),
                    _buildSwitchTile(
                      icon: "🗣️",
                      title: "Voice Pronunciation",
                      subtitle: "Read words aloud",
                      value: settingsService.isVoicePronunciationEnabled.value,
                      onChanged: (_) =>
                          settingsService.toggleVoicePronunciation(),
                      settingsService: settingsService,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Font Size Section
              _buildSectionTitle("🔤 Font Size", settingsService),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: settingsService.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "A",
                          style: TextStyle(
                            fontSize: 14,
                            color: settingsService.primaryTextColor,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: settingsService.fontSize.value,
                            min: 0.8,
                            max: 1.4,
                            divisions: 3,
                            activeColor: const Color(0xFF667EEA),
                            onChanged: (value) =>
                                settingsService.setFontSize(value),
                          ),
                        ),
                        Text(
                          "A",
                          style: TextStyle(
                            fontSize: 24,
                            color: settingsService.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: settingsService.isDarkMode.value
                            ? Colors.black26
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        "Preview: This is how text will look",
                        style: TextStyle(
                          fontSize: 16 * settingsService.fontSize.value,
                          color: settingsService.primaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Language Section
              _buildSectionTitle("�� Language", settingsService),
              SizedBox(height: 12.h),
              Container(
                decoration: BoxDecoration(
                  color: settingsService.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: AppSettingsService.availableLanguages.map((lang) {
                    final isFirst =
                        lang == AppSettingsService.availableLanguages.first;
                    final isLast =
                        lang == AppSettingsService.availableLanguages.last;
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 4.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: isFirst
                                  ? Radius.circular(20.r)
                                  : Radius.zero,
                              bottom: isLast
                                  ? Radius.circular(20.r)
                                  : Radius.zero,
                            ),
                          ),
                          leading: Container(
                            width: 24.w,
                            height: 24.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    settingsService.currentLanguage.value ==
                                        lang['code']
                                    ? const Color(0xFF667EEA)
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                            child:
                                settingsService.currentLanguage.value ==
                                    lang['code']
                                ? Center(
                                    child: Container(
                                      width: 12.w,
                                      height: 12.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF667EEA),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          title: Text(
                            lang['nativeName']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: settingsService.primaryTextColor,
                            ),
                          ),
                          subtitle: Text(
                            lang['name']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: settingsService.secondaryTextColor,
                            ),
                          ),
                          trailing:
                              settingsService.currentLanguage.value ==
                                  lang['code']
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF56D97F),
                                )
                              : null,
                          onTap: () =>
                              settingsService.setLanguage(lang['code']!),
                        ),
                        if (!isLast)
                          Divider(height: 1.h, color: Colors.grey.shade200),
                      ],
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppSettingsService settingsService) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: settingsService.isDarkMode.value
            ? Colors.white
            : settingsService.isEyeFriendlyMode.value
            ? Colors.brown.shade800
            : Colors.white,
      ),
    );
  }

  Widget _buildThemeOption({
    required String icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required AppSettingsService settingsService,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      leading: Text(icon, style: const TextStyle(fontSize: 32)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: settingsService.primaryTextColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: settingsService.secondaryTextColor,
        ),
      ),
      trailing: isSelected
          ? Container(
              padding: EdgeInsets.all(4.r),
              decoration: const BoxDecoration(
                color: Color(0xFF56D97F),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.white, size: 20.r),
            )
          : Container(
              width: 28.w,
              height: 28.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
            ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required AppSettingsService settingsService,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      leading: Text(icon, style: const TextStyle(fontSize: 32)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: settingsService.primaryTextColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: settingsService.secondaryTextColor,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: const Color(0xFF56D97F),
        activeThumbColor: Colors.white,
      ),
    );
  }
}
