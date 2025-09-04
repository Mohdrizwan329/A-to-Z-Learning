import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/number%20controller/numbers_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_GridView_Builder_Page.dart';

class NumbersScreen extends StatefulWidget {
  const NumbersScreen({super.key});

  @override
  State<NumbersScreen> createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen> {
  late final NumbersController controller;
  final numbersList = List.generate(100, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    controller = Get.put(NumbersController());
    controller.resetSelection();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      appBar: CustomAppBar(
        title: "Numbers",
        titleStyle: ConstStyle.heading2.copyWith(
          fontSize: SizeConfig.getProportionateScreenWidth(18),
        ),
        showBackButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: ConstColors.textColorWhit,
            size: SizeConfig.getProportionateScreenWidth(18),
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: ConstColors.textColorWhit,
              size: SizeConfig.getProportionateScreenWidth(20),
            ),
            onPressed: () {
              controller.resetSelection();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportionateScreenWidth(15),
            vertical: SizeConfig.getProportionateScreenHeight(8),
          ),
          child: Column(
            children: [
              CustomGridViewBuilder<int>(
                items: numbersList,
                crossAxisSpacing: SizeConfig.getProportionateScreenWidth(10),
                mainAxisSpacing: SizeConfig.getProportionateScreenHeight(10),
                childAspectRatio: 1.3,
                crossAxisCount: 3,
                itemBuilder: (context, index, item) {
                  return Obx(() {
                    final isSelected = controller.selectedIndex.value == index;

                    return InkWell(
                      borderRadius: BorderRadius.circular(
                        SizeConfig.getProportionateScreenWidth(12),
                      ),
                      onTap: () {
                        controller.handleTap(index);
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
                        child: Center(
                          child: Text(
                            '${numbersList[index]}',
                            style: ConstStyle.heading1.copyWith(
                              fontSize: SizeConfig.getProportionateScreenWidth(
                                20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
            ],
          ),
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
