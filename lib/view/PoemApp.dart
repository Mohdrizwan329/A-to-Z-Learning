import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/poem_detail_controller.dart';
import 'package:learning_a_to_z/view/home/Home_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_GridView_Builder_Page.dart';

class PoemListPage extends StatefulWidget {
  PoemListPage({super.key});

  @override
  State<PoemListPage> createState() => _PoemListPageState();
}

class _PoemListPageState extends State<PoemListPage> {
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

  final Map<String, IconData> poemIcons = {
    'Twinkle Twinkle': Icons.star,
    'Baa Baa Black Sheep': Icons.pets,
    'Humpty Dumpty': Icons.egg,
    'Mary Had a Little Lamb': Icons.emoji_nature,
    'Jack and Jill': Icons.water,
    'Old MacDonald': Icons.agriculture,
    'Itsy Bitsy Spider': Icons.bug_report,
    'Hickory Dickory Dock': Icons.access_time,
    'Row Row Row Your Boat': Icons.directions_boat,
    'Wheels on the Bus': Icons.directions_bus,
  };

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      appBar: CustomAppBar(
        title: "Learning For Kids",
        titleStyle: ConstStyle.heading2.copyWith(
          fontSize: SizeConfig.getProportionateScreenWidth(18),
        ),
        showBackButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: ConstColors.textColorWhit,
            size: SizeConfig.getProportionateScreenWidth(20),
          ),
          onPressed: () {
            Get.to(() => HomeScreen());
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(12)),
        child: CustomGridViewBuilder(
          crossAxisCount: 2,
          crossAxisSpacing: SizeConfig.getProportionateScreenWidth(12),
          mainAxisSpacing: SizeConfig.getProportionateScreenHeight(12),
          childAspectRatio: 1,
          items: poems,
          itemBuilder: (context, index, item) {
            final poem = poems[index];
            final icon = poemIcons[poem.title] ?? Icons.music_note;

            return GestureDetector(
              onTap: () {
                Get.put(PoemController(poem), tag: poem.title);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PoemDetailPage(poem: poem)),
                );
              },
              child: Card(
                color: ConstColors.textColorWhit,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    SizeConfig.getProportionateScreenWidth(12),
                  ),
                  side: BorderSide(
                    color: ConstColors.dividerColor,
                    width: SizeConfig.getProportionateScreenWidth(1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: SizeConfig.getProportionateScreenWidth(40),
                      backgroundColor: ConstColors.primaryGreen.withOpacity(
                        0.1,
                      ),
                      child: Icon(
                        icon,
                        size: SizeConfig.getProportionateScreenWidth(36),
                        color: ConstColors.primaryGreen,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.getProportionateScreenHeight(8),
                    ),
                    Text(
                      poem.title,
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateScreenWidth(16),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
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
      backgroundColor: ConstColors.backgroundColorWhite,
      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2.copyWith(
          fontSize: SizeConfig.getProportionateScreenWidth(18),
        ),
        title: widget.poem.title,
        showBackButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: ConstColors.textColorWhit,
            size: SizeConfig.getProportionateScreenWidth(20),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: ConstColors.textColorWhit,
              size: SizeConfig.getProportionateScreenWidth(22),
            ),
            onPressed: () {
              setState(() {
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
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: 1.1),
            duration: const Duration(seconds: 8),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Image.network(
                  'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            },
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: SizeConfig.getProportionateScreenHeight(400),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionateScreenWidth(16),
                ),
                itemCount: controller.lines.length,
                itemBuilder: (context, index) {
                  final line = controller.lines[index];
                  final isHighlighted = highlightedLineIndex == index;

                  if (!isHighlighted) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.getProportionateScreenHeight(8),
                        ),
                        child: Text(
                          line,
                          style: TextStyle(
                            fontSize: SizeConfig.getProportionateScreenWidth(
                              20,
                            ),
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    final words = line.split(" ");
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.getProportionateScreenHeight(8),
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: List.generate(words.length, (wIndex) {
                              final word = words[wIndex];
                              final isWordHighlighted =
                                  wIndex == highlightedWordIndex;
                              return TextSpan(
                                text: "$word ",
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.getProportionateScreenWidth(
                                        20,
                                      ),
                                  fontWeight: isWordHighlighted
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isWordHighlighted
                                      ? Colors.yellow
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
    );
  }
}
