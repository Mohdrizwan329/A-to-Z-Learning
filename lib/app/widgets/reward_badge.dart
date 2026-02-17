import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'animated_builder.dart';

/// A reward badge widget with animation
class RewardBadgeWidget extends StatefulWidget {
  final String emoji;
  final String name;
  final String description;
  final Color color;
  final bool isUnlocked;
  final VoidCallback? onTap;
  final int? requiredStars;
  final int? currentStars;

  const RewardBadgeWidget({
    super.key,
    required this.emoji,
    required this.name,
    this.description = '',
    required this.color,
    this.isUnlocked = false,
    this.onTap,
    this.requiredStars,
    this.currentStars,
  });

  @override
  State<RewardBadgeWidget> createState() => _RewardBadgeWidgetState();
}

class _RewardBadgeWidgetState extends State<RewardBadgeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _shineAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isUnlocked) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomAnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isUnlocked ? _scaleAnimation.value : 1.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow effect for unlocked badges
                    if (widget.isUnlocked)
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withValues(alpha: 0.5),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    // Badge container
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: widget.isUnlocked
                            ? widget.color
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.isUnlocked
                              ? Colors.white.withValues(alpha: 0.5)
                              : Colors.grey.shade400,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: widget.isUnlocked
                            ? Text(
                                widget.emoji,
                                style: const TextStyle(fontSize: 32),
                              )
                            : Icon(
                                Icons.lock_rounded,
                                color: Colors.grey.shade500,
                                size: 28,
                              ),
                      ),
                    ),
                    // Shine effect for unlocked badges
                    if (widget.isUnlocked)
                      Positioned.fill(
                        child: ClipOval(
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withValues(alpha: 0.3),
                                  Colors.transparent,
                                ],
                                stops: [
                                  _shineAnimation.value - 0.3,
                                  _shineAnimation.value,
                                  _shineAnimation.value + 0.3,
                                ].map((s) => s.clamp(0.0, 1.0)).toList(),
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.srcATop,
                            child: Container(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: AppTheme.spacingXS),
          Text(
            widget.name,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: widget.isUnlocked ? Colors.white : Colors.white60,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.requiredStars != null && !widget.isUnlocked)
            Text(
              '${widget.currentStars ?? 0}/${widget.requiredStars}',
              style: GoogleFonts.nunito(
                fontSize: 10,
                color: Colors.white54,
              ),
            ),
        ],
      ),
    );
  }
}

/// A star counter widget
class StarCounter extends StatelessWidget {
  final int count;
  final double size;
  final Color color;
  final bool showLabel;

  const StarCounter({
    super.key,
    required this.count,
    this.size = 20,
    this.color = const Color(0xFFFFD700),
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: color,
            size: size,
          ),
          SizedBox(width: AppTheme.spacingXS),
          Text(
            count.toString(),
            style: GoogleFonts.poppins(
              fontSize: size * 0.8,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (showLabel)
            Text(
              ' stars',
              style: GoogleFonts.nunito(
                fontSize: size * 0.6,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}

/// A streak counter widget
class StreakCounter extends StatelessWidget {
  final int days;
  final Color color;

  const StreakCounter({
    super.key,
    required this.days,
    this.color = AppTheme.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: Colors.white,
            size: 32,
          ),
          SizedBox(width: AppTheme.spacingS),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$days Day${days == 1 ? '' : 's'}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Streak!',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
