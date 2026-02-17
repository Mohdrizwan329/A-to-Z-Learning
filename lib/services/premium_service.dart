import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/firebase_service.dart';
import 'package:jiyan_learning/view%20model/auth%20controller/auth_controller.dart';

class PremiumService extends GetxController {
  static PremiumService get to => Get.find();

  final _storage = GetStorage();
  static const String _premiumKey = 'isPremium';
  static const String _planTypeKey = 'planType';
  static const String _expiryKey = 'premiumExpiry';

  // Observable states
  final RxBool isPremium = false.obs;
  final RxString planType = ''.obs; // 'monthly', 'yearly', 'lifetime'
  final Rx<DateTime?> expiryDate = Rx<DateTime?>(null);

  // Premium feature keys
  static const String kAdvancedMath = 'advanced_math';
  static const String kOfflineMode = 'offline_mode';
  static const String kNoAds = 'no_ads';
  static const String kPdfDownloads = 'pdf_downloads';
  static const String kDetailedReports = 'detailed_reports';
  static const String kAllGames = 'all_games';
  static const String kCustomThemes = 'custom_themes';
  static const String kParentDashboard = 'parent_dashboard';

  // Premium screens that will be unlocked
  static const List<String> premiumScreens = [
    'Advanced Math Games',
    'Offline Learning',
    'PDF Downloads',
    'Progress Reports',
    'Fun Games',
    'Custom Themes',
    'Parent Dashboard',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadPremiumStatus();
  }

  void _loadPremiumStatus() {
    isPremium.value = _storage.read<bool>(_premiumKey) ?? false;
    planType.value = _storage.read<String>(_planTypeKey) ?? '';

    final expiryTimestamp = _storage.read<int>(_expiryKey);
    if (expiryTimestamp != null) {
      expiryDate.value = DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
      // Check if subscription has expired
      if (expiryDate.value!.isBefore(DateTime.now()) && planType.value != 'lifetime') {
        _expireSubscription();
      }
    }
  }

  void _expireSubscription() {
    isPremium.value = false;
    planType.value = '';
    expiryDate.value = null;
    _storage.write(_premiumKey, false);
    _storage.remove(_planTypeKey);
    _storage.remove(_expiryKey);
  }

  /// Activate premium subscription
  Future<void> activatePremium({
    required String plan,
    required String paymentId,
  }) async {
    isPremium.value = true;
    planType.value = plan;

    DateTime? expiry;
    switch (plan) {
      case 'monthly':
        expiry = DateTime.now().add(const Duration(days: 30));
        break;
      case 'yearly':
        expiry = DateTime.now().add(const Duration(days: 365));
        break;
      case 'lifetime':
        expiry = null; // No expiry for lifetime
        break;
    }

    expiryDate.value = expiry;

    // Save to local storage
    await _storage.write(_premiumKey, true);
    await _storage.write(_planTypeKey, plan);
    if (expiry != null) {
      await _storage.write(_expiryKey, expiry.millisecondsSinceEpoch);
    }

    // Sync to Firebase if logged in
    _syncToFirebase(plan, expiry);
  }

  Future<void> _syncToFirebase(String plan, DateTime? expiry) async {
    try {
      if (FirebaseService.isAvailable) {
        final authController = Get.find<AuthController>();
        if (authController.isLoggedIn) {
          await FirebaseService().updateSubscription(
            uid: authController.userId,
            isPremium: true,
            expiryDate: expiry,
          );
        }
      }
    } catch (e) {
      // Silent fail - local storage is primary
    }
  }

  /// Check if a specific feature is available
  bool hasFeature(String featureKey) {
    if (!isPremium.value) return false;

    // Check expiry for non-lifetime plans
    if (planType.value != 'lifetime' && expiryDate.value != null) {
      if (expiryDate.value!.isBefore(DateTime.now())) {
        _expireSubscription();
        return false;
      }
    }

    // Monthly plan features
    if (planType.value == 'monthly') {
      return [kNoAds, kAdvancedMath, kAllGames].contains(featureKey);
    }

    // Yearly and Lifetime have all features
    return true;
  }

  /// Get remaining days of subscription
  int get remainingDays {
    if (!isPremium.value) return 0;
    if (planType.value == 'lifetime') return 999;
    if (expiryDate.value == null) return 0;

    final remaining = expiryDate.value!.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining : 0;
  }

  /// Get plan display name
  String get planDisplayName {
    switch (planType.value) {
      case 'monthly':
        return 'Monthly Plan';
      case 'yearly':
        return 'Yearly Plan';
      case 'lifetime':
        return 'Lifetime Plan';
      default:
        return 'Free Plan';
    }
  }

  /// Check if should show ads
  bool get shouldShowAds => !isPremium.value || !hasFeature(kNoAds);

  /// Restore purchases (check Firebase)
  Future<bool> restorePurchases() async {
    try {
      if (!FirebaseService.isAvailable) return false;

      final authController = Get.find<AuthController>();
      if (!authController.isLoggedIn) return false;

      final isActive = await FirebaseService().isSubscriptionActive(
        authController.userId,
      );

      if (isActive) {
        // Fetch full user data to get plan details
        final userData = await FirebaseService().getUserData(
          authController.userId,
        );
        if (userData != null && userData.isPremium) {
          isPremium.value = true;
          expiryDate.value = userData.subscriptionExpiry;
          await _storage.write(_premiumKey, true);
          if (userData.subscriptionExpiry != null) {
            await _storage.write(
              _expiryKey,
              userData.subscriptionExpiry!.millisecondsSinceEpoch,
            );
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Cancel subscription (for testing)
  Future<void> cancelSubscription() async {
    _expireSubscription();
  }

  /// TEST MODE: Activate premium for testing without payment
  /// Call this from debug menu or console
  Future<void> testActivatePremium({String plan = 'yearly'}) async {
    await activatePremium(plan: plan, paymentId: 'TEST_${DateTime.now().millisecondsSinceEpoch}');
  }
}
