import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';
import 'package:jiyan_learning/services/tts_service.dart';

class WritingAccuracyPage extends StatefulWidget {
  const WritingAccuracyPage({super.key});

  @override
  State<WritingAccuracyPage> createState() => _WritingAccuracyPageState();
}

class _WritingAccuracyPageState extends State<WritingAccuracyPage> {
  final FlutterTts flutterTts = FlutterTts();
  int currentIndex = 0;
  List<Offset?> userPoints = [];
  int score = 0;
  bool showResult = false;
  double accuracy = 0;
  int attempts = 0;

  final List<Map<String, dynamic>> challenges = [
    {'char': 'O', 'type': 'circle', 'description': 'Draw a circle'},
    {'char': 'L', 'type': 'angle', 'description': 'Draw an L shape'},
    {'char': 'V', 'type': 'v_shape', 'description': 'Draw a V shape'},
    {'char': 'T', 'type': 't_shape', 'description': 'Draw a T shape'},
    {'char': 'X', 'type': 'cross', 'description': 'Draw an X shape'},
    {'char': 'S', 'type': 's_curve', 'description': 'Draw an S curve'},
    {'char': '1', 'type': 'line', 'description': 'Draw a straight line'},
    {'char': '8', 'type': 'eight', 'description': 'Draw a figure 8'},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _calculateAccuracy() {
    if (userPoints.length < 10) {
      setState(() {
        accuracy = 0;
        showResult = true;
      });
      flutterTts.speak("Please draw more!");
      return;
    }

    final type = challenges[currentIndex]['type'] as String;
    double calculatedAccuracy = 0;

    switch (type) {
      case 'circle':
        calculatedAccuracy = _evaluateCircle();
        break;
      case 'line':
        calculatedAccuracy = _evaluateLine();
        break;
      case 'angle':
        calculatedAccuracy = _evaluateAngle();
        break;
      case 'v_shape':
        calculatedAccuracy = _evaluateVShape();
        break;
      case 't_shape':
        calculatedAccuracy = _evaluateTShape();
        break;
      case 'cross':
        calculatedAccuracy = _evaluateCross();
        break;
      default:
        calculatedAccuracy = _evaluateGeneric();
    }

    accuracy = calculatedAccuracy.clamp(0, 100);
    attempts++;

    if (accuracy >= 70) {
      score += (accuracy ~/ 10) * 5;
      flutterTts.speak("Great! ${accuracy.toInt()} percent accuracy!");
    } else if (accuracy >= 50) {
      flutterTts.speak("Good try! ${accuracy.toInt()} percent.");
    } else {
      flutterTts.speak("Keep practicing!");
    }

    setState(() => showResult = true);
  }

  double _evaluateCircle() {
    final validPoints = userPoints.whereType<Offset>().toList();
    if (validPoints.isEmpty) return 0;

    // Find center and average radius
    double sumX = 0, sumY = 0;
    for (var p in validPoints) {
      sumX += p.dx;
      sumY += p.dy;
    }
    final center = Offset(sumX / validPoints.length, sumY / validPoints.length);

    double avgRadius = 0;
    for (var p in validPoints) {
      avgRadius += (p - center).distance;
    }
    avgRadius /= validPoints.length;

    // Check variance from average radius
    double variance = 0;
    for (var p in validPoints) {
      double diff = ((p - center).distance - avgRadius).abs();
      variance += diff;
    }
    variance /= validPoints.length;

    // Check if closed (first and last points near each other)
    double closedness = (validPoints.first - validPoints.last).distance;
    double closeBonus = closedness < avgRadius * 0.3 ? 15 : 0;

    double accuracyScore = 100 - (variance / avgRadius * 100) + closeBonus;
    return accuracyScore;
  }

  double _evaluateLine() {
    final validPoints = userPoints.whereType<Offset>().toList();
    if (validPoints.length < 2) return 0;

    final start = validPoints.first;
    final end = validPoints.last;
    final lineLength = (end - start).distance;

    if (lineLength < 50) return 30; // Too short

    // Check straightness
    double totalDeviation = 0;
    for (var p in validPoints) {
      double deviation = _pointToLineDistance(p, start, end);
      totalDeviation += deviation;
    }
    double avgDeviation = totalDeviation / validPoints.length;

    double accuracyScore = 100 - (avgDeviation / lineLength * 200);
    return accuracyScore;
  }

  double _evaluateAngle() {
    final validPoints = userPoints.whereType<Offset>().toList();
    if (validPoints.length < 3) return 0;

    // Find the corner point (lowest y with smallest x for L shape)
    Offset? corner;
    double maxY = 0;
    for (var p in validPoints) {
      if (p.dy > maxY) {
        maxY = p.dy;
        corner = p;
      }
    }

    if (corner == null) return 50;

    // Check for two roughly perpendicular segments
    int verticalPoints = 0;
    int horizontalPoints = 0;

    for (var p in validPoints) {
      if ((p.dx - corner.dx).abs() < 30) verticalPoints++;
      if ((p.dy - corner.dy).abs() < 30) horizontalPoints++;
    }

    double ratio = min(verticalPoints, horizontalPoints) / max(verticalPoints, horizontalPoints);
    return 50 + ratio * 50;
  }

  double _evaluateVShape() {
    final validPoints = userPoints.whereType<Offset>().toList();
    if (validPoints.length < 3) return 0;

    // Find the bottom point
    Offset? bottom;
    double maxY = 0;
    for (var p in validPoints) {
      if (p.dy > maxY) {
        maxY = p.dy;
        bottom = p;
      }
    }

    if (bottom == null) return 50;

    // Check symmetry around bottom point
    int leftPoints = validPoints.where((p) => p.dx < bottom!.dx).length;
    int rightPoints = validPoints.where((p) => p.dx > bottom!.dx).length;

    double symmetry = min(leftPoints, rightPoints) / max(leftPoints, rightPoints);
    return 40 + symmetry * 60;
  }

  double _evaluateTShape() {
    final validPoints = userPoints.whereType<Offset>().toList();
    if (validPoints.length < 5) return 0;

    // Check for horizontal top and vertical stem
    double minY = double.infinity;
    for (var p in validPoints) {
      if (p.dy < minY) minY = p.dy;
    }

    int topPoints = validPoints.where((p) => (p.dy - minY).abs() < 40).length;
    int totalPoints = validPoints.length;

    double topRatio = topPoints / totalPoints;
    return (topRatio > 0.2 && topRatio < 0.6) ? 70 + topRatio * 30 : 50;
  }

  double _evaluateCross() {
    final validPoints = userPoints.whereType<Offset>().toList();
    if (validPoints.length < 4) return 0;

    // Find bounding box
    double minX = double.infinity, maxX = 0, minY = double.infinity, maxY = 0;
    for (var p in validPoints) {
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }

    double width = maxX - minX;
    double height = maxY - minY;

    // Good X should be roughly square
    double aspectRatio = min(width, height) / max(width, height);
    return 50 + aspectRatio * 50;
  }

  double _evaluateGeneric() {
    return userPoints.length > 20 ? 60 : 40;
  }

  double _pointToLineDistance(Offset point, Offset lineStart, Offset lineEnd) {
    double A = point.dx - lineStart.dx;
    double B = point.dy - lineStart.dy;
    double C = lineEnd.dx - lineStart.dx;
    double D = lineEnd.dy - lineStart.dy;

    double dot = A * C + B * D;
    double lenSq = C * C + D * D;
    double param = lenSq != 0 ? dot / lenSq : -1;

    double xx, yy;

    if (param < 0) {
      xx = lineStart.dx;
      yy = lineStart.dy;
    } else if (param > 1) {
      xx = lineEnd.dx;
      yy = lineEnd.dy;
    } else {
      xx = lineStart.dx + param * C;
      yy = lineStart.dy + param * D;
    }

    double dx = point.dx - xx;
    double dy = point.dy - yy;
    return sqrt(dx * dx + dy * dy);
  }

  void _nextChallenge() {
    setState(() {
      if (currentIndex < challenges.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      userPoints.clear();
      showResult = false;
      accuracy = 0;
    });
    TtsService.to.speak(challenges[currentIndex]['description']);
  }

  void _clearCanvas() {
    setState(() {
      userPoints.clear();
      showResult = false;
      accuracy = 0;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challenge = challenges[currentIndex];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text("Writing Accuracy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
              // Challenge info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFF3E5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          challenge['char'],
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF764BA2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge['description'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF764BA2),
                            ),
                          ),
                          Text(
                            "Challenge ${currentIndex + 1} of ${challenges.length}",
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    if (showResult)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: accuracy >= 70
                                ? [Colors.green, Colors.green.shade700]
                                : accuracy >= 50
                                    ? [Colors.orange, Colors.orange.shade700]
                                    : [Colors.red, Colors.red.shade700],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${accuracy.toInt()}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              accuracy >= 70 ? "Great!" : accuracy >= 50 ? "Good" : "Try Again",
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ],
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
                    child: Stack(
                      children: [
                        // Guide character (faded)
                        Center(
                          child: Text(
                            challenge['char'],
                            style: TextStyle(
                              fontSize: 280,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        // Drawing canvas
                        GestureDetector(
                          onPanUpdate: showResult
                              ? null
                              : (details) {
                                  setState(() {
                                    RenderBox box = context.findRenderObject() as RenderBox;
                                    userPoints.add(box.globalToLocal(details.globalPosition));
                                  });
                                },
                          onPanEnd: showResult
                              ? null
                              : (details) {
                                  setState(() => userPoints.add(null));
                                },
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: AccuracyDrawingPainter(
                              points: userPoints,
                              isCorrect: showResult && accuracy >= 70,
                              showResult: showResult,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Stats
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat("Attempts", "$attempts"),
                    _buildStat("Points", "${userPoints.whereType<Offset>().length}"),
                    _buildStat("Best", "${accuracy.toInt()}%"),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _clearCanvas,
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: showResult ? null : _calculateAccuracy,
                        icon: const Icon(Icons.check),
                        label: const Text("Check"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF667EEA),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _nextChallenge,
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
      ],
    );
  }
}

class AccuracyDrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final bool isCorrect;
  final bool showResult;

  AccuracyDrawingPainter({
    required this.points,
    required this.isCorrect,
    required this.showResult,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = showResult ? (isCorrect ? Colors.green : Colors.orange) : Color(0xFF764BA2)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant AccuracyDrawingPainter oldDelegate) => true;
}
