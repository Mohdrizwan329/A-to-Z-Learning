import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class HandwritingPracticePage extends StatefulWidget {
  const HandwritingPracticePage({Key? key}) : super(key: key);

  @override
  State<HandwritingPracticePage> createState() =>
      _HandwritingPracticePageState();
}

class _HandwritingPracticePageState extends State<HandwritingPracticePage> {
  String _selectedCategory = 'capital';
  int _currentIndex = 0;
  List<Offset?> _points = [];
  Color _penColor = Colors.blue;
  double _penWidth = 4.0;
  bool _showGuide = true;

  final Map<String, List<String>> _categories = {
    'capital': List.generate(26, (i) => String.fromCharCode(65 + i)),
    'small': List.generate(26, (i) => String.fromCharCode(97 + i)),
    'numbers': List.generate(10, (i) => '$i'),
    'hindi': [
      'अ',
      'आ',
      'इ',
      'ई',
      'उ',
      'ऊ',
      'ए',
      'ऐ',
      'ओ',
      'औ',
      'अं',
      'अः',
      'क',
      'ख',
      'ग',
      'घ',
      'ङ',
      'च',
      'छ',
      'ज',
      'झ',
      'ञ',
      'ट',
      'ठ',
      'ड',
      'ढ',
      'ण',
      'त',
      'थ',
      'द',
      'ध',
      'न',
      'प',
      'फ',
      'ब',
      'भ',
      'म',
      'य',
      'र',
      'ल',
      'व',
      'श',
      'ष',
      'स',
      'ह',
      'क्ष',
      'त्र',
      'ज्ञ',
    ],
  };

  final List<Map<String, dynamic>> _penColors = [
    {'color': Colors.blue, 'name': 'Blue'},
    {'color': Colors.red, 'name': 'Red'},
    {'color': Colors.green, 'name': 'Green'},
    {'color': Colors.purple, 'name': 'Purple'},
    {'color': Colors.orange, 'name': 'Orange'},
    {'color': Colors.black, 'name': 'Black'},
  ];

  String get _currentChar => _categories[_selectedCategory]![_currentIndex];

  void _clearCanvas() {
    setState(() {
      _points = [];
    });
  }

  void _nextChar() {
    final maxIndex = _categories[_selectedCategory]!.length - 1;
    if (_currentIndex < maxIndex) {
      setState(() {
        _currentIndex++;
        _points = [];
      });
    }
  }

