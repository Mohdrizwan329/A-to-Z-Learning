import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view/learn%20set/rhymes_page.dart';
import 'package:jiyan_learning/view/learn%20set/gk_learning_page.dart';
import 'package:jiyan_learning/view/learn%20set/stories_page.dart';
import 'package:jiyan_learning/view/world%20meaning%20Alphabet%20/Alphabet_meaning.dart';
// Generic Pages
import 'package:jiyan_learning/view/Alphabets/generic_alphabet_page.dart';
import 'package:jiyan_learning/view%20model/alphabet%20controller/generic_alphabet_controller.dart';
// Core imports
import 'package:jiyan_learning/view/numbers/Number_Page.dart';
import 'package:jiyan_learning/view/tables/Table_Page.dart';
import 'package:jiyan_learning/view/drawing/Drawing_Image_Page.dart';
import 'package:jiyan_learning/view/drawing/Drawing_Page.dart';
import 'package:jiyan_learning/view/hindi%20world%20meaning/hindi_letters_page.dart';
import 'package:jiyan_learning/view/learn%20set/learning_set_grid_page.dart';
import 'package:jiyan_learning/view/math%20problem%20&%20solution/Problems_Pages.dart';
import 'package:jiyan_learning/view/math%20qustion/math_qust_grid_page.dart';
import 'package:jiyan_learning/view/quiz/quiz_page.dart';
import 'package:jiyan_learning/view/premium/fun_games_page.dart';
import 'package:jiyan_learning/view/premium/quiz_battle_page.dart';
// Early Learning
import 'package:jiyan_learning/view/early_learning/sensory_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/visual_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/audio_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/play_based_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/montessori_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/activity_based_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/exploratory_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/discovery_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/experiential_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/kinesthetic_learning_page.dart';
// Literacy
import 'package:jiyan_learning/view/literacy/sight_words_page.dart';
import 'package:jiyan_learning/view/literacy/spelling_practice_page.dart';
import 'package:jiyan_learning/view/literacy/reading_fluency_page.dart';
import 'package:jiyan_learning/view/literacy/sentence_formation_page.dart';
import 'package:jiyan_learning/view/literacy/listening_skills_page.dart';
// Writing
import 'package:jiyan_learning/view/writing/cursive_writing_page.dart';
// Math
import 'package:jiyan_learning/view/math/money_concepts_page.dart';
// Knowledge
import 'package:jiyan_learning/view/knowledge/environmental_studies_page.dart';
import 'package:jiyan_learning/view/knowledge/science_basics_page.dart';
// Global Awareness
import 'package:jiyan_learning/view/global_awareness/world_map_page.dart';
import 'package:jiyan_learning/view/global_awareness/global_cultures_page.dart';
import 'package:jiyan_learning/view/global_awareness/famous_places_page.dart';
// Projects
import 'package:jiyan_learning/view/projects/mini_projects_page.dart';
// Creativity
import 'package:jiyan_learning/view/creativity/story_creation_page.dart';
// SEL
import 'package:jiyan_learning/view/sel/good_habits_page.dart';
import 'package:jiyan_learning/view/sel/confidence_building_page.dart';
import 'package:jiyan_learning/view/sel/mindfulness_page.dart';
// Rewards
import 'package:jiyan_learning/view/rewards/surprise_rewards_page.dart';
// Games
import 'package:jiyan_learning/view/games/drag_drop_game_page.dart';
import 'package:jiyan_learning/view/games/tracing_game_page.dart';
import 'package:jiyan_learning/view/games/matching_game_page.dart';
import 'package:jiyan_learning/view/games/logic_game_page.dart';
import 'package:jiyan_learning/view/games/puzzle_game_page.dart';
// Assessment
import 'package:jiyan_learning/view/assessment/adaptive_quiz_page.dart';
// SEL additional
import 'package:jiyan_learning/view/sel/empathy_learning_page.dart';
import 'package:jiyan_learning/view/sel/emotional_regulation_page.dart';
import 'package:jiyan_learning/view/sel/self_awareness_page.dart';
// Writing additional
import 'package:jiyan_learning/view/writing/writing_accuracy_page.dart';
// Knowledge additional
import 'package:jiyan_learning/view/knowledge/social_awareness_page.dart';
// Rewards additional
import 'package:jiyan_learning/view/rewards/daily_goals_page.dart';
// Executive Function
import 'package:jiyan_learning/view/executive_function/planning_skills_page.dart';
import 'package:jiyan_learning/view/executive_function/goal_setting_page.dart';
import 'package:jiyan_learning/view/executive_function/task_sequencing_page.dart';
import 'package:jiyan_learning/view/executive_function/working_memory_page.dart';
// STEM
import 'package:jiyan_learning/view/stem/stem_hub_page.dart';
import 'package:jiyan_learning/view/stem/simple_experiments_page.dart';
import 'package:jiyan_learning/view/stem/design_thinking_page.dart';
// Digital Literacy
import 'package:jiyan_learning/view/digital_literacy/computer_awareness_page.dart';
import 'package:jiyan_learning/view/digital_literacy/keyboard_mouse_page.dart';
import 'package:jiyan_learning/view/digital_literacy/internet_safety_page.dart';
import 'package:jiyan_learning/view/digital_literacy/digital_etiquette_page.dart';
// Projects additional
import 'package:jiyan_learning/view/projects/diy_learning_page.dart';
// Assessment additional
import 'package:jiyan_learning/view/assessment/skill_evaluation_page.dart';
// Life Skills
import 'package:jiyan_learning/view/life_skills/hygiene_habits_page.dart';
import 'package:jiyan_learning/view/life_skills/money_habits_page.dart';
import 'package:jiyan_learning/view/life_skills/time_management_page.dart';
import 'package:jiyan_learning/view/life_skills/safety_skills_page.dart';
// Cognitive
import 'package:jiyan_learning/view/cognitive/focus_improvement_page.dart';
import 'package:jiyan_learning/view/cognitive/attention_training_page.dart';
// Health
import 'package:jiyan_learning/view/health/nutrition_learning_page.dart';
import 'package:jiyan_learning/view/health/exercise_fitness_page.dart';
import 'package:jiyan_learning/view/health/body_safety_page.dart';
import 'package:jiyan_learning/view/health/mental_health_basics_page.dart';
// STEM Advanced (Class 5-6)
import 'package:jiyan_learning/view/stem/engineering_kids_page.dart';
import 'package:jiyan_learning/view/stem/stem_challenges_page.dart';
import 'package:jiyan_learning/view/stem/steam_page.dart';
// Metacognition (Class 5-6)
import 'package:jiyan_learning/view/metacognition/think_about_thinking_page.dart';
import 'package:jiyan_learning/view/metacognition/self_reflection_page.dart';
import 'package:jiyan_learning/view/metacognition/learning_strategy_page.dart';
// Sustainability (Class 5-6)
import 'package:jiyan_learning/view/sustainability/climate_awareness_page.dart';
import 'package:jiyan_learning/view/sustainability/recycling_kids_page.dart';
import 'package:jiyan_learning/view/sustainability/sustainable_habits_page.dart';
// Social Studies (Class 5-6)
import 'package:jiyan_learning/view/social_studies/citizenship_basics_page.dart';
import 'package:jiyan_learning/view/social_studies/rights_duties_page.dart';
import 'package:jiyan_learning/view/social_studies/family_relationships_page.dart';
// Premium (Class 5-6)
// Age Content Service
import 'package:jiyan_learning/services/age_content_service.dart'
    hide AlphabetType;

