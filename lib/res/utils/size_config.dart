import 'package:flutter/widgets.dart';

import 'package:jiyan_learning/utils/responsive.dart';

/// Legacy sizing helper, kept so the pages that already call it keep working.
///
/// It used to scale linearly against the raw screen size, which meant a
/// 1920pt-wide desktop window multiplied every value by 5.12. It now delegates
/// to [R], which clamps the scale and measures the capped content column rather
/// than the whole window. Prefer `.w` / `.h` / `.r` from `utils/responsive.dart`
/// in new code.
class SizeConfig {
  static void init(BuildContext context) => R.update(MediaQuery.of(context));

  /// Width of the column the UI is actually laid out in.
  static double get screenWidth => R.layoutWidth;

  static double get screenHeight => R.screenHeight;

  static double getProportionateScreenHeight(double inputHeight) =>
      R.h(inputHeight);

  static double getProportionateScreenWidth(double inputWidth) =>
      R.w(inputWidth);
}
