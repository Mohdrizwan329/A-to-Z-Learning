import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mascotController;
  late AnimationController _floatController;
  late AnimationController _fadeController;
  late Animation<double> _mascotScale;
  late Animation<double> _floatAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _titleSlide;

  // Floating shapes
  final List<FloatingShape> _shapes = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initShapes();
    _setupAnimations();
    _navigateToAgeSelection();
  }

  void _initShapes() {
    final colors = [
      AppTheme.primaryColor.withValues(alpha: 0.3),
      AppTheme.secondaryColor.withValues(alpha: 0.3),
      AppTheme.accentColor.withValues(alpha: 0.3),
      const Color(0xFFA78BFA).withValues(alpha: 0.3),
      const Color(0xFFFF6B6B).withValues(alpha: 0.3),
    ];

    for (int i = 0; i < 15; i++) {
      _shapes.add(
        FloatingShape(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: 20 + _random.nextDouble() * 40,
          color: colors[_random.nextInt(colors.length)],
          speed: 0.5 + _random.nextDouble() * 1.5,
          shape: ShapeType.values[_random.nextInt(ShapeType.values.length)],
        ),
      );
    }
  }

  void _setupAnimations() {
    // Mascot bounce animation
    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _mascotScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mascotController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Floating animation for mascot
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Fade and slide animation for text
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _titleSlide = Tween<double>(
      begin: 30,
      end: 0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // Start animations
    _mascotController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _mascotController.dispose();
    _floatController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _navigateToAgeSelection() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed('/age-selection');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppTheme.screenBackground,
        child: Stack(
          children: [
            // Floating shapes background
            ..._buildFloatingShapes(),
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Mascot
                  _buildMascot(),
                  SizedBox(height: AppTheme.spacingXL),
                  // App Name
                  _buildAppName(),
                  SizedBox(height: AppTheme.spacingS),
                  // Tagline
                  _buildTagline(),
                ],
              ),
            ),
            // Loading indicator at bottom
            Positioned(
              bottom: 60.h,
              left: 0,
              right: 0,
              child: _buildLoadingIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingShapes() {
    return _shapes.map((shape) {
      return AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          final offset =
              sin(_floatController.value * pi * 2 + shape.x * 10) * 20;
          return Positioned(
            left: shape.x * MediaQuery.of(context).size.width,
            top: shape.y * MediaQuery.of(context).size.height + offset,
            child: _buildShape(shape),
          );
        },
      );
    }).toList();
  }

  Widget _buildShape(FloatingShape shape) {
    switch (shape.shape) {
      case ShapeType.circle:
        return Container(
          width: shape.size,
          height: shape.size,
          decoration: BoxDecoration(color: shape.color, shape: BoxShape.circle),
        );
      case ShapeType.square:
        return Transform.rotate(
          angle: 0.5,
          child: Container(
            width: shape.size,
            height: shape.size,
            decoration: BoxDecoration(
              color: shape.color,
              borderRadius: BorderRadius.circular(shape.size * 0.2),
            ),
          ),
        );
      case ShapeType.triangle:
        return CustomPaint(
          size: Size(shape.size, shape.size),
          painter: TrianglePainter(color: shape.color),
        );
      case ShapeType.star:
        return Icon(Icons.star_rounded, size: shape.size, color: shape.color);
    }
  }

  Widget _buildMascot() {
    return AnimatedBuilder(
      animation: _mascotController,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: Transform.scale(
                scale: _mascotScale.value,
                child: Container(
                  width: 180.w,
                  height: 180.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.secondaryColor,
                        AppTheme.secondaryColor.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.secondaryColor.withValues(alpha: 0.4),
                        blurRadius: 30.r,
                        spreadRadius: 5.r,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Cute animal mascot (using emoji for now)
                      const Text('🦁', style: TextStyle(fontSize: 90)),
                      // Sparkles around mascot
                      Positioned(
                        top: 10.h,
                        right: 20.w,
                        child: _buildSparkle(),
                      ),
                      Positioned(
                        bottom: 20.h,
                        left: 15.w,
                        child: _buildSparkle(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSparkle() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: value,
            child: Icon(Icons.auto_awesome, color: Colors.white, size: 24.r),
          ),
        );
      },
    );
  }

  Widget _buildAppName() {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _titleSlide.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Text(
              'Jiyan Learning',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    offset: const Offset(2, 2),
                    blurRadius: 4.r,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagline() {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Text(
            'Learn, Play & Grow! 🌟',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Column(
            children: [
              SizedBox(
                width: 100.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    minHeight: 6.h,
                  ),
                ),
              ),
              SizedBox(height: AppTheme.spacingS),
              Text(
                'Loading fun...',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Floating shape model
enum ShapeType { circle, square, triangle, star }

class FloatingShape {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double speed;
  final ShapeType shape;

  FloatingShape({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    required this.shape,
  });
}

// Triangle painter
class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Animated builder helper
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