/// Age groups for content filtering
enum AgeGroupFilter {
  toddler, // 2-4 years (Toddler / Nursery)
  lkgUkg, // 4-6 years (LKG / UKG)
  class1To2, // 6-8 years (Class 1-2)
  class3To4, // 8-10 years (Class 3-4)
  class5To6, // 10-12 years (Class 5-6)
  all, // Available for all ages
}

class ClassItem {
  final String title;
  final String subtitle;
  final Widget Function()? pageBuilder;
  final List<AgeGroupFilter> ageGroups;
  final String category;
  final String emoji;
  final List<Color> gradient;

  const ClassItem({
    required this.title,
    required this.subtitle,
    required this.pageBuilder,
    this.ageGroups = const [AgeGroupFilter.all],
    this.category = 'Other',
    this.emoji = '📚',
    this.gradient = const [Color(0xFF667EEA), Color(0xFF764BA2)],
  });
}

class CategoryData {
  final String name;
  final String emoji;
  final List<Color> gradient;

  const CategoryData({
    required this.name,
    required this.emoji,
    required this.gradient,
  });
}

IconData getIconForTitle(String title) {
  title = title.toLowerCase();

  if (title.contains("number") || title.contains("1-100")) {
    return Icons.numbers;
  } else if (title.contains("capital")) {
    return Icons.abc;
  } else if (title.contains("small")) {
    return Icons.text_fields;
  } else if (title.contains("a to z") || title.contains("alphabet")) {
    return Icons.sort_by_alpha;
  } else if (title.contains("hindi")) {
    return Icons.book;
  } else if (title.contains("math problem")) {
    return Icons.calculate;
  } else if (title.contains("math practice")) {
    return Icons.quiz;
  } else if (title.contains("table")) {
    return Icons.grid_on;
  } else if (title.contains("drawing")) {
    return Icons.brush;
  } else if (title.contains("question")) {
    return Icons.question_answer;
  } else if (title.contains("learning set")) {
    return Icons.book;
  } else if (title.contains("rhymes") || title.contains("poetry")) {
    return Icons.music_note;
  }
  return Icons.school;
}

class HomeController extends GetxController {
  var classItems = <ClassItem>[].obs;
  var searchQuery = "".obs;
  var displayItems = <ClassItem>[].obs;
  var categorizedItems = <String, List<ClassItem>>{}.obs;

  // Category order for display
  static const List<String> categoryOrder = [
    'Core Learning',
    'Games & Quiz',
    'Literacy',
    'Writing',
    'Math & Logic',
    'Creativity',
    'Knowledge',
    'Life Skills',
    'Health',
    'Culture',
    'Special Features',
  ];

  // Category metadata
  static const Map<String, CategoryData> categoryMeta = {
    'Core Learning': CategoryData(
      name: 'Core Learning',
      emoji: '📚',
      gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    ),
    'Games & Quiz': CategoryData(
      name: 'Games & Quiz',
      emoji: '🎮',
      gradient: [Color(0xFF4ECDC4), Color(0xFF56E39F)],
    ),
    'Literacy': CategoryData(
      name: 'Literacy',
      emoji: '📖',
      gradient: [Color(0xFF74B9FF), Color(0xFF0984E3)],
    ),
    'Writing': CategoryData(
      name: 'Writing',
      emoji: '✍️',
      gradient: [Color(0xFFA29BFE), Color(0xFF6C5CE7)],
    ),
    'Math & Logic': CategoryData(
      name: 'Math & Logic',
      emoji: '🧮',
      gradient: [Color(0xFFFFE66D), Color(0xFFFFA94D)],
    ),
    'Creativity': CategoryData(
      name: 'Creativity',
      emoji: '🎨',
      gradient: [Color(0xFFFF9FF3), Color(0xFFF368E0)],
    ),
    'Knowledge': CategoryData(
      name: 'Knowledge',
      emoji: '🌍',
      gradient: [Color(0xFF55EFC4), Color(0xFF00B894)],
    ),
    'Life Skills': CategoryData(
      name: 'Life Skills',
      emoji: '🏠',
      gradient: [Color(0xFFFDCB6E), Color(0xFFE17055)],
    ),
    'Health': CategoryData(
      name: 'Health',
      emoji: '💪',
      gradient: [Color(0xFF81ECEC), Color(0xFF00CEC9)],
    ),
    'Culture': CategoryData(
      name: 'Culture',
      emoji: '🇮🇳',
      gradient: [Color(0xFFFAB1A0), Color(0xFFFF7675)],
    ),
    'Special Features': CategoryData(
      name: 'Special Features',
      emoji: '⭐',
      gradient: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
    ),
  };

  AgeContentService get _ageService => Get.find<AgeContentService>();

