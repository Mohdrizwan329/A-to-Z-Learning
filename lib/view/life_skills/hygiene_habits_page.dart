import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HygieneHabitsPage extends StatefulWidget {
  const HygieneHabitsPage({super.key});

  @override
  State<HygieneHabitsPage> createState() => _HygieneHabitsPageState();
}

class _HygieneHabitsPageState extends State<HygieneHabitsPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Why Hygiene Matters',
      'emoji': '✨',
      'color': Color(0xFF4CAF50),
      'intro': 'Good hygiene keeps you healthy and happy!',
      'reasons': [
        {'reason': 'Prevents sickness', 'emoji': '🦠', 'detail': 'Germs can\'t make you sick'},
        {'reason': 'Keeps you fresh', 'emoji': '🌸', 'detail': 'You smell and feel clean'},
        {'reason': 'Healthy teeth', 'emoji': '😁', 'detail': 'No cavities or toothaches'},
        {'reason': 'Makes friends happy', 'emoji': '👫', 'detail': 'Everyone likes clean friends'},
        {'reason': 'Builds good habits', 'emoji': '⭐', 'detail': 'Habits last a lifetime'},
      ],
    },
    {
      'title': 'Washing Hands',
      'emoji': '🧼',
      'color': Color(0xFF2196F3),
      'intro': 'Washing hands is the #1 way to stop germs!',
      'steps': [
        {'step': 'Wet hands with water', 'emoji': '💧'},
        {'step': 'Add soap', 'emoji': '🧴'},
        {'step': 'Rub hands together - make bubbles!', 'emoji': '🫧'},
        {'step': 'Scrub between fingers', 'emoji': '🤞'},
        {'step': 'Clean under fingernails', 'emoji': '💅'},
        {'step': 'Wash for 20 seconds (sing Happy Birthday twice!)', 'emoji': '🎵'},
        {'step': 'Rinse with water', 'emoji': '💦'},
        {'step': 'Dry with clean towel', 'emoji': '🧻'},
      ],
      'whenToWash': [
        'Before eating',
        'After using bathroom',
        'After playing outside',
        'After touching pets',
        'After sneezing or coughing',
        'After touching garbage',
      ],
    },
    {
      'title': 'Brushing Teeth',
      'emoji': '🦷',
      'color': Color(0xFF00BCD4),
      'intro': 'Brush twice a day for a healthy smile!',
      'steps': [
        {'step': 'Put pea-sized toothpaste on brush', 'emoji': '🫛'},
        {'step': 'Brush front teeth up and down', 'emoji': '⬆️⬇️'},
        {'step': 'Brush back teeth in circles', 'emoji': '🔄'},
        {'step': 'Brush the chewing surfaces', 'emoji': '😮'},
        {'step': 'Don\'t forget your tongue!', 'emoji': '👅'},
        {'step': 'Brush for 2 minutes', 'emoji': '⏰'},
        {'step': 'Spit out toothpaste', 'emoji': '💦'},
        {'step': 'Rinse your mouth', 'emoji': '🥤'},
      ],
      'tips': [
        'Replace toothbrush every 3 months',
        'Brush morning and night',
        'Visit dentist twice a year',
        'Avoid too many sweets',
      ],
    },
    {
      'title': 'Taking a Bath',
      'emoji': '🛁',
      'color': Color(0xFF9C27B0),
      'intro': 'Baths and showers keep your body clean!',
      'bodyParts': [
        {'part': 'Hair', 'emoji': '💆', 'how': 'Shampoo and scrub scalp'},
        {'part': 'Face', 'emoji': '😊', 'how': 'Wash gently with water'},
        {'part': 'Ears', 'emoji': '👂', 'how': 'Clean behind and around ears'},
        {'part': 'Neck', 'emoji': '🦒', 'how': 'Wash all around'},
        {'part': 'Arms & Underarms', 'emoji': '💪', 'how': 'Don\'t forget underarms!'},
        {'part': 'Body', 'emoji': '🧍', 'how': 'Soap up everywhere'},
        {'part': 'Legs & Feet', 'emoji': '🦶', 'how': 'Scrub between toes'},
      ],
      'afterBath': [
        'Dry off completely',
        'Put on clean clothes',
        'Comb your hair',
        'Apply lotion if needed',
      ],
    },
    {
      'title': 'Nail Care',
      'emoji': '💅',
      'color': Color(0xFFE91E63),
      'intro': 'Clean, trimmed nails look great and stay healthy!',
      'tips': [
        {'tip': 'Trim nails regularly', 'emoji': '✂️', 'why': 'Prevents dirt buildup'},
        {'tip': 'Keep nails clean', 'emoji': '🧼', 'why': 'Germs hide under dirty nails'},
        {'tip': 'Don\'t bite nails', 'emoji': '🚫', 'why': 'Germs go in your mouth'},
        {'tip': 'Cut straight across', 'emoji': '➡️', 'why': 'Prevents ingrown nails'},
        {'tip': 'Clean under nails', 'emoji': '🪥', 'why': 'Removes hidden dirt'},
      ],
    },
    {
      'title': 'Hair Care',
      'emoji': '💇',
      'color': Color(0xFFFF9800),
      'intro': 'Healthy hair starts with good care!',
      'routine': [
        {'task': 'Wash hair regularly', 'emoji': '🚿', 'how': '2-3 times a week'},
        {'task': 'Use shampoo', 'emoji': '🧴', 'how': 'Rub into scalp gently'},
        {'task': 'Rinse well', 'emoji': '💧', 'how': 'No shampoo left behind'},
        {'task': 'Comb gently', 'emoji': '🪮', 'how': 'Start from ends'},
        {'task': 'Get regular haircuts', 'emoji': '✂️', 'how': 'Every few months'},
      ],
      'problems': [
        {'problem': 'Tangles', 'solution': 'Use conditioner, comb gently'},
        {'problem': 'Dandruff', 'solution': 'Special shampoo, tell parents'},
        {'problem': 'Lice', 'solution': 'Tell an adult immediately!'},
      ],
    },
    {
      'title': 'Covering Coughs & Sneezes',
      'emoji': '🤧',
      'color': Color(0xFF795548),
      'intro': 'Stop germs from spreading to others!',
      'rightWay': [
        {'do': 'Cover mouth and nose with elbow', 'emoji': '💪', 'why': 'Germs stay on your arm'},
        {'do': 'Use a tissue', 'emoji': '🧻', 'why': 'Catches the germs'},
        {'do': 'Throw tissue away', 'emoji': '🗑️', 'why': 'Don\'t keep germy tissues'},
        {'do': 'Wash hands after', 'emoji': '🧼', 'why': 'Removes any germs'},
      ],
      'wrongWay': [
        {'dont': 'Sneeze into hands', 'emoji': '✋❌', 'why': 'Spreads germs when you touch things'},
        {'dont': 'Sneeze into the air', 'emoji': '💨❌', 'why': 'Germs fly everywhere'},
        {'dont': 'Wipe nose on sleeve', 'emoji': '👕❌', 'why': 'Makes clothes germy'},
      ],
    },
    {
      'title': 'Daily Hygiene Checklist',
      'emoji': '📋',
      'color': Color(0xFF673AB7),
      'morning': [
        {'task': 'Wash face', 'emoji': '🧼'},
        {'task': 'Brush teeth', 'emoji': '🦷'},
        {'task': 'Comb hair', 'emoji': '🪮'},
        {'task': 'Put on clean clothes', 'emoji': '👕'},
        {'task': 'Put on deodorant (if needed)', 'emoji': '🌸'},
      ],
      'afterMeals': [
        {'task': 'Wash hands', 'emoji': '🧼'},
        {'task': 'Wipe mouth', 'emoji': '🧻'},
        {'task': 'Check teeth for food', 'emoji': '😁'},
      ],
      'evening': [
        {'task': 'Take a bath/shower', 'emoji': '🛁'},
        {'task': 'Brush teeth', 'emoji': '🦷'},
        {'task': 'Wash hands', 'emoji': '🧼'},
        {'task': 'Put on clean pajamas', 'emoji': '🛏️'},
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
          'Hygiene Habits',
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
        decoration: const BoxDecoration(
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
              const SizedBox(height: 8),
              Text(
                section['intro'],
                style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildDynamicContent(section),
      ],
    );
  }

  Widget _buildDynamicContent(Map<String, dynamic> section) {
    switch (section['title']) {
      case 'Why Hygiene Matters':
        return _buildWhyMatters(section);
      case 'Washing Hands':
        return _buildHandWashing(section);
      case 'Brushing Teeth':
        return _buildTeethBrushing(section);
      case 'Taking a Bath':
        return _buildBathing(section);
      case 'Nail Care':
        return _buildNailCare(section);
      case 'Hair Care':
        return _buildHairCare(section);
      case 'Covering Coughs & Sneezes':
        return _buildCoughsCovering(section);
      case 'Daily Hygiene Checklist':
        return _buildDailyChecklist(section);
      default:
        return const SizedBox();
    }
  }

  Widget _buildWhyMatters(Map<String, dynamic> section) {
    return Column(
      children: (section['reasons'] as List).map<Widget>((reason) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
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
                  child: Text(reason['emoji'], style: const TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reason['reason'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                      ),
                    ),
                    Text(
                      reason['detail'],
                      style: GoogleFonts.nunito(fontSize: 12),
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

  Widget _buildHandWashing(Map<String, dynamic> section) {
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
              Text('📋 Steps:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...(section['steps'] as List).asMap().entries.map((entry) {
                final step = entry.value;
                return _buildNumberedStep(entry.key + 1, step['step'], step['emoji'], section['color']);
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
              Text('🕐 When to Wash:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (section['whenToWash'] as List).map<Widget>((when) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      when,
                      style: GoogleFonts.nunito(fontSize: 12),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeethBrushing(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: (section['steps'] as List).asMap().entries.map<Widget>((entry) {
              final step = entry.value;
              return _buildNumberedStep(entry.key + 1, step['step'], step['emoji'], section['color']);
            }).toList(),
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
              Text('💡 Tips:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...(section['tips'] as List).map((tip) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.cyan, size: 18),
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

  Widget _buildBathing(Map<String, dynamic> section) {
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
              Text('🧴 Wash Each Part:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...(section['bodyParts'] as List).map((part) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(part['emoji'], style: const TextStyle(fontSize: 22)),
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
                              part['how'],
                              style: GoogleFonts.nunito(fontSize: 11),
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
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('✨ After Bath:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...(section['afterBath'] as List).map((task) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.purple, size: 18),
                      const SizedBox(width: 8),
                      Text(task, style: GoogleFonts.nunito(fontSize: 13)),
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

  Widget _buildNailCare(Map<String, dynamic> section) {
    return Column(
      children: (section['tips'] as List).map<Widget>((tip) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
                  child: Text(tip['emoji'], style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip['tip'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      tip['why'],
                      style: GoogleFonts.nunito(fontSize: 12),
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

  Widget _buildHairCare(Map<String, dynamic> section) {
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
              Text('💇 Hair Care Routine:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...(section['routine'] as List).map((task) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(task['emoji'], style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task['task'],
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              task['how'],
                              style: GoogleFonts.nunito(fontSize: 11),
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
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('⚠️ Common Problems:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['problems'] as List).map((prob) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          prob['problem'],
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          prob['solution'],
                          style: GoogleFonts.nunito(fontSize: 12),
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

  Widget _buildCoughsCovering(Map<String, dynamic> section) {
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
              Text('✅ The Right Way:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 10),
              ...(section['rightWay'] as List).map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['do'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text(item['why'], style: GoogleFonts.nunito(fontSize: 11)),
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
              Text('❌ The Wrong Way:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(height: 10),
              ...(section['wrongWay'] as List).map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['dont'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text(item['why'], style: GoogleFonts.nunito(fontSize: 11)),
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

  Widget _buildDailyChecklist(Map<String, dynamic> section) {
    return Column(
      children: [
        _buildChecklistSection('🌅 Morning', section['morning'] as List, Colors.orange, section['color']),
        const SizedBox(height: 16),
        _buildChecklistSection('🍽️ After Meals', section['afterMeals'] as List, Colors.green, section['color']),
        const SizedBox(height: 16),
        _buildChecklistSection('🌙 Evening', section['evening'] as List, Colors.indigo, section['color']),
      ],
    );
  }

  Widget _buildChecklistSection(String title, List tasks, Color titleColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 10),
          ...tasks.map((task) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      border: Border.all(color: accentColor, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.check, size: 14, color: accentColor),
                  ),
                  const SizedBox(width: 10),
                  Text(task['emoji'], style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(task['task'], style: GoogleFonts.nunito(fontSize: 14)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNumberedStep(int number, String step, String emoji, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(child: Text(step, style: GoogleFonts.nunito(fontSize: 13))),
        ],
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
