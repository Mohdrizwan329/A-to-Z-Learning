import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/accessibility_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class AccessibilitySettingsPage extends StatelessWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final accessibilityService = Get.find<AccessibilityService>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text(
          "Accessibility",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16.r),
          children: [
            // Reading Support Section
            _buildSectionHeader('📖 Reading Support'),
            _buildSettingsCard([
              Obx(
                () => SwitchListTile(
                  title: const Text('Dyslexia-Friendly Font'),
                  subtitle: const Text(
                    'Uses OpenDyslexic font for easier reading',
                  ),
                  value: accessibilityService.dyslexiaFontEnabled.value,
                  onChanged: (value) =>
                      accessibilityService.setDyslexiaFont(value),
                  secondary: const Text('📝', style: TextStyle(fontSize: 24)),
                ),
              ),
              const Divider(),
              Obx(
                () => ListTile(
                  leading: const Text('📏', style: TextStyle(fontSize: 24)),
                  title: const Text('Font Size'),
                  subtitle: Text(
                    '${(accessibilityService.fontScale.value * 100).round()}%',
                  ),
                  trailing: SizedBox(
                    width: 150.w,
                    child: Slider(
                      value: accessibilityService.fontScale.value,
                      min: 0.8,
                      max: 1.5,
                      divisions: 7,
                      onChanged: (value) =>
                          accessibilityService.setFontScale(value),
                    ),
                  ),
                ),
              ),
              const Divider(),
              Obx(
                () => ListTile(
                  leading: const Text('↔️', style: TextStyle(fontSize: 24)),
                  title: const Text('Letter Spacing'),
                  subtitle: Text(
                    accessibilityService.letterSpacing.value.toStringAsFixed(1),
                  ),
                  trailing: SizedBox(
                    width: 150.w,
                    child: Slider(
                      value: accessibilityService.letterSpacing.value,
                      min: 0.0,
                      max: 2.0,
                      divisions: 8,
                      onChanged: (value) =>
                          accessibilityService.setLetterSpacing(value),
                    ),
                  ),
                ),
              ),
              const Divider(),
              Obx(
                () => ListTile(
                  leading: const Text('↕️', style: TextStyle(fontSize: 24)),
                  title: const Text('Line Spacing'),
                  subtitle: Text(
                    accessibilityService.lineSpacing.value.toStringAsFixed(1),
                  ),
                  trailing: SizedBox(
                    width: 150.w,
                    child: Slider(
                      value: accessibilityService.lineSpacing.value,
                      min: 1.0,
                      max: 2.5,
                      divisions: 6,
                      onChanged: (value) =>
                          accessibilityService.setLineSpacing(value),
                    ),
                  ),
                ),
              ),
              const Divider(),
              Obx(
                () => SwitchListTile(
                  title: const Text('Bold Text'),
                  subtitle: const Text(
                    'Makes all text bold for better visibility',
                  ),
                  value: accessibilityService.boldTextEnabled.value,
                  onChanged: (value) => accessibilityService.setBoldText(value),
                  secondary: const Text(
                    '𝐁',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),

            SizedBox(height: 16.h),

            // Visual Settings Section
            _buildSectionHeader('👁️ Visual Settings'),
            _buildSettingsCard([
              Obx(
                () => SwitchListTile(
                  title: const Text('Color Blind Mode'),
                  subtitle: const Text(
                    'Adjust colors for color vision deficiency',
                  ),
                  value: accessibilityService.colorBlindModeEnabled.value,
                  onChanged: (value) =>
                      accessibilityService.setColorBlindMode(value),
                  secondary: const Text('🎨', style: TextStyle(fontSize: 24)),
                ),
              ),
              Obx(() {
                if (!accessibilityService.colorBlindModeEnabled.value) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    const Divider(),
                    ListTile(
                      leading: const Text('🔴', style: TextStyle(fontSize: 24)),
                      title: const Text('Color Blind Type'),
                      trailing: DropdownButton<ColorBlindType>(
                        value: accessibilityService.colorBlindType.value,
                        onChanged: (type) {
                          if (type != null) {
                            accessibilityService.setColorBlindMode(
                              true,
                              type: type,
                            );
                          }
                        },
                        items: ColorBlindType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.displayName),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              }),
              const Divider(),
              Obx(
                () => SwitchListTile(
                  title: const Text('High Contrast Mode'),
                  subtitle: const Text(
                    'Increases contrast for better visibility',
                  ),
                  value: accessibilityService.highContrastEnabled.value,
                  onChanged: (value) =>
                      accessibilityService.setHighContrast(value),
                  secondary: const Text('◐', style: TextStyle(fontSize: 24)),
                ),
              ),
              const Divider(),
              Obx(
                () => SwitchListTile(
                  title: const Text('Reduce Animations'),
                  subtitle: const Text('Minimizes motion and animations'),
                  value: accessibilityService.reduceAnimationsEnabled.value,
                  onChanged: (value) =>
                      accessibilityService.setReduceAnimations(value),
                  secondary: const Text('🎬', style: TextStyle(fontSize: 24)),
                ),
              ),
              const Divider(),
              Obx(
                () => SwitchListTile(
                  title: const Text('Large Buttons'),
                  subtitle: const Text(
                    'Makes buttons bigger and easier to tap',
                  ),
                  value: accessibilityService.largeButtonsEnabled.value,
                  onChanged: (value) =>
                      accessibilityService.setLargeButtons(value),
                  secondary: const Text('🔘', style: TextStyle(fontSize: 24)),
                ),
              ),
            ]),

            SizedBox(height: 16.h),

            // Audio Settings Section
            _buildSectionHeader('🔊 Audio Settings'),
            _buildSettingsCard([
              Obx(
                () => SwitchListTile(
                  title: const Text('Haptic Feedback'),
                  subtitle: const Text('Vibration feedback on interactions'),
                  value: accessibilityService.hapticFeedbackEnabled.value,
                  onChanged: (value) =>
                      accessibilityService.setHapticFeedback(value),
                  secondary: const Text('📳', style: TextStyle(fontSize: 24)),
                ),
              ),
              const Divider(),
              Obx(
                () => ListTile(
                  leading: const Text('🐢', style: TextStyle(fontSize: 24)),
                  title: const Text('Voice Speed'),
                  subtitle: Text(
                    '${(accessibilityService.voiceSpeed.value * 100).round()}%',
                  ),
                  trailing: SizedBox(
                    width: 150.w,
                    child: Slider(
                      value: accessibilityService.voiceSpeed.value,
                      min: 0.5,
                      max: 2.0,
                      divisions: 6,
                      onChanged: (value) =>
                          accessibilityService.setVoiceSpeed(value),
                    ),
                  ),
                ),
              ),
            ]),

            SizedBox(height: 16.h),

            // Reading Aids Section
            _buildSectionHeader('📚 Reading Aids'),
            _buildSettingsCard([
              Obx(
                () => SwitchListTile(
                  title: const Text('Reading Guide'),
                  subtitle: const Text('Shows a guide line while reading'),
                  value: accessibilityService.readingGuideEnabled.value,
                  onChanged: (value) =>
                      accessibilityService.setReadingGuide(value),
                  secondary: const Text('📏', style: TextStyle(fontSize: 24)),
                ),
              ),
              const Divider(),
              Obx(
                () => SwitchListTile(
                  title: const Text('Focus Mode'),
                  subtitle: const Text(
                    'Highlights active content, dims surroundings',
                  ),
                  value: accessibilityService.focusModeEnabled.value,
                  onChanged: (value) =>
                      accessibilityService.setFocusMode(value),
                  secondary: const Text('🎯', style: TextStyle(fontSize: 24)),
                ),
              ),
            ]),

            SizedBox(height: 16.h),

            // Preview Section
            _buildSectionHeader('👀 Preview'),
            Obx(
              () => Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sample Text Preview',
                      style: accessibilityService.applyAccessibility(
                        const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'This is how text will appear with your current accessibility settings. The quick brown fox jumps over the lazy dog.',
                      style: accessibilityService.applyAccessibility(
                        const TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Wrap(
                      spacing: 8.r,
                      runSpacing: 8.r,
                      children: [
                        _buildColorPreview(
                          'Red',
                          Colors.red,
                          accessibilityService,
                        ),
                        _buildColorPreview(
                          'Green',
                          Colors.green,
                          accessibilityService,
                        ),
                        _buildColorPreview(
                          'Blue',
                          Colors.blue,
                          accessibilityService,
                        ),
                        _buildColorPreview(
                          'Yellow',
                          Colors.yellow,
                          accessibilityService,
                        ),
                        _buildColorPreview(
                          'Orange',
                          Colors.orange,
                          accessibilityService,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Reset Button
            ElevatedButton.icon(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Reset Settings?'),
                    content: const Text(
                      'This will reset all accessibility settings to their defaults.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          accessibilityService.resetToDefaults();
                          Get.back();
                          Get.snackbar(
                            'Settings Reset',
                            'Accessibility settings restored to defaults',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reset to Defaults'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildColorPreview(
    String name,
    Color color,
    AccessibilityService service,
  ) {
    final adjustedColor = service.getAccessibleColor(color);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: adjustedColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        name,
        style: TextStyle(
          color: adjustedColor.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
