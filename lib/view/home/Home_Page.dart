import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/home_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_GridView_Builder_Page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    // initialize SizeConfig
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      appBar: CustomAppBar(
        title: "Learning For Kids",
        titleStyle: ConstStyle.heading2.copyWith(
          fontSize: SizeConfig.getProportionateScreenWidth(18),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              size: SizeConfig.getProportionateScreenWidth(24),
              color: ConstColors.textColorWhit,
            ),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(16)),
          child: Column(
            children: [
              /// 🔍 Ads Banner
              AdsScreen(),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(16)),

              /// 🔍 Grid Items
              Obx(() {
                var items = controller.filteredItems;
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(
                        SizeConfig.getProportionateScreenWidth(20),
                      ),
                      child: Text(
                        "No results found",
                        style: TextStyle(
                          fontSize: SizeConfig.getProportionateScreenWidth(14),
                        ),
                      ),
                    ),
                  );
                }
                return CustomGridViewBuilder(
                  items: items,
                  crossAxisCount: 2,
                  mainAxisSpacing: SizeConfig.getProportionateScreenHeight(10),
                  crossAxisSpacing: SizeConfig.getProportionateScreenWidth(10),
                  childAspectRatio: 0.9,
                  itemBuilder: (context, index, item) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => item.page!);
                      },
                      child: Card(
                        elevation: 4,
                        color: ConstColors.textColorWhit,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            SizeConfig.getProportionateScreenWidth(12),
                          ),
                          side: BorderSide(
                            color: ConstColors.dividerColor,
                            width: SizeConfig.getProportionateScreenWidth(1),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.getProportionateScreenWidth(
                              8,
                            ),
                            vertical: SizeConfig.getProportionateScreenHeight(
                              12,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius:
                                    SizeConfig.getProportionateScreenWidth(40) /
                                    1.5,
                                backgroundColor: ConstColors.primaryGreen
                                    .withOpacity(0.1),
                                child: Icon(
                                  getIconForTitle(item.title),
                                  size:
                                      SizeConfig.getProportionateScreenWidth(
                                        40,
                                      ) *
                                      0.6,
                                  color: ConstColors.primaryGreen,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.getProportionateScreenHeight(
                                  8,
                                ),
                              ),
                              Text(
                                item.title,
                                style: ConstStyle.heading3.copyWith(
                                  fontSize:
                                      SizeConfig.getProportionateScreenWidth(
                                        14,
                                      ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (item.subtitle.isNotEmpty)
                                SizedBox(
                                  height:
                                      SizeConfig.getProportionateScreenHeight(
                                        5,
                                      ),
                                ),
                              Text(
                                item.subtitle,
                                style: ConstStyle.smallText1.copyWith(
                                  fontSize:
                                      SizeConfig.getProportionateScreenWidth(
                                        12,
                                      ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
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
    );
  }
}
