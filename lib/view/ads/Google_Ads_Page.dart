import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jiyan_learning/services/ad_service.dart';

/// Full-width Banner Ad Widget
class AdsScreen extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final bool showGradientBorder;

  const AdsScreen({
    super.key,
    this.margin,
    this.showGradientBorder = false,
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
    if (_adService == null || !mounted || _isDisposed) return;

    // Dispose old ad if exists
    _bannerAd?.dispose();
    _bannerAd = null;

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
    // Return empty if AdService not available
    if (_adService == null) {
      return const SizedBox.shrink();
    }

    if (!_isLoaded || _bannerAd == null) {
      // Show placeholder while loading
      final loadingRadius = widget.showGradientBorder ? 16.0 : 0.0;
      return Container(
        margin: widget.margin ?? EdgeInsets.zero,
        width: double.infinity,
        height: 60,
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
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: OverflowBox(
              alignment: Alignment.topCenter,
              maxHeight: 100,
              child: SizedBox(
                height: 56,
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
