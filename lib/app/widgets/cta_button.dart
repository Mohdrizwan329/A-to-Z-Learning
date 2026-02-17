import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'animated_builder.dart';

/// A Call-To-Action button with bounce animation
class CTAButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final double? width;
  final double height;
  final bool isLoading;
  final bool isOutlined;
  final double fontSize;
  final BorderRadius? borderRadius;

  const CTAButton({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.width,
    this.height = 56,
    this.isLoading = false,
    this.isOutlined = false,
    this.fontSize = 16,
    this.borderRadius,
  });

  @override
  State<CTAButton> createState() => _CTAButtonState();
}

class _CTAButtonState extends State<CTAButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? AppTheme.primaryColor;

    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => _controller.forward() : null,
      onTapUp: widget.onTap != null
          ? (_) {
              _controller.reverse();
              widget.onTap?.call();
            }
          : null,
      onTapCancel:
          widget.onTap != null ? () => _controller.reverse() : null,
      child: CustomAnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width ?? double.infinity,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.isOutlined ? Colors.transparent : bgColor,
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(AppTheme.radiusMedium),
                border: widget.isOutlined
                    ? Border.all(color: bgColor, width: 2)
                    : null,
                boxShadow: widget.isOutlined
                    ? null
                    : [
                        BoxShadow(
                          color: bgColor.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.isOutlined
                                ? bgColor
                                : widget.textColor ?? Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: widget.isOutlined
                                  ? bgColor
                                  : widget.textColor ?? Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: AppTheme.spacingS),
                          ],
                          Text(
                            widget.label,
                            style: GoogleFonts.poppins(
                              fontSize: widget.fontSize,
                              fontWeight: FontWeight.w600,
                              color: widget.isOutlined
                                  ? bgColor
                                  : widget.textColor ?? Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A fun round CTA button
class RoundCTAButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final double size;
  final String? label;

  const RoundCTAButton({
    super.key,
    required this.icon,
    this.color = AppTheme.primaryColor,
    this.onTap,
    this.size = 60,
    this.label,
  });

  @override
  State<RoundCTAButton> createState() => _RoundCTAButtonState();
}

class _RoundCTAButtonState extends State<RoundCTAButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _onTap,
          child: CustomAnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _bounceAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.color,
                        widget.color.withValues(alpha: 0.8),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: widget.size * 0.5,
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.label != null) ...[
          SizedBox(height: AppTheme.spacingXS),
          Text(
            widget.label!,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ],
    );
  }
}

/// A text CTA button (for links)
class TextCTAButton extends StatelessWidget {
  final String label;
  final Color? color;
  final VoidCallback? onTap;
  final IconData? icon;
  final double fontSize;

  const TextCTAButton({
    super.key,
    required this.label,
    this.color,
    this.onTap,
    this.icon,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppTheme.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
              decoration: TextDecoration.underline,
              decorationColor: textColor,
            ),
          ),
          if (icon != null) ...[
            SizedBox(width: AppTheme.spacingXS),
            Icon(icon, color: textColor, size: fontSize + 2),
          ],
        ],
      ),
    );
  }
}
