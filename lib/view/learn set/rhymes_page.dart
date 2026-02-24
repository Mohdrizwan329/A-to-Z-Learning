import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view%20model/learn%20set%20controller/rhymes_controller.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class RhymesPage extends StatefulWidget {
  const RhymesPage({super.key});

  @override
  State<RhymesPage> createState() => _RhymesPageState();
}

class _RhymesPageState extends State<RhymesPage> with TickerProviderStateMixin {
  final controller = Get.put(RhymesController());
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Rhymes & Songs',
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
        controller.stopSinging();
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
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: controller.rhymes.length,
              itemBuilder: (context, index) {
                final rhyme = controller.rhymes[index];
                final color = Color(rhyme['color'] as int);

                return Obx(() {
                  // Access reactive list to trigger rebuild when rhymes are completed
                  final _ = controller.completedRhymes.length;
                  final isCompleted = controller.isRhymeCompleted(index);

                  return GestureDetector(
                    onTap: () => _openRhymeDetail(index),
                    child: AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, index % 2 == 0 ? _bounceAnimation.value : -_bounceAnimation.value),
                          child: child,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withValues(alpha: 0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Decorative circles
                            Positioned(
                              top: -20,
                              right: -20,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                            ),
                            // Content
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                          rhyme['emoji']!,
                                          style: TextStyle(fontSize: 42),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      rhyme['title']!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.1,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Completed badge
                            if (isCompleted)
                              Positioned(
                                bottom: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
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

  void _openRhymeDetail(int index) {
    // Mark as completed when card is tapped
    controller.markRhymeCompleted(index);

    Get.to(() => RhymeDetailPage(
          initialIndex: index,
          controller: controller,
        ))?.then((_) {
      // Refresh completed rhymes when coming back from detail page
      controller.refreshCompletedRhymes();
    });
  }
}

class RhymeDetailPage extends StatefulWidget {
  final int initialIndex;
  final RhymesController controller;

  const RhymeDetailPage({
    super.key,
    required this.initialIndex,
    required this.controller,
  });

  @override
  State<RhymeDetailPage> createState() => _RhymeDetailPageState();
}

class _RhymeDetailPageState extends State<RhymeDetailPage>
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

  void _startSinging() {
    if (widget.controller.isSinging.value) {
      widget.controller.stopSinging();
      if (!mounted) return;
      setState(() {
        highlightedLineIndex = -1;
        highlightedWordIndex = -1;
      });
      return;
    }

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

  void _goToPrevious() {
    if (currentIndex > 0) {
      widget.controller.stopSinging();
      setState(() {
        currentIndex--;
        highlightedLineIndex = -1;
        highlightedWordIndex = -1;
      });
    }
  }

  void _goToNext() {
    if (currentIndex < widget.controller.rhymes.length - 1) {
      widget.controller.stopSinging();
      setState(() {
        currentIndex++;
        highlightedLineIndex = -1;
        highlightedWordIndex = -1;
      });
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    widget.controller.stopSinging();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rhyme = widget.controller.rhymes[currentIndex];
    final color = Color(rhyme['color'] as int);
    final lines = widget.controller.getLinesForRhyme(currentIndex);

    return GradientScaffold(
      title: rhyme['title']!,
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
            widget.controller.stopSinging();
            setState(() {
              highlightedLineIndex = -1;
              highlightedWordIndex = -1;
            });
            _startSinging();
          },
        ),
      ],
      onBackPressed: () {
        widget.controller.stopSinging();
        Get.back();
      },
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative stars
            ...List.generate(20, (index) {
              return Positioned(
                left: (index * 37) % MediaQuery.of(context).size.width,
                top: (index * 53) % 400,
                child: Icon(
                  Icons.star,
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 8 + (index % 3) * 4,
                ),
              );
            }),
            Column(
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
                          final isSinging = widget.controller.isSinging.value;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSinging)
                                Text("🎵 ", style: TextStyle(fontSize: 24)),
                              Text(rhyme['emoji']!, style: TextStyle(fontSize: 60)),
                              if (isSinging)
                                Text(" 🎶", style: TextStyle(fontSize: 24)),
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
                  child: Obx(() => ElevatedButton.icon(
                      onPressed: _startSinging,
                      icon: Icon(
                        widget.controller.isSinging.value
                            ? Icons.stop_circle
                            : Icons.play_circle_fill,
                        size: 28,
                      ),
                      label: Text(
                        widget.controller.isSinging.value ? 'Stop' : 'Sing Along',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.controller.isSinging.value
                            ? Colors.red
                            : color,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    )),
                ),

                SizedBox(height: 16),

                // Lyrics with highlighting and float animation
                Expanded(
                  child: AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value * 0.4),
                        child: child,
                      );
                    },
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
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                                  margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                  padding: isWordHighlighted
                                      ? EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                                      : EdgeInsets.zero,
                                  decoration: isWordHighlighted
                                      ? BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFFFFD700).withValues(alpha: 0.5),
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
                ),

                SizedBox(height: 16),

                // Navigation
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentIndex > 0)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFEC4899).withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _goToPrevious,
                            icon: Icon(Icons.skip_previous),
                            label: Text('Previous'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        )
                      else
                        SizedBox(width: 120),
                      // Page counter badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                          '${currentIndex + 1} / ${widget.controller.rhymes.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (currentIndex < widget.controller.rhymes.length - 1)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF3B82F6).withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _goToNext,
                            icon: Icon(Icons.skip_next),
                            label: Text('Next'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        )
                      else
                        SizedBox(width: 120),
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
}
