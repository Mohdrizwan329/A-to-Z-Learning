import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'dart:math';
import 'package:jiyan_learning/services/tts_service.dart';

class FineMotorSkillsPage extends StatefulWidget {
  const FineMotorSkillsPage({super.key});

  @override
  State<FineMotorSkillsPage> createState() => _FineMotorSkillsPageState();
}

class _FineMotorSkillsPageState extends State<FineMotorSkillsPage> {
  int currentExercise = 0;
  List<Offset> drawnPoints = [];
  int score = 0;
  bool showResult = false;
  double accuracy = 0;

  final List<Map<String, dynamic>> exercises = [
    {
      'title': 'Trace the Line',
      'emoji': '➖',
      'type': 'line',
      'color': Color(0xFF4ECDC4),
      'path': [Offset(0.1, 0.5), Offset(0.9, 0.5)],
    },
    {
      'title': 'Trace the Zigzag',
      'emoji': '⚡',
      'type': 'zigzag',
      'color': Color(0xFFFF6B6B),
      'path': [
        Offset(0.1, 0.3),
        Offset(0.3, 0.7),
        Offset(0.5, 0.3),
        Offset(0.7, 0.7),
        Offset(0.9, 0.3),
      ],
    },
    {
      'title': 'Trace the Wave',
      'emoji': '🌊',
      'type': 'wave',
      'color': Color(0xFF667EEA),
      'path': [], // Generated dynamically
    },
    {
      'title': 'Trace the Circle',
      'emoji': '⭕',
      'type': 'circle',
      'color': Color(0xFFFFAA5A),
      'path': [], // Generated dynamically
    },
    {
      'title': 'Trace the Spiral',
      'emoji': '🌀',
      'type': 'spiral',
      'color': Color(0xFFA78BFA),
      'path': [], // Generated dynamically
    },
    {
      'title': 'Connect the Dots',
      'emoji': '🔴',
      'type': 'dots',
      'color': Color(0xFF56D97F),
      'path': [
        Offset(0.2, 0.2),
        Offset(0.8, 0.2),
        Offset(0.8, 0.8),
        Offset(0.2, 0.8),
        Offset(0.2, 0.2),
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _generateDynamicPaths();
  }

  void _generateDynamicPaths() {
    // Generate wave path
    List<Offset> wavePath = [];
    for (double x = 0.1; x <= 0.9; x += 0.05) {
      double y = 0.5 + 0.2 * sin((x - 0.1) * 4 * pi);
      wavePath.add(Offset(x, y));
    }
    exercises[2]['path'] = wavePath;

    // Generate circle path
    List<Offset> circlePath = [];
    for (double angle = 0; angle <= 2 * pi; angle += 0.2) {
      double x = 0.5 + 0.3 * cos(angle);
      double y = 0.5 + 0.3 * sin(angle);
      circlePath.add(Offset(x, y));
    }
    exercises[3]['path'] = circlePath;

    // Generate spiral path
    List<Offset> spiralPath = [];
    for (double angle = 0; angle <= 4 * pi; angle += 0.3) {
      double r = 0.05 + 0.06 * angle / pi;
      double x = 0.5 + r * cos(angle);
      double y = 0.5 + r * sin(angle);
      spiralPath.add(Offset(x, y));
    }
    exercises[4]['path'] = spiralPath;
  }

  void _onPanUpdate(DragUpdateDetails details, Size canvasSize) {
    if (showResult) return;
    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPos = box.globalToLocal(details.globalPosition);

    // Normalize to 0-1 range
    final normalizedX = (localPos.dx - 20) / (canvasSize.width - 40);
    final normalizedY = (localPos.dy - 20) / (canvasSize.height - 40);

    if (normalizedX >= 0 && normalizedX <= 1 && normalizedY >= 0 && normalizedY <= 1) {
      setState(() {
        drawnPoints.add(Offset(normalizedX, normalizedY));
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (drawnPoints.length < 10) return;
    _calculateAccuracy();
  }

  void _calculateAccuracy() {
    final path = exercises[currentExercise]['path'] as List<Offset>;
    if (path.isEmpty || drawnPoints.isEmpty) return;

    int matchedPoints = 0;

    for (var drawnPoint in drawnPoints) {
      double minDistance = double.infinity;
      for (var pathPoint in path) {
        double dist = (drawnPoint - pathPoint).distance;
        if (dist < minDistance) minDistance = dist;
      }
      if (minDistance < 0.1) matchedPoints++;
    }

    accuracy = (matchedPoints / drawnPoints.length * 100).clamp(0, 100);

    if (accuracy >= 70) {
      score += (accuracy ~/ 10) * 5;
    }

    setState(() => showResult = true);
  }

  void _nextExercise() {
    setState(() {
      if (currentExercise < exercises.length - 1) {
        currentExercise++;
      } else {
        currentExercise = 0;
      }
      drawnPoints.clear();
      showResult = false;
      accuracy = 0;
    });
    TtsService.to.speak(exercises[currentExercise]['title']);
  }

  void _resetExercise() {
    setState(() {
      drawnPoints.clear();
      showResult = false;
      accuracy = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final exercise = exercises[currentExercise];

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
        title: const Text("Fine Motor Skills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("⭐ $score", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
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
              const SizedBox(height: 16),
              // Exercise info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(exercise['emoji'], style: const TextStyle(fontSize: 40)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise['title'],
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF764BA2)),
                          ),
                          Text(
                            "Exercise ${currentExercise + 1} of ${exercises.length}",
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    if (showResult)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: accuracy >= 70 ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${accuracy.toInt()}%",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Canvas
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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GestureDetector(
                          onPanUpdate: (details) => _onPanUpdate(details, constraints.biggest),
                          onPanEnd: _onPanEnd,
                          child: CustomPaint(
                            size: constraints.biggest,
                            painter: MotorSkillsPainter(
                              path: exercise['path'] as List<Offset>,
                              pathColor: exercise['color'] as Color,
                              drawnPoints: drawnPoints,
                              exerciseType: exercise['type'] as String,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Instructions
              Text(
                showResult
                    ? (accuracy >= 70 ? "Great job! 🎉" : "Keep practicing! 💪")
                    : "Trace along the pattern with your finger",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _resetExercise,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Clear"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _nextExercise,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Next"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF56D97F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ],
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

class MotorSkillsPainter extends CustomPainter {
  final List<Offset> path;
  final Color pathColor;
  final List<Offset> drawnPoints;
  final String exerciseType;

  MotorSkillsPainter({
    required this.path,
    required this.pathColor,
    required this.drawnPoints,
    required this.exerciseType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final padding = 20.0;
    final drawSize = Size(size.width - padding * 2, size.height - padding * 2);

    // Draw guide path
    if (path.isNotEmpty) {
      final guidePaint = Paint()
        ..color = pathColor.withValues(alpha: 0.3)
        ..strokeWidth = 30
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final guidePath = Path();
      final firstPoint = Offset(
        padding + path[0].dx * drawSize.width,
        padding + path[0].dy * drawSize.height,
      );
      guidePath.moveTo(firstPoint.dx, firstPoint.dy);

      for (int i = 1; i < path.length; i++) {
        final point = Offset(
          padding + path[i].dx * drawSize.width,
          padding + path[i].dy * drawSize.height,
        );
        guidePath.lineTo(point.dx, point.dy);
      }

      canvas.drawPath(guidePath, guidePaint);

      // Draw dots for 'dots' exercise
      if (exerciseType == 'dots') {
        for (var point in path) {
          final pos = Offset(
            padding + point.dx * drawSize.width,
            padding + point.dy * drawSize.height,
          );
          canvas.drawCircle(pos, 15, Paint()..color = pathColor);
          canvas.drawCircle(pos, 10, Paint()..color = Colors.white);
        }
      }

      // Draw start indicator
      canvas.drawCircle(firstPoint, 12, Paint()..color = Colors.green);
      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'S',
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(firstPoint.dx - 4, firstPoint.dy - 6));
    }

    // Draw user's path
    if (drawnPoints.isNotEmpty) {
      final userPaint = Paint()
        ..color = Color(0xFF764BA2)
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final userPath = Path();
      final firstDrawn = Offset(
        padding + drawnPoints[0].dx * drawSize.width,
        padding + drawnPoints[0].dy * drawSize.height,
      );
      userPath.moveTo(firstDrawn.dx, firstDrawn.dy);

      for (int i = 1; i < drawnPoints.length; i++) {
        final point = Offset(
          padding + drawnPoints[i].dx * drawSize.width,
          padding + drawnPoints[i].dy * drawSize.height,
        );
        userPath.lineTo(point.dx, point.dy);
      }

      canvas.drawPath(userPath, userPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MotorSkillsPainter oldDelegate) => true;
}
