import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class WorksheetsPage extends StatefulWidget {
  const WorksheetsPage({Key? key}) : super(key: key);

  @override
  State<WorksheetsPage> createState() => _WorksheetsPageState();
}

class _WorksheetsPageState extends State<WorksheetsPage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;
  late TabController _tabController;
  bool _isInitialized = false;

  final List<Map<String, String>> _categories = [
    {'id': 'math', 'name': 'Math', 'icon': '🧮'},
    {'id': 'tracing', 'name': 'Tracing', 'icon': '✏️'},
    {'id': 'matching', 'name': 'Matching', 'icon': '🔗'},
    {'id': 'fill', 'name': 'Fill-in', 'icon': '📝'},
  ];

  String get _selectedCategory => _categories[_tabController.index]['id']!;

  final Map<String, List<Map<String, dynamic>>> worksheets = {
    'math': [
      {
        'title': 'Addition Practice',
        'icon': '➕',
        'type': 'addition',
        'difficulty': 'Easy',
      },
      {
        'title': 'Subtraction Practice',
        'icon': '➖',
        'type': 'subtraction',
        'difficulty': 'Easy',
      },
      {
        'title': 'Multiplication Practice',
        'icon': '✖️',
        'type': 'multiplication',
        'difficulty': 'Medium',
      },
      {
        'title': 'Division Practice',
        'icon': '➗',
        'type': 'division',
        'difficulty': 'Medium',
      },
      {
        'title': 'Mixed Problems',
        'icon': '🔢',
        'type': 'mixed',
        'difficulty': 'Hard',
      },
    ],
    'tracing': [
      {
        'title': 'Trace Letters A-Z',
        'icon': '🔤',
        'type': 'letters',
        'difficulty': 'Easy',
      },
      {
        'title': 'Trace Numbers 1-20',
        'icon': '🔢',
        'type': 'numbers',
        'difficulty': 'Easy',
      },
      {
        'title': 'Trace Shapes',
        'icon': '⭐',
        'type': 'shapes',
        'difficulty': 'Easy',
      },
      {
        'title': 'Trace Hindi Letters',
        'icon': '🇮🇳',
        'type': 'hindi',
        'difficulty': 'Medium',
      },
    ],
    'matching': [
      {
        'title': 'Match Animals',
        'icon': '🐾',
        'type': 'animals',
        'difficulty': 'Easy',
      },
      {
        'title': 'Match Colors',
        'icon': '🎨',
        'type': 'colors',
        'difficulty': 'Easy',
      },
      {
        'title': 'Match Fruits',
        'icon': '🍎',
        'type': 'fruits',
        'difficulty': 'Easy',
      },
      {
        'title': 'Match Numbers to Words',
        'icon': '1️⃣',
        'type': 'numwords',
        'difficulty': 'Medium',
      },
    ],
    'fill': [
      {
        'title': 'Fill Missing Numbers',
        'icon': '❓',
        'type': 'missing_num',
        'difficulty': 'Medium',
      },
      {
        'title': 'Fill Missing Letters',
        'icon': '🔠',
        'type': 'missing_letter',
        'difficulty': 'Easy',
      },
      {
        'title': 'Complete the Pattern',
        'icon': '🔄',
        'type': 'pattern',
        'difficulty': 'Hard',
      },
    ],
  };

  final Map<String, List<Color>> categoryGradients = {
    'math': [
      const Color(0xFFFF6B6B),
      const Color(0xFFFF8E53),
      const Color(0xFFFFAA5A),
    ],
    'tracing': [
      const Color(0xFF4ECDC4),
      const Color(0xFF44A08D),
      const Color(0xFF093028),
    ],
    'matching': [
      const Color(0xFFFFAA5A),
      const Color(0xFFFF8E53),
      const Color(0xFFFF6B6B),
    ],
    'fill': [
      const Color(0xFFA78BFA),
      const Color(0xFF8B5CF6),
      const Color(0xFF6366F1),
    ],
  };

  List<Map<String, dynamic>> get _filteredWorksheets {
    return worksheets[_selectedCategory] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bubbleController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFFF8E53),
                  Color(0xFFFFAA5A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0,
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
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    final filteredWorksheets = _filteredWorksheets;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
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
            ..._buildFloatingBubbles(),
            SafeArea(
              child: Column(
                children: [
                  // Worksheets Grid
                  Expanded(
                    child: filteredWorksheets.isEmpty
                        ? _buildEmptyState()
                        : GridView.builder(
                            padding: EdgeInsets.all(16.r),
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16.r,
                                  crossAxisSpacing: 16.r,
                                  childAspectRatio: 0.85,
                                ),
                            itemCount: filteredWorksheets.length,
                            itemBuilder: (context, index) {
                              final worksheet = filteredWorksheets[index];
                              return _buildWorksheetCard(worksheet, index);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 8,
      shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
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
      centerTitle: true,
      title: Text(
        'Worksheets',
        style: GoogleFonts.baloo2(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4.r,
              offset: const Offset(1, 2),
            ),
          ],
        ),
      ),
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3.r,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
        labelStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
        tabs: _categories.map((category) {
          return Tab(text: category['name']!);
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 3,
              ),
            ),
            child: const Center(
              child: Text('🔍', style: TextStyle(fontSize: 60)),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Worksheets Found',
            style: GoogleFonts.baloo2(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try searching something else!',
            style: GoogleFonts.nunito(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorksheetCard(Map<String, dynamic> worksheet, int index) {
    final gradients = categoryGradients[_selectedCategory]!;
    final difficulty = worksheet['difficulty'] as String;

    Color difficultyColor;
    switch (difficulty) {
      case 'Easy':
        difficultyColor = const Color(0xFF4ECDC4);
        break;
      case 'Medium':
        difficultyColor = const Color(0xFFFFAA5A);
        break;
      case 'Hard':
        difficultyColor = const Color(0xFFFF6B6B);
        break;
      default:
        difficultyColor = const Color(0xFF4ECDC4);
    }

    // The card is passed as `child` so it is built once, not on every frame of
    // the float animation. Rebuilding it per frame meant re-resolving its two
    // GoogleFonts styles 60 times a second, which cost this page 78ms a frame -
    // about 12fps - while it just sat there.
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(
          0,
          index.isEven ? _floatAnimation.value : -_floatAnimation.value,
        ),
        child: child,
      ),
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              TtsService.to.speak(worksheet['title']);
              _openWorksheet(worksheet);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradients,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: gradients[0].withValues(alpha: 0.4),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative circle
                  Positioned(
                    top: -15.h,
                    right: -15.w,
                    child: Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  // Main content
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon container
                        Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              worksheet['icon'],
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Title
                        Flexible(
                          child: Text(
                            worksheet['title'],
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Difficulty badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: difficultyColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: difficultyColor.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            difficulty,
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildFloatingBubbles() {
    return List.generate(6, (index) {
      final random = math.Random(index);
      final size = 20.0 + random.nextDouble() * 40;
      final left = random.nextDouble() * MediaQuery.of(context).size.width;
      final delay = random.nextDouble();
      final opacity = 0.1 + random.nextDouble() * 0.15;

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + delay) % 1.0;
          final top = MediaQuery.of(context).size.height * (1 - progress);

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

  void _openWorksheet(Map<String, dynamic> worksheet) {
    if (_selectedCategory == 'math') {
      Get.to(
        () => MathWorksheetScreen(
          title: worksheet['title'],
          type: worksheet['type'],
        ),
      );
    } else {
      Get.snackbar(
        '${worksheet['icon']} Opening Worksheet',
        '${worksheet['title']} worksheet is loading...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: categoryGradients[_selectedCategory]![0],
        colorText: Colors.white,
        margin: EdgeInsets.all(16.r),
        borderRadius: 16.r,
        duration: const Duration(seconds: 2),
      );
    }
  }
}

// Math Worksheet Screen
class MathWorksheetScreen extends StatefulWidget {
  final String title;
  final String type;

  const MathWorksheetScreen({Key? key, required this.title, required this.type})
    : super(key: key);

  @override
  State<MathWorksheetScreen> createState() => _MathWorksheetScreenState();
}

class _MathWorksheetScreenState extends State<MathWorksheetScreen> {
  final List<Map<String, dynamic>> problems = [];
  final Map<int, String> userAnswers = {};
  bool isSubmitted = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _generateProblems();
  }

  void _generateProblems() {
    final random = math.Random();
    for (int i = 0; i < 10; i++) {
      int num1, num2, answer;
      String operator;

      switch (widget.type) {
        case 'addition':
          num1 = random.nextInt(50) + 1;
          num2 = random.nextInt(50) + 1;
          answer = num1 + num2;
          operator = '+';
          break;
        case 'subtraction':
          num1 = random.nextInt(50) + 20;
          num2 = random.nextInt(20) + 1;
          answer = num1 - num2;
          operator = '-';
          break;
        case 'multiplication':
          num1 = random.nextInt(12) + 1;
          num2 = random.nextInt(12) + 1;
          answer = num1 * num2;
          operator = '×';
          break;
        case 'division':
          num2 = random.nextInt(10) + 1;
          answer = random.nextInt(10) + 1;
          num1 = num2 * answer;
          operator = '÷';
          break;
        default:
          final ops = ['+', '-', '×'];
          operator = ops[random.nextInt(ops.length)];
          num1 = random.nextInt(20) + 1;
          num2 = random.nextInt(10) + 1;
          if (operator == '+') {
            answer = num1 + num2;
          } else if (operator == '-') {
            answer = num1 - num2;
          } else {
            answer = num1 * num2;
          }
      }

      problems.add({
        'num1': num1,
        'num2': num2,
        'operator': operator,
        'answer': answer,
      });
    }
  }

  void _submitAnswers() {
    int correct = 0;
    for (int i = 0; i < problems.length; i++) {
      final userAnswer = int.tryParse(userAnswers[i] ?? '');
      if (userAnswer == problems[i]['answer']) {
        correct++;
      }
    }
    setState(() {
      score = correct;
      isSubmitted = true;
    });

    _showResultDialog();
  }

  void _showResultDialog() {
    final percentage = (score / problems.length * 100).round();
    String message;
    String emoji;
    List<Color> gradients;

    if (percentage >= 90) {
      message = 'Excellent!';
      emoji = '🏆';
      gradients = [const Color(0xFF4ECDC4), const Color(0xFF44A08D)];
    } else if (percentage >= 70) {
      message = 'Great Job!';
      emoji = '⭐';
      gradients = [const Color(0xFFFFAA5A), const Color(0xFFFF8E53)];
    } else if (percentage >= 50) {
      message = 'Good Effort!';
      emoji = '👍';
      gradients = [const Color(0xFF667EEA), const Color(0xFF764BA2)];
    } else {
      message = 'Keep Practicing!';
      emoji = '💪';
      gradients = [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)];
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF0F4FF), Color(0xFFE8ECFF), Color(0xFFF5F0FF)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                  gradient: LinearGradient(colors: gradients),
                ),
                child: Column(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 60)),
                    SizedBox(height: 12.h),
                    Text(
                      message,
                      style: GoogleFonts.baloo2(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Score section
              Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: gradients[0].withValues(alpha: 0.2),
                            blurRadius: 12.r,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Score: $score/${problems.length}',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: gradients,
                            ).createShader(bounds),
                            child: Text(
                              '$percentage%',
                              style: GoogleFonts.baloo2(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Get.back();
                                Get.back();
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                              child: Text(
                                'Done',
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              gradient: LinearGradient(colors: gradients),
                              boxShadow: [
                                BoxShadow(
                                  color: gradients[0].withValues(alpha: 0.4),
                                  blurRadius: 8.r,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                                setState(() {
                                  problems.clear();
                                  userAnswers.clear();
                                  isSubmitted = false;
                                  score = 0;
                                  _generateProblems();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh_rounded,
                                    color: Colors.white,
                                    size: 20.r,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Try Again',
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 8,
        shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
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
        centerTitle: true,
        title: Text(
          widget.title,
          style: GoogleFonts.baloo2(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
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
        child: SafeArea(
          child: LayoutBuilder(
            // Portrait-shaped content: in landscape the body is barely 300pt
            // tall, which is shorter than the header and the submit button
            // together. The page scrolls when that happens.
            //
            // The problem list is given a share of the viewport rather than
            // `Expanded`, because `Expanded` inside a scroll view needs an
            // `IntrinsicHeight` above it, and measuring the intrinsic height of
            // a lazy list builds every problem card: that cost this page 79ms a
            // frame, five times a 60fps budget.
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress indicator
                    Container(
                      margin: EdgeInsets.all(16.r),
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Equal shares so the widest label wraps in its own column.
                          Expanded(
                            child: _buildStatItem(
                              '📝',
                              'Questions',
                              '${problems.length}',
                            ),
                          ),
                          Container(
                            width: 1.w,
                            height: 40.h,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          Expanded(
                            child: _buildStatItem(
                              '✅',
                              'Answered',
                              '${userAnswers.length}',
                            ),
                          ),
                          Container(
                            width: 1.w,
                            height: 40.h,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          Expanded(
                            child: _buildStatItem(
                              '⏳',
                              'Remaining',
                              '${problems.length - userAnswers.length}',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: math.max(200.h, constraints.maxHeight * 0.55),
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        physics: const BouncingScrollPhysics(),
                        itemCount: problems.length,
                        itemBuilder: (context, index) {
                          return _buildProblemCard(index);
                        },
                      ),
                    ),
                    if (!isSubmitted)
                      Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Container(
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF4ECDC4,
                                ).withValues(alpha: 0.4),
                                blurRadius: 12.r,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _submitAnswers,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8.w),
                                Flexible(
                                  child: Text(
                                    'Submit Answers',
                                    style: GoogleFonts.nunito(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildProblemCard(int index) {
    final problem = problems[index];
    final isCorrect =
        isSubmitted &&
        int.tryParse(userAnswers[index] ?? '') == problem['answer'];
    final isWrong =
        isSubmitted &&
        int.tryParse(userAnswers[index] ?? '') != problem['answer'];

    Color cardColor;
    Color borderColor;
    if (isSubmitted) {
      if (isCorrect) {
        cardColor = const Color(0xFF4ECDC4).withValues(alpha: 0.2);
        borderColor = const Color(0xFF4ECDC4);
      } else {
        cardColor = const Color(0xFFFF6B6B).withValues(alpha: 0.2);
        borderColor = const Color(0xFFFF6B6B);
      }
    } else {
      cardColor = Colors.white.withValues(alpha: 0.15);
      borderColor = Colors.white.withValues(alpha: 0.3);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSubmitted
                    ? (isCorrect
                          ? [const Color(0xFF4ECDC4), const Color(0xFF44A08D)]
                          : [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)])
                    : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color:
                      (isSubmitted
                              ? (isCorrect
                                    ? const Color(0xFF4ECDC4)
                                    : const Color(0xFFFF6B6B))
                              : const Color(0xFF667EEA))
                          .withValues(alpha: 0.4),
                  blurRadius: 8.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: isSubmitted
                  ? Icon(
                      isCorrect ? Icons.check : Icons.close,
                      color: Colors.white,
                      size: 22.r,
                    )
                  : Text(
                      '${index + 1}',
                      style: GoogleFonts.baloo2(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          SizedBox(width: 16.w),
          Flexible(
            child: Text(
              '${problem['num1']} ${problem['operator']} ${problem['num2']} = ',
              style: GoogleFonts.baloo2(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: TextField(
                enabled: !isSubmitted,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: GoogleFonts.baloo2(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: '?',
                  hintStyle: GoogleFonts.baloo2(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      userAnswers[index] = value;
                    } else {
                      userAnswers.remove(index);
                    }
                  });
                },
              ),
            ),
          ),
          if (isWrong) ...[
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                '${problem['answer']}',
                style: GoogleFonts.baloo2(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
