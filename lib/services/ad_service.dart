import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class AdService extends GetxService {
  static AdService? get instance =>
      Get.isRegistered<AdService>() ? Get.find<AdService>() : null;
  static AdService get to => Get.find<AdService>();
  static bool get isAvailable => Get.isRegistered<AdService>();

  /// Master switch for every ad in the app.
  ///
  /// AdsScreen checks this before requesting anything, so flipping it here
  /// turns ads on or off across all ~150 screens that embed a banner plus the
  /// app-wide GlobalAdShell -- no per-screen edits needed.
  static bool adsEnabled = false;

  // Banner Ad Unit ID
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Test Banner
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // Test Banner
    }
    return '';
  }

  Future<AdService> init() async {
    await MobileAds.instance.initialize();
    return this;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
