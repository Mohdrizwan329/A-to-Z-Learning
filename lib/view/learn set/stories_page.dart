import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view%20model/learn%20set%20controller/stories_controller.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage>
    with TickerProviderStateMixin {
  final controller = Get.put(StoriesController());
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
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
    return GradientScaffold(
      title: 'Moral Stories',
      emoji: '',
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
          onPressed: () => controller.resetProgress(),
        ),
      ],
      onBackPressed: () {
        controller.stopReading();
        Get.back();
      },
      bottomNavigationBar: const AdsScreen(),
      body: Column(
        children: [
          // Progress bar with percentage
          Obx(() {
            final progress = controller.progressPercentage / 100;
            final progressString = controller.progressString;
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                        '$progressString completed',
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
          Expanded(
            child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.stories.length,
          itemBuilder: (context, index) {
            final story = controller.stories[index];
            final color = Color(story['color'] as int);

            return Obx(() {
              // Access reactive list to trigger rebuild when stories are completed
              final _ = controller.completedStories.length;
              final isCompleted = controller.isStoryCompleted(index);

              return AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  final offset = (index % 2 == 0)
                      ? _floatAnimation.value * 0.5
                      : -_floatAnimation.value * 0.5;
                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: child,
                  );
                },
                child: GestureDetector(
                onTap: () => _openStoryDetail(index),
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            story['emoji']!,
                            style: TextStyle(fontSize: 42),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    story['title']!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                if (isCompleted)
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: color,
                                      size: 16,
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              story['moral']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.9),
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              );
            });
          },
            ),
          ),
        ],
      ),
    );
  }

  void _openStoryDetail(int index) {
    Get.to(() => StoryDetailPage(
          initialIndex: index,
          controller: controller,
        ));
  }
}

class StoryDetailPage extends StatefulWidget {
  final int initialIndex;
  final StoriesController controller;

  const StoryDetailPage({
    super.key,
    required this.initialIndex,
    required this.controller,
  });

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  late int currentIndex;
  int highlightedLineIndex = -1;
  int highlightedWordIndex = -1;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _goToPrevious() {
    if (currentIndex > 0) {
      widget.controller.stopReading();
      setState(() {
        currentIndex--;
        highlightedLineIndex = -1;
        highlightedWordIndex = -1;
      });
    }
  }

  void _goToNext() {
    if (currentIndex < widget.controller.stories.length - 1) {
      widget.controller.stopReading();
      setState(() {
        currentIndex++;
        highlightedLineIndex = -1;
        highlightedWordIndex = -1;
      });
    }
  }

  void _startReadingWithHighlight() {
    if (widget.controller.isReading.value) {
      widget.controller.stopReading();
      setState(() {
        highlightedLineIndex = -1;
        highlightedWordIndex = -1;
      });
    } else {
      widget.controller.startSpeakingWithHighlight(
        currentIndex,
        onLineChanged: (lineIndex) {
          setState(() {
            highlightedLineIndex = lineIndex;
            highlightedWordIndex = -1;
          });
        },
        onWordChanged: (wordIndex) {
          setState(() {
            highlightedWordIndex = wordIndex;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.controller.stories[currentIndex];
    final lines = widget.controller.getLinesForStory(currentIndex);

    return GradientScaffold(
      title: story['title']!,
      emoji: '',
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
            widget.controller.stopReading();
            setState(() {
              highlightedLineIndex = -1;
              highlightedWordIndex = -1;
            });
          },
        ),
      ],
      onBackPressed: () {
        widget.controller.stopReading();
        Get.back();
      },
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              // This triggers rebuild when isReading changes
              final _ = widget.controller.isReading.value;
              return Container();
            }),
            Column(
              children: [
                // Emoji header
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFF6B6B).withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        final isReading = widget.controller.isReading.value;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isReading)
                              Text("📖 ", style: TextStyle(fontSize: 24)),
                            Text(story['emoji']!, style: TextStyle(fontSize: 60)),
                            if (isReading)
                              Text(" 📚", style: TextStyle(fontSize: 24)),
                          ],
                        );
                      }),
                    ],
                  ),
                ),

                // Play/Stop button
                Obx(() => GestureDetector(
                      onTap: _startReadingWithHighlight,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: widget.controller.isReading.value
                                ? [Color(0xFFEF4444), Color(0xFFF87171)]
                                : [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: (widget.controller.isReading.value
                                      ? Color(0xFFEF4444)
                                      : Color(0xFF4ECDC4))
                                  .withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.controller.isReading.value
                                  ? Icons.stop
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Text(
                              widget.controller.isReading.value
                                  ? 'Stop Reading'
                                  : 'Read Story',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

                SizedBox(height: 16),

                // Story content with highlighting
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFF6B6B).withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: lines.length,
                      itemBuilder: (context, index) {
                        final line = lines[index];
                        final isHighlighted = highlightedLineIndex == index;

                        if (!isHighlighted) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              line,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          final words = line.split(' ');
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: List.generate(words.length, (wIndex) {
                                final word = words[wIndex];
                                final isWordHighlighted =
                                    wIndex == highlightedWordIndex;
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 2),
                                  padding: isWordHighlighted
                                      ? EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4)
                                      : EdgeInsets.zero,
                                  decoration: isWordHighlighted
                                      ? BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFFFD700),
                                              Color(0xFFFFA500)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFFFFD700)
                                                  .withValues(alpha: 0.5),
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        )
                                      : null,
                                  child: Text(
                                    isWordHighlighted ? word : '$word ',
                                    style: TextStyle(
                                      fontSize: isWordHighlighted ? 22 : 20,
                                      fontWeight: isWordHighlighted
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: Colors.white,
                                      height: 1.4,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Navigation buttons
                Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF667EEA).withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavButton(
                        icon: Icons.arrow_back_ios,
                        label: 'Previous',
                        gradientColors: [Color(0xFFEC4899), Color(0xFFF472B6)],
                        onTap: currentIndex > 0 ? _goToPrevious : null,
                      ),
                      // Counter badge
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFF6B6B).withValues(alpha: 0.4),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${currentIndex + 1} / ${widget.controller.stories.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildNavButton(
                        icon: Icons.arrow_forward_ios,
                        label: 'Next',
                        gradientColors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                        onTap: currentIndex <
                                widget.controller.stories.length - 1
                            ? _goToNext
                            : null,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required List<Color> gradientColors,
    VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.grey.shade400, Colors.grey.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: gradientColors[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