  void _prevChar() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _points = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text(
          "Handwriting",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _showGuide ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showGuide = !_showGuide;
              });
            },
            tooltip: 'Toggle Guide',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // With the keyboard up the body loses about 300pt, which is less than
        // the selector, controls and pen settings need together. The page
        // scrolls when that happens and is unchanged when there is room.
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : 0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category Selection
                  _buildCategorySelector(),
                  // Character Display
                  _buildCharacterDisplay(),
                  // Drawing Canvas. A share of the viewport rather than
                  // `Expanded`, which cannot be laid out inside a scroll view.
                  SizedBox(
                    height: max(220.h, constraints.maxHeight * 0.4),
                    child: _buildDrawingCanvas(),
                  ),
                  // Controls
                  _buildControls(),
                  // Pen Settings
                  _buildPenSettings(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = [
      {'id': 'capital', 'name': 'A-Z', 'icon': '🔤'},
      {'id': 'small', 'name': 'a-z', 'icon': '🔡'},
      {'id': 'numbers', 'name': '0-9', 'icon': '🔢'},
      {'id': 'hindi', 'name': 'हिंदी', 'icon': '🇮🇳'},
    ];

    return Container(
      padding: EdgeInsets.all(12.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat['id'];
          // Expanded, so each chip is measured against a real width. A Row
          // measures an inflexible child with unbounded width, and each chip
          // holds a Flexible caption, which cannot be laid out that way.
          return Expanded(
            child: GestureDetector(
              onTap: () {
                TtsService.to.speak(cat['name'] as String);
                setState(() {
                  _selectedCategory = cat['id'] as String;
                  _currentIndex = 0;
                  _points = [];
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        )
                      : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? const Color(0xFF667EEA).withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        cat['icon'] as String,
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        cat['name'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCharacterDisplay() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          Flexible(
            child: IconButton(
              onPressed: _currentIndex > 0 ? _prevChar : null,
              icon: Icon(
                Icons.arrow_back_ios,
                color: _currentIndex > 0
                    ? const Color(0xFF667EEA)
                    : Colors.grey.shade300,
              ),
            ),
          ),
          // Character
          Flexible(
            child: Column(
              children: [
                Text(
                  'Practice Writing',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Text(
                      _currentChar,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${_currentIndex + 1} / ${_categories[_selectedCategory]!.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Next Button
          Flexible(
            child: IconButton(
              onPressed:
                  _currentIndex < _categories[_selectedCategory]!.length - 1
                  ? _nextChar
                  : null,
              icon: Icon(
                Icons.arrow_forward_ios,
                color:
                    _currentIndex < _categories[_selectedCategory]!.length - 1
                    ? const Color(0xFF667EEA)
                    : Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawingCanvas() {
    return Container(
      margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Stack(
          children: [
            // Guide lines
            CustomPaint(size: Size.infinite, painter: GuideLinesPainter()),
            // Guide character (watermark)
            if (_showGuide)
              Center(
                child: Text(
                  _currentChar,
                  style: TextStyle(
                    fontSize: 200,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.withValues(alpha: 0.15),
                  ),
                ),
              ),
            // Drawing area
            GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _points.add(details.localPosition);
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _points.add(details.localPosition);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _points.add(null); // Add null to separate strokes
                });
              },
              child: CustomPaint(
                size: Size.infinite,
                painter: DrawingPainter(
                  points: _points,
                  color: _penColor,
                  strokeWidth: _penWidth,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Clear Button
          Expanded(
            child: _buildControlButton(
              icon: Icons.refresh,
              label: 'Clear',
              color: Colors.red,
              onTap: _clearCanvas,
            ),
          ),
          // Undo Button
          Expanded(
            child: _buildControlButton(
              icon: Icons.undo,
              label: 'Undo',
              color: Colors.orange,
              onTap: () {
                if (_points.isNotEmpty) {
                  setState(() {
                    // Remove last stroke
                    int lastNull = _points.lastIndexOf(null);
                    if (lastNull == -1) {
                      _points = [];
                    } else {
                      _points = _points.sublist(0, lastNull);
                    }
                  });
                }
              },
            ),
          ),
          // Done Button
          Expanded(
            child: _buildControlButton(
              icon: Icons.check_circle,
              label: 'Done',
              color: Colors.green,
              onTap: () {
                if (_points.isNotEmpty) {
                  Get.snackbar(
                    'Great Job! 🎉',
                    'You practiced writing "$_currentChar"',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                  _nextChar();
                } else {
                  Get.snackbar(
                    'Try Writing!',
                    'Practice writing the character first',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22.r),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPenSettings() {
    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Color Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: const Text(
                  'Pen Color:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Row(
                children: _penColors.map((pc) {
                  final color = pc['color'] as Color;
                  final isSelected = _penColor == color;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _penColor = color;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.black
                              : Colors.grey.shade300,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: isSelected
                          ? Icon(Icons.check, color: Colors.white, size: 18.r)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Pen Size
          Row(
            children: [
              const Text(
                'Pen Size:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Slider(
                  value: _penWidth,
                  min: 2.0,
                  max: 12.0,
                  divisions: 5,
                  activeColor: const Color(0xFF667EEA),
                  onChanged: (value) {
                    setState(() {
                      _penWidth = value;
                    });
                  },
                ),
              ),
              Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: _penColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: _penWidth * 2,
                    height: _penWidth * 2,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Drawing Painter
class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;
  final double strokeWidth;

  DrawingPainter({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

// Guide Lines Painter
class GuideLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    final dashedPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    // Draw horizontal lines
    final lineSpacing = size.height / 4;
    for (int i = 1; i < 4; i++) {
      final y = lineSpacing * i;
      if (i == 2) {
        // Center line - dashed
        _drawDashedLine(
          canvas,
          Offset(0, y),
          Offset(size.width, y),
          dashedPaint,
        );
      } else {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }

    // Draw vertical center line - dashed
    _drawDashedLine(
      canvas,
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      dashedPaint,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 4.0;
    final distance = (end - start).distance;
    final dx = (end.dx - start.dx) / distance;
    final dy = (end.dy - start.dy) / distance;

    double currentDistance = 0;
    while (currentDistance < distance) {
      final startPoint = Offset(
        start.dx + dx * currentDistance,
        start.dy + dy * currentDistance,
      );
      final endPoint = Offset(
        start.dx + dx * (currentDistance + dashWidth).clamp(0, distance),
        start.dy + dy * (currentDistance + dashWidth).clamp(0, distance),
      );
      canvas.drawLine(startPoint, endPoint, paint);
      currentDistance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
