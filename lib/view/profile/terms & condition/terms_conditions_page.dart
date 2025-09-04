import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/setting%20controller/terms_conditions_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsConditionsController());

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: ConstColors.backgroundColorWhite,
      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2,
        title: controller.title.value,
        showBackButton: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: ConstColors.textColorWhit,
          ),
          onPressed: () => Get.back(),
        ),
      ),

      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              children: [
                Text(controller.subTitle.value, style: ConstStyle.smallText),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.sections
                      .map(
                        (section) => Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section['title'],
                                style: ConstStyle.smallText,
                              ),
                              const SizedBox(height: 8),
                              ...List.generate(
                                (section['bullets'] as List).length,
                                (index) {
                                  final bullet =
                                      (section['bullets'] as List)[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(
                                            top: 6,
                                            right: 8,
                                          ),
                                          child: Icon(
                                            Icons.circle,
                                            size: 6,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            bullet,
                                            style: ConstStyle.smallText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 1, thickness: 1, color: Colors.grey.shade400),
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
