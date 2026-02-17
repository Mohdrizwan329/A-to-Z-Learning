import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskSequencingPage extends StatefulWidget {
  const TaskSequencingPage({super.key});

  @override
  State<TaskSequencingPage> createState() => _TaskSequencingPageState();
}

class _TaskSequencingPageState extends State<TaskSequencingPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Sequencing?',
      'emoji': '🔢',
      'color': Color(0xFF7E57C2),
      'content': [
        {'icon': '1️⃣', 'text': 'Sequencing means putting things in the right order'},
        {'icon': '2️⃣', 'text': 'First, Then, Next, Last - that\'s a sequence!'},
        {'icon': '3️⃣', 'text': 'It helps us do tasks step by step'},
        {'icon': '⭐', 'text': 'Everything has a sequence - even stories!'},
      ],
    },
    {
      'title': 'Making a Sandwich',
      'emoji': '🥪',
      'color': Color(0xFFFF7043),
      'sequence': [
        {'order': 'First', 'action': 'Get bread, butter, and filling', 'emoji': '🍞'},
        {'order': 'Then', 'action': 'Put two slices of bread on plate', 'emoji': '🍽️'},
        {'order': 'Next', 'action': 'Spread butter on bread', 'emoji': '🧈'},
        {'order': 'After that', 'action': 'Add the filling you like', 'emoji': '🧀'},
        {'order': 'Finally', 'action': 'Put the other bread on top', 'emoji': '🥪'},
      ],
    },
    {
      'title': 'Planting a Seed',
      'emoji': '🌱',
      'color': Color(0xFF66BB6A),
      'sequence': [
        {'order': 'First', 'action': 'Get a pot and soil', 'emoji': '🪴'},
        {'order': 'Then', 'action': 'Fill the pot with soil', 'emoji': '🏺'},
        {'order': 'Next', 'action': 'Make a small hole', 'emoji': '🕳️'},
        {'order': 'After that', 'action': 'Put the seed in the hole', 'emoji': '🌰'},
        {'order': 'Then', 'action': 'Cover with soil', 'emoji': '🪴'},
        {'order': 'Finally', 'action': 'Water the plant', 'emoji': '💧'},
      ],
    },
    {
      'title': 'Story Sequence',
      'emoji': '📖',
      'color': Color(0xFF42A5F5),
      'story': [
        {'part': 'Beginning', 'emoji': '🌅', 'what': 'Who? Where? When?', 'example': 'Once upon a time, a little girl lived in a village...'},
        {'part': 'Middle', 'emoji': '🎭', 'what': 'What happened?', 'example': 'One day, she found a magic lamp...'},
        {'part': 'Problem', 'emoji': '😰', 'what': 'What went wrong?', 'example': 'But a giant came and took it away...'},
        {'part': 'Solution', 'emoji': '💡', 'what': 'How was it fixed?', 'example': 'She was brave and tricked the giant...'},
        {'part': 'End', 'emoji': '🌈', 'what': 'How did it finish?', 'example': 'And she lived happily ever after!'},
      ],
    },
    {
      'title': 'Daily Routines',
      'emoji': '📅',
      'color': Color(0xFFFFB74D),
      'routines': [
        {
          'name': 'Getting Ready for Bed',
          'steps': ['Finish dinner', 'Brush teeth', 'Put on pajamas', 'Read a story', 'Say goodnight', 'Sleep'],
        },
        {
          'name': 'Going to School',
          'steps': ['Wake up', 'Get ready', 'Eat breakfast', 'Take bag', 'Leave home', 'Reach school'],
        },
      ],
    },
    {
      'title': 'Sequence Words',
      'emoji': '📝',
      'color': Color(0xFFEC407A),
      'words': [
        {'word': 'First', 'meaning': 'The very beginning', 'emoji': '1️⃣'},
        {'word': 'Then', 'meaning': 'After that', 'emoji': '2️⃣'},
        {'word': 'Next', 'meaning': 'What comes after', 'emoji': '3️⃣'},
        {'word': 'After that', 'meaning': 'Following the last step', 'emoji': '4️⃣'},
        {'word': 'Finally', 'meaning': 'The very last thing', 'emoji': '5️⃣'},
        {'word': 'Last', 'meaning': 'At the end', 'emoji': '🔚'},
      ],
    },
    {
      'title': 'Practice Time!',
      'emoji': '🎯',
      'color': Color(0xFF26A69A),
      'challenges': [
        {'challenge': 'Put these in order: eat → cook → buy groceries', 'emoji': '🛒'},
        {'challenge': 'What comes first: dress → shower → dry?', 'emoji': '🚿'},
        {'challenge': 'Order the day: lunch → breakfast → dinner', 'emoji': '🍽️'},
        {'challenge': 'Arrange: teenager → baby → adult → child', 'emoji': '👶'},
        {'challenge': 'Sequence: caterpillar → egg → butterfly → cocoon', 'emoji': '🦋'},
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
          'Task Sequencing',
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
        if (section.containsKey('sequence')) _buildSequenceCards(section),
        if (section.containsKey('story')) _buildStoryCards(section),
        if (section.containsKey('routines')) _buildRoutineCards(section),
        if (section.containsKey('words')) _buildWordCards(section),
        if (section.containsKey('challenges')) _buildChallengeCards(section),
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

  Widget _buildSequenceCards(Map<String, dynamic> section) {
    return Column(
      children: (section['sequence'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final step = entry.value;
        final isLast = idx == (section['sequence'] as List).length - 1;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: section['color'],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      step['order'],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(step['emoji'], style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step['action'],
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!isLast)
              Container(
                height: 20,
                child: Icon(Icons.arrow_downward, color: Colors.white, size: 20),
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStoryCards(Map<String, dynamic> section) {
    return Column(
      children: (section['story'] as List).map<Widget>((part) {
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
                  Text(part['emoji'], style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 10),
                  Text(
                    part['part'],
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
                part['what'],
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  part['example'],
                  style: GoogleFonts.nunito(
                    fontStyle: FontStyle.italic,
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

  Widget _buildRoutineCards(Map<String, dynamic> section) {
    return Column(
      children: (section['routines'] as List).map<Widget>((routine) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                routine['name'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (routine['steps'] as List).asMap().entries.map<Widget>((entry) {
                  final idx = entry.key;
                  final step = entry.value;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: section['color'].withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${idx + 1}. $step',
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                            color: section['color'],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (idx < (routine['steps'] as List).length - 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.arrow_forward, size: 16),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWordCards(Map<String, dynamic> section) {
    return Column(
      children: (section['words'] as List).map<Widget>((word) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(word['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word['word'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      word['meaning'],
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

  Widget _buildChallengeCards(Map<String, dynamic> section) {
    return Column(
      children: (section['challenges'] as List).asMap().entries.map<Widget>((entry) {
        final challenge = entry.value;
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(challenge['emoji'], style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  challenge['challenge'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(Icons.lightbulb_outline, color: section['color']),
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
