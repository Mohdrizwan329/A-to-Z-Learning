import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class ThinkAboutThinkingDetailPage extends StatefulWidget {
  final int sectionIndex;

  const ThinkAboutThinkingDetailPage({super.key, required this.sectionIndex});

  @override
  State<ThinkAboutThinkingDetailPage> createState() =>
      _ThinkAboutThinkingDetailPageState();
}

class _ThinkAboutThinkingDetailPageState
    extends State<ThinkAboutThinkingDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  static final List<Map<String, dynamic>> thinkingConcepts = [
    {
      'title': 'How Do You Learn?',
      'emoji': '🧒',
      'question': 'What helps you learn best?',
      'options': [
        {'emoji': '👁️', 'text': 'Seeing pictures', 'type': 'Visual'},
        {'emoji': '👂', 'text': 'Listening', 'type': 'Auditory'},
        {'emoji': '✋', 'text': 'Doing things', 'type': 'Kinesthetic'},
      ],
      'tip':
          'Everyone learns differently! Knowing how you learn helps you study better.',
    },
    {
      'title': 'Before You Start',
      'emoji': '🎯',
      'question': 'What should you think about before starting a task?',
      'steps': [
        {'emoji': '🤔', 'text': 'What do I need to do?'},
        {'emoji': '📋', 'text': 'What do I already know?'},
        {'emoji': '🛠️', 'text': 'What tools do I need?'},
        {'emoji': '⏰', 'text': 'How long will it take?'},
      ],
      'tip': 'Planning before you start makes everything easier!',
    },
    {
      'title': 'While You Work',
      'emoji': '💭',
      'question': 'What should you ask yourself while working?',
      'steps': [
        {'emoji': '✅', 'text': 'Am I doing this right?'},
        {'emoji': '🆘', 'text': 'Do I need help?'},
        {'emoji': '🔄', 'text': 'Should I try a different way?'},
        {'emoji': '🎯', 'text': 'Am I staying focused?'},
      ],
      'tip': 'Checking your work while doing it helps you catch mistakes!',
    },
    {
      'title': 'After You Finish',
      'emoji': '🏁',
      'question': 'What should you think about after finishing?',
      'steps': [
        {'emoji': '🤔', 'text': 'Did I do my best?'},
        {'emoji': '📝', 'text': 'What did I learn?'},
        {'emoji': '💪', 'text': 'What was hard?'},
        {'emoji': '🌟', 'text': 'What can I do better next time?'},
      ],
      'tip': 'Reflecting helps you become a better learner!',
    },
    {
      'title': 'Problem Solving',
      'emoji': '🧩',
      'question': 'What to do when you\'re stuck?',
      'steps': [
        {'emoji': '😤', 'text': 'Take a deep breath'},
        {'emoji': '🔍', 'text': 'Read the problem again'},
        {'emoji': '✂️', 'text': 'Break it into smaller parts'},
        {'emoji': '🙋', 'text': 'Ask for help if needed'},
      ],
      'tip': 'Getting stuck is normal! Smart kids know how to get unstuck.',
    },
    {
      'title': 'Memory Tricks',
      'emoji': '🎪',
      'question': 'How can you remember things better?',
      'tricks': [
        {'emoji': '🎵', 'text': 'Make a song', 'example': 'ABC song'},
        {'emoji': '🖼️', 'text': 'Draw a picture', 'example': 'Mind maps'},
        {'emoji': '📖', 'text': 'Tell a story', 'example': 'Connect ideas'},
        {'emoji': '🔁', 'text': 'Repeat it', 'example': 'Practice daily'},
      ],
      'tip': 'Different tricks work for different things. Try them all!',
    },
  ];

  @override
  void initState() {
    super.initState();
    initGridAnimations(this, floatRange: 3.0);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final concept = thinkingConcepts[widget.sectionIndex];
    final gradient = AppColors.getGradientForIndex(widget.sectionIndex);

    return GradientScaffold(
      title: concept['title'],
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
                      concept['emoji'],
                      style: const TextStyle(fontSize: 70),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      concept['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      concept['question'],
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Content based on type
            if (concept.containsKey('options'))
              _buildOptionsCards(concept)
            else if (concept.containsKey('steps'))
              _buildStepsCards(concept)
            else if (concept.containsKey('tricks'))
              _buildTricksCards(concept),
            const SizedBox(height: 16),
            // Tip Card
            buildFloatingItem(
              index: 99,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.6),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        concept['tip'],
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsCards(Map<String, dynamic> concept) {
    return Column(
      children:
          (concept['options'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final option = entry.value;
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
                Text(option['emoji'], style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option['text'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        option['type'],
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.8),
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

  Widget _buildStepsCards(Map<String, dynamic> concept) {
    return Column(
      children:
          (concept['steps'] as List).asMap().entries.map<Widget>((entry) {
        final index = entry.key;
        final step = entry.value;
        final cardGradient =
            AppColors.getGradientForIndex(widget.sectionIndex + index + 1);
        return buildFloatingItem(
          index: index + 1,
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
                      '${index + 1}',
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
                  child: Text(
                    step['text'],
                    style: GoogleFonts.nunito(
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

  Widget _buildTricksCards(Map<String, dynamic> concept) {
    return Column(
      children:
          (concept['tricks'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final trick = entry.value;
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
                Text(trick['emoji'], style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trick['text'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Example: ${trick['example']}',
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.8),
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
}
