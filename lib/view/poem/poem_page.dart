import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/view%20model/poem%20controller/poem_detail_controller.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class PoemListPage extends StatefulWidget {
  const PoemListPage({super.key});

  @override
  State<PoemListPage> createState() => _PoemListPageState();
}

class _PoemListPageState extends State<PoemListPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final List<Poem> poems = [
    Poem(
      title: 'Twinkle Twinkle',
      content:
          '''Twinkle, twinkle, little star,\nHow I wonder what you are!\nUp above the world so high,\nLike a diamond in the sky.''',
      audioPath: 'assets/audio/twinkle.mp3',
    ),
    Poem(
      title: 'Baa Baa Black Sheep',
      content:
          '''Baa, baa, black sheep,\nHave you any wool?\nYes sir, yes sir,\nThree bags full.''',
      audioPath: 'assets/audio/baa.mp3',
    ),
    Poem(
      title: 'Humpty Dumpty',
      content:
          '''Humpty Dumpty sat on a wall,\nHumpty Dumpty had a great fall.\nAll the king's horses and all the king's men\nCouldn't put Humpty together again.''',
      audioPath: 'assets/audio/humpty.mp3',
    ),
    Poem(
      title: 'Mary Had a Little Lamb',
      content:
          '''Mary had a little lamb,\nIts fleece was white as snow;\nAnd everywhere that Mary went,\nThe lamb was sure to go.''',
      audioPath: 'assets/audio/mary.mp3',
    ),
    Poem(
      title: 'Jack and Jill',
      content:
          '''Jack and Jill went up the hill\nTo fetch a pail of water.\nJack fell down and broke his crown,\nAnd Jill came tumbling after.''',
      audioPath: 'assets/audio/jackjill.mp3',
    ),
    Poem(
      title: 'Old MacDonald',
      content:
          '''Old MacDonald had a farm,\nE-I-E-I-O.\nAnd on his farm he had a cow,\nE-I-E-I-O.''',
      audioPath: 'assets/audio/oldmacdonald.mp3',
    ),
    Poem(
      title: 'Itsy Bitsy Spider',
      content:
          '''The itsy bitsy spider climbed up the waterspout.\nDown came the rain and washed the spider out.\nOut came the sun and dried up all the rain,\nAnd the itsy bitsy spider climbed up the spout again.''',
      audioPath: 'assets/audio/itsybitsy.mp3',
    ),
    Poem(
      title: 'Hickory Dickory Dock',
      content:
          '''Hickory dickory dock,\nThe mouse ran up the clock.\nThe clock struck one,\nThe mouse ran down,\nHickory dickory dock.''',
      audioPath: 'assets/audio/hickory.mp3',
    ),
    Poem(
      title: 'Row Row Row Your Boat',
      content:
          '''Row, row, row your boat,\nGently down the stream.\nMerrily, merrily, merrily, merrily,\nLife is but a dream.''',
      audioPath: 'assets/audio/rowrow.mp3',
    ),
    Poem(
      title: 'Wheels on the Bus',
      content:
          '''The wheels on the bus go round and round,\nRound and round, round and round.\nThe wheels on the bus go round and round,\nAll through the town.''',
      audioPath: 'assets/audio/wheels.mp3',
    ),
  ];

  final Map<String, String> poemEmojis = {
    'Twinkle Twinkle': '⭐',
    'Baa Baa Black Sheep': '🐑',
    'Humpty Dumpty': '🥚',
    'Mary Had a Little Lamb': '🐑',
    'Jack and Jill': '💧',
    'Old MacDonald': '🚜',
    'Itsy Bitsy Spider': '🕷️',
    'Hickory Dickory Dock': '🐭',
    'Row Row Row Your Boat': '🚣',
    'Wheels on the Bus': '🚌',
  };

  @override
  void initState() {
    super.initState();
    initGridAnimations(this);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Nursery Rhymes',
      emoji: '📝',
      body: GridView.builder(
        padding: EdgeInsets.all(12.r),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.r,
          crossAxisSpacing: 16.r,
          childAspectRatio: 0.85,
        ),
        itemCount: poems.length,
        itemBuilder: (context, index) {
          final poem = poems[index];
          final emoji = poemEmojis[poem.title] ?? '🎵';
          final gradient = AppColors.getGradientForIndex(index);

          return buildFloatingItem(
            index: index,
            child: _buildPoemCard(poem, emoji, gradient, index),
          );
        },
      ),
    );
  }

  Widget _buildPoemCard(
    Poem poem,
    String emoji,
    List<Color> gradient,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        TtsService.to.speak(poem.title);
        Get.put(PoemController(poem), tag: poem.title);
        ProgressService.to.markItemCompleted(ProgressService.kPoems, index);
        Get.to(() => PoemDetailPage(poem: poem));
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20.h,
              right: -20.w,
              child: Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -30.h,
              left: -30.w,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 36)),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Flexible(
                    child: Text(
                      poem.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.26),
                            offset: const Offset(1, 1),
                            blurRadius: 2.r,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 16.r,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Play',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Obx(() {
                final _ =
                    ProgressService.to.completedItems[ProgressService.kPoems];
                final isCompleted = ProgressService.to.isItemCompleted(
                  ProgressService.kPoems,
                  index,
                );
                if (isCompleted) {
                  return Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 16.r),
                  );
                }
                return const SizedBox.shrink();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class PoemDetailPage extends StatefulWidget {
  final Poem poem;

  const PoemDetailPage({super.key, required this.poem});

  @override
  State<PoemDetailPage> createState() => _PoemDetailPageState();
}

class _PoemDetailPageState extends State<PoemDetailPage> {
  late PoemController controller;
  int highlightedLineIndex = 0;
  int highlightedWordIndex = -1;

  @override
  void initState() {
    super.initState();
    controller = Get.find(tag: widget.poem.title);

    controller.startSpeakingLines(
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

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: widget.poem.title,
      emoji: '🎵',
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
            controller.startSpeakingLines(
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
          },
        ),
      ],
      body: SafeArea(
        child: Stack(
          children: [
            ...List.generate(20, (index) {
              return Positioned(
                left: (index * 37) % MediaQuery.of(context).size.width,
                top: (index * 53) % 400,
                child: Icon(
                  Icons.star,
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 8.r + (index % 3) * 4,
                ),
              );
            }),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 400.h),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemCount: controller.lines.length,
                  itemBuilder: (context, index) {
                    final line = controller.lines[index];
                    final isHighlighted = highlightedLineIndex == index;

                    if (!isHighlighted) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Text(
                            line,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      final words = line.split(' ');
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: List.generate(words.length, (wIndex) {
                                final word = words[wIndex];
                                final isWordHighlighted =
                                    wIndex == highlightedWordIndex;
                                return TextSpan(
                                  text: '$word ',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: isWordHighlighted
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isWordHighlighted
                                        ? const Color(0xFFFFD700)
                                        : Colors.white,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
