import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _orbitController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotate;
  late Animation<double> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<double> _taglineFade;
  late Animation<double> _bottomFade;
  late Animation<double> _bottomSlide;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Logo appears with scale + slight rotate
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
      ),
    );
    _logoRotate = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // Title slides up
    _titleSlide = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.55, curve: Curves.easeOut),
      ),
    );

    // Tagline
    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.7, curve: Curves.easeOut),
      ),
    );

    // Bottom content
    _bottomFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.6, 0.85, curve: Curves.easeOut),
      ),
    );
    _bottomSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.6, 0.85, curve: Curves.easeOut),
      ),
    );

    _mainController.forward();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed('/home');
  }

  @override
  void dispose() {
    _mainController.dispose();
    _orbitController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            AnimatedBuilder(
              animation: _orbitController,
              builder: (context, _) {
                return CustomPaint(
                  size: size,
                  painter: _ParticlePainter(
                    progress: _orbitController.value,
                  ),
                );
              },
            ),

            // Colorful orbiting circles around logo
            AnimatedBuilder(
              animation: _orbitController,
              builder: (context, _) {
                return CustomPaint(
                  size: size,
                  painter: _OrbitPainter(
                    progress: _orbitController.value,
                    center: Offset(size.width / 2, size.height * 0.38),
                  ),
                );
              },
            ),

            // Top decorative colored shapes
            _buildTopDecor(size),

            // Bottom wave decoration
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: Size(size.width, 120),
                painter: _WavePainter(),
              ),
            ),

            // Main content
            SafeArea(
              child: AnimatedBuilder(
                animation: Listenable.merge([_mainController, _pulseController]),
                builder: (context, _) {
                  return Column(
                    children: [
                      SizedBox(height: size.height * 0.08),

                      // Logo with glow
                      Transform.scale(
                        scale: _logoScale.value.clamp(0.0, 1.05),
                        child: Transform.rotate(
                          angle: _logoRotate.value,
                          child: _buildLogo(),
                        ),
                      ),

                      SizedBox(height: size.height * 0.04),

                      // Title
                      Opacity(
                        opacity: _titleFade.value,
                        child: Transform.translate(
                          offset: Offset(0, _titleSlide.value),
                          child: _buildTitle(),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Tagline
                      Opacity(
                        opacity: _taglineFade.value,
                        child: _buildTagline(),
                      ),

                      const Spacer(),

                      // Feature icons row
                      Opacity(
                        opacity: _bottomFade.value,
                        child: Transform.translate(
                          offset: Offset(0, _bottomSlide.value),
                          child: _buildFeatureRow(),
                        ),
                      ),

                      SizedBox(height: size.height * 0.04),

                      // Loader
                      Opacity(
                        opacity: _bottomFade.value,
                        child: _buildLoader(),
                      ),

                      SizedBox(height: size.height * 0.05),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopDecor(Size size) {
    return Stack(
      children: [
        Positioned(
          top: -30,
          left: -20,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00B894).withValues(alpha: 0.15),
            ),
          ),
        ),
        Positioned(
          top: -10,
          right: -30,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFD93D).withValues(alpha: 0.12),
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.15,
          right: 20,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF6B6B).withValues(alpha: 0.15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00B894).withValues(
                  alpha: 0.15 + 0.1 * _pulseController.value,
                ),
                blurRadius: 40 + 15 * _pulseController.value,
                spreadRadius: 10 + 5 * _pulseController.value,
              ),
              BoxShadow(
                color: const Color(0xFF0984E3).withValues(
                  alpha: 0.1 + 0.08 * _pulseController.value,
                ),
                blurRadius: 60 + 20 * _pulseController.value,
                spreadRadius: 15 + 8 * _pulseController.value,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipOval(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Image.asset(
              'assets/Splash Screen.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.school_rounded,
                size: 80,
                color: Color(0xFF2C5364),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: const [
                    Colors.white,
                    Color(0xFFFFD93D),
                    Colors.white,
                  ],
                  stops: [
                    (_shimmerController.value - 0.3).clamp(0.0, 1.0),
                    _shimmerController.value,
                    (_shimmerController.value + 0.3).clamp(0.0, 1.0),
                  ],
                ).createShader(bounds);
              },
              child: child!,
            );
          },
          child: const Text(
            'JIYAN',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 8,
              height: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00B894), Color(0xFF0984E3)],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Text(
            'LEARNING APPLICATION',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagline() {
    return Text(
      'Learn  ·  Play  ·  Grow',
      style: TextStyle(
        fontSize: 15,
        color: Colors.white.withValues(alpha: 0.6),
        fontWeight: FontWeight.w400,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildFeatureRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _FeatureIcon(
          icon: Icons.auto_stories_rounded,
          label: 'Study',
          color: const Color(0xFF0984E3),
        ),
        const SizedBox(width: 20),
        _FeatureIcon(
          icon: Icons.sports_esports_rounded,
          label: 'Play',
          color: const Color(0xFF00B894),
        ),
        const SizedBox(width: 20),
        _FeatureIcon(
          icon: Icons.brush_rounded,
          label: 'Create',
          color: const Color(0xFFFF9F43),
        ),
        const SizedBox(width: 20),
        _FeatureIcon(
          icon: Icons.people_alt_rounded,
          label: 'Share',
          color: const Color(0xFFFF6B6B),
        ),
      ],
    );
  }

  Widget _buildLoader() {
    return Column(
      children: [
        SizedBox(
          width: 120,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 3,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF00B894),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Loading...',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.4),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FeatureIcon({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Orbiting colorful dots around the logo
class _OrbitPainter extends CustomPainter {
  final double progress;
  final Offset center;

  _OrbitPainter({required this.progress, required this.center});

  @override
  void paint(Canvas canvas, Size size) {
    final orbitItems = [
      _OrbitItem(90, const Color(0xFF00B894), 6),
      _OrbitItem(90, const Color(0xFFFF6B6B), 5),
      _OrbitItem(90, const Color(0xFFFFD93D), 4.5),
      _OrbitItem(90, const Color(0xFF0984E3), 5.5),
      _OrbitItem(90, const Color(0xFFa29bfe), 4),
      _OrbitItem(90, const Color(0xFFFF9F43), 5),
    ];

    for (int i = 0; i < orbitItems.length; i++) {
      final item = orbitItems[i];
      final angle = progress * 2 * pi + (i * 2 * pi / orbitItems.length);
      final radius = item.orbitRadius + sin(progress * 4 * pi + i) * 8;

      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle) * 0.5; // Elliptical orbit

      final paint = Paint()
        ..color = item.color.withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(Offset(x, y), item.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _OrbitItem {
  final double orbitRadius;
  final Color color;
  final double size;
  const _OrbitItem(this.orbitRadius, this.color, this.size);
}

// Background particles
class _ParticlePainter extends CustomPainter {
  final double progress;

  _ParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42); // Fixed seed for consistent positions

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final r = random.nextDouble() * 2 + 0.5;
      final speed = random.nextDouble() * 0.5 + 0.5;

      final y = (baseY + progress * size.height * speed * 0.3) % size.height;
      final opacity = (sin(progress * 2 * pi + i) * 0.3 + 0.3).clamp(0.05, 0.5);

      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()..color = Colors.white.withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// Bottom wave
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.6)
      ..quadraticBezierTo(
          size.width * 0.25, size.height * 0.35,
          size.width * 0.5, size.height * 0.55)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.75,
          size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFF00B894),
            Color(0xFF0984E3),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill,
    );

    // Second subtle wave on top
    final path2 = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(
          size.width * 0.3, size.height * 0.5,
          size.width * 0.6, size.height * 0.7)
      ..quadraticBezierTo(
          size.width * 0.85, size.height * 0.85,
          size.width, size.height * 0.65)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      path2,
      Paint()..color = const Color(0xFF0984E3).withValues(alpha: 0.3),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
