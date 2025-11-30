import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/home/home_page.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/view/learn set/Animal_Name_Learning_Page.dart';
import 'package:learning_a_to_z/view/learn set/Bird_Name_Learning_Page.dart';
import 'package:learning_a_to_z/view/learn set/Color_name_learning_page.dart';
import 'package:learning_a_to_z/view/learn set/Flower_Name_Learning_Page.dart';
import 'package:learning_a_to_z/view/learn set/Fruit_Name_Learning_Page.dart';
import 'package:learning_a_to_z/view/learn%20set/bodyparts_name_learning_page.dart';
import 'package:learning_a_to_z/view/learn%20set/month_name_learning_page.dart';
import 'package:learning_a_to_z/view/learn%20set/vegetables_name_learning_page.dart';
import 'package:learning_a_to_z/view/learn%20set/week_day_learning_page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class LearningSetsGridScreen extends StatefulWidget {
  const LearningSetsGridScreen({super.key});

  @override
  State<LearningSetsGridScreen> createState() => _LearningSetsGridScreenState();
}

class _LearningSetsGridScreenState extends State<LearningSetsGridScreen>
    with SingleTickerProviderStateMixin {
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
            colors: [Color(0xFFFFF1A6), Color(0xFFFFC1E3), Color(0xFFA6E4FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                child: CustomAppBar(
                  titleStyle: ConstStyle.heading2.copyWith(
                    color: ConstColors.textColorWhit,
                  ),
                  title: "Learning Sets Practice",
                  showBackButton: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: ConstColors.textColorWhit,
                      size: SizeConfig.getProportionateScreenHeight(20),
                    ),
                    onPressed: () => Get.to(() => const HomeScreen()),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: ConstColors.textColorWhit,
                        size: SizeConfig.getProportionateScreenHeight(22),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: SizeConfig.getProportionateScreenHeight(12)),

              // Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: SizeConfig.getProportionateScreenWidth(12),
                  mainAxisSpacing: SizeConfig.getProportionateScreenHeight(12),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionateScreenWidth(16),
                  ),
                  children: [
                    _buildBox(
                      'Animals',
                      Icons.pets,
                      Colors.blue,
                      () => Get.to(() => AnimalLearningPage()),
                    ),
                    _buildBox(
                      'Birds',
                      Icons.flight,
                      Colors.redAccent,
                      () => Get.to(() => BirdLearningPage()),
                    ),
                    _buildBox(
                      'Flowers',
                      Icons.local_florist,
                      Colors.orange,
                      () => Get.to(() => FlowerLearningPage()),
                    ),
                    _buildBox(
                      'Fruits',
                      Icons.local_grocery_store,
                      Colors.purple,
                      () => Get.to(() => FruitLearningPage()),
                    ),
                    _buildBox(
                      'Vegetables',
                      Icons.eco,
                      Colors.green.shade700,
                      () => Get.to(() => VegetablesLearningPage()),
                    ),
                    _buildBox(
                      'Colors',
                      Icons.color_lens,
                      Colors.deepOrange,
                      () => Get.to(() => ColorsLearningPage()),
                    ),
                    _buildBox(
                      'Days',
                      Icons.calendar_today,
                      Colors.teal,
                      () => Get.to(() => WeekDayLearningPage()),
                    ),
                    _buildBox(
                      'Months',
                      Icons.event,
                      Colors.indigo,
                      () => Get.to(() => MonthLearningPage()),
                    ),
                    _buildBox(
                      'Body Parts',
                      Icons.accessibility_new,
                      Colors.pinkAccent,
                      () => Get.to(() => BodyPartsLearningPage()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(12)),

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
    );
  }

  Widget _buildBox(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: onTap,
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
              gradient: LinearGradient(
                colors: [color.withOpacity(0.4), color.withOpacity(0.2)],
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
              vertical: SizeConfig.getProportionateScreenHeight(20),
              horizontal: SizeConfig.getProportionateScreenWidth(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: SizeConfig.getProportionateScreenWidth(30),
                  child: Icon(
                    icon,
                    size: SizeConfig.getProportionateScreenWidth(28),
                    color: color,
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(10)),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateScreenWidth(16),
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
