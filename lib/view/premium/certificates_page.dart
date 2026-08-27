import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/services/speech_recognition_service.dart';
import 'package:jiyan_learning/services/tts_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:jiyan_learning/services/certificate_vault.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class CertificatesPage extends StatefulWidget {
  const CertificatesPage({Key? key}) : super(key: key);

  @override
  State<CertificatesPage> createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late final SpeechRecognitionService speechService;
  String _searchQuery = '';
  AnimationController? _waveController;
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;
  bool _isInitialized = false;

  // Card gradients matching home screen style
  final List<List<Color>> cardGradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
    [Color(0xFF56D97F), Color(0xFF81E89E)],
    [Color(0xFF45B7D1), Color(0xFF74C9DB)],
    [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
    [Color(0xFFFF6EB4), Color(0xFFFF9ECE)],
    [Color(0xFFFFE66D), Color(0xFFFFF59D)],
    [Color(0xFF4ECDC4), Color(0xFF7EDDD6)],
  ];

  final List<Map<String, dynamic>> _allCertificates = [
    // ========== NUMBERS & MATH ==========
    {
      'title': 'Numbers Master',
      'description': 'Complete all numbers 1-100',
      'icon': '🔢',
      'color': const Color(0xFFFF6B6B),
      'progressKey': ProgressService.kNumbers,
      'requirement': 100,
    },
    {
      'title': 'Tables Genius',
      'description': 'Master multiplication tables 2-20',
      'icon': '✖️',
      'color': const Color(0xFF56D97F),
      'progressKey': ProgressService.kTables,
      'requirement': 20,
    },
    {
      'title': 'Addition Pro',
      'description': 'Complete addition practice',
      'icon': '➕',
      'color': const Color(0xFF4CAF50),
      'progressKey': ProgressService.kMathAddition,
      'requirement': 50,
    },
    {
      'title': 'Subtraction Pro',
      'description': 'Complete subtraction practice',
      'icon': '➖',
      'color': const Color(0xFFE91E63),
      'progressKey': ProgressService.kMathSubtraction,
      'requirement': 50,
    },
    {
      'title': 'Multiplication Pro',
      'description': 'Complete multiplication practice',
      'icon': '✖️',
      'color': const Color(0xFF9C27B0),
      'progressKey': ProgressService.kMathMultiplication,
      'requirement': 50,
    },
    {
      'title': 'Division Pro',
      'description': 'Complete division practice',
      'icon': '➗',
      'color': const Color(0xFF00BCD4),
      'progressKey': ProgressService.kMathDivision,
      'requirement': 50,
    },
    {
      'title': 'Math Problem Solver',
      'description': 'Solve math problems',
      'icon': '🧮',
      'color': const Color(0xFF3F51B5),
      'progressKey': 'progress_math_problems',
      'requirement': 30,
    },
    {
      'title': 'Math Scanner Expert',
      'description': 'Use math scanner feature',
      'icon': '📷',
      'color': const Color(0xFF607D8B),
      'progressKey': 'progress_math_scanner',
      'requirement': 20,
    },

    // ========== ALPHABET & LETTERS ==========
    {
      'title': 'Capital Letters Champion',
      'description': 'Learn all capital letters A-Z',
      'icon': '🅰️',
      'color': const Color(0xFF4ECDC4),
      'progressKey': ProgressService.kCapitalLetters,
      'requirement': 26,
    },
    {
      'title': 'Small Letters Expert',
      'description': 'Master all small letters a-z',
      'icon': '🔤',
      'color': const Color(0xFFFFAA5A),
      'progressKey': ProgressService.kSmallLetters,
      'requirement': 26,
    },
    {
      'title': 'Alphabet Words Whiz',
      'description': 'Learn words for all alphabets',
      'icon': '📖',
      'color': const Color(0xFF3F51B5),
      'progressKey': ProgressService.kAlphabetWords,
      'requirement': 26,
    },
    {
      'title': 'Hindi Scholar',
      'description': 'Complete Hindi letters learning',
      'icon': '🇮🇳',
      'color': const Color(0xFFA78BFA),
      'progressKey': ProgressService.kHindiLetters,
      'requirement': 49,
    },

    // ========== LEARNING SETS ==========
    {
      'title': 'Animal Expert',
      'description': 'Learn all animal names',
      'icon': '🦁',
      'color': const Color(0xFFFF6EB4),
      'progressKey': ProgressService.kAnimals,
      'requirement': 20,
    },
    {
      'title': 'Bird Watcher',
      'description': 'Learn all bird names',
      'icon': '🐦',
      'color': const Color(0xFF8BC34A),
      'progressKey': ProgressService.kBirds,
      'requirement': 20,
    },
    {
      'title': 'Fruit Lover',
      'description': 'Learn all fruit names',
      'icon': '🍎',
      'color': const Color(0xFFFF5722),
      'progressKey': ProgressService.kFruits,
      'requirement': 20,
    },
    {
      'title': 'Veggie Expert',
      'description': 'Learn all vegetable names',
      'icon': '🥕',
      'color': const Color(0xFF4CAF50),
      'progressKey': ProgressService.kVegetables,
      'requirement': 20,
    },
    {
      'title': 'Flower Garden',
      'description': 'Learn all flower names',
      'icon': '🌸',
      'color': const Color(0xFFE91E63),
      'progressKey': ProgressService.kFlowers,
      'requirement': 15,
    },
    {
      'title': 'Color Artist',
      'description': 'Learn all colors',
      'icon': '🎨',
      'color': const Color(0xFF9C27B0),
      'progressKey': ProgressService.kColors,
      'requirement': 15,
    },
    {
      'title': 'Body Parts Pro',
      'description': 'Learn all body parts',
      'icon': '👋',
      'color': const Color(0xFFFF9800),
      'progressKey': ProgressService.kBodyParts,
      'requirement': 20,
    },
    {
      'title': 'Calendar Master',
      'description': 'Learn all months',
      'icon': '📅',
      'color': const Color(0xFF2196F3),
      'progressKey': ProgressService.kMonths,
      'requirement': 12,
    },
    {
      'title': 'Week Days Wizard',
      'description': 'Learn all days of the week',
      'icon': '🗓️',
      'color': const Color(0xFF009688),
      'progressKey': ProgressService.kWeekDays,
      'requirement': 7,
    },
    {
      'title': 'Shape Master',
      'description': 'Learn all shapes',
      'icon': '🔷',
      'color': const Color(0xFF673AB7),
      'progressKey': ProgressService.kShapes,
      'requirement': 15,
    },
    {
      'title': 'Vehicle Expert',
      'description': 'Learn all vehicle names',
      'icon': '🚗',
      'color': const Color(0xFF795548),
      'progressKey': ProgressService.kVehicles,
      'requirement': 20,
    },
    {
      'title': 'Seasons Scholar',
      'description': 'Learn all seasons',
      'icon': '🌤️',
      'color': const Color(0xFF00BCD4),
      'progressKey': ProgressService.kSeasons,
      'requirement': 6,
    },

    // ========== CREATIVE & FUN ==========
    {
      'title': 'Poetry Star',
      'description': 'Complete all poems',
      'icon': '📝',
      'color': const Color(0xFF7C4DFF),
      'progressKey': ProgressService.kPoems,
      'requirement': 10,
    },
    {
      'title': 'Story Teller',
      'description': 'Complete all stories',
      'icon': '📚',
      'color': const Color(0xFFFF7043),
      'progressKey': ProgressService.kStories,
      'requirement': 10,
    },
    {
      'title': 'Rhyme Time',
      'description': 'Learn all rhymes',
      'icon': '🎵',
      'color': const Color(0xFFEC407A),
      'progressKey': ProgressService.kRhymes,
      'requirement': 10,
    },
    {
      'title': 'GK Champion',
      'description': 'Complete general knowledge',
      'icon': '🧠',
      'color': const Color(0xFF26A69A),
      'progressKey': ProgressService.kGK,
      'requirement': 30,
    },
    {
      'title': 'Coloring Artist',
      'description': 'Complete coloring activities',
      'icon': '🖍️',
      'color': const Color(0xFFAB47BC),
      'progressKey': ProgressService.kColoring,
      'requirement': 20,
    },

    // ========== DRAWING & ART ==========
    {
      'title': 'Drawing Master',
      'description': 'Complete drawing activities',
      'icon': '✏️',
      'color': const Color(0xFFFF4081),
      'progressKey': 'progress_drawing',
      'requirement': 20,
    },
    {
      'title': 'Image Tracer',
      'description': 'Trace and draw images',
      'icon': '🖼️',
      'color': const Color(0xFF00ACC1),
      'progressKey': 'progress_drawing_image',
      'requirement': 15,
    },
    {
      'title': 'Craft Creator',
      'description': 'Complete craft activities',
      'icon': '🎭',
      'color': const Color(0xFFFF6E40),
      'progressKey': 'progress_craft',
      'requirement': 10,
    },

    // ========== EARLY LEARNING (Toddler/LKG/UKG) ==========
    {
      'title': 'Sensory Explorer',
      'description': 'Complete sensory learning',
      'icon': '👆',
      'color': const Color(0xFFFFB74D),
      'progressKey': ProgressService.kSensoryLearning,
      'requirement': 15,
    },
    {
      'title': 'Visual Learner',
      'description': 'Complete visual learning',
      'icon': '👁️',
      'color': const Color(0xFF64B5F6),
      'progressKey': ProgressService.kVisualLearning,
      'requirement': 15,
    },
    {
      'title': 'Audio Learner',
      'description': 'Complete audio learning',
      'icon': '🔊',
      'color': const Color(0xFF81C784),
      'progressKey': ProgressService.kAudioLearning,
      'requirement': 15,
    },
    {
      'title': 'Kinesthetic Star',
      'description': 'Complete kinesthetic learning',
      'icon': '🤸',
      'color': const Color(0xFFBA68C8),
      'progressKey': ProgressService.kKinestheticLearning,
      'requirement': 15,
    },
    {
      'title': 'Play Expert',
      'description': 'Complete play-based learning',
      'icon': '🎮',
      'color': const Color(0xFFE57373),
      'progressKey': ProgressService.kPlayBasedLearning,
      'requirement': 15,
    },
    {
      'title': 'Little Explorer',
      'description': 'Complete exploratory learning',
      'icon': '🔭',
      'color': const Color(0xFF4DB6AC),
      'progressKey': ProgressService.kExploratoryLearning,
      'requirement': 15,
    },
    {
      'title': 'Discovery Pro',
      'description': 'Complete discovery learning',
      'icon': '🔍',
      'color': const Color(0xFFFFD54F),
      'progressKey': ProgressService.kDiscoveryLearning,
      'requirement': 15,
    },
    {
      'title': 'Montessori Master',
      'description': 'Complete Montessori learning',
      'icon': '🎓',
      'color': const Color(0xFF9575CD),
      'progressKey': ProgressService.kMontessoriLearning,
      'requirement': 15,
    },
    {
      'title': 'Activity Star',
      'description': 'Complete activity-based learning',
      'icon': '🎯',
      'color': const Color(0xFFFF8A65),
      'progressKey': ProgressService.kActivityBasedLearning,
      'requirement': 15,
    },
    {
      'title': 'Experience Expert',
      'description': 'Complete experiential learning',
      'icon': '🎪',
      'color': const Color(0xFF4FC3F7),
      'progressKey': ProgressService.kExperientialLearning,
      'requirement': 15,
    },

    // ========== LITERACY & READING ==========
    {
      'title': 'Phonics Pro',
      'description': 'Master letter sounds',
      'icon': '🔤',
      'color': const Color(0xFFFF7043),
      'progressKey': 'progress_phonics',
      'requirement': 26,
    },
    {
      'title': 'Sight Word Champion',
      'description': 'Learn common sight words',
      'icon': '👀',
      'color': const Color(0xFF5C6BC0),
      'progressKey': 'progress_sight_words',
      'requirement': 50,
    },
    {
      'title': 'Word Builder',
      'description': 'Build words from letters',
      'icon': '🔠',
      'color': const Color(0xFF26A69A),
      'progressKey': 'progress_word_building',
      'requirement': 30,
    },
    {
      'title': 'Spelling Bee',
      'description': 'Master spelling practice',
      'icon': '🐝',
      'color': const Color(0xFFFFCA28),
      'progressKey': 'progress_spelling',
      'requirement': 50,
    },
    {
      'title': 'Reading Fluency Star',
      'description': 'Achieve reading fluency',
      'icon': '📗',
      'color': const Color(0xFF66BB6A),
      'progressKey': 'progress_reading_fluency',
      'requirement': 20,
    },
    {
      'title': 'Sentence Maker',
      'description': 'Form complete sentences',
      'icon': '✍️',
      'color': const Color(0xFF7E57C2),
      'progressKey': 'progress_sentence_formation',
      'requirement': 30,
    },
    {
      'title': 'Listening Expert',
      'description': 'Complete listening skills',
      'icon': '👂',
      'color': const Color(0xFF42A5F5),
      'progressKey': 'progress_listening',
      'requirement': 20,
    },

    // ========== WRITING SKILLS ==========
    {
      'title': 'Stroke Order Master',
      'description': 'Learn correct stroke order',
      'icon': '📝',
      'color': const Color(0xFF8D6E63),
      'progressKey': 'progress_stroke_order',
      'requirement': 26,
    },
    {
      'title': 'Fine Motor Pro',
      'description': 'Complete fine motor activities',
      'icon': '🤲',
      'color': const Color(0xFFAED581),
      'progressKey': 'progress_fine_motor',
      'requirement': 20,
    },
    {
      'title': 'Cursive Writer',
      'description': 'Master cursive writing',
      'icon': '🖋️',
      'color': const Color(0xFF90A4AE),
      'progressKey': 'progress_cursive',
      'requirement': 26,
    },
    {
      'title': 'Handwriting Pro',
      'description': 'Complete handwriting practice',
      'icon': '✒️',
      'color': const Color(0xFFCE93D8),
      'progressKey': 'progress_handwriting',
      'requirement': 30,
    },

    // ========== GAMES & INTERACTIVE ==========
    {
      'title': 'Games Master',
      'description': 'Complete games hub activities',
      'icon': '🎮',
      'color': const Color(0xFFEF5350),
      'progressKey': 'progress_games_hub',
      'requirement': 20,
    },
    {
      'title': 'Quiz Champion',
      'description': 'Complete quiz challenges',
      'icon': '❓',
      'color': const Color(0xFF42A5F5),
      'progressKey': 'progress_quiz',
      'requirement': 30,
    },
    {
      'title': 'Drag & Drop Pro',
      'description': 'Complete drag & drop games',
      'icon': '🎯',
      'color': const Color(0xFF66BB6A),
      'progressKey': 'progress_drag_drop',
      'requirement': 20,
    },
    {
      'title': 'Matching Expert',
      'description': 'Complete matching games',
      'icon': '🃏',
      'color': const Color(0xFFAB47BC),
      'progressKey': 'progress_matching_game',
      'requirement': 20,
    },
    {
      'title': 'Tracing Star',
      'description': 'Complete tracing activities',
      'icon': '✍️',
      'color': const Color(0xFF26C6DA),
      'progressKey': 'progress_tracing',
      'requirement': 26,
    },
    {
      'title': 'Puzzle Solver',
      'description': 'Solve all puzzles',
      'icon': '🧩',
      'color': const Color(0xFFFFCA28),
      'progressKey': 'progress_puzzle',
      'requirement': 15,
    },
    {
      'title': 'Logic Master',
      'description': 'Complete logic games',
      'icon': '🧠',
      'color': const Color(0xFF7E57C2),
      'progressKey': 'progress_logic_games',
      'requirement': 20,
    },
    {
      'title': 'Quiz Battle Winner',
      'description': 'Win quiz battles',
      'icon': '⚔️',
      'color': const Color(0xFFFF7043),
      'progressKey': 'progress_quiz_battle',
      'requirement': 10,
    },
    {
      'title': 'Daily Goals Achiever',
      'description': 'Complete daily goals',
      'icon': '🎯',
      'color': const Color(0xFF4CAF50),
      'progressKey': 'progress_daily_goals',
      'requirement': 30,
    },

    // ========== SCIENCE & KNOWLEDGE ==========
    {
      'title': 'Science Explorer',
      'description': 'Complete science basics',
      'icon': '🔬',
      'color': const Color(0xFF00897B),
      'progressKey': 'progress_science',
      'requirement': 20,
    },
    {
      'title': 'Environment Hero',
      'description': 'Learn about environment',
      'icon': '🌍',
      'color': const Color(0xFF43A047),
      'progressKey': 'progress_environment',
      'requirement': 15,
    },
    {
      'title': 'World Explorer',
      'description': 'Learn world map',
      'icon': '🗺️',
      'color': const Color(0xFF1E88E5),
      'progressKey': 'progress_world_map',
      'requirement': 10,
    },
    {
      'title': 'Flag Master',
      'description': 'Learn countries & flags',
      'icon': '🏳️',
      'color': const Color(0xFF5E35B1),
      'progressKey': 'progress_flags',
      'requirement': 50,
    },
    {
      'title': 'Famous Places Expert',
      'description': 'Learn famous landmarks',
      'icon': '🏛️',
      'color': const Color(0xFFD81B60),
      'progressKey': 'progress_famous_places',
      'requirement': 20,
    },
    {
      'title': 'Culture Explorer',
      'description': 'Learn global cultures',
      'icon': '🌐',
      'color': const Color(0xFF00ACC1),
      'progressKey': 'progress_cultures',
      'requirement': 15,
    },

    // ========== STEM & PROJECTS ==========
    {
      'title': 'STEM Star',
      'description': 'Complete STEM activities',
      'icon': '⚙️',
      'color': const Color(0xFF3949AB),
      'progressKey': 'progress_stem',
      'requirement': 20,
    },
    {
      'title': 'Mini Project Pro',
      'description': 'Complete mini projects',
      'icon': '🔧',
      'color': const Color(0xFF00796B),
      'progressKey': 'progress_mini_projects',
      'requirement': 10,
    },
    {
      'title': 'DIY Master',
      'description': 'Complete DIY activities',
      'icon': '🛠️',
      'color': const Color(0xFF8D6E63),
      'progressKey': 'progress_diy',
      'requirement': 10,
    },
    {
      'title': 'Experiment Expert',
      'description': 'Complete experiments',
      'icon': '🧪',
      'color': const Color(0xFF7CB342),
      'progressKey': 'progress_experiments',
      'requirement': 15,
    },
    {
      'title': 'Design Thinker',
      'description': 'Complete design thinking',
      'icon': '💡',
      'color': const Color(0xFFFFB300),
      'progressKey': 'progress_design_thinking',
      'requirement': 10,
    },
    {
      'title': 'Young Engineer',
      'description': 'Complete engineering activities',
      'icon': '👷',
      'color': const Color(0xFF546E7A),
      'progressKey': 'progress_engineering',
      'requirement': 15,
    },

    // ========== LIFE SKILLS ==========
    {
      'title': 'Hygiene Hero',
      'description': 'Learn hygiene habits',
      'icon': '🧼',
      'color': const Color(0xFF29B6F6),
      'progressKey': 'progress_hygiene',
      'requirement': 15,
    },
    {
      'title': 'Time Manager',
      'description': 'Master time management',
      'icon': '⏰',
      'color': const Color(0xFF5C6BC0),
      'progressKey': 'progress_time_management',
      'requirement': 10,
    },
    {
      'title': 'Safety Expert',
      'description': 'Learn safety skills',
      'icon': '🦺',
      'color': const Color(0xFFEF5350),
      'progressKey': 'progress_safety',
      'requirement': 15,
    },
    {
      'title': 'Money Smart',
      'description': 'Learn money habits',
      'icon': '💰',
      'color': const Color(0xFF66BB6A),
      'progressKey': 'progress_money_habits',
      'requirement': 10,
    },
    {
      'title': 'Good Habits Star',
      'description': 'Learn good habits',
      'icon': '⭐',
      'color': const Color(0xFFFFCA28),
      'progressKey': 'progress_good_habits',
      'requirement': 20,
    },
    {
      'title': 'Life Skills Pro',
      'description': 'Complete daily life skills',
      'icon': '🏠',
      'color': const Color(0xFFAB47BC),
      'progressKey': 'progress_life_skills',
      'requirement': 15,
    },

    // ========== HEALTH & WELLNESS ==========
    {
      'title': 'Nutrition Expert',
      'description': 'Learn about nutrition',
      'icon': '🥗',
      'color': const Color(0xFF4CAF50),
      'progressKey': 'progress_nutrition',
      'requirement': 15,
    },
    {
      'title': 'Fitness Star',
      'description': 'Complete fitness activities',
      'icon': '🏃',
      'color': const Color(0xFFFF5722),
      'progressKey': 'progress_fitness',
      'requirement': 20,
    },
    {
      'title': 'Mental Health Hero',
      'description': 'Learn mental health basics',
      'icon': '💆',
      'color': const Color(0xFF9C27B0),
      'progressKey': 'progress_mental_health',
      'requirement': 10,
    },
    {
      'title': 'Body Safety Pro',
      'description': 'Learn body safety',
      'icon': '🛡️',
      'color': const Color(0xFF2196F3),
      'progressKey': 'progress_body_safety',
      'requirement': 10,
    },

    // ========== SOCIAL EMOTIONAL LEARNING ==========
    {
      'title': 'Mindfulness Master',
      'description': 'Complete mindfulness activities',
      'icon': '🧘',
      'color': const Color(0xFF26A69A),
      'progressKey': 'progress_mindfulness',
      'requirement': 15,
    },
    {
      'title': 'Emotion Expert',
      'description': 'Understand emotions',
      'icon': '😊',
      'color': const Color(0xFFFFCA28),
      'progressKey': 'progress_emotions',
      'requirement': 20,
    },
    {
      'title': 'Empathy Star',
      'description': 'Learn empathy skills',
      'icon': '💝',
      'color': const Color(0xFFE91E63),
      'progressKey': 'progress_empathy',
      'requirement': 15,
    },
    {
      'title': 'Confidence Builder',
      'description': 'Build self-confidence',
      'icon': '💪',
      'color': const Color(0xFFFF5722),
      'progressKey': 'progress_confidence',
      'requirement': 15,
    },
    {
      'title': 'Calm Master',
      'description': 'Learn emotional regulation',
      'icon': '😌',
      'color': const Color(0xFF00BCD4),
      'progressKey': 'progress_calm_down',
      'requirement': 10,
    },
    {
      'title': 'Self Aware Star',
      'description': 'Develop self-awareness',
      'icon': '🪞',
      'color': const Color(0xFF7E57C2),
      'progressKey': 'progress_self_awareness',
      'requirement': 15,
    },

    // ========== COGNITIVE SKILLS ==========
    {
      'title': 'Focus Master',
      'description': 'Improve focus & concentration',
      'icon': '🎯',
      'color': const Color(0xFF3F51B5),
      'progressKey': 'progress_focus',
      'requirement': 20,
    },
    {
      'title': 'Attention Pro',
      'description': 'Complete attention training',
      'icon': '👁️',
      'color': const Color(0xFF009688),
      'progressKey': 'progress_attention',
      'requirement': 20,
    },
    {
      'title': 'Memory Champion',
      'description': 'Train working memory',
      'icon': '🧠',
      'color': const Color(0xFF673AB7),
      'progressKey': 'progress_memory',
      'requirement': 20,
    },

    // ========== EXECUTIVE FUNCTION ==========
    {
      'title': 'Planning Pro',
      'description': 'Master planning skills',
      'icon': '📋',
      'color': const Color(0xFF5C6BC0),
      'progressKey': 'progress_planning',
      'requirement': 15,
    },
    {
      'title': 'Goal Setter',
      'description': 'Set and achieve goals',
      'icon': '🎯',
      'color': const Color(0xFFFF7043),
      'progressKey': 'progress_goal_setting',
      'requirement': 10,
    },
    {
      'title': 'Task Sequencer',
      'description': 'Master task sequencing',
      'icon': '📊',
      'color': const Color(0xFF26A69A),
      'progressKey': 'progress_task_sequencing',
      'requirement': 15,
    },
    {
      'title': 'Metacognition Master',
      'description': 'Think about thinking',
      'icon': '💭',
      'color': const Color(0xFF9C27B0),
      'progressKey': 'progress_metacognition',
      'requirement': 10,
    },
    {
      'title': 'Self Reflector',
      'description': 'Complete self-reflection',
      'icon': '🔮',
      'color': const Color(0xFF00ACC1),
      'progressKey': 'progress_self_reflection',
      'requirement': 10,
    },
    {
      'title': 'Learning Strategy Pro',
      'description': 'Master learning strategies',
      'icon': '📚',
      'color': const Color(0xFFFF9800),
      'progressKey': 'progress_learning_strategy',
      'requirement': 15,
    },

    // ========== DIGITAL LITERACY ==========
    {
      'title': 'Computer Whiz',
      'description': 'Learn computer awareness',
      'icon': '💻',
      'color': const Color(0xFF546E7A),
      'progressKey': 'progress_computer',
      'requirement': 15,
    },
    {
      'title': 'Keyboard Master',
      'description': 'Master keyboard & mouse',
      'icon': '⌨️',
      'color': const Color(0xFF78909C),
      'progressKey': 'progress_keyboard',
      'requirement': 20,
    },
    {
      'title': 'Internet Safety Pro',
      'description': 'Learn internet safety',
      'icon': '🔒',
      'color': const Color(0xFF43A047),
      'progressKey': 'progress_internet_safety',
      'requirement': 10,
    },
    {
      'title': 'Digital Citizen',
      'description': 'Learn digital etiquette',
      'icon': '🌐',
      'color': const Color(0xFF1E88E5),
      'progressKey': 'progress_digital_etiquette',
      'requirement': 10,
    },
    {
      'title': 'Screen Smart',
      'description': 'Learn screen responsibility',
      'icon': '📱',
      'color': const Color(0xFF7E57C2),
      'progressKey': 'progress_screen_responsibility',
      'requirement': 10,
    },

    // ========== SUSTAINABILITY ==========
    {
      'title': 'Climate Hero',
      'description': 'Learn climate awareness',
      'icon': '🌡️',
      'color': const Color(0xFF00897B),
      'progressKey': 'progress_climate',
      'requirement': 10,
    },
    {
      'title': 'Recycling Champion',
      'description': 'Learn recycling',
      'icon': '♻️',
      'color': const Color(0xFF4CAF50),
      'progressKey': 'progress_recycling',
      'requirement': 10,
    },
    {
      'title': 'Eco Warrior',
      'description': 'Learn sustainable habits',
      'icon': '🌱',
      'color': const Color(0xFF8BC34A),
      'progressKey': 'progress_sustainable',
      'requirement': 15,
    },

    // ========== SOCIAL STUDIES ==========
    {
      'title': 'Community Helper Expert',
      'description': 'Learn about community helpers',
      'icon': '👨‍🚒',
      'color': const Color(0xFFFF5722),
      'progressKey': 'progress_community_helpers',
      'requirement': 15,
    },
    {
      'title': 'Family & Friends',
      'description': 'Learn about relationships',
      'icon': '👨‍👩‍👧‍👦',
      'color': const Color(0xFFE91E63),
      'progressKey': 'progress_family',
      'requirement': 10,
    },
    {
      'title': 'Map Reader',
      'description': 'Learn maps & directions',
      'icon': '🧭',
      'color': const Color(0xFF00BCD4),
      'progressKey': 'progress_maps',
      'requirement': 10,
    },
    {
      'title': 'Good Citizen',
      'description': 'Learn citizenship basics',
      'icon': '🏛️',
      'color': const Color(0xFF3F51B5),
      'progressKey': 'progress_citizenship',
      'requirement': 10,
    },
    {
      'title': 'Rights & Duties Pro',
      'description': 'Learn rights and duties',
      'icon': '⚖️',
      'color': const Color(0xFF673AB7),
      'progressKey': 'progress_rights_duties',
      'requirement': 10,
    },

    // ========== MUSIC ==========
    {
      'title': 'Music Notes Master',
      'description': 'Learn music notes',
      'icon': '🎵',
      'color': const Color(0xFFE91E63),
      'progressKey': ProgressService.kMusicNotes,
      'requirement': 10,
    },
    {
      'title': 'Instrument Expert',
      'description': 'Learn music instruments',
      'icon': '🎸',
      'color': const Color(0xFF9C27B0),
      'progressKey': ProgressService.kMusicInstruments,
      'requirement': 15,
    },
    {
      'title': 'Music Facts Pro',
      'description': 'Learn music facts',
      'icon': '🎼',
      'color': const Color(0xFF673AB7),
      'progressKey': ProgressService.kMusicFacts,
      'requirement': 10,
    },
    {
      'title': 'Rhythm Master',
      'description': 'Master rhythm',
      'icon': '🥁',
      'color': const Color(0xFFFF5722),
      'progressKey': ProgressService.kRhythm,
      'requirement': 10,
    },
    {
      'title': 'Dance Star',
      'description': 'Complete dance activities',
      'icon': '💃',
      'color': const Color(0xFFFF4081),
      'progressKey': 'progress_dance',
      'requirement': 10,
    },

    // ========== ANIMATED LEARNING ==========
    {
      'title': 'Animated ABC Pro',
      'description': 'Complete animated ABC',
      'icon': '🔤',
      'color': const Color(0xFF42A5F5),
      'progressKey': ProgressService.kAnimatedABC,
      'requirement': 26,
    },
    {
      'title': 'Animated Numbers Pro',
      'description': 'Complete animated numbers',
      'icon': '🔢',
      'color': const Color(0xFF66BB6A),
      'progressKey': ProgressService.kAnimatedNumbers,
      'requirement': 20,
    },
    {
      'title': 'Animated Rhymes Star',
      'description': 'Watch animated rhymes',
      'icon': '🎬',
      'color': const Color(0xFFFFCA28),
      'progressKey': ProgressService.kAnimatedRhymes,
      'requirement': 10,
    },
    {
      'title': 'Animated Stories Star',
      'description': 'Watch animated stories',
      'icon': '📺',
      'color': const Color(0xFFEF5350),
      'progressKey': ProgressService.kAnimatedStories,
      'requirement': 10,
    },

    // ========== FLASHCARDS & WORKSHEETS ==========
    {
      'title': 'Flashcard Master',
      'description': 'Complete flashcard learning',
      'icon': '🃏',
      'color': const Color(0xFF5C6BC0),
      'progressKey': 'progress_flashcards',
      'requirement': 50,
    },
    {
      'title': 'Worksheet Champion',
      'description': 'Complete all worksheets',
      'icon': '📄',
      'color': const Color(0xFF26A69A),
      'progressKey': 'progress_worksheets',
      'requirement': 30,
    },

    // ========== SPECIAL ACHIEVEMENTS ==========
    {
      'title': 'First Steps',
      'description': 'Complete 10% of all content',
      'icon': '👣',
      'color': const Color(0xFF8BC34A),
      'isSpecial': true,
      'requirement': 10,
    },
    {
      'title': 'Rising Star',
      'description': 'Complete 25% of all content',
      'icon': '⭐',
      'color': const Color(0xFFFFB300),
      'isSpecial': true,
      'requirement': 25,
    },
    {
      'title': 'Super Learner',
      'description': 'Complete 50% of all content',
      'icon': '🌟',
      'color': const Color(0xFFFFD700),
      'isSpecial': true,
      'requirement': 50,
    },
    {
      'title': 'Knowledge King',
      'description': 'Complete 75% of all content',
      'icon': '👑',
      'color': const Color(0xFFFF6F00),
      'isSpecial': true,
      'requirement': 75,
    },
    {
      'title': 'Ultimate Champion',
      'description': 'Complete 100% of all content',
      'icon': '🏆',
      'color': const Color(0xFFFFD700),
      'isSpecial': true,
      'requirement': 100,
    },
    {
      'title': 'Perfect Streak',
      'description': '7 days learning streak',
      'icon': '🔥',
      'color': const Color(0xFFFF5722),
      'isSpecial': true,
      'requirement': 7,
    },
    {
      'title': 'Monthly Master',
      'description': '30 days learning streak',
      'icon': '📅',
      'color': const Color(0xFF9C27B0),
      'isSpecial': true,
      'requirement': 30,
    },
  ];

  List<Map<String, dynamic>> get _filteredCertificates {
    if (_searchQuery.isEmpty) {
      return _allCertificates;
    }
    return _allCertificates.where((cert) {
      final title = cert['title'].toString().toLowerCase();
      final description = cert['description'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || description.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    speechService = Get.find<SpeechRecognitionService>();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _waveController?.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFFF8E53),
                  Color(0xFFFFAA5A),
                ],
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
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    final progressService = ProgressService.to;
    final certificates = _filteredCertificates;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 8,
        shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 18.r,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x40FF6B6B),
                blurRadius: 15.r,
                offset: Offset(0, 5),
              ),
            ],
          ),
        ),
        title: FittedBox(
          // The title is a Row of separately styled words, so it cannot
          // ellipsize; scaling it down keeps the whole title readable on a
          // narrow phone instead of clipping the last word.
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Certifi',
                style: GoogleFonts.baloo2(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4.r,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
              ),
              Text(
                'cates',
                style: GoogleFonts.baloo2(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFE66D),
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4.r,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Floating bubbles
            ..._buildFloatingBubbles(),
            SafeArea(
              child: Column(
                children: [
                  // Search Bar
                  _buildSearchBar(),

                  // Certificates List
                  Expanded(
                    child: certificates.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: EdgeInsets.all(16.r),
                            itemCount: certificates.length,
                            itemBuilder: (context, index) {
                              final cert = certificates[index];
                              double progress;
                              bool isEarned;

                              if (cert['isSpecial'] == true) {
                                progress = progressService.getOverallProgress();
                                isEarned = progress >= cert['requirement'];
                              } else {
                                final completed = progressService
                                    .getCompletedCount(cert['progressKey']);
                                final total = cert['requirement'] as int;
                                progress = (completed / total * 100)
                                    .clamp(0, 100)
                                    .toDouble();
                                isEarned = completed >= total;
                              }

                              return AnimatedBuilder(
                                animation: _floatAnimation,
                                builder: (context, child) {
                                  final offset = index.isEven
                                      ? _floatAnimation.value * 0.4
                                      : -_floatAnimation.value * 0.4;
                                  return Transform.translate(
                                    offset: Offset(0, offset),
                                    child: child,
                                  );
                                },
                                child: _buildCertificateCard(
                                  cert,
                                  progress,
                                  isEarned,
                                  index,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingBubbles() {
    return List.generate(6, (index) {
      final random = math.Random(index);
      final size = 30.0 + random.nextDouble() * 50;
      final left = random.nextDouble() * MediaQuery.of(context).size.width;
      final startTop = random.nextDouble() * MediaQuery.of(context).size.height;

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + index * 0.15) % 1.0;
          final top =
              startTop - (progress * MediaQuery.of(context).size.height * 0.5);
          final opacity = (1 - progress).clamp(0.0, 0.15);

          return Positioned(
            left: left,
            top: top,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: opacity),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Obx(() {
        final isListening = speechService.isListening.value;
        final recognizedText = speechService.recognizedText.value;

        return Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: isListening
                ? const Color(0xFFFF6B6B).withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isListening
                  ? const Color(0xFFFF6B6B).withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              // Wave Animation (visible when listening)
              if (isListening)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: _buildWaveAnimation(),
                  ),
                ),

              // Search Content
              Row(
                children: [
                  // Search/Mic Icon
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Icon(
                      isListening ? Icons.mic : Icons.search,
                      color: Colors.white,
                      size: 22.r,
                    ),
                  ),
                  // Search TextField or Listening Text
                  Expanded(
                    child: isListening
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(
                              recognizedText.isEmpty
                                  ? 'Listening...'
                                  : recognizedText,
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search certificates...',
                              hintStyle: GoogleFonts.nunito(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 16.h,
                              ),
                            ),
                          ),
                  ),
                  // Clear Button (visible when there's text and not listening)
                  if (_searchQuery.isNotEmpty && !isListening)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(8.r),
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18.r,
                        ),
                      ),
                    ),
                  // Mic / Stop Button
                  GestureDetector(
                    onTap: _toggleVoiceSearch,
                    child: Container(
                      margin: EdgeInsets.all(8.r),
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        gradient: isListening
                            ? const LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                              )
                            : null,
                        color: isListening
                            ? null
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: isListening
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFF6B6B,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 8.r,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        isListening
                            ? Icons.stop_rounded
                            : Icons.mic_none_rounded,
                        color: Colors.white,
                        size: 20.r,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  // Wave animation for voice search
  Widget _buildWaveAnimation() {
    if (_waveController == null) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _waveController!,
      builder: (context, child) {
        return CustomPaint(
          painter: _WavePainter(
            animationValue: _waveController!.value,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          size: Size.infinite,
        );
      },
    );
  }

  // Toggle voice search
  void _toggleVoiceSearch() async {
    if (speechService.isListening.value) {
      await speechService.stopListening();
      if (!mounted) return;
      // Apply the recognized text to search
      final text = speechService.recognizedText.value;
      if (text.isNotEmpty) {
        setState(() {
          _searchController.text = text;
          _searchQuery = text;
        });
      }
    } else {
      // Check if speech recognition is available
      if (!speechService.isAvailable.value) {
        Get.snackbar(
          'Microphone',
          'Speech recognition is not available. Please check microphone permissions.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFF6B6B),
          colorText: Colors.white,
          margin: EdgeInsets.all(16.r),
          borderRadius: 12.r,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Clear previous text
      speechService.recognizedText.value = '';

      try {
        await speechService.startListening(
          locale: 'en_IN',
          onResultCallback: (recognizedText) {
            if (!mounted) return;
            setState(() {
              _searchController.text = recognizedText;
              _searchQuery = recognizedText;
            });
          },
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to start listening: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFF6B6B),
          colorText: Colors.white,
          margin: EdgeInsets.all(16.r),
          borderRadius: 12.r,
        );
      }
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 3,
              ),
            ),
            child: const Center(
              child: Text('🔍', style: TextStyle(fontSize: 60)),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Certificates Found',
            style: GoogleFonts.baloo2(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try searching something else!',
            style: GoogleFonts.nunito(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(
    Map<String, dynamic> cert,
    double progress,
    bool isEarned,
    int index,
  ) {
    // Use home-style gradients
    final gradient = isEarned
        ? [const Color(0xFFFFD700), const Color(0xFFFFA500)] // Gold for earned
        : cardGradients[index % cardGradients.length];

    return GestureDetector(
      onTap: isEarned
          ? () {
              TtsService.to.speak(cert['title']);
              _showCertificate(cert);
            }
          : () => _explainLock(cert),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: isEarned ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 15.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circle
            Positioned(
              top: -20.h,
              right: -20.w,
              child: Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -30.h,
              left: -30.w,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  // Certificate Icon
                  Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            cert['icon'],
                            style: const TextStyle(fontSize: 36),
                          ),
                        ),
                        if (!isEarned)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 28.r,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // Certificate Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cert['title'],
                          style: GoogleFonts.baloo2(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 2.r,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          cert['description'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Progress Bar
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.r),
                                child: LinearProgressIndicator(
                                  value: progress / 100,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.3,
                                  ),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                  minHeight: 8.h,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                '${progress.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 12,
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
            ),
            // Earned Badge
            if (isEarned)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, color: Colors.white, size: 14.r),
                      SizedBox(width: 4.w),
                      Text(
                        'EARNED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCertificate(Map<String, dynamic> cert) {
    Get.to(() => CertificateViewPage(cert: cert));
  }

  /// Why this one is still locked, and how much is left to unlock it. A tap
  /// that does nothing at all leaves a child guessing.
  void _explainLock(Map<String, dynamic> cert) {
    final requirement = cert['requirement'] as int;
    final String message;

    final progress = ProgressService.to;

    if (cert['isSpecial'] == true) {
      final done = progress.getOverallProgress().round();
      message = 'Reach $requirement% overall to unlock this one. '
          'You are at $done% right now.';
    } else {
      final done = progress.getCompletedCount(cert['progressKey']);
      final left = (requirement - done).clamp(0, requirement);
      message = left == 1
          ? 'Finish 1 more to unlock this certificate. ($done of $requirement)'
          : 'Finish $left more to unlock this certificate. '
              '($done of $requirement)';
    }

    Get.snackbar(
      '🔒 ${cert['title']}',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF764BA2),
      colorText: Colors.white,
      margin: EdgeInsets.all(16.r),
      borderRadius: 12.r,
      duration: const Duration(seconds: 3),
    );
  }
}

// Full Screen Certificate View Page
class CertificateViewPage extends StatefulWidget {
  final Map<String, dynamic> cert;

  const CertificateViewPage({Key? key, required this.cert}) : super(key: key);

  @override
  State<CertificateViewPage> createState() => _CertificateViewPageState();
}

class _CertificateViewPageState extends State<CertificateViewPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey _certificateKey = GlobalKey();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDownloading = false;

  /// Where saved certificates are remembered, so a second visit offers to
  /// open the one already on the device.
  final CertificateVault _vault = Get.isRegistered<CertificateVault>()
      ? Get.find<CertificateVault>()
      : Get.put(CertificateVault());

  bool get _isSaved => _vault.hasSaved(widget.cert['title'].toString());

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _downloadCertificate() async {
    setState(() => _isDownloading = true);

    try {
      // Capture the certificate widget as image
      RenderRepaintBoundary boundary =
          _certificateKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        final directory = await getApplicationDocumentsDirectory();
        final title = widget.cert['title'].toString();
        // One file per certificate, overwritten on a re-download, so saving
        // twice does not leave a folder full of near-identical copies.
        final fileName =
            'certificate_${title.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}.png';
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(byteData.buffer.asUint8List());

        await _vault.record(title, file.path);

        // The app's own copy is private, so the certificate also goes to the
        // phone's gallery -- that is where a parent will look for it.
        final galleryError = await _vault.saveToGallery(
          file.path,
          album: 'Jiyan Learning',
        );

        if (mounted) setState(() {});

        Get.snackbar(
          galleryError == null ? 'Saved to your gallery!' : 'Saved in the app',
          galleryError ??
              'Look for it in Photos, under "Jiyan Learning".',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor:
              galleryError == null ? Colors.green : Colors.orange,
          colorText: Colors.white,
          margin: EdgeInsets.all(16.r),
          borderRadius: 12.r,
          duration: const Duration(seconds: 4),
          mainButton: TextButton(
            onPressed: _openSavedCertificate,
            child: const Text(
              'OPEN',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download certificate: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16.r),
        borderRadius: 12.r,
      );
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  /// Hands the saved file to whatever the device opens images with.
  Future<void> _openSavedCertificate() async {
    final error = await _vault.open(widget.cert['title'].toString());
    if (error == null) return;

    Get.snackbar(
      'Could not open',
      error,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      margin: EdgeInsets.all(16.r),
      borderRadius: 12.r,
    );
    if (mounted) setState(() {});
  }

  Future<void> _shareCertificate() async {
    setState(() => _isDownloading = true);

    try {
      RenderRepaintBoundary boundary =
          _certificateKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        final directory = await getTemporaryDirectory();
        final fileName =
            'certificate_${widget.cert['title'].toString().replaceAll(' ', '_')}.png';
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(byteData.buffer.asUint8List());

        await Share.shareXFiles(
          [XFile(file.path)],
          text:
              'I earned the ${widget.cert['title']} certificate on Jiyan Kids Learning!',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share certificate: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16.r),
        borderRadius: 12.r,
      );
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.cert['color'] as Color;
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 8,
        shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 18.r,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x40FF6B6B),
                blurRadius: 15.r,
                offset: Offset(0, 5),
              ),
            ],
          ),
        ),
        title: Text(
          'Certificate',
          style: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4.r,
                offset: const Offset(1, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Certificate Content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.r),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: RepaintBoundary(
                        key: _certificateKey,
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(maxWidth: 400.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 30.r,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Decorative corners
                              Positioned(
                                top: 0,
                                left: 0,
                                child: _buildCornerDecoration(color, true),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Transform.flip(
                                  flipX: true,
                                  child: _buildCornerDecoration(color, true),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Transform.flip(
                                  flipY: true,
                                  child: _buildCornerDecoration(color, false),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Transform.flip(
                                  flipX: true,
                                  flipY: true,
                                  child: _buildCornerDecoration(color, false),
                                ),
                              ),

                              // Certificate content
                              Padding(
                                padding: EdgeInsets.all(24.r),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Header with stars
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: color,
                                          size: 24.r,
                                        ),
                                        SizedBox(width: 8.w),
                                        // Wide letter-spacing makes this
                                        // heading wider than the certificate
                                        // on a small phone; it scales down
                                        // rather than clipping.
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'CERTIFICATE',
                                              style:
                                                  GoogleFonts.playfairDisplay(
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.bold,
                                                    color: color,
                                                    letterSpacing: 4,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Icon(
                                          Icons.star,
                                          color: color,
                                          size: 24.r,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'OF ACHIEVEMENT',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade600,
                                        letterSpacing: 6,
                                      ),
                                    ),

                                    SizedBox(height: 24.h),

                                    // Decorative line
                                    Container(
                                      height: 2.h,
                                      width: 150.w,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            color,
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 24.h),

                                    // "This is to certify that"
                                    Text(
                                      'This is to certify that',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),

                                    SizedBox(height: 12.h),

                                    // Student name placeholder
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: color.withValues(alpha: 0.5),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Young Learner',
                                        style: GoogleFonts.dancingScript(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 20.h),

                                    // Achievement text
                                    Text(
                                      'has successfully achieved',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),

                                    SizedBox(height: 16.h),

                                    // Badge Icon
                                    Container(
                                      width: 100.w,
                                      height: 100.h,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            color,
                                            Color.lerp(
                                              color,
                                              Colors.white,
                                              0.3,
                                            )!,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: color.withValues(alpha: 0.5),
                                            blurRadius: 20.r,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.cert['icon'],
                                          style: const TextStyle(fontSize: 50),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 16.h),

                                    // Certificate Title
                                    Text(
                                      widget.cert['title'],
                                      style: GoogleFonts.baloo2(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    SizedBox(height: 8.h),

                                    // Description
                                    Text(
                                      widget.cert['description'],
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    SizedBox(height: 24.h),

                                    // Decorative line
                                    Container(
                                      height: 2.h,
                                      width: 150.w,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            color,
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 20.h),

                                    // Date and Signature area
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // Date
                                        Flexible(
                                          child: Column(
                                            children: [
                                              Text(
                                                dateStr,
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Container(
                                                width: 80.w,
                                                height: 1.h,
                                                color: Colors.grey.shade400,
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                'Date',
                                                style: GoogleFonts.lato(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Seal
                                        Container(
                                          width: 60.w,
                                          height: 60.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: color,
                                              width: 3,
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.verified,
                                              color: color,
                                              size: 30.r,
                                            ),
                                          ),
                                        ),

                                        // Signature
                                        Column(
                                          children: [
                                            Text(
                                              'Jiyan',
                                              style: GoogleFonts.dancingScript(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Container(
                                              width: 80.w,
                                              height: 1.h,
                                              color: Colors.grey.shade400,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              'Signature',
                                              style: GoogleFonts.lato(
                                                fontSize: 11,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 16.h),

                                    // App branding
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Jiyan ',
                                            style: GoogleFonts.baloo2(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFFF6B6B),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            'Kids ',
                                            style: GoogleFonts.baloo2(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF4ECDC4),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            'Learning',
                                            style: GoogleFonts.baloo2(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFFFE66D),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Action Buttons
              Container(
                padding: EdgeInsets.all(20.r),
                child: Row(
                  children: [
                    // Share Button
                    Expanded(
                      child: GestureDetector(
                        onTap: _isDownloading ? null : _shareCertificate,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.share, color: Colors.white),
                              SizedBox(width: 8.w),
                              Text(
                                'Share',
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Download Button
                    Expanded(
                      child: GestureDetector(
                        onTap: _isDownloading
                            ? null
                            : _isSaved
                                ? _openSavedCertificate
                                : _downloadCertificate,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFFD700,
                                ).withValues(alpha: 0.4),
                                blurRadius: 15.r,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _isDownloading
                                  ? SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.r,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Icon(
                                      _isSaved
                                          ? Icons.visibility_rounded
                                          : Icons.download,
                                      color: Colors.white,
                                    ),
                              SizedBox(width: 8.w),
                              Flexible(
                                child: Text(
                                  _isDownloading
                                      ? 'Saving...'
                                      : _isSaved
                                          ? 'View'
                                          : 'Download',
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCornerDecoration(Color color, bool isTop) {
    return CustomPaint(
      size: const Size(60, 60),
      painter: _CornerDecorationPainter(color: color, isTop: isTop),
    );
  }
}

// Corner decoration painter
class _CornerDecorationPainter extends CustomPainter {
  final Color color;
  final bool isTop;

  _CornerDecorationPainter({required this.color, required this.isTop});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();

    if (isTop) {
      path.moveTo(0, size.height * 0.7);
      path.quadraticBezierTo(0, 0, size.width * 0.7, 0);
    } else {
      path.moveTo(0, size.height * 0.3);
      path.quadraticBezierTo(0, size.height, size.width * 0.7, size.height);
    }

    canvas.drawPath(path, paint);

    // Draw decorative dots
    final dotPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.15),
      4,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.05),
      3,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.05, size.height * 0.35),
      3,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Wave Painter for voice search animation
class _WavePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _WavePainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    const waveHeight = 8.0;
    final waveLength = size.width / 3;

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y =
          size.height / 2 +
          waveHeight *
              (0.5 *
                      (1 +
                          math.sin(
                            2 * math.pi * (x / waveLength + animationValue),
                          )) +
                  0.3 *
                      (1 +
                          math.sin(
                            2 *
                                math.pi *
                                (x / waveLength * 2 + animationValue * 1.5),
                          )));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Second wave layer
    final paint2 = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y =
          size.height / 2 +
          waveHeight *
              0.7 *
              (0.5 *
                      (1 +
                          math.sin(
                            2 *
                                math.pi *
                                (x / waveLength + animationValue + 0.5),
                          )) +
                  0.3 *
                      (1 +
                          math.sin(
                            2 *
                                math.pi *
                                (x / waveLength * 2 +
                                    animationValue * 1.5 +
                                    0.3),
                          )));
      path2.lineTo(x, y);
    }

    path2.lineTo(size.width, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
