import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/speech_recognition_service.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class OfflineLearningPage extends StatefulWidget {
  const OfflineLearningPage({Key? key}) : super(key: key);

  @override
  State<OfflineLearningPage> createState() => _OfflineLearningPageState();
}

class _OfflineLearningPageState extends State<OfflineLearningPage>
    with TickerProviderStateMixin {
  final RxMap<String, bool> downloadedContent = <String, bool>{}.obs;
  final RxMap<String, double> downloadProgress = <String, double>{}.obs;
  final TextEditingController _searchController = TextEditingController();
  late final SpeechRecognitionService speechService;
  String _searchQuery = '';
  AnimationController? _waveController;

  // Home screen style animations
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;

  // Home screen style card gradients
  final List<List<Color>> cardGradients = [
    [const Color(0xFFFF6B6B), const Color(0xFFFF8E8E)],
    [const Color(0xFFFFAA5A), const Color(0xFFFFCB80)],
    [const Color(0xFF56D97F), const Color(0xFF81E89E)],
    [const Color(0xFF45B7D1), const Color(0xFF74C9DB)],
    [const Color(0xFFA78BFA), const Color(0xFFC4B5FD)],
    [const Color(0xFFFF6EB4), const Color(0xFFFF9ECE)],
    [const Color(0xFFFFE66D), const Color(0xFFFFF59D)],
    [const Color(0xFF4ECDC4), const Color(0xFF7EDDD6)],
  ];

  final List<Map<String, dynamic>> offlineCategories = [
    // ========== NUMBERS & MATH ==========
    {
      'id': 'numbers',
      'title': 'Numbers 1-100',
      'description': 'Learn counting numbers',
      'icon': '🔢',
      'color': const Color(0xFFFF6B6B),
      'size': '15 MB',
      'items': 100,
    },
    {
      'id': 'tables',
      'title': 'Math Tables',
      'description': 'Multiplication tables 2-20',
      'icon': '✖️',
      'color': const Color(0xFFFFAA5A),
      'size': '10 MB',
      'items': 20,
    },
    {
      'id': 'math_problems',
      'title': 'Math Problems',
      'description': 'Addition, subtraction & more',
      'icon': '🧮',
      'color': const Color(0xFF4CAF50),
      'size': '18 MB',
      'items': 200,
    },
    {
      'id': 'math_questions',
      'title': 'Math Questions',
      'description': 'Practice math questions',
      'icon': '❓',
      'color': const Color(0xFF2196F3),
      'size': '12 MB',
      'items': 150,
    },

    // ========== ALPHABETS & LETTERS ==========
    {
      'id': 'capital_letters',
      'title': 'Capital Letters',
      'description': 'Learn A-Z uppercase',
      'icon': '🅰️',
      'color': const Color(0xFF4ECDC4),
      'size': '12 MB',
      'items': 26,
    },
    {
      'id': 'small_letters',
      'title': 'Small Letters',
      'description': 'Learn a-z lowercase',
      'icon': '🔤',
      'color': const Color(0xFF9C27B0),
      'size': '12 MB',
      'items': 26,
    },
    {
      'id': 'hindi_letters',
      'title': 'Hindi Letters',
      'description': 'Learn Hindi alphabets',
      'icon': '🇮🇳',
      'color': const Color(0xFFA78BFA),
      'size': '25 MB',
      'items': 49,
    },
    {
      'id': 'alphabet_words',
      'title': 'Alphabet Words',
      'description': 'Words with each letter',
      'icon': '📖',
      'color': const Color(0xFFE91E63),
      'size': '30 MB',
      'items': 260,
    },

    // ========== LEARNING SETS ==========
    {
      'id': 'animals',
      'title': 'Animals',
      'description': 'Learn animal names & sounds',
      'icon': '🦁',
      'color': const Color(0xFF56D97F),
      'size': '35 MB',
      'items': 50,
    },
    {
      'id': 'birds',
      'title': 'Birds',
      'description': 'Learn bird names & sounds',
      'icon': '🐦',
      'color': const Color(0xFFFF6EB4),
      'size': '28 MB',
      'items': 40,
    },
    {
      'id': 'fruits',
      'title': 'Fruits',
      'description': 'Learn fruit names',
      'icon': '🍎',
      'color': const Color(0xFF00CED1),
      'size': '20 MB',
      'items': 30,
    },
    {
      'id': 'vegetables',
      'title': 'Vegetables',
      'description': 'Learn vegetable names',
      'icon': '🥕',
      'color': const Color(0xFF8BC34A),
      'size': '18 MB',
      'items': 25,
    },
    {
      'id': 'flowers',
      'title': 'Flowers',
      'description': 'Learn flower names',
      'icon': '🌸',
      'color': const Color(0xFFFF69B4),
      'size': '15 MB',
      'items': 20,
    },
    {
      'id': 'colors',
      'title': 'Colors',
      'description': 'Learn color names',
      'icon': '🎨',
      'color': const Color(0xFFE040FB),
      'size': '10 MB',
      'items': 15,
    },
    {
      'id': 'shapes',
      'title': 'Shapes',
      'description': 'Learn shape names',
      'icon': '🔷',
      'color': const Color(0xFF3F51B5),
      'size': '12 MB',
      'items': 20,
    },
    {
      'id': 'bodyparts',
      'title': 'Body Parts',
      'description': 'Learn body part names',
      'icon': '👋',
      'color': const Color(0xFF9C27B0),
      'size': '18 MB',
      'items': 25,
    },
    {
      'id': 'vehicles',
      'title': 'Vehicles',
      'description': 'Learn vehicle names',
      'icon': '🚗',
      'color': const Color(0xFF795548),
      'size': '22 MB',
      'items': 35,
    },
    {
      'id': 'months',
      'title': 'Months',
      'description': 'Learn month names',
      'icon': '📅',
      'color': const Color(0xFF607D8B),
      'size': '8 MB',
      'items': 12,
    },
    {
      'id': 'weekdays',
      'title': 'Week Days',
      'description': 'Learn days of the week',
      'icon': '📆',
      'color': const Color(0xFF00BCD4),
      'size': '5 MB',
      'items': 7,
    },
    {
      'id': 'seasons',
      'title': 'Seasons',
      'description': 'Learn about seasons',
      'icon': '🌤️',
      'color': const Color(0xFFFFEB3B),
      'size': '15 MB',
      'items': 4,
    },

    // ========== CREATIVE & FUN ==========
    {
      'id': 'poems',
      'title': 'Poems & Rhymes',
      'description': 'Fun poems for kids',
      'icon': '📝',
      'color': const Color(0xFF7C4DFF),
      'size': '40 MB',
      'items': 30,
    },
    {
      'id': 'stories',
      'title': 'Stories',
      'description': 'Moral stories for kids',
      'icon': '📚',
      'color': const Color(0xFFFF7043),
      'size': '50 MB',
      'items': 25,
    },
    {
      'id': 'rhymes',
      'title': 'Nursery Rhymes',
      'description': 'Classic nursery rhymes',
      'icon': '🎵',
      'color': const Color(0xFFE91E63),
      'size': '60 MB',
      'items': 20,
    },
    {
      'id': 'gk',
      'title': 'General Knowledge',
      'description': 'Fun facts for kids',
      'icon': '🧠',
      'color': const Color(0xFF673AB7),
      'size': '25 MB',
      'items': 100,
    },

    // ========== DRAWING & ART ==========
    {
      'id': 'drawing',
      'title': 'Drawing',
      'description': 'Learn to draw',
      'icon': '✏️',
      'color': const Color(0xFFFF5722),
      'size': '30 MB',
      'items': 50,
    },
    {
      'id': 'drawing_images',
      'title': 'Drawing Templates',
      'description': 'Coloring templates',
      'icon': '🖼️',
      'color': const Color(0xFF009688),
      'size': '45 MB',
      'items': 100,
    },
    {
      'id': 'coloring',
      'title': 'Coloring Pages',
      'description': 'Fun coloring activities',
      'icon': '🖍️',
      'color': const Color(0xFFFF4081),
      'size': '35 MB',
      'items': 80,
    },

    // ========== EARLY LEARNING ==========
    {
      'id': 'sensory',
      'title': 'Sensory Learning',
      'description': 'Touch, see, hear activities',
      'icon': '👋',
      'color': const Color(0xFFFFB74D),
      'size': '20 MB',
      'items': 30,
    },
    {
      'id': 'visual',
      'title': 'Visual Learning',
      'description': 'Picture-based learning',
      'icon': '👁️',
      'color': const Color(0xFF42A5F5),
      'size': '40 MB',
      'items': 50,
    },
    {
      'id': 'audio',
      'title': 'Audio Learning',
      'description': 'Sound-based activities',
      'icon': '🔊',
      'color': const Color(0xFF66BB6A),
      'size': '55 MB',
      'items': 40,
    },
    {
      'id': 'kinesthetic',
      'title': 'Kinesthetic Learning',
      'description': 'Movement activities',
      'icon': '🤸',
      'color': const Color(0xFFAB47BC),
      'size': '25 MB',
      'items': 25,
    },
    {
      'id': 'play_based',
      'title': 'Play-Based Learning',
      'description': 'Learn through play',
      'icon': '🎮',
      'color': const Color(0xFFFF7043),
      'size': '35 MB',
      'items': 45,
    },
    {
      'id': 'exploratory',
      'title': 'Exploratory Learning',
      'description': 'Discover & explore',
      'icon': '🔭',
      'color': const Color(0xFF5C6BC0),
      'size': '30 MB',
      'items': 35,
    },
    {
      'id': 'discovery',
      'title': 'Discovery Zone',
      'description': 'Find new things',
      'icon': '🔍',
      'color': const Color(0xFF26A69A),
      'size': '28 MB',
      'items': 40,
    },
    {
      'id': 'montessori',
      'title': 'Montessori',
      'description': 'Montessori activities',
      'icon': '🎓',
      'color': const Color(0xFFEF5350),
      'size': '32 MB',
      'items': 50,
    },
    {
      'id': 'activity_based',
      'title': 'Activity-Based',
      'description': 'Hands-on activities',
      'icon': '🎯',
      'color': const Color(0xFF7E57C2),
      'size': '38 MB',
      'items': 60,
    },
    {
      'id': 'experiential',
      'title': 'Experiential Learning',
      'description': 'Learn by experience',
      'icon': '🎪',
      'color': const Color(0xFFEC407A),
      'size': '42 MB',
      'items': 45,
    },

    // ========== LITERACY & READING ==========
    {
      'id': 'phonics',
      'title': 'Phonics',
      'description': 'Letter sounds & blending',
      'icon': '🔤',
      'color': const Color(0xFF29B6F6),
      'size': '35 MB',
      'items': 100,
    },
    {
      'id': 'sight_words',
      'title': 'Sight Words',
      'description': 'Common words to recognize',
      'icon': '👀',
      'color': const Color(0xFF26C6DA),
      'size': '20 MB',
      'items': 200,
    },
    {
      'id': 'reading_basics',
      'title': 'Reading Basics',
      'description': 'Learn to read',
      'icon': '📖',
      'color': const Color(0xFF9CCC65),
      'size': '45 MB',
      'items': 80,
    },
    {
      'id': 'vocabulary',
      'title': 'Vocabulary Builder',
      'description': 'New words daily',
      'icon': '📚',
      'color': const Color(0xFFFFCA28),
      'size': '30 MB',
      'items': 500,
    },
    {
      'id': 'spelling',
      'title': 'Spelling Practice',
      'description': 'Learn to spell correctly',
      'icon': '✍️',
      'color': const Color(0xFF8D6E63),
      'size': '22 MB',
      'items': 300,
    },
    {
      'id': 'grammar',
      'title': 'Grammar Basics',
      'description': 'Basic grammar rules',
      'icon': '📝',
      'color': const Color(0xFF78909C),
      'size': '25 MB',
      'items': 100,
    },
    {
      'id': 'comprehension',
      'title': 'Reading Comprehension',
      'description': 'Understand what you read',
      'icon': '🧩',
      'color': const Color(0xFFBA68C8),
      'size': '40 MB',
      'items': 75,
    },

    // ========== WRITING SKILLS ==========
    {
      'id': 'tracing',
      'title': 'Letter Tracing',
      'description': 'Trace letters & numbers',
      'icon': '✏️',
      'color': const Color(0xFF4DB6AC),
      'size': '18 MB',
      'items': 62,
    },
    {
      'id': 'handwriting',
      'title': 'Handwriting Practice',
      'description': 'Improve handwriting',
      'icon': '✒️',
      'color': const Color(0xFF7986CB),
      'size': '25 MB',
      'items': 100,
    },
    {
      'id': 'creative_writing',
      'title': 'Creative Writing',
      'description': 'Write your own stories',
      'icon': '📝',
      'color': const Color(0xFFFFB300),
      'size': '15 MB',
      'items': 50,
    },
    {
      'id': 'sentence_building',
      'title': 'Sentence Building',
      'description': 'Make sentences',
      'icon': '🔗',
      'color': const Color(0xFF00897B),
      'size': '20 MB',
      'items': 150,
    },

    // ========== GAMES & INTERACTIVE ==========
    {
      'id': 'matching_games',
      'title': 'Matching Games',
      'description': 'Match pairs & memory',
      'icon': '🃏',
      'color': const Color(0xFFE57373),
      'size': '25 MB',
      'items': 30,
    },
    {
      'id': 'puzzle_games',
      'title': 'Puzzle Games',
      'description': 'Fun puzzles for kids',
      'icon': '🧩',
      'color': const Color(0xFF64B5F6),
      'size': '35 MB',
      'items': 50,
    },
    {
      'id': 'tracing_games',
      'title': 'Tracing Games',
      'description': 'Trace & learn',
      'icon': '✍️',
      'color': const Color(0xFF81C784),
      'size': '20 MB',
      'items': 40,
    },
    {
      'id': 'quiz_games',
      'title': 'Quiz Games',
      'description': 'Test your knowledge',
      'icon': '❔',
      'color': const Color(0xFFFFD54F),
      'size': '15 MB',
      'items': 200,
    },
    {
      'id': 'word_games',
      'title': 'Word Games',
      'description': 'Fun with words',
      'icon': '🔠',
      'color': const Color(0xFF4FC3F7),
      'size': '18 MB',
      'items': 100,
    },
    {
      'id': 'counting_games',
      'title': 'Counting Games',
      'description': 'Learn to count',
      'icon': '🔢',
      'color': const Color(0xFFA1887F),
      'size': '22 MB',
      'items': 50,
    },
    {
      'id': 'sorting_games',
      'title': 'Sorting Games',
      'description': 'Sort & categorize',
      'icon': '📊',
      'color': const Color(0xFF90A4AE),
      'size': '20 MB',
      'items': 40,
    },
    {
      'id': 'pattern_games',
      'title': 'Pattern Games',
      'description': 'Find patterns',
      'icon': '🔲',
      'color': const Color(0xFFCE93D8),
      'size': '15 MB',
      'items': 35,
    },
    {
      'id': 'music_games',
      'title': 'Music Games',
      'description': 'Learn with music',
      'icon': '🎵',
      'color': const Color(0xFFE91E63),
      'size': '45 MB',
      'items': 30,
    },

    // ========== SCIENCE & KNOWLEDGE ==========
    {
      'id': 'science_basics',
      'title': 'Science Basics',
      'description': 'Basic science concepts',
      'icon': '🔬',
      'color': const Color(0xFF00ACC1),
      'size': '35 MB',
      'items': 80,
    },
    {
      'id': 'nature',
      'title': 'Nature & Environment',
      'description': 'Learn about nature',
      'icon': '🌿',
      'color': const Color(0xFF43A047),
      'size': '40 MB',
      'items': 60,
    },
    {
      'id': 'space',
      'title': 'Space & Planets',
      'description': 'Explore the universe',
      'icon': '🚀',
      'color': const Color(0xFF1E88E5),
      'size': '30 MB',
      'items': 50,
    },
    {
      'id': 'human_body',
      'title': 'Human Body',
      'description': 'Learn about our body',
      'icon': '🫀',
      'color': const Color(0xFFE53935),
      'size': '25 MB',
      'items': 40,
    },
    {
      'id': 'weather',
      'title': 'Weather',
      'description': 'Learn about weather',
      'icon': '🌦️',
      'color': const Color(0xFF039BE5),
      'size': '18 MB',
      'items': 25,
    },
    {
      'id': 'plants',
      'title': 'Plants & Trees',
      'description': 'Learn about plants',
      'icon': '🌳',
      'color': const Color(0xFF7CB342),
      'size': '28 MB',
      'items': 45,
    },

    // ========== STEM & PROJECTS ==========
    {
      'id': 'stem_basics',
      'title': 'STEM Basics',
      'description': 'Science, Tech, Engineering, Math',
      'icon': '🔧',
      'color': const Color(0xFF5E35B1),
      'size': '40 MB',
      'items': 60,
    },
    {
      'id': 'mini_projects',
      'title': 'Mini Projects',
      'description': 'Fun DIY projects',
      'icon': '🔬',
      'color': const Color(0xFF00897B),
      'size': '35 MB',
      'items': 40,
    },
    {
      'id': 'experiments',
      'title': 'Home Experiments',
      'description': 'Safe experiments at home',
      'icon': '🧪',
      'color': const Color(0xFF8E24AA),
      'size': '30 MB',
      'items': 50,
    },
    {
      'id': 'diy_learning',
      'title': 'DIY Learning',
      'description': 'Do it yourself activities',
      'icon': '🛠️',
      'color': const Color(0xFFF4511E),
      'size': '28 MB',
      'items': 45,
    },
    {
      'id': 'coding_basics',
      'title': 'Coding Basics',
      'description': 'Introduction to coding',
      'icon': '💻',
      'color': const Color(0xFF1976D2),
      'size': '25 MB',
      'items': 30,
    },
    {
      'id': 'robotics_intro',
      'title': 'Robotics Intro',
      'description': 'Learn about robots',
      'icon': '🤖',
      'color': const Color(0xFF546E7A),
      'size': '22 MB',
      'items': 25,
    },

    // ========== LIFE SKILLS ==========
    {
      'id': 'daily_routines',
      'title': 'Daily Routines',
      'description': 'Morning & evening habits',
      'icon': '🏠',
      'color': const Color(0xFF8D6E63),
      'size': '15 MB',
      'items': 30,
    },
    {
      'id': 'hygiene',
      'title': 'Hygiene Habits',
      'description': 'Stay clean & healthy',
      'icon': '🧼',
      'color': const Color(0xFF26C6DA),
      'size': '12 MB',
      'items': 25,
    },
    {
      'id': 'money_basics',
      'title': 'Money Basics',
      'description': 'Learn about money',
      'icon': '💰',
      'color': const Color(0xFFFFB300),
      'size': '18 MB',
      'items': 35,
    },
    {
      'id': 'time_management',
      'title': 'Time Management',
      'description': 'Learn to tell time',
      'icon': '⏰',
      'color': const Color(0xFF5C6BC0),
      'size': '15 MB',
      'items': 40,
    },
    {
      'id': 'safety_skills',
      'title': 'Safety Skills',
      'description': 'Stay safe everywhere',
      'icon': '🦺',
      'color': const Color(0xFFE53935),
      'size': '20 MB',
      'items': 30,
    },
    {
      'id': 'manners',
      'title': 'Good Manners',
      'description': 'Learn politeness',
      'icon': '🙏',
      'color': const Color(0xFFAB47BC),
      'size': '10 MB',
      'items': 25,
    },

    // ========== HEALTH & WELLNESS ==========
    {
      'id': 'nutrition',
      'title': 'Nutrition Learning',
      'description': 'Healthy food choices',
      'icon': '🥗',
      'color': const Color(0xFF66BB6A),
      'size': '18 MB',
      'items': 40,
    },
    {
      'id': 'exercise',
      'title': 'Exercise & Fitness',
      'description': 'Stay active & fit',
      'icon': '🏃',
      'color': const Color(0xFFFF7043),
      'size': '25 MB',
      'items': 35,
    },
    {
      'id': 'body_safety',
      'title': 'Body Safety',
      'description': 'Personal safety awareness',
      'icon': '🛡️',
      'color': const Color(0xFF5C6BC0),
      'size': '15 MB',
      'items': 20,
    },
    {
      'id': 'mental_wellness',
      'title': 'Mental Wellness',
      'description': 'Emotional health basics',
      'icon': '🧘',
      'color': const Color(0xFF7E57C2),
      'size': '20 MB',
      'items': 30,
    },

    // ========== SOCIAL EMOTIONAL LEARNING ==========
    {
      'id': 'emotions',
      'title': 'Understanding Emotions',
      'description': 'Learn about feelings',
      'icon': '😊',
      'color': const Color(0xFFFFB74D),
      'size': '22 MB',
      'items': 35,
    },
    {
      'id': 'friendship',
      'title': 'Friendship Skills',
      'description': 'Making & keeping friends',
      'icon': '🤝',
      'color': const Color(0xFF4FC3F7),
      'size': '18 MB',
      'items': 30,
    },
    {
      'id': 'empathy',
      'title': 'Empathy & Kindness',
      'description': 'Understanding others',
      'icon': '💝',
      'color': const Color(0xFFEC407A),
      'size': '15 MB',
      'items': 25,
    },
    {
      'id': 'self_control',
      'title': 'Self Control',
      'description': 'Managing impulses',
      'icon': '🧘',
      'color': const Color(0xFF26A69A),
      'size': '12 MB',
      'items': 20,
    },
    {
      'id': 'conflict_resolution',
      'title': 'Conflict Resolution',
      'description': 'Solving problems peacefully',
      'icon': '🕊️',
      'color': const Color(0xFF42A5F5),
      'size': '16 MB',
      'items': 25,
    },
    {
      'id': 'self_esteem',
      'title': 'Self Esteem',
      'description': 'Building confidence',
      'icon': '⭐',
      'color': const Color(0xFFFFD54F),
      'size': '14 MB',
      'items': 20,
    },

    // ========== COGNITIVE SKILLS ==========
    {
      'id': 'memory_skills',
      'title': 'Memory Skills',
      'description': 'Improve memory',
      'icon': '🧠',
      'color': const Color(0xFF7E57C2),
      'size': '20 MB',
      'items': 50,
    },
    {
      'id': 'attention_focus',
      'title': 'Attention & Focus',
      'description': 'Concentration exercises',
      'icon': '🎯',
      'color': const Color(0xFF26A69A),
      'size': '18 MB',
      'items': 40,
    },
    {
      'id': 'problem_solving',
      'title': 'Problem Solving',
      'description': 'Think & solve',
      'icon': '💡',
      'color': const Color(0xFFFFCA28),
      'size': '25 MB',
      'items': 60,
    },

    // ========== EXECUTIVE FUNCTION ==========
    {
      'id': 'planning',
      'title': 'Planning Skills',
      'description': 'Learn to plan ahead',
      'icon': '📋',
      'color': const Color(0xFF5C6BC0),
      'size': '15 MB',
      'items': 30,
    },
    {
      'id': 'organization',
      'title': 'Organization',
      'description': 'Keep things organized',
      'icon': '📁',
      'color': const Color(0xFF00897B),
      'size': '12 MB',
      'items': 25,
    },
    {
      'id': 'task_initiation',
      'title': 'Task Initiation',
      'description': 'Getting started',
      'icon': '🚀',
      'color': const Color(0xFFFF7043),
      'size': '10 MB',
      'items': 20,
    },
    {
      'id': 'flexibility',
      'title': 'Cognitive Flexibility',
      'description': 'Adapt & change',
      'icon': '🔄',
      'color': const Color(0xFF26C6DA),
      'size': '14 MB',
      'items': 25,
    },
    {
      'id': 'working_memory',
      'title': 'Working Memory',
      'description': 'Hold & use info',
      'icon': '📝',
      'color': const Color(0xFFAB47BC),
      'size': '18 MB',
      'items': 35,
    },
    {
      'id': 'impulse_control',
      'title': 'Impulse Control',
      'description': 'Think before acting',
      'icon': '⏸️',
      'color': const Color(0xFFEF5350),
      'size': '12 MB',
      'items': 20,
    },

    // ========== DIGITAL LITERACY ==========
    {
      'id': 'screen_safety',
      'title': 'Screen Safety',
      'description': 'Safe screen time',
      'icon': '📱',
      'color': const Color(0xFF1E88E5),
      'size': '15 MB',
      'items': 25,
    },
    {
      'id': 'internet_basics',
      'title': 'Internet Basics',
      'description': 'Safe internet use',
      'icon': '🌐',
      'color': const Color(0xFF00ACC1),
      'size': '18 MB',
      'items': 30,
    },
    {
      'id': 'typing_basics',
      'title': 'Typing Basics',
      'description': 'Learn to type',
      'icon': '⌨️',
      'color': const Color(0xFF546E7A),
      'size': '12 MB',
      'items': 26,
    },
    {
      'id': 'digital_citizenship',
      'title': 'Digital Citizenship',
      'description': 'Be a good digital citizen',
      'icon': '🏛️',
      'color': const Color(0xFF5E35B1),
      'size': '14 MB',
      'items': 20,
    },
    {
      'id': 'media_literacy',
      'title': 'Media Literacy',
      'description': 'Understand media',
      'icon': '📺',
      'color': const Color(0xFFE91E63),
      'size': '16 MB',
      'items': 25,
    },

    // ========== SUSTAINABILITY ==========
    {
      'id': 'recycling',
      'title': 'Recycling for Kids',
      'description': 'Reduce, reuse, recycle',
      'icon': '♻️',
      'color': const Color(0xFF4CAF50),
      'size': '15 MB',
      'items': 25,
    },
    {
      'id': 'climate',
      'title': 'Climate Awareness',
      'description': 'Understand climate',
      'icon': '🌍',
      'color': const Color(0xFF00BCD4),
      'size': '20 MB',
      'items': 30,
    },
    {
      'id': 'sustainable_habits',
      'title': 'Sustainable Habits',
      'description': 'Eco-friendly living',
      'icon': '🌱',
      'color': const Color(0xFF8BC34A),
      'size': '12 MB',
      'items': 20,
    },

    // ========== SOCIAL STUDIES ==========
    {
      'id': 'community_helpers',
      'title': 'Community Helpers',
      'description': 'People who help us',
      'icon': '👨‍🚒',
      'color': const Color(0xFFF44336),
      'size': '25 MB',
      'items': 35,
    },
    {
      'id': 'family',
      'title': 'Family & Relationships',
      'description': 'Learn about family',
      'icon': '👨‍👩‍👧‍👦',
      'color': const Color(0xFFE91E63),
      'size': '18 MB',
      'items': 25,
    },
    {
      'id': 'maps',
      'title': 'Maps & Directions',
      'description': 'Learn to read maps',
      'icon': '🗺️',
      'color': const Color(0xFF2196F3),
      'size': '20 MB',
      'items': 30,
    },
    {
      'id': 'countries_flags',
      'title': 'Countries & Flags',
      'description': 'Learn world flags',
      'icon': '🏳️',
      'color': const Color(0xFF673AB7),
      'size': '30 MB',
      'items': 195,
    },
    {
      'id': 'cultures',
      'title': 'World Cultures',
      'description': 'Different cultures',
      'icon': '🌍',
      'color': const Color(0xFF009688),
      'size': '35 MB',
      'items': 50,
    },

    // ========== MUSIC & ARTS ==========
    {
      'id': 'music_basics',
      'title': 'Music Basics',
      'description': 'Learn about music',
      'icon': '🎼',
      'color': const Color(0xFF9C27B0),
      'size': '40 MB',
      'items': 40,
    },
    {
      'id': 'instruments',
      'title': 'Musical Instruments',
      'description': 'Learn instruments',
      'icon': '🎸',
      'color': const Color(0xFF795548),
      'size': '35 MB',
      'items': 30,
    },
    {
      'id': 'singing',
      'title': 'Singing & Songs',
      'description': 'Learn to sing',
      'icon': '🎤',
      'color': const Color(0xFFFF4081),
      'size': '50 MB',
      'items': 50,
    },
    {
      'id': 'dance',
      'title': 'Dance & Movement',
      'description': 'Learn dance moves',
      'icon': '💃',
      'color': const Color(0xFFE040FB),
      'size': '60 MB',
      'items': 40,
    },
    {
      'id': 'art_crafts',
      'title': 'Arts & Crafts',
      'description': 'Creative art activities',
      'icon': '🎨',
      'color': const Color(0xFFFF5722),
      'size': '45 MB',
      'items': 80,
    },

    // ========== ANIMATED CONTENT ==========
    {
      'id': 'animated_stories',
      'title': 'Animated Stories',
      'description': 'Watch & learn',
      'icon': '🎬',
      'color': const Color(0xFF3F51B5),
      'size': '150 MB',
      'items': 30,
    },
    {
      'id': 'animated_rhymes',
      'title': 'Animated Rhymes',
      'description': 'Sing-along videos',
      'icon': '🎥',
      'color': const Color(0xFFE91E63),
      'size': '200 MB',
      'items': 40,
    },
    {
      'id': 'animated_lessons',
      'title': 'Animated Lessons',
      'description': 'Video lessons',
      'icon': '📽️',
      'color': const Color(0xFF00BCD4),
      'size': '180 MB',
      'items': 50,
    },
    {
      'id': 'cartoons',
      'title': 'Educational Cartoons',
      'description': 'Learn with cartoons',
      'icon': '📺',
      'color': const Color(0xFFFF9800),
      'size': '250 MB',
      'items': 25,
    },

    // ========== FLASHCARDS & WORKSHEETS ==========
    {
      'id': 'flashcards',
      'title': 'Flashcard Sets',
      'description': 'All flashcards offline',
      'icon': '🃏',
      'color': const Color(0xFF607D8B),
      'size': '50 MB',
      'items': 500,
    },
    {
      'id': 'worksheets',
      'title': 'Printable Worksheets',
      'description': 'Practice worksheets',
      'icon': '📄',
      'color': const Color(0xFF9E9E9E),
      'size': '80 MB',
      'items': 200,
    },

    // ========== ASSESSMENT & QUIZ ==========
    {
      'id': 'assessment_tests',
      'title': 'Assessment Tests',
      'description': 'Test your learning',
      'icon': '📝',
      'color': const Color(0xFF673AB7),
      'size': '25 MB',
      'items': 100,
    },
    {
      'id': 'quiz_bank',
      'title': 'Quiz Bank',
      'description': 'Thousands of quizzes',
      'icon': '❓',
      'color': const Color(0xFF00BCD4),
      'size': '35 MB',
      'items': 1000,
    },
  ];

  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return offlineCategories;
    }
    return offlineCategories.where((cat) {
      final title = cat['title'].toString().toLowerCase();
      final description = cat['description'].toString().toLowerCase();
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

    // Initialize home screen style animations
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

    // Simulate some content already downloaded
    downloadedContent['numbers'] = true;
    downloadedContent['alphabets'] = true;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _waveController?.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  // Build floating bubbles like home screen
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

  int get totalDownloaded => downloadedContent.values.where((v) => v).length;
  int get totalSize {
    int size = 0;
    for (var cat in offlineCategories) {
      if (downloadedContent[cat['id']] == true) {
        size += int.parse((cat['size'] as String).replaceAll(' MB', ''));
      }
    }
    return size;
  }

  Future<void> _downloadContent(String id) async {
    downloadProgress[id] = 0.0;

    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 100));
      downloadProgress[id] = i / 100;
    }

    downloadedContent[id] = true;
    downloadProgress.remove(id);
  }

  void _deleteContent(String id) {
    // Find the content name for display
    final content = offlineCategories.firstWhere(
      (cat) => cat['id'] == id,
      orElse: () => {'name': 'Content'},
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFF5F5),
                Color(0xFFFFE5E5),
                Color(0xFFFFF0F0),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF6B6B),
                      Color(0xFFFF8E53),
                      Color(0xFFFF6B6B),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Delete icon with animation effect
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Delete Content?',
                      style: GoogleFonts.baloo2(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Content section
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Content info card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              content['icon'] ?? '📦',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  content['name'] ?? 'Content',
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2D3436),
                                  ),
                                ),
                                Text(
                                  content['size'] ?? '',
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Warning message
                    Text(
                      'This content will be removed from your device. You can download it again anytime.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        // Cancel button
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () => Get.back(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Delete button
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                                downloadedContent[id] = false;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Delete',
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
                      ],
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

  void _downloadAll() async {
    for (var cat in offlineCategories) {
      if (downloadedContent[cat['id']] != true) {
        await _downloadContent(cat['id']);
      }
    }
  }

  void _toggleVoiceSearch() async {
    if (speechService.isListening.value) {
      await speechService.stopListening();
      if (!mounted) return;
      final text = speechService.recognizedText.value;
      if (text.isNotEmpty) {
        setState(() {
          _searchController.text = text;
          _searchQuery = text;
        });
      }
    } else {
      if (!speechService.isAvailable.value) {
        return;
      }

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
        debugPrint('Speech recognition error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _filteredCategories;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 8,
        shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 18,
            ),
          ),
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
            boxShadow: [
              BoxShadow(
                color: Color(0x40FF6B6B),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
        ),
        title: Text(
          "Offline Learning",
          style: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(1, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            final allDownloaded = offlineCategories.every(
              (cat) => downloadedContent[cat['id']] == true,
            );
            if (!allDownloaded) {
              return GestureDetector(
                onTap: _downloadAll,
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.download, color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'All',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFf093fb),
              Color(0xFFf5576c),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Floating bubbles background
            ..._buildFloatingBubbles(),
            SafeArea(
              child: Column(
                children: [
                  // Search Bar
                  _buildSearchBar(),
                  // Storage Info Card
                  _buildStorageInfoCard(),
                  // Content List with floating animation
                  Expanded(
                    child: categories.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return AnimatedBuilder(
                                animation: _floatController,
                                builder: (context, child) {
                                  final offset = index.isEven
                                      ? _floatAnimation.value
                                      : -_floatAnimation.value;
                                  return Transform.translate(
                                    offset: Offset(0, offset),
                                    child: child,
                                  );
                                },
                                child: _buildContentCard(category, index),
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
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Obx(() {
        final isListening = speechService.isListening.value;
        final recognizedText = speechService.recognizedText.value;

        return Container(
          height: 56,
          decoration: BoxDecoration(
            color: isListening
                ? const Color(0xFFFF6B6B).withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isListening
                  ? const Color(0xFFFF6B6B).withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              if (isListening)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: _buildWaveAnimation(),
                  ),
                ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Icon(
                      isListening ? Icons.mic : Icons.search,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  Expanded(
                    child: isListening
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                              hintText: 'Search content...',
                              hintStyle: GoogleFonts.nunito(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                            ),
                          ),
                  ),
                  if (_searchQuery.isNotEmpty && !isListening)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: _toggleVoiceSearch,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: isListening
                            ? const LinearGradient(
                                colors: [
                                  Color(0xFFFF6B6B),
                                  Color(0xFFFF8E53),
                                ],
                              )
                            : null,
                        color: isListening
                            ? null
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isListening
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFFF6B6B)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 8,
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
                        size: 20,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
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
          const SizedBox(height: 24),
          Text(
            'No Content Found',
            style: GoogleFonts.baloo2(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
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

  Widget _buildStorageInfoCard() {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.25),
              Colors.white.withValues(alpha: 0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.cloud_download_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Downloaded Content',
                    style: GoogleFonts.baloo2(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalDownloaded of ${offlineCategories.length} categories',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: totalDownloaded / offlineCategories.length,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$totalSize MB',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildContentCard(Map<String, dynamic> category, int index) {
    final id = category['id'] as String;
    // Use home-style gradients
    final gradient = cardGradients[index % cardGradients.length];

    return Obx(() {
      final isDownloaded = downloadedContent[id] == true;
      final isDownloading = downloadProgress.containsKey(id);
      final progress = downloadProgress[id] ?? 0.0;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: isDownloaded
              ? Border.all(color: const Color(0xFFFFD700), width: 3)
              : null,
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -15,
              right: -15,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category['icon'],
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                category['title'],
                                style: GoogleFonts.baloo2(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 2,
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isDownloaded)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFD700),
                                      Color(0xFFFFA500),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'SAVED',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${category['items']} items • ${category['size']}',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        if (isDownloading) ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white.withValues(alpha: 0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Downloading... ${(progress * 100).toInt()}%',
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Action Button
                  if (isDownloading)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  else if (isDownloaded)
                    GestureDetector(
                      onTap: () => _deleteContent(id),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () => _downloadContent(id),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
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
      final y = size.height / 2 +
          waveHeight *
              (0.5 *
                      (1 +
                          math.sin(
                              2 * math.pi * (x / waveLength + animationValue))) +
                  0.3 *
                      (1 +
                          math.sin(2 *
                              math.pi *
                              (x / waveLength * 2 + animationValue * 1.5))));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height / 2 +
          waveHeight *
              0.7 *
              (0.5 *
                      (1 +
                          math.sin(2 *
                              math.pi *
                              (x / waveLength + animationValue + 0.5))) +
                  0.3 *
                      (1 +
                          math.sin(2 *
                              math.pi *
                              (x / waveLength * 2 +
                                  animationValue * 1.5 +
                                  0.3))));
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
