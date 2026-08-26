import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class SelfControlPage extends StatefulWidget {
  const SelfControlPage({super.key});

  @override
  State<SelfControlPage> createState() => _SelfControlPageState();
}

class _SelfControlPageState extends State<SelfControlPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Self-Control?',
      'emoji': '🧠',
      'color': Color(0xFF673AB7),
      'intro':
          'Self-control is the ability to control your feelings, actions, and impulses!',
      'examples': [
        {'situation': 'Waiting your turn', 'emoji': '⏳', 'skill': 'Patience'},
        {
          'situation': 'Not eating candy before dinner',
          'emoji': '🍬',
          'skill': 'Resisting temptation',
        },
        {
          'situation': 'Staying calm when angry',
          'emoji': '😤',
          'skill': 'Managing emotions',
        },
        {
          'situation': 'Finishing homework before playing',
          'emoji': '📚',
          'skill': 'Delayed gratification',
        },
        {
          'situation': 'Keeping a secret',
          'emoji': '🤐',
          'skill': 'Impulse control',
        },
      ],
      'funFact':
          'Self-control is like a muscle - the more you use it, the stronger it gets!',
    },
    {
      'title': 'The Marshmallow Test',
      'emoji': '🍡',
      'color': Color(0xFFE91E63),
      'intro': 'A famous experiment about waiting for bigger rewards!',
      'story': [
        {'part': 'A child is given ONE marshmallow', 'emoji': '🍬'},
        {'part': 'They can eat it now OR wait 15 minutes', 'emoji': '⏰'},
        {'part': 'If they wait, they get TWO marshmallows!', 'emoji': '🍬🍬'},
        {'part': 'This tests your ability to wait', 'emoji': '��'},
      ],
      'lesson': 'Sometimes waiting leads to better rewards!',
      'strategies': [
        'Look away from the temptation',
        'Think about something else',
        'Remind yourself of the bigger reward',
        'Sing a song in your head',
      ],
    },
    {
      'title': 'Stop and Think',
      'emoji': '🛑',
      'color': Color(0xFF2196F3),
      'intro': 'Before acting, STOP and THINK!',
      'steps': [
        {
          'step': 'STOP',
          'emoji': '🛑',
          'desc': 'Pause before you act',
          'color': 0xFFE53935,
        },
        {
          'step': 'THINK',
          'emoji': '🤔',
          'desc': 'Consider your choices',
          'color': 0xFFFFB300,
        },
        {
          'step': 'ACT',
          'emoji': '✅',
          'desc': 'Make a good choice',
          'color': 0xFF43A047,
        },
      ],
      'examples': [
        {
          'trigger': 'Someone takes your toy',
          'bad': 'Hit them',
          'good': 'Ask nicely or tell an adult',
        },
        {
          'trigger': 'You want to quit homework',
          'bad': 'Stop working',
          'good': 'Take a short break, then continue',
        },
        {
          'trigger': 'Friend says something mean',
          'bad': 'Say something meaner',
          'good': 'Walk away or talk calmly',
        },
      ],
    },
    {
      'title': 'Managing Big Feelings',
      'emoji': '😤',
      'color': Color(0xFFFF5722),
      'intro': 'Big feelings are okay! Managing them is the key!',
      'feelings': [
        {
          'feeling': 'Angry',
          'emoji': '😠',
          'calmDown': [
            'Take deep breaths',
            'Count to 10',
            'Squeeze a stress ball',
          ],
        },
        {
          'feeling': 'Frustrated',
          'emoji': '😤',
          'calmDown': ['Take a break', 'Ask for help', 'Try again later'],
        },
        {
          'feeling': 'Excited',
          'emoji': '🤩',
          'calmDown': [
            'Use indoor voice',
            'Wait your turn',
            'Channel energy positively',
          ],
        },
        {
          'feeling': 'Sad',
          'emoji': '😢',
          'calmDown': [
            'Talk to someone',
            'Draw your feelings',
            'Give yourself a hug',
          ],
        },
      ],
      'remember':
          'It\'s okay to feel big feelings. What matters is what we DO with them!',
    },
    {
      'title': 'Waiting Skills',
      'emoji': '⏳',
      'color': Color(0xFF4CAF50),
      'intro': 'Waiting is hard! Here are tips to make it easier:',
      'tips': [
        {
          'tip': 'Take deep breaths',
          'emoji': '🌬️',
          'how': 'Breathe in 4 counts, out 4 counts',
        },
        {
          'tip': 'Count in your head',
          'emoji': '🔢',
          'how': 'Count slowly to 20',
        },
        {
          'tip': 'Think of something fun',
          'emoji': '🎈',
          'how': 'Imagine your favorite place',
        },
        {
          'tip': 'Sing a quiet song',
          'emoji': '🎵',
          'how': 'Hum a tune in your head',
        },
        {
          'tip': 'Look at something interesting',
          'emoji': '👀',
          'how': 'Find shapes in the clouds',
        },
        {
          'tip': 'Squeeze your hands',
          'emoji': '✊',
          'how': 'Make fists and release',
        },
      ],
      'situations': [
        'Waiting in line',
        'Waiting for your turn to speak',
        'Waiting for food at a restaurant',
        'Waiting for a special day',
      ],
    },
    {
      'title': 'Following Rules',
      'emoji': '📋',
      'color': Color(0xFF00BCD4),
      'intro': 'Following rules is an important part of self-control!',
      'whyRules': [
        {'reason': 'Keep everyone safe', 'emoji': '🛡️'},
        {'reason': 'Make things fair', 'emoji': '⚖️'},
        {'reason': 'Help everyone get along', 'emoji': '🤝'},
        {'reason': 'Show respect', 'emoji': '💕'},
      ],
      'ruleTypes': [
        {
          'place': 'Home',
          'emoji': '🏠',
          'examples': ['No running inside', 'Bedtime at 8 PM', 'Clean up toys'],
        },
        {
          'place': 'School',
          'emoji': '🏫',
          'examples': [
            'Raise your hand',
            'Walk in hallways',
            'Listen to teacher',
          ],
        },
        {
          'place': 'Playground',
          'emoji': '🛝',
          'examples': ['Take turns', 'Play safely', 'Include everyone'],
        },
      ],
    },
    {
      'title': 'Resisting Temptation',
      'emoji': '💪',
      'color': Color(0xFF9C27B0),
      'intro':
          'Temptation is when you really want to do something you shouldn\'t!',
      'temptations': [
        {
          'temptation': 'Eat snacks before meals',
          'emoji': '🍪',
          'resist': 'Drink water, think about yummy dinner',
        },
        {
          'temptation': 'Play games during homework',
          'emoji': '🎮',
          'resist': 'Put games away, reward yourself after',
        },
        {
          'temptation': 'Stay up past bedtime',
          'emoji': '🌙',
          'resist': 'Remember how tired you\'ll be',
        },
        {
          'temptation': 'Buy everything you see',
          'emoji': '🛍️',
          'resist': 'Wait a day, save for something better',
        },
      ],
      'mantra': 'I am stronger than my temptations!',
    },
    {
      'title': 'Self-Control Games',
      'emoji': '🎮',
      'color': Color(0xFFFF9800),
      'intro': 'Practice self-control with these fun games!',
      'games': [
        {
          'name': 'Red Light, Green Light',
          'emoji': '🚦',
          'howToPlay': 'Run on green, freeze on red!',
          'skill': 'Stopping quickly',
        },
        {
          'name': 'Simon Says',
          'emoji': '👨',
          'howToPlay': 'Only do it if Simon says!',
          'skill': 'Listening carefully',
        },
        {
          'name': 'Freeze Dance',
          'emoji': '💃',
          'howToPlay': 'Dance when music plays, freeze when it stops!',
          'skill': 'Quick control',
        },
        {
          'name': 'The Quiet Game',
          'emoji': '🤫',
          'howToPlay': 'See who can stay quiet the longest!',
          'skill': 'Impulse control',
        },
        {
          'name': 'Turtle Time',
          'emoji': '🐢',
          'howToPlay': 'Do everything super slow!',
          'skill': 'Patience',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final section = sections[currentSection];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Self-Control',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildProgressDots(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: _buildSectionContent(section),
                ),
              ),
              _buildNavButtons(section),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressDots() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(sections.length, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            width: index == currentSection ? 20 : 8,
            height: 8.h,
            decoration: BoxDecoration(
              color: index == currentSection
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4.r),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionContent(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20.r,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(section['emoji'], style: const TextStyle(fontSize: 50)),
              SizedBox(height: 12.h),
              Text(
                section['title'],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                section['intro'],
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        _buildDynamicContent(section),
      ],
    );
  }

  Widget _buildDynamicContent(Map<String, dynamic> section) {
    switch (section['title']) {
      case 'What is Self-Control?':
        return _buildWhatIsSelfControl(section);
      case 'The Marshmallow Test':
        return _buildMarshmallowTest(section);
      case 'Stop and Think':
        return _buildStopAndThink(section);
      case 'Managing Big Feelings':
        return _buildManagingFeelings(section);
      case 'Waiting Skills':
        return _buildWaitingSkills(section);
      case 'Following Rules':
        return _buildFollowingRules(section);
      case 'Resisting Temptation':
        return _buildResistingTemptation(section);
      case 'Self-Control Games':
        return _buildGames(section);
      default:
        return const SizedBox();
    }
  }

  Widget _buildWhatIsSelfControl(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Examples of Self-Control:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              ...(section['examples'] as List).map((example) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        example['emoji'],
                        style: const TextStyle(fontSize: 28),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              example['situation'],
                              style: GoogleFonts.nunito(fontSize: 13),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 4.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: section['color'],
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                example['skill'],
                                style: GoogleFonts.nunito(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              const Text('💪', style: TextStyle(fontSize: 28)),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  section['funFact'],
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMarshmallowTest(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🍡 The Experiment:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              ...(section['story'] as List).asMap().entries.map((entry) {
                final part = entry.value;
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Container(
                        width: 28.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          color: section['color'],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(part['emoji'], style: const TextStyle(fontSize: 20)),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          part['part'],
                          style: GoogleFonts.nunito(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '💡 Strategies to Wait:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              ...(section['strategies'] as List).map((strategy) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.green, size: 18.r),
                      SizedBox(width: 8.w),
                      Text(strategy, style: GoogleFonts.nunito(fontSize: 13)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: section['color'].withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              const Text('🎯', style: TextStyle(fontSize: 28)),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  section['lesson'],
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStopAndThink(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: (section['steps'] as List).map<Widget>((step) {
              return Column(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Color(step['color']),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        step['emoji'],
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    step['step'],
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  Text(step['desc'], style: GoogleFonts.nunito(fontSize: 10)),
                ],
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16.h),
        ...(section['examples'] as List).map((example) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '😤 ${example['trigger']}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          children: [
                            const Text('❌', style: TextStyle(fontSize: 16)),
                            Text(
                              example['bad'],
                              style: GoogleFonts.nunito(fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          children: [
                            const Text('✅', style: TextStyle(fontSize: 16)),
                            Text(
                              example['good'],
                              style: GoogleFonts.nunito(fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildManagingFeelings(Map<String, dynamic> section) {
    return Column(
      children: [
        ...(section['feelings'] as List).map((feeling) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      feeling['emoji'],
                      style: const TextStyle(fontSize: 32),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      feeling['feeling'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  'Calm down by:',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 6.h),
                ...(feeling['calmDown'] as List).map((tip) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10.w, top: 4.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16.r,
                          color: Colors.green,
                        ),
                        SizedBox(width: 8.w),
                        Text(tip, style: GoogleFonts.nunito(fontSize: 12)),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              const Text('💕', style: TextStyle(fontSize: 28)),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  section['remember'],
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWaitingSkills(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '⏳ Waiting Tips:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              ...(section['tips'] as List).map((tip) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Text(tip['emoji'], style: const TextStyle(fontSize: 24)),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tip['tip'],
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              tip['how'],
                              style: GoogleFonts.nunito(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📍 Practice Waiting Here:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.r,
                runSpacing: 8.r,
                children: (section['situations'] as List).map<Widget>((
                  situation,
                ) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      situation,
                      style: GoogleFonts.nunito(fontSize: 12),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFollowingRules(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '❓ Why Follow Rules?',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: (section['whyRules'] as List).map<Widget>((reason) {
                  return Column(
                    children: [
                      Text(
                        reason['emoji'],
                        style: const TextStyle(fontSize: 28),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: 70.w,
                        child: Text(
                          reason['reason'],
                          style: GoogleFonts.nunito(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        ...(section['ruleTypes'] as List).map((type) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(type['emoji'], style: const TextStyle(fontSize: 26)),
                    SizedBox(width: 10.w),
                    Text(
                      '${type['place']} Rules',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ...(type['examples'] as List).map((example) {
                  return Padding(
                    padding: EdgeInsets.only(left: 36.w, top: 4.h),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_right, size: 16.r),
                        Text(example, style: GoogleFonts.nunito(fontSize: 12)),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildResistingTemptation(Map<String, dynamic> section) {
    return Column(
      children: [
        ...(section['temptations'] as List).map((t) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(t['emoji'], style: const TextStyle(fontSize: 28)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        t['temptation'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      const Text('💪', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Resist: ${t['resist']}',
                          style: GoogleFonts.nunito(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: section['color'].withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              const Text('🌟', style: TextStyle(fontSize: 36)),
              SizedBox(height: 8.h),
              Text(
                section['mantra'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGames(Map<String, dynamic> section) {
    return Column(
      children: (section['games'] as List).map<Widget>((game) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Container(
                width: 55.w,
                height: 55.h,
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    game['emoji'],
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
                      game['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                      ),
                    ),
                    Text(
                      game['howToPlay'],
                      style: GoogleFonts.nunito(fontSize: 12),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        '✓ ${game['skill']}',
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavButtons(Map<String, dynamic> section) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentSection > 0)
            ElevatedButton.icon(
              onPressed: () {
                setState(() => currentSection--);
                TtsService.to.speak(sections[currentSection]['title']);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            )
          else
            SizedBox(width: 100.w),
          if (currentSection < sections.length - 1)
            ElevatedButton.icon(
              onPressed: () {
                setState(() => currentSection++);
                TtsService.to.speak(sections[currentSection]['title']);
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.check),
              label: const Text('Done!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
