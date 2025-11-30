import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/qustion%20controller/division_questions_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class DivisionQuestionsScreen extends StatefulWidget {
  const DivisionQuestionsScreen({super.key});

  @override
  State<DivisionQuestionsScreen> createState() =>
      _DivisionQuestionsScreenState();
}

class _DivisionQuestionsScreenState extends State<DivisionQuestionsScreen>
    with SingleTickerProviderStateMixin {
  final DivisionQuestionsController controller = Get.put(
    DivisionQuestionsController(),
  );

  late AnimationController _animationController;
  late Animation<double> _floatAnimation;

  final List<int> selectedIndexes = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF1A6), // light yellow
              Color(0xFFFFC1E3), // pink
              Color(0xFFA6E4FF), // light blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(12)),
            child: Column(
              children: [
                /// AppBar
                CustomAppBar(
                  titleStyle: ConstStyle.heading2.copyWith(
                    fontSize: SizeConfig.getProportionateScreenWidth(18),
                    color: Colors.white,
                  ),
                  title: "Division Questions",
                  showBackButton: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: SizeConfig.getProportionateScreenWidth(18),
                    ),
                    onPressed: () => Get.back(),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: SizeConfig.getProportionateScreenWidth(20),
                      ),
                      onPressed: () {
                        setState(() {
                          controller.resetAll();
                          selectedIndexes.clear();
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.getProportionateScreenHeight(12)),

                /// GridView
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.questions.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: SizeConfig.getProportionateScreenHeight(
                      12,
                    ),
                    crossAxisSpacing: SizeConfig.getProportionateScreenWidth(
                      12,
                    ),
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final question = controller.questions[index];
                    final isSelected = selectedIndexes.contains(index);

                    /// Locked card
                    if (!controller.isInCurrentBatch(index) &&
                        !question.isAnswered) {
                      return Card(
                        color: Colors.grey.shade200,
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
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock,
                                color: Colors.grey,
                                size: SizeConfig.getProportionateScreenHeight(
                                  30,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.getProportionateScreenHeight(
                                  10,
                                ),
                              ),
                              const Text(
                                "Locked",
                                style: ConstStyle.smallText1,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    /// Active Card with floating animation
                    return AnimatedBuilder(
                      animation: _floatAnimation,
                      builder: (_, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatAnimation.value),
                          child: child,
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedIndexes.remove(index);
                            } else {
                              selectedIndexes.add(index);
                            }
                          });
                        },
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              SizeConfig.getProportionateScreenWidth(12),
                            ),
                            side: BorderSide(
                              color: ConstColors.dividerColor,
                              width: SizeConfig.getProportionateScreenWidth(1),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: question.isAnswered
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFFB6FFC1),
                                        Color(0xFFFFD2A6),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : isSelected
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFFFFD2A6),
                                        Color(0xFFB6FFC1),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : const LinearGradient(
                                      colors: [
                                        Color(0xFF81D4FA),
                                        Color(0xFFFFC1E3),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              borderRadius: BorderRadius.circular(
                                SizeConfig.getProportionateScreenWidth(12),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 3),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(
                              SizeConfig.getProportionateScreenWidth(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// Numbers Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${question.num1} ÷ ${question.num2}",
                                      style: ConstStyle.heading5.copyWith(
                                        fontSize:
                                            SizeConfig.getProportionateScreenWidth(
                                              18,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height:
                                      SizeConfig.getProportionateScreenHeight(
                                        10,
                                      ),
                                ),

                                /// Answer Input
                                if (!question.isAnswered)
                                  SizedBox(
                                    height:
                                        SizeConfig.getProportionateScreenHeight(
                                          40,
                                        ),
                                    child: TextField(
                                      controller: question.controller,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            SizeConfig.getProportionateScreenWidth(
                                              8,
                                            ),
                                          ),
                                        ),
                                        labelText: "Your Ans",
                                        labelStyle: ConstStyle.smallText1,
                                      ),
                                    ),
                                  ),

                                if (question.isAnswered)
                                  Text(
                                    question.result,
                                    style: TextStyle(
                                      color: ConstColors.primaryGreen,
                                      fontSize:
                                          SizeConfig.getProportionateScreenHeight(
                                            14,
                                          ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                SizedBox(
                                  height:
                                      SizeConfig.getProportionateScreenHeight(
                                        10,
                                      ),
                                ),

                                /// Submit Button
                                if (!question.isAnswered)
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        controller.checkAnswer(index);
                                        if (controller.allAnsweredInBatch) {
                                          _showScoreDialog(context, controller);
                                        }
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ConstColors.appBarBackgroundcolor,
                                      foregroundColor:
                                          ConstColors.textColorWhit,
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.getProportionateScreenWidth(
                                              24,
                                            ),
                                        vertical:
                                            SizeConfig.getProportionateScreenHeight(
                                              12,
                                            ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          SizeConfig.getProportionateScreenWidth(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "Submit",
                                      style: ConstStyle.buttonStyle.copyWith(
                                        fontSize:
                                            SizeConfig.getProportionateScreenWidth(
                                              14,
                                            ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                /// Ads
                SizedBox(
                  height: SizeConfig.getProportionateScreenHeight(80),
                  width: double.infinity,
                  child: AdsScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Score Dialog
  void _showScoreDialog(
    BuildContext context,
    DivisionQuestionsController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ConstColors.backgroundColorWhite,
        title: Text(
          "Batch Completed!",
          style: ConstStyle.heading1.copyWith(
            fontSize: SizeConfig.getProportionateScreenWidth(20),
          ),
        ),
        content: Obx(
          () => Text(
            "Correct:    ${controller.correct}\nIncorrect:    ${controller.incorrect}",
            style: ConstStyle.heading5.copyWith(
              fontSize: SizeConfig.getProportionateScreenWidth(16),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              controller.moveToNextBatch();
            },
            child: Text(
              "Next 10 Questions",
              style: ConstStyle.heading6.copyWith(
                fontSize: SizeConfig.getProportionateScreenWidth(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
