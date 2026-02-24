import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
// Generic Math Questions Page - replaces 4 individual pages
import 'package:jiyan_learning/view/math%20qustion/generic_math_questions_page.dart';
import 'package:jiyan_learning/view%20model/qustion%20controller/generic_math_questions_controller.dart';

class MathQustionGridScreen extends StatefulWidget {
  @override
  State<MathQustionGridScreen> createState() => _MathQustionGridScreenState();
}

class _MathQustionGridScreenState extends State<MathQustionGridScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  final List<Map<String, dynamic>> mathItems = [
    {
      'label': 'Addition',
      'emoji': '➕',
      'gradient': [Color(0xFF56D97F), Color(0xFF81E89E)],
      'pageBuilder': () => GenericMathQuestionsPage(operationType: MathOperationType.addition),
      'progressKey': ProgressService.kMathAddition,
    },
    {
      'label': 'Subtraction',
      'emoji': '➖',
      'gradient': [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
      'pageBuilder': () => GenericMathQuestionsPage(operationType: MathOperationType.subtraction),
      'progressKey': ProgressService.kMathSubtraction,
    },
    {
      'label': 'Multiplication',
      'emoji': '✖️',
      'gradient': [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
      'pageBuilder': () => GenericMathQuestionsPage(operationType: MathOperationType.multiplication),
      'progressKey': ProgressService.kMathMultiplication,
    },
    {
      'label': 'Division',
      'emoji': '➗',
      'gradient': [Color(0xFF45B7D1), Color(0xFF74C9DB)],
      'pageBuilder': () => GenericMathQuestionsPage(operationType: MathOperationType.division),
      'progressKey': ProgressService.kMathDivision,
    },
  ];

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -5, end: 5).animate(
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

    return GradientScaffold(
      title: 'Math Practice',
      emoji: '🧮',
      bottomNavigationBar: const AdsScreen(),
      body: GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.8,
          ),
          itemCount: mathItems.length,
          itemBuilder: (context, index) {
            final item = mathItems[index];

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
              child: _buildMathCard(item, index),
            );
          },
        ),
    );
  }

  Widget _buildMathCard(Map<String, dynamic> item, int index) {
    final List<Color> gradient = item['gradient'];
    final String? progressKey = item['progressKey'];

    return GestureDetector(
      onTap: () => Get.to(item['pageBuilder']),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.5),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -25,
              right: -25,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -35,
              left: -35,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(item['emoji'], style: TextStyle(fontSize: 56)),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    item['label'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black26, offset: Offset(1, 2), blurRadius: 3),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Progress indicator
            if (progressKey != null)
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Obx(() {
                  final progress = ProgressService.to.getProgressPercentage(progressKey);
                  final progressStr = ProgressService.to.getProgressString(progressKey);
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress / 100,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progress == 100 ? Colors.green : Colors.white,
                          ),
                          minHeight: 6,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        progressStr,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}
