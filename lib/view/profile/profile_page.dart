import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/view/profile/edit_profile_page.dart';
import 'package:learning_a_to_z/view/profile/account/account_settings_page.dart';
import 'package:learning_a_to_z/view/profile/help/help_page.dart';
import 'package:learning_a_to_z/view/profile/notification/notification_settings_page.dart';
import 'package:learning_a_to_z/view/profile/policy/privacy_policy_page.dart';
import 'package:learning_a_to_z/view/profile/terms%20&%20condition/terms_conditions_page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.appVersion,
    this.onSavedAddresses,
    this.onPrivacyPolicy,
    this.onTerms,
    this.onSupport,
    // this.onLogout,
  });

  final String name;
  final String email;
  final String appVersion;

  final VoidCallback? onSavedAddresses;
  final VoidCallback? onPrivacyPolicy;
  final VoidCallback? onTerms;
  final VoidCallback? onSupport;
  // final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: CustomAppBar(titleStyle: ConstStyle.heading2, title: "Profile"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  child: Card(
                    color: ConstColors.textColorWhit,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        SizeConfig.getProportionateScreenWidth(12),
                      ),
                      side: BorderSide(
                        color: ConstColors.dividerColor,
                        width: SizeConfig.getProportionateScreenWidth(1),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                              'assets/images/persion.jpeg',
                            ),
                            backgroundColor: Color(0xFFE8EEF3),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // ✅ vertical center
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // ✅ long text handle
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  email,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              Get.to(() => const EditProfileScreen());
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: ConstColors.primaryGreen,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Edit',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                _ProfileTile(
                  title: 'Account',
                  subtitle: '',
                  onTap: () {
                    Get.to(() => AccountSettingsScreen());
                  },
                ),

                const SizedBox(height: 8),
                _ProfileTile(
                  title: 'Notification',
                  subtitle: '',
                  onTap: () {
                    Get.to(() => NotificationSettingsScreen());
                  },
                ),

                const SizedBox(height: 8),
                _ProfileTile(
                  title: 'Privacy policy',
                  subtitle: '',
                  onTap: () {
                    Get.to(() => PrivacyPolicyScreen());
                  },
                ),
                _ProfileTile(
                  title: 'Terms & conditions',
                  subtitle: '',
                  onTap: () {
                    Get.to(() => TermsConditionsScreen());
                  },
                ),
                _ProfileTile(
                  title: 'Support',
                  subtitle: '',
                  onTap: () {
                    // Get.to(() => BookingConfirmedScreen());
                  },
                ),
                _ProfileTile(
                  title: 'Help',
                  subtitle: '',
                  onTap: () {
                    Get.to(() => HelpScreen());
                  },
                ),

                const SizedBox(height: 8),

                SizedBox(
                  height: 70,
                  child: Card(
                    color: ConstColors.textColorWhit,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        SizeConfig.getProportionateScreenWidth(12),
                      ),
                      side: BorderSide(
                        color: ConstColors.dividerColor,
                        width: SizeConfig.getProportionateScreenWidth(1),
                      ),
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          // Get.to(() => LoginScreen(role: "Contractor"));
                        },
                        child: Text('Logout', style: ConstStyle.heading7),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade400,
                    ),
                    Container(
                      height: SizeConfig.getProportionateScreenHeight(60),
                      color: ConstColors.appBarBackgroundcolor,
                      child: Center(child: AdsScreen()),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  const _ProfileTile({required this.title, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Card(
        color: ConstColors.textColorWhit,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            SizeConfig.getProportionateScreenWidth(12),
          ),
          side: BorderSide(
            color: ConstColors.dividerColor,
            // width: SizeConfig.getProportionateScreenWidth(1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(title, style: ConstStyle.heading8),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black54,
                ),
                onPressed: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
