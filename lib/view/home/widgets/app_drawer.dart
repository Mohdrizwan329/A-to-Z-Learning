import 'dart:convert';
import 'dart:typed_data';

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
import 'package:jiyan_learning/services/age_content_service.dart';
import 'package:jiyan_learning/view/age_selection/age_selection_page.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  AuthController get authController {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
    return Get.find<AuthController>();
  }

  /// The signed-in user, or null when there is nobody -- or no Firebase to
  /// ask. Every field below already falls back to a guest, so a drawer that
  /// cannot reach auth should still open rather than take the screen down.
  @override
  Widget build(BuildContext context) {
    // Flutter's default drawer is a fixed 304pt, which on a 390pt phone reads
    // as the whole screen. Just under three quarters instead: room for the
    // longest menu label on one line, with a strip of the page behind still
    // showing so it reads as a drawer. Floored so the rows still fit on a
    // small phone, and capped so a tablet gets a panel, not half a page.
    final width = (MediaQuery.sizeOf(context).width * 0.72).clamp(270.0, 420.0);
    // Below this the header has to stack instead of sitting in a row.
    final isNarrow = width < 300;

    return Drawer(
      backgroundColor: Colors.transparent,
      width: width,
      // Material 3 rounds a drawer's trailing corners, which against this
      // gradient reads as a bite taken out of the panel. Square instead, so
      // the drawer meets the screen edge cleanly.
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
              // The age this child is set to, and the close button -- the top
              // strip of the drawer, which would otherwise hold nothing but
              // the button. The close button is there so the drawer can be
              // dismissed without knowing that a swipe or a tap outside would
              // also do it.
              Padding(
                padding: EdgeInsets.only(
                  top: 4.h,
                  left: isNarrow ? 10.w : 16.w,
                  right: isNarrow ? 10.w : 16.w,
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildAgeChip(isNarrow: isNarrow)),
                    SizedBox(width: 8.w),
                    _buildCloseButton(context, isNarrow: isNarrow),
                  ],
                ),
              ),

              // Header with User Info
              _buildLiveHeader(isNarrow: isNarrow),

              // Menu Items
              Expanded(
                child: SingleChildScrollView(
                  // The top gap belongs to the scroll view, not to the
                  // header: at rest it holds the first card 10 off the rule,
                  // and it scrolls away with the cards instead of leaving an
                  // empty band under the line.
                  padding: EdgeInsets.only(
                    left: isNarrow ? 10.w : 16.w,
                    right: isNarrow ? 10.w : 16.w,
                    top: 10.h,
                    bottom: 8.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // First under the divider: the one row that changes
                      // what every other screen shows.
                      _buildMenuItem(
                        title: 'Class & Age',
                        emoji: '\u{1F393}',
                        color: const Color(0xFF9B5DE5),
                        onTap: () => Get.to(
                          () => const AgeSelectionPage(isInitialSetup: false),
                        ),
                      ),
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
                      SizedBox(height: 24.h),
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

  /// The X in the corner. Closes the drawer and nothing else.
  Widget _buildCloseButton(BuildContext context, {required bool isNarrow}) {
    final size = isNarrow ? 32.0 : 36.0;
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => Scaffold.of(context).closeDrawer(),
        child: Tooltip(
          message: 'Close menu',
          child: SizedBox(
            width: size.w,
            height: size.h,
            child: Icon(
              Icons.close_rounded,
              size: (isNarrow ? 18 : 20).r,
              color: Colors.white,
              semanticLabel: 'Close menu',
            ),
          ),
        ),
      ),
    );
  }

  /// The header, watching the signed-in user.
  ///
  /// The details arrive after the drawer is first built -- Firestore is a
  /// round trip away -- so this is an Obx rather than a snapshot, otherwise
  /// the drawer keeps showing "Guest" for a user who is signed in.
  /// The age group this child is set to, worded as the age-selection card
  /// words it. Empty when no age has been chosen yet, or when the service is
  /// not up (a test, or a drawer built before startup finished), so the strip
  /// then holds only the close button.
  Widget _buildAgeChip({required bool isNarrow}) {
    if (!Get.isRegistered<AgeContentService>()) return const SizedBox.shrink();
    final service = Get.find<AgeContentService>();

    return Obx(() {
      if (!service.hasSelectedAge.value) return const SizedBox.shrink();
      final group = service.currentAgeGroup.value;
      // The card's own subtitle ("Toddler / Nursery") is too long to sit
      // beside the years here, so the class is shortened to the half a parent
      // reads for.
      final grade = switch (group) {
        AgeGroup.toddler => 'Nursery',
        AgeGroup.lkgUkg => 'LKG / UKG',
        AgeGroup.class1To2 => 'Class 1-2',
        AgeGroup.class3To4 => 'Class 3-4',
        AgeGroup.class5To6 => 'Class 5-6',
      };

      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('\u{1F393}', style: TextStyle(fontSize: isNarrow ? 12 : 13)),
              SizedBox(width: 5.w),
              Flexible(
                child: Text(
                  '${group.displayName} \u00b7 $grade',
                  style: GoogleFonts.nunito(
                    fontSize: isNarrow ? 12 : 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLiveHeader({required bool isNarrow}) {
    final AuthController auth;
    try {
      auth = authController;
    } catch (e) {
      // No Firebase to ask (web without config, or a test): still open, just
      // as a guest.
      debugPrint('Drawer could not read the signed-in user: $e');
      return _buildHeader(isNarrow: isNarrow);
    }

    return Obx(() {
      final user = auth.userModel;
      final account = auth.firebaseUser;

      // The profile doc is the better source, but it is written after
      // sign-up; until then the account itself is all there is.
      final name = _firstNonEmpty([
        user?.childName,
        account?.displayName,
        // "riz" out of "riz@gmail.com" beats a blank card.
        account?.email?.split('@').first,
      ]);
      final email = _firstNonEmpty([user?.parentEmail, account?.email]);
      final phone = _firstNonEmpty([user?.parentPhone, account?.phoneNumber]);

      return _buildHeader(
        isNarrow: isNarrow,
        name: name,
        email: email,
        phone: phone,
        location: _firstNonEmpty([user?.location]),
        // The picture taken at signup wins: it is the one this family chose.
        photoBase64: _firstNonEmpty([user?.photoBase64]),
        photoUrl: _firstNonEmpty([user?.photoUrl, account?.photoURL]),
      );
    });
  }

  /// First value that actually has something in it, trimmed; null if none do.
  static String? _firstNonEmpty(List<String?> candidates) {
    for (final value in candidates) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    }
    return null;
  }

  Widget _buildHeader({
    String? name,
    String? email,
    String? location,
    String? phone,
    String? photoBase64,
    String? photoUrl,
    bool isNarrow = false,
  }) {
    final photoBytes = _decodePhoto(photoBase64);
    // A half-width drawer has no room for an avatar beside the text, so the
    // header stacks: picture on top, details underneath and centred.
    final avatar = isNarrow ? 104.0 : 124.0;

    return Container(
      margin: EdgeInsets.fromLTRB(
        isNarrow ? 10.w : 16.w,
        // Clears the age chip and close button above rather than sitting
        // right under them.
        10.h,
        isNarrow ? 10.w : 16.w,
        // Nothing below: the rule at the bottom of this column is the header's
        // last pixel, so the menu starts right under it and scrolls under it.
        0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
          padding: EdgeInsets.fromLTRB(
            isNarrow ? 4.r : 8.r,
            0,
            isNarrow ? 4.r : 8.r,
            isNarrow ? 4.r : 8.r,
          ),
          child: Flex(
            direction: isNarrow ? Axis.vertical : Axis.horizontal,
            // Stacked, the header is only as tall as its contents; a flex
            // child would have nothing finite to expand into.
            mainAxisSize: isNarrow ? MainAxisSize.min : MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
                  Container(
                    width: avatar.w,
                    height: avatar.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF6B6B),
                          Color(0xFFFF8E53),
                          Color(0xFFFFAA5A),
                        ],
                      ),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: photoBytes != null
                        ? Image.memory(photoBytes, fit: BoxFit.cover)
                        : photoUrl != null
                        ? Image.network(
                            photoUrl,
                            fit: BoxFit.cover,
                            // A picture that will not load must not leave a
                            // blank disc where a face should be.
                            errorBuilder: (_, __, ___) =>
                                _avatarInitial(name, isNarrow),
                            loadingBuilder: (_, child, progress) =>
                                progress == null
                                    ? child
                                    : _avatarInitial(name, isNarrow),
                          )
                        : _avatarInitial(name, isNarrow),
                  ),
                  SizedBox(width: isNarrow ? 0 : 14.w, height: isNarrow ? 10.h : 0),
                  // User Info
                  _flexIn(
                    isNarrow: isNarrow,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: isNarrow
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        // Name
                        Text(
                          name ?? 'Guest',
                          textAlign: isNarrow ? TextAlign.center : TextAlign.start,
                          style: GoogleFonts.baloo2(
                            fontSize: isNarrow ? 22 : 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: isNarrow
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            Icon(
                              email != null
                                  ? Icons.email_rounded
                                  : Icons.phone_rounded,
                              size: 14.r,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                email ?? phone ?? 'Not signed in',
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withValues(alpha: 0.92),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (location != null) ...[
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: isNarrow
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 14.r,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  location,
                                  style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white.withValues(alpha: 0.88),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
            ],
          ),
        ),
          // Separates the person from the menu now that there is no card
          // edge doing it. Written out rather than a Divider because Divider
          // centres its line in its height, which leaves a band of empty
          // space under the rule; the first menu row sits straight beneath.
          Padding(
            padding: EdgeInsets.only(top: isNarrow ? 14.h : 18.h),
            child: Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }

  /// The stored picture, or null if there isn't one -- or it will not decode,
  /// which must not take the drawer down with it.
  static Uint8List? _decodePhoto(String? base64Photo) {
    if (base64Photo == null) return null;
    try {
      return base64Decode(base64Photo);
    } catch (e) {
      debugPrint('Stored profile photo could not be read: $e');
      return null;
    }
  }

  /// The initial shown when there is no picture to show -- or not yet.
  Widget _avatarInitial(String? name, bool isNarrow) => Center(
        child: Text(
          (name?.isNotEmpty == true) ? name![0].toUpperCase() : '👋',
          style: GoogleFonts.baloo2(
            fontSize: isNarrow ? 46 : 56,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

  /// Side by side the details take the leftover width; stacked they simply
  /// take their own height, so no flex is involved at all.
  Widget _flexIn({required bool isNarrow, required Widget child}) =>
      isNarrow ? child : Expanded(child: child);

  Widget _buildMenuItem({
    required String title,
    required String emoji,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      child: Material(
        color: Colors.black.withValues(alpha: 0.22),
        // The fill alone is barely a shade off the gradient behind it, so a
        // hairline gives each row an edge to sit in. Material takes a shape
        // or a borderRadius, never both.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            Get.back(); // Close drawer
            onTap();
          },
          child: LayoutBuilder(builder: (context, constraints) {
            // In a half-width drawer the row has to give its space to the
            // label: the badge shrinks and the chevron goes, rather than
            // squeezing every title onto three lines.
            final tight = constraints.maxWidth < 260;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: tight ? 10.w : 16.w,
                vertical: tight ? 6.h : 8.h,
              ),
              child: Row(
                children: [
                  // Icon Container
                  Container(
                    width: tight ? 32.w : 38.w,
                    height: tight ? 32.h : 38.h,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: TextStyle(fontSize: tight ? 16 : 19),
                      ),
                    ),
                  ),
                  SizedBox(width: tight ? 8.w : 14.w),
                  // Title
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        fontSize: tight ? 13 : 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                  if (!tight)
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16.r,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
