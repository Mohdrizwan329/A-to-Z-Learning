import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/premium_service.dart';
import 'package:jiyan_learning/view/premium/advanced_math_games_page.dart';
import 'package:jiyan_learning/view/premium/fun_games_page.dart';
import 'package:jiyan_learning/view/premium/parent_dashboard_page.dart';
import 'package:jiyan_learning/view/premium/progress_reports_page.dart';
import 'package:jiyan_learning/view/premium/pdf_downloads_page.dart';
import 'package:jiyan_learning/view/premium/custom_themes_page.dart';
import 'package:jiyan_learning/view/premium/worksheets_page.dart';
import 'package:jiyan_learning/view/premium/certificates_page.dart';
import 'package:jiyan_learning/view/premium/offline_learning_page.dart';
import 'package:jiyan_learning/view/premium/voice_learning_page.dart';
import 'package:jiyan_learning/view/premium/flashcards_page.dart';
import 'package:jiyan_learning/view/premium/quiz_battle_page.dart';
import 'package:jiyan_learning/view/premium/story_time_page.dart';
import 'package:jiyan_learning/view/premium/handwriting_practice_page.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class PremiumFeaturesScreen extends StatefulWidget {
  const PremiumFeaturesScreen({Key? key}) : super(key: key);

  @override
  State<PremiumFeaturesScreen> createState() => _PremiumFeaturesScreenState();
}

