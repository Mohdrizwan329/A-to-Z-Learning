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
    final next = routing?.current ?? '';
    if (next == currentRoute.value) return;
    // GetX calls this while the Navigator is still applying the route change.
    // Writing the observable now would mark the banner dirty in the middle of
    // that update; defer to after the frame so the rebuild lands on a settled
    // tree.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentRoute.value = next;
    });
  }

  bool _hasAds(String route) {
    if (!AdService.adsEnabled) return false;
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

    final bottomInset = mq.padding.bottom;

    // `child` is the app's Navigator, and it is deliberately kept OUT of the
    // Obx below. Rebuilding it on a route change corrupts the element tree --
    // routingCallback fires while Navigator is mid-update, so the rebuild lands
    // in the middle of that mutation and trips
    // '_elements.contains(element)', replacing the whole app with a red error
    // screen. Only the strip underneath is allowed to react.
    //
    // The bottom system inset is handed to that strip unconditionally, so this
    // MediaQuery never has to change with the banner's visibility.
    final content = MediaQuery(
      data: mq.copyWith(
        padding: mq.padding.copyWith(bottom: 0),
        viewPadding: mq.viewPadding.copyWith(bottom: 0),
      ),
      child: child,
    );

    return Column(
      children: [
        Expanded(child: content),
        Obx(() {
          // Read first and unconditionally: Obx throws instead of rendering
          // when a build registers no observable, and every check below can
          // bail out early.
          final route = currentRoute.value;

          // The keyboard already eats most of the screen; a banner on top of
          // that leaves nothing of the form the user is typing into.
          final keyboardOpen = mq.viewInsets.bottom > 0;
          final showBanner = _hasAds(route) && !keyboardOpen;

          // Either way this strip owns the bottom inset the app above gave up.
          return Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: showBanner
                ? const AdsScreen(collapseWhenUnfilled: true)
                : const SizedBox.shrink(),
          );
        }),
      ],
    );
  }
}
