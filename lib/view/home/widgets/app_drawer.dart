import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view/rewards/rewards_page.dart';
import 'package:jiyan_learning/view/rewards/daily_goals_page.dart';
import 'package:jiyan_learning/view/premium/leaderboard_page.dart';
import 'package:jiyan_learning/view/premium/progress_reports_page.dart';
import 'package:jiyan_learning/view/premium/certificates_page.dart';
import 'package:jiyan_learning/view/premium/offline_learning_page.dart';
import 'package:jiyan_learning/view/premium/parent_dashboard_page.dart';
import 'package:jiyan_learning/view/teacher/reports_page.dart';
import 'package:jiyan_learning/view%20model/auth%20controller/auth_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  AuthController get authController {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
    return Get.find<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    final user = authController.userModel;

    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
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
        child: SafeArea(
          child: Column(
            children: [
              // Header with User Info
              _buildHeader(
                user?.childName ?? "Guest",
                user?.parentEmail ?? "",
                user?.location,
                user?.parentPhone,
              ),

              // Menu Items
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMenuItem(
                        title: 'My Rewards',
                        emoji: '🏆',
                        color: const Color(0xFFFFD700),
                        onTap: () => Get.to(() => RewardsPage()),
                      ),
                      _buildMenuItem(
                        title: 'Daily Goals',
                        emoji: '📊',
                        color: const Color(0xFF4ECDC4),
                        onTap: () => Get.to(() => DailyGoalsPage()),
                      ),
                      _buildMenuItem(
                        title: 'Leaderboard',
                        emoji: '👑',
                        color: const Color(0xFFA78BFA),
                        onTap: () => Get.to(() => LeaderboardPage()),
                      ),
                      _buildMenuItem(
                        title: 'Progress Reports',
                        emoji: '📈',
                        color: const Color(0xFFFFCB80),
                        onTap: () => Get.to(() => ProgressReportsPage()),
                      ),
                      _buildMenuItem(
                        title: 'Certificates',
                        emoji: '🏅',
                        color: const Color(0xFFFFA500),
                        onTap: () => Get.to(() => const CertificatesPage()),
                      ),

                      _buildMenuItem(
                        title: 'Offline Learning',
                        emoji: '📴',
                        color: const Color(0xFF00CED1),
                        onTap: () => Get.to(() => const OfflineLearningPage()),
                      ),
                      _buildMenuItem(
                        title: 'Parent Dashboard',
                        emoji: '👨‍👩‍👧',
                        color: const Color(0xFFC4B5FD),
                        onTap: () => Get.to(() => ParentDashboardPage()),
                      ),
                      _buildMenuItem(
                        title: 'Reports',
                        emoji: '📊',
                        color: const Color(0xFF6366F1),
                        onTap: () => Get.to(() => const ReportsPage()),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name, String email, String? location, String? phone) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Material(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                      ),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '👋',
                        style: GoogleFonts.baloo2(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Text(
                          name.isEmpty ? 'Welcome!' : name,
                          style: GoogleFonts.baloo2(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.email_rounded,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                email.isNotEmpty ? email : 'No email',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location?.isNotEmpty == true ? location! : 'India',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String emoji,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.back(); // Close drawer
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 14),
                // Title
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
