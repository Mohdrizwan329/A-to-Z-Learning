import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EngineeringKidsPage extends StatefulWidget {
  const EngineeringKidsPage({super.key});

  @override
  State<EngineeringKidsPage> createState() => _EngineeringKidsPageState();
}

class _EngineeringKidsPageState extends State<EngineeringKidsPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Engineering?',
      'emoji': '⚙️',
      'color': Color(0xFFFF7043),
      'content': [
        {'icon': '🔧', 'text': 'Engineering is about solving problems by building things'},
        {'icon': '🏗️', 'text': 'Engineers design buildings, bridges, cars, and more!'},
        {'icon': '💡', 'text': 'They use science and math to create solutions'},
        {'icon': '🎨', 'text': 'Engineering combines creativity with knowledge'},
        {'icon': '⭐', 'text': 'You can be an engineer too!'},
      ],
    },
    {
      'title': 'Types of Engineers',
      'emoji': '👷',
      'color': Color(0xFF42A5F5),
      'types': [
        {'type': 'Civil Engineer', 'emoji': '🏗️', 'builds': 'Roads, bridges, buildings'},
        {'type': 'Mechanical Engineer', 'emoji': '⚙️', 'builds': 'Machines, cars, robots'},
        {'type': 'Electrical Engineer', 'emoji': '⚡', 'builds': 'Circuits, lights, electronics'},
        {'type': 'Computer Engineer', 'emoji': '💻', 'builds': 'Computers, apps, software'},
        {'type': 'Aerospace Engineer', 'emoji': '🚀', 'builds': 'Airplanes, rockets, spacecraft'},
        {'type': 'Environmental Engineer', 'emoji': '🌱', 'builds': 'Clean water, recycling systems'},
      ],
    },
    {
      'title': 'Design Process',
      'emoji': '📋',
      'color': Color(0xFF66BB6A),
      'steps': [
        {'step': 1, 'name': 'Ask', 'detail': 'What is the problem?', 'emoji': '❓'},
        {'step': 2, 'name': 'Imagine', 'detail': 'Think of many solutions', 'emoji': '💭'},
        {'step': 3, 'name': 'Plan', 'detail': 'Draw your design', 'emoji': '📝'},
        {'step': 4, 'name': 'Create', 'detail': 'Build your design', 'emoji': '🔧'},
        {'step': 5, 'name': 'Test', 'detail': 'Does it work?', 'emoji': '🧪'},
        {'step': 6, 'name': 'Improve', 'detail': 'Make it better!', 'emoji': '⬆️'},
      ],
    },
    {
      'title': 'Build a Bridge',
      'emoji': '🌉',
      'color': Color(0xFF9C27B0),
      'challenge': {
        'goal': 'Build a bridge that can hold weight',
        'materials': ['Paper', 'Tape', 'Scissors', 'Books (for testing)'],
        'tips': [
          'Fold paper to make it stronger',
          'Use triangles - they\'re strong shapes!',
          'Test with small weights first',
          'If it breaks, redesign and try again',
        ],
      },
    },
    {
      'title': 'Build a Tower',
      'emoji': '🗼',
      'color': Color(0xFFFFB74D),
      'challenge': {
        'goal': 'Build the tallest tower that stands on its own',
        'materials': ['Spaghetti or straws', 'Marshmallows or clay', 'Tape'],
        'tips': [
          'Wide base = stable tower',
          'Use cross supports for strength',
          'Balance is important',
          'Don\'t make it too top-heavy',
        ],
      },
    },
    {
      'title': 'Build a Car',
      'emoji': '🚗',
      'color': Color(0xFF00BCD4),
      'challenge': {
        'goal': 'Build a car that rolls far',
        'materials': ['Cardboard box', 'Bottle caps (wheels)', 'Straws (axles)', 'Tape'],
        'tips': [
          'Wheels need to spin freely',
          'Make the car light',
          'Smooth wheels roll better',
          'Test on a ramp!',
        ],
      },
    },
    {
      'title': 'Engineering Skills',
      'emoji': '🧠',
      'color': Color(0xFF26A69A),
      'skills': [
        {'skill': 'Problem Solving', 'emoji': '🧩', 'how': 'Find creative solutions'},
        {'skill': 'Building', 'emoji': '🔨', 'how': 'Make things with your hands'},
        {'skill': 'Testing', 'emoji': '🧪', 'how': 'See if your idea works'},
        {'skill': 'Improving', 'emoji': '📈', 'how': 'Make things better'},
        {'skill': 'Teamwork', 'emoji': '🤝', 'how': 'Work together with others'},
        {'skill': 'Persistence', 'emoji': '💪', 'how': 'Never give up!'},
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
          'Engineering for Kids',
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
        if (section.containsKey('types')) _buildTypeCards(section),
        if (section.containsKey('steps')) _buildStepCards(section),
        if (section.containsKey('challenge')) _buildChallengeCard(section),
        if (section.containsKey('skills')) _buildSkillCards(section),
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

  Widget _buildTypeCards(Map<String, dynamic> section) {
    return Column(
      children: (section['types'] as List).map<Widget>((type) {
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
                  child: Text(type['emoji'], style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type['type'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Builds: ${type['builds']}',
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
                      step['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      step['detail'],
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                        fontSize: 13,
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

  Widget _buildChallengeCard(Map<String, dynamic> section) {
    final challenge = section['challenge'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎯', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Text(
                'Challenge',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            challenge['goal'],
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '🧪 Materials:',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: section['color'],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (challenge['materials'] as List).map<Widget>((m) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  m,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: section['color'],
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            '💡 Tips:',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: section['color'],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...(challenge['tips'] as List).map<Widget>((tip) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check, color: section['color'], size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
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
        ],
      ),
    );
  }

  Widget _buildSkillCards(Map<String, dynamic> section) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: (section['skills'] as List).length,
      itemBuilder: (context, index) {
        final skill = section['skills'][index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(skill['emoji'], style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text(
                skill['skill'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                skill['how'],
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
