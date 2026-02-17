import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class InternetSafetyPage extends StatefulWidget {
  const InternetSafetyPage({super.key});

  @override
  State<InternetSafetyPage> createState() => _InternetSafetyPageState();
}

class _InternetSafetyPageState extends State<InternetSafetyPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is the Internet?',
      'emoji': '🌐',
      'color': Color(0xFF2196F3),
      'content': 'The internet connects computers all around the world! It\'s like a giant web where you can find information, play games, and talk to people.',
      'visualItems': [
        {'emoji': '🏠', 'label': 'Your Home'},
        {'emoji': '↔️', 'label': ''},
        {'emoji': '🌍', 'label': 'Whole World'},
      ],
      'goodThings': ['Learn new things', 'Play fun games', 'Talk to family far away', 'Watch videos'],
    },
    {
      'title': 'Personal Information',
      'emoji': '🔒',
      'color': Color(0xFFE91E63),
      'warning': 'NEVER share these online with strangers:',
      'neverShare': [
        {'item': 'Your full name', 'emoji': '👤'},
        {'item': 'Your address', 'emoji': '🏠'},
        {'item': 'Your phone number', 'emoji': '📱'},
        {'item': 'Your school name', 'emoji': '🏫'},
        {'item': 'Your password', 'emoji': '🔑'},
        {'item': 'Your photos', 'emoji': '📷'},
      ],
      'tip': 'If someone asks for this information, tell a parent or teacher right away!',
    },
    {
      'title': 'Strong Passwords',
      'emoji': '🔐',
      'color': Color(0xFF9C27B0),
      'intro': 'A password is like a key to your online house. Make it strong!',
      'goodPassword': [
        {'rule': 'Use letters AND numbers', 'example': 'Cat123', 'emoji': '🔤'},
        {'rule': 'Add special characters', 'example': 'Cat@123!', 'emoji': '✨'},
        {'rule': 'Make it long', 'example': '8+ characters', 'emoji': '📏'},
        {'rule': 'Mix UPPER and lower', 'example': 'CaT@123!', 'emoji': '🔠'},
      ],
      'badPassword': ['123456', 'password', 'your name', 'your birthday'],
      'remember': 'Never tell anyone your password except parents!',
    },
    {
      'title': 'Stranger Danger Online',
      'emoji': '⚠️',
      'color': Color(0xFFFF5722),
      'message': 'Not everyone online is who they say they are!',
      'rules': [
        {'rule': 'Don\'t talk to strangers online', 'emoji': '🚫'},
        {'rule': 'Never meet online friends in person', 'emoji': '👋❌'},
        {'rule': 'Tell parents if someone bothers you', 'emoji': '👨‍👩‍👧'},
        {'rule': 'Block people who are mean', 'emoji': '🛑'},
        {'rule': 'Don\'t accept friend requests from strangers', 'emoji': '❌'},
      ],
      'remember': 'Online friends should stay online. Real friends you meet in real life!',
    },
    {
      'title': 'Safe Websites',
      'emoji': '✅',
      'color': Color(0xFF4CAF50),
      'intro': 'Not all websites are safe for kids. Here\'s how to know:',
      'safeSignals': [
        {'signal': 'Ask a parent first', 'emoji': '👨‍👩‍👧'},
        {'signal': 'Look for kid-friendly sites', 'emoji': '👧'},
        {'signal': 'Check for "https" at start', 'emoji': '🔒'},
        {'signal': 'Use search with Safe Mode', 'emoji': '🔍'},
      ],
      'dangerSigns': [
        {'sign': 'Lots of pop-ups', 'emoji': '⚠️'},
        {'sign': 'Asks for personal info', 'emoji': '❌'},
        {'sign': 'Looks weird or scary', 'emoji': '😰'},
        {'sign': 'Says you won a prize', 'emoji': '🎁❌'},
      ],
    },
    {
      'title': 'Cyberbullying',
      'emoji': '🛡️',
      'color': Color(0xFFFF9800),
      'intro': 'Cyberbullying is when someone is mean to others online.',
      'whatItIs': [
        'Sending mean messages',
        'Sharing embarrassing photos',
        'Leaving someone out on purpose',
        'Spreading rumors online',
      ],
      'whatToDo': [
        {'action': 'Don\'t respond', 'emoji': '🤐'},
        {'action': 'Save the evidence', 'emoji': '📸'},
        {'action': 'Block the bully', 'emoji': '🚫'},
        {'action': 'Tell a trusted adult', 'emoji': '👨‍👩‍👧'},
        {'action': 'Be kind online', 'emoji': '💝'},
      ],
      'golden': 'Treat others online the way you want to be treated!',
    },
    {
      'title': 'Screen Time Balance',
      'emoji': '⏰',
      'color': Color(0xFF00BCD4),
      'intro': 'Too much screen time isn\'t healthy. Balance is key!',
      'balance': [
        {'activity': 'Play outside', 'emoji': '🏃'},
        {'activity': 'Read books', 'emoji': '📚'},
        {'activity': 'Play with friends', 'emoji': '👫'},
        {'activity': 'Do homework first', 'emoji': '✏️'},
        {'activity': 'Help at home', 'emoji': '🏠'},
        {'activity': 'Get enough sleep', 'emoji': '😴'},
      ],
      'tips': [
        'Take breaks every 30 minutes',
        'No screens before bed',
        'Keep screens in family areas',
        'Follow time limits set by parents',
      ],
    },
    {
      'title': 'Be a Good Digital Citizen',
      'emoji': '🌟',
      'color': Color(0xFF673AB7),
      'intro': 'A good digital citizen uses the internet safely and kindly!',
      'pledges': [
        {'pledge': 'I will be kind online', 'emoji': '💕'},
        {'pledge': 'I will protect my information', 'emoji': '🔒'},
        {'pledge': 'I will tell adults if I see something bad', 'emoji': '🗣️'},
        {'pledge': 'I will not share others\' photos without asking', 'emoji': '📷'},
        {'pledge': 'I will balance my screen time', 'emoji': '⚖️'},
        {'pledge': 'I will think before I post', 'emoji': '🤔'},
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
          'Internet Safety',
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
        if (section['title'] == 'What is the Internet?')
          _buildInternetIntro(section),
        if (section['title'] == 'Personal Information')
          _buildPersonalInfo(section),
        if (section['title'] == 'Strong Passwords')
          _buildPasswords(section),
        if (section['title'] == 'Stranger Danger Online')
          _buildStrangerDanger(section),
        if (section['title'] == 'Safe Websites')
          _buildSafeWebsites(section),
        if (section['title'] == 'Cyberbullying')
          _buildCyberbullying(section),
        if (section['title'] == 'Screen Time Balance')
          _buildScreenTime(section),
        if (section['title'] == 'Be a Good Digital Citizen')
          _buildDigitalCitizen(section),
      ],
    );
  }

  Widget _buildInternetIntro(Map<String, dynamic> section) {
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
              Text(
                section['content'],
                style: GoogleFonts.nunito(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: (section['visualItems'] as List).map<Widget>((item) {
                  return Column(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 36)),
                      if (item['label'].isNotEmpty)
                        Text(
                          item['label'],
                          style: GoogleFonts.nunito(fontSize: 11),
                        ),
                    ],
                  );
                }).toList(),
              ),
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
                '✨ Good things about the Internet:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 8),
              ...(section['goodThings'] as List).map((thing) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 18),
                      const SizedBox(width: 8),
                      Text(thing, style: GoogleFonts.nunito(fontSize: 14)),
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

  Widget _buildPersonalInfo(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('🚨', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      section['warning'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...(section['neverShare'] as List).map((item) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Text(
                        item['item'],
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.close, color: Colors.red),
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
              const Text('💡', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['tip'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
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

  Widget _buildPasswords(Map<String, dynamic> section) {
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
                section['intro'],
                style: GoogleFonts.nunito(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '✅ Good Password Tips:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              ...(section['goodPassword'] as List).map((item) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['rule'],
                              style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Example: ${item['example']}',
                              style: GoogleFonts.nunito(fontSize: 12, color: Colors.grey.shade600),
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
                '❌ Bad Passwords:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (section['badPassword'] as List).map<Widget>((bad) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      bad,
                      style: GoogleFonts.nunito(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: section['color'].withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Text('🔑', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
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

  Widget _buildStrangerDanger(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('⚠️', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['message'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...(section['rules'] as List).map<Widget>((rule) {
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
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(rule['emoji'], style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    rule['rule'],
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('💭', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['remember'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSafeWebsites(Map<String, dynamic> section) {
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
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✅ Safe Signals:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              ...(section['safeSignals'] as List).map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(item['signal'], style: GoogleFonts.nunito(fontSize: 14)),
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
                '❌ Danger Signs:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              ...(section['dangerSigns'] as List).map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(item['sign'], style: GoogleFonts.nunito(fontSize: 14)),
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

  Widget _buildCyberbullying(Map<String, dynamic> section) {
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
                section['intro'],
                style: GoogleFonts.nunito(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Text(
                'Cyberbullying includes:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...(section['whatItIs'] as List).map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.remove, size: 16, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(item, style: GoogleFonts.nunito(fontSize: 13)),
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
              Text(
                'What to do if it happens:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 12),
              ...(section['whatToDo'] as List).map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(item['action'], style: GoogleFonts.nunito(fontWeight: FontWeight.w600)),
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
              const Text('💝', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['golden'],
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

  Widget _buildScreenTime(Map<String, dynamic> section) {
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
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🌈 Balance with other activities:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: (section['balance'] as List).length,
                itemBuilder: (context, index) {
                  final item = section['balance'][index];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item['emoji'], style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 4),
                        Text(
                          item['activity'],
                          style: GoogleFonts.nunito(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: section['color'].withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '💡 Tips:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...(section['tips'] as List).map((tip) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, size: 18, color: Colors.teal),
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

  Widget _buildDigitalCitizen(Map<String, dynamic> section) {
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
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📜 My Digital Citizen Pledge:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
              const SizedBox(height: 12),
              ...(section['pledges'] as List).map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple.shade100),
                  ),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item['pledge'],
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Icon(Icons.check_circle, color: Colors.purple.shade400),
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
