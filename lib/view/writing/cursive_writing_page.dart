import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class CursiveWritingPage extends StatefulWidget {
  const CursiveWritingPage({super.key});

  @override
  State<CursiveWritingPage> createState() => _CursiveWritingPageState();
}

class _CursiveWritingPageState extends State<CursiveWritingPage> {
  final FlutterTts flutterTts = FlutterTts();
  int currentIndex = 0;
  int currentCategory = 0; // 0=ABC, 1=abc, 2=123, 3=Hindi
  List<CursiveDrawingPoint?> drawingPoints = [];
  Color penColor = Color(0xFF764BA2);
  double penWidth = 20.0;
  bool showGuide = true;

  final List<String> categoryLabels = ['ABC', 'abc', '123', 'हिंदी'];
  final List<List<Color>> categoryGradients = [
    [Color(0xFF667EEA), Color(0xFF764BA2)],
    [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    [Color(0xFFFFAA5A), Color(0xFFFF8E53)],
  ];

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

  final List<String> numbers = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
  ];

  final List<String> hindiLetters = [
    'अ', 'आ', 'इ', 'ई', 'उ', 'ऊ', 'ए', 'ऐ', 'ओ', 'औ', 'अं', 'अः',
    'क', 'ख', 'ग', 'घ', 'ङ',
    'च', 'छ', 'ज', 'झ', 'ञ',
    'ट', 'ठ', 'ड', 'ढ', 'ण',
    'त', 'थ', 'द', 'ध', 'न',
    'प', 'फ', 'ब', 'भ', 'म',
    'य', 'र', 'ल', 'व',
    'श', 'ष', 'स', 'ह',
    'क्ष', 'त्र', 'ज्ञ',
  ];

  List<String> get currentList {
    switch (currentCategory) {
      case 0: return capitalLetters;
      case 1: return smallLetters;
      case 2: return numbers;
      case 3: return hindiLetters;
      default: return capitalLetters;
    }
  }

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
    final letter = currentList[currentIndex];
    if (currentCategory == 3) {
      flutterTts.setLanguage("hi-IN");
      flutterTts.speak(letter);
      flutterTts.setLanguage("en-US");
    } else {
      flutterTts.speak(letter);
    }
  }

  void _previousLetter() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      } else {
        currentIndex = currentList.length - 1;
      }
      drawingPoints.clear();
    });
    TtsService.to.speak(currentList[currentIndex]);
    _speakLetter();
  }

  void _nextLetter() {
    setState(() {
      if (currentIndex < currentList.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      drawingPoints.clear();
    });
    TtsService.to.speak(currentList[currentIndex]);
    _speakLetter();
  }

  void _clearCanvas() {
    setState(() => drawingPoints.clear());
  }

  void _selectCategory(int index) {
    if (currentCategory == index) return;
    setState(() {
      currentCategory = index;
      currentIndex = 0;
      drawingPoints.clear();
    });
    TtsService.to.speak(categoryLabels[index]);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLetter = currentList[currentIndex];

    return GradientScaffold(
      title: 'Cursive Writing',
      emoji: '✒️',
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: _clearCanvas,
            icon: const Icon(Icons.refresh, color: Colors.white, size: 24),
          ),
        ),
      ],
      bottomNavigationBar: const AdsScreen(),
      body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Category buttons + letter display
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Category buttons row
                    Row(
                      children: List.generate(4, (index) {
                        final isSelected = currentCategory == index;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _selectCategory(index),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(colors: categoryGradients[index])
                                    : null,
                                color: isSelected ? null : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  categoryLabels[index],
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
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
                        // Drawing canvas (clipped to letter shape)
                        GestureDetector(
                          onPanStart: (details) {
                            setState(() {
                              drawingPoints.add(CursiveDrawingPoint(
                                offset: details.localPosition,
                                color: penColor,
                                strokeWidth: penWidth,
                              ));
                            });
                          },
                          onPanUpdate: (details) {
                            setState(() {
                              drawingPoints.add(CursiveDrawingPoint(
                                offset: details.localPosition,
                                color: penColor,
                                strokeWidth: penWidth,
                              ));
                            });
                          },
                          onPanEnd: (details) {
                            setState(() => drawingPoints.add(null));
                          },
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: CursiveColoringPainter(
                              drawingPoints: drawingPoints,
                              letter: currentLetter,
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
                        onPressed: _previousLetter,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("Previous"),
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

class CursiveDrawingPoint {
  final Offset offset;
  final Color color;
  final double strokeWidth;

  CursiveDrawingPoint({
    required this.offset,
    required this.color,
    required this.strokeWidth,
  });
}

class CursiveColoringPainter extends CustomPainter {
  final List<CursiveDrawingPoint?> drawingPoints;
  final String letter;

  CursiveColoringPainter({
    required this.drawingPoints,
    required this.letter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (drawingPoints.isEmpty) return;

    // Save a compositing layer
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    // Draw user strokes first (destination)
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        final paint = Paint()
          ..color = drawingPoints[i]!.color
          ..strokeWidth = drawingPoints[i]!.strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke;

        canvas.drawLine(
          drawingPoints[i]!.offset,
          drawingPoints[i + 1]!.offset,
          paint,
        );
      } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
        final paint = Paint()
          ..color = drawingPoints[i]!.color
          ..strokeWidth = drawingPoints[i]!.strokeWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          drawingPoints[i]!.offset,
          drawingPoints[i]!.strokeWidth / 2,
          paint,
        );
      }
    }

    // Draw the letter mask with dstIn — keeps strokes only inside letter
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: const TextStyle(
          fontSize: 250,
          fontFamily: 'Cursive',
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    final maskPaint = Paint()..blendMode = BlendMode.dstIn;
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), maskPaint);
    textPainter.paint(canvas, offset);
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CursiveColoringPainter oldDelegate) => true;
}
