import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';

//////////////////////////////////////////////////////////
//                MAIN MATH GRID SCREEN
//////////////////////////////////////////////////////////
class MathGridScreen extends StatefulWidget {
  @override
  State<MathGridScreen> createState() => _MathGridScreenState();
}

class _MathGridScreenState extends State<MathGridScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  final List<Map<String, dynamic>> mathOperations = [
    {
      'label': 'Addition',
      'icon': Icons.add,
      'emoji': '➕',
      'gradient': [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
      'page': () => AdditionPage(),
    },
    {
      'label': 'Subtraction',
      'icon': Icons.remove,
      'emoji': '➖',
      'gradient': [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
      'page': () => SubtractionPage(),
    },
    {
      'label': 'Multiplication',
      'icon': Icons.clear,
      'emoji': '✖️',
      'gradient': [Color(0xFF56D97F), Color(0xFF81E89E)],
      'page': () => MultiplicationPage(),
    },
    {
      'label': 'Division',
      'icon': Icons.percent,
      'emoji': '➗',
      'gradient': [Color(0xFF45B7D1), Color(0xFF74C9DB)],
      'page': () => DivisionPage(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("🔢", style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              "Math Problems",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Text("🧮", style: TextStyle(fontSize: 24)),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: mathOperations.length,
          itemBuilder: (context, index) {
            final item = mathOperations[index];
            final gradient = item['gradient'] as List<Color>;

            return AnimatedBuilder(
              animation: _floatController,
              builder: (_, child) {
                final offset = (index % 2 == 0)
                    ? _floatAnimation.value
                    : -_floatAnimation.value;
                return Transform.translate(
                  offset: Offset(0, offset),
                  child: child,
                );
              },
              child: _buildMathCard(item, gradient),
            );
          },
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildMathCard(Map<String, dynamic> item, List<Color> gradient) {
    return GestureDetector(
      onTap: () => Get.to(item['page']),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -15,
              right: -15,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          item['emoji'],
                          style: TextStyle(fontSize: 42),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      item['label'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
//                MATH TEMPLATE SCREEN
//////////////////////////////////////////////////////////
class MathGridTemplate extends StatefulWidget {
  final String title;
  final String operator;
  final String emoji;
  final List<Color> themeGradient;

  const MathGridTemplate({
    Key? key,
    required this.title,
    required this.operator,
    required this.emoji,
    required this.themeGradient,
  }) : super(key: key);

  @override
  State<MathGridTemplate> createState() => _MathGridTemplateState();
}

class _MathGridTemplateState extends State<MathGridTemplate>
    with TickerProviderStateMixin {
  final Random _random = Random();
  final FlutterTts flutterTts = FlutterTts();
  List<String> problems = [];
  int selectedIndex = -1;

  late AnimationController _floatController;
  late AnimationController _pulseController;
  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;

  final List<List<Color>> cardGradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
    [Color(0xFF56D97F), Color(0xFF81E89E)],
    [Color(0xFF45B7D1), Color(0xFF74C9DB)],
    [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
    [Color(0xFFFF6EB4), Color(0xFFFF9ECE)],
    [Color(0xFFFFE66D), Color(0xFFFFF59D)],
    [Color(0xFF4ECDC4), Color(0xFF7EDDD6)],
  ];

  @override
  void initState() {
    super.initState();
    generateProblems();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  void generateProblems() {
    problems = List.generate(90, (index) {
      int a = _random.nextInt(10) + 1;
      int b = _random.nextInt(10) + 1;

      if (widget.operator == '-') {
        if (a < b) {
          int t = a;
          a = b;
          b = t;
        }
      } else if (widget.operator == '÷') {
        b = _random.nextInt(9) + 1;
        a = b * (_random.nextInt(10) + 1);
        return "$a ÷ $b = ${a ~/ b}";
      }

      if (widget.operator == '×') return "$a × $b = ${a * b}";
      if (widget.operator == '+') return "$a + $b = ${a + b}";
      if (widget.operator == '-') return "$a - $b = ${a - b}";
      return "$a * $b = ${a * b}";
    });
  }

  void _speak(String text) async {
    await flutterTts.stop();
    await flutterTts.speak(text
        .replaceAll('×', 'times')
        .replaceAll('÷', 'divided by')
        .replaceAll('+', 'plus')
        .replaceAll('-', 'minus')
        .replaceAll('=', 'equals'));
  }

  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndex == index) {
        selectedIndex = -1;
      } else {
        selectedIndex = index;
        _speak(problems[index]);
      }
    });
  }

  List<Color> _getGradient(int index) {
    return cardGradients[index % cardGradients.length];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.emoji, style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Text("🌟", style: TextStyle(fontSize: 24)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                generateProblems();
                selectedIndex = -1;
              });
            },
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
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: problems.length,
          itemBuilder: (context, index) {
            final gradient = _getGradient(index);
            final isSelected = selectedIndex == index;

            return AnimatedBuilder(
              animation: _floatController,
              builder: (_, child) {
                final offset = (index % 2 == 0)
                    ? _floatAnimation.value
                    : -_floatAnimation.value;
                return Transform.translate(
                  offset: Offset(0, offset),
                  child: child,
                );
              },
              child: _buildProblemCard(problems[index], gradient, isSelected, index),
            );
          },
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildProblemCard(String problem, List<Color> gradient, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => _toggleSelection(index),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? _pulseAnimation.value : 1.0,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSelected
                  ? [Color(0xFFFFD700), Color(0xFFFFA500)]
                  : gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: (isSelected ? Color(0xFFFFD700) : gradient[0]).withOpacity(0.4),
                blurRadius: isSelected ? 15 : 8,
                offset: Offset(0, 6),
                spreadRadius: isSelected ? 2 : 0,
              ),
            ],
            border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          ),
          child: Stack(
            children: [
              Positioned(
                top: -15,
                right: -15,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    problem,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Text("⭐", style: TextStyle(fontSize: 16)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
//                INDIVIDUAL OPERATION PAGES
//////////////////////////////////////////////////////////
class AdditionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MathGridTemplate(
        title: "Addition",
        operator: '+',
        emoji: '➕',
        themeGradient: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
      );
}

class SubtractionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MathGridTemplate(
        title: "Subtraction",
        operator: '-',
        emoji: '➖',
        themeGradient: [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
      );
}

class MultiplicationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MathGridTemplate(
        title: "Multiplication",
        operator: '×',
        emoji: '✖️',
        themeGradient: [Color(0xFF56D97F), Color(0xFF81E89E)],
      );
}

class DivisionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MathGridTemplate(
        title: "Division",
        operator: '÷',
        emoji: '➗',
        themeGradient: [Color(0xFF45B7D1), Color(0xFF74C9DB)],
      );
}
