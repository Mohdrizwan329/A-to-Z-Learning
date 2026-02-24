import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class CitizenshipBasicsDetailPage extends StatefulWidget {
  final int sectionIndex;

  const CitizenshipBasicsDetailPage({super.key, required this.sectionIndex});

  @override
  State<CitizenshipBasicsDetailPage> createState() =>
      _CitizenshipBasicsDetailPageState();
}

class _CitizenshipBasicsDetailPageState
    extends State<CitizenshipBasicsDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is a Country?',
      'emoji': '🌍',
      'content': [
        {'icon': '🗺️', 'text': 'A country is a large area of land with borders'},
        {'icon': '🏛️', 'text': 'Every country has its own government to make rules'},
        {'icon': '👥', 'text': 'Millions of people live together in a country'},
        {'icon': '🗣️', 'text': 'People in a country may speak one or many languages'},
        {'icon': '🎌', 'text': 'Every country has its own flag, anthem, and symbols'},
        {'icon': '📜', 'text': 'Countries have laws that all people must follow'},
        {'icon': '💰', 'text': 'Each country has its own money called currency'},
        {'icon': '🌐', 'text': 'There are about 195 countries in the world today'},
      ],
    },
    {
      'title': 'What is a Citizen?',
      'emoji': '🧑‍🤝‍🧑',
      'content': [
        {'icon': '🏠', 'text': 'A citizen is a person who legally belongs to a country'},
        {'icon': '👶', 'text': 'You can become a citizen by being born in a country'},
        {'icon': '📝', 'text': 'Some people become citizens of a new country later in life'},
        {'icon': '🛡️', 'text': 'Citizens are protected by the laws of their country'},
        {'icon': '✅', 'text': 'Citizens have special rights like voting and education'},
        {'icon': '🤝', 'text': 'Citizens also have duties like following laws and paying taxes'},
        {'icon': '🪪', 'text': 'Citizens get identity documents like passport and ID card'},
        {'icon': '❤️', 'text': 'Good citizens love and care for their country'},
      ],
    },
    {
      'title': 'National Symbols',
      'emoji': '🏳️',
      'content': [
        {'icon': '🏳️', 'text': 'National Flag - Every country has a unique flag with special colors and designs'},
        {'icon': '🎵', 'text': 'National Anthem - A special song that represents the country'},
        {'icon': '🦅', 'text': 'National Emblem - An official symbol or seal of the country'},
        {'icon': '🐦', 'text': 'National Bird - A bird that represents the country'},
        {'icon': '🐾', 'text': 'National Animal - An animal that is a symbol of the country'},
        {'icon': '🌸', 'text': 'National Flower - A flower chosen to represent the country'},
        {'icon': '🏟️', 'text': 'National Sport - A popular sport loved in the country'},
        {'icon': '🗣️', 'text': 'National Language - The official language spoken in the country'},
      ],
    },
    {
      'title': 'Types of Government',
      'emoji': '🏛️',
      'content': [
        {'icon': '🗳️', 'text': 'Democracy - People choose their leaders by voting'},
        {'icon': '👑', 'text': 'Monarchy - A king or queen rules the country'},
        {'icon': '🏛️', 'text': 'Republic - Leaders are elected by the people'},
        {'icon': '📋', 'text': 'Constitution - A book of rules that the government must follow'},
        {'icon': '👨‍⚖️', 'text': 'Parliament - A group of people who make laws for the country'},
        {'icon': '🧑‍💼', 'text': 'President or Prime Minister - The leader of a country'},
        {'icon': '⚖️', 'text': 'Courts - Places where judges make sure laws are followed fairly'},
        {'icon': '🌍', 'text': 'United Nations - Countries work together for world peace'},
      ],
    },
    {
      'title': 'Rights & Duties',
      'emoji': '⚖️',
      'rights': [
        {'right': 'Right to Education', 'emoji': '📚', 'detail': 'Every child can go to school and learn'},
        {'right': 'Right to Safety', 'emoji': '🛡️', 'detail': 'Every person should be protected from harm'},
        {'right': 'Right to Health', 'emoji': '🏥', 'detail': 'Everyone can see a doctor when sick'},
        {'right': 'Right to Freedom', 'emoji': '🕊️', 'detail': 'Everyone can speak freely and share ideas'},
        {'right': 'Right to Equality', 'emoji': '🤝', 'detail': 'All people are equal regardless of differences'},
      ],
      'duties': [
        {'duty': 'Follow the Laws', 'emoji': '📋', 'detail': 'Obey rules to keep everyone safe'},
        {'duty': 'Respect Others', 'emoji': '🙏', 'detail': 'Treat everyone with kindness and respect'},
        {'duty': 'Protect Environment', 'emoji': '🌱', 'detail': 'Keep our planet clean and green'},
        {'duty': 'Help Community', 'emoji': '💪', 'detail': 'Help neighbors and people in need'},
        {'duty': 'Be Honest', 'emoji': '💎', 'detail': 'Always tell the truth and act fairly'},
      ],
    },
    {
      'title': 'Being a Good Citizen',
      'emoji': '⭐',
      'tips': [
        {'tip': 'Follow rules and laws of your country', 'emoji': '📋'},
        {'tip': 'Respect people of all cultures and backgrounds', 'emoji': '🌍'},
        {'tip': 'Keep your surroundings clean and tidy', 'emoji': '🧹'},
        {'tip': 'Help others who are in need', 'emoji': '🤝'},
        {'tip': 'Be honest and truthful always', 'emoji': '💎'},
        {'tip': 'Take care of nature and animals', 'emoji': '🌿'},
        {'tip': 'Study well and learn about the world', 'emoji': '📚'},
        {'tip': 'Be kind and spread happiness', 'emoji': '😊'},
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
    final section = sections[widget.sectionIndex];
    return GradientScaffold(
      title: section['title'] ?? '',
      emoji: section['emoji'] ?? '',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: _buildSectionContent(section),
      ),
    );
  }

  Widget _buildGradientItem({
    required int itemIndex,
    required Widget child,
  }) {
    final gradient = AppColors.getGradientForIndex(itemIndex);
    return buildFloatingItem(
      index: itemIndex,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildSectionContent(Map<String, dynamic> section) {
    switch (widget.sectionIndex) {
      case 0:
      case 1:
      case 2:
      case 3:
        return _buildContentSection(section);
      case 4:
        return _buildRightsDutiesSection(section);
      case 5:
        return _buildTipsSection(section);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildContentSection(Map<String, dynamic> section) {
    final content = section['content'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: content.map<Widget>((item) {
        final idx = itemIndex++;
        return _buildGradientItem(
          itemIndex: idx,
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item['text'] ?? '',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
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

  Widget _buildRightsDutiesSection(Map<String, dynamic> section) {
    final rights = section['rights'] as List? ?? [];
    final duties = section['duties'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rights header
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            '✨ My Rights',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ...rights.map<Widget>((item) {
          final idx = itemIndex++;
          return _buildGradientItem(
            itemIndex: idx,
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                        item['emoji'] ?? '',
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['right'] ?? '',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['detail'] ?? '',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        // Duties header
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            '📝 My Duties',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ...duties.map<Widget>((item) {
          final idx = itemIndex++;
          return _buildGradientItem(
            itemIndex: idx,
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                        item['emoji'] ?? '',
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['duty'] ?? '',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['detail'] ?? '',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
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

  Widget _buildTipsSection(Map<String, dynamic> section) {
    final tips = section['tips'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: tips.map<Widget>((tip) {
        final idx = itemIndex++;
        return _buildGradientItem(
          itemIndex: idx,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${idx + 1}',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  tip['emoji'] ?? '',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tip['tip'] ?? '',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
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
}
