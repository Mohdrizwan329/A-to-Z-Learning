import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/learn%20set%20controller/fruit_learning_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_GridView_Builder_Page.dart';

class FruitLearningPage extends StatefulWidget {
  const FruitLearningPage({super.key});

  @override
  State<FruitLearningPage> createState() => _FruitLearningPageState();
}

class _FruitLearningPageState extends State<FruitLearningPage>
    with SingleTickerProviderStateMixin {
  final FruitLearningController controller = Get.put(FruitLearningController());

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
    controller.dispose();
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
              left: SizeConfig.getProportionateScreenWidth(16),
              right: SizeConfig.getProportionateScreenWidth(16),
              top: SizeConfig.getProportionateScreenHeight(12),
              bottom: SizeConfig.getProportionateScreenHeight(12),
            ),
            child: Column(
              children: [
                // Scrollable AppBar
                CustomAppBar(
                  titleStyle: ConstStyle.heading2.copyWith(color: Colors.white),
                  title: "Fruits Name",
                  showBackButton: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: SizeConfig.getProportionateScreenWidth(20),
                    ),
                    onPressed: () => Get.back(),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: SizeConfig.getProportionateScreenWidth(22),
                      ),
                      onPressed: () {
                        setState(() {
                          controller.resetSelection();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(8)),

                // GridView with floating animation
                CustomGridViewBuilder(
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: SizeConfig.getProportionateScreenHeight(12),
                  crossAxisSpacing: SizeConfig.getProportionateScreenWidth(12),
                  childAspectRatio: 1,
                  items: FruitLearningController.fruits,
                  itemBuilder: (context, index, item) {
                    final isSelected = index == controller.selectedIndex.value;

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
                            controller.selectFruit(index);
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
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.getProportionateScreenHeight(
                                12,
                              ),
                              horizontal:
                                  SizeConfig.getProportionateScreenWidth(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius:
                                      SizeConfig.getProportionateScreenWidth(
                                        30,
                                      ),
                                  child: Center(
                                    child: Text(
                                      item['emoji']!,
                                      style: TextStyle(
                                        fontSize:
                                            SizeConfig.getProportionateScreenWidth(
                                              28,
                                            ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      SizeConfig.getProportionateScreenHeight(
                                        10,
                                      ),
                                ),
                                Text(
                                  item['name']!,
                                  textAlign: TextAlign.center,
                                  style: ConstStyle.heading3.copyWith(
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

                // Ads
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
