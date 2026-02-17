import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignThinkingPage extends StatefulWidget {
  const DesignThinkingPage({super.key});

  @override
  State<DesignThinkingPage> createState() => _DesignThinkingPageState();
}

class _DesignThinkingPageState extends State<DesignThinkingPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Design Thinking?',
      'emoji': '💡',
      'color': Color(0xFF9C27B0),
      'description':
          'Design Thinking is a special way to solve problems by thinking like a designer! It helps us create amazing things that people really need and love.',
      'keyPoints': [
        {'icon': '🎯', 'text': 'Understand the problem first'},
        {'icon': '💭', 'text': 'Think of many ideas'},
        {'icon': '🔨', 'text': 'Build something to try'},
        {'icon': '🔄', 'text': 'Test and make it better'},
      ],
    },
    {
      'title': 'Step 1: Empathize',
      'emoji': '❤️',
      'color': Color(0xFFE91E63),
      'description':
          'Empathize means to understand how others feel. We ask questions and listen to learn what people need!',
      'activities': [
        {
          'title': 'Ask Questions',
          'emoji': '❓',
          'example': 'What makes you happy? What is hard for you?'
        },
        {
          'title': 'Watch Carefully',
          'emoji': '👀',
          'example': 'See how people do things'
        },
        {
          'title': 'Listen Well',
          'emoji': '👂',
          'example': 'Hear what people say they need'
        },
        {
          'title': 'Feel Their Feelings',
          'emoji': '🤗',
          'example': 'Imagine being in their shoes'
        },
      ],
      'challenge':
          'Interview a family member about something that is hard for them to do!',
    },
    {
      'title': 'Step 2: Define',
      'emoji': '🎯',
      'color': Color(0xFFFF5722),
      'description':
          'Define the problem clearly! After listening, we decide exactly what problem we want to solve.',
      'problemStatements': [
        {
          'who': '👵 Grandma',
          'needs': 'needs a way to',
          'problem': 'remember to take medicine',
          'because': 'because she sometimes forgets'
        },
        {
          'who': '🐕 Dogs',
          'needs': 'need a way to',
          'problem': 'stay cool in summer',
          'because': 'because they have fur coats'
        },
        {
          'who': '📚 Students',
          'needs': 'need a way to',
          'problem': 'carry heavy books easily',
          'because': 'because backpacks hurt'
        },
      ],
      'formula': '"[Who] needs a way to [what] because [why]"',
    },
    {
      'title': 'Step 3: Ideate',
      'emoji': '💭',
      'color': Color(0xFF4CAF50),
      'description':
          'Ideate means to think of LOTS of ideas! No idea is too silly or too wild. The more ideas, the better!',
      'rules': [
        {'icon': '🚀', 'rule': 'Dream Big', 'tip': 'Wild ideas are welcome!'},
        {'icon': '📝', 'rule': 'Many Ideas', 'tip': 'Try for 10+ ideas'},
        {
          'icon': '🤝',
          'rule': 'Build on Others',
          'tip': 'Add to friends\' ideas'
        },
        {'icon': '⏳', 'rule': 'Go Fast', 'tip': 'Don\'t judge, just write'},
      ],
      'techniques': [
        {
          'name': 'Mind Map',
          'emoji': '🧠',
          'desc': 'Branch out ideas like a tree'
        },
        {
          'name': 'Brainstorm',
          'emoji': '🌧️',
          'desc': 'Let ideas rain down'
        },
        {
          'name': 'Sketch',
          'emoji': '✏️',
          'desc': 'Draw your ideas quickly'
        },
        {
          'name': 'What If?',
          'emoji': '❓',
          'desc': 'Ask "What if..." questions'
        },
      ],
    },
    {
      'title': 'Step 4: Prototype',
      'emoji': '🔨',
      'color': Color(0xFF2196F3),
      'description':
          'A prototype is a simple version of your idea that you can touch and try! It doesn\'t have to be perfect.',
      'materials': [
        {'item': 'Paper & Cardboard', 'emoji': '📦'},
        {'item': 'Tape & Glue', 'emoji': '📎'},
        {'item': 'Lego & Blocks', 'emoji': '🧱'},
        {'item': 'Clay & Play-Doh', 'emoji': '🎨'},
        {'item': 'Straws & Sticks', 'emoji': '🥢'},
        {'item': 'Recycled Items', 'emoji': '♻️'},
      ],
      'tips': [
        'Start small and simple',
        'Use what you have at home',
        'It\'s okay if it\'s not pretty',
        'Build fast, improve later',
      ],
    },
    {
      'title': 'Step 5: Test',
      'emoji': '🧪',
      'color': Color(0xFF00BCD4),
      'description':
          'Testing means trying your prototype with real people! Watch what works and what doesn\'t.',
      'testingSteps': [
        {
          'step': '1',
          'title': 'Show Your Prototype',
          'desc': 'Let someone try it',
          'emoji': '🎁'
        },
        {
          'step': '2',
          'title': 'Watch Quietly',
          'desc': 'See how they use it',
          'emoji': '👀'
        },
        {
          'step': '3',
          'title': 'Ask Questions',
          'desc': 'What worked? What didn\'t?',
          'emoji': '❓'
        },
        {
          'step': '4',
          'title': 'Take Notes',
          'desc': 'Write down feedback',
          'emoji': '📝'
        },
      ],
      'remember': 'Feedback helps us improve! Even "bad" feedback is good!',
    },
    {
      'title': 'The Design Cycle',
      'emoji': '🔄',
      'color': Color(0xFF673AB7),
      'description':
          'Design Thinking is a cycle! After testing, we go back and make things better. Repeat until it\'s great!',
      'cycleSteps': [
        {'step': 'Empathize', 'emoji': '❤️', 'color': Color(0xFFE91E63)},
        {'step': 'Define', 'emoji': '🎯', 'color': Color(0xFFFF5722)},
        {'step': 'Ideate', 'emoji': '💭', 'color': Color(0xFF4CAF50)},
        {'step': 'Prototype', 'emoji': '🔨', 'color': Color(0xFF2196F3)},
        {'step': 'Test', 'emoji': '🧪', 'color': Color(0xFF00BCD4)},
      ],
      'motto': '"Fail Fast, Learn Fast, Improve Fast!"',
    },
    {
      'title': 'Design Challenge!',
      'emoji': '🏆',
      'color': Color(0xFFFF9800),
      'challenges': [
        {
          'title': 'Pet Toy Designer',
          'emoji': '🐱',
          'problem': 'Design a toy that keeps pets entertained',
          'difficulty': 'Easy'
        },
        {
          'title': 'Lunch Box Inventor',
          'emoji': '🍱',
          'problem': 'Design a lunch box that keeps food fresh and organized',
          'difficulty': 'Medium'
        },
        {
          'title': 'Playground Creator',
          'emoji': '🛝',
          'problem': 'Design a playground that kids of all abilities can enjoy',
          'difficulty': 'Hard'
        },
        {
          'title': 'Future School',
          'emoji': '🏫',
          'problem': 'Design the school of the future',
          'difficulty': 'Super Hard'
        },
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
          'Design Thinking',
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildProgressDots(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: _buildSectionContent(section),
                ),
              ),
              _buildNavigationButtons(section),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildProgressDots() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(sections.length, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: currentSection == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: currentSection == index
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
    switch (currentSection) {
      case 0:
        return _buildIntroSection(section);
      case 1:
        return _buildEmpathizeSection(section);
      case 2:
        return _buildDefineSection(section);
      case 3:
        return _buildIdeateSection(section);
      case 4:
        return _buildPrototypeSection(section);
      case 5:
        return _buildTestSection(section);
      case 6:
        return _buildCycleSection(section);
      case 7:
        return _buildChallengeSection(section);
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildIntroSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(
          section['emoji'],
          style: TextStyle(fontSize: 80),
        ),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 18,
              color: Colors.white,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['keyPoints'].length, (index) {
          final point = section['keyPoints'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(point['icon'], style: TextStyle(fontSize: 32)),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    point['text'],
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: section['color'],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: section['color'],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEmpathizeSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['activities'].length, (index) {
          final activity = section['activities'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(activity['emoji'], style: TextStyle(fontSize: 28)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Text(
                        activity['example'],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text('🌟', style: TextStyle(fontSize: 32)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Challenge!',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      section['challenge'],
                      style: GoogleFonts.nunito(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefineSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['formula'],
            style: GoogleFonts.sourceCodePro(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: section['color'],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Examples:',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        ...List.generate(section['problemStatements'].length, (index) {
          final statement = section['problemStatements'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(statement['who'], style: TextStyle(fontSize: 40)),
                SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text: statement['needs'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' '),
                      TextSpan(
                        text: statement['problem'],
                        style: TextStyle(
                          color: section['color'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' '),
                      TextSpan(text: statement['because']),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildIdeateSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Rules for Ideation:',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: List.generate(section['rules'].length, (index) {
            final rule = section['rules'][index];
            return Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(rule['icon'], style: TextStyle(fontSize: 32)),
                  SizedBox(height: 8),
                  Text(
                    rule['rule'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: section['color'],
                    ),
                  ),
                  Text(
                    rule['tip'],
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: 24),
        Text(
          'Techniques:',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        ...List.generate(section['techniques'].length, (index) {
          final technique = section['techniques'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(technique['emoji'], style: TextStyle(fontSize: 28)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        technique['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Text(
                        technique['desc'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPrototypeSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Materials You Can Use:',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: List.generate(section['materials'].length, (index) {
            final material = section['materials'][index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(material['emoji'], style: TextStyle(fontSize: 32)),
                  SizedBox(height: 4),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      material['item'],
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: 24),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '💡 Tips for Prototyping:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                ),
              ),
              SizedBox(height: 12),
              ...List.generate(section['tips'].length, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: section['color'], size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          section['tips'][index],
                          style: GoogleFonts.nunito(fontSize: 14),
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

  Widget _buildTestSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['testingSteps'].length, (index) {
          final step = section['testingSteps'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: section['color'],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      step['step'],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['title'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Text(
                        step['desc'],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(step['emoji'], style: TextStyle(fontSize: 28)),
              ],
            ),
          );
        }),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text('💡', style: TextStyle(fontSize: 32)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['remember'],
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCycleSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24),
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              ...List.generate(section['cycleSteps'].length, (index) {
                final step = section['cycleSteps'][index];
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: step['color'],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(step['emoji'], style: TextStyle(fontSize: 24)),
                          SizedBox(width: 8),
                          Text(
                            step['step'],
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index < section['cycleSteps'].length - 1)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Icon(
                          Icons.arrow_downward,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                      ),
                  ],
                );
              }),
              SizedBox(height: 16),
              Icon(
                Icons.refresh,
                color: section['color'],
                size: 40,
              ),
              Text(
                'Repeat!',
                style: GoogleFonts.poppins(
                  color: section['color'],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['motto'],
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Try these design challenges!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['challenges'].length, (index) {
          final challenge = section['challenges'][index];
          final colors = [
            Color(0xFFE91E63),
            Color(0xFF4CAF50),
            Color(0xFF2196F3),
            Color(0xFF9C27B0),
          ];
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors[index], width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(challenge['emoji'], style: TextStyle(fontSize: 40)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge['title'],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors[index],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors[index].withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              challenge['difficulty'],
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: colors[index],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: colors[index]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          challenge['problem'],
                          style: GoogleFonts.nunito(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNavigationButtons(Map<String, dynamic> section) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          if (currentSection > 0)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    currentSection--;
                  });
                },
                icon: Icon(Icons.arrow_back),
                label: Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          if (currentSection > 0) SizedBox(width: 12),
          Expanded(
            flex: currentSection == 0 ? 1 : 1,
            child: ElevatedButton.icon(
              onPressed: () {
                if (currentSection < sections.length - 1) {
                  setState(() {
                    currentSection++;
                  });
                } else {
                  Get.back();
                }
              },
              icon: Icon(
                currentSection < sections.length - 1
                    ? Icons.arrow_forward
                    : Icons.check_circle,
              ),
              label: Text(
                currentSection < sections.length - 1 ? 'Next' : 'Done',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'] as Color,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
