import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Screen-size buckets the UI adapts to.
///
/// Buckets are chosen from the *shortest* side so a phone held sideways is
/// still treated as a phone, while a tablet stays a tablet in both rotations.
enum DeviceType { mobile, tablet, desktop }

/// Global responsive metrics.
///
/// [update] is called from the app's `builder`, so every value here is
/// re-derived whenever the window resizes, the device rotates, or the user
/// changes their system font size.
class R {
  R._();

  /// The canvas every hardcoded size in this app was originally drawn against.
  /// Matches the base already used by `SizeConfig`.
  static const double baseWidth = 375;
  static const double baseHeight = 812;

  /// Widest the content is ever allowed to get, per bucket. Beyond this the
  /// shell centres the app instead of stretching it, so a maximised desktop
  /// window shows a comfortable column rather than a smeared-out phone layout.
  ///
  /// These are deliberately close to [baseWidth]. The app has 143 grids with a
  /// hardcoded `crossAxisCount` (132 of them `const`, so unreachable by any
  /// call-site rewrite), and a 2-column grid stretched across a 1200pt window
  /// produces absurd tiles. Capping the column keeps every one of those grids
  /// in proportion without editing a single delegate.
  static const double _maxWidthTablet = 600;
  static const double _maxWidthDesktop = 680;

  static double _screenWidth = baseWidth;
  static double _screenHeight = baseHeight;
  static double _layoutWidth = baseWidth;
  static double _scale = 1;
  static double _textScale = 1;
  static DeviceType _device = DeviceType.mobile;
  static EdgeInsets _viewPadding = EdgeInsets.zero;
  static Orientation _orientation = Orientation.portrait;
  static bool _ready = false;

  static void update(MediaQueryData mq) {
    _screenWidth = mq.size.width;
    _screenHeight = mq.size.height;
    _viewPadding = mq.padding;
    _orientation = mq.orientation;

    final shortest = math.min(_screenWidth, _screenHeight);
    if (_screenWidth >= 1100 || (isWindowed && _screenWidth >= 900)) {
      // A desktop or browser window is judged on its width: 1440x900 is a
      // desktop, even though its shortest side would read as a tablet.
      _device = DeviceType.desktop;
    } else if (shortest >= 600) {
      // Shortest side for the phone/tablet split, so rotating a device does not
      // change what it is.
      _device = DeviceType.tablet;
    } else {
      _device = DeviceType.mobile;
    }

    _layoutWidth = math.min(_screenWidth, maxContentWidth);

    final raw = _layoutWidth / baseWidth;
    // Clamped, not linear: a 1040pt desktop column should not render buttons
    // three times the size of the phone ones.
    _scale = raw.clamp(0.82, 1.45);
    // Never above [_scale]: text that shrinks less than the box around it
    // overflows every tight row and tile on a small phone. The ceiling stays
    // lower than the layout ceiling so text does not balloon on a tablet.
    _textScale = raw.clamp(0.82, 1.22);
    _ready = true;
  }

  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;
  static double get layoutWidth => _layoutWidth;
  static double get scale => _ready ? _scale : 1;
  static double get textScale => _ready ? _textScale : 1;
  static DeviceType get device => _device;
  static EdgeInsets get viewPadding => _viewPadding;
  static Orientation get orientation => _orientation;
  static bool get isLandscape => _orientation == Orientation.landscape;

  static bool get isMobile => _device == DeviceType.mobile;
  static bool get isTablet => _device == DeviceType.tablet;
  static bool get isDesktop => _device == DeviceType.desktop;

  /// True on the platforms where a resizable window (not a fixed screen) is
  /// what the app is living in.
  static bool get isWindowed =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;

  static double get maxContentWidth {
    switch (_device) {
      case DeviceType.desktop:
        return _maxWidthDesktop;
      case DeviceType.tablet:
        return _maxWidthTablet;
      case DeviceType.mobile:
        return double.infinity;
    }
  }

  /// Scale a length that was authored against [baseWidth].
  static double w(num value) => value * scale;

  /// Scale a vertical length. Tracks width so aspect ratios hold; height only
  /// contributes on very short screens, where it pulls sizes back down so
  /// fixed-height rows stop overflowing.
  static double h(num value) {
    final heightFactor = (_screenHeight / baseHeight).clamp(0.80, 1.0);
    return value * scale * (_ready ? heightFactor : 1);
  }

