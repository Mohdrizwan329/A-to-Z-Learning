import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view%20model/learn%20set%20controller/stories_controller.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

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
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.refresh, color: Colors.white, size: 20.r),
          ),
          onPressed: () => controller.resetProgress(),
        ),
      ],
      onBackPressed: () {
        controller.stopReading();
        Get.back();
      },
      body: Column(
        children: [
          // Progress bar with percentage
          Obx(() {
            final progress = controller.progressPercentage / 100;
            final progressString = controller.progressString;
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // The reader's font size can be 30% larger than this row was drawn for.
                      Flexible(
                        child: const Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '$progressString completed',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10.h,
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
              padding: EdgeInsets.all(16.r),
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
                      onTap: () {
                        TtsService.to.speak(story['title']!);
                        _openStoryDetail(index);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withValues(alpha: 0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 10.r,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 75.w,
                                  height: 75.h,
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
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        story['title']!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        story['moral']!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
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
                                  size: 20.r,
                                ),
                              ],
                            ),
                            if (isCompleted)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(3.r),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14.r,
                                  ),
                                ),
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
    // Mark as completed when card is tapped
    controller.markStoryCompleted(index);

    Get.to(
      () => StoryDetailPage(initialIndex: index, controller: controller),
    )?.then((_) {
      // Refresh completed stories when coming back
      controller.refreshCompletedStories();
    });
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

class _StoryDetailPageState extends State<StoryDetailPage>
    with TickerProviderStateMixin {
  late int currentIndex;
  int highlightedLineIndex = -1;
  int highlightedWordIndex = -1;

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;

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
      if (!mounted) return;
      setState(() {
        highlightedLineIndex = -1;
        highlightedWordIndex = -1;
      });
    } else {
      widget.controller.startSpeakingWithHighlight(
        currentIndex,
        onLineChanged: (lineIndex) {
          if (!mounted) return;
          setState(() {
            highlightedLineIndex = lineIndex;
            highlightedWordIndex = -1;
          });
        },
        onWordChanged: (wordIndex) {
          if (!mounted) return;
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
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.refresh, color: Colors.white, size: 20.r),
          ),
          onPressed: () {
            widget.controller.stopReading();
            setState(() {
              highlightedLineIndex = -1;
              highlightedWordIndex = -1;
            });
            _startReadingWithHighlight();
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
            LayoutBuilder(
              // Portrait-shaped content: in landscape the body is barely 300pt tall,
              // which is shorter than this column needs. Scroll when that happens and
              // stay exactly as before whenever there is room.
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Emoji header with float animation
                      AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnimation.value * 0.5),
                            child: child,
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(16.r),
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFF6B6B),
                                Color(0xFFFF8E53),
                                Color(0xFFFFAA5A),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF6B6B).withValues(alpha: 0.4),
                                blurRadius: 15.r,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() {
                                final isReading =
                                    widget.controller.isReading.value;
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isReading)
                                      Text(
                                        "📖 ",
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    Text(
                                      story['emoji']!,
                                      style: TextStyle(fontSize: 60),
                                    ),
                                    if (isReading)
                                      Text(
                                        " 📚",
                                        style: TextStyle(fontSize: 24),
                                      ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),

                      // Play/Stop button with float animation
                      AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -_floatAnimation.value * 0.3),
                            child: child,
                          );
                        },
                        child: Obx(
                          () => GestureDetector(
                            onTap: _startReadingWithHighlight,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: widget.controller.isReading.value
                                      ? [Color(0xFFEF4444), Color(0xFFF87171)]
                                      : [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30.r),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (widget.controller.isReading.value
                                                ? Color(0xFFEF4444)
                                                : Color(0xFF4ECDC4))
                                            .withValues(alpha: 0.4),
                                    blurRadius: 10.r,
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
                                    size: 28.r,
                                  ),
                                  SizedBox(width: 8.w),
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
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Story content with highlighting and float animation
                      SizedBox(
                        // A share of the viewport rather than `Expanded`:
                        // `Expanded` inside a scroll view needs an `IntrinsicHeight`
                        // above it, and a scrollable cannot report an intrinsic
                        // height - it throws.
                        height: math.max(200.h, constraints.maxHeight * 0.55),
                        child: AnimatedBuilder(
                          animation: _floatController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _floatAnimation.value * 0.4),
                              child: child,
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFF6B6B),
                                  Color(0xFFFF8E53),
                                  Color(0xFFFFAA5A),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(
                                    0xFFFF6B6B,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 15.r,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: lines.length,
                              itemBuilder: (context, index) {
                                final line = lines[index];
                                final isHighlighted =
                                    highlightedLineIndex == index;

                                if (!isHighlighted) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                    ),
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
                                    margin: EdgeInsets.symmetric(vertical: 6.h),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 12.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.4,
                                        ),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      children: List.generate(words.length, (
                                        wIndex,
                                      ) {
                                        final word = words[wIndex];
                                        final isWordHighlighted =
                                            wIndex == highlightedWordIndex;
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 2.w,
                                            vertical: 2.h,
                                          ),
                                          padding: isWordHighlighted
                                              ? EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 4.h,
                                                )
                                              : EdgeInsets.zero,
                                          decoration: isWordHighlighted
                                              ? BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFFFFD700),
                                                      Color(0xFFFFA500),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        8.r,
                                                      ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(
                                                        0xFFFFD700,
                                                      ).withValues(alpha: 0.5),
                                                      blurRadius: 8.r,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                )
                                              : null,
                                          child: Text(
                                            isWordHighlighted ? word : '$word ',
                                            style: TextStyle(
                                              fontSize: isWordHighlighted
                                                  ? 22
                                                  : 20,
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
                      ),

                      SizedBox(height: 16.h),

                      // Navigation buttons
                      Container(
                        margin: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          bottom: 8.h,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF667EEA).withValues(alpha: 0.4),
                              blurRadius: 10.r,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Equal shares for the two buttons: 'Previous' and
                            // 'Next' either side of the counter are wider than a
                            // small phone.
                            Flexible(
                              child: _buildNavButton(
                                icon: Icons.arrow_back_ios,
                                label: 'Previous',
                                gradientColors: [
                                  Color(0xFFEC4899),
                                  Color(0xFFF472B6),
                                ],
                                onTap: currentIndex > 0 ? _goToPrevious : null,
                              ),
                            ),
                            // Counter badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFF6B6B),
                                    Color(0xFFFF8E53),
                                    Color(0xFFFFAA5A),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(
                                      0xFFFF6B6B,
                                    ).withValues(alpha: 0.4),
                                    blurRadius: 6.r,
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
                            Flexible(
                              child: _buildNavButton(
                                icon: Icons.arrow_forward_ios,
                                label: 'Next',
                                gradientColors: [
                                  Color(0xFF3B82F6),
                                  Color(0xFF60A5FA),
                                ],
                                onTap:
                                    currentIndex <
                                        widget.controller.stories.length - 1
                                    ? _goToNext
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: gradientColors[0].withValues(alpha: 0.4),
                    blurRadius: 8.r,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18.r),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
