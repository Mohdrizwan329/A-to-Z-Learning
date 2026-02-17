import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MentalHealthBasicsPage extends StatefulWidget {
  const MentalHealthBasicsPage({super.key});

  @override
  State<MentalHealthBasicsPage> createState() => _MentalHealthBasicsPageState();
}

class _MentalHealthBasicsPageState extends State<MentalHealthBasicsPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Mental Health?',
      'emoji': '🧠',
      'color': Color(0xFF7986CB),
      'content': [
        {'icon': '🧠', 'text': 'Mental health is about how we think, feel, and act'},
        {'icon': '😊', 'text': 'It\'s about feeling good inside, not just outside'},
        {'icon': '💭', 'text': 'It affects how we handle stress and make choices'},
        {'icon': '🤝', 'text': 'It helps us get along with others'},
        {'icon': '⭐', 'text': 'Everyone has mental health, just like physical health!'},
      ],
    },
    {
      'title': 'Understanding Feelings',
      'emoji': '😊',
      'color': Color(0xFFFFB74D),
      'feelings': [
        {'feeling': 'Happy', 'emoji': '😊', 'color': Colors.yellow, 'when': 'When something good happens'},
        {'feeling': 'Sad', 'emoji': '😢', 'color': Colors.blue, 'when': 'When we lose something or feel hurt'},
        {'feeling': 'Angry', 'emoji': '😠', 'color': Colors.red, 'when': 'When things are unfair'},
        {'feeling': 'Scared', 'emoji': '😨', 'color': Colors.purple, 'when': 'When we face something unknown'},
        {'feeling': 'Excited', 'emoji': '🤩', 'color': Colors.orange, 'when': 'When we look forward to something'},
        {'feeling': 'Calm', 'emoji': '😌', 'color': Colors.green, 'when': 'When we feel peaceful inside'},
      ],
    },
    {
      'title': 'All Feelings are OK',
      'emoji': '💚',
      'color': Color(0xFF66BB6A),
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
      'color': Color(0xFF42A5F5),
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
      'color': Color(0xFFEF5350),
      'strategies': [
        {'strategy': 'Take deep breaths', 'emoji': '🌬️', 'howTo': 'Breathe in... count to 5... breathe out'},
        {'strategy': 'Count to 10', 'emoji': '🔢', 'howTo': '1, 2, 3, 4, 5, 6, 7, 8, 9, 10...'},
        {'strategy': 'Walk away', 'emoji': '🚶', 'howTo': 'Take a break from the situation'},
        {'strategy': 'Squeeze a stress ball', 'emoji': '✊', 'howTo': 'Let the anger out safely'},
        {'strategy': 'Talk about it', 'emoji': '🗣️', 'howTo': 'Tell someone how you feel'},
        {'strategy': 'Exercise', 'emoji': '🏃', 'howTo': 'Run, jump, or dance it out'},
      ],
    },
    {
      'title': 'When Feeling Worried',
      'emoji': '😰',
      'color': Color(0xFFAB47BC),
      'calming': [
        {'method': '5-4-3-2-1 Game', 'emoji': '🖐️', 'steps': 'See 5 things, hear 4 things, touch 3 things, smell 2 things, taste 1 thing'},
        {'method': 'Belly Breathing', 'emoji': '🎈', 'steps': 'Put hand on tummy, breathe in like filling a balloon, slowly let it out'},
        {'method': 'Happy Place', 'emoji': '🏖️', 'steps': 'Close eyes and imagine your favorite safe place'},
        {'method': 'Positive Talk', 'emoji': '💪', 'steps': 'Say "I am brave, I can do this"'},
        {'method': 'Hug Yourself', 'emoji': '🤗', 'steps': 'Cross arms and give yourself a big hug'},
      ],
    },
    {
      'title': 'Be Kind to Yourself',
      'emoji': '💗',
      'color': Color(0xFFEC407A),
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
      'color': Color(0xFF26A69A),
      'habits': [
        {'habit': 'Sleep well every night', 'emoji': '😴', 'why': 'Rest helps your brain'},
        {'habit': 'Play and have fun', 'emoji': '🎮', 'why': 'Fun makes you happy'},
        {'habit': 'Spend time with family', 'emoji': '👨‍👩‍👧', 'why': 'Love keeps you strong'},
        {'habit': 'Be active every day', 'emoji': '🏃', 'why': 'Exercise helps mood'},
        {'habit': 'Eat healthy foods', 'emoji': '🥗', 'why': 'Good food = good mood'},
        {'habit': 'Limit screen time', 'emoji': '📱', 'why': 'Balance is important'},
        {'habit': 'Practice gratitude', 'emoji': '🙏', 'why': 'Thankfulness brings joy'},
        {'habit': 'Be kind to others', 'emoji': '💕', 'why': 'Kindness makes everyone happy'},
      ],
    },
    {
      'title': 'When to Ask for Help',
      'emoji': '🆘',
      'color': Color(0xFFFF7043),
      'signs': [
        {'sign': 'Feeling sad for many days', 'emoji': '😢'},
        {'sign': 'Not wanting to play or eat', 'emoji': '🍽️'},
        {'sign': 'Trouble sleeping', 'emoji': '🛏️'},
        {'sign': 'Feeling scared all the time', 'emoji': '😰'},
        {'sign': 'Getting angry very often', 'emoji': '😠'},
        {'sign': 'Not wanting to go to school', 'emoji': '🏫'},
      ],
      'helpText': 'If you feel this way, talk to a trusted adult. They can help!',
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
          'Mental Health',
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
        if (section.containsKey('feelings')) _buildFeelingCards(section),
        if (section.containsKey('messages')) _buildMessageCards(section),
        if (section.containsKey('tips')) _buildTipCards(section),
        if (section.containsKey('strategies')) _buildStrategyCards(section),
        if (section.containsKey('calming')) _buildCalmingCards(section),
        if (section.containsKey('kindness')) _buildKindnessCards(section),
        if (section.containsKey('habits')) _buildHabitCards(section),
        if (section.containsKey('signs')) _buildSignCards(section),
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

  Widget _buildFeelingCards(Map<String, dynamic> section) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: (section['feelings'] as List).length,
      itemBuilder: (context, index) {
        final feeling = section['feelings'][index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (feeling['color'] as Color).withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(feeling['emoji'], style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 6),
              Text(
                feeling['feeling'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: feeling['color'],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                feeling['when'],
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageCards(Map<String, dynamic> section) {
    return Column(
      children: (section['messages'] as List).map<Widget>((message) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(message['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  message['text'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
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

  Widget _buildTipCards(Map<String, dynamic> section) {
    return Column(
      children: (section['tips'] as List).map<Widget>((tip) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(tip['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  tip['tip'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStrategyCards(Map<String, dynamic> section) {
    return Column(
      children: (section['strategies'] as List).map<Widget>((strategy) {
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(strategy['emoji'], style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strategy['strategy'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      strategy['howTo'],
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

  Widget _buildCalmingCards(Map<String, dynamic> section) {
    return Column(
      children: (section['calming'] as List).map<Widget>((calm) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(calm['emoji'], style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Text(
                    calm['method'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: section['color'],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  calm['steps'],
                  style: GoogleFonts.nunito(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKindnessCards(Map<String, dynamic> section) {
    return Column(
      children: (section['kindness'] as List).map<Widget>((kind) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
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
              Text(kind['emoji'], style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  kind['text'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
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

  Widget _buildHabitCards(Map<String, dynamic> section) {
    return Column(
      children: (section['habits'] as List).map<Widget>((habit) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(habit['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit['habit'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      habit['why'],
                      style: GoogleFonts.nunito(
                        color: section['color'],
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

  Widget _buildSignCards(Map<String, dynamic> section) {
    return Column(
      children: [
        ...(section['signs'] as List).map<Widget>((sign) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(sign['emoji'], style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    sign['sign'],
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        if (section.containsKey('helpText'))
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: Row(
              children: [
                const Text('💚', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section['helpText'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
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
