import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/home/home_page.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/view/math%20qustion/add_qust_page.dart';
import 'package:learning_a_to_z/view/math%20qustion/div_qust_page.dart';
import 'package:learning_a_to_z/view/math%20qustion/mul_qust_page.dart';
import 'package:learning_a_to_z/view/math%20qustion/sub_qust_page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class MathQustionGridScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF1A6), Color(0xFFFFC1E3), Color(0xFFA6E4FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(16)),
            child: Column(
              children: [
                CustomAppBar(
                  title: "Math Practice",
                  titleStyle: ConstStyle.heading2.copyWith(
                    fontSize: SizeConfig.getProportionateScreenWidth(20),
                    color: Colors.white,
                  ),
                  showBackButton: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: SizeConfig.getProportionateScreenWidth(22),
                    ),
                    onPressed: () => Get.to(() => HomeScreen()),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: SizeConfig.getProportionateScreenWidth(22),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: SizeConfig.getProportionateScreenWidth(
                      16,
                    ),
                    mainAxisSpacing: SizeConfig.getProportionateScreenHeight(
                      16,
                    ),
                    children: [
                      FloatingBox(
                        label: 'Addition',
                        icon: Icons.add,
                        color: ConstColors.primaryBlue,
                        onTap: () => Get.to(() => AdditionQuestionsScreen()),
                      ),
                      FloatingBox(
                        label: 'Subtraction',
                        icon: Icons.remove,
                        color: ConstColors.primaryRed,
                        onTap: () => Get.to(() => SubtractionQuestionsScreen()),
                      ),
                      FloatingBox(
                        label: 'Multiplication',
                        icon: Icons.clear,
                        color: ConstColors.primaryYellow,
                        onTap: () =>
                            Get.to(() => MultiplicationQuestionsScreen()),
                      ),
                      FloatingBox(
                        label: 'Division',
                        icon: Icons.percent,
                        color: ConstColors.primaryGreen,
                        onTap: () => Get.to(() => DivisionQuestionsScreen()),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),

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

class FloatingBox extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const FloatingBox({
    Key? key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  State<FloatingBox> createState() => _FloatingBoxState();
}

class _FloatingBoxState extends State<FloatingBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -6,
      end: 6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              SizeConfig.getProportionateScreenWidth(12),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.color.withOpacity(0.5),
                  widget.color.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(
                SizeConfig.getProportionateScreenWidth(12),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: SizeConfig.getProportionateScreenWidth(30),
                    backgroundColor: Colors.white,
                    child: Icon(
                      widget.icon,
                      color: widget.color,
                      size: SizeConfig.getProportionateScreenWidth(30),
                    ),
                  ),
                  SizedBox(height: SizeConfig.getProportionateScreenHeight(10)),
                  Text(
                    widget.label,
                    style: ConstStyle.heading2.copyWith(
                      fontSize: SizeConfig.getProportionateScreenWidth(18),
                      color: widget.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
