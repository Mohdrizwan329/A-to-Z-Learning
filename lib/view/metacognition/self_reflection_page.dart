import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SelfReflectionPage extends StatefulWidget {
  const SelfReflectionPage({super.key});

  @override
  State<SelfReflectionPage> createState() => _SelfReflectionPageState();
}

class _SelfReflectionPageState extends State<SelfReflectionPage> {
  int currentSection = 0;
  Map<String, int> answers = {};

  final List<Map<String, dynamic>> reflectionSections = [
    {
      'title': 'How Am I Feeling Today?',
      'emoji': '😊',
      'color': Color(0xFFFF6B6B),
      'type': 'mood',
      'options': [
        {'emoji': '😄', 'text': 'Super Happy', 'color': Color(0xFF4CAF50)},
        {'emoji': '🙂', 'text': 'Good', 'color': Color(0xFF8BC34A)},
        {'emoji': '😐', 'text': 'Okay', 'color': Color(0xFFFFC107)},
        {'emoji': '😔', 'text': 'A Little Sad', 'color': Color(0xFFFF9800)},
        {'emoji': '😢', 'text': 'Not Good', 'color': Color(0xFFF44336)},
      ],
    },
    {
      'title': 'What Did I Do Well Today?',
      'emoji': '⭐',
      'color': Color(0xFF4ECDC4),
      'type': 'achievements',
      'options': [
        {'emoji': '📚', 'text': 'I studied hard'},
        {'emoji': '🤝', 'text': 'I helped someone'},
        {'emoji': '🎯', 'text': 'I finished my work'},
        {'emoji': '😊', 'text': 'I was kind'},
        {'emoji': '🧹', 'text': 'I cleaned up'},
      ],
    },
    {
      'title': 'What Can I Do Better?',
      'emoji': '🌱',
      'color': Color(0xFF45B7D1),
      'type': 'improvement',
      'options': [
        {'emoji': '👂', 'text': 'Listen more carefully'},
        {'emoji': '⏰', 'text': 'Be on time'},
        {'emoji': '📖', 'text': 'Read more'},
        {'emoji': '🤫', 'text': 'Be more patient'},
        {'emoji': '💪', 'text': 'Try harder'},
      ],
    },
    {
      'title': 'What Makes Me Special?',
      'emoji': '🌟',
      'color': Color(0xFF9B59B6),
      'type': 'strengths',
      'options': [
        {'emoji': '🎨', 'text': 'I am creative'},
        {'emoji': '❤️', 'text': 'I am kind'},
        {'emoji': '🧠', 'text': 'I am smart'},
        {'emoji': '💪', 'text': 'I am brave'},
        {'emoji': '😄', 'text': 'I am funny'},
      ],
    },
    {
      'title': 'What Am I Grateful For?',
      'emoji': '🙏',
      'color': Color(0xFFF39C12),
      'type': 'gratitude',
      'options': [
        {'emoji': '👨‍👩‍👧', 'text': 'My family'},
        {'emoji': '👫', 'text': 'My friends'},
        {'emoji': '🏠', 'text': 'My home'},
        {'emoji': '🍎', 'text': 'Good food'},
        {'emoji': '📚', 'text': 'Learning new things'},
      ],
    },
    {
      'title': 'My Goal for Tomorrow',
      'emoji': '🎯',
      'color': Color(0xFF1ABC9C),
      'type': 'goals',
      'options': [
        {'emoji': '📖', 'text': 'Learn something new'},
        {'emoji': '🤝', 'text': 'Make a new friend'},
        {'emoji': '💪', 'text': 'Do my best'},
        {'emoji': '😊', 'text': 'Be happy'},
        {'emoji': '🌟', 'text': 'Be helpful'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final section = reflectionSections[currentSection];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Self Reflection',
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
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildReflectionCard(section),
                ),
              ),
              _buildNavigationButtons(section),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentSection + 1} of ${reflectionSections.length}',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${((currentSection + 1) / reflectionSections.length * 100).toInt()}%',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (currentSection + 1) / reflectionSections.length,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionCard(Map<String, dynamic> section) {
    return Column(
      children: [
        // Question Card
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
              Text(
                section['emoji'],
                style: const TextStyle(fontSize: 60),
              ),
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
        const SizedBox(height: 24),
        // Options
        ...List.generate((section['options'] as List).length, (index) {
          final option = section['options'][index];
          final isSelected = answers[section['type']] == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                answers[section['type']] = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? section['color'].withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? section['color'] : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: option['color'] ?? section['color'].withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        option['emoji'],
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      option['text'],
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? section['color'] : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: section['color'],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNavigationButtons(Map<String, dynamic> section) {
    final hasAnswer = answers.containsKey(section['type']);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentSection > 0)
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  currentSection--;
                });
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            const SizedBox(width: 100),
          if (currentSection < reflectionSections.length - 1)
            ElevatedButton.icon(
              onPressed: hasAnswer
                  ? () {
                      setState(() {
                        currentSection++;
                      });
                    }
                  : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'],
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: hasAnswer ? () => _showSummary() : null,
              icon: const Icon(Icons.check),
              label: const Text('Finish'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.green.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSummary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('🌟', style: TextStyle(fontSize: 50)),
                  const SizedBox(height: 12),
                  Text(
                    'Great Job Reflecting!',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Self-reflection helps you grow every day!',
                    style: GoogleFonts.nunito(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: reflectionSections.length,
                itemBuilder: (context, index) {
                  final section = reflectionSections[index];
                  final answerIndex = answers[section['type']];
                  final answer = answerIndex != null
                      ? section['options'][answerIndex]
                      : null;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: section['color'].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: section['color'].withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          answer?['emoji'] ?? '❓',
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section['title'],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                answer?['text'] ?? 'Not answered',
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  color: section['color'],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Done! 🎉',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
