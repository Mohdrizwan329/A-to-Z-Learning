import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class LearningStrategyDetailPage extends StatefulWidget {
  final int sectionIndex;

  const LearningStrategyDetailPage({super.key, required this.sectionIndex});

  @override
  State<LearningStrategyDetailPage> createState() =>
      _LearningStrategyDetailPageState();
}

class _LearningStrategyDetailPageState extends State<LearningStrategyDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  static final List<Map<String, dynamic>> strategies = [
    {
      'name': 'Chunking',
      'emoji': '🧩',
      'tagline': 'Break it into pieces!',
      'description': 'Break big things into small pieces to learn easier.',
      'example': 'Instead of learning 123456789, learn 123-456-789',
      'steps': [
        'Look at the big thing you need to learn',
        'Break it into 3-4 smaller parts',
        'Learn one part at a time',
        'Put it all together!',
      ],
      'bestFor': ['Phone numbers', 'Long words', 'Big problems'],
    },
    {
      'name': 'Visualization',
      'emoji': '🎨',
      'tagline': 'See it in your mind!',
      'description': 'Create pictures in your mind to remember things.',
      'example': 'To remember "CAT", picture a cat in your mind',
      'steps': [
        'Close your eyes',
        'Create a picture in your mind',
        'Add colors and details',
        'Open eyes and recall the picture',
      ],
      'bestFor': ['New words', 'Stories', 'Places'],
    },
    {
      'name': 'Repetition',
      'emoji': '🔄',
      'tagline': 'Practice makes perfect!',
      'description': 'Repeat things many times to remember them forever.',
      'example': 'Say "2+2=4" many times until you never forget',
      'steps': [
        'Learn something new',
        'Say it out loud 5 times',
        'Write it 3 times',
        'Review it tomorrow',
      ],
      'bestFor': ['Math facts', 'Spelling', 'Alphabet'],
    },
    {
      'name': 'Association',
      'emoji': '🔗',
      'tagline': 'Connect new to old!',
      'description': 'Link new things to things you already know.',
      'example': 'The word "EIGHT" looks like it has 8 letters!',
      'steps': [
        'Think of something you know well',
        'Find something similar in the new thing',
        'Create a connection between them',
        'Use this link to remember',
      ],
      'bestFor': ['New vocabulary', 'Names', 'Facts'],
    },
    {
      'name': 'Rhyme & Song',
      'emoji': '🎵',
      'tagline': 'Sing it to remember!',
      'description': 'Turn information into songs or rhymes.',
      'example': 'Twinkle Twinkle ABC song helps learn alphabet!',
      'steps': [
        'Take what you need to learn',
        'Make it rhyme or add a tune',
        'Sing it several times',
        'The melody helps you remember!',
      ],
      'bestFor': ['ABCs', 'Days of week', 'Months'],
    },
    {
      'name': 'Storytelling',
      'emoji': '📚',
      'tagline': 'Make it a story!',
      'description': 'Create a story to connect ideas together.',
      'example':
          'To remember APPLE, BANANA, CAT: "An Apple fell on a Banana which scared a Cat"',
      'steps': [
        'List the things you need to remember',
        'Create characters from them',
        'Make up a fun story',
        'Tell the story to remember!',
      ],
      'bestFor': ['Lists', 'Sequences', 'Vocabulary'],
    },
    {
      'name': 'Drawing',
      'emoji': '✏️',
      'tagline': 'Draw to learn!',
      'description': 'Draw pictures to understand and remember.',
      'example': 'Draw a picture of a story to remember it',
      'steps': [
        'Read or hear the information',
        'Get paper and colors',
        'Draw what you learned',
        'Look at your drawing to recall',
      ],
      'bestFor': ['Stories', 'Science concepts', 'History'],
    },
    {
      'name': 'Teach Someone',
      'emoji': '👨‍🏫',
      'tagline': 'Be the teacher!',
      'description': 'Teach what you learn to someone else.',
      'example': 'Teach your teddy bear the ABCs!',
      'steps': [
        'Learn something new',
        'Pretend you are the teacher',
        'Explain it to a friend, pet, or toy',
        'Teaching helps you understand better!',
      ],
      'bestFor': ['Everything!', 'Math', 'Reading'],
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
    final strategy = strategies[widget.sectionIndex];
    final gradient = AppColors.getGradientForIndex(widget.sectionIndex);

    return GradientScaffold(
      title: strategy['name'],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // Main Card
            buildFloatingItem(
              index: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withValues(alpha: 0.4),
                      blurRadius: 12.r,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      strategy['emoji'],
                      style: const TextStyle(fontSize: 70),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      strategy['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      strategy['tagline'],
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      strategy['description'],
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Example Card
            buildFloatingItem(
              index: 1,
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.6),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 28)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Example:',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                          Text(
                            strategy['example'],
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Steps Cards
            ..._buildStepsCards(strategy),
            SizedBox(height: 16.h),
            // Best For Card
            buildFloatingItem(
              index: (strategy['steps'] as List).length + 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.getGradientForIndex(
                      widget.sectionIndex + 5,
                    ),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withValues(alpha: 0.3),
                      blurRadius: 6.r,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('⭐', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 8.w),
                        Text(
                          'Best For:',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 8.r,
                      runSpacing: 8.r,
                      children: (strategy['bestFor'] as List).map<Widget>((
                        item,
                      ) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            item,
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStepsCards(Map<String, dynamic> strategy) {
    final steps = strategy['steps'] as List;
    return steps.asMap().entries.map<Widget>((entry) {
      final index = entry.key;
      final step = entry.value;
      final cardGradient = AppColors.getGradientForIndex(
        widget.sectionIndex + index + 1,
      );
      return buildFloatingItem(
        index: index + 2,
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: cardGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: cardGradient[0].withValues(alpha: 0.3),
                blurRadius: 6.r,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
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
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  step,
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
    }).toList();
  }
}
