import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> _policySections = const [
    {
      "title": "1. Information We Collect",
      "body":
          "We collect personal details such as name, age, gender, email, phone number, photographs, and profile preferences to facilitate matchmaking.",
    },
    {
      "title": "2. How We Use Your Information",
      "body":
          "Your data is used to create and manage profiles, enable communication, improve services, and ensure security.",
    },
    {
      "title": "3. Data Sharing and Disclosure",
      "body":
          "We do not sell your data but may share it with service providers and legal authorities if required.",
    },
    {
      "title": "4. Data Security",
      "body":
          "We implement security measures to protect your information from unauthorized access and misuse.",
    },
    {
      "title": "5. Your Rights",
      "body":
          "You can access, update, or delete your profile information and opt out of marketing communications at any time.",
    },
    {
      "title": "6. Communication Data",
      "body":
          "Messages and interactions within the platform are monitored for security and service improvement purposes.",
    },
    {
      "title": "7. Cookies and Tracking Technologies",
      "body":
          "We use cookies and similar technologies to enhance user experience and analyze app usage.",
    },
    {
      "title": "8. Account Termination",
      "body":
          "Users can delete their accounts permanently, and we ensure complete data removal upon request.",
    },
    {
      "title": "9. Third-Party Links",
      "body":
          "Our platform may contain links to third-party websites, and we are not responsible for their privacy policies.",
    },
    {
      "title": "10. Updates to This Policy",
      "body":
          "We may update this policy, and any changes will be communicated through our app.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2,
        title: "Privacy Policy",
        showBackButton: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: ConstColors.textColorWhit,
          ),
          onPressed: () => Get.back(),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _policySections.length,
        itemBuilder: (context, index) {
          final item = _policySections[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title']!, style: ConstStyle.smallText1),
                const SizedBox(height: 4),
                Text(item['body']!, style: ConstStyle.smallText),
              ],
            ),
          );
        },
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
