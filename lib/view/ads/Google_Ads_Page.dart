import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jiyan_learning/services/ad_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

/// Full-width Banner Ad Widget
class AdsScreen extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final bool showGradientBorder;

  /// When true the widget takes no space at all once a request comes back
  /// unfilled, instead of holding the loading placeholder open. Used by the
  /// app-wide banner, where a permanent empty strip would sit on every screen.
  final bool collapseWhenUnfilled;

  const AdsScreen({
    super.key,
    this.margin,
    this.showGradientBorder = false,
    this.collapseWhenUnfilled = false,
  });

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  AdService? _adService;
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  UniqueKey _adKey = UniqueKey();
  bool _adLoadStarted = false;
  bool _isDisposed = false;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    _adService = AdService.instance;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_adLoadStarted && _adService != null) {
      _adLoadStarted = true;
      _loadAd();
    }
  }

  void _loadAd() async {
    if (!AdService.adsEnabled) return;
    if (_adService == null || !mounted || _isDisposed) return;

    // Dispose old ad if exists
    _bannerAd?.dispose();
    _bannerAd = null;
    _loadFailed = false;

    // Use adaptive banner for full width, fallback to standard banner
    AdSize adSize = AdSize.banner;
    final width = MediaQuery.of(context).size.width.truncate();
    final adaptiveSize = await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      width,
    );
    if (adaptiveSize != null) {
      adSize = adaptiveSize;
    }

    if (!mounted || _isDisposed) return;

    _bannerAd = BannerAd(
      adUnitId: _adService!.bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted && !_isDisposed) {
            setState(() {
              _isLoaded = true;
              _loadFailed = false;
              _adKey = UniqueKey();
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (mounted && !_isDisposed) {
            setState(() {
              _isLoaded = false;
              _bannerAd = null;
              _loadFailed = true;
            });
          }
        },
      ),
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Return empty when ads are switched off app-wide, so the ~150 screens
    // embedding this widget lose the banner without any of them being edited.
    if (!AdService.adsEnabled) {
      return const SizedBox.shrink();
    }

    // Return empty if AdService not available
    if (_adService == null) {
      return const SizedBox.shrink();
    }

    if (!_isLoaded || _bannerAd == null) {
      if (widget.collapseWhenUnfilled && _loadFailed) {
        return const SizedBox.shrink();
      }
      // Show placeholder while loading
      final loadingRadius = widget.showGradientBorder ? 16.0 : 0.0;
      return Container(
        margin: widget.margin ?? EdgeInsets.zero,
        width: double.infinity,
        height: 60.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(loadingRadius),
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade100.withValues(alpha: 0.3),
              Colors.blue.shade100.withValues(alpha: 0.3),
            ],
          ),
        ),
      );
    }

    // Build the AdWidget once and reuse it
    final adWidget = AdWidget(key: _adKey, ad: _bannerAd!);

    // Full width simple ad when no gradient border
    if (!widget.showGradientBorder) {
      try {
        return SizedBox(
          width: double.infinity,
          height: _bannerAd!.size.height.toDouble(),
          child: adWidget,
        );
      } catch (e) {
        return const SizedBox.shrink();
      }
    }

    try {
      return Container(
        margin: widget.margin ?? EdgeInsets.zero,
        height: 60.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withValues(alpha: 0.3),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.all(2.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: OverflowBox(
              alignment: Alignment.topCenter,
              maxHeight: 100,
              child: SizedBox(
                height: 56.h,
                child: FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: adWidget,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}
