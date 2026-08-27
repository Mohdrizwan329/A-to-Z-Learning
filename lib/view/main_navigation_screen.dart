import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view/home/Home_Page.dart';
import 'package:jiyan_learning/view/alarm/study_alarm_page.dart';
import 'package:jiyan_learning/view/ocr/ocr_page.dart';
import 'package:jiyan_learning/view/math%20scanner/math_scanner_page.dart';
import 'package:jiyan_learning/view/profiles/profile/profile_page.dart';
import 'package:jiyan_learning/view%20model/auth%20controller/auth_controller.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class MainNavigationController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}

class MainNavigationScreen extends StatelessWidget {
  MainNavigationScreen({super.key});

  final controller = Get.put(MainNavigationController());

  /// Built once, not inside the Obx below. Each of these pages runs a
  /// `Get.put` of its own controller as it is constructed, so rebuilding them
  /// on every user-model change would hand the scanner screens a brand-new
  /// controller -- dropping the questions already on screen.
  final _scanPages = <Widget>[OcrScreen(), MathScannerPage()];

  /// Same reason as above: built once, so its alarm list is not rebuilt out
  /// from under the user on an unrelated change.
  final _alarmPage = StudyAlarmPage();

  AuthController get authController {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
    return Get.find<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // This Obx will rebuild when userModel changes
        final user = authController.userModel;
        final firebaseUser = authController.firebaseUser;
        final email = firebaseUser?.email ?? user?.parentEmail ?? "Guest";

        return IndexedStack(
          index: controller.currentIndex.value,
          children: [
            const HomeScreen(),
            _scanPages[0],
            _scanPages[1],
            _alarmPage,
            ProfileScreen(
              name: user?.childName ?? "Guest User",
              email: email,
              location: user?.location,
              appVersion: "1.0.0",
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10.r,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: _buildNavItem(
                      index: 0,
                      icon: Icons.home_rounded,
                      label: "Home",
                    ),
                  ),
                  Flexible(
                    child: _buildNavItem(
                      index: 1,
                      icon: Icons.document_scanner_rounded,
                      label: "MCQ",
                    ),
                  ),
                  Flexible(
                    child: _buildNavItem(
                      index: 2,
                      icon: Icons.camera_alt_rounded,
                      label: "Math",
                    ),
                  ),
                  Flexible(
                    child: _buildNavItem(
                      index: 3,
                      icon: Icons.alarm_rounded,
                      label: "Alarm",
                    ),
                  ),
                  Flexible(
                    child: _buildNavItem(
                      index: 4,
                      icon: Icons.person_rounded,
                      label: "Profile",
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

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = controller.currentIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22.r),
            SizedBox(height: 4.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
