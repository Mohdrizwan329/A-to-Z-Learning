import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/view/home/Home_Page.dart';
import 'package:learning_a_to_z/view/ocr/ocr_page.dart';
import 'package:learning_a_to_z/view/profile/profile_page.dart';
import 'package:learning_a_to_z/widgets/custom_bottom_nav_bar.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}

class BottomNavigatBarScreen extends StatefulWidget {
  const BottomNavigatBarScreen({super.key});

  @override
  State<BottomNavigatBarScreen> createState() => _BottomNavigatBarScreenState();
}

class _BottomNavigatBarScreenState extends State<BottomNavigatBarScreen> {
  final BottomNavController controller = Get.put(BottomNavController());

  final List<Widget> screens = [
    HomeScreen(),
    OcrScreen(),

    ProfileScreen(name: 'Arun', email: 'Arun@gmail.com', appVersion: 'v2.0.1'),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: ConstColors.backgroundColorWhite,
        body: screens[controller.selectedIndex.value],
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
        ),
      );
    });
  }
}
