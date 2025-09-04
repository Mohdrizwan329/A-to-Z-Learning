import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/home/Home_Page.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/view/math%20qustion/Add_Qst_Page.dart';
import 'package:learning_a_to_z/view/math%20qustion/Div_Qst_Page.dart';
import 'package:learning_a_to_z/view/math%20qustion/Mul_Qst_Page.dart';
import 'package:learning_a_to_z/view/math%20qustion/Sub_Qst_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class MathQustionGridScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context); // initialize responsive size

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,

      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2.copyWith(
          fontSize: SizeConfig.getProportionateScreenWidth(18),
        ),
        title: "Math Practice",
        showBackButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: SizeConfig.getProportionateScreenWidth(22),
            color: ConstColors.textColorWhit,
          ),
          onPressed: () {
            Get.to(() => HomeScreen());
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              size: SizeConfig.getProportionateScreenWidth(22),
              color: ConstColors.textColorWhit,
            ),
            onPressed: () {},
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(16)),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: SizeConfig.getProportionateScreenWidth(16),
                mainAxisSpacing: SizeConfig.getProportionateScreenHeight(16),
                children: [
                  _buildBox(
                    'Addition',
                    Icons.add,
                    ConstColors.primaryBlue,
                    () => Get.to(() => AdditionQuestionsScreen()),
                  ),
                  _buildBox(
                    'Subtraction',
                    Icons.remove,
                    ConstColors.primaryRed,
                    () => Get.to(() => SubtractionQuestionsScreen()),
                  ),
                  _buildBox(
                    'Multiplication',
                    Icons.clear,
                    ConstColors.primaryYellow,
                    () => Get.to(() => MultiplicationQuestionsScreen()),
                  ),
                  _buildBox(
                    'Division',
                    Icons.percent,
                    ConstColors.primaryGreen,
                    () => Get.to(() => DivisionQuestionsScreen()),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
          ],
        ),
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: SizeConfig.getProportionateScreenHeight(1),
            thickness: SizeConfig.getProportionateScreenHeight(1),
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
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionateScreenHeight(20),
            horizontal: SizeConfig.getProportionateScreenWidth(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: SizeConfig.getProportionateScreenWidth(30),
                backgroundColor: ConstColors.backgroundColorWhite,
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
                  fontSize: SizeConfig.getProportionateScreenWidth(16),
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
