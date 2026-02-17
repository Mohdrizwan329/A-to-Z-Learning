import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RightsDutiesPage extends StatefulWidget {
  const RightsDutiesPage({super.key});

  @override
  State<RightsDutiesPage> createState() => _RightsDutiesPageState();
}

class _RightsDutiesPageState extends State<RightsDutiesPage> {
  int currentTab = 0;

  final List<Map<String, dynamic>> rights = [
    {
      'title': 'Right to Education',
      'emoji': '📚',
      'color': Color(0xFF4FC3F7),
      'description': 'Every child can go to school and learn',
      'example': 'You can go to school for free until age 14',
    },
    {
      'title': 'Right to Play',
      'emoji': '⚽',
      'color': Color(0xFF66BB6A),
      'description': 'Every child has the right to play and have fun',
      'example': 'You can play games, sports, and enjoy your childhood',
    },
    {
      'title': 'Right to Food',
      'emoji': '🍎',
      'color': Color(0xFFFF7043),
      'description': 'Every child deserves healthy food to eat',
      'example': 'You should get nutritious meals every day',
    },
    {
      'title': 'Right to Safety',
      'emoji': '🛡️',
      'color': Color(0xFFBA68C8),
      'description': 'Every child should be protected from harm',
      'example': 'Adults should keep you safe from danger',
    },
    {
      'title': 'Right to Health',
      'emoji': '🏥',
      'color': Color(0xFF26A69A),
      'description': 'Every child can see a doctor when sick',
      'example': 'You can get medicine and treatment when needed',
    },
    {
      'title': 'Right to Love',
      'emoji': '❤️',
      'color': Color(0xFFEC407A),
      'description': 'Every child deserves love and care from family',
      'example': 'Your family should love and take care of you',
    },
    {
      'title': 'Right to Expression',
      'emoji': '🗣️',
      'color': Color(0xFFFFB74D),
      'description': 'Every child can share their thoughts and feelings',
      'example': 'You can tell adults what you think and feel',
    },
    {
      'title': 'Right to Name & Identity',
      'emoji': '📝',
      'color': Color(0xFF7986CB),
      'description': 'Every child has a name and belongs to a country',
      'example': 'You have your own name and are a citizen',
    },
  ];

  final List<Map<String, dynamic>> duties = [
    {
      'title': 'Study Well',
      'emoji': '📖',
      'color': Color(0xFF4FC3F7),
      'description': 'Do your homework and learn new things',
      'howTo': 'Pay attention in class and complete assignments',
    },
    {
      'title': 'Respect Elders',
      'emoji': '🙏',
      'color': Color(0xFF66BB6A),
      'description': 'Listen to and respect parents, teachers, and elders',
      'howTo': 'Say please, thank you, and be polite',
    },
    {
      'title': 'Keep Clean',
      'emoji': '🧹',
      'color': Color(0xFFFF7043),
      'description': 'Keep yourself and surroundings clean',
      'howTo': 'Wash hands, don\'t litter, organize your things',
    },
    {
      'title': 'Help Others',
      'emoji': '🤝',
      'color': Color(0xFFBA68C8),
      'description': 'Be kind and help people who need it',
      'howTo': 'Share with friends, help classmates, be caring',
    },
    {
      'title': 'Be Honest',
      'emoji': '💎',
      'color': Color(0xFF26A69A),
      'description': 'Always tell the truth',
      'howTo': 'Don\'t lie, cheat, or steal',
    },
    {
      'title': 'Follow Rules',
      'emoji': '📋',
      'color': Color(0xFFEC407A),
      'description': 'Obey rules at home, school, and public places',
      'howTo': 'Wait your turn, follow traffic rules, listen to instructions',
    },
    {
      'title': 'Save Resources',
      'emoji': '💧',
      'color': Color(0xFFFFB74D),
      'description': 'Don\'t waste water, electricity, or food',
      'howTo': 'Turn off lights, close taps, finish your food',
    },
    {
      'title': 'Love Nature',
      'emoji': '🌳',
      'color': Color(0xFF7986CB),
      'description': 'Protect plants, animals, and the environment',
      'howTo': 'Plant trees, don\'t harm animals, don\'t pollute',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Rights & Duties',
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
              _buildTabButtons(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: currentTab == 0
                      ? _buildRightsList()
                      : _buildDutiesList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTabButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => currentTab = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: currentTab == 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('✨', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      'My Rights',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: currentTab == 0 ? Colors.blue : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => currentTab = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: currentTab == 1 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('📝', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      'My Duties',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: currentTab == 1 ? Colors.green : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightsList() {
    return ListView.builder(
      key: const ValueKey('rights'),
      padding: const EdgeInsets.all(16),
      itemCount: rights.length,
      itemBuilder: (context, index) {
        final right = rights[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: right['color'].withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: right['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(right['emoji'], style: const TextStyle(fontSize: 28)),
                ),
              ),
              title: Text(
                right['title'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: right['color'],
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                right['description'],
                style: GoogleFonts.nunito(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: right['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text('💡', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Example:',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: right['color'],
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              right['example'],
                              style: GoogleFonts.nunito(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDutiesList() {
    return ListView.builder(
      key: const ValueKey('duties'),
      padding: const EdgeInsets.all(16),
      itemCount: duties.length,
      itemBuilder: (context, index) {
        final duty = duties[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: duty['color'].withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: duty['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(duty['emoji'], style: const TextStyle(fontSize: 28)),
                ),
              ),
              title: Text(
                duty['title'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: duty['color'],
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                duty['description'],
                style: GoogleFonts.nunito(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: duty['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text('✅', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How to do it:',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: duty['color'],
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              duty['howTo'],
                              style: GoogleFonts.nunito(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
