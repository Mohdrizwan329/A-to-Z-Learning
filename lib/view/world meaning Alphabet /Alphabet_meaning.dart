import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view model/alphabet controller/world_meaning_alphabet_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class AlphabetMening extends StatefulWidget {
  AlphabetMening({super.key});

  @override
  State<AlphabetMening> createState() => _AlphabetMeningState();
}

class _AlphabetMeningState extends State<AlphabetMening>
    with SingleTickerProviderStateMixin {
  final WorldMeaningAlphabetController controller = Get.put(
    WorldMeaningAlphabetController(),
  );

  late AnimationController _animationController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    controller.clearCache();
    Get.delete<WorldMeaningAlphabetController>();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF1A6), // yellow
              Color(0xFFFFC1E3), // pink
              Color(0xFFA6E4FF), // blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(12)),
            child: Column(
              children: [
                // SAME APPBAR STYLE
                CustomAppBar(
                  title: "Words Meaning",
                  titleStyle: ConstStyle.heading2.copyWith(
                    fontSize: SizeConfig.getProportionateScreenWidth(18),
                    color: Colors.white,
                  ),
                  showBackButton: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: SizeConfig.getProportionateScreenWidth(18),
                    ),
                    onPressed: () => Get.back(),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
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

                SizedBox(height: SizeConfig.getProportionateScreenHeight(8)),

                // GRID VIEW
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: SizeConfig.getProportionateScreenHeight(
                      12,
                    ),
                    crossAxisSpacing: SizeConfig.getProportionateScreenWidth(
                      12,
                    ),
                    childAspectRatio: 1,
                  ),
                  itemCount: controller.alphabetData.length,
                  itemBuilder: (context, index) {
                    final item = controller.alphabetData[index];
                    final isSelected = controller.selectedIndexes.contains(
                      index,
                    );

                    return AnimatedBuilder(
                      animation: _floatAnimation,
                      builder: (_, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatAnimation.value),
                          child: child,
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            controller.toggleSelection(
                              index: index,
                              showSnack: _showSnack,
                            );
                          });
                        },
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              SizeConfig.getProportionateScreenWidth(12),
                            ),
                            side: BorderSide(
                              color: ConstColors.dividerColor,
                              width: SizeConfig.getProportionateScreenWidth(1),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFFFFD2A6),
                                        Color(0xFFB6FFC1),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : const LinearGradient(
                                      colors: [
                                        Color(0xFF81D4FA),
                                        Color(0xFFFFC1E3),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              borderRadius: BorderRadius.circular(
                                SizeConfig.getProportionateScreenWidth(12),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// Letter
                                Text(
                                  item['letter']!,
                                  style: ConstStyle.heading1.copyWith(
                                    fontSize:
                                        SizeConfig.getProportionateScreenWidth(
                                          26,
                                        ),
                                  ),
                                ),

                                SizedBox(
                                  height:
                                      SizeConfig.getProportionateScreenHeight(
                                        12,
                                      ),
                                ),

                                /// Emoji
                                CircleAvatar(
                                  radius:
                                      SizeConfig.getProportionateScreenWidth(
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
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height:
                                      SizeConfig.getProportionateScreenHeight(
                                        12,
                                      ),
                                ),

                                /// Meaning
                                Text(
                                  item['meaning']!,
                                  textAlign: TextAlign.center,
                                  style: ConstStyle.heading4.copyWith(
                                    fontSize:
                                        SizeConfig.getProportionateScreenWidth(
                                          16,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),

                // ADS BOTTOM
                SizedBox(
                  height: SizeConfig.getProportionateScreenHeight(80),
                  width: double.infinity,
                  child: AdsScreen(),
                ),
              ],
            ),
          ),
        ),
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
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
