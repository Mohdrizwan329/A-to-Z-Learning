import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

import 'package:jiyan_learning/utils/responsive.dart';

/// Reusable gradient card widget for grid items
/// Used across alphabet, numbers, tables, learning pages
class GradientCard extends StatelessWidget {
  final Widget child;
  final List<Color> gradient;
  final bool isSelected;
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool showDecorations;
  final bool showSelectedStar;
  final Animation<double>? pulseAnimation;

  const GradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.isSelected = false,
    this.onTap,
    this.borderRadius = 20,
    this.padding,
    this.showDecorations = true,
    this.showSelectedStar = true,
    this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isSelected ? AppColors.selectedGradient : gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppColors.cardShadow(
          isSelected ? AppColors.selectedGradient[0] : gradient[0],
          isSelected: isSelected,
        ),
        border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
      ),
      child: Stack(
        children: [
          // Decorative circles
          if (showDecorations) ...[
            Positioned(
              top: -10.h,
              right: -10.w,
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -15.h,
              left: -15.w,
              child: Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
          ],
          // Main content
          Padding(
            padding: padding ?? EdgeInsets.all(8.r),
            child: Center(child: child),
          ),
          // Selected star indicator
          if (isSelected && showSelectedStar)
            Positioned(
              top: 4.h,
              left: 4.w,
              child: Text("⭐", style: TextStyle(fontSize: 14)),
            ),
        ],
      ),
    );

    // Apply pulse animation if provided
    if (pulseAnimation != null) {
      card = AnimatedBuilder(
        animation: pulseAnimation!,
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? pulseAnimation!.value : 1.0,
            child: child,
          );
        },
        child: card,
      );
    }

    return GestureDetector(onTap: onTap, child: card);
  }
}

/// Text content for gradient card (letter, number, etc.)
class GradientCardText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final List<Shadow>? shadows;

  /// Line cap for the cards that show prose rather than a number. Left null by
  /// default so the big single-value cards are unaffected.
  final int? maxLines;

  const GradientCardText({
    super.key,
    required this.text,
    this.fontSize = 36,
    this.fontWeight = FontWeight.bold,
    this.color = Colors.white,
    this.shadows,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        shadows:
            shadows ??
            [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(2, 2),
                blurRadius: 4.r,
              ),
            ],
      ),
    );
  }
}
