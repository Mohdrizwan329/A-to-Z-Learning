import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/view/learn set/Animal_Name_Learning_Page.dart';
import 'package:learning_a_to_z/view/learn set/Bird_Name_Learning_Page.dart';
import 'package:learning_a_to_z/view/learn set/Color_name_learning_page.dart';
import 'package:learning_a_to_z/view/learn set/Flower_Name_Learning_Page.dart';
import 'package:learning_a_to_z/view/learn set/Fruit_Name_Learning_Page.dart';
import 'package:learning_a_to_z/view/learn%20set/bodyparts_name_learning_page.dart';
import 'package:learning_a_to_z/view/learn%20set/month_name_learning_page.dart';
import 'package:learning_a_to_z/view/learn%20set/vegetables_name_learning_page.dart';
import 'package:learning_a_to_z/view/learn%20set/week_day_learning_page.dart';

class LearningSetsGridScreen extends StatefulWidget {
  const LearningSetsGridScreen({super.key});

  @override
  State<LearningSetsGridScreen> createState() => _LearningSetsGridScreenState();
}

class _LearningSetsGridScreenState extends State<LearningSetsGridScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  final List<Map<String, dynamic>> learningItems = [
    {'label': 'Animals', 'emoji': '🦁', 'gradient': [Color(0xFFFF6B6B), Color(0xFFFF8E8E)], 'pageBuilder': () => AnimalLearningPage()},
    {'label': 'Birds', 'emoji': '🦅', 'gradient': [Color(0xFF45B7D1), Color(0xFF74C9DB)], 'pageBuilder': () => BirdLearningPage()},
    {'label': 'Flowers', 'emoji': '🌸', 'gradient': [Color(0xFFFF6EB4), Color(0xFFFF9ECE)], 'pageBuilder': () => FlowerLearningPage()},
    {'label': 'Fruits', 'emoji': '🍎', 'gradient': [Color(0xFF56D97F), Color(0xFF81E89E)], 'pageBuilder': () => FruitLearningPage()},
    {'label': 'Vegetables', 'emoji': '🥕', 'gradient': [Color(0xFFFFAA5A), Color(0xFFFFCB80)], 'pageBuilder': () => VegetablesLearningPage()},
    {'label': 'Colors', 'emoji': '🌈', 'gradient': [Color(0xFFA78BFA), Color(0xFFC4B5FD)], 'pageBuilder': () => ColorsLearningPage()},
    {'label': 'Days', 'emoji': '📅', 'gradient': [Color(0xFF4ECDC4), Color(0xFF7EDDD6)], 'pageBuilder': () => WeekDayLearningPage()},
    {'label': 'Months', 'emoji': '🗓️', 'gradient': [Color(0xFF5C6BC0), Color(0xFF8E99D4)], 'pageBuilder': () => MonthLearningPage()},
    {'label': 'Body Parts', 'emoji': '🤚', 'gradient': [Color(0xFFEC407A), Color(0xFFF06292)], 'pageBuilder': () => BodyPartsLearningPage()},
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
            Text("📚", style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              "Learning Sets",
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
          itemCount: learningItems.length,
          itemBuilder: (context, index) {
            final item = learningItems[index];

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
              child: _buildCard(item, index),
            );
          },
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildCard(Map<String, dynamic> item, int index) {
    final List<Color> gradient = item['gradient'];

    return GestureDetector(
      onTap: () => Get.to(item['pageBuilder']),
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
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
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
                        child: Text(item['emoji'], style: TextStyle(fontSize: 42)),
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
                          Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2),
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
