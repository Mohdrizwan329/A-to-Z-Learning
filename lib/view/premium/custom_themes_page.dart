import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class CustomThemesPage extends StatefulWidget {
  const CustomThemesPage({Key? key}) : super(key: key);

  @override
  State<CustomThemesPage> createState() => _CustomThemesPageState();
}

class _CustomThemesPageState extends State<CustomThemesPage> {
  final _storage = GetStorage();
  String _selectedTheme = 'default';

  final List<Map<String, dynamic>> themes = [
    {
      'id': 'default',
      'name': 'Default Purple',
      'icon': '💜',
      'primary': Color(0xFF667EEA),
      'secondary': Color(0xFF764BA2),
      'accent': Color(0xFFF093FB),
    },
    {
      'id': 'ocean',
      'name': 'Ocean Blue',
      'icon': '🌊',
      'primary': Color(0xFF0077B6),
      'secondary': Color(0xFF00B4D8),
      'accent': Color(0xFF90E0EF),
    },
    {
      'id': 'sunset',
      'name': 'Sunset Orange',
      'icon': '🌅',
      'primary': Color(0xFFFF6B6B),
      'secondary': Color(0xFFFF8E53),
      'accent': Color(0xFFFFD93D),
    },
    {
      'id': 'forest',
      'name': 'Forest Green',
      'icon': '🌲',
      'primary': Color(0xFF2D6A4F),
      'secondary': Color(0xFF40916C),
      'accent': Color(0xFF95D5B2),
    },
    {
      'id': 'candy',
      'name': 'Candy Pink',
      'icon': '🍭',
      'primary': Color(0xFFFF6EB4),
      'secondary': Color(0xFFFF9ECE),
      'accent': Color(0xFFFFD1E8),
    },
    {
      'id': 'space',
      'name': 'Space Dark',
      'icon': '🚀',
      'primary': Color(0xFF1A1A2E),
      'secondary': Color(0xFF16213E),
      'accent': Color(0xFFE94560),
    },
    {
      'id': 'rainbow',
      'name': 'Rainbow',
      'icon': '🌈',
      'primary': Color(0xFFFF0000),
      'secondary': Color(0xFF00FF00),
      'accent': Color(0xFF0000FF),
    },
    {
      'id': 'golden',
      'name': 'Royal Gold',
      'icon': '👑',
      'primary': Color(0xFFFFD700),
      'secondary': Color(0xFFFFA500),
      'accent': Color(0xFFDAA520),
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedTheme = _storage.read<String>('selected_theme') ?? 'default';
  }

  void _selectTheme(String themeId) {
    setState(() {
      _selectedTheme = themeId;
    });
    _storage.write('selected_theme', themeId);

    final theme = themes.firstWhere((t) => t['id'] == themeId);
    Get.snackbar(
      'Theme Applied!',
      '${theme['name']} theme is now active.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: theme['primary'],
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = themes.firstWhere((t) => t['id'] == _selectedTheme);

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
          "Custom Themes",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
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
        child: Column(
          children: [
            // Current Theme Preview
            _buildCurrentThemePreview(currentTheme),
            // Theme Grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16.r),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.r,
                  crossAxisSpacing: 16.r,
                  childAspectRatio: 0.85,
                ),
                itemCount: themes.length,
                itemBuilder: (context, index) {
                  final theme = themes[index];
                  return _buildThemeCard(theme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentThemePreview(Map<String, dynamic> theme) {
    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(theme['icon'], style: const TextStyle(fontSize: 40)),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Theme',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      theme['name'],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme['primary'],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: const Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Color preview
          Row(
            children: [
              Expanded(child: _buildColorPreview('Primary', theme['primary'])),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildColorPreview('Secondary', theme['secondary']),
              ),
              SizedBox(width: 8.w),
              Expanded(child: _buildColorPreview('Accent', theme['accent'])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorPreview(String label, Color color) {
    return Column(
      children: [
        Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildThemeCard(Map<String, dynamic> theme) {
    final isSelected = _selectedTheme == theme['id'];
    final primary = theme['primary'] as Color;
    final secondary = theme['secondary'] as Color;
    final accent = theme['accent'] as Color;

    return GestureDetector(
      onTap: () => _selectTheme(theme['id']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: isSelected ? Border.all(color: primary, width: 3) : null,
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.3),
              blurRadius: isSelected ? 20 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Gradient preview at top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primary, secondary, accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    theme['icon'],
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  children: [
                    Text(
                      theme['name'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    // Mini color dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildColorDot(primary),
                        SizedBox(width: 6.w),
                        _buildColorDot(secondary),
                        SizedBox(width: 6.w),
                        _buildColorDot(accent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Selected checkmark
            if (isSelected)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16.r),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorDot(Color color) {
    return Container(
      width: 20.w,
      height: 20.h,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4.r),
        ],
      ),
    );
  }
}
