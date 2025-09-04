import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final Map<String, bool> _notificationSettings = {
    'Phone Number View': true,
    'Contact Request': true,
    'Wish List': true,
    'Chat': false,
    'Profile View': false,
    'Express Interest': true,
    'Daily Recommendations': true,
    'New Matches': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2,
        title: "Notification Settings",
        showBackButton: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: ConstColors.textColorWhit,
          ),
          onPressed: () => Get.back(),
        ),
      ),

      body: ListView(
        children: _notificationSettings.entries.map((entry) {
          return SwitchListTile(
            activeColor: ConstColors.textColor,
            title: Text(entry.key, style: ConstStyle.smallText),
            value: entry.value,
            onChanged: (newValue) {
              setState(() {
                _notificationSettings[entry.key] = newValue;
              });
            },
          );
        }).toList(),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 1, thickness: 1, color: Colors.grey.shade400),
          Container(
            height: SizeConfig.getProportionateScreenHeight(60),
            color: ConstColors.appBarBackgroundcolor,
            child: Center(child: AdsScreen()),
          ),
        ],
      ),
    );
  }
}
