import 'dart:async';
import 'package:get/get.dart';

class OTPController extends GetxController {
  var timer = 60.obs;
  late Timer _countdown;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (this.timer.value > 0) {
        this.timer.value--;
      } else {
        _countdown.cancel();
      }
    });
  }

  void resendOtp() {
    timer.value = 60;
    startTimer();
  }

  void verifyOtp(String otp) {
    if (otp == "123456") {
      Get.snackbar("Success", "OTP Verified");
    } else {
      Get.snackbar("Error", "Invalid OTP");
    }
  }

  @override
  void onClose() {
    _countdown.cancel();
    super.onClose();
  }
}
