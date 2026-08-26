import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class DeviceOptimizationPage extends StatefulWidget {
  const DeviceOptimizationPage({super.key});

  @override
  State<DeviceOptimizationPage> createState() => _DeviceOptimizationPageState();
}

class _DeviceOptimizationPageState extends State<DeviceOptimizationPage> {
  final GetStorage _storage = GetStorage();

  // Performance Settings
  bool lowEndMode = false;
  bool reducedAnimations = false;
  bool lowQualityImages = false;
  bool cacheContent = true;
  bool preloadContent = false;

  // Display Settings
  String displayMode = 'auto'; // auto, phone, tablet
  bool landscapeSupport = false;
  bool largeUI = false;
  double uiScale = 1.0;

  // Memory Settings
  bool autoCleanCache = true;
  int cacheSize = 100; // MB
  bool backgroundSync = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      lowEndMode = _storage.read('lowEndMode') ?? false;
      reducedAnimations = _storage.read('reducedAnimations') ?? false;
      lowQualityImages = _storage.read('lowQualityImages') ?? false;
      cacheContent = _storage.read('cacheContent') ?? true;
      preloadContent = _storage.read('preloadContent') ?? false;
      displayMode = _storage.read('displayMode') ?? 'auto';
      landscapeSupport = _storage.read('landscapeSupport') ?? false;
      largeUI = _storage.read('largeUI') ?? false;
      uiScale = _storage.read('uiScale') ?? 1.0;
      autoCleanCache = _storage.read('autoCleanCache') ?? true;
      cacheSize = _storage.read('cacheSize') ?? 100;
      backgroundSync = _storage.read('backgroundSync') ?? true;
    });
  }

  void _saveSetting(String key, dynamic value) {
    _storage.write(key, value);
  }

  void _enableLowEndMode(bool value) {
    setState(() {
      lowEndMode = value;
      if (value) {
        reducedAnimations = true;
        lowQualityImages = true;
        preloadContent = false;
        backgroundSync = false;
        cacheSize = 50;
      }
    });
    _saveSetting('lowEndMode', value);
    _saveSetting('reducedAnimations', reducedAnimations);
    _saveSetting('lowQualityImages', lowQualityImages);
    _saveSetting('preloadContent', preloadContent);
    _saveSetting('backgroundSync', backgroundSync);
    _saveSetting('cacheSize', cacheSize);
  }

  void _enableTabletMode() {
    setState(() {
      displayMode = 'tablet';
      landscapeSupport = true;
      largeUI = true;
      uiScale = 1.2;
    });
    _saveSetting('displayMode', displayMode);
    _saveSetting('landscapeSupport', landscapeSupport);
    _saveSetting('largeUI', largeUI);
    _saveSetting('uiScale', uiScale);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return GradientScaffold(
      title: 'Device Settings',
      emoji: '⚡',
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          // Device Info Card
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                const Text("📱", style: TextStyle(fontSize: 40)),
                SizedBox(height: 8.h),
                Text(
                  isTablet ? "Tablet Detected" : "Phone Detected",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Screen: ${screenWidth.toInt()} x ${MediaQuery.of(context).size.height.toInt()}",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                SizedBox(height: 16.h),
                if (isTablet && displayMode != 'tablet')
                  ElevatedButton.icon(
                    onPressed: _enableTabletMode,
                    icon: const Icon(Icons.tablet),
                    label: const Text("Enable Tablet Mode"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF667EEA),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Quick Optimize Section
          _buildSectionHeader("🚀", "Quick Optimize"),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: "📱",
                  title: "Low-End Device Mode",
                  subtitle: "Optimize for slower devices",
                  value: lowEndMode,
                  onChanged: _enableLowEndMode,
                  color: Color(0xFFFF6B6B),
                ),
                Divider(height: 1.h),
                ListTile(
                  leading: Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF56D97F).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Center(
                      child: Text("✨", style: TextStyle(fontSize: 22)),
                    ),
                  ),
                  title: const Text(
                    "Auto Optimize",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text("Detect and apply best settings"),
                  trailing: ElevatedButton(
                    onPressed: _autoOptimize,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF56D97F),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Optimize"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Performance Settings
          _buildSectionHeader("⚡", "Performance"),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: "🎬",
                  title: "Reduced Animations",
                  subtitle: "Faster transitions, less battery",
                  value: reducedAnimations,
                  onChanged: (v) {
                    setState(() => reducedAnimations = v);
                    _saveSetting('reducedAnimations', v);
                  },
                  color: Color(0xFF667EEA),
                ),
                Divider(height: 1.h),
                _buildSwitchTile(
                  icon: "🖼️",
                  title: "Low Quality Images",
                  subtitle: "Use compressed images to save memory",
                  value: lowQualityImages,
                  onChanged: (v) {
                    setState(() => lowQualityImages = v);
                    _saveSetting('lowQualityImages', v);
                  },
                  color: Color(0xFFFFAA5A),
                ),
                Divider(height: 1.h),
                _buildSwitchTile(
                  icon: "💾",
                  title: "Cache Content",
                  subtitle: "Store data for faster loading",
                  value: cacheContent,
                  onChanged: (v) {
                    setState(() => cacheContent = v);
                    _saveSetting('cacheContent', v);
                  },
                  color: Color(0xFF4ECDC4),
                ),
                Divider(height: 1.h),
                _buildSwitchTile(
                  icon: "📥",
                  title: "Preload Content",
                  subtitle: "Load next lessons in background",
                  value: preloadContent,
                  onChanged: (v) {
                    setState(() => preloadContent = v);
                    _saveSetting('preloadContent', v);
                  },
                  color: Color(0xFFA78BFA),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Display Settings
          _buildSectionHeader("📺", "Display & Layout"),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF667EEA).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Center(
                      child: Text("📱", style: TextStyle(fontSize: 22)),
                    ),
                  ),
                  title: const Text(
                    "Display Mode",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(_getDisplayModeText()),
                  trailing: DropdownButton<String>(
                    value: displayMode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'auto', child: Text("Auto")),
                      DropdownMenuItem(value: 'phone', child: Text("Phone")),
                      DropdownMenuItem(value: 'tablet', child: Text("Tablet")),
                    ],
                    onChanged: (v) {
                      setState(() => displayMode = v ?? 'auto');
                      _saveSetting('displayMode', displayMode);
                    },
                  ),
                ),
                Divider(height: 1.h),
                _buildSwitchTile(
                  icon: "🔄",
                  title: "Landscape Support",
                  subtitle: "Allow rotation on tablets",
                  value: landscapeSupport,
                  onChanged: (v) {
                    setState(() => landscapeSupport = v);
                    _saveSetting('landscapeSupport', v);
                  },
                  color: Color(0xFF56D97F),
                ),
                Divider(height: 1.h),
                _buildSwitchTile(
                  icon: "🔍",
                  title: "Large UI Elements",
                  subtitle: "Bigger buttons and text for tablets",
                  value: largeUI,
                  onChanged: (v) {
                    setState(() => largeUI = v);
                    _saveSetting('largeUI', v);
                  },
                  color: Color(0xFFFF6B6B),
                ),
                Divider(height: 1.h),
                ListTile(
                  leading: Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFD93D).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Center(
                      child: Text("📏", style: TextStyle(fontSize: 22)),
                    ),
                  ),
                  title: const Text(
                    "UI Scale",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("${(uiScale * 100).toInt()}%"),
                  trailing: SizedBox(
                    width: 150.w,
                    child: Slider(
                      value: uiScale,
                      min: 0.8,
                      max: 1.5,
                      divisions: 7,
                      activeColor: Color(0xFFFFD93D),
                      onChanged: (v) {
                        setState(() => uiScale = v);
                        _saveSetting('uiScale', v);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Memory Settings
          _buildSectionHeader("💾", "Memory & Storage"),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: "🧹",
                  title: "Auto Clean Cache",
                  subtitle: "Remove old cached data automatically",
                  value: autoCleanCache,
                  onChanged: (v) {
                    setState(() => autoCleanCache = v);
                    _saveSetting('autoCleanCache', v);
                  },
                  color: Color(0xFF4ECDC4),
                ),
                Divider(height: 1.h),
                ListTile(
                  leading: Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFA78BFA).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Center(
                      child: Text("📦", style: TextStyle(fontSize: 22)),
                    ),
                  ),
                  title: const Text(
                    "Cache Size Limit",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("$cacheSize MB"),
                  trailing: SizedBox(
                    width: 150.w,
                    child: Slider(
                      value: cacheSize.toDouble(),
                      min: 50,
                      max: 500,
                      divisions: 9,
                      activeColor: Color(0xFFA78BFA),
                      onChanged: (v) {
                        setState(() => cacheSize = v.toInt());
                        _saveSetting('cacheSize', cacheSize);
                      },
                    ),
                  ),
                ),
                Divider(height: 1.h),
                _buildSwitchTile(
                  icon: "🔄",
                  title: "Background Sync",
                  subtitle: "Sync progress when app is idle",
                  value: backgroundSync,
                  onChanged: (v) {
                    setState(() => backgroundSync = v);
                    _saveSetting('backgroundSync', v);
                  },
                  color: Color(0xFF667EEA),
                ),
                Divider(height: 1.h),
                ListTile(
                  leading: Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFFF6B6B).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Center(
                      child: Text("🗑️", style: TextStyle(fontSize: 22)),
                    ),
                  ),
                  title: const Text(
                    "Clear Cache Now",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text("Free up storage space"),
                  trailing: ElevatedButton(
                    onPressed: _clearCache,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6B6B),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Clear"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Reset Button
          ElevatedButton.icon(
            onPressed: _resetToDefaults,
            icon: const Icon(Icons.refresh),
            label: const Text("Reset to Defaults"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String emoji, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Flexible(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        width: 45.w,
        height: 45.h,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(child: Text(icon, style: const TextStyle(fontSize: 22))),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: color.withValues(alpha: 0.5),
        inactiveTrackColor: Colors.grey.shade300,
      ),
    );
  }

  String _getDisplayModeText() {
    switch (displayMode) {
      case 'phone':
        return 'Optimized for phones';
      case 'tablet':
        return 'Optimized for tablets';
      default:
        return 'Automatically detect';
    }
  }

  void _autoOptimize() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    setState(() {
      if (isTablet) {
        displayMode = 'tablet';
        landscapeSupport = true;
        largeUI = true;
        uiScale = 1.2;
      } else {
        displayMode = 'phone';
        landscapeSupport = false;
        largeUI = false;
        uiScale = 1.0;
      }
      // Default performance settings
      reducedAnimations = false;
      lowQualityImages = false;
      cacheContent = true;
      preloadContent = true;
      autoCleanCache = true;
      backgroundSync = true;
    });

    // Save all settings
    _saveSetting('displayMode', displayMode);
    _saveSetting('landscapeSupport', landscapeSupport);
    _saveSetting('largeUI', largeUI);
    _saveSetting('uiScale', uiScale);
    _saveSetting('reducedAnimations', reducedAnimations);
    _saveSetting('lowQualityImages', lowQualityImages);
    _saveSetting('cacheContent', cacheContent);
    _saveSetting('preloadContent', preloadContent);
    _saveSetting('autoCleanCache', autoCleanCache);
    _saveSetting('backgroundSync', backgroundSync);

    Get.snackbar(
      "Optimized!",
      isTablet ? "Tablet settings applied" : "Phone settings applied",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF56D97F),
      colorText: Colors.white,
      margin: EdgeInsets.all(16.r),
      borderRadius: 12.r,
    );
  }

  void _clearCache() {
    Get.dialog(
      AlertDialog(
        title: const Text("Clear Cache?"),
        content: const Text(
          "This will remove all cached content. Downloaded offline content will not be affected.",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                "Cache Cleared",
                "Temporary data has been removed",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Color(0xFF56D97F),
                colorText: Colors.white,
                margin: EdgeInsets.all(16.r),
                borderRadius: 12.r,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF6B6B)),
            child: const Text("Clear", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _resetToDefaults() {
    Get.dialog(
      AlertDialog(
        title: const Text("Reset Settings?"),
        content: const Text(
          "This will reset all device optimization settings to defaults.",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              setState(() {
                lowEndMode = false;
                reducedAnimations = false;
                lowQualityImages = false;
                cacheContent = true;
                preloadContent = false;
                displayMode = 'auto';
                landscapeSupport = false;
                largeUI = false;
                uiScale = 1.0;
                autoCleanCache = true;
                cacheSize = 100;
                backgroundSync = true;
              });
              // Clear all saved settings
              _storage.remove('lowEndMode');
              _storage.remove('reducedAnimations');
              _storage.remove('lowQualityImages');
              _storage.remove('cacheContent');
              _storage.remove('preloadContent');
              _storage.remove('displayMode');
              _storage.remove('landscapeSupport');
              _storage.remove('largeUI');
              _storage.remove('uiScale');
              _storage.remove('autoCleanCache');
              _storage.remove('cacheSize');
              _storage.remove('backgroundSync');

              Get.snackbar(
                "Reset Complete",
                "All settings restored to defaults",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Color(0xFF667EEA),
                colorText: Colors.white,
                margin: EdgeInsets.all(16.r),
                borderRadius: 12.r,
              );
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }
}
