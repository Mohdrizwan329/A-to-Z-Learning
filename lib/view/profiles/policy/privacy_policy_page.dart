import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _policySections = const [
    {
      "title": "1. Information We Collect",
      "body": "We collect personal details such as name, age, gender, email, phone number, photographs, and profile preferences to facilitate matchmaking.",
      "icon": "📋",
    },
    {
      "title": "2. How We Use Your Information",
      "body": "Your data is used to create and manage profiles, enable communication, improve services, and ensure security.",
      "icon": "🔧",
    },
    {
      "title": "3. Data Sharing and Disclosure",
      "body": "We do not sell your data but may share it with service providers and legal authorities if required.",
      "icon": "🤝",
    },
    {
      "title": "4. Data Security",
      "body": "We implement security measures to protect your information from unauthorized access and misuse.",
      "icon": "🔒",
    },
    {
      "title": "5. Your Rights",
      "body": "You can access, update, or delete your profile information and opt out of marketing communications at any time.",
      "icon": "✅",
    },
    {
      "title": "6. Communication Data",
      "body": "Messages and interactions within the platform are monitored for security and service improvement purposes.",
      "icon": "💬",
    },
    {
      "title": "7. Cookies and Tracking",
      "body": "We use cookies and similar technologies to enhance user experience and analyze app usage.",
      "icon": "🍪",
    },
    {
      "title": "8. Account Termination",
      "body": "Users can delete their accounts permanently, and we ensure complete data removal upon request.",
      "icon": "🗑️",
    },
    {
      "title": "9. Third-Party Links",
      "body": "Our platform may contain links to third-party websites, and we are not responsible for their privacy policies.",
      "icon": "🔗",
    },
    {
      "title": "10. Updates to This Policy",
      "body": "We may update this policy, and any changes will be communicated through our app.",
      "icon": "📢",
    },
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _policySections.length,
                  itemBuilder: (context, index) {
                    final item = _policySections[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFF11998E).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  item['icon'],
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF11998E),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['body']!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const AdsScreen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("🔐", style: TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Color(0xFFFFE66D)],
                  ).createShader(bounds),
                  child: const Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text("📜", style: TextStyle(fontSize: 28)),
              ],
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}
