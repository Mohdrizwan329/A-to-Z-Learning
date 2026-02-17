import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DigitalEtiquettePage extends StatefulWidget {
  const DigitalEtiquettePage({super.key});

  @override
  State<DigitalEtiquettePage> createState() => _DigitalEtiquettePageState();
}

class _DigitalEtiquettePageState extends State<DigitalEtiquettePage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Digital Etiquette?',
      'emoji': '🌟',
      'color': Color(0xFF9C27B0),
      'content': 'Digital etiquette means having good manners online! It\'s how we should behave when using computers, phones, and the internet.',
      'comparison': [
        {'real': 'Say please and thank you', 'digital': 'Use kind words in messages'},
        {'real': 'Don\'t yell at people', 'digital': 'Don\'t write in ALL CAPS'},
        {'real': 'Wait your turn', 'digital': 'Don\'t interrupt video calls'},
        {'real': 'Be respectful', 'digital': 'Treat everyone kindly online'},
      ],
    },
    {
      'title': 'Messaging Manners',
      'emoji': '💬',
      'color': Color(0xFF2196F3),
      'dos': [
        {'rule': 'Use proper spelling', 'emoji': '✏️'},
        {'rule': 'Say hi and bye', 'emoji': '👋'},
        {'rule': 'Read before replying', 'emoji': '👀'},
        {'rule': 'Be patient for replies', 'emoji': '⏰'},
        {'rule': 'Use emojis nicely', 'emoji': '😊'},
      ],
      'donts': [
        {'rule': 'Don\'t send too many messages', 'emoji': '📧❌'},
        {'rule': 'Don\'t use ALL CAPS (it\'s shouting!)', 'emoji': '🗣️❌'},
        {'rule': 'Don\'t share mean messages', 'emoji': '😠❌'},
        {'rule': 'Don\'t send before thinking', 'emoji': '🤔'},
      ],
    },
    {
      'title': 'Video Call Rules',
      'emoji': '📹',
      'color': Color(0xFF4CAF50),
      'before': [
        {'rule': 'Find a quiet place', 'emoji': '🤫'},
        {'rule': 'Check your background', 'emoji': '🖼️'},
        {'rule': 'Have good lighting', 'emoji': '💡'},
        {'rule': 'Test your microphone', 'emoji': '🎤'},
      ],
      'during': [
        {'rule': 'Mute when not talking', 'emoji': '🔇'},
        {'rule': 'Look at the camera', 'emoji': '👀'},
        {'rule': 'Don\'t eat on camera', 'emoji': '🍔❌'},
        {'rule': 'Raise hand to speak', 'emoji': '✋'},
        {'rule': 'Listen when others talk', 'emoji': '👂'},
      ],
    },
    {
      'title': 'Social Media Kindness',
      'emoji': '❤️',
      'color': Color(0xFFE91E63),
      'intro': 'Social media should be a happy place. Spread kindness!',
      'kindActions': [
        {'action': 'Post positive things', 'emoji': '🌈'},
        {'action': 'Give nice compliments', 'emoji': '💕'},
        {'action': 'Share helpful information', 'emoji': '📚'},
        {'action': 'Support your friends', 'emoji': '🤝'},
        {'action': 'Report mean content', 'emoji': '🛡️'},
      ],
      'thinkBeforePost': {
        'T': 'Is it True?',
        'H': 'Is it Helpful?',
        'I': 'Is it Inspiring?',
        'N': 'Is it Necessary?',
        'K': 'Is it Kind?',
      },
    },
    {
      'title': 'Gaming Etiquette',
      'emoji': '🎮',
      'color': Color(0xFFFF9800),
      'rules': [
        {'rule': 'Play fair - no cheating!', 'emoji': '⚖️'},
        {'rule': 'Be a good sport - win or lose', 'emoji': '🏆'},
        {'rule': 'Don\'t rage quit', 'emoji': '😤❌'},
        {'rule': 'Help new players', 'emoji': '🤝'},
        {'rule': 'Keep game chat friendly', 'emoji': '💬'},
        {'rule': 'Take breaks', 'emoji': '⏸️'},
        {'rule': 'Don\'t share personal info', 'emoji': '🔒'},
      ],
      'goodGamer': 'A good gamer makes the game fun for everyone!',
    },
    {
      'title': 'Email Basics',
      'emoji': '📧',
      'color': Color(0xFF00BCD4),
      'parts': [
        {'part': 'To', 'desc': 'Who gets the email', 'emoji': '👤'},
        {'part': 'Subject', 'desc': 'What it\'s about', 'emoji': '📋'},
        {'part': 'Greeting', 'desc': 'Say hi! (Dear..., Hi...)', 'emoji': '👋'},
        {'part': 'Body', 'desc': 'Your message', 'emoji': '📝'},
        {'part': 'Closing', 'desc': 'End nicely (Best, Thanks)', 'emoji': '👍'},
        {'part': 'Signature', 'desc': 'Your name', 'emoji': '✍️'},
      ],
      'tips': [
        'Use a clear subject line',
        'Keep messages short and clear',
        'Check spelling before sending',
        'Be polite and respectful',
      ],
    },
    {
      'title': 'Respecting Others Online',
      'emoji': '🙏',
      'color': Color(0xFF795548),
      'rules': [
        {'rule': 'Ask before sharing someone\'s photo', 'emoji': '📷'},
        {'rule': 'Respect different opinions', 'emoji': '🤔'},
        {'rule': 'Don\'t make fun of others', 'emoji': '😔❌'},
        {'rule': 'Keep secrets secret', 'emoji': '🤐'},
        {'rule': 'Give credit when sharing others\' work', 'emoji': '🎨'},
        {'rule': 'Include everyone', 'emoji': '👫'},
      ],
      'golden': 'The Golden Rule: Treat others online how you want to be treated!',
    },
    {
      'title': 'Digital Citizen Checklist',
      'emoji': '✅',
      'color': Color(0xFF673AB7),
      'checklist': [
        {'item': 'I am kind in all my messages', 'emoji': '💕'},
        {'item': 'I think before I post or send', 'emoji': '🤔'},
        {'item': 'I respect others\' privacy', 'emoji': '🔒'},
        {'item': 'I follow video call rules', 'emoji': '📹'},
        {'item': 'I am a good sport in games', 'emoji': '🎮'},
        {'item': 'I write polite emails', 'emoji': '📧'},
        {'item': 'I ask for permission', 'emoji': '✋'},
        {'item': 'I spread positivity online', 'emoji': '🌟'},
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
          'Digital Etiquette',
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
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (section['title'] == 'What is Digital Etiquette?')
          _buildIntro(section),
        if (section['title'] == 'Messaging Manners')
          _buildMessaging(section),
        if (section['title'] == 'Video Call Rules')
          _buildVideoCalls(section),
        if (section['title'] == 'Social Media Kindness')
          _buildSocialMedia(section),
        if (section['title'] == 'Gaming Etiquette')
          _buildGaming(section),
        if (section['title'] == 'Email Basics')
          _buildEmail(section),
        if (section['title'] == 'Respecting Others Online')
          _buildRespect(section),
        if (section['title'] == 'Digital Citizen Checklist')
          _buildChecklist(section),
      ],
    );
  }

  Widget _buildIntro(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['content'],
            style: GoogleFonts.nunito(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🔄 Real Life vs Digital Life:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...(section['comparison'] as List).map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🏠 Real',
                              style: GoogleFonts.nunito(fontSize: 10, color: Colors.grey),
                            ),
                            Text(item['real'], style: GoogleFonts.nunito(fontSize: 12)),
                          ],
                        ),
                      ),
                      const Text('=', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '💻 Digital',
                              style: GoogleFonts.nunito(fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              item['digital'],
                              style: GoogleFonts.nunito(fontSize: 12),
                              textAlign: TextAlign.right,
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
      ],
    );
  }

  Widget _buildMessaging(Map<String, dynamic> section) {
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
              Text(
                '✅ DO:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              ...(section['dos'] as List).map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(item['rule'], style: GoogleFonts.nunito(fontSize: 14)),
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
              Text(
                '❌ DON\'T:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              ...(section['donts'] as List).map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(item['rule'], style: GoogleFonts.nunito(fontSize: 14))),
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

  Widget _buildVideoCalls(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🔧 Before the Call:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 10),
              ...(section['before'] as List).map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(item['rule'], style: GoogleFonts.nunito(fontSize: 14)),
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
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📹 During the Call:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 10),
              ...(section['during'] as List).map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(item['rule'], style: GoogleFonts.nunito(fontSize: 14)),
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

  Widget _buildSocialMedia(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['intro'],
            style: GoogleFonts.nunito(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '💕 Spread Kindness:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...(section['kindActions'] as List).map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(item['action'], style: GoogleFonts.nunito(fontSize: 14)),
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
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🤔 THINK Before You Post:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...(section['thinkBeforePost'] as Map).entries.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: section['color'],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(entry.value, style: GoogleFonts.nunito(fontWeight: FontWeight.w600)),
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

  Widget _buildGaming(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ...(section['rules'] as List).map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: section['color'].withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(item['emoji'], style: const TextStyle(fontSize: 20)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item['rule'],
                          style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                        ),
                      ),
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
              const Text('🌟', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['goodGamer'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmail(Map<String, dynamic> section) {
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
              Text(
                '📧 Parts of an Email:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...(section['parts'] as List).asMap().entries.map((entry) {
                final part = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              part['part'],
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              part['desc'],
                              style: GoogleFonts.nunito(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Text(part['emoji'], style: const TextStyle(fontSize: 20)),
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
            color: Colors.cyan.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '💡 Email Tips:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...(section['tips'] as List).map((tip) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.teal, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(tip, style: GoogleFonts.nunito(fontSize: 13))),
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

  Widget _buildRespect(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: (section['rules'] as List).map<Widget>((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: section['color'].withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(item['emoji'], style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item['rule'],
                        style: GoogleFonts.nunito(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('✨', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text(
                section['golden'],
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

  Widget _buildChecklist(Map<String, dynamic> section) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: (section['checklist'] as List).map<Widget>((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: section['color'].withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: section['color'].withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item['item'],
                    style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(item['emoji'], style: const TextStyle(fontSize: 22)),
              ],
            ),
          );
        }).toList(),
      ),
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
