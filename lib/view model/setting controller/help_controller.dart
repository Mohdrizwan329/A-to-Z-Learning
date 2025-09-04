import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HelpController extends GetxController {
  final name = ''.obs;
  final phone = ''.obs;
  final email = ''.obs;
  final message = ''.obs;

  final isLoading = false.obs;

  Future<void> submitFeedback({
    required String routeName,
    required GlobalKey<FormState> formKey,
  }) async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      name.value = '';
      phone.value = '';
      email.value = '';
      message.value = '';

      Get.snackbar(
        'Success',
        'Your message has been submitted',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