  @override
  void onInit() {
    super.onInit();

    ever(_ageService.currentAgeGroup, (_) => _updateDisplayItems());
    ever(searchQuery, (_) => _updateDisplayItems());

    classItems.assignAll([
      // ============================================================
      // AGE GROUP 1: TODDLER (2-4 Years) - Sensory, recognition, fun
      // AGE GROUP 2: LKG/UKG (4-6 Years) - Foundation + interaction
      // AGE GROUP 3: CLASS 1-2 (6-8 Years) - Academic readiness
      // AGE GROUP 4: CLASS 3-4 (8-10 Years) - Reasoning + independence
      // AGE GROUP 5: CLASS 5-6 (10-12 Years) - World awareness + self learning
      // ============================================================
      // === CORE LEARNING ===
      // Numbers: Toddler (1-20), LKG/UKG (1-100), Class 1-2+
      ClassItem(
        title: 'Numbers',
        subtitle: 'Learn Counting',
        pageBuilder: () => NumbersScreen(gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)]),
        category: 'Core Learning',
        emoji: '🔢',
        gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
        ageGroups: [
          AgeGroupFilter.toddler,
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),
      // Capital Letters: Toddler + All ages
      ClassItem(
        title: 'Capital Letters',
        subtitle: 'Alphabets',
        pageBuilder: () => GenericAlphabetPage(type: AlphabetType.capital, gradient: [Color(0xFF45B7D1), Color(0xFF74C9DB)]),
        category: 'Core Learning',
        emoji: '🅰️',
        gradient: [Color(0xFF45B7D1), Color(0xFF74C9DB)],
        ageGroups: [
          AgeGroupFilter.toddler,
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),
      // Small Letters: All ages including Toddler
      ClassItem(
        title: 'Small Letters',
        subtitle: 'Alphabets',
        pageBuilder: () => GenericAlphabetPage(type: AlphabetType.small, gradient: [Color(0xFF56D97F), Color(0xFF81E89E)]),
        category: 'Core Learning',
        emoji: '🔤',
        gradient: [Color(0xFF56D97F), Color(0xFF81E89E)],
        ageGroups: [
          AgeGroupFilter.toddler,
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),
      // Hindi Letters: Toddler (basic sounds) + All ages
      ClassItem(
        title: 'Hindi Letters',
        subtitle: 'हिंदी वर्णमाला',
        pageBuilder: () => HindiLettersPage(gradient: [Color(0xFFFFAA5A), Color(0xFFFFCB80)]),
        category: 'Core Learning',
        emoji: '🇮🇳',
        gradient: [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
        ageGroups: [
          AgeGroupFilter.toddler,
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),
      // Alphabet Words/Meaning: LKG/UKG and above (NOT Toddler)
      ClassItem(
        title: 'A to Z Words',
        subtitle: 'A for Apple',
        pageBuilder: () => AlphabetMeaning(gradient: [Color(0xFFA78BFA), Color(0xFFC4B5FD)]),
        category: 'Core Learning',
        emoji: '📖',
        gradient: [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
        ageGroups: [
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),
      // Tables: LKG/UKG (2-10), Class 1-2 (2-20), Class 3-4+ (2-40) - NOT Toddler
      ClassItem(
        title: 'Tables',
        subtitle: '2 to 40',
        pageBuilder: () => TableScreen(gradient: [Color(0xFF3B82F6), Color(0xFF60A5FA)]),
        category: 'Core Learning',
        emoji: '✖️',
        gradient: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
        ageGroups: [
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),
      // Learning Sets: All ages (Animals, Fruits, Colors, etc.)
      ClassItem(
        title: 'Learning Sets',
        subtitle: 'Animals, Fruits...',
        pageBuilder: () => LearningSetsGridScreen(gradient: [Color(0xFFEC4899), Color(0xFFF472B6)]),
        category: 'Core Learning',
        emoji: '📚',
        gradient: [Color(0xFFEC4899), Color(0xFFF472B6)],
        ageGroups: [
          AgeGroupFilter.toddler,
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),
      // Poetry/Rhymes: Toddler + All ages
      ClassItem(
        title: 'Rhymes & Songs',
        subtitle: 'Sing Along Rhymes',
        pageBuilder: () => RhymesPage(),
        category: 'Core Learning',
        emoji: '🎵',
        gradient: [Color(0xFF10B981), Color(0xFF34D399)],
        ageGroups: [
          AgeGroupFilter.toddler,
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),
      // General Knowledge: All ages
      ClassItem(
        title: 'General Knowledge',
        subtitle: 'GK Questions',
        pageBuilder: () => GKLearningPage(),
        category: 'Core Learning',
        emoji: '🧠',
        gradient: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
        ageGroups: [
          AgeGroupFilter.toddler,
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),
      // Stories: All ages
      ClassItem(
        title: 'Stories',
        subtitle: 'Learn with Stories',
        pageBuilder: () => StoriesPage(),
        category: 'Core Learning',
        emoji: '📚',
        gradient: [Color(0xFFEF4444), Color(0xFFF87171)],
        ageGroups: [
          AgeGroupFilter.toddler,
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),

      // === EARLY LEARNING (FULL) - Toddler & LKG/UKG ONLY ===
      // Sensory Learning: Toddler ONLY
      ClassItem(
        title: 'Sensory Learning',
        subtitle: 'Touch, Feel, Explore',
        pageBuilder: () => SensoryLearningPage(),
        category: 'Core Learning',
        emoji: '🖐️',
        gradient: [Color(0xFF81ECEC), Color(0xFF00CEC9)],
        ageGroups: [AgeGroupFilter.toddler],
      ),
      // Visual Learning: Toddler ONLY
      ClassItem(
        title: 'Visual Learning',
        subtitle: 'See & Learn',
        pageBuilder: () => VisualLearningPage(),
        category: 'Core Learning',
        emoji: '👀',
        gradient: [Color(0xFF74B9FF), Color(0xFF0984E3)],
        ageGroups: [AgeGroupFilter.toddler],
      ),
      // Audio Learning: Toddler ONLY
      ClassItem(
        title: 'Audio Learning',
        subtitle: 'Listen & Learn',
        pageBuilder: () => AudioLearningPage(),
        category: 'Core Learning',
        emoji: '🔊',
        gradient: [Color(0xFFA29BFE), Color(0xFF6C5CE7)],
        ageGroups: [AgeGroupFilter.toddler],
      ),
      // Play Based Learning: Toddler ONLY
      ClassItem(
        title: 'Play Based Learning',
        subtitle: 'Learn Through Play',
        pageBuilder: () => PlayBasedLearningPage(),
        category: 'Core Learning',
        emoji: '🎈',
        gradient: [Color(0xFFFF9FF3), Color(0xFFF368E0)],
        ageGroups: [AgeGroupFilter.toddler],
      ),
      // Montessori Learning: Toddler ONLY
      ClassItem(
        title: 'Montessori Learning',
        subtitle: 'Self-Directed Learning',
        pageBuilder: () => MontessoriLearningPage(),
        category: 'Core Learning',
        emoji: '🧒',
        gradient: [Color(0xFF55EFC4), Color(0xFF00B894)],
        ageGroups: [AgeGroupFilter.toddler],
      ),
      // Activity Based: Toddler ONLY
      ClassItem(
        title: 'Activity Based',
        subtitle: 'Hands-on Activities',
        pageBuilder: () => ActivityBasedLearningPage(),
        category: 'Core Learning',
        emoji: '🎯',
        gradient: [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
        ageGroups: [AgeGroupFilter.toddler],
      ),
      // Exploratory Learning: LKG/UKG ONLY
      ClassItem(
        title: 'Exploratory Learning',
        subtitle: 'Explore & Discover',
        pageBuilder: () => ExploratoryLearningPage(),
        category: 'Core Learning',
        emoji: '🔍',
        gradient: [Color(0xFF45B7D1), Color(0xFF74C9DB)],
        ageGroups: [AgeGroupFilter.lkgUkg],
      ),
      // Discovery Learning: LKG/UKG ONLY
      ClassItem(
        title: 'Discovery Learning',
        subtitle: 'Find & Learn',
        pageBuilder: () => DiscoveryLearningPage(),
        category: 'Core Learning',
        emoji: '💡',
        gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
        ageGroups: [AgeGroupFilter.lkgUkg],
      ),
      // Experiential Learning: LKG/UKG ONLY
      ClassItem(
        title: 'Experiential Learning',
        subtitle: 'Learn by Doing',
        pageBuilder: () => ExperientialLearningPage(),
        category: 'Core Learning',
        emoji: '🧪',
        gradient: [Color(0xFF56D97F), Color(0xFF81E89E)],
        ageGroups: [AgeGroupFilter.lkgUkg],
      ),
      // Kinesthetic Learning: LKG/UKG ONLY
      ClassItem(
        title: 'Kinesthetic Learning',
        subtitle: 'Move & Learn',
        pageBuilder: () => KinestheticLearningPage(),
        category: 'Core Learning',
        emoji: '🏃',
        gradient: [Color(0xFFEC4899), Color(0xFFF472B6)],
        ageGroups: [AgeGroupFilter.lkgUkg],
      ),

      // === GAMES & QUIZ ===
      // Quiz Time: Direct quiz access - LKG/UKG and above
      ClassItem(
        title: 'Quiz Time',
        subtitle: 'Test Knowledge!',
        pageBuilder: () => QuizPage(),
        category: 'Games & Quiz',
        emoji: '❓',
        gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
        ageGroups: [
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),
      // Drag & Drop: LKG/UKG and Class 1-2 only (NOT Toddler)
      ClassItem(
        title: 'Drag & Drop',
        subtitle: 'Match Game',
        pageBuilder: () => DragDropGamePage(),
        category: 'Games & Quiz',
        emoji: '🃏',
        gradient: [Color(0xFF45B7D1), Color(0xFF74C9DB)],
        ageGroups: [AgeGroupFilter.lkgUkg, AgeGroupFilter.class1To2],
      ),
      // Matching Game: Toddler (very simple), LKG/UKG, Class 1-2
      ClassItem(
        title: 'Matching Game',
        subtitle: 'Find Pairs',
        pageBuilder: () => MatchingGamePage(),
        category: 'Games & Quiz',
        emoji: '🎴',
        gradient: [Color(0xFF56D97F), Color(0xFF81E89E)],
        ageGroups: [
          AgeGroupFilter.toddler,
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
        ],
      ),
      // Tracing Game: Toddler (guided) and LKG/UKG only
      ClassItem(
        title: 'Tracing Game',
        subtitle: 'Trace & Learn',
        pageBuilder: () => TracingGamePage(),
        category: 'Games & Quiz',
        emoji: '✏️',
        gradient: [Color(0xFFFDCB6E), Color(0xFFE17055)],
        ageGroups: [AgeGroupFilter.toddler, AgeGroupFilter.lkgUkg],
      ),
      // Logic Games: Class 1-2 and Class 3-4 only
      ClassItem(
        title: 'Logic Games',
        subtitle: 'Think & Solve',
        pageBuilder: () => LogicGamePage(),
        category: 'Games & Quiz',
        emoji: '🧠',
        gradient: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
        ageGroups: [AgeGroupFilter.class1To2, AgeGroupFilter.class3To4],
      ),
      // Puzzle Game: Toddler, LKG/UKG, Class 1-2
      ClassItem(
        title: 'Puzzle Game',
        subtitle: 'Word Puzzles',
        pageBuilder: () => PuzzleGamePage(),
        category: 'Games & Quiz',
        emoji: '🧩',
        gradient: [Color(0xFFFF6EB4), Color(0xFFFF9A9E)],
        ageGroups: [AgeGroupFilter.toddler, AgeGroupFilter.lkgUkg, AgeGroupFilter.class1To2],
      ),
      // Adaptive Quiz: LKG/UKG only (image based) - NOT for Toddler
      ClassItem(
        title: 'Adaptive Quiz',
        subtitle: 'Image Based Quiz',
        pageBuilder: () => AdaptiveQuizPage(),
        category: 'Games & Quiz',
        emoji: '🎯',
        gradient: [Color(0xFF10B981), Color(0xFF34D399)],
        ageGroups: [AgeGroupFilter.lkgUkg],
      ),
      // Fun Games: LKG/UKG, Class 1-2 (NOT Toddler)
      ClassItem(
        title: 'Fun Games',
        subtitle: 'Play & Learning',
        pageBuilder: () => FunGamesPage(),
        category: 'Games & Quiz',
        emoji: '🎯',
        gradient: [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
        ageGroups: [AgeGroupFilter.lkgUkg, AgeGroupFilter.class1To2],
      ),
      // Quiz Battle: Class 5-6 ONLY (per spec)
      ClassItem(
        title: 'Quiz Battle',
        subtitle: 'Challenge Friends',
        pageBuilder: () => QuizBattlePage(),
        category: 'Games & Quiz',
        emoji: '⚔️',
        gradient: [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),
      // Surprise Rewards: Class 1-2 ONLY (per spec - Rewards section)
      ClassItem(
        title: 'Surprise Rewards',
        subtitle: 'Spin & Win',
        pageBuilder: () => SurpriseRewardsPage(),
        category: 'Games & Quiz',
        emoji: '🎁',
        gradient: [Color(0xFFEC4899), Color(0xFFF472B6)],
        ageGroups: [AgeGroupFilter.class1To2],
      ),
      // Daily Goals: Class 1-2 ONLY (per spec - Rewards section)
      ClassItem(
        title: 'Daily Goals',
        subtitle: 'Track Progress',
        pageBuilder: () => DailyGoalsPage(),
        category: 'Games & Quiz',
        emoji: '🎯',
        gradient: [Color(0xFF14B8A6), Color(0xFF2DD4BF)],
        ageGroups: [AgeGroupFilter.class1To2],
      ),

      // === MATH & LOGIC ===
      // Math NOT for Toddler (blocked per spec)
      // LKG/UKG: Numbers (1-100), Tables (2-10), Generic Math Questions, Money Concepts (coins)
      // Class 1-2: Tables (2-20), Math Problem & Solution
      // Class 3-4+: Full math features, Math Scanner

      // Math Problem & Solution: Class 1-2 and above (NOT Toddler, NOT LKG/UKG)
      ClassItem(
        title: 'Math Problems',
        subtitle: 'Solutions',
        pageBuilder: () => MathGridScreen(),
        category: 'Math & Logic',
        emoji: '🧮',
        gradient: [Color(0xFFFFE66D), Color(0xFFFFA94D)],
        ageGroups: [
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),
      // Math Questions (Generic): LKG/UKG and above (basic for LKG/UKG)
      ClassItem(
        title: 'Math Practice',
        subtitle: 'Questions',
        pageBuilder: () => MathQustionGridScreen(),
        category: 'Math & Logic',
        emoji: '🧮',
        gradient: [Color(0xFF56D97F), Color(0xFF81E89E)],
        ageGroups: [
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),
      // Money Concepts: LKG/UKG (coins only) and above
      ClassItem(
        title: 'Money Concepts',
        subtitle: 'Learn Currency',
        pageBuilder: () => MoneyConceptsPage(),
        category: 'Math & Logic',
        emoji: '💰',
        gradient: [Color(0xFF10B981), Color(0xFF34D399)],
        ageGroups: [
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),

      // === LITERACY ===
      // Toddler: NO Literacy (blocked per spec)
      // LKG/UKG: Sight Words, Listening Skills
      // Class 1-2: Reading Fluency, Sentence Formation, Spelling Practice

      // Sight Words: LKG/UKG and Class 1-2 ONLY
      ClassItem(
        title: 'Sight Words',
        subtitle: 'Common Words',
        pageBuilder: () => SightWordsPage(),
        category: 'Literacy',
        emoji: '👁️',
        gradient: [Color(0xFF56D97F), Color(0xFF81E89E)],
        ageGroups: [AgeGroupFilter.lkgUkg, AgeGroupFilter.class1To2],
      ),
      // Spelling Practice: Class 1-2 ONLY (per spec - Literacy FULL)
      ClassItem(
        title: 'Spelling Practice',
        subtitle: 'Learn Spelling',
        pageBuilder: () => SpellingPracticePage(),
        category: 'Literacy',
        emoji: '✏️',
        gradient: [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
        ageGroups: [AgeGroupFilter.class1To2],
      ),
      // Reading Fluency: Class 1-2 ONLY (per spec - Literacy FULL)
      ClassItem(
        title: 'Reading Fluency',
        subtitle: 'Read Stories',
        pageBuilder: () => ReadingFluencyPage(),
        category: 'Literacy',
        emoji: '📚',
        gradient: [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
        ageGroups: [AgeGroupFilter.class1To2],
      ),
      // Sentence Formation: Class 1-2 ONLY (per spec - Literacy FULL)
      ClassItem(
        title: 'Sentence Formation',
        subtitle: 'Make Sentences',
        pageBuilder: () => SentenceFormationPage(),
        category: 'Literacy',
        emoji: '📝',
        gradient: [Color(0xFF45B7D1), Color(0xFF74C9DB)],
        ageGroups: [AgeGroupFilter.class1To2],
      ),
      // Listening Skills: LKG/UKG ONLY (per spec)
      ClassItem(
        title: 'Listening Skills',
        subtitle: 'Listen & Learn',
        pageBuilder: () => ListeningSkillsPage(),
        category: 'Literacy',
        emoji: '👂',
        gradient: [Color(0xFFEC4899), Color(0xFFF472B6)],
        ageGroups: [AgeGroupFilter.lkgUkg],
      ),
      // Story Time: NOT in spec for any age - removing from Literacy
      // Voice Learning: NOT in spec - removing

      // === WRITING ===
      // Toddler: NO Writing (blocked per spec) - only Drawing allowed under Creativity
      // LKG/UKG: Stroke Order, Fine Motor Skills
      // Class 1-2: Cursive Writing, Writing Accuracy

      // Drawing: Toddler (Creativity), LKG/UKG+ - moved to Creativity for Toddler
      ClassItem(
        title: 'Kids Drawing',
        subtitle: 'Free Draw',
        pageBuilder: () => KidsDrowingScreen(),
        category: 'Writing',
        emoji: '🎨',
        gradient: [Color(0xFFA29BFE), Color(0xFF6C5CE7)],
        ageGroups: [
          AgeGroupFilter.toddler,
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),
      // Drawing Image: Toddler (Creativity), LKG/UKG+
      ClassItem(
        title: 'Drawing Image',
        subtitle: 'Trace & Draw',
        pageBuilder: () => DrowingScreen(),
        category: 'Writing',
        emoji: '🖼️',
        gradient: [Color(0xFFFF9FF3), Color(0xFFF368E0)],
        ageGroups: [
          AgeGroupFilter.toddler,
          AgeGroupFilter.lkgUkg,
          AgeGroupFilter.class1To2,
          AgeGroupFilter.class3To4,
          AgeGroupFilter.class5To6,
        ],
      ),
      // Cursive Writing: Class 1-2 ONLY (per spec)
      ClassItem(
        title: 'Cursive Writing',
        subtitle: 'Flowing Letters',
        pageBuilder: () => CursiveWritingPage(),
        category: 'Writing',
        emoji: '📜',
        gradient: [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
        ageGroups: [AgeGroupFilter.class1To2],
      ),
      // Handwriting: NOT in spec - removing or keeping for LKG/UKG only
      // Writing Accuracy: Class 1-2 ONLY (per spec)
      ClassItem(
        title: 'Writing Accuracy',
        subtitle: 'Perfect Writing',
        pageBuilder: () => WritingAccuracyPage(),
        category: 'Writing',
        emoji: '✅',
        gradient: [Color(0xFF10B981), Color(0xFF34D399)],
        ageGroups: [AgeGroupFilter.class1To2],
      ),

      // === CREATIVITY ===
      // Toddler: Drawing Page, Drawing Image Page
      // LKG/UKG: Craft Ideas, Dance Activities, Story Creation
      // Class 1-2+: Story Creation

      // Music Learning: Removed from home screen
      // Rhythm Learning: Removed from home screen
      // Dance Activities: LKG/UKG ONLY (per spec)
// Story Creation: LKG/UKG ONLY (per spec)
      ClassItem(
        title: 'Story Creation',
        subtitle: 'Build Stories',
        pageBuilder: () => StoryCreationPage(),
        category: 'Creativity',
        emoji: '📚',
        gradient: [Color(0xFF74B9FF), Color(0xFF0984E3)],
        ageGroups: [AgeGroupFilter.lkgUkg],
      ),
      // Imagination: NOT in spec - removing
      // Animated Videos: Removed from home screen

      // === KNOWLEDGE ===
      // Class 1-2: Science Basics, Environmental Studies, Social Awareness
      // Class 3-4: STEM Hub, Simple Experiments, Design Thinking (Projects section)
      // Class 5-6: Global Awareness (World Map, Countries, Famous Places, Global Cultures)

      // Science Basics: Class 1-2 ONLY (per spec)
      ClassItem(
        title: 'Science Basics',
        subtitle: 'Learn Science',
        pageBuilder: () => ScienceBasicsPage(),
        category: 'Knowledge',
        emoji: '🔬',
        gradient: [Color(0xFF74B9FF), Color(0xFF0984E3)],
        ageGroups: [AgeGroupFilter.class1To2],
      ),
      // Environmental Studies: Class 1-2 ONLY (per spec)
      ClassItem(
        title: 'Environment',
        subtitle: 'Save Earth',
        pageBuilder: () => EnvironmentalStudiesPage(),
        category: 'Knowledge',
        emoji: '🌍',
        gradient: [Color(0xFF55EFC4), Color(0xFF00B894)],
        ageGroups: [AgeGroupFilter.class1To2],
      ),
      // Social Awareness: Class 1-2 ONLY (per spec)
      ClassItem(
        title: 'Social Skills',
        subtitle: 'Society & People',
        pageBuilder: () => SocialAwarenessPage(),
        category: 'Knowledge',
        emoji: '🤝',
        gradient: [Color(0xFFEC4899), Color(0xFFF472B6)],
        ageGroups: [AgeGroupFilter.class1To2],
      ),
      // World Map: Class 5-6 ONLY (per spec - Global Awareness)
      ClassItem(
        title: 'World Map',
        subtitle: 'Continents',
        pageBuilder: () => WorldMapPage(),
        category: 'Knowledge',
        emoji: '🗺️',
        gradient: [Color(0xFF45B7D1), Color(0xFF74C9DB)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),
      // Famous Places: Class 5-6 ONLY (per spec - Global Awareness)
      ClassItem(
        title: 'Famous Places',
        subtitle: 'World Wonders',
        pageBuilder: () => FamousPlacesPage(),
        category: 'Knowledge',
        emoji: '🏛️',
        gradient: [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),
      // Mini Projects: Class 3-4 ONLY (per spec - Projects section)
      ClassItem(
        title: 'Mini Projects',
        subtitle: 'Hands-on Learning',
        pageBuilder: () => MiniProjectsPage(),
        category: 'Knowledge',
        emoji: '🔬',
        gradient: [Color(0xFFEC4899), Color(0xFFF472B6)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),
      // Experiments/Home Experiments: NOT in spec for Knowledge - removed

      // === LIFE SKILLS ===
      // Class 3-4: Hygiene Habits, Time Management, Safety Skills, Money Habits
      // Class 5-6: NOT in spec for Life Skills

      // Hygiene Habits: Class 3-4 ONLY (per spec)
      ClassItem(
        title: 'Hygiene Habits',
        subtitle: 'Stay Clean',
        pageBuilder: () => HygieneHabitsPage(),
        category: 'Life Skills',
        emoji: '🧼',
        gradient: [Color(0xFF74B9FF), Color(0xFF0984E3)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),
      // Time Management: Class 3-4 ONLY (per spec)
      ClassItem(
        title: 'Time Management',
        subtitle: 'Use Time Well',
        pageBuilder: () => TimeManagementPage(),
        category: 'Life Skills',
        emoji: '⏰',
        gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),
      // Safety Skills: Class 3-4 ONLY (per spec)
      ClassItem(
        title: 'Safety Skills',
        subtitle: 'Stay Safe',
        pageBuilder: () => SafetySkillsPage(),
        category: 'Life Skills',
        emoji: '🦺',
        gradient: [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),
      // Money Habits: Class 3-4 ONLY (per spec)
      ClassItem(
        title: 'Money Habits',
        subtitle: 'Save & Spend',
        pageBuilder: () => MoneyHabitsPage(),
        category: 'Life Skills',
        emoji: '💵',
        gradient: [Color(0xFF56D97F), Color(0xFF81E89E)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),
      // Daily Skills: NOT in spec - removed
      // Good Habits: Toddler ONLY - SEL (per spec)
      ClassItem(
        title: 'Good Habits',
        subtitle: 'Daily Routines',
        pageBuilder: () => GoodHabitsPage(),
        category: 'Life Skills',
        emoji: '✅',
        gradient: [Color(0xFF45B7D1), Color(0xFF74C9DB)],
        ageGroups: [AgeGroupFilter.toddler],
      ),
      // Self Control: NOT in spec for Life Skills - removed

      // === HEALTH ===
      // Class 5-6 ONLY: Nutrition Learning, Exercise & Fitness, Mental Health Basics, Body Safety
      // Toddler: Mindfulness (stories based) - under SEL
      // LKG/UKG: Emotional Intelligence, Empathy Learning, Confidence Building - under SEL
      // Class 1-2: Emotional Regulation, Self Awareness - under SEL

      // Nutrition Learning: Class 5-6 ONLY (per spec)
      ClassItem(
        title: 'Nutrition',
        subtitle: 'Eat Healthy',
        pageBuilder: () => NutritionLearningPage(),
        category: 'Health',
        emoji: '🥗',
        gradient: [Color(0xFF81ECEC), Color(0xFF00CEC9)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),
      // Exercise & Fitness: Class 5-6 ONLY (per spec)
      ClassItem(
        title: 'Exercise',
        subtitle: 'Stay Active',
        pageBuilder: () => ExerciseFitnessPage(),
        category: 'Health',
        emoji: '🏃',
        gradient: [Color(0xFF56D97F), Color(0xFF81E89E)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),
      // Mental Health Basics: Class 5-6 ONLY (per spec)
      ClassItem(
        title: 'Mental Health',
        subtitle: 'Feel Good',
        pageBuilder: () => MentalHealthBasicsPage(),
        category: 'Health',
        emoji: '🧠',
        gradient: [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),
      // Body Safety: Class 5-6 ONLY (per spec)
      ClassItem(
        title: 'Body Safety',
        subtitle: 'Safe & Protected',
        pageBuilder: () => BodySafetyPage(),
        category: 'Health',
        emoji: '🛡️',
        gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),

      // === SEL (Social Emotional Learning) ===
      // Toddler: Good Habits, Mindfulness (stories based)
      // LKG/UKG: Emotional Intelligence, Empathy Learning, Confidence Building
      // Class 1-2: Emotional Regulation, Self Awareness

      // Mindfulness: Toddler ONLY - SEL (per spec)
      ClassItem(
        title: 'Mindfulness',
        subtitle: 'Be Present',
        pageBuilder: () => MindfulnessPage(),
        category: 'Health',
        emoji: '🧘',
        gradient: [Color(0xFF74B9FF), Color(0xFF0984E3)],
        ageGroups: [AgeGroupFilter.toddler],
      ),
      // Empathy Learning: LKG/UKG ONLY - SEL (per spec)
      ClassItem(
        title: 'Empathy Learning',
        subtitle: 'Understand Others',
        pageBuilder: () => EmpathyLearningPage(),
        category: 'Health',
        emoji: '🤝',
        gradient: [Color(0xFF81ECEC), Color(0xFF00CEC9)],
        ageGroups: [AgeGroupFilter.lkgUkg],
      ),
      // Confidence Building: LKG/UKG ONLY - SEL (per spec)
      ClassItem(
        title: 'Confidence',
        subtitle: 'Be Confident',
        pageBuilder: () => ConfidenceBuildingPage(),
        category: 'Health',
        emoji: '💪',
        gradient: [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
        ageGroups: [AgeGroupFilter.lkgUkg],
      ),
      // Emotional Regulation: Class 1-2 ONLY - SEL (per spec)
      ClassItem(
        title: 'Calm Down',
        subtitle: 'Manage Feelings',
        pageBuilder: () => EmotionalRegulationPage(),
        category: 'Health',
        emoji: '🧘',
        gradient: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
        ageGroups: [AgeGroupFilter.class1To2],
      ),
      // Self Awareness: Class 1-2 ONLY - SEL (per spec)
      ClassItem(
        title: 'Know Yourself',
        subtitle: 'Self Awareness',
        pageBuilder: () => SelfAwarenessPage(),
        category: 'Health',
        emoji: '🪞',
        gradient: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
        ageGroups: [AgeGroupFilter.class1To2],
      ),

      // === COGNITIVE (Class 1-2) ===
      // Focus Improvement: Class 1-2 ONLY (per spec)
      ClassItem(
        title: 'Focus Improvement',
        subtitle: 'Concentrate Better',
        pageBuilder: () => FocusImprovementPage(),
        category: 'Health',
        emoji: '🎯',
        gradient: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
        ageGroups: [AgeGroupFilter.class1To2],
      ),
      // Attention Training: Class 1-2 ONLY (per spec)
      ClassItem(
        title: 'Attention Training',
        subtitle: 'Stay Focused',
        pageBuilder: () => AttentionTrainingPage(),
        category: 'Health',
        emoji: '👁️',
        gradient: [Color(0xFF06B6D4), Color(0xFF22D3EE)],
        ageGroups: [AgeGroupFilter.class1To2],
      ),

      // === CULTURE ===
      // Culture is NOT in spec for any age group - removing all culture items
      // Global Cultures: Class 5-6 ONLY (per spec - Global Awareness section)
      ClassItem(
        title: 'Global Cultures',
        subtitle: 'World Traditions',
        pageBuilder: () => GlobalCulturesPage(),
        category: 'Culture',
        emoji: '🌏',
        gradient: [Color(0xFF74B9FF), Color(0xFF0984E3)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),

      // Avatar Shop, Flashcards, PDF Downloads, Custom Themes, Infographics, Learning Path: NOT in spec - removed

      // === EXECUTIVE FUNCTION === (Class 3-4 ONLY per spec)
      // Planning Skills, Goal Setting, Task Sequencing, Working Memory
      ClassItem(
        title: 'Planning Skills',
        subtitle: 'Plan Your Tasks',
        pageBuilder: () => PlanningSkillsPage(),
        category: 'Life Skills',
        emoji: '📋',
        gradient: [Color(0xFF6366F1), Color(0xFF818CF8)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),
      ClassItem(
        title: 'Goal Setting',
        subtitle: 'Set & Achieve Goals',
        pageBuilder: () => GoalSettingPage(),
        category: 'Life Skills',
        emoji: '🎯',
        gradient: [Color(0xFF10B981), Color(0xFF34D399)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),
      ClassItem(
        title: 'Task Sequencing',
        subtitle: 'Order Your Work',
        pageBuilder: () => TaskSequencingPage(),
        category: 'Life Skills',
        emoji: '📊',
        gradient: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),
      ClassItem(
        title: 'Working Memory',
        subtitle: 'Train Your Brain',
        pageBuilder: () => WorkingMemoryPage(),
        category: 'Life Skills',
        emoji: '🧠',
        gradient: [Color(0xFFEC4899), Color(0xFFF472B6)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),

      // === STEM (Intro) === (Class 3-4 ONLY per spec)
      // STEM Hub, Simple Experiments, Design Thinking
      ClassItem(
        title: 'STEM Hub',
        subtitle: 'Science & Tech',
        pageBuilder: () => StemHubPage(),
        category: 'Knowledge',
        emoji: '🔬',
        gradient: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),
      ClassItem(
        title: 'Simple Experiments',
        subtitle: 'Learn by Doing',
        pageBuilder: () => SimpleExperimentsPage(),
        category: 'Knowledge',
        emoji: '🧪',
        gradient: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),
      ClassItem(
        title: 'Design Thinking',
        subtitle: 'Creative Problem Solving',
        pageBuilder: () => DesignThinkingPage(),
        category: 'Knowledge',
        emoji: '💡',
        gradient: [Color(0xFF14B8A6), Color(0xFF2DD4BF)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),

      // === DIGITAL LITERACY === (Class 3-4 ONLY per spec)
      // Computer Awareness, Keyboard & Mouse, Internet Safety, Digital Etiquette
      ClassItem(
        title: 'Computer Awareness',
        subtitle: 'Know Your Computer',
        pageBuilder: () => ComputerAwarenessPage(),
        category: 'Knowledge',
        emoji: '💻',
        gradient: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),
      ClassItem(
        title: 'Keyboard & Mouse',
        subtitle: 'Master Input Devices',
        pageBuilder: () => KeyboardMousePage(),
        category: 'Knowledge',
        emoji: '⌨️',
        gradient: [Color(0xFF64748B), Color(0xFF94A3B8)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),
      ClassItem(
        title: 'Internet Safety',
        subtitle: 'Stay Safe Online',
        pageBuilder: () => InternetSafetyPage(),
        category: 'Knowledge',
        emoji: '🔒',
        gradient: [Color(0xFFEF4444), Color(0xFFF87171)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),
      ClassItem(
        title: 'Digital Etiquette',
        subtitle: 'Online Manners',
        pageBuilder: () => DigitalEtiquettePage(),
        category: 'Knowledge',
        emoji: '🤝',
        gradient: [Color(0xFF22C55E), Color(0xFF4ADE80)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),

      // === ASSESSMENT === (Class 3-4 ONLY per spec)
      // Skill Evaluation
      ClassItem(
        title: 'Skill Evaluation',
        subtitle: 'Test Your Skills',
        pageBuilder: () => SkillEvaluationPage(),
        category: 'Games & Quiz',
        emoji: '📝',
        gradient: [Color(0xFFD946EF), Color(0xFFE879F9)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),

      // === PROJECTS === (Class 3-4 ONLY per spec)
      // DIY Learning, Mini Projects (already added above)
      ClassItem(
        title: 'DIY Learning',
        subtitle: 'Do It Yourself',
        pageBuilder: () => DiyLearningPage(),
        category: 'Knowledge',
        emoji: '🛠️',
        gradient: [Color(0xFFF97316), Color(0xFFFB923C)],
        ageGroups: [AgeGroupFilter.class3To4],
      ),

      // === STEM ADVANCED === (Class 5-6 ONLY per spec)
      // Engineering for Kids, STEM Challenges, STEAM Page
      ClassItem(
        title: 'Engineering for Kids',
        subtitle: 'Build & Create',
        pageBuilder: () => EngineeringKidsPage(),
        category: 'Knowledge',
        emoji: '🔧',
        gradient: [Color(0xFF0891B2), Color(0xFF22D3EE)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),
      ClassItem(
        title: 'STEM Challenges',
        subtitle: 'Problem Solving',
        pageBuilder: () => StemChallengesPage(),
        category: 'Knowledge',
        emoji: '🏆',
        gradient: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),
      ClassItem(
        title: 'STEAM Page',
        subtitle: 'Science, Tech, Art & Math',
        pageBuilder: () => SteamPage(),
        category: 'Knowledge',
        emoji: '🚀',
        gradient: [Color(0xFFDB2777), Color(0xFFF472B6)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),

      // === METACOGNITION === (Class 5-6 ONLY per spec)
      // Think About Thinking, Self Reflection, Learning Strategy
      ClassItem(
        title: 'Think About Thinking',
        subtitle: 'How You Learn',
        pageBuilder: () => ThinkAboutThinkingPage(),
        category: 'Life Skills',
        emoji: '🤔',
        gradient: [Color(0xFF6366F1), Color(0xFF818CF8)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),
      ClassItem(
        title: 'Self Reflection',
        subtitle: 'Know Your Mind',
        pageBuilder: () => SelfReflectionPage(),
        category: 'Life Skills',
        emoji: '🪞',
        gradient: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),
      ClassItem(
        title: 'Learning Strategy',
        subtitle: 'Study Smart',
        pageBuilder: () => LearningStrategyPage(),
        category: 'Life Skills',
        emoji: '📚',
        gradient: [Color(0xFF10B981), Color(0xFF34D399)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),

      // === SUSTAINABILITY === (Class 5-6 ONLY per spec)
      // Climate Awareness, Recycling, Sustainable Habits
      ClassItem(
        title: 'Climate Awareness',
        subtitle: 'Protect Our Planet',
        pageBuilder: () => ClimateAwarenessPage(),
        category: 'Knowledge',
        emoji: '🌍',
        gradient: [Color(0xFF059669), Color(0xFF34D399)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),
      ClassItem(
        title: 'Recycling',
        subtitle: 'Reduce, Reuse, Recycle',
        pageBuilder: () => RecyclingKidsPage(),
        category: 'Knowledge',
        emoji: '♻️',
        gradient: [Color(0xFF16A34A), Color(0xFF4ADE80)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),
      ClassItem(
        title: 'Sustainable Habits',
        subtitle: 'Go Green',
        pageBuilder: () => SustainableHabitsPage(),
        category: 'Knowledge',
        emoji: '🌱',
        gradient: [Color(0xFF65A30D), Color(0xFFA3E635)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),

      // === SOCIAL STUDIES === (Class 5-6 ONLY per spec)
      // Citizenship, Rights & Duties, Family & Relationships
      ClassItem(
        title: 'Citizenship',
        subtitle: 'Be a Good Citizen',
        pageBuilder: () => CitizenshipBasicsPage(),
        category: 'Knowledge',
        emoji: '🏛️',
        gradient: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),
      ClassItem(
        title: 'Rights & Duties',
        subtitle: 'Your Responsibilities',
        pageBuilder: () => RightsDutiesPage(),
        category: 'Knowledge',
        emoji: '⚖️',
        gradient: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),
      ClassItem(
        title: 'Family & Relationships',
        subtitle: 'Social Bonds',
        pageBuilder: () => FamilyRelationshipsPage(),
        category: 'Health',
        emoji: '👨‍👩‍👧‍👦',
        gradient: [Color(0xFFEC4899), Color(0xFFF9A8D4)],
        ageGroups: [AgeGroupFilter.class5To6],
      ),

      // Parent/Teacher modules removed from home screen - they are shown in Drawer only
    ]);

    _updateDisplayItems();
  }

  AgeGroupFilter _getCurrentAgeFilter() {
    switch (_ageService.currentAgeGroup.value) {
      case AgeGroup.toddler:
        return AgeGroupFilter.toddler;
      case AgeGroup.lkgUkg:
        return AgeGroupFilter.lkgUkg;
      case AgeGroup.class1To2:
        return AgeGroupFilter.class1To2;
      case AgeGroup.class3To4:
        return AgeGroupFilter.class3To4;
      case AgeGroup.class5To6:
        return AgeGroupFilter.class5To6;
    }
  }

  void _updateDisplayItems() {
    final currentAgeFilter = _getCurrentAgeFilter();

    var items = classItems.where((item) {
      return item.ageGroups.contains(AgeGroupFilter.all) ||
          item.ageGroups.contains(currentAgeFilter);
    }).toList();

    if (searchQuery.value.isNotEmpty) {
      items = items
          .where(
            (item) =>
                item.title.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                item.subtitle.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
          )
          .toList();
    }

    displayItems.assignAll(items);

    // Update categorized items
    final Map<String, List<ClassItem>> catItems = {};
    for (var item in items) {
      if (!catItems.containsKey(item.category)) {
        catItems[item.category] = [];
      }
      catItems[item.category]!.add(item);
    }
    categorizedItems.assignAll(catItems);
  }

  List<ClassItem> get filteredItems => displayItems;

  // Get items by category in order
  List<MapEntry<String, List<ClassItem>>> get orderedCategories {
    final result = <MapEntry<String, List<ClassItem>>>[];
    for (var cat in categoryOrder) {
      if (categorizedItems.containsKey(cat) &&
          categorizedItems[cat]!.isNotEmpty) {
        result.add(MapEntry(cat, categorizedItems[cat]!));
      }
    }
    return result;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }
}
