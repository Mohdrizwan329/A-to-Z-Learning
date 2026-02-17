import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

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
        border: isSelected
            ? Border.all(color: Colors.white, width: 3)
            : null,
      ),
      child: Stack(
        children: [
          // Decorative circles
          if (showDecorations) ...[
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -15,
              left: -15,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
          ],
          // Main content
          Padding(
            padding: padding ?? const EdgeInsets.all(8),
            child: Center(child: child),
          ),
          // Selected star indicator
          if (isSelected && showSelectedStar)
            const Positioned(
              top: 4,
              left: 4,
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

    return GestureDetector(
      onTap: onTap,
      child: card,
    );
  }
}

/// Text content for gradient card (letter, number, etc.)
class GradientCardText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final List<Shadow>? shadows;

  const GradientCardText({
    super.key,
    required this.text,
    this.fontSize = 36,
    this.fontWeight = FontWeight.bold,
    this.color = Colors.white,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        shadows: shadows ??
            [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
      ),
    );
  }
}

/// Image content for gradient card (animals, fruits, etc.)
class GradientCardImage extends StatelessWidget {
  final String imagePath;
  final String? label;
  final double imageSize;
  final double labelFontSize;

  const GradientCardImage({
    super.key,
    required this.imagePath,
    this.label,
    this.imageSize = 60,
    this.labelFontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.image_not_supported,
            size: imageSize * 0.6,
            color: Colors.white54,
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 8),
          Text(
            label!,
            style: TextStyle(
              fontSize: labelFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

/// Emoji content for gradient card
class GradientCardEmoji extends StatelessWidget {
  final String emoji;
  final String? label;
  final double emojiSize;
  final double labelFontSize;

  const GradientCardEmoji({
    super.key,
    required this.emoji,
    this.label,
    this.emojiSize = 40,
    this.labelFontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          emoji,
          style: TextStyle(fontSize: emojiSize),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(
            label!,
            style: TextStyle(
              fontSize: labelFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
