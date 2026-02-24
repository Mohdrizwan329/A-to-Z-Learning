import 'package:flutter/material.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

/// A wrapper widget that adds a banner ad at the bottom of any screen
/// Use this to wrap the body of any Scaffold to show ads
class AdWrapper extends StatelessWidget {
  final Widget child;
  final bool showAd;

  const AdWrapper({super.key, required this.child, this.showAd = true});

  @override
  Widget build(BuildContext context) {
    if (!showAd) return child;

    return Column(
      children: [
        Expanded(child: child),
        const AdsScreen(),
      ],
    );
  }
}

/// Extension method to easily wrap any widget with ads
extension AdWrapperExtension on Widget {
  Widget withBottomAd({bool showAd = true}) {
    return AdWrapper(showAd: showAd, child: this);
  }
}
