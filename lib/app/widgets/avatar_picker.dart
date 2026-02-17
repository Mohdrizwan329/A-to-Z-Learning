import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'animated_builder.dart';

/// An avatar picker widget for profile selection
class AvatarPicker extends StatefulWidget {
  final List<String> avatars;
  final String? selectedAvatar;
  final ValueChanged<String>? onAvatarSelected;
  final double avatarSize;
  final int crossAxisCount;
  final bool showLabel;

  const AvatarPicker({
    super.key,
    this.avatars = defaultAvatars,
    this.selectedAvatar,
    this.onAvatarSelected,
    this.avatarSize = 70,
    this.crossAxisCount = 4,
    this.showLabel = false,
  });

  static const List<String> defaultAvatars = [
    '🦁', '🐻', '🐰', '🦊',
    '🐼', '🐨', '🐸', '🦄',
    '🐶', '🐱', '🐯', '🐵',
  ];

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  String? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.selectedAvatar;
  }

  void _selectAvatar(String avatar) {
    setState(() {
      _selectedAvatar = avatar;
    });
    widget.onAvatarSelected?.call(avatar);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: AppTheme.spacingM,
        crossAxisSpacing: AppTheme.spacingM,
        childAspectRatio: widget.showLabel ? 0.8 : 1.0,
      ),
      itemCount: widget.avatars.length,
      itemBuilder: (context, index) {
        final avatar = widget.avatars[index];
        final isSelected = avatar == _selectedAvatar;

        return AvatarItem(
          emoji: avatar,
          isSelected: isSelected,
          size: widget.avatarSize,
          showLabel: widget.showLabel,
          onTap: () => _selectAvatar(avatar),
        );
      },
    );
  }
}

/// A single avatar item
class AvatarItem extends StatefulWidget {
  final String emoji;
  final bool isSelected;
  final double size;
  final bool showLabel;
  final VoidCallback? onTap;

  const AvatarItem({
    super.key,
    required this.emoji,
    this.isSelected = false,
    this.size = 70,
    this.showLabel = false,
    this.onTap,
  });

  @override
  State<AvatarItem> createState() => _AvatarItemState();
}

class _AvatarItemState extends State<AvatarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AvatarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.reverse();
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
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _bounceAnimation.value,
                child: Stack(
                  children: [
                    Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? AppTheme.primaryColor.withValues(alpha: 0.2)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: widget.isSelected
                            ? Border.all(
                                color: AppTheme.primaryColor,
                                width: 3,
                              )
                            : null,
                        boxShadow: widget.isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          widget.emoji,
                          style: TextStyle(fontSize: widget.size * 0.5),
                        ),
                      ),
                    ),
                    if (widget.isSelected)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: widget.size * 0.35,
                          height: widget.size * 0.35,
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: widget.size * 0.2,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          if (widget.showLabel) ...[
            SizedBox(height: AppTheme.spacingXS),
            Text(
              _getAvatarName(widget.emoji),
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                color: widget.isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  String _getAvatarName(String emoji) {
    final Map<String, String> avatarNames = {
      '\u{1F981}': 'Lion',
      '\u{1F43B}': 'Bear',
      '\u{1F430}': 'Bunny',
      '\u{1F98A}': 'Fox',
      '\u{1F43C}': 'Panda',
      '\u{1F428}': 'Koala',
      '\u{1F438}': 'Frog',
      '\u{1F984}': 'Unicorn',
      '\u{1F436}': 'Dog',
      '\u{1F431}': 'Cat',
      '\u{1F42F}': 'Tiger',
      '\u{1F435}': 'Monkey',
    };
    return avatarNames[emoji] ?? '';
  }
}

/// A profile avatar display widget
class ProfileAvatar extends StatelessWidget {
  final String emoji;
  final double size;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showEditIcon;

  const ProfileAvatar({
    super.key,
    required this.emoji,
    this.size = 80,
    this.backgroundColor,
    this.onTap,
    this.showEditIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  backgroundColor ?? AppTheme.primaryColor,
                  (backgroundColor ?? AppTheme.primaryColor).withValues(alpha: 0.7),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (backgroundColor ?? AppTheme.primaryColor)
                      .withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(fontSize: size * 0.5),
              ),
            ),
          ),
          if (showEditIcon)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.35,
                height: size * 0.35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit,
                  color: AppTheme.primaryColor,
                  size: size * 0.18,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
