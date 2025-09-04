import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool _contactRequest = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2,
        title: "Account Settings",
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
        children: [
          _buildTextRow("Change Password"),
          _buildTextRow("Logout"),
          _buildSwitchRow("Contact Request", _contactRequest, (val) {
            setState(() {
              _contactRequest = val;
            });
          }),
          _buildTextRow("Delete Account"),
        ],
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

  Widget _buildTextRow(String title) {
    return ListTile(
      title: Text(title, style: ConstStyle.smallText),
      trailing: const Icon(Icons.circle_outlined, size: 20, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildSwitchRow(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      activeColor: ConstColors.textColor,
      title: Text(title, style: ConstStyle.smallText),
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
