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

//////////////////////////////////////////////////////////
//                MAIN MATH GRID SCREEN
//////////////////////////////////////////////////////////
class MathGridScreen extends StatefulWidget {
  @override
  State<MathGridScreen> createState() => _MathGridScreenState();
}

class _MathGridScreenState extends State<MathGridScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF1A6), Color(0xFFFFC1E3), Color(0xFFA6E4FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: "Math Problem With Solution",
                  titleStyle: ConstStyle.heading2.copyWith(
                    fontSize: SizeConfig.getProportionateScreenWidth(20),
                    color: Colors.white,
                  ),
                  showBackButton: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: SizeConfig.getProportionateScreenWidth(22),
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),

                SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: SizeConfig.getProportionateScreenWidth(16),
                  mainAxisSpacing: SizeConfig.getProportionateScreenHeight(16),
                  children: [
                    FloatingBox(
                      label: 'Addition',
                      icon: Icons.add,
                      color: Colors.redAccent,
                      onTap: () => Get.to(() => AdditionPage()),
                    ),
                    FloatingBox(
                      label: 'Subtraction',
                      icon: Icons.remove,
                      color: Colors.purpleAccent,
                      onTap: () => Get.to(() => SubtractionPage()),
                    ),
                    FloatingBox(
                      label: 'Multiplication',
                      icon: Icons.clear,
                      color: Colors.green,
                      onTap: () => Get.to(() => MultiplicationPage()),
                    ),
                    FloatingBox(
                      label: 'Division',
                      icon: Icons.percent,
                      color: Colors.blue,
                      onTap: () => Get.to(() => DivisionPage()),
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.getProportionateScreenHeight(25)),

                SizedBox(
                  height: SizeConfig.getProportionateScreenHeight(80),
                  child: AdsScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
//                FLOATING BOX WIDGET
//////////////////////////////////////////////////////////
class FloatingBox extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const FloatingBox({
    Key? key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  State<FloatingBox> createState() => _FloatingBoxState();
}

class _FloatingBoxState extends State<FloatingBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -6,
      end: 6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              SizeConfig.getProportionateScreenWidth(12),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF81D4FA), Color(0xFFFFC1E3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(
                SizeConfig.getProportionateScreenWidth(12),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: SizeConfig.getProportionateScreenWidth(30),
                    backgroundColor: Colors.white,
                    child: Icon(
                      widget.icon,
                      color: widget.color,
                      size: SizeConfig.getProportionateScreenWidth(30),
                    ),
                  ),
                  SizedBox(height: SizeConfig.getProportionateScreenHeight(10)),
                  Text(
                    widget.label,
                    style: ConstStyle.heading2.copyWith(
                      fontSize: SizeConfig.getProportionateScreenWidth(18),
                      color: widget.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
//                FLOATING PROBLEM BOX WIDGET
//////////////////////////////////////////////////////////
class FloatingProblemBox extends StatefulWidget {
  final Widget child;

  const FloatingProblemBox({Key? key, required this.child}) : super(key: key);

  @override
  State<FloatingProblemBox> createState() => _FloatingProblemBoxState();
}

class _FloatingProblemBoxState extends State<FloatingProblemBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2 + random.nextInt(3)), // 2-4 sec
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -6,
      end: 6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

//////////////////////////////////////////////////////////
//                MATH TEMPLATE SCREEN
//////////////////////////////////////////////////////////
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
          int t = a;
          a = b;
          b = t;
        }
      } else if (widget.operator == '÷') {
        b = _random.nextInt(9) + 1;
        a = b * (_random.nextInt(10) + 1);
        return "$a ÷ $b = ${a ~/ b}";
      }

      if (widget.operator == '×') return "$a × $b = ${a * b}";
      if (widget.operator == '+') return "$a + $b = ${a + b}";
      if (widget.operator == '-') return "$a - $b = ${a - b}";
      return "$a * $b = ${a * b}";
    });
  }

  void _speak(String text) async {
    await flutterTts.speak(text.replaceAll('×', 'times'));
  }

  void _toggleSelection(int index) {
    setState(() {
      selectedIndices.clear();
      selectedIndices.add(index);
      _speak(problems[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF1A6), Color(0xFFFFC1E3), Color(0xFFA6E4FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(16)),
            child: Column(
              children: [
                CustomAppBar(
                  title: widget.title,
                  titleStyle: ConstStyle.heading2.copyWith(
                    fontSize: SizeConfig.getProportionateScreenWidth(18),
                    color: Colors.white,
                  ),
                  showBackButton: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: SizeConfig.getProportionateScreenWidth(22),
                    ),
                    onPressed: () => Get.back(),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
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

                SizedBox(height: SizeConfig.getProportionateScreenHeight(15)),

                CustomGridViewBuilder(
                  items: problems,
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                  itemBuilder: (context, index, item) {
                    bool selected = selectedIndices.contains(index);

                    return FloatingProblemBox(
                      child: GestureDetector(
                        onTap: () => _toggleSelection(index),
                        child: Card(
                          elevation: 7,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selected
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFFFFD2A6),
                                        Color(0xFFB6FFC1),
                                      ],
                                    )
                                  : const LinearGradient(
                                      colors: [
                                        Color(0xFF81D4FA),
                                        Color(0xFFFFC1E3),
                                      ],
                                    ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item,
                                  textAlign: TextAlign.center,
                                  style: ConstStyle.heading1.copyWith(
                                    fontSize:
                                        SizeConfig.getProportionateScreenWidth(
                                          22,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20),

                SizedBox(
                  height: SizeConfig.getProportionateScreenHeight(80),
                  child: AdsScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
//                INDIVIDUAL OPERATION PAGES
//////////////////////////////////////////////////////////
class AdditionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MathGridTemplate(title: "Addition", operator: '+');
}

class SubtractionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MathGridTemplate(title: "Subtraction", operator: '-');
}

class MultiplicationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MathGridTemplate(title: "Multiplication", operator: '×');
}

class DivisionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MathGridTemplate(title: "Division", operator: '÷');
}
