import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BodySafetyPage extends StatefulWidget {
  const BodySafetyPage({super.key});

  @override
  State<BodySafetyPage> createState() => _BodySafetyPageState();
}

class _BodySafetyPageState extends State<BodySafetyPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'My Body Belongs to Me',
      'emoji': '🧒',
      'color': Color(0xFF42A5F5),
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
      'color': Color(0xFF66BB6A),
      'touches': [
        {
          'type': 'Good Touch',
          'emoji': '💚',
          'color': Colors.green,
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
          'color': Colors.red,
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
      'color': Color(0xFFFF7043),
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
      'color': Color(0xFFAB47BC),
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
      'color': Color(0xFF26A69A),
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
      'color': Color(0xFFEF5350),
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
      'color': Color(0xFFFFB74D),
      'secrets': [
        {
          'type': 'Good Secrets',
          'emoji': '🎁',
          'color': Colors.green,
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
          'color': Colors.red,
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
      'color': Color(0xFF7986CB),
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
  Widget build(BuildContext context) {
    final section = sections[currentSection];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Body Safety',
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
            colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
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
                  padding: const EdgeInsets.all(16),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(sections.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: index == currentSection ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: index == currentSection
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4),
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
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(section['emoji'], style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 12),
              Text(
                section['title'],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (section.containsKey('content')) _buildContentCards(section),
        if (section.containsKey('touches')) _buildTouchCards(section),
        if (section.containsKey('rules')) _buildRuleCards(section),
        if (section.containsKey('adults')) _buildAdultCards(section),
        if (section.containsKey('steps')) _buildStepCards(section),
        if (section.containsKey('secrets')) _buildSecretCards(section),
        if (section.containsKey('reminders')) _buildReminderCards(section),
      ],
    );
  }

  Widget _buildContentCards(Map<String, dynamic> section) {
    return Column(
      children: (section['content'] as List).map<Widget>((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
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
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTouchCards(Map<String, dynamic> section) {
    return Column(
      children: (section['touches'] as List).map<Widget>((touch) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (touch['color'] as Color).withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(touch['emoji'], style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 10),
                  Text(
                    touch['type'],
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: touch['color'],
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              ...(touch['examples'] as List).map<Widget>((example) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        touch['type'] == 'Good Touch' ? Icons.check_circle : Icons.cancel,
                        color: touch['color'],
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          example,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRuleCards(Map<String, dynamic> section) {
    return Column(
      children: (section['rules'] as List).map<Widget>((rule) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rule['rule'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                rule['detail'],
                style: GoogleFonts.nunito(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdultCards(Map<String, dynamic> section) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: (section['adults'] as List).length,
          itemBuilder: (context, index) {
            final adult = section['adults'][index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(adult['emoji'], style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 6),
                  Text(
                    adult['who'],
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      color: section['color'],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
        if (section.containsKey('tip'))
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.yellow.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange, width: 1),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section['tip'],
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStepCards(Map<String, dynamic> section) {
    return Column(
      children: (section['steps'] as List).map<Widget>((step) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: section['color'],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${step['step']}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(step['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['action'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      step['detail'],
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                        fontSize: 12,
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

  Widget _buildSecretCards(Map<String, dynamic> section) {
    return Column(
      children: (section['secrets'] as List).map<Widget>((secret) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (secret['color'] as Color).withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(secret['emoji'], style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 10),
                  Text(
                    secret['type'],
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: secret['color'],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...(secret['examples'] as List).map<Widget>((example) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        secret['type'] == 'Good Secrets' ? Icons.check : Icons.warning,
                        color: secret['color'],
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          example,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (secret['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  secret['note'],
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: secret['color'],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReminderCards(Map<String, dynamic> section) {
    return Column(
      children: (section['reminders'] as List).map<Widget>((reminder) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: section['color'].withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(reminder['emoji'], style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  reminder['text'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: section['color'],
                    fontSize: 15,
                  ),
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
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentSection > 0)
            ElevatedButton.icon(
              onPressed: () => setState(() => currentSection--),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            const SizedBox(width: 100),
          if (currentSection < sections.length - 1)
            ElevatedButton.icon(
              onPressed: () => setState(() => currentSection++),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
