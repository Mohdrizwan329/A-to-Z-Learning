import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/ad_service.dart';
import 'package:jiyan_learning/services/premium_service.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

/// Mounts a single banner ad below every screen in the app.
///
/// This sits in `GetMaterialApp.builder`, i.e. outside the Navigator, so one
/// banner is shared by all 200+ screens instead of each one creating and
/// disposing its own on every push and pop.
class GlobalAdShell extends StatelessWidget {
  const GlobalAdShell({super.key, required this.child});

  final Widget child;

  /// Master switch for the app-wide banner.
  ///
  /// Off for now, so the wiring is in place but no screen's layout changes.
  /// Flip to true to turn the banner on across every screen at once.
  static bool adsEnabled = false;

  /// Routes that must stay ad-free: the splash and auth flow, and the pages
  /// that sell the ad-free upgrade.
  static const Set<String> _adFreeRoutes = {
    '/',
    '/login',
    '/signup',
    '/forgot-password',
    '/premium',
    '/premium-features',
  };

  /// Tracks the active route so the shell can rebuild on navigation. Fed by
  /// `GetMaterialApp.routingCallback` in main.dart.
  static final RxString currentRoute = ''.obs;

  static void onRouteChanged(Routing? routing) {
    currentRoute.value = routing?.current ?? '';
  }

  bool _hasAds(String route) {
    if (!adsEnabled) return false;
    if (!AdService.isAvailable) return false;
    if (_adFreeRoutes.contains(route)) return false;
    // PremiumService is registered lazily, so treat "not loaded yet" as free.
    if (Get.isRegistered<PremiumService>() && !PremiumService.to.shouldShowAds) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Obx(() {
      // Read first and unconditionally: Obx throws instead of rendering when a
      // build registers no observable, and every check below can bail out
      // early -- including the adsEnabled switch, which is off by default.
      final route = currentRoute.value;

      // The keyboard already eats most of the screen; a banner on top of that
      // leaves nothing of the form the user is typing into.
      final keyboardOpen = mq.viewInsets.bottom > 0;
      final showBanner = _hasAds(route) && !keyboardOpen;

      // The shape of this tree must NOT change with showBanner. Returning
      // `child` bare on ad-free routes and a Column elsewhere re-parents the
      // whole Navigator on the first navigation away from the splash, which
      // trips '_elements.contains(element)' and replaces the app with a red
      // error screen. Keep one structure and vary only what fills the slot.
      final bottomInset = mq.padding.bottom;
      final content = MediaQuery(
        data: showBanner
            // With a banner present it owns the bottom system inset, so the
            // screens above must stop reserving that space or every SafeArea
            // leaves a double gap.
            ? mq.copyWith(
                padding: mq.padding.copyWith(bottom: 0),
                viewPadding: mq.viewPadding.copyWith(bottom: 0),
              )
            : mq,
        child: child,
      );

      return Column(
        children: [
          Expanded(child: content),
          if (showBanner)
            Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: const AdsScreen(collapseWhenUnfilled: true),
            )
          else
            const SizedBox.shrink(),
        ],
      );
    });
  }
}
