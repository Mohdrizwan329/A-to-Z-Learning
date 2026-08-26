import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class FamilyRelationshipsDetailPage extends StatefulWidget {
  final int sectionIndex;

  const FamilyRelationshipsDetailPage({super.key, required this.sectionIndex});

  @override
  State<FamilyRelationshipsDetailPage> createState() =>
      _FamilyRelationshipsDetailPageState();
}

class _FamilyRelationshipsDetailPageState
    extends State<FamilyRelationshipsDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  static final List<Map<String, dynamic>> sections = [
    {
      'title': 'My Family',
      'emoji': '👨‍👩‍👧‍👦',
      'members': [
        {
          'name': 'Mother',
          'emoji': '👩',
          'hindi': 'माँ (Maa)',
          'role': 'Takes care of us with love',
        },
        {
          'name': 'Father',
          'emoji': '👨',
          'hindi': 'पिता (Pita)',
          'role': 'Protects and provides for family',
        },
        {
          'name': 'Sister',
          'emoji': '👧',
          'hindi': 'बहन (Behen)',
          'role': 'A friend to play and share with',
        },
        {
          'name': 'Brother',
          'emoji': '👦',
          'hindi': 'भाई (Bhai)',
          'role': 'A friend to learn and grow with',
        },
      ],
    },
    {
      'title': 'Grandparents',
      'emoji': '👴👵',
      'members': [
        {
          'name': 'Grandfather',
          'emoji': '👴',
          'hindi': 'दादा/नाना',
          'role': 'Tells stories and gives wisdom',
        },
        {
          'name': 'Grandmother',
          'emoji': '👵',
          'hindi': 'दादी/नानी',
          'role': 'Cooks yummy food and gives hugs',
        },
      ],
    },
    {
      'title': 'Extended Family',
      'emoji': '👥',
      'members': [
        {
          'name': 'Uncle',
          'emoji': '👨',
          'hindi': 'चाचा/मामा',
          'role': 'Father\'s or Mother\'s brother',
        },
        {
          'name': 'Aunt',
          'emoji': '👩',
          'hindi': 'चाची/मामी',
          'role': 'Father\'s or Mother\'s sister',
        },
        {
          'name': 'Cousin',
          'emoji': '🧒',
          'hindi': 'चचेरा भाई/बहन',
          'role': 'Uncle or Aunt\'s children',
        },
      ],
    },
    {
      'title': 'Family Values',
      'emoji': '❤️',
      'values': [
        {
          'name': 'Love',
          'emoji': '💕',
          'meaning': 'Care for each other always',
        },
        {
          'name': 'Respect',
          'emoji': '🙏',
          'meaning': 'Listen and be polite to elders',
        },
        {
          'name': 'Sharing',
          'emoji': '🤝',
          'meaning': 'Share toys, food, and happiness',
        },
        {
          'name': 'Helping',
          'emoji': '🤲',
          'meaning': 'Help with chores and tasks',
        },
        {'name': 'Honesty', 'emoji': '✨', 'meaning': 'Always tell the truth'},
      ],
    },
    {
      'title': 'Types of Families',
      'emoji': '🏠',
      'types': [
        {
          'name': 'Nuclear Family',
          'emoji': '👨‍👩‍👧',
          'desc': 'Parents and children living together',
        },
        {
          'name': 'Joint Family',
          'emoji': '👨‍👩‍👧‍👦👴👵',
          'desc': 'Grandparents, parents, and children together',
        },
        {
          'name': 'Single Parent',
          'emoji': '👩‍👧',
          'desc': 'One parent taking care of children',
        },
        {
          'name': 'Extended Family',
          'emoji': '👥',
          'desc': 'Relatives living together or nearby',
        },
      ],
    },
    {
      'title': 'Being a Good Family Member',
      'emoji': '🌟',
      'tips': [
        {'emoji': '👂', 'tip': 'Listen to your parents and elders'},
        {'emoji': '🤗', 'tip': 'Give hugs and say "I love you"'},
        {'emoji': '🧹', 'tip': 'Help with household chores'},
        {'emoji': '📚', 'tip': 'Do your homework on time'},
        {'emoji': '😊', 'tip': 'Be kind to your siblings'},
        {'emoji': '🙏', 'tip': 'Say please and thank you'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    initGridAnimations(this, floatRange: 3.0);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final section = sections[widget.sectionIndex];
    final gradient = AppColors.getGradientForIndex(widget.sectionIndex);

    return GradientScaffold(
      title: section['title'],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // Main Card
            buildFloatingItem(
              index: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withValues(alpha: 0.4),
                      blurRadius: 12.r,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      section['emoji'],
                      style: const TextStyle(fontSize: 70),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      section['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Content based on type
            if (section.containsKey('members')) _buildMemberCards(section),
            if (section.containsKey('values')) _buildValueCards(section),
            if (section.containsKey('types')) _buildTypeCards(section),
            if (section.containsKey('tips')) _buildTipCards(section),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCards(Map<String, dynamic> section) {
    return Column(
      children: (section['members'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final member = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(member['emoji'], style: const TextStyle(fontSize: 40)),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        member['hindi'],
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        member['role'],
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
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

  Widget _buildValueCards(Map<String, dynamic> section) {
    return Column(
      children: (section['values'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final value = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(value['emoji'], style: const TextStyle(fontSize: 32)),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        value['meaning'],
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
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

  Widget _buildTypeCards(Map<String, dynamic> section) {
    return Column(
      children: (section['types'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final type = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(type['emoji'], style: const TextStyle(fontSize: 28)),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        type['desc'],
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
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

  Widget _buildTipCards(Map<String, dynamic> section) {
    return Column(
      children: (section['tips'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final tip = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(tip['emoji'], style: const TextStyle(fontSize: 28)),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    tip['tip'],
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
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
