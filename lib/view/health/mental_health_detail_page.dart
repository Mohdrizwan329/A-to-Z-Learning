import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class MentalHealthDetailPage extends StatefulWidget {
  final int sectionIndex;

  const MentalHealthDetailPage({super.key, required this.sectionIndex});

  @override
  State<MentalHealthDetailPage> createState() => _MentalHealthDetailPageState();
}

class _MentalHealthDetailPageState extends State<MentalHealthDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  static final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Mental Health?',
      'emoji': '🧠',
      'content': [
        {
          'icon': '🧠',
          'text': 'Mental health is about how we think, feel, and act',
        },
        {
          'icon': '😊',
          'text': 'It\'s about feeling good inside, not just outside',
        },
        {
          'icon': '💭',
          'text': 'It affects how we handle stress and make choices',
        },
        {'icon': '🤝', 'text': 'It helps us get along with others'},
        {
          'icon': '⭐',
          'text': 'Everyone has mental health, just like physical health!',
        },
      ],
    },
    {
      'title': 'Understanding Feelings',
      'emoji': '😊',
      'feelings': [
        {
          'feeling': 'Happy',
          'emoji': '😊',
          'when': 'When something good happens',
        },
        {
          'feeling': 'Sad',
          'emoji': '😢',
          'when': 'When we lose something or feel hurt',
        },
        {'feeling': 'Angry', 'emoji': '😠', 'when': 'When things are unfair'},
        {
          'feeling': 'Scared',
          'emoji': '😨',
          'when': 'When we face something unknown',
        },
        {
          'feeling': 'Excited',
          'emoji': '🤩',
          'when': 'When we look forward to something',
        },
        {
          'feeling': 'Calm',
          'emoji': '😌',
          'when': 'When we feel peaceful inside',
        },
      ],
    },
    {
      'title': 'All Feelings are OK',
      'emoji': '💚',
      'messages': [
        {'text': 'It\'s OK to feel sad sometimes', 'emoji': '😢✓'},
        {'text': 'It\'s OK to feel angry', 'emoji': '😠✓'},
        {'text': 'It\'s OK to feel scared', 'emoji': '😨✓'},
        {'text': 'It\'s OK to cry', 'emoji': '😭✓'},
        {'text': 'It\'s OK to ask for help', 'emoji': '🙋✓'},
        {'text': 'Feelings come and go like clouds', 'emoji': '☁️'},
        {'text': 'You are not your feelings', 'emoji': '💫'},
      ],
    },
    {
      'title': 'When Feeling Sad',
      'emoji': '😢',
      'tips': [
        {'tip': 'Talk to someone you trust', 'emoji': '🗣️'},
        {'tip': 'Hug a parent or stuffed toy', 'emoji': '🤗'},
        {'tip': 'Draw or color your feelings', 'emoji': '🎨'},
        {'tip': 'Listen to happy music', 'emoji': '🎵'},
        {'tip': 'Go outside and play', 'emoji': '🌳'},
        {'tip': 'Write in a journal', 'emoji': '📔'},
        {'tip': 'Remember: sadness doesn\'t last forever', 'emoji': '🌈'},
      ],
    },
    {
      'title': 'When Feeling Angry',
      'emoji': '😠',
      'strategies': [
        {
          'strategy': 'Take deep breaths',
          'emoji': '🌬️',
          'howTo': 'Breathe in... count to 5... breathe out',
        },
        {
          'strategy': 'Count to 10',
          'emoji': '🔢',
          'howTo': '1, 2, 3, 4, 5, 6, 7, 8, 9, 10...',
        },
        {
          'strategy': 'Walk away',
          'emoji': '🚶',
          'howTo': 'Take a break from the situation',
        },
        {
          'strategy': 'Squeeze a stress ball',
          'emoji': '✊',
          'howTo': 'Let the anger out safely',
        },
        {
          'strategy': 'Talk about it',
          'emoji': '🗣️',
          'howTo': 'Tell someone how you feel',
        },
        {
          'strategy': 'Exercise',
          'emoji': '🏃',
          'howTo': 'Run, jump, or dance it out',
        },
      ],
    },
    {
      'title': 'When Feeling Worried',
      'emoji': '😰',
      'calming': [
        {
          'method': '5-4-3-2-1 Game',
          'emoji': '🖐️',
          'steps':
              'See 5 things, hear 4 things, touch 3 things, smell 2 things, taste 1 thing',
        },
        {
          'method': 'Belly Breathing',
          'emoji': '🎈',
          'steps':
              'Put hand on tummy, breathe in like filling a balloon, slowly let it out',
        },
        {
          'method': 'Happy Place',
          'emoji': '🏖️',
          'steps': 'Close eyes and imagine your favorite safe place',
        },
        {
          'method': 'Positive Talk',
          'emoji': '💪',
          'steps': 'Say "I am brave, I can do this"',
        },
        {
          'method': 'Hug Yourself',
          'emoji': '🤗',
          'steps': 'Cross arms and give yourself a big hug',
        },
      ],
    },
    {
      'title': 'Be Kind to Yourself',
      'emoji': '💗',
      'kindness': [
        {'text': 'You are doing your best', 'emoji': '⭐'},
        {'text': 'It\'s OK to make mistakes', 'emoji': '✏️'},
        {'text': 'You are learning every day', 'emoji': '📚'},
        {'text': 'You are special just as you are', 'emoji': '💎'},
        {'text': 'Celebrate small wins', 'emoji': '🎉'},
        {'text': 'Rest when you need to', 'emoji': '😴'},
        {'text': 'Be your own best friend', 'emoji': '🤝'},
      ],
    },
    {
      'title': 'Healthy Mind Habits',
      'emoji': '🌟',
      'habits': [
        {
          'habit': 'Sleep well every night',
          'emoji': '😴',
          'why': 'Rest helps your brain',
        },
        {
          'habit': 'Play and have fun',
          'emoji': '🎮',
          'why': 'Fun makes you happy',
        },
        {
          'habit': 'Spend time with family',
          'emoji': '👨‍👩‍👧',
          'why': 'Love keeps you strong',
        },
        {
          'habit': 'Be active every day',
          'emoji': '🏃',
          'why': 'Exercise helps mood',
        },
        {
          'habit': 'Eat healthy foods',
          'emoji': '🥗',
          'why': 'Good food = good mood',
        },
        {
          'habit': 'Limit screen time',
          'emoji': '📱',
          'why': 'Balance is important',
        },
        {
          'habit': 'Practice gratitude',
          'emoji': '🙏',
          'why': 'Thankfulness brings joy',
        },
        {
          'habit': 'Be kind to others',
          'emoji': '💕',
          'why': 'Kindness makes everyone happy',
        },
      ],
    },
    {
      'title': 'When to Ask for Help',
      'emoji': '🆘',
      'signs': [
        {'sign': 'Feeling sad for many days', 'emoji': '😢'},
        {'sign': 'Not wanting to play or eat', 'emoji': '🍽️'},
        {'sign': 'Trouble sleeping', 'emoji': '🛏️'},
        {'sign': 'Feeling scared all the time', 'emoji': '😰'},
        {'sign': 'Getting angry very often', 'emoji': '😠'},
        {'sign': 'Not wanting to go to school', 'emoji': '🏫'},
      ],
      'helpText':
          'If you feel this way, talk to a trusted adult. They can help!',
    },
  ];

  @override
  void initState() {
    super.initState();
    initGridAnimations(this, floatRange: 3.0);
    TtsService.to.speak(sections[widget.sectionIndex]['title']);
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
            if (section.containsKey('content')) _buildContentCards(section),
            if (section.containsKey('feelings')) _buildFeelingCards(section),
            if (section.containsKey('messages')) _buildMessageCards(section),
            if (section.containsKey('tips')) _buildTipCards(section),
            if (section.containsKey('strategies')) _buildStrategyCards(section),
            if (section.containsKey('calming')) _buildCalmingCards(section),
            if (section.containsKey('kindness')) _buildKindnessCards(section),
            if (section.containsKey('habits')) _buildHabitCards(section),
            if (section.containsKey('signs')) _buildSignCards(section),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCards(Map<String, dynamic> section) {
    return Column(
      children: (section['content'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final item = entry.value;
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
                Text(item['icon'], style: const TextStyle(fontSize: 32)),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    item['text'],
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildFeelingCards(Map<String, dynamic> section) {
    return Column(
      children: (section['feelings'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final feeling = entry.value;
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
                Text(feeling['emoji'], style: const TextStyle(fontSize: 36)),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feeling['feeling'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        feeling['when'],
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

  Widget _buildMessageCards(Map<String, dynamic> section) {
    return Column(
      children: (section['messages'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final message = entry.value;
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
                Text(message['emoji'], style: const TextStyle(fontSize: 28)),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    message['text'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
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

  Widget _buildStrategyCards(Map<String, dynamic> section) {
    return Column(
      children: (section['strategies'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final strategy = entry.value;
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
                Text(strategy['emoji'], style: const TextStyle(fontSize: 32)),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strategy['strategy'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        strategy['howTo'],
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
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

  Widget _buildCalmingCards(Map<String, dynamic> section) {
    return Column(
      children: (section['calming'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final calm = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(calm['emoji'], style: const TextStyle(fontSize: 32)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        calm['method'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    calm['steps'],
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 13,
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

  Widget _buildKindnessCards(Map<String, dynamic> section) {
    return Column(
      children: (section['kindness'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final kind = entry.value;
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
                Text(kind['emoji'], style: const TextStyle(fontSize: 32)),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    kind['text'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
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

  Widget _buildHabitCards(Map<String, dynamic> section) {
    return Column(
      children: (section['habits'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final habit = entry.value;
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
                Text(habit['emoji'], style: const TextStyle(fontSize: 28)),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit['habit'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        habit['why'],
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
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

  Widget _buildSignCards(Map<String, dynamic> section) {
    final signs = section['signs'] as List;
    return Column(
      children: [
        ...signs.asMap().entries.map<Widget>((entry) {
          final idx = entry.key;
          final sign = entry.value;
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
                  Text(sign['emoji'], style: const TextStyle(fontSize: 28)),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      sign['sign'],
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
        }),
        if (section.containsKey('helpText'))
          buildFloatingItem(
            index: 99,
            child: Container(
              margin: EdgeInsets.only(top: 8.h),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.green.withValues(alpha: 0.6),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  const Text('💚', style: TextStyle(fontSize: 28)),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      section['helpText'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
