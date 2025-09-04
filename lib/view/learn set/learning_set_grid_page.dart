import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/home/Home_Page.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/view/learn set/Animal_Name_Learning_Page.dart';
import 'package:learning_a_to_z/view/learn set/Bird_Name_Learning_Page.dart';
import 'package:learning_a_to_z/view/learn set/Color_name_learning_page.dart';
import 'package:learning_a_to_z/view/learn set/Flower_Name_Learning_Page.dart';
import 'package:learning_a_to_z/view/learn set/Fruit_Name_Learning_Page.dart';
import 'package:learning_a_to_z/view/learn%20set/bodyparts_name_learning_page.dart';
import 'package:learning_a_to_z/view/learn%20set/month_name_learning_page.dart';
import 'package:learning_a_to_z/view/learn%20set/vegetables_name_learning_page.dart';
import 'package:learning_a_to_z/view/learn%20set/week_day_learning_page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class LearningSetsGridScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,

      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2.copyWith(
          fontSize: SizeConfig.getProportionateScreenHeight(20),
        ),
        title: "Learning Sets Practice",
        showBackButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: ConstColors.textColorWhit,
            size: SizeConfig.getProportionateScreenHeight(20),
          ),
          onPressed: () => Get.to(() => HomeScreen()),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: ConstColors.textColorWhit,
              size: SizeConfig.getProportionateScreenHeight(22),
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
                crossAxisSpacing: SizeConfig.getProportionateScreenWidth(12),
                mainAxisSpacing: SizeConfig.getProportionateScreenHeight(12),
                children: [
                  _buildBox(
                    'Animals',
                    Icons.pets,
                    Colors.blue,
                    () => Get.to(() => AnimalLearningPage()),
                  ),
                  _buildBox(
                    'Birds',
                    Icons.flight,
                    Colors.redAccent,
                    () => Get.to(() => BirdLearningPage()),
                  ),
                  _buildBox(
                    'Flowers',
                    Icons.local_florist,
                    Colors.orange,
                    () => Get.to(() => FlowerLearningPage()),
                  ),
                  _buildBox(
                    'Fruits',
                    Icons.local_grocery_store,
                    Colors.purple,
                    () => Get.to(() => FruitLearningPage()),
                  ),
                  _buildBox(
                    'Vegetables',
                    Icons.eco,
                    Colors.green.shade700,
                    () => Get.to(() => VegetablesLearningPage()),
                  ),
                  _buildBox(
                    'Colors',
                    Icons.color_lens,
                    Colors.deepOrange,
                    () => Get.to(() => ColorsLearningPage()),
                  ),
                  _buildBox(
                    'Days',
                    Icons.calendar_today,
                    Colors.teal,
                    () => Get.to(() => WeekDayLearningPage()),
                  ),
                  _buildBox(
                    'Months',
                    Icons.event,
                    Colors.indigo,
                    () => Get.to(() => MonthLearningPage()),
                  ),
                  _buildBox(
                    'Body Parts',
                    Icons.accessibility_new,
                    Colors.pinkAccent,
                    () => Get.to(() => BodyPartsLearningPage()),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(12)),
          ],
        ),
      ),

      // Bottom Ads Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ConstColors.appBarBackgroundcolor,
          border: Border(
            top: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
        ),
        height: SizeConfig.getProportionateScreenHeight(60),
        child: const Center(child: AdsScreen()),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: SizeConfig.getProportionateScreenWidth(30),
                backgroundColor: ConstColors.backgroundColorWhite,
                child: Icon(
                  icon,
                  size: SizeConfig.getProportionateScreenWidth(28),
                  color: color,
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
