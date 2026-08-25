import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/tts_service.dart';

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
      {'title': 'Addition Practice', 'icon': '➕', 'type': 'addition', 'difficulty': 'Easy'},
      {'title': 'Subtraction Practice', 'icon': '➖', 'type': 'subtraction', 'difficulty': 'Easy'},
      {'title': 'Multiplication Practice', 'icon': '✖️', 'type': 'multiplication', 'difficulty': 'Medium'},
      {'title': 'Division Practice', 'icon': '➗', 'type': 'division', 'difficulty': 'Medium'},
      {'title': 'Mixed Problems', 'icon': '🔢', 'type': 'mixed', 'difficulty': 'Hard'},
    ],
    'tracing': [
      {'title': 'Trace Letters A-Z', 'icon': '🔤', 'type': 'letters', 'difficulty': 'Easy'},
      {'title': 'Trace Numbers 1-20', 'icon': '🔢', 'type': 'numbers', 'difficulty': 'Easy'},
      {'title': 'Trace Shapes', 'icon': '⭐', 'type': 'shapes', 'difficulty': 'Easy'},
      {'title': 'Trace Hindi Letters', 'icon': '🇮🇳', 'type': 'hindi', 'difficulty': 'Medium'},
    ],
    'matching': [
      {'title': 'Match Animals', 'icon': '🐾', 'type': 'animals', 'difficulty': 'Easy'},
      {'title': 'Match Colors', 'icon': '🎨', 'type': 'colors', 'difficulty': 'Easy'},
      {'title': 'Match Fruits', 'icon': '🍎', 'type': 'fruits', 'difficulty': 'Easy'},
      {'title': 'Match Numbers to Words', 'icon': '1️⃣', 'type': 'numwords', 'difficulty': 'Medium'},
    ],
    'fill': [
      {'title': 'Fill Missing Numbers', 'icon': '❓', 'type': 'missing_num', 'difficulty': 'Medium'},
      {'title': 'Fill Missing Letters', 'icon': '🔠', 'type': 'missing_letter', 'difficulty': 'Easy'},
      {'title': 'Complete the Pattern', 'icon': '🔄', 'type': 'pattern', 'difficulty': 'Hard'},
    ],
  };

  final Map<String, List<Color>> categoryGradients = {
    'math': [const Color(0xFFFF6B6B), const Color(0xFFFF8E53), const Color(0xFFFFAA5A)],
    'tracing': [const Color(0xFF4ECDC4), const Color(0xFF44A08D), const Color(0xFF093028)],
    'matching': [const Color(0xFFFFAA5A), const Color(0xFFFF8E53), const Color(0xFFFF6B6B)],
    'fill': [const Color(0xFFA78BFA), const Color(0xFF8B5CF6), const Color(0xFF6366F1)],
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
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
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
              colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
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
                            padding: const EdgeInsets.all(16),
                            physics: const BouncingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        ),
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
              blurRadius: 4,
              offset: const Offset(1, 2),
            ),
          ],
        ),
      ),
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
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
        labelPadding: const EdgeInsets.symmetric(horizontal: 20),
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
            width: 120,
            height: 120,
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
          const SizedBox(height: 24),
          Text(
            'No Worksheets Found',
            style: GoogleFonts.baloo2(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
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

    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, index.isEven ? _floatAnimation.value : -_floatAnimation.value),
          child: GestureDetector(
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
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: gradients[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative circle
                  Positioned(
                    top: -15,
                    right: -15,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon container
                        Container(
                          width: 60,
                          height: 60,
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
                        const SizedBox(height: 12),
                        // Title
                        Text(
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
                        const SizedBox(height: 8),
                        // Difficulty badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: difficultyColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
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
          ),
        );
      },
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
      Get.to(() => MathWorksheetScreen(
        title: worksheet['title'],
        type: worksheet['type'],
      ));
    } else {
      Get.snackbar(
        '${worksheet['icon']} Opening Worksheet',
        '${worksheet['title']} worksheet is loading...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: categoryGradients[_selectedCategory]![0],
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
        duration: const Duration(seconds: 2),
      );
    }
  }
}

// Math Worksheet Screen
class MathWorksheetScreen extends StatefulWidget {
  final String title;
  final String type;

  const MathWorksheetScreen({
    Key? key,
    required this.title,
    required this.type,
  }) : super(key: key);

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF0F4FF),
                Color(0xFFE8ECFF),
                Color(0xFFF5F0FF),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  gradient: LinearGradient(colors: gradients),
                ),
                child: Column(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 60)),
                    const SizedBox(height: 12),
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: gradients[0].withValues(alpha: 0.2),
                            blurRadius: 12,
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
                          const SizedBox(height: 8),
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
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade300, width: 2),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Get.back();
                                Get.back();
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(colors: gradients),
                              boxShadow: [
                                BoxShadow(
                                  color: gradients[0].withValues(alpha: 0.4),
                                  blurRadius: 8,
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
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
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
          child: Column(
            children: [
              // Progress indicator
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('📝', 'Questions', '${problems.length}'),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    _buildStatItem('✅', 'Answered', '${userAnswers.length}'),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    _buildStatItem('⏳', 'Remaining', '${problems.length - userAnswers.length}'),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: problems.length,
                  itemBuilder: (context, index) {
                    return _buildProblemCard(index);
                  },
                ),
              ),
              if (!isSubmitted)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4ECDC4).withValues(alpha: 0.4),
                          blurRadius: 12,
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
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Submit Answers',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
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
        ),
      ),
    );
  }

  Widget _buildStatItem(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
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
    final isCorrect = isSubmitted &&
        int.tryParse(userAnswers[index] ?? '') == problem['answer'];
    final isWrong = isSubmitted &&
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
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
                  color: (isSubmitted
                          ? (isCorrect ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B6B))
                          : const Color(0xFF667EEA))
                      .withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: isSubmitted
                  ? Icon(
                      isCorrect ? Icons.check : Icons.close,
                      color: Colors.white,
                      size: 22,
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
          const SizedBox(width: 16),
          Text(
            '${problem['num1']} ${problem['operator']} ${problem['num2']} = ',
            style: GoogleFonts.baloo2(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
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
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                ),
                borderRadius: BorderRadius.circular(10),
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

