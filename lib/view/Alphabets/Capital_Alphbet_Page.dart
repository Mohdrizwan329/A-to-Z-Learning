import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/class%20controller/capitall_alphabet_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_GridView_Builder_Page.dart';

class CapitalAlphbet26 extends StatefulWidget {
  const CapitalAlphbet26({super.key});

  @override
  State<CapitalAlphbet26> createState() => _CapitalAlphbet26State();
}

class _CapitalAlphbet26State extends State<CapitalAlphbet26>
    with SingleTickerProviderStateMixin {
  final CapitallAlphabetController controller = Get.put(
    CapitallAlphabetController(),
  );

  late AnimationController _animationController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
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

      /// 🌈 Kid-Friendly Gradient Background
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
            padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(12)),
            child: Column(
              children: [
                /// AppBar
                CustomAppBar(
                  title: "Capital Letter Alphabet",
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

                SizedBox(height: 12),

                /// GRID + FLOAT ANIMATION
                CustomGridViewBuilder<String>(
                  items: controller.alphabets,
                  crossAxisCount: 4,
                  mainAxisSpacing: SizeConfig.getProportionateScreenHeight(12),
                  crossAxisSpacing: SizeConfig.getProportionateScreenWidth(12),
                  childAspectRatio: 1,
                  itemBuilder: (context, index, item) {
                    final letter = controller.alphabets[index];
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
                            controller.handleTap(index);
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
                                        Color(0xFFFFA726), // vibrant orange
                                        Color(0xFFFFEB3B), // yellow
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : const LinearGradient(
                                      colors: [
                                        Color(0xFF81D4FA), // light blue
                                        Color(0xFFB39DDB), // soft purple
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              borderRadius: BorderRadius.circular(
                                SizeConfig.getProportionateScreenWidth(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: const Offset(2, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                letter,
                                style: ConstStyle.heading1.copyWith(
                                  fontSize:
                                      SizeConfig.getProportionateScreenWidth(
                                        22,
                                      ),
                                ),
                              ),
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
