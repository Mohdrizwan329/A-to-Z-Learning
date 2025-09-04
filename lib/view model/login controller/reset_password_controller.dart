import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  var isLoading = false.obs;

  void resetPassword() {
    final email = emailController.text.trim();
    final newPassword = newPassController.text.trim();
    final confirmPassword = confirmPassController.text.trim();

    if (email.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Invalid email format");
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters");
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    isLoading.value = true;

    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar("Success", "Password reset successful!");
      Get.offAllNamed('/login');
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.onClose();
  }
}
