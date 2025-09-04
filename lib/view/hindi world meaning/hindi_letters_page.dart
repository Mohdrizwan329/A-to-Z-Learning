import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/hindi%20controller/hindi_letters_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class HindiLettersPage extends StatefulWidget {
  const HindiLettersPage({super.key});

  @override
  State<HindiLettersPage> createState() => _HindiLettersPageState();
}

class _HindiLettersPageState extends State<HindiLettersPage> {
  final HindiLettersController controller = Get.put(HindiLettersController());

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context); // responsive size init

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2.copyWith(
          fontSize: SizeConfig.getProportionateScreenWidth(18),
        ),
        title: "अ से ज्ञ तक",
        showBackButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: ConstColors.textColorWhit,
            size: SizeConfig.getProportionateScreenWidth(18),
          ),
          onPressed: () => Navigator.pop(context),
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
                controller.clearCache();
              });
            },
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(12)),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: SizeConfig.getProportionateScreenHeight(12),
            crossAxisSpacing: SizeConfig.getProportionateScreenWidth(12),
            childAspectRatio: 1,
          ),
          itemCount: controller.letters.length,
          itemBuilder: (context, index) {
            final item = controller.letters[index];
            final isSelected = controller.selectedIndexes.contains(index);

            return GestureDetector(
              onTap: () =>
                  setState(() => controller.toggleSelection(index: index)),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Hindi Letter
                    Text(
                      item['letter']!,
                      style: ConstStyle.heading1.copyWith(
                        fontSize: SizeConfig.getProportionateScreenWidth(26),
                      ),
                    ),

                    SizedBox(
                      height: SizeConfig.getProportionateScreenHeight(12),
                    ),

                    /// Emoji inside Circle
                    CircleAvatar(
                      radius: SizeConfig.getProportionateScreenWidth(26),
                      child: Center(
                        child: Text(
                          item['emoji']!,
                          style: TextStyle(
                            fontSize: SizeConfig.getProportionateScreenWidth(
                              24,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: SizeConfig.getProportionateScreenHeight(12),
                    ),

                    /// Meaning text
                    Text(
                      item['meaning']!,
                      textAlign: TextAlign.center,
                      style: ConstStyle.heading4.copyWith(
                        fontSize: SizeConfig.getProportionateScreenWidth(16),
                      ),
                    ),
                  ],
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
