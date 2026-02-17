import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view/stem/simple_experiments_page.dart';
import 'package:jiyan_learning/view/stem/engineering_kids_page.dart';
import 'package:jiyan_learning/view/stem/stem_challenges_page.dart';
import 'package:jiyan_learning/view/stem/steam_page.dart';

class StemHubPage extends StatelessWidget {
  const StemHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> stemCategories = [
      {
        'title': 'Science',
        'emoji': '🔬',
        'color': Color(0xFF66BB6A),
        'subtitle': 'Explore & Discover',
        'description': 'Learn about the world around you through experiments!',
        'page': () => SimpleExperimentsPage(),
      },
      {
        'title': 'Technology',
        'emoji': '💻',
        'color': Color(0xFF42A5F5),
        'subtitle': 'Digital World',
        'description': 'Understand how computers and gadgets work!',
        'page': null,
      },
      {
        'title': 'Engineering',
        'emoji': '⚙️',
        'color': Color(0xFFFF7043),
        'subtitle': 'Build & Create',
        'description': 'Design and build amazing things!',
        'page': () => EngineeringKidsPage(),
      },
      {
        'title': 'Math',
        'emoji': '🔢',
        'color': Color(0xFF7E57C2),
        'subtitle': 'Numbers & Logic',
        'description': 'Solve puzzles and discover patterns!',
        'page': null,
      },
      {
        'title': 'STEM Challenges',
        'emoji': '🏆',
        'color': Color(0xFFFFB74D),
        'subtitle': 'Problem Solving',
        'description': 'Fun challenges that use all STEM skills!',
        'page': () => StemChallengesPage(),
      },
      {
        'title': 'STEAM (Art+Science)',
        'emoji': '🎨',
        'color': Color(0xFFEC407A),
        'subtitle': 'Creative Science',
        'description': 'Where Art meets Science!',
        'page': () => SteamPage(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'STEM Learning',
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
              _buildStemInfo(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: stemCategories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryCard(stemCategories[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildStemInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStemLetter('S', 'Science', '🔬'),
              _buildStemLetter('T', 'Technology', '💻'),
              _buildStemLetter('E', 'Engineering', '⚙️'),
              _buildStemLetter('M', 'Math', '🔢'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Learn to think like a scientist, engineer, and problem solver!',
            style: GoogleFonts.nunito(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStemLetter(String letter, String word, String emoji) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              letter,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(emoji, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        if (category['page'] != null) {
          Get.to(category['page']);
        } else {
          Get.snackbar(
            '🚧 Coming Soon!',
            'This section is under development',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              category['color'],
              category['color'].withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: category['color'].withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    category['emoji'],
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      category['subtitle'],
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category['description'],
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
