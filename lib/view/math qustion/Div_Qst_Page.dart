import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/qustion%20controller/division_questions_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_GridView_Builder_Page.dart';

class DivisionQuestionsScreen extends StatefulWidget {
  const DivisionQuestionsScreen({super.key});

  @override
  State<DivisionQuestionsScreen> createState() =>
      _DivisionQuestionsScreenState();
}

class _DivisionQuestionsScreenState extends State<DivisionQuestionsScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final controller = Get.put(DivisionQuestionsController());

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,

      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2,
        title: "Division Questions",
        showBackButton: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: ConstColors.textColorWhit,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: ConstColors.textColorWhit),
            onPressed: () {
              controller.resetAll();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(10)),
        child: CustomGridViewBuilder(
          crossAxisCount: 2,
          mainAxisExtent: SizeConfig.getProportionateScreenHeight(220),
          crossAxisSpacing: SizeConfig.getProportionateScreenWidth(12),
          mainAxisSpacing: SizeConfig.getProportionateScreenHeight(12),
          items: controller.questions,
          itemBuilder: (context, index, item) {
            final question = controller.questions[index];

            if (!controller.isInCurrentBatch(index) && !question.isAnswered) {
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
                        size: SizeConfig.getProportionateScreenHeight(30),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(10),
                      ),
                      const Text("Locked", style: ConstStyle.smallText1),
                    ],
                  ),
                ),
              );
            }

            return Card(
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
              color: ConstColors.textColorWhit,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionateScreenWidth(10),
                  vertical: SizeConfig.getProportionateScreenHeight(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(" ÷ ", style: ConstStyle.heading5),
                        SizedBox(
                          width: SizeConfig.getProportionateScreenWidth(15),
                        ),
                        Column(
                          children: [
                            Text(
                              "${question.num1}",
                              style: ConstStyle.heading5,
                            ),
                            Text(
                              "${question.num2}",
                              style: ConstStyle.heading5,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.getProportionateScreenHeight(10),
                    ),
                    if (!question.isAnswered)
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(40),
                        child: TextField(
                          controller: question.controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
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
                          fontSize: SizeConfig.getProportionateScreenHeight(14),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(
                      height: SizeConfig.getProportionateScreenHeight(10),
                    ),
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
                          backgroundColor: ConstColors.appBarBackgroundcolor,
                          foregroundColor: ConstColors.textColorWhit,
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.getProportionateScreenWidth(
                              24,
                            ),
                            vertical: SizeConfig.getProportionateScreenHeight(
                              12,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              SizeConfig.getProportionateScreenWidth(12),
                            ),
                          ),
                        ),
                        child: Text("Submit", style: ConstStyle.buttonStyle),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 1, thickness: 1, color: Colors.grey.shade400),
          Container(
            height: SizeConfig.getProportionateScreenHeight(60),
            color: ConstColors.appBarBackgroundcolor,
            child: const Center(child: AdsScreen()),
          ),
        ],
      ),
    );
  }

  void _showScoreDialog(
    BuildContext context,
    DivisionQuestionsController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ConstColors.backgroundColorWhite,
        title: Text("Batch Completed!", style: ConstStyle.heading1),
        content: Obx(
          () => Text(
            "Correct:    ${controller.correct}\nIncorrect:    ${controller.incorrect}",
            style: ConstStyle.heading5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.moveToNextBatch();
            },
            child: Text("Next 10 Questions", style: ConstStyle.heading6),
          ),
        ],
      ),
    );
  }
}
