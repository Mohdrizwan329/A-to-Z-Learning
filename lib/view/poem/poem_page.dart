import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/poem%20controller/poem_detail_controller.dart';

class PoemListPage extends StatefulWidget {
  PoemListPage({super.key});

  @override
  State<PoemListPage> createState() => _PoemListPageState();
}

class _PoemListPageState extends State<PoemListPage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  final List<Poem> poems = [
    Poem(
      title: 'Twinkle Twinkle',
      content: '''Twinkle, twinkle, little star,\nHow I wonder what you are!\nUp above the world so high,\nLike a diamond in the sky.''',
      audioPath: 'assets/audio/twinkle.mp3',
    ),
    Poem(
      title: 'Baa Baa Black Sheep',
      content: '''Baa, baa, black sheep,\nHave you any wool?\nYes sir, yes sir,\nThree bags full.''',
      audioPath: 'assets/audio/baa.mp3',
    ),
    Poem(
      title: 'Humpty Dumpty',
      content: '''Humpty Dumpty sat on a wall,\nHumpty Dumpty had a great fall.\nAll the king's horses and all the king's men\nCouldn't put Humpty together again.''',
      audioPath: 'assets/audio/humpty.mp3',
    ),
    Poem(
      title: 'Mary Had a Little Lamb',
      content: '''Mary had a little lamb,\nIts fleece was white as snow;\nAnd everywhere that Mary went,\nThe lamb was sure to go.''',
      audioPath: 'assets/audio/mary.mp3',
    ),
    Poem(
      title: 'Jack and Jill',
      content: '''Jack and Jill went up the hill\nTo fetch a pail of water.\nJack fell down and broke his crown,\nAnd Jill came tumbling after.''',
      audioPath: 'assets/audio/jackjill.mp3',
    ),
    Poem(
      title: 'Old MacDonald',
      content: '''Old MacDonald had a farm,\nE-I-E-I-O.\nAnd on his farm he had a cow,\nE-I-E-I-O.''',
      audioPath: 'assets/audio/oldmacdonald.mp3',
    ),
    Poem(
      title: 'Itsy Bitsy Spider',
      content: '''The itsy bitsy spider climbed up the waterspout.\nDown came the rain and washed the spider out.\nOut came the sun and dried up all the rain,\nAnd the itsy bitsy spider climbed up the spout again.''',
      audioPath: 'assets/audio/itsybitsy.mp3',
    ),
    Poem(
      title: 'Hickory Dickory Dock',
      content: '''Hickory dickory dock,\nThe mouse ran up the clock.\nThe clock struck one,\nThe mouse ran down,\nHickory dickory dock.''',
      audioPath: 'assets/audio/hickory.mp3',
    ),
    Poem(
      title: 'Row Row Row Your Boat',
      content: '''Row, row, row your boat,\nGently down the stream.\nMerrily, merrily, merrily, merrily,\nLife is but a dream.''',
      audioPath: 'assets/audio/rowrow.mp3',
    ),
    Poem(
      title: 'Wheels on the Bus',
      content: '''The wheels on the bus go round and round,\nRound and round, round and round.\nThe wheels on the bus go round and round,\nAll through the town.''',
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

  final List<List<Color>> poemGradients = [
    [Color(0xFFFFD700), Color(0xFFFFA500)],
    [Color(0xFF56D97F), Color(0xFF81E89E)],
    [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    [Color(0xFF45B7D1), Color(0xFF74C9DB)],
    [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
    [Color(0xFFFF6EB4), Color(0xFFFF9ECE)],
    [Color(0xFF4ECDC4), Color(0xFF7EDDD6)],
    [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
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
            Text("📝", style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              "Nursery Rhymes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Text("🎵", style: TextStyle(fontSize: 24)),
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
            childAspectRatio: 0.85,
          ),
          itemCount: poems.length,
          itemBuilder: (context, index) {
            final poem = poems[index];
            final emoji = poemEmojis[poem.title] ?? '🎵';
            final gradient = poemGradients[index % poemGradients.length];

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
              child: _buildPoemCard(poem, emoji, gradient, index),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPoemCard(Poem poem, String emoji, List<Color> gradient, int index) {
    return GestureDetector(
      onTap: () {
        Get.put(PoemController(poem), tag: poem.title);
        Get.to(() => PoemDetailPage(poem: poem));
      },
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
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(emoji, style: TextStyle(fontSize: 36)),
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    poem.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_circle_fill, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          "Play",
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

  @override
  void dispose() {
    controller.stop();
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
        title: Text(
          widget.poem.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              controller.startSpeakingLines(
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
        child: SafeArea(
          child: Stack(
            children: [
              ...List.generate(20, (index) {
                return Positioned(
                  left: (index * 37) % MediaQuery.of(context).size.width,
                  top: (index * 53) % 400,
                  child: Icon(
                    Icons.star,
                    color: Colors.white.withOpacity(0.3),
                    size: 8 + (index % 3) * 4,
                  ),
                );
              }),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: SizeConfig.getProportionateScreenHeight(400),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    itemCount: controller.lines.length,
                    itemBuilder: (context, index) {
                      final line = controller.lines[index];
                      final isHighlighted = highlightedLineIndex == index;

                      if (!isHighlighted) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              line,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        final words = line.split(" ");
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: List.generate(words.length, (wIndex) {
                                  final word = words[wIndex];
                                  final isWordHighlighted = wIndex == highlightedWordIndex;
                                  return TextSpan(
                                    text: "$word ",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: isWordHighlighted
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isWordHighlighted
                                          ? Color(0xFFFFD700)
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
      ),
    );
  }
}
