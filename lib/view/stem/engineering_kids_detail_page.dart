import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class EngineeringKidsDetailPage extends StatefulWidget {
  final int sectionIndex;

  const EngineeringKidsDetailPage({super.key, required this.sectionIndex});

  @override
  State<EngineeringKidsDetailPage> createState() =>
      _EngineeringKidsDetailPageState();
}

class _EngineeringKidsDetailPageState extends State<EngineeringKidsDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  static final List<Map<String, dynamic>> _sections = [
    {
      'title': 'What is Engineering?',
      'emoji': '⚙️',
      'content': [
        {
          'icon': '🔧',
          'text': 'Engineering is about solving problems by building things',
        },
        {
          'icon': '🏗️',
          'text': 'Engineers design buildings, bridges, cars, and more!',
        },
        {
          'icon': '💡',
          'text': 'They use science and math to create solutions',
        },
        {
          'icon': '🎨',
          'text': 'Engineering combines creativity with knowledge',
        },
        {'icon': '⭐', 'text': 'You can be an engineer too!'},
      ],
    },
    {
      'title': 'Types of Engineers',
      'emoji': '👷',
      'types': [
        {
          'type': 'Civil Engineer',
          'emoji': '🏗️',
          'builds': 'Roads, bridges, buildings',
        },
        {
          'type': 'Mechanical Engineer',
          'emoji': '⚙️',
          'builds': 'Machines, cars, robots',
        },
        {
          'type': 'Electrical Engineer',
          'emoji': '⚡',
          'builds': 'Circuits, lights, electronics',
        },
        {
          'type': 'Computer Engineer',
          'emoji': '💻',
          'builds': 'Computers, apps, software',
        },
        {
          'type': 'Aerospace Engineer',
          'emoji': '🚀',
          'builds': 'Airplanes, rockets, spacecraft',
        },
        {
          'type': 'Environmental Engineer',
          'emoji': '🌱',
          'builds': 'Clean water, recycling systems',
        },
      ],
    },
    {
      'title': 'Design Process',
      'emoji': '📋',
      'steps': [
        {
          'step': 1,
          'name': 'Ask',
          'detail': 'What is the problem?',
          'emoji': '❓',
        },
        {
          'step': 2,
          'name': 'Imagine',
          'detail': 'Think of many solutions',
          'emoji': '💭',
        },
        {
          'step': 3,
          'name': 'Plan',
          'detail': 'Draw your design',
          'emoji': '📝',
        },
        {
          'step': 4,
          'name': 'Create',
          'detail': 'Build your design',
          'emoji': '🔧',
        },
        {
          'step': 5,
          'name': 'Test',
          'detail': 'Does it work?',
          'emoji': '🧪',
        },
        {
          'step': 6,
          'name': 'Improve',
          'detail': 'Make it better!',
          'emoji': '⬆️',
        },
      ],
    },
    {
      'title': 'Build a Bridge',
      'emoji': '🌉',
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
      'challenge': {
        'goal': 'Build the tallest tower that stands on its own',
        'materials': [
          'Spaghetti or straws',
          'Marshmallows or clay',
          'Tape',
        ],
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
      'challenge': {
        'goal': 'Build a car that rolls far',
        'materials': [
          'Cardboard box',
          'Bottle caps (wheels)',
          'Straws (axles)',
          'Tape',
        ],
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
      'skills': [
        {
          'skill': 'Problem Solving',
          'emoji': '🧩',
          'how': 'Find creative solutions',
        },
        {
          'skill': 'Building',
          'emoji': '🔨',
          'how': 'Make things with your hands',
        },
        {
          'skill': 'Testing',
          'emoji': '🧪',
          'how': 'See if your idea works',
        },
        {
          'skill': 'Improving',
          'emoji': '📈',
          'how': 'Make things better',
        },
        {
          'skill': 'Teamwork',
          'emoji': '🤝',
          'how': 'Work together with others',
        },
        {
          'skill': 'Persistence',
          'emoji': '💪',
          'how': 'Never give up!',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    initGridAnimations(this, floatRange: 3.0, pulseMax: 1.0);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final section = _sections[widget.sectionIndex];

    return GradientScaffold(
      title: section['title'] ?? '',
      emoji: section['emoji'] ?? '',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildSectionContent(section),
      ),
    );
  }

  Widget _buildSectionContent(Map<String, dynamic> section) {
    switch (widget.sectionIndex) {
      case 0:
        return _buildContentSection(section);
      case 1:
        return _buildTypesSection(section);
      case 2:
        return _buildStepsSection(section);
      case 3:
      case 4:
      case 5:
        return _buildChallengeSection(section);
      case 6:
        return _buildSkillsSection(section);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildGradientItem({required int index, required Widget child}) {
    final gradient = AppColors.getGradientForIndex(index);
    return buildFloatingItem(
      index: index,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(Map<String, dynamic> section) {
    final content =
        section['content'] as List<Map<String, dynamic>>? ?? [];
    return Column(
      children: [
        Text(section['emoji'] ?? '', style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(
          section['title'] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ...List.generate(content.length, (index) {
          final item = content[index];
          return _buildGradientItem(
            index: index,
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      item['icon'] ?? '',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item['text'] ?? '',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  Widget _buildTypesSection(Map<String, dynamic> section) {
    final types =
        section['types'] as List<Map<String, dynamic>>? ?? [];
    return Column(
      children: [
        Text(section['emoji'] ?? '', style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(
          section['title'] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ...List.generate(types.length, (index) {
          final type = types[index];
          return _buildGradientItem(
            index: index,
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      type['emoji'] ?? '',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type['type'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.build,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              type['builds'] ?? '',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildStepsSection(Map<String, dynamic> section) {
    final steps =
        section['steps'] as List<Map<String, dynamic>>? ?? [];
    return Column(
      children: [
        Text(section['emoji'] ?? '', style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(
          section['title'] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ...List.generate(steps.length, (index) {
          final step = steps[index];
          return _buildGradientItem(
            index: index,
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${step['step'] ?? ''}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  step['emoji'] ?? '',
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['name'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        step['detail'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
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

  Widget _buildChallengeSection(Map<String, dynamic> section) {
    final challenge =
        section['challenge'] as Map<String, dynamic>? ?? {};
    final materials = challenge['materials'] as List? ?? [];
    final tips = challenge['tips'] as List? ?? [];

    return Column(
      children: [
        Text(section['emoji'] ?? '', style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(
          section['title'] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        // Goal card
        _buildGradientItem(
          index: 0,
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🎯', style: TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Challenge',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      challenge['goal'] ?? '',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Materials card
        _buildGradientItem(
          index: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🧪', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Materials',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: materials.map<Widget>((m) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      m ?? '',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        // Tips
        ...List.generate(tips.length, (index) {
          return _buildGradientItem(
            index: index + 2,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('💡', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tips[index] ?? '',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

  Widget _buildSkillsSection(Map<String, dynamic> section) {
    final skills =
        section['skills'] as List<Map<String, dynamic>>? ?? [];
    return Column(
      children: [
        Text(section['emoji'] ?? '', style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(
          section['title'] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ...List.generate(skills.length, (index) {
          final skill = skills[index];
          return _buildGradientItem(
            index: index,
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      skill['emoji'] ?? '',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill['skill'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        skill['how'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
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
}
