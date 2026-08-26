import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:jiyan_learning/utils/responsive.dart';

/// A scaffold with gradient background and styled AppBar
/// Used for consistent styling across all screens in the app
class GradientScaffold extends StatelessWidget {
  final String title;
  final String? emoji;
  final String? subtitle;
  final Widget body;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Color>? appBarGradient;
  final List<Color>? bodyGradient;
  final PreferredSizeWidget? bottom;

  const GradientScaffold({
    super.key,
    required this.title,
    required this.body,
    this.emoji,
    this.subtitle,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.appBarGradient,
    this.bodyGradient,
    this.bottom,
  });

  /// Default app bar gradient (Coral to Orange)
  static const List<Color> defaultAppBarGradient = [
    Color(0xFFFF6B6B),
    Color(0xFFFF8E53),
    Color(0xFFFFAA5A),
  ];

  /// Default body gradient (Purple to Pink to Red)
  static const List<Color> defaultBodyGradient = [
    Color(0xFF667EEA),
    Color(0xFF764BA2),
    Color(0xFFF093FB),
    Color(0xFFF5576C),
  ];

  static const List<double> defaultBodyGradientStops = [0.0, 0.3, 0.7, 1.0];

  @override
  Widget build(BuildContext context) {
    final appBarColors = appBarGradient ?? defaultAppBarGradient;
    final bodyColors = bodyGradient ?? defaultBodyGradient;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20.r,
                  ),
                ),
                onPressed: onBackPressed ?? () => Get.back(),
              )
            : null,
        automaticallyImplyLeading: showBackButton,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: appBarColors,
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
        bottom: bottom,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.baloo2(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: GoogleFonts.nunito(fontSize: 12, color: Colors.white70),
              ),
          ],
        ),
        centerTitle: true,
        actions: actions,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bodyColors,
            stops: bodyColors.length == 4 ? defaultBodyGradientStops : null,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
