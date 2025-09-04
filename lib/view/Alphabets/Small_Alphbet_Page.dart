import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/alphabet%20controller/alphbet_small26_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_GridView_Builder_Page.dart';

class SmallAlphbet26 extends StatefulWidget {
  const SmallAlphbet26({super.key});

  @override
  State<SmallAlphbet26> createState() => _SmallAlphbet26State();
}

class _SmallAlphbet26State extends State<SmallAlphbet26> {
  final LowercaseAlphabetController controller = Get.put(
    LowercaseAlphabetController(),
  );

  @override
  void initState() {
    super.initState();
    controller.resetSelection();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      appBar: CustomAppBar(
        title: "Small Letter Alphabet",
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
              setState(() {
                controller.resetSelection();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(12)),
        child: Column(
          children: [
            CustomGridViewBuilder<String>(
              items: controller.alphabets,
              crossAxisCount: 4,
              mainAxisSpacing: SizeConfig.getProportionateScreenHeight(12),
              crossAxisSpacing: SizeConfig.getProportionateScreenWidth(12),
              childAspectRatio: 1,
              itemBuilder: (context, index, item) {
                final letter = controller.alphabets[index];
                final isSelected = controller.selectedIndexes.contains(index);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      controller.handleTap(index);
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
                    child: Center(
                      child: Text(
                        letter,
                        style: ConstStyle.heading1.copyWith(
                          fontSize: SizeConfig.getProportionateScreenWidth(22),
                        ),
                      ),
                    ),
                  ),
                );
              },
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
            child: const Center(child: AdsScreen()),
          ),
        ],
      ),
    );
  }
}
