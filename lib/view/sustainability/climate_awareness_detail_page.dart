import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class ClimateAwarenessDetailPage extends StatefulWidget {
  final int sectionIndex;

  const ClimateAwarenessDetailPage({super.key, required this.sectionIndex});

  @override
  State<ClimateAwarenessDetailPage> createState() =>
      _ClimateAwarenessDetailPageState();
}

class _ClimateAwarenessDetailPageState extends State<ClimateAwarenessDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Climate?',
      'emoji': '🌡️',
      'content': [
        {
          'icon': '☀️',
          'text': 'Climate is the usual weather in a place over many years',
        },
        {
          'icon': '🌧️',
          'text': 'Some places are usually hot, some are usually cold',
        },
        {
          'icon': '🌍',
          'text':
              'Weather changes every day, but climate stays mostly the same',
        },
        {
          'icon': '📅',
          'text':
              'Scientists study weather for 30+ years to understand climate',
        },
      ],
    },
    {
      'title': 'Climate is Changing',
      'emoji': '🌡️⬆️',
      'content': [
        {'icon': '🔥', 'text': 'The Earth is getting warmer than before'},
        {
          'icon': '🏭',
          'text': 'Smoke from factories and cars makes Earth warmer',
        },
        {'icon': '🌳', 'text': 'Cutting down too many trees makes it worse'},
        {
          'icon': '😟',
          'text': 'This change is called Global Warming or Climate Change',
        },
      ],
    },
    {
      'title': 'The Greenhouse Effect',
      'emoji': '🏠',
      'content': [
        {'icon': '☀️', 'text': 'Sun sends heat to Earth to keep us warm'},
        {
          'icon': '🌫️',
          'text': 'Some gases in the air trap this heat like a blanket',
        },
        {
          'icon': '🏡',
          'text': 'It\'s like a greenhouse that keeps plants warm',
        },
        {
          'icon': '⚠️',
          'text': 'Too many gases = too much heat = Earth gets too hot',
        },
      ],
      'visual': true,
    },
    {
      'title': 'What\'s Happening?',
      'emoji': '😢',
      'effects': [
        {
          'effect': 'Ice is Melting',
          'emoji': '🧊',
          'detail': 'Polar bears are losing their homes',
        },
        {
          'effect': 'Sea Levels Rising',
          'emoji': '🌊',
          'detail': 'Oceans are getting higher',
        },
        {
          'effect': 'More Storms',
          'emoji': '🌀',
          'detail': 'Hurricanes and floods happen more',
        },
        {
          'effect': 'Droughts',
          'emoji': '🏜️',
          'detail': 'Some places have less rain',
        },
        {
          'effect': 'Animals in Danger',
          'emoji': '🦋',
          'detail': 'Many species are dying',
        },
      ],
    },
    {
      'title': 'Climate Zones',
      'emoji': '🗺️',
      'zones': [
        {
          'name': 'Tropical',
          'emoji': '🌴',
          'weather': 'Hot and rainy all year',
        },
        {'name': 'Desert', 'emoji': '🏜️', 'weather': 'Very hot and dry'},
        {
          'name': 'Temperate',
          'emoji': '🍂',
          'weather': 'Not too hot, not too cold',
        },
        {
          'name': 'Polar',
          'emoji': '❄️',
          'weather': 'Very cold with ice and snow',
        },
      ],
    },
    {
      'title': 'Weather vs Climate',
      'emoji': '⚡',
      'comparison': [
        {'weather': 'Today is sunny', 'climate': 'This area is usually sunny'},
        {
          'weather': 'It rained this morning',
          'climate': 'Monsoon season brings rain',
        },
        {'weather': 'It\'s snowing now', 'climate': 'Winters here are cold'},
        {'weather': 'Changes every day', 'climate': 'Stays the same for years'},
      ],
    },
    {
      'title': 'How Can YOU Help?',
      'emoji': '🦸',
      'tips': [
        {
          'tip': 'Turn off lights when not using',
          'emoji': '💡',
          'saves': 'Energy',
        },
        {
          'tip': 'Walk or cycle instead of car rides',
          'emoji': '🚲',
          'saves': 'Fuel',
        },
        {
          'tip': 'Plant trees and take care of plants',
          'emoji': '🌱',
          'saves': 'Air',
        },
        {'tip': 'Don\'t waste water', 'emoji': '💧', 'saves': 'Water'},
        {'tip': 'Use less plastic', 'emoji': '🚫', 'saves': 'Ocean'},
        {'tip': 'Reduce, Reuse, Recycle', 'emoji': '♻️', 'saves': 'Resources'},
        {
          'tip': 'Eat more vegetables, less meat',
          'emoji': '🥗',
          'saves': 'Land',
        },
        {
          'tip': 'Tell others about climate change',
          'emoji': '🗣️',
          'saves': 'Future',
        },
      ],
    },
    {
      'title': 'Climate Heroes',
      'emoji': '🌟',
      'heroes': [
        {
          'name': 'Scientists',
          'emoji': '👩‍🔬',
          'role': 'Study the climate and find solutions',
        },
        {
          'name': 'Activists',
          'emoji': '📢',
          'role': 'Spread awareness about climate change',
        },
        {
          'name': 'Engineers',
          'emoji': '👷',
          'role': 'Create clean energy like solar panels',
        },
        {
          'name': 'You!',
          'emoji': '🌟',
          'role': 'Every small action helps save our planet',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    initGridAnimations(this, floatRange: 3.0, pulseMax: 1.0);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final section = sections[widget.sectionIndex];
    return GradientScaffold(
      title: section['title'] ?? '',
      emoji: section['emoji'] ?? '',
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
        child: _buildSectionContent(section),
      ),
    );
  }

  Widget _buildGradientItem({required int itemIndex, required Widget child}) {
    final gradient = AppColors.getGradientForIndex(itemIndex);
    return buildFloatingItem(
      index: itemIndex,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withValues(alpha: 0.4),
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildSectionContent(Map<String, dynamic> section) {
    switch (widget.sectionIndex) {
      case 0:
      case 1:
      case 2:
        return _buildContentSection(section);
      case 3:
        return _buildEffectsSection(section);
      case 4:
        return _buildZonesSection(section);
      case 5:
        return _buildComparisonSection(section);
      case 6:
        return _buildTipsSection(section);
      case 7:
        return _buildHeroesSection(section);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildContentSection(Map<String, dynamic> section) {
    final content = section['content'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: [
        ...content.map<Widget>((item) {
          final idx = itemIndex++;
          return _buildGradientItem(
            itemIndex: idx,
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  Container(
                    width: 55.w,
                    height: 55.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        item['icon'] ?? '',
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      item['text'] ?? '',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        if (section.containsKey('visual') && section['visual'] == true)
          _buildGradientItem(
            itemIndex: itemIndex,
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  const Text(
                    '☀️\n⬇️\n🌍',
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Sun → Heat → Earth\nGases trap heat like a blanket',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEffectsSection(Map<String, dynamic> section) {
    final effects = section['effects'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: effects.map<Widget>((effect) {
        final idx = itemIndex++;
        return _buildGradientItem(
          itemIndex: idx,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Container(
                  width: 55.w,
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      effect['emoji'] ?? '',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        effect['effect'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        effect['detail'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildZonesSection(Map<String, dynamic> section) {
    final zones = section['zones'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: zones.map<Widget>((zone) {
        final idx = itemIndex++;
        return _buildGradientItem(
          itemIndex: idx,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      zone['emoji'] ?? '',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        zone['name'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        zone['weather'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildComparisonSection(Map<String, dynamic> section) {
    final comparison = section['comparison'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: [
        // Header card
        _buildGradientItem(
          itemIndex: itemIndex++,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '⛅ Weather',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '🌍 Climate',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Comparison items
        ...comparison.map<Widget>((item) {
          final idx = itemIndex++;
          return _buildGradientItem(
            itemIndex: idx,
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item['weather'] ?? '',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Text('↔️', style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: Text(
                      item['climate'] ?? '',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTipsSection(Map<String, dynamic> section) {
    final tips = section['tips'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: tips.map<Widget>((tip) {
        final idx = itemIndex++;
        return _buildGradientItem(
          itemIndex: idx,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      tip['emoji'] ?? '',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip['tip'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Saves: ${tip['saves'] ?? ''}',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHeroesSection(Map<String, dynamic> section) {
    final heroes = section['heroes'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: heroes.map<Widget>((hero) {
        final idx = itemIndex++;
        return _buildGradientItem(
          itemIndex: idx,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      hero['emoji'] ?? '',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hero['name'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        hero['role'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
