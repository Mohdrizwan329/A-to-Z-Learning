import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/alphabet%20controller/world_meaning_alphabet_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';

class AlphabetMening extends StatefulWidget {
  const AlphabetMening({super.key});

  @override
  State<AlphabetMening> createState() => _AlphabetMeningState();
}

class _AlphabetMeningState extends State<AlphabetMening>
    with TickerProviderStateMixin {
  final WorldMeaningAlphabetController controller = Get.put(
    WorldMeaningAlphabetController(),
  );

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
    [Color(0xFF5C6BC0), Color(0xFF8E99D4)],
    [Color(0xFFEC407A), Color(0xFFF06292)],
    [Color(0xFF26C6DA), Color(0xFF4DD0E1)],
    [Color(0xFFAB47BC), Color(0xFFCE93D8)],
    [Color(0xFFFF7043), Color(0xFFFF8A65)],
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
            Text("🔤", style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              "A to Z Words",
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
            onPressed: () => controller.clearCache(),
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
          itemCount: controller.alphabetData.length,
          itemBuilder: (context, index) {
            final item = controller.alphabetData[index];
            final gradient = _getGradient(index);

            return Obx(() {
              final isSelected = controller.selectedIndexes.contains(index);

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
                child: _buildLetterCard(item, gradient, isSelected, index),
              );
            });
          },
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildLetterCard(Map<String, String> item, List<Color> gradient, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => controller.toggleSelection(index: index, showSnack: _showSnack),
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
                      Text(
                        item['letter']!,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 0.9,
                          shadows: [
                            Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            item['emoji']!,
                            style: TextStyle(fontSize: 42),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item['meaning']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isSelected)
                Positioned(top: 8, left: 8, child: Text("⭐", style: TextStyle(fontSize: 16))),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