class _PremiumFeaturesScreenState extends State<PremiumFeaturesScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  // Features available in Monthly plan (₹49)
  final List<Map<String, dynamic>> monthlyFeatures = [
    {
      'title': 'Advanced Math Games',
      'subtitle': 'Challenge your brain!',
      'icon': '🧮',
      'gradient': [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
      'page': () => AdvancedMathGamesPage(),
      'featureKey': PremiumService.kAdvancedMath,
      'planRequired': 'monthly',
    },
    {
      'title': 'Fun Games',
      'subtitle': 'Learn while playing!',
      'icon': '🎮',
      'gradient': [Color(0xFF4ECDC4), Color(0xFF44A08D)],
      'page': () => FunGamesPage(),
      'featureKey': PremiumService.kAllGames,
      'planRequired': 'monthly',
    },
    {
      'title': 'Worksheets',
      'subtitle': 'Practice sheets',
      'icon': '📝',
      'gradient': [Color(0xFFFFAA5A), Color(0xFFFF8E53)],
      'page': () => const WorksheetsPage(),
      'featureKey': PremiumService.kAdvancedMath,
      'planRequired': 'monthly',
    },
    {
      'title': 'Flashcards',
      'subtitle': 'Interactive learning',
      'icon': '🃏',
      'gradient': [Color(0xFF9B59B6), Color(0xFFBE90D4)],
      'page': () => const FlashcardsPage(),
      'featureKey': PremiumService.kAdvancedMath,
      'planRequired': 'monthly',
    },
    {
      'title': 'No Ads',
      'subtitle': 'Ad-free experience',
      'icon': '🚫',
      'gradient': [Color(0xFF667EEA), Color(0xFF764BA2)],
      'page': null,
      'featureKey': PremiumService.kNoAds,
      'planRequired': 'monthly',
      'isAutomatic': true,
    },
  ];

  // Additional features in Yearly/Lifetime plans (₹399/₹999)
  final List<Map<String, dynamic>> yearlyFeatures = [
    {
      'title': 'Voice Learning',
      'subtitle': 'Learn with pronunciation',
      'icon': '🎤',
      'gradient': [Color(0xFF00B894), Color(0xFF55EFC4)],
      'page': () => const VoiceLearningPage(),
      'featureKey': PremiumService.kDetailedReports,
      'planRequired': 'yearly',
    },
    {
      'title': 'Quiz Battle',
      'subtitle': 'Competitive quizzes',
      'icon': '⚔️',
      'gradient': [Color(0xFFE17055), Color(0xFFFF7675)],
      'page': () => const QuizBattlePage(),
      'featureKey': PremiumService.kDetailedReports,
      'planRequired': 'yearly',
    },
    {
      'title': 'Story Time',
      'subtitle': 'Educational stories',
      'icon': '📖',
      'gradient': [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
      'page': () => const StoryTimePage(),
      'featureKey': PremiumService.kDetailedReports,
      'planRequired': 'yearly',
    },
    {
      'title': 'Handwriting Practice',
      'subtitle': 'Trace & write',
      'icon': '✍️',
      'gradient': [Color(0xFFFDAA5B), Color(0xFFFFD89B)],
      'page': () => const HandwritingPracticePage(),
      'featureKey': PremiumService.kDetailedReports,
      'planRequired': 'yearly',
    },
    {
      'title': 'Progress Reports',
      'subtitle': 'Track your learning',
      'icon': '📊',
      'gradient': [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
      'page': () => ProgressReportsPage(),
      'featureKey': PremiumService.kDetailedReports,
      'planRequired': 'yearly',
    },
    {
      'title': 'Parent Dashboard',
      'subtitle': 'Monitor your child',
      'icon': '👨‍👩‍👧',
      'gradient': [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
      'page': () => ParentDashboardPage(),
      'featureKey': PremiumService.kParentDashboard,
      'planRequired': 'yearly',
    },
    {
      'title': 'PDF Downloads',
      'subtitle': 'Download & share',
      'icon': '📥',
      'gradient': [Color(0xFF56D97F), Color(0xFF81E89E)],
      'page': () => const PdfDownloadsPage(),
      'featureKey': PremiumService.kPdfDownloads,
      'planRequired': 'yearly',
    },
    {
      'title': 'Certificates',
      'subtitle': 'Earn achievements',
      'icon': '🏅',
      'gradient': [Color(0xFFFFD700), Color(0xFFFFA500)],
      'page': () => const CertificatesPage(),
      'featureKey': PremiumService.kDetailedReports,
      'planRequired': 'yearly',
    },
    {
      'title': 'Offline Learning',
      'subtitle': 'Learn without internet',
      'icon': '📴',
      'gradient': [Color(0xFF00CED1), Color(0xFF20B2AA)],
      'page': () => const OfflineLearningPage(),
      'featureKey': PremiumService.kOfflineMode,
      'planRequired': 'yearly',
    },
  ];

  // Lifetime exclusive features
  final List<Map<String, dynamic>> lifetimeFeatures = [
    {
      'title': 'Custom Themes',
      'subtitle': 'Personalize app',
      'icon': '🎨',
      'gradient': [Color(0xFFFF6EB4), Color(0xFFFF9ECE)],
      'page': () => const CustomThemesPage(),
      'featureKey': PremiumService.kCustomThemes,
      'planRequired': 'lifetime',
    },
  ];

  List<Map<String, dynamic>> get allFeatures => [
    ...monthlyFeatures,
    ...yearlyFeatures,
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text(
          "Premium Features",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Obx(() {
          final planType = PremiumService.to.planType.value;
          final isPremium = PremiumService.to.isPremium.value;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium Status Card
                _buildPremiumStatusCard(),
                SizedBox(height: 16.h),

                // Monthly Plan Features Section (Available in all plans)
                _buildSectionHeader(
                  title: 'Basic Features',
                  subtitle: 'Included in Monthly Plan (₹49)',
                  color: Color(0xFF4ECDC4),
                  isUnlocked: isPremium,
                ),
                SizedBox(height: 12.h),
                _buildFeatureGrid(monthlyFeatures),
                SizedBox(height: 24.h),

                // Yearly Plan Features Section
                _buildSectionHeader(
                  title: 'Pro Features',
                  subtitle: 'Included in Yearly Plan (₹399)',
                  color: Color(0xFFFFAA5A),
                  isUnlocked:
                      isPremium &&
                      (planType == 'yearly' || planType == 'lifetime'),
                ),
                SizedBox(height: 12.h),
                _buildFeatureGrid(yearlyFeatures),
                SizedBox(height: 24.h),

                // Lifetime Exclusive Features
                _buildSectionHeader(
                  title: 'Exclusive Features',
                  subtitle: 'Included in Lifetime Plan (₹999)',
                  color: Color(0xFFA78BFA),
                  isUnlocked: isPremium && planType == 'lifetime',
                ),
                SizedBox(height: 12.h),
                _buildFeatureGrid(lifetimeFeatures),
                SizedBox(height: 20.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPremiumStatusCard() {
    return Obx(() {
      final premiumService = PremiumService.to;
      return Container(
        margin: EdgeInsets.all(16.r),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: premiumService.isPremium.value
                ? [Color(0xFFFFD700), Color(0xFFFFA500)]
                : [Colors.white24, Colors.white10],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color:
                  (premiumService.isPremium.value
                          ? Color(0xFFFFD700)
                          : Colors.black)
                      .withOpacity(0.3),
              blurRadius: 15.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  premiumService.isPremium.value ? "👑" : "🔒",
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    premiumService.isPremium.value
                        ? premiumService.planDisplayName
                        : 'Free Plan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: premiumService.isPremium.value
                          ? Colors.brown.shade800
                          : Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    premiumService.isPremium.value
                        ? (premiumService.planType.value == 'lifetime'
                              ? 'Unlimited Access'
                              : '${premiumService.remainingDays} days remaining')
                        : 'Upgrade to unlock all features',
                    style: TextStyle(
                      fontSize: 14,
                      color: premiumService.isPremium.value
                          ? Colors.brown.shade600
                          : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            if (!premiumService.isPremium.value)
              ElevatedButton(
                onPressed: () => Get.toNamed('/premium'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFD700),
                  foregroundColor: Colors.brown.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text('Upgrade'),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required Color color,
    required bool isUnlocked,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isUnlocked ? color : Colors.white30,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: isUnlocked ? color : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                isUnlocked ? Icons.check_circle : Icons.lock,
                color: Colors.white,
                size: 28.r,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              isUnlocked ? 'UNLOCKED' : 'LOCKED',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(List<Map<String, dynamic>> features) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.r,
        crossAxisSpacing: 12.r,
        childAspectRatio: 1.0,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            final offset = (index % 2 == 0)
                ? _floatAnimation.value
                : -_floatAnimation.value;
            return Transform.translate(offset: Offset(0, offset), child: child);
          },
          child: _buildFeatureCard(feature, index),
        );
      },
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature, int index) {
    final gradient = feature['gradient'] as List<Color>;
    final isAvailable = PremiumService.to.hasFeature(feature['featureKey']);
    final hasPage = feature['page'] != null;
    final isAutomatic = feature['isAutomatic'] == true;

    return GestureDetector(
      onTap: () {
        if (!PremiumService.to.isPremium.value) {
          _showUpgradeDialog();
        } else if (!isAvailable) {
          _showPlanUpgradeDialog(feature['title']);
        } else if (isAutomatic) {
          // Automatic features like "No Ads" - show info
          Get.snackbar(
            'Active!',
            '${feature['title']} is automatically enabled for you.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else if (hasPage) {
          Get.to(feature['page']);
        } else {
          Get.snackbar(
            'Coming Soon!',
            '${feature['title']} will be available soon.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isAvailable
                ? gradient
                : [Colors.grey.shade400, Colors.grey.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: (isAvailable ? gradient[0] : Colors.grey).withOpacity(0.4),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background circles
            Positioned(
              top: -20.h,
              right: -20.w,
              child: Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -30.h,
              left: -30.w,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            // Content
            Center(
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          feature['icon'],
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Line caps keep a long feature name from pushing the tile
                    // past its fixed square height on a narrow phone.
                    Flexible(
                      child: Text(
                        feature['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Flexible(
                      child: Text(
                        feature['subtitle'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Lock icon for unavailable features
            if (!isAvailable)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lock, color: Colors.white, size: 16.r),
                ),
              ),
            // Active badge for automatic features
            if (isAutomatic && isAvailable)
              Positioned(
                top: 8.h,
                left: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // Coming soon badge
            if (!hasPage && !isAutomatic && isAvailable)
              Positioned(
                top: 8.h,
                left: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Text(
                    'Soon',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showUpgradeDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("👑", style: TextStyle(fontSize: 50)),
            SizedBox(height: 16.h),
            const Text(
              'Upgrade to Premium',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFAA5A),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Unlock all premium features and give your child the best learning experience!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: const Text('Later'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed('/premium');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFAA5A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: const Text('Upgrade'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPlanUpgradeDialog(String featureName) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("⬆️", style: TextStyle(fontSize: 50)),
            SizedBox(height: 16.h),
            const Text(
              'Upgrade Your Plan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA78BFA),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              '$featureName is available in Yearly and Lifetime plans. Upgrade to access this feature!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.toNamed('/premium');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA78BFA),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text('View Plans'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
