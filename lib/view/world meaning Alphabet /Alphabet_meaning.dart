import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/alphabet%20controller/world_meaning_alphabet_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_GridView_Builder_Page.dart';

class AlphabetMening extends StatefulWidget {
  AlphabetMening({super.key});

  @override
  State<AlphabetMening> createState() => _AlphabetMeningState();
}

class _AlphabetMeningState extends State<AlphabetMening> {
  final WorldMeaningAlphabetController controller = Get.put(
    WorldMeaningAlphabetController(),
  );

  @override
  void dispose() {
    controller.clearCache();
    Get.delete<WorldMeaningAlphabetController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context); // responsive size init

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      appBar: CustomAppBar(
        title: "Words Meaning",
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
                controller.selectedIndexes.clear();
              });
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(12)),
          child: Column(
            children: [
              CustomGridViewBuilder(
                items: controller.alphabetData,
                crossAxisCount: 2,
                mainAxisSpacing: SizeConfig.getProportionateScreenHeight(12),
                crossAxisSpacing: SizeConfig.getProportionateScreenWidth(12),
                childAspectRatio: 0.9,
                itemBuilder: (context, index, item) {
                  final isSelected = controller.selectedIndexes.contains(index);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        controller.toggleSelection(
                          index: index,
                          showSnack: _showSnack,
                        );
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
                          vertical: SizeConfig.getProportionateScreenHeight(6),
                          horizontal: SizeConfig.getProportionateScreenWidth(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Letter
                            Text(
                              item['letter']!,
                              style: ConstStyle.heading1.copyWith(
                                fontSize:
                                    SizeConfig.getProportionateScreenWidth(26),
                              ),
                            ),

                            SizedBox(
                              height: SizeConfig.getProportionateScreenHeight(
                                12,
                              ),
                            ),

                            /// Emoji
                            CircleAvatar(
                              radius: SizeConfig.getProportionateScreenWidth(
                                26,
                              ),
                              child: Center(
                                child: Text(
                                  item['emoji']!,
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.getProportionateScreenWidth(
                                          24,
                                        ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: SizeConfig.getProportionateScreenHeight(
                                12,
                              ),
                            ),

                            /// Meaning
                            Text(
                              item['meaning']!,
                              textAlign: TextAlign.center,
                              style: ConstStyle.heading4.copyWith(
                                fontSize:
                                    SizeConfig.getProportionateScreenWidth(16),
                              ),
                            ),
                          ],
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

  void _showSnack(String msg) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.getProportionateScreenHeight(18),
          ),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }
}
