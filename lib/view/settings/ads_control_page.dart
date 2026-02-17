import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class AdsControlPage extends StatefulWidget {
  const AdsControlPage({super.key});

  @override
  State<AdsControlPage> createState() => _AdsControlPageState();
}

class _AdsControlPageState extends State<AdsControlPage> {
  bool _adsEnabled = false;
  bool _personalizedAds = false;
  bool _videoAds = false;
  bool _bannerAds = false;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Ads Control',
      emoji: '📺',
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text("🛡️", style: TextStyle(fontSize: 40)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ad-Free Learning',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Control ad settings for your child',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Child Safe Badge
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: const [
                      Text("✅", style: TextStyle(fontSize: 24)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Child-Safe Environment',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'All ads are currently disabled for safety',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Ad Settings
                _buildSettingCard(
                  emoji: '📺',
                  title: 'Enable Ads',
                  subtitle: 'Show educational ads in the app',
                  value: _adsEnabled,
                  onChanged: (value) {
                    setState(() => _adsEnabled = value);
                  },
                  gradient: [Color(0xFF6366F1), Color(0xFF818CF8)],
                ),
                const SizedBox(height: 12),
                _buildSettingCard(
                  emoji: '🎯',
                  title: 'Personalized Ads',
                  subtitle: 'Show ads based on interests',
                  value: _personalizedAds,
                  onChanged: _adsEnabled
                      ? (value) {
                          setState(() => _personalizedAds = value);
                        }
                      : null,
                  gradient: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                  disabled: !_adsEnabled,
                ),
                const SizedBox(height: 12),
                _buildSettingCard(
                  emoji: '🎬',
                  title: 'Video Ads',
                  subtitle: 'Allow video advertisements',
                  value: _videoAds,
                  onChanged: _adsEnabled
                      ? (value) {
                          setState(() => _videoAds = value);
                        }
                      : null,
                  gradient: [Color(0xFFEC4899), Color(0xFFF472B6)],
                  disabled: !_adsEnabled,
                ),
                const SizedBox(height: 12),
                _buildSettingCard(
                  emoji: '🖼️',
                  title: 'Banner Ads',
                  subtitle: 'Show banner ads at bottom',
                  value: _bannerAds,
                  onChanged: _adsEnabled
                      ? (value) {
                          setState(() => _bannerAds = value);
                        }
                      : null,
                  gradient: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                  disabled: !_adsEnabled,
                ),

                const SizedBox(height: 24),

                // Remove Ads Premium
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEAB308), Color(0xFFFDE047)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Text("👑", style: TextStyle(fontSize: 32)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Go Premium',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Remove all ads permanently',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.snackbar(
                            'Coming Soon',
                            'Premium subscription will be available soon!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black87,
                            colorText: Colors.white,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Upgrade'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text("ℹ️", style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8),
                          Text(
                            'About Ads',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• All ads are reviewed for child safety\n'
                        '• No data is collected from children\n'
                        '• Educational content only\n'
                        '• COPPA compliant',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildSettingCard({
    required String emoji,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool)? onChanged,
    required List<Color> gradient,
    bool disabled = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: disabled ? Colors.white.withValues(alpha: 0.5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: disabled
                      ? [Colors.grey.shade400, Colors.grey.shade500]
                      : gradient,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: disabled ? Colors.grey : const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: disabled ? Colors.grey : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: gradient[0].withValues(alpha: 0.5),
              activeThumbColor: gradient[0],
            ),
          ],
        ),
      ),
    );
  }
}
