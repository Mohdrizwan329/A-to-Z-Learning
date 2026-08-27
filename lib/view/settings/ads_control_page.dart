import 'package:flutter/material.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/utils/responsive.dart';

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
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text("🛡️", style: TextStyle(fontSize: 40)),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ad-Free Learning',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
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
              SizedBox(height: 24.h),

              // Child Safe Badge
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Text("✅", style: TextStyle(fontSize: 24)),
                    SizedBox(width: 12.w),
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
              SizedBox(height: 24.h),

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
              SizedBox(height: 12.h),
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
              SizedBox(height: 12.h),
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
              SizedBox(height: 12.h),
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

              SizedBox(height: 24.h),

              // Remove Ads Premium
              SizedBox(height: 24.h),

              // Info
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("ℹ️", style: TextStyle(fontSize: 20)),
                        SizedBox(width: 8.w),
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
                    SizedBox(height: 8.h),
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
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: disabled
                      ? [Colors.grey.shade400, Colors.grey.shade500]
                      : gradient,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
            SizedBox(width: 16.w),
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
                  SizedBox(height: 4.h),
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
