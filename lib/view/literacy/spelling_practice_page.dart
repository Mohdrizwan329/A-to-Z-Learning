import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view%20model/spelling_practice_controller/spelling_practice_controller.dart';
import 'package:jiyan_learning/view/literacy/spelling_practice_detail_page.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class SpellingPracticePage extends StatefulWidget {
  const SpellingPracticePage({super.key});

  @override
  State<SpellingPracticePage> createState() => _SpellingPracticePageState();
}

class _SpellingPracticePageState extends State<SpellingPracticePage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  late final SpellingPracticeController controller;
  int selectedIndex = -1;

  final List<Map<String, dynamic>> levelCards = [
    {
      'name': 'Easy',
      'emoji': '🔤',
      'subtitle': '3-4 Letter Words',
      'levelIndex': 0,
    },
    {
      'name': 'Medium',
      'emoji': '📝',
      'subtitle': '5-6 Letter Words',
      'levelIndex': 1,
    },
    {
      'name': 'Hard',
      'emoji': '🏆',
      'subtitle': '7+ Letter Words',
      'levelIndex': 2,
    },
    {
      'name': 'Animals',
      'emoji': '🦁',
      'subtitle': 'Animal Names',
      'levelIndex': 3,
    },
    {
      'name': 'Food & Fruits',
      'emoji': '🍎',
      'subtitle': 'Food Spelling',
      'levelIndex': 4,
    },
    {
      'name': 'Nature',
      'emoji': '🌿',
      'subtitle': 'Nature Words',
      'levelIndex': 5,
    },
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.put(SpellingPracticeController());
    initGridAnimations(this, floatRange: 2.0, pulseMax: 1.0);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Spelling Practice',
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.refresh, color: Colors.white, size: 20),
          ),
          onPressed: () {
            controller.resetProgress();
            setState(() {});
          },
        ),
      ],
      body: Column(
        children: [
          // Progress bar
          Obx(() {
            int levelsCompleted = 0;
            final totalLevels =
                SpellingPracticeController.progressKeys.length;
            for (var key in SpellingPracticeController.progressKeys) {
              final completed = ProgressService.to.getCompletedCount(key);
              final total = ProgressService.to.getTotalCount(key);
              if (total > 0 && completed >= total) {
                levelsCompleted++;
              }
            }
            final progress =
                totalLevels > 0 ? levelsCompleted / totalLevels : 0.0;
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$levelsCompleted/$totalLevels completed',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          // Level cards grid (2x2)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: levelCards.length,
              itemBuilder: (context, index) {
                final card = levelCards[index];
                final gradient = AppColors.getGradientForIndex(index);
                final levelIndex = card['levelIndex'] as int;
                final progressKey =
                    SpellingPracticeController.progressKeys[levelIndex];

                return Obx(() {
                  final isSelected = selectedIndex == index;
                  final completed =
                      ProgressService.to.getCompletedCount(progressKey);
                  final total =
                      ProgressService.to.getTotalCount(progressKey);

                  return buildFloatingItem(
                    index: index,
                    child: GradientCard(
                      gradient: gradient,
                      isSelected: isSelected,
                      showDecorations: true,
                      onTap: () {
                        TtsService.to.speak(card['name']);
                        setState(() {
                          selectedIndex = index;
                        });
                        controller.selectLevel(levelIndex);
                        Get.to(() => SpellingPracticeDetailPage(
                              levelIndex: levelIndex,
                            ));
                      },
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withValues(alpha: 0.25),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      card['emoji'],
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  card['name'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  card['subtitle'],
                                  style: GoogleFonts.nunito(
                                    fontSize: 11,
                                    color:
                                        Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$completed/$total',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Checkmark if all completed
                          if (completed >= total && total > 0)
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SizedBox.shrink(),
    );
  }
}
