import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/table%20controller/table_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/view/home/Home_Page.dart';
import 'package:learning_a_to_z/view/tables/Table_Count_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_GridView_Builder_Page.dart';

class TableScreen extends StatefulWidget {
  TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final TableController controller = Get.put(TableController());

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final totalBoxes = 39;

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,

      appBar: CustomAppBar(
        title: "Tables",
        titleStyle: ConstStyle.heading2,
        showBackButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: ConstColors.textColorWhit,
            size: SizeConfig.getProportionateScreenWidth(20),
          ),
          onPressed: () => Get.to(() => HomeScreen()),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: ConstColors.textColorWhit,
              size: SizeConfig.getProportionateScreenWidth(22),
            ),
            onPressed: controller.resetExpanded,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionateScreenWidth(12),
          vertical: SizeConfig.getProportionateScreenHeight(8),
        ),
        child: Column(
          children: [
            CustomGridViewBuilder(
              crossAxisCount: 3,
              crossAxisSpacing: SizeConfig.getProportionateScreenWidth(10),
              mainAxisSpacing: SizeConfig.getProportionateScreenHeight(10),
              childAspectRatio: 1.2,
              items: List.generate(totalBoxes, (index) => 'Item ${index + 1}'),
              itemBuilder: (context, index, item) {
                final number = index + 2;
                final isExpanded = controller.expandedIndexes.contains(index);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      controller.toggleExpanded(index, number);
                      Get.to(() => TableDetailScreen(number: number));
                    });
                  },
                  child: Card(
                    elevation: SizeConfig.getProportionateScreenHeight(4),
                    color: ConstColors.textColorWhit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        SizeConfig.getProportionateScreenWidth(12),
                      ),
                      side: BorderSide(
                        color: ConstColors.dividerColor,
                        width: SizeConfig.getProportionateScreenWidth(1),
                      ),
                    ),
                    child: AnimatedContainer(
                      duration: Duration(
                        milliseconds: SizeConfig.getProportionateScreenWidth(
                          300,
                        ).toInt(),
                      ),
                      padding: EdgeInsets.all(
                        SizeConfig.getProportionateScreenWidth(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '$number',
                            style: ConstStyle.heading1.copyWith(
                              fontSize: SizeConfig.getProportionateScreenWidth(
                                24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
}
