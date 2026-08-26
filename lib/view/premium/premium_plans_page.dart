import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/premium_service.dart';
import 'package:jiyan_learning/view/premium/premium_features_screen.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class PremiumPlansPage extends StatelessWidget {
  const PremiumPlansPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> plans = [
      {
        'title': 'Monthly',
        'planType': 'monthly',
        'price': '\$4.99',
        'features': [
          'Ad-free learning',
          'Advanced Math Games',
          'Fun Educational Games',
          'Progress tracking',
        ],
        'color': Color(0xFF4ECDC4),
        'icon': '📚',
      },
      {
        'title': 'Yearly',
        'planType': 'yearly',
        'price': '\$39.99',
        'features': [
          'All Monthly features',
          'Save 30%',
          'PDF downloads',
          'Detailed Progress Reports',
          'Parent Dashboard',
          'Priority support',
        ],
        'color': Color(0xFFFFAA5A),
        'icon': '🎓',
        'popular': true,
      },
      {
        'title': 'Lifetime',
        'planType': 'lifetime',
        'price': '\$99.99',
        'features': [
          'All Yearly features',
          'Lifetime access',
          'Future updates free',
          'Family sharing (3 kids)',
          'Custom Themes',
          'Exclusive Content',
        ],
        'color': Color(0xFFA78BFA),
        'icon': '👨‍👩‍👧‍👦',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 18.r,
            ),
          ),
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
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: FittedBox(
          // The title is a Row of separately styled words, so it cannot
          // ellipsize; scaling it down keeps the whole title readable on a
          // narrow phone instead of clipping the last word.
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 28.r,
                ),
              ),
              SizedBox(width: 12.w),
              const Text(
                "Premium Plans",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ],
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
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                // Premium status banner
                Obx(() {
                  final premiumService = PremiumService.to;
                  if (premiumService.isPremium.value) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          const Text("👑", style: TextStyle(fontSize: 30)),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'You are a ${premiumService.planDisplayName} member!',
                                  style: TextStyle(
                                    color: Colors.brown.shade800,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (premiumService.planType.value != 'lifetime')
                                  Text(
                                    '${premiumService.remainingDays} days remaining',
                                    style: TextStyle(
                                      color: Colors.brown.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                Get.to(() => const PremiumFeaturesScreen()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown.shade800,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('View'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Header
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Text("✨", style: TextStyle(fontSize: 28)),
                      ),
                      SizedBox(width: 12.w),
                      const Expanded(
                        child: Text(
                          'Unlock unlimited learning for your child!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Premium benefits preview
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '✨ Premium Features ✨',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.r,
                        runSpacing: 8.r,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildFeatureChip('🧮 Advanced Math'),
                          _buildFeatureChip('🎮 Fun Games'),
                          _buildFeatureChip('📊 Progress Reports'),
                          _buildFeatureChip('👨‍👩‍👧 Parent Dashboard'),
                          _buildFeatureChip('📥 PDF Downloads'),
                          _buildFeatureChip('🚫 No Ads'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Plan cards
                ...plans.map((plan) => _buildPlanCard(plan)),
                SizedBox(height: 20.h),

                // Coming soon note
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      const Text("🚀", style: TextStyle(fontSize: 24)),
                      SizedBox(width: 12.w),
                      const Expanded(
                        child: Text(
                          'In-App Purchase coming soon! Stay tuned for easy subscription options.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final isPopular = plan['popular'] == true;
    final color = plan['color'] as Color;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: isPopular ? Border.all(color: color, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 15.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (isPopular)
            Positioned(
              top: 0,
              right: 20.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  ),
                ),
                child: const Text(
                  'POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Text(
                          plan['icon'],
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
                            plan['title'],
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          Text(
                            plan['price'],
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                ...((plan['features'] as List<String>).map(
                  (feature) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: color, size: 20.r),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () => _showComingSoonDialog(plan['title']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: const Text(
                      'Coming Soon',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String planTitle) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("🚀", style: TextStyle(fontSize: 50)),
            SizedBox(height: 16.h),
            const Text(
              'Coming Soon!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFAA5A),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'In-App Purchase for $planTitle plan will be available soon. We\'re working hard to bring you the best experience!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFAA5A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
