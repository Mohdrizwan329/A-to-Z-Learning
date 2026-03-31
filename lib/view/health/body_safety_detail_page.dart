import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class BodySafetyDetailPage extends StatefulWidget {
  final int sectionIndex;

  const BodySafetyDetailPage({super.key, required this.sectionIndex});

  @override
  State<BodySafetyDetailPage> createState() => _BodySafetyDetailPageState();
}

class _BodySafetyDetailPageState extends State<BodySafetyDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  static final List<Map<String, dynamic>> sections = [
    {
      'title': 'My Body Belongs to Me',
      'emoji': '🧒',
      'content': [
        {'icon': '⭐', 'text': 'Your body is special and belongs only to you'},
        {'icon': '🛡️', 'text': 'You have the right to keep your body safe'},
        {'icon': '👍', 'text': 'You decide who can touch you'},
        {'icon': '🗣️', 'text': 'You can always say NO to touches you don\'t like'},
        {'icon': '❤️', 'text': 'It\'s important to take care of your body'},
      ],
    },
    {
      'title': 'Good Touch vs Bad Touch',
      'emoji': '👋',
      'touches': [
        {
          'type': 'Good Touch',
          'emoji': '💚',
          'isGood': true,
          'examples': [
            'A hug from parents',
            'A high-five from friends',
            'A pat on the back for good work',
            'Doctor\'s check-up with parents present',
          ],
        },
        {
          'type': 'Bad Touch',
          'emoji': '❌',
          'isGood': false,
          'examples': [
            'Any touch that makes you uncomfortable',
            'Touch on private parts',
            'Touch that someone asks you to keep secret',
            'Touch that hurts you',
          ],
        },
      ],
    },
    {
      'title': 'Private Parts',
      'emoji': '🔒',
      'content': [
        {'icon': '👙', 'text': 'Private parts are covered by your underwear/swimsuit'},
        {'icon': '🔐', 'text': 'These parts are called PRIVATE for a reason'},
        {'icon': '🚫', 'text': 'No one should touch or ask to see them'},
        {'icon': '👨‍👩‍👧', 'text': 'Only parents or doctors (with parents) can help when needed'},
        {'icon': '🗣️', 'text': 'Tell a trusted adult if anyone tries to touch them'},
      ],
    },
    {
      'title': 'The Underwear Rule',
      'emoji': '🩲',
      'rules': [
        {'rule': 'P - Privates are Private', 'detail': 'Parts covered by underwear are only yours'},
        {'rule': 'A - Always remember your body is yours', 'detail': 'You\'re the boss of your body'},
        {'rule': 'N - No means No!', 'detail': 'You can always say no to bad touches'},
        {'rule': 'T - Talk about secrets that upset you', 'detail': 'Tell a trusted adult'},
        {'rule': 'S - Speak up, someone can help', 'detail': 'Adults you trust will help you'},
      ],
    },
    {
      'title': 'Trusted Adults',
      'emoji': '👨‍👩‍👧',
      'adults': [
        {'who': 'Parents / Guardians', 'emoji': '👨‍👩‍👧'},
        {'who': 'Grandparents', 'emoji': '👴👵'},
        {'who': 'Teachers', 'emoji': '👩‍🏫'},
        {'who': 'School Counselor', 'emoji': '🏫'},
        {'who': 'Close relatives you trust', 'emoji': '👨‍👧'},
        {'who': 'Police', 'emoji': '👮'},
      ],
      'tip': 'A trusted adult is someone who makes you feel safe and listens to you.',
    },
    {
      'title': 'What to Do If...',
      'emoji': '🆘',
      'steps': [
        {'step': 1, 'action': 'Say NO loudly', 'emoji': '🗣️', 'detail': '"NO! I don\'t like this!"'},
        {'step': 2, 'action': 'Get away if you can', 'emoji': '🏃', 'detail': 'Run to a safe place'},
        {'step': 3, 'action': 'Tell a trusted adult', 'emoji': '👨‍👩‍👧', 'detail': 'It\'s NEVER your fault'},
        {'step': 4, 'action': 'Keep telling until someone helps', 'emoji': '🔁', 'detail': 'Don\'t give up'},
      ],
    },
    {
      'title': 'Good Secrets vs Bad Secrets',
      'emoji': '🤫',
      'secrets': [
        {
          'type': 'Good Secrets',
          'emoji': '🎁',
          'isGood': true,
          'examples': [
            'Surprise birthday party',
            'Gift for someone',
            'Happy surprises',
          ],
          'note': 'These make people happy and are revealed soon',
        },
        {
          'type': 'Bad Secrets',
          'emoji': '⚠️',
          'isGood': false,
          'examples': [
            'Secrets about touches',
            'Secrets that make you scared or sad',
            'Secrets you\'re told never to tell anyone',
          ],
          'note': 'BAD secrets should ALWAYS be told to a trusted adult',
        },
      ],
    },
    {
      'title': 'Remember Always!',
      'emoji': '💪',
      'reminders': [
        {'text': 'Your body belongs to YOU', 'emoji': '⭐'},
        {'text': 'You can ALWAYS say NO', 'emoji': '🚫'},
        {'text': 'It\'s NEVER your fault', 'emoji': '💚'},
        {'text': 'Trusted adults will HELP you', 'emoji': '🤝'},
        {'text': 'TELL someone if you\'re uncomfortable', 'emoji': '🗣️'},
        {'text': 'You are BRAVE and STRONG', 'emoji': '💪'},
        {'text': 'You are LOVED and IMPORTANT', 'emoji': '❤️'},
      ],
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Main Card
            buildFloatingItem(
              index: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withValues(alpha: 0.4),
                      blurRadius: 12,
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
                    const SizedBox(height: 12),
                    Text(
                      section['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
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
            const SizedBox(height: 20),
            // Content based on type
            if (section.containsKey('content'))
              _buildContentCards(section),
            if (section.containsKey('touches'))
              _buildTouchCards(section),
            if (section.containsKey('rules'))
              _buildRuleCards(section),
            if (section.containsKey('adults'))
              _buildAdultCards(section),
            if (section.containsKey('steps'))
              _buildStepCards(section),
            if (section.containsKey('secrets'))
              _buildSecretCards(section),
            if (section.containsKey('reminders'))
              _buildReminderCards(section),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildContentCards(Map<String, dynamic> section) {
    return Column(
      children:
          (section['content'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final item = entry.value;
        final cardGradient =
            AppColors.getGradientForIndex(widget.sectionIndex + idx + 1);
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(item['icon'], style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item['text'],
                    style: GoogleFonts.nunito(
                      fontSize: 16,
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

  Widget _buildTouchCards(Map<String, dynamic> section) {
    return Column(
      children:
          (section['touches'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final touch = entry.value;
        final cardGradient =
            AppColors.getGradientForIndex(widget.sectionIndex + idx + 1);
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(touch['emoji'],
                        style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 10),
                    Text(
                      touch['type'],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 10),
                ...(touch['examples'] as List).map<Widget>((example) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          touch['isGood'] == true
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            example,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRuleCards(Map<String, dynamic> section) {
    return Column(
      children:
          (section['rules'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final rule = entry.value;
        final cardGradient =
            AppColors.getGradientForIndex(widget.sectionIndex + idx + 1);
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule['rule'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rule['detail'],
                  style: GoogleFonts.nunito(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdultCards(Map<String, dynamic> section) {
    final adults = section['adults'] as List;
    return Column(
      children: [
        ...adults.asMap().entries.map<Widget>((entry) {
          final idx = entry.key;
          final adult = entry.value;
          final cardGradient =
              AppColors.getGradientForIndex(widget.sectionIndex + idx + 1);
          return buildFloatingItem(
            index: idx + 1,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: cardGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: cardGradient[0].withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(adult['emoji'], style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      adult['who'],
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        if (section.containsKey('tip'))
          buildFloatingItem(
            index: adults.length + 1,
            child: Container(
              margin: const EdgeInsets.only(top: 4, bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      section['tip'],
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
          ),
      ],
    );
  }

  Widget _buildStepCards(Map<String, dynamic> section) {
    return Column(
      children:
          (section['steps'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final step = entry.value;
        final cardGradient =
            AppColors.getGradientForIndex(widget.sectionIndex + idx + 1);
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${step['step']}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(step['emoji'], style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['action'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        step['detail'],
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

  Widget _buildSecretCards(Map<String, dynamic> section) {
    return Column(
      children:
          (section['secrets'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final secret = entry.value;
        final cardGradient =
            AppColors.getGradientForIndex(widget.sectionIndex + idx + 1);
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(secret['emoji'],
                        style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 10),
                    Text(
                      secret['type'],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...(secret['examples'] as List).map<Widget>((example) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          secret['isGood'] == true
                              ? Icons.check
                              : Icons.warning,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            example,
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    secret['note'],
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReminderCards(Map<String, dynamic> section) {
    return Column(
      children:
          (section['reminders'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final reminder = entry.value;
        final cardGradient =
            AppColors.getGradientForIndex(widget.sectionIndex + idx + 1);
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(reminder['emoji'],
                    style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    reminder['text'],
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
}
