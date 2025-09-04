import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/learn%20set%20controller/fruit_learning_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_GridView_Builder_Page.dart';

class FruitLearningPage extends StatefulWidget {
  const FruitLearningPage({super.key});

  @override
  State<FruitLearningPage> createState() => _FruitLearningPageState();
}

class _FruitLearningPageState extends State<FruitLearningPage> {
  final FruitLearningController controller = Get.put(FruitLearningController());

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2.copyWith(
          fontSize: SizeConfig.getProportionateScreenWidth(18),
        ),
        title: "Fruits Name",
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
                controller.resetSelection();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(12)),
        child: CustomGridViewBuilder(
          crossAxisCount: 2,
          mainAxisSpacing: SizeConfig.getProportionateScreenHeight(12),
          crossAxisSpacing: SizeConfig.getProportionateScreenWidth(12),
          childAspectRatio: 1,
          items: FruitLearningController.fruits,
          itemBuilder: (context, index, item) {
            final isSelected = index == controller.selectedIndex.value;

            return GestureDetector(
              onTap: () {
                setState(() {
                  controller.selectFruit(index);
                });
              },
              child: Card(
                color: isSelected
                    ? ConstColors.primaryYellow
                    : ConstColors.textColorWhit,
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
                    vertical: SizeConfig.getProportionateScreenHeight(16),
                    horizontal: SizeConfig.getProportionateScreenWidth(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: SizeConfig.getProportionateScreenWidth(30),
                        child: Center(
                          child: Text(
                            item['emoji']!,
                            style: TextStyle(
                              fontSize: SizeConfig.getProportionateScreenWidth(
                                28,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(10),
                      ),
                      Text(
                        item['name']!,
                        textAlign: TextAlign.center,
                        style: ConstStyle.heading3.copyWith(
                          fontSize: SizeConfig.getProportionateScreenWidth(16),
                        ),
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
          Divider(
            height: SizeConfig.getProportionateScreenHeight(1),
            thickness: SizeConfig.getProportionateScreenHeight(1),
            color: Colors.grey.shade400,
          ),
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
