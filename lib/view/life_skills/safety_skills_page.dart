import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SafetySkillsPage extends StatefulWidget {
  const SafetySkillsPage({super.key});

  @override
  State<SafetySkillsPage> createState() => _SafetySkillsPageState();
}

class _SafetySkillsPageState extends State<SafetySkillsPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Road Safety',
      'emoji': '🚦',
      'color': Color(0xFFE53935),
      'intro': 'Stay safe when walking near roads!',
      'rules': [
        {'rule': 'Always use crosswalks/zebra crossings', 'emoji': '🚶'},
        {'rule': 'Look left, right, then left again', 'emoji': '👀'},
        {'rule': 'Wait for the green light', 'emoji': '🟢'},
        {'rule': 'Never run across the road', 'emoji': '🏃❌'},
        {'rule': 'Walk on the footpath/sidewalk', 'emoji': '👣'},
        {'rule': 'Hold an adult\'s hand', 'emoji': '🤝'},
        {'rule': 'Don\'t play near roads', 'emoji': '⚽❌'},
        {'rule': 'Wear bright colors at night', 'emoji': '💡'},
      ],
      'trafficLights': [
        {'color': 'Red', 'meaning': 'STOP! Do not cross', 'emoji': '🔴'},
        {'color': 'Yellow', 'meaning': 'WAIT! Get ready', 'emoji': '🟡'},
        {'color': 'Green', 'meaning': 'GO! Cross carefully', 'emoji': '🟢'},
      ],
    },
    {
      'title': 'Stranger Safety',
      'emoji': '⚠️',
      'color': Color(0xFFFF9800),
      'intro': 'Not all strangers are bad, but we need to be careful!',
      'safeStrangers': [
        {'who': 'Police officers in uniform', 'emoji': '👮'},
        {'who': 'Teachers at school', 'emoji': '👩‍🏫'},
        {'who': 'Shop workers in their shop', 'emoji': '🛒'},
        {'who': 'Firefighters in uniform', 'emoji': '🧑‍🚒'},
      ],
      'rules': [
        {'rule': 'Never go anywhere with a stranger', 'emoji': '🚫'},
        {'rule': 'Don\'t accept gifts from strangers', 'emoji': '🎁❌'},
        {'rule': 'Don\'t get in a stranger\'s car', 'emoji': '🚗❌'},
        {'rule': 'Yell "NO!" and run if grabbed', 'emoji': '🗣️'},
        {'rule': 'Tell a trusted adult immediately', 'emoji': '👨‍👩‍👧'},
        {'rule': 'Stay in groups with friends', 'emoji': '👫'},
      ],
      'password': 'Have a secret family password that only trusted people know!',
    },
    {
      'title': 'Fire Safety',
      'emoji': '🔥',
      'color': Color(0xFFD32F2F),
      'intro': 'Know what to do in case of fire!',
      'prevention': [
        {'rule': 'Never play with matches or lighters', 'emoji': '🔥❌'},
        {'rule': 'Stay away from candles', 'emoji': '🕯️'},
        {'rule': 'Don\'t touch electrical outlets', 'emoji': '🔌'},
        {'rule': 'Keep things away from heaters', 'emoji': '♨️'},
      ],
      'whatToDo': [
        {'action': 'Tell an adult immediately', 'emoji': '🗣️'},
        {'action': 'Get out of the building fast', 'emoji': '🏃'},
        {'action': 'Crawl low if there\'s smoke', 'emoji': '🐛'},
        {'action': 'Feel doors before opening', 'emoji': '🚪'},
        {'action': 'Never hide in closets', 'emoji': '📦❌'},
        {'action': 'Meet at the meeting point', 'emoji': '📍'},
        {'action': 'Call emergency services', 'emoji': '📞'},
      ],
      'stopDropRoll': {
        'title': 'If your clothes catch fire:',
        'steps': ['🛑 STOP - Don\'t run!', '⬇️ DROP - Fall to the ground', '🔄 ROLL - Roll back and forth'],
      },
    },
    {
      'title': 'Home Safety',
      'emoji': '🏠',
      'color': Color(0xFF4CAF50),
      'intro': 'Stay safe at home!',
      'rules': [
        {'area': 'Kitchen', 'emoji': '👩‍🍳', 'rules': ['Don\'t use stove alone', 'Be careful with hot things', 'Keep knives away']},
        {'area': 'Bathroom', 'emoji': '🛁', 'rules': ['Don\'t run on wet floors', 'Keep water in tub', 'Lock door when using']},
        {'area': 'Stairs', 'emoji': '🪜', 'rules': ['Hold the railing', 'Don\'t run up/down', 'Keep toys off stairs']},
        {'area': 'Outside', 'emoji': '🌳', 'rules': ['Tell parents where you go', 'Stay in safe areas', 'Come home before dark']},
      ],
      'homeAlone': [
        'Don\'t open door for strangers',
        'Know how to call parents',
        'Know emergency numbers',
        'Don\'t tell callers you\'re alone',
        'Lock all doors and windows',
      ],
    },
    {
      'title': 'Water Safety',
      'emoji': '🏊',
      'color': Color(0xFF2196F3),
      'intro': 'Water can be fun but dangerous. Be careful!',
      'rules': [
        {'rule': 'Never swim alone', 'emoji': '👫'},
        {'rule': 'Always have adult supervision', 'emoji': '👀'},
        {'rule': 'Learn to swim', 'emoji': '🏊'},
        {'rule': 'Don\'t run near pools', 'emoji': '🏃❌'},
        {'rule': 'Stay in shallow water first', 'emoji': '💧'},
        {'rule': 'Don\'t push others in water', 'emoji': '🚫'},
        {'rule': 'Wear life jacket when boating', 'emoji': '🦺'},
        {'rule': 'Don\'t dive in unknown water', 'emoji': '🚫'},
      ],
      'beachSafety': [
        {'rule': 'Swim where lifeguards are', 'emoji': '🏖️'},
        {'rule': 'Watch for waves', 'emoji': '🌊'},
        {'rule': 'Stay close to shore', 'emoji': '🏝️'},
        {'rule': 'Know the flag warnings', 'emoji': '🚩'},
      ],
    },
    {
      'title': 'Personal Safety',
      'emoji': '🛡️',
      'color': Color(0xFF9C27B0),
      'intro': 'Keep your body safe!',
      'bodyRules': [
        {'rule': 'Your body belongs to you', 'emoji': '👤'},
        {'rule': 'Private parts are private', 'emoji': '🔒'},
        {'rule': 'No one should touch you in ways that feel wrong', 'emoji': '🚫'},
        {'rule': 'It\'s okay to say NO', 'emoji': '🙅'},
        {'rule': 'Tell a trusted adult if something happens', 'emoji': '🗣️'},
        {'rule': 'It\'s never your fault', 'emoji': '💙'},
      ],
      'trustedAdults': [
        {'who': 'Parents/Guardians', 'emoji': '👨‍👩‍👧'},
        {'who': 'Teachers', 'emoji': '👩‍🏫'},
        {'who': 'School counselor', 'emoji': '🧑‍⚕️'},
        {'who': 'Grandparents', 'emoji': '👵'},
        {'who': 'Police', 'emoji': '👮'},
      ],
    },
    {
      'title': 'Emergency Numbers',
      'emoji': '📞',
      'color': Color(0xFFFF5722),
      'intro': 'Know these important numbers!',
      'numbers': [
        {'service': 'Police', 'number': '100', 'emoji': '👮', 'when': 'Crime, danger, or emergency'},
        {'service': 'Fire', 'number': '101', 'emoji': '🚒', 'when': 'Fire emergency'},
        {'service': 'Ambulance', 'number': '102', 'emoji': '🚑', 'when': 'Medical emergency'},
        {'service': 'Women Helpline', 'number': '1091', 'emoji': '👩', 'when': 'Women in danger'},
        {'service': 'Child Helpline', 'number': '1098', 'emoji': '👧', 'when': 'Children in danger'},
        {'service': 'Emergency', 'number': '112', 'emoji': '🆘', 'when': 'Any emergency'},
      ],
      'howToCall': [
        'Stay calm',
        'Tell them what happened',
        'Give your location/address',
        'Give your name and phone number',
        'Stay on the line',
        'Follow their instructions',
      ],
    },
    {
      'title': 'Safety Quiz',
      'emoji': '✅',
      'color': Color(0xFF673AB7),
      'intro': 'Test what you learned!',
      'questions': [
        {'q': 'What do you do at a red light?', 'a': 'STOP and wait', 'emoji': '🔴'},
        {'q': 'Should you go with a stranger?', 'a': 'NEVER', 'emoji': '🚫'},
        {'q': 'If clothes catch fire?', 'a': 'STOP, DROP, ROLL', 'emoji': '��'},
        {'q': 'Can you swim alone?', 'a': 'NO, always with adult', 'emoji': '🏊'},
        {'q': 'Emergency number in India?', 'a': '112 or 100', 'emoji': '📞'},
        {'q': 'Who can you tell secrets to?', 'a': 'Trusted adults', 'emoji': '🗣️'},
      ],
      'pledge': 'I promise to stay safe and follow these rules!',
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
          'Safety Skills',
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
        decoration: const BoxDecoration(
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
              Text(section['emoji'], style: const TextStyle(fontSize: 50)),
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
              const SizedBox(height: 8),
              Text(
                section['intro'],
                style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildDynamicContent(section),
      ],
    );
  }

  Widget _buildDynamicContent(Map<String, dynamic> section) {
    switch (section['title']) {
      case 'Road Safety':
        return _buildRoadSafety(section);
      case 'Stranger Safety':
        return _buildStrangerSafety(section);
      case 'Fire Safety':
        return _buildFireSafety(section);
      case 'Home Safety':
        return _buildHomeSafety(section);
      case 'Water Safety':
        return _buildWaterSafety(section);
      case 'Personal Safety':
        return _buildPersonalSafety(section);
      case 'Emergency Numbers':
        return _buildEmergencyNumbers(section);
      case 'Safety Quiz':
        return _buildQuiz(section);
      default:
        return const SizedBox();
    }
  }

  Widget _buildRoadSafety(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📋 Road Rules:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['rules'] as List).map((rule) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(rule['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(rule['rule'], style: GoogleFonts.nunito(fontSize: 13))),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🚦 Traffic Lights:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: (section['trafficLights'] as List).map<Widget>((light) {
                  return Column(
                    children: [
                      Text(light['emoji'], style: const TextStyle(fontSize: 40)),
                      const SizedBox(height: 4),
                      Text(light['color'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(light['meaning'], style: GoogleFonts.nunito(fontSize: 10), textAlign: TextAlign.center),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStrangerSafety(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('✅ Safe Adults to Ask for Help:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['safeStrangers'] as List).map((s) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(s['emoji'], style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Text(s['who'], style: GoogleFonts.nunito(fontSize: 14)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('⚠️ Important Rules:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(height: 10),
              ...(section['rules'] as List).map((rule) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(rule['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(rule['rule'], style: GoogleFonts.nunito(fontSize: 13))),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('🔑', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['password'],
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFireSafety(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🛡️ Prevention:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['prevention'] as List).map((rule) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(rule['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(rule['rule'], style: GoogleFonts.nunito(fontSize: 13))),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🔥 If There\'s a Fire:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['whatToDo'] as List).asMap().entries.map((entry) {
                final action = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: section['color'],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(action['emoji'], style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(action['action'], style: GoogleFonts.nunito(fontSize: 13))),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section['stopDropRoll']['title'],
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: (section['stopDropRoll']['steps'] as List).map<Widget>((step) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        step,
                        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
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

  Widget _buildHomeSafety(Map<String, dynamic> section) {
    return Column(
      children: [
        ...(section['rules'] as List).map((area) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(area['emoji'], style: const TextStyle(fontSize: 26)),
                    const SizedBox(width: 10),
                    Text(
                      area['area'],
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: section['color']),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...(area['rules'] as List).map((rule) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 36, top: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(child: Text(rule, style: GoogleFonts.nunito(fontSize: 12))),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🏠 If Home Alone:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...(section['homeAlone'] as List).map((rule) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.amber, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(rule, style: GoogleFonts.nunito(fontSize: 13))),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWaterSafety(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🏊 Pool & Swimming Rules:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['rules'] as List).map((rule) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(rule['emoji'], style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(rule['rule'], style: GoogleFonts.nunito(fontSize: 13))),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🏖️ Beach Safety:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['beachSafety'] as List).map((rule) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(rule['emoji'], style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Text(rule['rule'], style: GoogleFonts.nunito(fontSize: 13)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalSafety(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('💜 Body Safety Rules:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['bodyRules'] as List).map((rule) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Text(rule['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(rule['rule'], style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600))),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🤝 Trusted Adults You Can Tell:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: (section['trustedAdults'] as List).map<Widget>((adult) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: section['color'].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(adult['emoji'], style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text(adult['who'], style: GoogleFonts.nunito(fontSize: 12)),
                      ],
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

  Widget _buildEmergencyNumbers(Map<String, dynamic> section) {
    return Column(
      children: [
        ...(section['numbers'] as List).map((num) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(num['emoji'], style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(num['service'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      Text(num['when'], style: GoogleFonts.nunito(fontSize: 11)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: section['color'],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    num['number'],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📞 How to Call:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['howToCall'] as List).asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(entry.value, style: GoogleFonts.nunito(fontSize: 13)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuiz(Map<String, dynamic> section) {
    return Column(
      children: [
        ...(section['questions'] as List).asMap().entries.map((entry) {
          final q = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: section['color'],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(q['q'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    Text(q['emoji'], style: const TextStyle(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        q['a'],
                        style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: Colors.green.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('🌟', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(
                section['pledge'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
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
