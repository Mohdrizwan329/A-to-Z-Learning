import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/table%20controller/table_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/view/home/home_page.dart';
import 'package:learning_a_to_z/view/tables/Table_Count_Page.dart';
import 'package:learning_a_to_z/view/tables/Table_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class TableScreen extends StatefulWidget {
  TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen>
    with SingleTickerProviderStateMixin {
  final TableController controller = Get.put(TableController());

  late AnimationController _animationController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

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
    super.dispose();
  }

  /// Colorful & Floating Box
  Widget colorfulAnimatedBox(int number, bool isSelected, int index) {
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
          controller.toggleExpanded(index, number); // Use existing method
          Get.to(() => TableDetailScreen(number: number));
        },
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
                "$number",
                style: ConstStyle.heading1.copyWith(
                  fontSize: SizeConfig.getProportionateScreenWidth(26),
                  color: Colors.black87,
                  shadows: const [
                    Shadow(
                      color: Colors.white54,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final totalBoxes = 39;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Full screen gradient background
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
                /// CUSTOM APPBAR
                CustomAppBar(
                  title: "Tables",
                  titleStyle: ConstStyle.heading2.copyWith(
                    color: Colors.white,
                    fontSize: SizeConfig.getProportionateScreenWidth(20),
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
                      icon: Icon(Icons.refresh, color: Colors.white),
                      onPressed: controller.resetExpanded,
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.getProportionateScreenHeight(16)),

                /// GRID VIEW (Animated + Colorful Boxes)
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: totalBoxes,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: SizeConfig.getProportionateScreenWidth(
                      12,
                    ),
                    mainAxisSpacing: SizeConfig.getProportionateScreenHeight(
                      12,
                    ),
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final number = index + 2;
                    final isSelected = controller.expandedIndexes.contains(
                      index,
                    );
                    return colorfulAnimatedBox(number, isSelected, index);
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
