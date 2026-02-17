import 'package:flutter/material.dart';

/// Mixin that provides float and pulse animations for grid-based pages
/// Use with TickerProviderStateMixin in your StatefulWidget State class
///
/// Example usage:
/// ```dart
/// class _MyPageState extends State<MyPage>
///     with TickerProviderStateMixin, GridAnimationsMixin {
///   @override
///   void initState() {
///     super.initState();
///     initGridAnimations(this);
///   }
///
///   @override
///   void dispose() {
///     disposeGridAnimations();
///     super.dispose();
///   }
/// }
/// ```
mixin GridAnimationsMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;

  /// Access to float animation for grid items
  Animation<double> get floatAnimation => _floatAnimation;

  /// Access to pulse animation for selected items
  Animation<double> get pulseAnimation => _pulseAnimation;

  /// Access to float controller
  AnimationController get floatController => _floatController;

  /// Access to pulse controller
  AnimationController get pulseController => _pulseController;

  /// Initialize animations with customizable durations
  void initGridAnimations(
    TickerProvider vsync, {
    Duration floatDuration = const Duration(seconds: 3),
    Duration pulseDuration = const Duration(milliseconds: 1500),
    double floatRange = 4.0,
    double pulseMin = 1.0,
    double pulseMax = 1.08,
  }) {
    _floatController = AnimationController(
      vsync: vsync,
      duration: floatDuration,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: vsync,
      duration: pulseDuration,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -floatRange, end: floatRange).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: pulseMin, end: pulseMax).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  /// Dispose of animation controllers
  void disposeGridAnimations() {
    _floatController.dispose();
    _pulseController.dispose();
  }

  /// Build animated grid item with float effect
  /// Items alternate float direction based on index
  Widget buildFloatingItem({
    required int index,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (_, child) {
        final offset = (index % 2 == 0)
            ? _floatAnimation.value
            : -_floatAnimation.value;
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      child: child,
    );
  }

  /// Build animated item with pulse effect when selected
  Widget buildPulsingItem({
    required bool isSelected,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? _pulseAnimation.value : 1.0,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Combined float and pulse animation for grid items
  Widget buildAnimatedGridItem({
    required int index,
    required bool isSelected,
    required Widget child,
  }) {
    return buildFloatingItem(
      index: index,
      child: buildPulsingItem(
        isSelected: isSelected,
        child: child,
      ),
    );
  }
}

/// Extension on State for easy animation setup without mixin
/// Useful when you can't use mixin due to inheritance constraints
class GridAnimationsHelper {
  final TickerProvider vsync;
  late AnimationController floatController;
  late AnimationController pulseController;
  late Animation<double> floatAnimation;
  late Animation<double> pulseAnimation;

  GridAnimationsHelper(this.vsync);

  void init({
    Duration floatDuration = const Duration(seconds: 3),
    Duration pulseDuration = const Duration(milliseconds: 1500),
    double floatRange = 4.0,
    double pulseMin = 1.0,
    double pulseMax = 1.08,
  }) {
    floatController = AnimationController(
      vsync: vsync,
      duration: floatDuration,
    )..repeat(reverse: true);

    pulseController = AnimationController(
      vsync: vsync,
      duration: pulseDuration,
    )..repeat(reverse: true);

    floatAnimation = Tween<double>(begin: -floatRange, end: floatRange).animate(
      CurvedAnimation(parent: floatController, curve: Curves.easeInOut),
    );

    pulseAnimation = Tween<double>(begin: pulseMin, end: pulseMax).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );
  }

  void dispose() {
    floatController.dispose();
    pulseController.dispose();
  }

  Widget buildAnimatedItem({
    required int index,
    required bool isSelected,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: floatController,
      builder: (_, floatChild) {
        final offset = (index % 2 == 0)
            ? floatAnimation.value
            : -floatAnimation.value;
        return Transform.translate(
          offset: Offset(0, offset),
          child: AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, pulseChild) {
              return Transform.scale(
                scale: isSelected ? pulseAnimation.value : 1.0,
                child: pulseChild,
              );
            },
            child: floatChild,
          ),
        );
      },
      child: child,
    );
  }
}