  /// Font sizes are scaled globally by [ResponsiveShell] through
  /// `MediaQuery.textScaler`, which is applied when text is painted and so
  /// reaches every `fontSize` in the app — including the ~1,100 that sit inside
  /// `const TextStyle`, which no call-site rewrite could have touched without
  /// stripping their `const`.
  ///
  /// This is therefore deliberately an identity: writing `16.sp` stays readable
  /// and consistent with `.w` / `.r`, but must not scale a second time.
  static double sp(num value) => value.toDouble();

  /// Scale a radius, padding or gap.
  static double r(num value) => value * scale;

  /// A fraction of the usable content width.
  static double widthPct(double fraction) => _layoutWidth * fraction;

  /// A fraction of the screen height.
  static double heightPct(double fraction) => _screenHeight * fraction;

  /// Pick a value per bucket, falling back down the chain when one is omitted.
  static T pick<T>({required T mobile, T? tablet, T? desktop}) {
    switch (_device) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }

  /// Column count for a grid whose tiles want to be about [targetTileWidth]
  /// wide. Grids get denser on bigger screens instead of growing giant tiles.
  static int gridColumns({
    double targetTileWidth = 180,
    int min = 2,
    int max = 6,
  }) {
    final columns = (_layoutWidth / (targetTileWidth * scale)).floor();
    return columns.clamp(min, max);
  }
}

/// `16.sp`, `12.r`, `40.h` — the same units used across the app's widgets.
extension ResponsiveNum on num {
  /// Horizontal / general length.
  double get w => R.w(this);

  /// Vertical length.
  double get h => R.h(this);

  /// Font size.
  double get sp => R.sp(this);

  /// Radius, padding, gap.
  double get r => R.r(this);

  /// Fraction of the content width (`0.5.sw` is half the column).
  double get sw => R.widthPct(toDouble());

  /// Fraction of the screen height.
  double get sh => R.heightPct(toDouble());
}

extension ResponsiveContext on BuildContext {
  DeviceType get deviceType => R.device;
  bool get isMobile => R.isMobile;
  bool get isTablet => R.isTablet;
  bool get isDesktop => R.isDesktop;
  bool get isLandscape => R.isLandscape;

  /// Content width after the shell's max-width cap.
  double get contentWidth => R.layoutWidth;

  T responsive<T>({required T mobile, T? tablet, T? desktop}) =>
      R.pick(mobile: mobile, tablet: tablet, desktop: desktop);
}

/// Lets every scrollable be dragged with a mouse or trackpad, not just flicked
/// with a finger.
///
/// Flutter ships desktop and web without mouse drag-scrolling, so on Windows,
/// macOS, Linux, Chrome and Edge the app's carousels and grids would only
/// respond to a wheel. This restores the obvious gesture on every platform.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
      };
}

/// Keeps [R] in step with the live [MediaQuery], clamps runaway system font
/// scaling, and stops the phone-shaped layout from stretching across a wide
/// desktop or tablet window.
///
/// Install it once via `GetMaterialApp.builder`.
class ResponsiveShell extends StatelessWidget {
  const ResponsiveShell({
    super.key,
    required this.child,
    this.background,
  });

  final Widget child;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    R.update(mq);

    // Text scaling is where this app becomes responsive without touching its
    // 3,242 hardcoded `fontSize` values: textScaler is applied when text is
    // painted, so it reaches const styles too.
    //
    // Two factors are composed:
    //  * the device factor, so a 320pt phone renders ~12% smaller text than the
    //    375pt canvas the UI was drawn for, and a tablet renders ~22% larger;
    //  * the user's own system font setting, clamped so an extreme accessibility
    //    setting cannot burst the app's many fixed-height cards.
    final userFactor = mq.textScaler.scale(1).clamp(0.85, 1.30);
    var clamped = mq.copyWith(
      textScaler: TextScaler.linear(userFactor * R.textScale),
    );

    final maxWidth = R.maxContentWidth;
    Widget content = child;

    if (maxWidth.isFinite && mq.size.width > maxWidth) {
      // The 92 `MediaQuery.of(context).size` call sites inside the app must see
      // the column they are actually laid out in, not the full window, or every
      // width they compute overflows the cap.
      clamped = clamped.copyWith(
        size: Size(maxWidth, mq.size.height),
      );
      // Fill the space either side of the column, otherwise a maximised window
      // shows the app floating on bare canvas.
      final backdrop = background ??
          Color.lerp(
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.primary,
            0.06,
          )!;
      content = ColoredBox(
        color: backdrop,
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(width: maxWidth, child: content),
        ),
      );
    }

    return MediaQuery(data: clamped, child: content);
  }
}
