import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view model/table controller/table_detail_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/view/tables/Table_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class TableDetailScreen extends StatefulWidget {
  final int number;

  const TableDetailScreen({super.key, required this.number});

  @override
  State<TableDetailScreen> createState() => _TableDetailScreenState();
}

class _TableDetailScreenState extends State<TableDetailScreen>
    with SingleTickerProviderStateMixin {
  late TableDetailController controller;
  late AnimationController _animationController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TableDetailController(widget.number));

    // Floating animation
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
    Get.delete<TableDetailController>();
    super.dispose();
  }

  Widget buildAnimatedSelectableBox(int index, int product) {
    return Obx(() {
      bool isSelected = controller.selectedIndex.value == index;

      return AnimatedBuilder(
        animation: _floatAnimation,
        builder: (_, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: child,
          );
        },
        child: GestureDetector(
          onTap: () => controller.onBoxTap(index),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [
                          Color(0xFFFFD2A6), // orange-light
                          Color(0xFFB6FFC1), // green-light
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [
                          Color(0xFF81D4FA), // blue-light
                          Color(0xFFFFC1E3), // pink-light
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(12),
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
                  "$product",
                  style: ConstStyle.heading1.copyWith(
                    color: Colors.black87,
                    fontSize: SizeConfig.getProportionateScreenWidth(22),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

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
            padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(16)),
            child: Column(
              children: [
                /// APP BAR
                CustomAppBar(
                  title: "${widget.number} Table",
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
                    onPressed: () => Get.to(() => TableScreen()),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: SizeConfig.getProportionateScreenWidth(22),
                      ),
                      onPressed: () => controller.resetStep(),
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),

                /// GRID VIEW
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                  ),
                  itemBuilder: (context, i) {
                    final product = widget.number * (i + 1);
                    return buildAnimatedSelectableBox(i, product);
                  },
                ),

                SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),

                /// ADS
                SizedBox(
                  height: SizeConfig.getProportionateScreenHeight(80),
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
