import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class StrokeOrderPage extends StatefulWidget {
  const StrokeOrderPage({super.key});

  @override
  State<StrokeOrderPage> createState() => _StrokeOrderPageState();
}

class _StrokeOrderPageState extends State<StrokeOrderPage> with TickerProviderStateMixin {
  int currentIndex = 0;
  int currentStroke = 0;
  bool isAnimating = false;
  bool showAllStrokes = false;
  late AnimationController _animationController;
  late Animation<double> _strokeAnimation;

  final List<Map<String, dynamic>> characters = [
    {
      'char': 'A',
      'strokes': [
        {'start': Offset(0.5, 1.0), 'end': Offset(0.2, 0.0), 'description': 'Left diagonal up'},
        {'start': Offset(0.5, 1.0), 'end': Offset(0.8, 0.0), 'description': 'Right diagonal up'},
        {'start': Offset(0.35, 0.5), 'end': Offset(0.65, 0.5), 'description': 'Horizontal bar'},
      ],
    },
    {
      'char': 'B',
      'strokes': [
        {'start': Offset(0.3, 0.0), 'end': Offset(0.3, 1.0), 'description': 'Vertical line down'},
        {'start': Offset(0.3, 0.0), 'end': Offset(0.6, 0.0), 'description': 'Top horizontal'},
        {'start': Offset(0.6, 0.0), 'end': Offset(0.7, 0.25), 'description': 'Top right curve'},
        {'start': Offset(0.7, 0.25), 'end': Offset(0.3, 0.5), 'description': 'Middle curve'},
        {'start': Offset(0.3, 0.5), 'end': Offset(0.7, 0.75), 'description': 'Bottom curve out'},
        {'start': Offset(0.7, 0.75), 'end': Offset(0.3, 1.0), 'description': 'Bottom curve in'},
      ],
    },
    {
      'char': 'C',
      'strokes': [
        {'start': Offset(0.7, 0.2), 'end': Offset(0.3, 0.5), 'description': 'Top curve'},
        {'start': Offset(0.3, 0.5), 'end': Offset(0.7, 0.8), 'description': 'Bottom curve'},
      ],
    },
    {
      'char': 'D',
      'strokes': [
        {'start': Offset(0.3, 0.0), 'end': Offset(0.3, 1.0), 'description': 'Vertical line down'},
        {'start': Offset(0.3, 0.0), 'end': Offset(0.7, 0.5), 'description': 'Curve out'},
        {'start': Offset(0.7, 0.5), 'end': Offset(0.3, 1.0), 'description': 'Curve in'},
      ],
    },
    {
      'char': 'E',
      'strokes': [
        {'start': Offset(0.3, 0.0), 'end': Offset(0.3, 1.0), 'description': 'Vertical line down'},
        {'start': Offset(0.3, 0.0), 'end': Offset(0.7, 0.0), 'description': 'Top horizontal'},
        {'start': Offset(0.3, 0.5), 'end': Offset(0.6, 0.5), 'description': 'Middle horizontal'},
        {'start': Offset(0.3, 1.0), 'end': Offset(0.7, 1.0), 'description': 'Bottom horizontal'},
      ],
    },
    {
      'char': '1',
      'strokes': [
        {'start': Offset(0.4, 0.2), 'end': Offset(0.5, 0.0), 'description': 'Small diagonal'},
        {'start': Offset(0.5, 0.0), 'end': Offset(0.5, 1.0), 'description': 'Vertical line down'},
        {'start': Offset(0.3, 1.0), 'end': Offset(0.7, 1.0), 'description': 'Bottom line'},
      ],
    },
    {
      'char': '2',
      'strokes': [
        {'start': Offset(0.25, 0.2), 'end': Offset(0.5, 0.0), 'description': 'Top curve start'},
        {'start': Offset(0.5, 0.0), 'end': Offset(0.75, 0.3), 'description': 'Top curve end'},
        {'start': Offset(0.75, 0.3), 'end': Offset(0.25, 1.0), 'description': 'Diagonal down'},
        {'start': Offset(0.25, 1.0), 'end': Offset(0.75, 1.0), 'description': 'Bottom line'},
      ],
    },
    {
      'char': '3',
      'strokes': [
        {'start': Offset(0.25, 0.0), 'end': Offset(0.7, 0.0), 'description': 'Top line'},
        {'start': Offset(0.7, 0.0), 'end': Offset(0.4, 0.5), 'description': 'Upper diagonal'},
        {'start': Offset(0.4, 0.5), 'end': Offset(0.7, 0.75), 'description': 'Middle curve'},
        {'start': Offset(0.7, 0.75), 'end': Offset(0.25, 1.0), 'description': 'Bottom curve'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _strokeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _playStrokeAnimation() async {
    final strokes = characters[currentIndex]['strokes'] as List;
    setState(() {
      isAnimating = true;
      currentStroke = 0;
      showAllStrokes = false;
    });

    for (int i = 0; i < strokes.length; i++) {
      if (!mounted) return;
      setState(() => currentStroke = i);
      _animationController.reset();
      await _animationController.forward();
      await Future.delayed(const Duration(milliseconds: 300));
    }

    if (!mounted) return;
    setState(() {
      isAnimating = false;
      showAllStrokes = true;
    });
  }

  void _nextCharacter() {
    setState(() {
      if (currentIndex < characters.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      currentStroke = 0;
      showAllStrokes = false;
    });
  }

  void _previousCharacter() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      } else {
        currentIndex = characters.length - 1;
      }
      currentStroke = 0;
      showAllStrokes = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentChar = characters[currentIndex];
    final strokes = currentChar['strokes'] as List;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text("Stroke Order", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Character selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _previousCharacter,
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        currentChar['char'],
                        style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Color(0xFF764BA2)),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _nextCharacter,
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "${currentIndex + 1} of ${characters.length}",
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
              ),
              const SizedBox(height: 20),
              // Stroke canvas
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // Guide lines
                        CustomPaint(
                          size: Size.infinite,
                          painter: GuideLinesPainter(),
                        ),
                        // Faded character
                        Center(
                          child: Text(
                            currentChar['char'],
                            style: TextStyle(
                              fontSize: 200,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.withValues(alpha: 0.15),
                            ),
                          ),
                        ),
                        // Animated strokes
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return CustomPaint(
                              size: Size.infinite,
                              painter: StrokePainter(
                                strokes: strokes,
                                currentStroke: currentStroke,
                                progress: _strokeAnimation.value,
                                showAllStrokes: showAllStrokes,
                                isAnimating: isAnimating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Stroke info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      "Strokes: ${strokes.length}",
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (isAnimating && currentStroke < strokes.length)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Step ${currentStroke + 1}: ${strokes[currentStroke]['description']}",
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Play button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  onPressed: isAnimating ? null : _playStrokeAnimation,
                  icon: Icon(isAnimating ? Icons.hourglass_top : Icons.play_arrow, size: 28),
                  label: Text(
                    isAnimating ? "Playing..." : "Show Stroke Order",
                    style: const TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF56D97F),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }
}

class GuideLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Horizontal guide lines
    canvas.drawLine(Offset(0, size.height * 0.25), Offset(size.width, size.height * 0.25), paint);
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), paint);
    canvas.drawLine(Offset(0, size.height * 0.75), Offset(size.width, size.height * 0.75), paint);

    // Vertical center line
    paint.color = Colors.red.withValues(alpha: 0.1);
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StrokePainter extends CustomPainter {
  final List strokes;
  final int currentStroke;
  final double progress;
  final bool showAllStrokes;
  final bool isAnimating;

  StrokePainter({
    required this.strokes,
    required this.currentStroke,
    required this.progress,
    required this.showAllStrokes,
    required this.isAnimating,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final padding = 40.0;
    final drawSize = Size(size.width - padding * 2, size.height - padding * 2);

    for (int i = 0; i < strokes.length; i++) {
      final stroke = strokes[i];
      final start = Offset(
        padding + stroke['start'].dx * drawSize.width,
        padding + stroke['start'].dy * drawSize.height,
      );
      final end = Offset(
        padding + stroke['end'].dx * drawSize.width,
        padding + stroke['end'].dy * drawSize.height,
      );

      if (showAllStrokes || (isAnimating && i < currentStroke)) {
        // Completed strokes
        final paint = Paint()
          ..color = Color(0xFF764BA2)
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(start, end, paint);

        // Stroke number
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${i + 1}',
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        final numberPos = Offset(start.dx - 8, start.dy - 8);
        canvas.drawCircle(numberPos, 12, Paint()..color = Color(0xFF56D97F));
        textPainter.paint(canvas, Offset(numberPos.dx - 4, numberPos.dy - 7));
      } else if (isAnimating && i == currentStroke) {
        // Current animating stroke
        final currentEnd = Offset(
          start.dx + (end.dx - start.dx) * progress,
          start.dy + (end.dy - start.dy) * progress,
        );

        final paint = Paint()
          ..color = Color(0xFFFF6B6B)
          ..strokeWidth = 14
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(start, currentEnd, paint);

        // Arrow head
        if (progress > 0.1) {
          canvas.drawCircle(currentEnd, 10, Paint()..color = Color(0xFFFF6B6B));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant StrokePainter oldDelegate) => true;
}
