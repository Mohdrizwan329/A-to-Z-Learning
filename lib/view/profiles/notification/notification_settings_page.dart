import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final List<Map<String, dynamic>> _notificationSettings = [
    {'title': 'Phone Number View', 'value': true, 'icon': Icons.phone, 'color': Color(0xFF667EEA)},
    {'title': 'Contact Request', 'value': true, 'icon': Icons.contact_mail, 'color': Color(0xFF4ECDC4)},
    {'title': 'Wish List', 'value': true, 'icon': Icons.favorite, 'color': Color(0xFFFF6B6B)},
    {'title': 'Chat', 'value': false, 'icon': Icons.chat_bubble, 'color': Color(0xFF45B7D1)},
    {'title': 'Profile View', 'value': false, 'icon': Icons.visibility, 'color': Color(0xFFA78BFA)},
    {'title': 'Express Interest', 'value': true, 'icon': Icons.star, 'color': Color(0xFFFFAA5A)},
    {'title': 'Daily Recommendations', 'value': true, 'icon': Icons.recommend, 'color': Color(0xFF56D97F)},
    {'title': 'New Matches', 'value': false, 'icon': Icons.people, 'color': Color(0xFFEC407A)},
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
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _notificationSettings.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _notificationSettings.length) {
                        return Column(
                          children: const [
                            SizedBox(height: 20),
                            AdsScreen(),
                          ],
                        );
                      }
                      final item = _notificationSettings[index];
                      return _buildNotificationTile(index, item);
                    },
                  ),
                ),
              ),
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
                const Text("🔔", style: TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Color(0xFFFFE66D)],
                  ).createShader(bounds),
                  child: const Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text("📱", style: TextStyle(fontSize: 28)),
              ],
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(int index, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        secondary: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: (item['color'] as Color).withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(item['icon'], color: item['color'], size: 24),
        ),
        title: Text(
          item['title'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        activeColor: item['color'],
        value: item['value'],
        onChanged: (newValue) {
          setState(() {
            _notificationSettings[index]['value'] = newValue;
          });
        },
      ),
    );
  }
}
