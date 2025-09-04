import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/qustion%20controller/multiplication_questions_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_GridView_Builder_Page.dart';

class MultiplicationQuestionsScreen extends StatefulWidget {
  const MultiplicationQuestionsScreen({super.key});

  @override
  State<MultiplicationQuestionsScreen> createState() =>
      _MultiplicationQuestionsScreenState();
}

class _MultiplicationQuestionsScreenState
    extends State<MultiplicationQuestionsScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MultiplicationController());
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,

      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2,
        title: "Multiplication Questions",
        showBackButton: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: ConstColors.textColorWhit,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: ConstColors.textColorWhit),
            onPressed: () {
              setState(() {
                controller.reset();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionateScreenWidth(10),
          vertical: SizeConfig.getProportionateScreenHeight(10),
        ),
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
                padding: EdgeInsets.only(
                  left: SizeConfig.getProportionateScreenWidth(10),
                  right: SizeConfig.getProportionateScreenWidth(10),
                  top: SizeConfig.getProportionateScreenHeight(20),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(" × ", style: ConstStyle.heading5),
                          SizedBox(
                            width: SizeConfig.getProportionateScreenWidth(15),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                " ${question.num1}",
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
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
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
                            fontSize: SizeConfig.getProportionateScreenHeight(
                              14,
                            ),
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
                              controller.checkAnswer(index, context);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ConstColors.appBarBackgroundcolor,
                            foregroundColor: ConstColors.textColorWhit,
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  SizeConfig.getProportionateScreenWidth(24),
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
}
