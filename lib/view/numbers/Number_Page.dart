import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/number%20controller/numbers_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class NumbersScreen extends StatefulWidget {
  const NumbersScreen({super.key});

  @override
  State<NumbersScreen> createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen>
    with SingleTickerProviderStateMixin {
  late final NumbersController controller;
  final numbersList = List.generate(100, (index) => index + 1);

  late AnimationController _animationController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.put(NumbersController());
    controller.resetSelection();

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
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionateScreenWidth(12),
              vertical: SizeConfig.getProportionateScreenHeight(12),
            ),
            child: Column(
              children: [
                /// AppBar
                CustomAppBar(
                  title: "Numbers",
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
                          controller.resetSelection();
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.getProportionateScreenHeight(12)),

                /// Grid + Floating Animation
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: SizeConfig.getProportionateScreenHeight(
                      12,
                    ),
                    crossAxisSpacing: SizeConfig.getProportionateScreenWidth(
                      12,
                    ),
                    childAspectRatio: 1,
                  ),
                  itemCount: numbersList.length,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      final isSelected =
                          controller.selectedIndex.value == index;

                      return AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (_, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnimation.value),
                            child: child,
                          );
                        },
                        child: GestureDetector(
                          onTap: () => controller.handleTap(index),
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                SizeConfig.getProportionateScreenWidth(12),
                              ),
                              side: BorderSide(
                                color: ConstColors.dividerColor,
                                width: SizeConfig.getProportionateScreenWidth(
                                  1,
                                ),
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
                              child: Center(
                                child: Text(
                                  '${numbersList[index]}',
                                  style: ConstStyle.heading1.copyWith(
                                    fontSize:
                                        SizeConfig.getProportionateScreenWidth(
                                          24,
                                        ),
                                  ),
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
      ),
      bottomNavigationBar: SizedBox(
        height: SizeConfig.getProportionateScreenHeight(80),
        width: double.infinity,
        child: AdsScreen(),
      ),
    );
  }
}
