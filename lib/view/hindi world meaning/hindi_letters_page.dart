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

class _HindiLettersPageState extends State<HindiLettersPage>
    with SingleTickerProviderStateMixin {
  final HindiLettersController controller = Get.put(HindiLettersController());

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
              Color(0xFFFFF1A6), // light yellow
              Color(0xFFFFC1E3), // pink
              Color(0xFFA6E4FF), // light blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: SizeConfig.getProportionateScreenHeight(12),
              left: SizeConfig.getProportionateScreenWidth(12),
              right: SizeConfig.getProportionateScreenWidth(12),
              bottom: SizeConfig.getProportionateScreenHeight(12),
            ),
            child: Column(
              children: [
                /// Fixed AppBar
                CustomAppBar(
                  title: "अ से ज्ञ तक",
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
                          controller.clearCache();
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.getProportionateScreenHeight(8)),

                /// GridView inside SingleChildScrollView
                GridView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(), // disable Grid scroll
                  shrinkWrap: true, // take only needed height
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
                  itemCount: controller.letters.length,
                  itemBuilder: (context, index) {
                    final item = controller.letters[index];
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
                        onTap: () => setState(
                          () => controller.toggleSelection(index: index),
                        ),
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
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      SizeConfig.getProportionateScreenHeight(
                                        12,
                                      ),
                                ),
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

                /// Ads Screen
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
}
