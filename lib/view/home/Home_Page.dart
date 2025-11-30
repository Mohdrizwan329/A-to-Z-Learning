import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view model/home controller/home_controller.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_GridView_Builder_Page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());

  late AnimationController _animationController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
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
              Color(0xFFB3E5FC), // light sky blue
              Color(0xFFFFF59D), // light yellow
              Color(0xFFFFCCBC), // light pink
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(
                SizeConfig.getProportionateScreenWidth(16),
              ),
              child: Column(
                children: [
                  CustomAppBar(
                    title: "Learning For Kids",
                    titleStyle: ConstStyle.heading2.copyWith(
                      fontSize: SizeConfig.getProportionateScreenWidth(18),
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Obx(() {
                    var items = controller.filteredItems;
                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(color: Colors.black87),
                        ),
                      );
                    }

                    return CustomGridViewBuilder(
                      items: items,
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.95,
                      itemBuilder: (context, index, item) {
                        return AnimatedBuilder(
                          animation: _floatAnimation,
                          builder: (_, child) {
                            return Transform.translate(
                              offset: Offset(0, _floatAnimation.value),
                              child: child,
                            );
                          },
                          child: GestureDetector(
                            onTap: () => Get.to(() => item.page!),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 1.0, end: 1.0),
                              duration: const Duration(milliseconds: 150),
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: child,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF4081), // vibrant pink
                                      Color(0xFFFFA000), // orange
                                      Color(0xFF00BCD4), // cyan
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    SizeConfig.getProportionateScreenWidth(18),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(2, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white.withOpacity(
                                        0.5,
                                      ),
                                      child: Icon(
                                        getIconForTitle(item.title),
                                        size: 32,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.title,
                                      style: ConstStyle.heading3.copyWith(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (item.subtitle.isNotEmpty)
                                      SizedBox(height: 4),
                                    Text(
                                      item.subtitle,
                                      style: ConstStyle.smallText1.copyWith(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
