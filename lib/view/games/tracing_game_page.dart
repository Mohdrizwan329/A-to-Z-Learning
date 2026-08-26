import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class TracingGamePage extends StatefulWidget {
  const TracingGamePage({super.key});

  @override
  State<TracingGamePage> createState() => _TracingGamePageState();
}

class _TracingGamePageState extends State<TracingGamePage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Home screen style animations
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  // Capital Letters (A-Z)
  final List<String> _capitalLetters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  // Small Letters (a-z)
  final List<String> _smallLetters = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
  ];

  // Numbers (0-9)
  final List<String> _numbers = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];

  // Hindi Letters (Vowels + Consonants)
  final List<String> _hindiLetters = [
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
  ];

  // Separate index for each tab
  final List<int> _currentIndices = [0, 0, 0, 0]; // [A-Z, a-z, 0-9, Hindi]
  int _currentMode = 0; // 0: Capital, 1: Small, 2: Numbers, 3: Hindi
  List<Offset> _points = [];

  // Separate completed items for each tab
  final List<List<int>> _completedItemsPerTab = [
    [], // A-Z completed
    [], // a-z completed
    [], // 0-9 completed
    [], // Hindi completed
  ];

  final List<String> _modeNames = ['A-Z', 'a-z', '0-9', 'हिंदी'];

  // Getters for current tab's data
  int get _currentIndex => _currentIndices[_currentMode];
  set _currentIndex(int value) => _currentIndices[_currentMode] = value;

  List<int> get _completedItems => _completedItemsPerTab[_currentMode];

  List<String> get _currentList {
    switch (_currentMode) {
      case 0:
        return _capitalLetters;
      case 1:
        return _smallLetters;
      case 2:
        return _numbers;
      case 3:
        return _hindiLetters;
      default:
        return _capitalLetters;
    }
  }

  String get _currentModeName => _modeNames[_currentMode];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentMode = _tabController.index;
          _points = [];
          // Note: Each tab maintains its own progress and current index
        });
      }
    });

    // Initialize home screen style animations
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  // Build floating bubbles like home screen
  List<Widget> _buildFloatingBubbles() {
    return List.generate(6, (index) {
      final random = math.Random(index);
      final size = 30.0 + random.nextDouble() * 50;
      final left = random.nextDouble() * MediaQuery.of(context).size.width;
      final startTop = random.nextDouble() * MediaQuery.of(context).size.height;

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + index * 0.15) % 1.0;
          final top =
              startTop - (progress * MediaQuery.of(context).size.height * 0.5);
          final opacity = (1 - progress).clamp(0.0, 0.15);

          return Positioned(
            left: left,
            top: top,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: opacity),
              ),
            ),
          );
        },
      );
    });
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _points = [details.localPosition];
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _points.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    // Simple completion check - if enough points drawn
    if (_points.length > 50) {
      if (!_completedItems.contains(_currentIndex)) {
        _completedItems.add(_currentIndex);
      }
    }
  }

  void _clearDrawing() {
    setState(() {
      _points = [];
    });
  }

  void _nextItem() {
    if (_currentIndex < _currentList.length - 1) {
      setState(() {
        _currentIndex++;
        _points = [];
      });
    }
  }

  void _previousItem() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _points = [];
      });
    }
  }

  void _resetAll() {
    setState(() {
      _currentIndices[_currentMode] = 0;
      _points = [];
      _completedItemsPerTab[_currentMode].clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20.r,
            ),
          ),
          onPressed: () => Navigator.pop(context),
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
        title: const Text(
          'Letter Tracing',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.refresh, color: Colors.white, size: 20.r),
            ),
            onPressed: _resetAll,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3.r,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
          tabs: const [
            Tab(text: 'A-Z'),
            Tab(text: 'a-z'),
            Tab(text: '0-9'),
            Tab(text: 'हिंदी'),
          ],
        ),
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Floating bubbles background
            ..._buildFloatingBubbles(),
            SafeArea(
              child: LayoutBuilder(
                // Portrait-shaped content: in landscape the body is barely 300pt tall,
                // which is shorter than this column needs. Scroll when that happens and
                // stay exactly as before whenever there is room.
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      // A LayoutBuilder can sit inside another scrollable, where
                      // maxHeight is infinite; a minHeight of infinity
                      // is not a constraint anything can satisfy.
                      minHeight: constraints.maxHeight.isFinite
                          ? constraints.maxHeight
                          : 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Progress bar
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _currentModeName,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${_completedItems.length}/${_currentList.length} completed',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: LinearProgressIndicator(
                                  value: _currentList.isEmpty
                                      ? 0
                                      : _completedItems.length /
                                            _currentList.length,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.2,
                                  ),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF56D97F),
                                      ),
                                  minHeight: 10.h,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Progress indicator
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Text(
                                  '${_currentIndex + 1} / ${_currentList.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '✓ ${_completedItems.length}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tracing Canvas. Flexible so the canvas gives up the last
                        // few pixels on a short screen instead of the whole column
                        // overflowing; it keeps its full height wherever there is
                        // room.
                        Flexible(
                          child: Container(
                            height: 320.h,
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 15.r,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24.r),
                              child: Stack(
                                children: [
                                  // Background letter/number to trace
                                  Center(
                                    child: Text(
                                      _currentList[_currentIndex],
                                      style: TextStyle(
                                        fontSize: 250,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Dotted guide (simplified)
                                  Center(
                                    child: Text(
                                      _currentList[_currentIndex],
                                      style: TextStyle(
                                        fontSize: 250,
                                        fontWeight: FontWeight.bold,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 3
                                          ..color = Colors.grey.withValues(
                                            alpha: 0.4,
                                          ),
                                      ),
                                    ),
                                  ),

                                  // Drawing canvas with letter clipping
                                  GestureDetector(
                                    onPanStart: _onPanStart,
                                    onPanUpdate: _onPanUpdate,
                                    onPanEnd: _onPanEnd,
                                    child: CustomPaint(
                                      size: Size.infinite,
                                      painter: TracingPainter(
                                        points: _points,
                                        letter: _currentList[_currentIndex],
                                      ),
                                    ),
                                  ),

                                  // Completed indicator
                                  if (_completedItems.contains(_currentIndex))
                                    Positioned(
                                      top: 16.h,
                                      right: 16.w,
                                      child: Container(
                                        padding: EdgeInsets.all(12.r),
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 32.r,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Controls
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: // Previous Button
                                GestureDetector(
                                  onTap: _currentIndex > 0
                                      ? _previousItem
                                      : null,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: _currentIndex > 0
                                            ? [
                                                const Color(0xFF667EEA),
                                                const Color(0xFF764BA2),
                                              ]
                                            : [
                                                Colors.grey.shade400,
                                                Colors.grey.shade500,
                                              ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(25.r),
                                      boxShadow: _currentIndex > 0
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF667EEA,
                                                ).withValues(alpha: 0.4),
                                                blurRadius: 8.r,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                          size: 18.r,
                                        ),
                                        SizedBox(width: 6.w),
                                        Flexible(
                                          child: Text(
                                            'Prev',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              Flexible(
                                child: // Clear Button
                                GestureDetector(
                                  onTap: _clearDrawing,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF6B6B),
                                          Color(0xFFFF8E53),
                                          Color(0xFFFFAA5A),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(25.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFFF6B6B,
                                          ).withValues(alpha: 0.4),
                                          blurRadius: 8.r,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.refresh,
                                          color: Colors.white,
                                          size: 18.r,
                                        ),
                                        SizedBox(width: 6.w),
                                        Flexible(
                                          child: Text(
                                            'Clear',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              Flexible(
                                child: // Next Button
                                GestureDetector(
                                  onTap: _currentIndex < _currentList.length - 1
                                      ? _nextItem
                                      : null,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors:
                                            _currentIndex <
                                                _currentList.length - 1
                                            ? [
                                                const Color(0xFF56D97F),
                                                const Color(0xFF4ECDC4),
                                              ]
                                            : [
                                                Colors.grey.shade400,
                                                Colors.grey.shade500,
                                              ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(25.r),
                                      boxShadow:
                                          _currentIndex <
                                              _currentList.length - 1
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF56D97F,
                                                ).withValues(alpha: 0.4),
                                                blurRadius: 8.r,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Next',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 18.r,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 50.h),

                        // Letter/Number selection row
                        SizedBox(
                          height: 100.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            itemCount: _currentList.length,
                            itemBuilder: (context, index) {
                              final isSelected = index == _currentIndex;
                              final isCompleted = _completedItems.contains(
                                index,
                              );

                              return GestureDetector(
                                onTap: () {
                                  TtsService.to.speak(_currentList[index]);
                                  setState(() {
                                    _currentIndex = index;
                                    _points = [];
                                  });
                                },
                                child: Container(
                                  width: 85.w,
                                  height: 85.h,
                                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFFF6B6B)
                                        : isCompleted
                                        ? Colors.green
                                        : Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: isSelected
                                        ? Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _currentList[index],
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected || isCompleted
                                            ? Colors.white
                                            : Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TracingPainter extends CustomPainter {
  final List<Offset> points;
  final String letter;

  TracingPainter({required this.points, required this.letter});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // Create text painter for letter shape
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: const TextStyle(
          fontSize: 250,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Calculate center position
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Save canvas state
    canvas.save();

    // Create clipping path from letter
    final letterPath = Path();
    letterPath.addRect(
      Rect.fromLTWH(
        offset.dx,
        offset.dy,
        textPainter.width,
        textPainter.height,
      ),
    );

    // Use a custom clip approach - draw only where points intersect with letter bounds
    // Create the drawing path
    final drawPath = Path();
    drawPath.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      drawPath.lineTo(points[i].dx, points[i].dy);
    }

    // Create fill paint for coloring inside the letter
    final fillPaint = Paint()
      ..color = const Color(0xFFFF6B6B)
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Clip to the letter text shape using a shader mask approach
    // First draw colored strokes
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    // Draw the user's tracing path
    canvas.drawPath(drawPath, fillPaint);

    // Use destination-in blend mode to keep only where text exists
    canvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..blendMode = BlendMode.dstIn,
    );

    // Draw text as mask
    textPainter.paint(canvas, offset);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(TracingPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.letter != letter;
  }
}
