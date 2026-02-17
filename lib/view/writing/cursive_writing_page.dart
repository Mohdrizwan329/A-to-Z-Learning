import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class CursiveWritingPage extends StatefulWidget {
  const CursiveWritingPage({super.key});

  @override
  State<CursiveWritingPage> createState() => _CursiveWritingPageState();
}

class _CursiveWritingPageState extends State<CursiveWritingPage> {
  final FlutterTts flutterTts = FlutterTts();
  int currentIndex = 0;
  bool isCapital = true;
  List<Offset?> points = [];
  Color penColor = Color(0xFF764BA2);
  double penWidth = 4.0;
  bool showGuide = true;

  final List<String> capitalLetters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'V', 'W', 'X', 'Y', 'Z'
  ];

  final List<String> smallLetters = [
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
    'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
    'u', 'v', 'w', 'x', 'y', 'z'
  ];

  final List<Color> penColors = [
    Color(0xFF764BA2),
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFFFF5722),
    Color(0xFF9C27B0),
    Color(0xFF000000),
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

  void _speakLetter() {
    final letter = isCapital ? capitalLetters[currentIndex] : smallLetters[currentIndex];
    flutterTts.speak("Cursive ${isCapital ? 'capital' : 'small'} $letter");
  }

  void _nextLetter() {
    setState(() {
      if (currentIndex < 25) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      points.clear();
    });
    _speakLetter();
  }

  void _previousLetter() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      } else {
        currentIndex = 25;
      }
      points.clear();
    });
    _speakLetter();
  }

  void _clearCanvas() {
    setState(() => points.clear());
  }

  void _toggleCase() {
    setState(() {
      isCapital = !isCapital;
      points.clear();
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLetter = isCapital ? capitalLetters[currentIndex] : smallLetters[currentIndex];

    return GradientScaffold(
      title: 'Cursive Writing',
      emoji: '✒️',
      bottomNavigationBar: const AdsScreen(),
      body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Case toggle and letter selector
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    // Case toggle
                    GestureDetector(
                      onTap: _toggleCase,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isCapital
                                ? [Color(0xFF667EEA), Color(0xFF764BA2)]
                                : [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isCapital ? "ABC" : "abc",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Letter navigation
                    IconButton(
                      onPressed: _previousLetter,
                      icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF764BA2)),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFF3E5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          currentLetter,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cursive',
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF764BA2),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _nextLetter,
                      icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF764BA2)),
                    ),
                    const Spacer(),
                    // Speak button
                    IconButton(
                      onPressed: _speakLetter,
                      icon: const Icon(Icons.volume_up, color: Color(0xFF764BA2), size: 28),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Canvas
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
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
                        // Guide lines (notebook style)
                        CustomPaint(
                          size: Size.infinite,
                          painter: NotebookLinesPainter(),
                        ),
                        // Guide letter (faded cursive)
                        if (showGuide)
                          Center(
                            child: Text(
                              currentLetter,
                              style: TextStyle(
                                fontSize: 250,
                                fontFamily: 'Cursive',
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
                                color: Colors.purple.withValues(alpha: 0.12),
                              ),
                            ),
                          ),
                        // Drawing canvas
                        GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              RenderBox box = context.findRenderObject() as RenderBox;
                              points.add(box.globalToLocal(details.globalPosition));
                            });
                          },
                          onPanEnd: (details) {
                            setState(() => points.add(null));
                          },
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: CursiveDrawingPainter(
                              points: points,
                              color: penColor,
                              strokeWidth: penWidth,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Tools
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Color picker
                    ...penColors.map((color) => GestureDetector(
                          onTap: () => setState(() => penColor = color),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: penColor == color
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                            ),
                          ),
                        )),
                    const SizedBox(width: 16),
                    // Toggle guide
                    IconButton(
                      onPressed: () => setState(() => showGuide = !showGuide),
                      icon: Icon(
                        showGuide ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _nextLetter,
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
    );
  }
}

class NotebookLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.15)
      ..strokeWidth = 1;

    // Horizontal lines (notebook style)
    double lineSpacing = 40;
    for (double y = lineSpacing; y < size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Red margin line
    paint.color = Colors.red.withValues(alpha: 0.2);
    paint.strokeWidth = 2;
    canvas.drawLine(Offset(50, 0), Offset(50, size.height), paint);

    // Center dashed line (for cursive baseline)
    paint.color = Colors.grey.withValues(alpha: 0.3);
    paint.strokeWidth = 1;
    double centerY = size.height * 0.6;
    for (double x = 0; x < size.width; x += 15) {
      canvas.drawLine(Offset(x, centerY), Offset(x + 8, centerY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CursiveDrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;
  final double strokeWidth;

  CursiveDrawingPainter({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
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
  bool shouldRepaint(covariant CursiveDrawingPainter oldDelegate) => true;
}
