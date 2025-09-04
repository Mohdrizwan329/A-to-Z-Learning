import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_GridView_Builder_Page.dart';

class MathGridScreen extends StatefulWidget {
  @override
  State<MathGridScreen> createState() => _MathGridScreenState();
}

class _MathGridScreenState extends State<MathGridScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,

      appBar: CustomAppBar(
        title: "Math Problem With Solution",
        showBackButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: ConstColors.textColorWhit,
            size: SizeConfig.getProportionateScreenWidth(20),
          ),
          onPressed: () => Get.back(),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(16)),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: SizeConfig.getProportionateScreenWidth(16),
              mainAxisSpacing: SizeConfig.getProportionateScreenHeight(16),
              children: [
                _buildBox(
                  'Addition',
                  Icons.add,
                  ConstColors.primaryBlue,
                  () => Get.to(() => AdditionPage()),
                ),
                _buildBox(
                  'Subtraction',
                  Icons.remove,
                  ConstColors.primaryRed,
                  () => Get.to(() => SubtractionPage()),
                ),
                _buildBox(
                  'Multiplication',
                  Icons.clear,
                  ConstColors.primaryYellow,
                  () => Get.to(() => MultiplicationPage()),
                ),
                _buildBox(
                  'Division',
                  Icons.percent,
                  ConstColors.primaryGreen,
                  () => Get.to(() => DivisionPage()),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(16)),
          ],
        ),
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: SizeConfig.getProportionateScreenHeight(1),
            thickness: SizeConfig.getProportionateScreenWidth(1),
            color: Colors.grey.shade400,
          ),
          Container(
            height: SizeConfig.getProportionateScreenHeight(60),
            color: ConstColors.appBarBackgroundcolor,
            child: Center(child: AdsScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildBox(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: SizeConfig.getProportionateScreenHeight(4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            SizeConfig.getProportionateScreenWidth(12),
          ),
          side: BorderSide(
            color: ConstColors.dividerColor,
            width: SizeConfig.getProportionateScreenWidth(1),
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionateScreenWidth(12),
              vertical: SizeConfig.getProportionateScreenHeight(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: SizeConfig.getProportionateScreenWidth(30),
                  child: Center(
                    child: Icon(
                      icon,
                      size: SizeConfig.getProportionateScreenWidth(30),
                      color: color,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(10)),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateScreenWidth(18),
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MathGridTemplate extends StatefulWidget {
  final String title;
  final String operator;

  const MathGridTemplate({
    Key? key,
    required this.title,
    required this.operator,
  }) : super(key: key);

  @override
  State<MathGridTemplate> createState() => _MathGridTemplateState();
}

class _MathGridTemplateState extends State<MathGridTemplate> {
  final Random _random = Random();
  final FlutterTts flutterTts = FlutterTts();
  List<String> problems = [];
  Set<int> selectedIndices = {};

  @override
  void initState() {
    super.initState();
    generateProblems();
  }

  void generateProblems() {
    problems = List.generate(90, (index) {
      int a = _random.nextInt(10) + 1;
      int b = _random.nextInt(10) + 1;

      if (widget.operator == '-') {
        if (a < b) {
          int temp = a;
          a = b;
          b = temp;
        }
      } else if (widget.operator == '÷') {
        b = _random.nextInt(9) + 1;
        a = b * (_random.nextInt(10) + 1);
        return "$a ÷ $b = ${a ~/ b}";
      }

      if (widget.operator == '×') {
        return "$a × $b = ${a * b}";
      } else if (widget.operator == '+') {
        return "$a + $b = ${a + b}";
      } else if (widget.operator == '-') {
        return "$a - $b = ${a - b}";
      } else {
        return "$a * $b = ${a * b}";
      }
    });
  }

  void _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text.replaceAll('×', 'times'));
  }

  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.clear();
      } else {
        selectedIndices
          ..clear()
          ..add(index);

        _speak(problems[index]);
      }
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    Color getTileColor(int index) => selectedIndices.contains(index)
        ? ConstColors.primaryYellow
        : ConstColors.textColorWhit;

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,

      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2,
        title: widget.title,
        showBackButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: ConstColors.textColorWhit,
            size: SizeConfig.getProportionateScreenWidth(20),
          ),
          onPressed: () => Get.back(),
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
                generateProblems();
                selectedIndices.clear();
              });
            },
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(16)),
        child: CustomGridViewBuilder(
          crossAxisCount: 2,
          mainAxisSpacing: SizeConfig.getProportionateScreenHeight(12),
          crossAxisSpacing: SizeConfig.getProportionateScreenWidth(12),
          childAspectRatio: 1,
          items: problems,
          itemBuilder: (context, index, item) {
            final question = problems[index];
            return GestureDetector(
              onTap: () => _toggleSelection(index),
              child: Card(
                color: getTileColor(index),
                elevation: SizeConfig.getProportionateScreenHeight(4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    SizeConfig.getProportionateScreenWidth(12),
                  ),
                  side: BorderSide(
                    color: ConstColors.dividerColor,
                    width: SizeConfig.getProportionateScreenWidth(1),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(
                      SizeConfig.getProportionateScreenWidth(8),
                    ),
                    child: Text(
                      question,
                      textAlign: TextAlign.center,
                      style: ConstStyle.heading1.copyWith(
                        fontSize: SizeConfig.getProportionateScreenWidth(20),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: SizeConfig.getProportionateScreenHeight(1),
            thickness: SizeConfig.getProportionateScreenWidth(1),
            color: Colors.grey.shade400,
          ),
          Container(
            height: SizeConfig.getProportionateScreenHeight(60),
            color: ConstColors.appBarBackgroundcolor,
            child: Center(child: AdsScreen()),
          ),
        ],
      ),
    );
  }
}

class AdditionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MathGridTemplate(title: "Addition", operator: '+');
  }
}

class SubtractionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MathGridTemplate(title: "Subtraction", operator: '-');
  }
}

class MultiplicationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MathGridTemplate(title: "Multiplication", operator: '×');
  }
}

class DivisionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MathGridTemplate(title: "Division", operator: '÷');
  }
}
