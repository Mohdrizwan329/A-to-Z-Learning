import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/qustion%20controller/multiplication_questions_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';

class MultiplicationQuestionsScreen extends StatefulWidget {
  const MultiplicationQuestionsScreen({super.key});

  @override
  State<MultiplicationQuestionsScreen> createState() =>
      _MultiplicationQuestionsScreenState();
}

class _MultiplicationQuestionsScreenState extends State<MultiplicationQuestionsScreen>
    with TickerProviderStateMixin {
  final MultiplicationController controller = Get.put(MultiplicationController());

  late AnimationController _floatController;
  late AnimationController _pulseController;
  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;

  final List<int> selectedIndexes = [];

  final List<List<Color>> cardGradients = [
    [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
    [Color(0xFF56D97F), Color(0xFF81E89E)],
    [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    [Color(0xFF45B7D1), Color(0xFF74C9DB)],
    [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
    [Color(0xFFFF6EB4), Color(0xFFFF9ECE)],
    [Color(0xFFFFE66D), Color(0xFFFFF59D)],
    [Color(0xFF4ECDC4), Color(0xFF7EDDD6)],
    [Color(0xFF5C6BC0), Color(0xFF8E99D4)],
    [Color(0xFFEC407A), Color(0xFFF06292)],
  ];

  @override
  void initState() {
    super.initState();

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
    super.dispose();
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
          children: const [
            Text("✖️", style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              "Multiplication",
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
                controller.reset();
                selectedIndexes.clear();
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
            childAspectRatio: 0.9,
          ),
          itemCount: controller.questions.length,
          itemBuilder: (context, index) {
            final question = controller.questions[index];
            final gradient = _getGradient(index);
            final isSelected = selectedIndexes.contains(index);

            if (!controller.isInCurrentBatch(index) && !question.isAnswered) {
              return _buildLockedCard();
            }

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
              child: _buildQuestionCard(question, gradient, isSelected, index),
            );
          },
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildLockedCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, color: Colors.grey.shade600, size: 40),
            SizedBox(height: 8),
            Text("Locked", style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(dynamic question, List<Color> gradient, bool isSelected, int index) {
    final isAnswered = question.isAnswered;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedIndexes.remove(index);
          } else {
            selectedIndexes.add(index);
          }
        });
      },
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
              colors: isAnswered
                  ? [Color(0xFF56D97F), Color(0xFF81E89E)]
                  : isSelected
                      ? [Color(0xFFFFD700), Color(0xFFFFA500)]
                      : gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (isSelected ? Color(0xFFFFD700) : gradient[0]).withOpacity(0.4),
                blurRadius: isSelected ? 15 : 8,
                offset: Offset(0, 4),
                spreadRadius: isSelected ? 2 : 0,
              ),
            ],
            border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          ),
          child: Stack(
            children: [
              Positioned(top: -10, right: -10, child: Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.15)))),
              Positioned(bottom: -15, left: -15, child: Container(width: 50, height: 50, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)))),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${question.num1} × ${question.num2}",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black26, offset: Offset(1, 2), blurRadius: 3)]),
                    ),
                    SizedBox(height: 12),
                    if (!isAnswered)
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: question.controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            hintText: "Answer",
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                    if (isAnswered)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
                        child: Text(question.result, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),
                    SizedBox(height: 12),
                    if (!isAnswered)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            controller.checkAnswer(index, context);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: gradient[0],
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 4,
                        ),
                        child: Text("Submit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    if (isAnswered) Text("✅", style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),
              if (isSelected) Positioned(top: 6, left: 6, child: Text("⭐", style: TextStyle(fontSize: 14))),
            ],
          ),
        ),
      ),
    );
  }
}
