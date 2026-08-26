import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:jiyan_learning/utils/responsive.dart';

/// Common AppBar with gradient styling used across the app
/// Matches the design from Numbers page
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? emoji;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Color>? gradientColors;

  const CommonAppBar({
    super.key,
    required this.title,
    this.emoji,
    this.subtitle,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.gradientColors,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors =
        gradientColors ??
        [
          const Color(0xFFFF6B6B),
          const Color(0xFFFF8E53),
          const Color(0xFFFFAA5A),
        ];

    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: onBackPressed ?? () => Get.back(),
            )
          : null,
      automaticallyImplyLeading: showBackButton,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
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
    );
  }
}
