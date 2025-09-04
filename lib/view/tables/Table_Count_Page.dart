import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/table%20controller/table_detail_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/view/tables/Table_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_GridView_Builder_Page.dart';

class TableDetailScreen extends StatefulWidget {
  final int number;

  const TableDetailScreen({super.key, required this.number});

  @override
  State<TableDetailScreen> createState() => _TableDetailScreenState();
}

class _TableDetailScreenState extends State<TableDetailScreen> {
  late TableDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TableDetailController(widget.number));
  }

  @override
  void dispose() {
    Get.delete<TableDetailController>();
    super.dispose();
  }

  Widget buildSelectableBox(int index, int product) {
    return Obx(() {
      bool isSelected = controller.selectedIndex.value == index;

      Color boxColor = isSelected
          ? ConstColors.primaryYellow
          : ConstColors.textColorWhit;
      Color textColor = isSelected
          ? ConstColors.textColor
          : Colors.grey.shade600;

      return GestureDetector(
        onTap: () {
          controller.onBoxTap(index);
        },
        child: Card(
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
          color: boxColor,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionateScreenWidth(8),
                vertical: SizeConfig.getProportionateScreenHeight(6),
              ),
              child: Text(
                " $product",
                textAlign: TextAlign.center,
                style: ConstStyle.heading1.copyWith(
                  color: textColor,
                  fontSize: SizeConfig.getProportionateScreenWidth(22),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      appBar: CustomAppBar(
        title: "${widget.number} Table",
        titleStyle: ConstStyle.heading2.copyWith(
          fontSize: SizeConfig.getProportionateScreenWidth(20),
        ),
        showBackButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: ConstColors.textColorWhit,
            size: SizeConfig.getProportionateScreenWidth(20),
          ),
          onPressed: () {
            Get.to(() => TableScreen());
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
              controller.resetStep();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(12)),
        child: CustomGridViewBuilder(
          crossAxisCount: 3,
          crossAxisSpacing: SizeConfig.getProportionateScreenWidth(10),
          mainAxisSpacing: SizeConfig.getProportionateScreenHeight(10),
          childAspectRatio: 1.4,
          items: List.generate(10, (index) => index),
          itemBuilder: (context, i, item) {
            final product = widget.number * (i + 1);
            return buildSelectableBox(i, product);
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
