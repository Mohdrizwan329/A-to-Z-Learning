import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/offline_content_service.dart';
import 'package:jiyan_learning/services/speech_recognition_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class OfflineLearningPage extends StatefulWidget {
  const OfflineLearningPage({Key? key}) : super(key: key);

  @override
  State<OfflineLearningPage> createState() => _OfflineLearningPageState();
}

class _OfflineLearningPageState extends State<OfflineLearningPage>
    with TickerProviderStateMixin {
  late final OfflineContentService offline;
  final TextEditingController _searchController = TextEditingController();
  late final SpeechRecognitionService speechService;

  /// Whether a category is ready to use with no network. Reads through to the
  /// service, so it survives a restart instead of resetting to nothing.
  RxMap<String, OfflineEntry> get _entries => offline.entries;
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
    },
    {
      'id': 'tables',
      'title': 'Math Tables',
      'description': 'Multiplication tables 2-20',
      'icon': '✖️',
      'color': const Color(0xFFFFAA5A),
    },
    {
      'id': 'math_problems',
      'title': 'Math Problems',
      'description': 'Addition, subtraction & more',
      'icon': '🧮',
      'color': const Color(0xFF4CAF50),
    },
    {
      'id': 'math_questions',
      'title': 'Math Questions',
      'description': 'Practice math questions',
      'icon': '❓',
      'color': const Color(0xFF2196F3),
    },

    // ========== ALPHABETS & LETTERS ==========
    {
      'id': 'capital_letters',
      'title': 'Capital Letters',
      'description': 'Learn A-Z uppercase',
      'icon': '🅰️',
      'color': const Color(0xFF4ECDC4),
    },
    {
      'id': 'small_letters',
      'title': 'Small Letters',
      'description': 'Learn a-z lowercase',
      'icon': '🔤',
      'color': const Color(0xFF9C27B0),
    },
    {
      'id': 'hindi_letters',
      'title': 'Hindi Letters',
      'description': 'Learn Hindi alphabets',
      'icon': '🇮🇳',
      'color': const Color(0xFFA78BFA),
    },
    {
      'id': 'alphabet_words',
      'title': 'Alphabet Words',
      'description': 'Words with each letter',
      'icon': '📖',
      'color': const Color(0xFFE91E63),
    },

    // ========== LEARNING SETS ==========
    {
      'id': 'animals',
      'title': 'Animals',
      'description': 'Learn animal names & sounds',
      'icon': '🦁',
      'color': const Color(0xFF56D97F),
    },
    {
      'id': 'birds',
      'title': 'Birds',
      'description': 'Learn bird names & sounds',
      'icon': '🐦',
      'color': const Color(0xFFFF6EB4),
    },
    {
      'id': 'fruits',
      'title': 'Fruits',
      'description': 'Learn fruit names',
      'icon': '🍎',
      'color': const Color(0xFF00CED1),
    },
    {
      'id': 'vegetables',
      'title': 'Vegetables',
      'description': 'Learn vegetable names',
      'icon': '🥕',
      'color': const Color(0xFF8BC34A),
    },
    {
      'id': 'flowers',
      'title': 'Flowers',
      'description': 'Learn flower names',
      'icon': '🌸',
      'color': const Color(0xFFFF69B4),
    },
    {
      'id': 'colors',
      'title': 'Colors',
      'description': 'Learn color names',
      'icon': '🎨',
      'color': const Color(0xFFE040FB),
    },
    {
      'id': 'shapes',
      'title': 'Shapes',
      'description': 'Learn shape names',
      'icon': '🔷',
      'color': const Color(0xFF3F51B5),
    },
    {
      'id': 'bodyparts',
      'title': 'Body Parts',
      'description': 'Learn body part names',
      'icon': '👋',
      'color': const Color(0xFF9C27B0),
    },
    {
      'id': 'vehicles',
      'title': 'Vehicles',
      'description': 'Learn vehicle names',
      'icon': '🚗',
      'color': const Color(0xFF795548),
    },
    {
      'id': 'months',
      'title': 'Months',
      'description': 'Learn month names',
      'icon': '📅',
      'color': const Color(0xFF607D8B),
    },
    {
      'id': 'weekdays',
      'title': 'Week Days',
      'description': 'Learn days of the week',
      'icon': '📆',
      'color': const Color(0xFF00BCD4),
    },
    {
      'id': 'seasons',
      'title': 'Seasons',
      'description': 'Learn about seasons',
      'icon': '🌤️',
      'color': const Color(0xFFFFEB3B),
    },

    // ========== CREATIVE & FUN ==========
    {
      'id': 'poems',
      'title': 'Poems & Rhymes',
      'description': 'Fun poems for kids',
      'icon': '📝',
      'color': const Color(0xFF7C4DFF),
    },
    {
      'id': 'stories',
      'title': 'Stories',
      'description': 'Moral stories for kids',
      'icon': '📚',
      'color': const Color(0xFFFF7043),
    },
    {
      'id': 'rhymes',
      'title': 'Nursery Rhymes',
      'description': 'Classic nursery rhymes',
      'icon': '🎵',
      'color': const Color(0xFFE91E63),
    },
    {
      'id': 'gk',
      'title': 'General Knowledge',
      'description': 'Fun facts for kids',
      'icon': '🧠',
      'color': const Color(0xFF673AB7),
    },

    // ========== DRAWING & ART ==========
    {
      'id': 'drawing',
      'title': 'Drawing',
      'description': 'Learn to draw',
      'icon': '✏️',
      'color': const Color(0xFFFF5722),
    },
    {
      'id': 'drawing_images',
      'title': 'Drawing Templates',
      'description': 'Coloring templates',
      'icon': '🖼️',
      'color': const Color(0xFF009688),
    },
    {
      'id': 'coloring',
      'title': 'Coloring Pages',
      'description': 'Fun coloring activities',
      'icon': '🖍️',
      'color': const Color(0xFFFF4081),
    },

    // ========== EARLY LEARNING ==========
    {
      'id': 'sensory',
      'title': 'Sensory Learning',
      'description': 'Touch, see, hear activities',
      'icon': '👋',
      'color': const Color(0xFFFFB74D),
    },
    {
      'id': 'visual',
      'title': 'Visual Learning',
      'description': 'Picture-based learning',
      'icon': '👁️',
      'color': const Color(0xFF42A5F5),
    },
    {
      'id': 'audio',
      'title': 'Audio Learning',
      'description': 'Sound-based activities',
      'icon': '🔊',
      'color': const Color(0xFF66BB6A),
    },
    {
      'id': 'kinesthetic',
      'title': 'Kinesthetic Learning',
      'description': 'Movement activities',
      'icon': '🤸',
      'color': const Color(0xFFAB47BC),
    },
    {
      'id': 'play_based',
      'title': 'Play-Based Learning',
      'description': 'Learn through play',
      'icon': '🎮',
      'color': const Color(0xFFFF7043),
    },
    {
      'id': 'exploratory',
      'title': 'Exploratory Learning',
      'description': 'Discover & explore',
      'icon': '🔭',
      'color': const Color(0xFF5C6BC0),
    },
    {
      'id': 'discovery',
      'title': 'Discovery Zone',
      'description': 'Find new things',
      'icon': '🔍',
      'color': const Color(0xFF26A69A),
    },
    {
      'id': 'montessori',
      'title': 'Montessori',
      'description': 'Montessori activities',
      'icon': '🎓',
      'color': const Color(0xFFEF5350),
    },
    {
      'id': 'activity_based',
      'title': 'Activity-Based',
      'description': 'Hands-on activities',
      'icon': '🎯',
      'color': const Color(0xFF7E57C2),
    },
    {
      'id': 'experiential',
      'title': 'Experiential Learning',
      'description': 'Learn by experience',
      'icon': '🎪',
      'color': const Color(0xFFEC407A),
    },

    // ========== LITERACY & READING ==========
    {
      'id': 'phonics',
      'title': 'Phonics',
      'description': 'Letter sounds & blending',
      'icon': '🔤',
      'color': const Color(0xFF29B6F6),
    },
    {
      'id': 'sight_words',
      'title': 'Sight Words',
      'description': 'Common words to recognize',
      'icon': '👀',
      'color': const Color(0xFF26C6DA),
    },
    {
      'id': 'reading_basics',
      'title': 'Reading Basics',
      'description': 'Learn to read',
      'icon': '📖',
      'color': const Color(0xFF9CCC65),
    },
    {
      'id': 'vocabulary',
      'title': 'Vocabulary Builder',
      'description': 'New words daily',
      'icon': '📚',
      'color': const Color(0xFFFFCA28),
    },
    {
      'id': 'spelling',
      'title': 'Spelling Practice',
      'description': 'Learn to spell correctly',
      'icon': '✍️',
      'color': const Color(0xFF8D6E63),
    },
    {
      'id': 'grammar',
      'title': 'Grammar Basics',
      'description': 'Basic grammar rules',
      'icon': '📝',
      'color': const Color(0xFF78909C),
    },
    {
      'id': 'comprehension',
      'title': 'Reading Comprehension',
      'description': 'Understand what you read',
      'icon': '🧩',
      'color': const Color(0xFFBA68C8),
    },

    // ========== WRITING SKILLS ==========
    {
      'id': 'tracing',
      'title': 'Letter Tracing',
      'description': 'Trace letters & numbers',
      'icon': '✏️',
      'color': const Color(0xFF4DB6AC),
    },
    {
      'id': 'handwriting',
      'title': 'Handwriting Practice',
      'description': 'Improve handwriting',
      'icon': '✒️',
      'color': const Color(0xFF7986CB),
    },
    {
      'id': 'creative_writing',
      'title': 'Creative Writing',
      'description': 'Write your own stories',
      'icon': '📝',
      'color': const Color(0xFFFFB300),
    },
    {
      'id': 'sentence_building',
      'title': 'Sentence Building',
      'description': 'Make sentences',
      'icon': '🔗',
      'color': const Color(0xFF00897B),
    },

    // ========== GAMES & INTERACTIVE ==========
    {
      'id': 'matching_games',
      'title': 'Matching Games',
      'description': 'Match pairs & memory',
      'icon': '🃏',
      'color': const Color(0xFFE57373),
    },
    {
      'id': 'puzzle_games',
      'title': 'Puzzle Games',
      'description': 'Fun puzzles for kids',
      'icon': '🧩',
      'color': const Color(0xFF64B5F6),
    },
    {
      'id': 'tracing_games',
      'title': 'Tracing Games',
      'description': 'Trace & learn',
      'icon': '✍️',
      'color': const Color(0xFF81C784),
    },
    {
      'id': 'quiz_games',
      'title': 'Quiz Games',
      'description': 'Test your knowledge',
      'icon': '❔',
      'color': const Color(0xFFFFD54F),
    },
    {
      'id': 'word_games',
      'title': 'Word Games',
      'description': 'Fun with words',
      'icon': '🔠',
      'color': const Color(0xFF4FC3F7),
    },
    {
      'id': 'counting_games',
      'title': 'Counting Games',
      'description': 'Learn to count',
      'icon': '🔢',
      'color': const Color(0xFFA1887F),
    },
    {
      'id': 'sorting_games',
      'title': 'Sorting Games',
      'description': 'Sort & categorize',
      'icon': '📊',
      'color': const Color(0xFF90A4AE),
    },
    {
      'id': 'pattern_games',
      'title': 'Pattern Games',
      'description': 'Find patterns',
      'icon': '🔲',
      'color': const Color(0xFFCE93D8),
    },
    {
      'id': 'music_games',
      'title': 'Music Games',
      'description': 'Learn with music',
      'icon': '🎵',
      'color': const Color(0xFFE91E63),
    },

    // ========== SCIENCE & KNOWLEDGE ==========
    {
      'id': 'science_basics',
      'title': 'Science Basics',
      'description': 'Basic science concepts',
      'icon': '🔬',
      'color': const Color(0xFF00ACC1),
    },
    {
      'id': 'nature',
      'title': 'Nature & Environment',
      'description': 'Learn about nature',
      'icon': '🌿',
      'color': const Color(0xFF43A047),
    },
    {
      'id': 'space',
      'title': 'Space & Planets',
      'description': 'Explore the universe',
      'icon': '🚀',
      'color': const Color(0xFF1E88E5),
    },
    {
      'id': 'human_body',
      'title': 'Human Body',
      'description': 'Learn about our body',
      'icon': '🫀',
      'color': const Color(0xFFE53935),
    },
    {
      'id': 'weather',
      'title': 'Weather',
      'description': 'Learn about weather',
      'icon': '🌦️',
      'color': const Color(0xFF039BE5),
    },
    {
      'id': 'plants',
      'title': 'Plants & Trees',
      'description': 'Learn about plants',
      'icon': '🌳',
      'color': const Color(0xFF7CB342),
    },

    // ========== STEM & PROJECTS ==========
    {
      'id': 'stem_basics',
      'title': 'STEM Basics',
      'description': 'Science, Tech, Engineering, Math',
      'icon': '🔧',
      'color': const Color(0xFF5E35B1),
    },
    {
      'id': 'mini_projects',
      'title': 'Mini Projects',
      'description': 'Fun DIY projects',
      'icon': '🔬',
      'color': const Color(0xFF00897B),
    },
    {
      'id': 'experiments',
      'title': 'Home Experiments',
      'description': 'Safe experiments at home',
      'icon': '🧪',
      'color': const Color(0xFF8E24AA),
    },
    {
      'id': 'diy_learning',
      'title': 'DIY Learning',
      'description': 'Do it yourself activities',
      'icon': '🛠️',
      'color': const Color(0xFFF4511E),
    },
    {
      'id': 'coding_basics',
      'title': 'Coding Basics',
      'description': 'Introduction to coding',
      'icon': '💻',
      'color': const Color(0xFF1976D2),
    },
    {
      'id': 'robotics_intro',
      'title': 'Robotics Intro',
      'description': 'Learn about robots',
      'icon': '🤖',
      'color': const Color(0xFF546E7A),
    },

    // ========== LIFE SKILLS ==========
    {
      'id': 'daily_routines',
      'title': 'Daily Routines',
      'description': 'Morning & evening habits',
      'icon': '🏠',
      'color': const Color(0xFF8D6E63),
    },
    {
      'id': 'hygiene',
      'title': 'Hygiene Habits',
      'description': 'Stay clean & healthy',
      'icon': '🧼',
      'color': const Color(0xFF26C6DA),
    },
    {
      'id': 'money_basics',
      'title': 'Money Basics',
      'description': 'Learn about money',
      'icon': '💰',
      'color': const Color(0xFFFFB300),
    },
    {
      'id': 'time_management',
      'title': 'Time Management',
      'description': 'Learn to tell time',
      'icon': '⏰',
      'color': const Color(0xFF5C6BC0),
    },
    {
      'id': 'safety_skills',
      'title': 'Safety Skills',
      'description': 'Stay safe everywhere',
      'icon': '🦺',
      'color': const Color(0xFFE53935),
    },
    {
      'id': 'manners',
      'title': 'Good Manners',
      'description': 'Learn politeness',
      'icon': '🙏',
      'color': const Color(0xFFAB47BC),
    },

    // ========== HEALTH & WELLNESS ==========
    {
      'id': 'nutrition',
      'title': 'Nutrition Learning',
      'description': 'Healthy food choices',
      'icon': '🥗',
      'color': const Color(0xFF66BB6A),
    },
    {
      'id': 'exercise',
      'title': 'Exercise & Fitness',
      'description': 'Stay active & fit',
      'icon': '🏃',
      'color': const Color(0xFFFF7043),
    },
    {
      'id': 'body_safety',
      'title': 'Body Safety',
      'description': 'Personal safety awareness',
      'icon': '🛡️',
      'color': const Color(0xFF5C6BC0),
    },
    {
      'id': 'mental_wellness',
      'title': 'Mental Wellness',
      'description': 'Emotional health basics',
      'icon': '🧘',
      'color': const Color(0xFF7E57C2),
    },

    // ========== SOCIAL EMOTIONAL LEARNING ==========
    {
      'id': 'emotions',
      'title': 'Understanding Emotions',
      'description': 'Learn about feelings',
      'icon': '😊',
      'color': const Color(0xFFFFB74D),
    },
    {
      'id': 'friendship',
      'title': 'Friendship Skills',
      'description': 'Making & keeping friends',
      'icon': '🤝',
      'color': const Color(0xFF4FC3F7),
    },
    {
      'id': 'empathy',
      'title': 'Empathy & Kindness',
      'description': 'Understanding others',
      'icon': '💝',
      'color': const Color(0xFFEC407A),
    },
    {
      'id': 'self_control',
      'title': 'Self Control',
      'description': 'Managing impulses',
      'icon': '🧘',
      'color': const Color(0xFF26A69A),
    },
    {
      'id': 'conflict_resolution',
      'title': 'Conflict Resolution',
      'description': 'Solving problems peacefully',
      'icon': '🕊️',
      'color': const Color(0xFF42A5F5),
    },
    {
      'id': 'self_esteem',
      'title': 'Self Esteem',
      'description': 'Building confidence',
      'icon': '⭐',
      'color': const Color(0xFFFFD54F),
    },

    // ========== COGNITIVE SKILLS ==========
    {
      'id': 'memory_skills',
      'title': 'Memory Skills',
      'description': 'Improve memory',
      'icon': '🧠',
      'color': const Color(0xFF7E57C2),
    },
    {
      'id': 'attention_focus',
      'title': 'Attention & Focus',
      'description': 'Concentration exercises',
      'icon': '🎯',
      'color': const Color(0xFF26A69A),
    },
    {
      'id': 'problem_solving',
      'title': 'Problem Solving',
      'description': 'Think & solve',
      'icon': '💡',
      'color': const Color(0xFFFFCA28),
    },

    // ========== EXECUTIVE FUNCTION ==========
    {
      'id': 'planning',
      'title': 'Planning Skills',
      'description': 'Learn to plan ahead',
      'icon': '📋',
      'color': const Color(0xFF5C6BC0),
    },
    {
      'id': 'organization',
      'title': 'Organization',
      'description': 'Keep things organized',
      'icon': '📁',
      'color': const Color(0xFF00897B),
    },
    {
      'id': 'task_initiation',
      'title': 'Task Initiation',
      'description': 'Getting started',
      'icon': '🚀',
      'color': const Color(0xFFFF7043),
    },
    {
      'id': 'flexibility',
      'title': 'Cognitive Flexibility',
      'description': 'Adapt & change',
      'icon': '🔄',
      'color': const Color(0xFF26C6DA),
    },
    {
      'id': 'working_memory',
      'title': 'Working Memory',
      'description': 'Hold & use info',
      'icon': '📝',
      'color': const Color(0xFFAB47BC),
    },
    {
      'id': 'impulse_control',
      'title': 'Impulse Control',
      'description': 'Think before acting',
      'icon': '⏸️',
      'color': const Color(0xFFEF5350),
    },

    // ========== DIGITAL LITERACY ==========
    {
      'id': 'screen_safety',
      'title': 'Screen Safety',
      'description': 'Safe screen time',
      'icon': '📱',
      'color': const Color(0xFF1E88E5),
    },
    {
      'id': 'internet_basics',
      'title': 'Internet Basics',
      'description': 'Safe internet use',
      'icon': '🌐',
      'color': const Color(0xFF00ACC1),
    },
    {
      'id': 'typing_basics',
      'title': 'Typing Basics',
      'description': 'Learn to type',
      'icon': '⌨️',
      'color': const Color(0xFF546E7A),
    },
    {
      'id': 'digital_citizenship',
      'title': 'Digital Citizenship',
      'description': 'Be a good digital citizen',
      'icon': '🏛️',
      'color': const Color(0xFF5E35B1),
    },
    {
      'id': 'media_literacy',
      'title': 'Media Literacy',
      'description': 'Understand media',
      'icon': '📺',
      'color': const Color(0xFFE91E63),
    },

    // ========== SUSTAINABILITY ==========
    {
      'id': 'recycling',
      'title': 'Recycling for Kids',
      'description': 'Reduce, reuse, recycle',
      'icon': '♻️',
      'color': const Color(0xFF4CAF50),
    },
    {
      'id': 'climate',
      'title': 'Climate Awareness',
      'description': 'Understand climate',
      'icon': '🌍',
      'color': const Color(0xFF00BCD4),
    },
    {
      'id': 'sustainable_habits',
      'title': 'Sustainable Habits',
      'description': 'Eco-friendly living',
      'icon': '🌱',
      'color': const Color(0xFF8BC34A),
    },

    // ========== SOCIAL STUDIES ==========
    {
      'id': 'community_helpers',
      'title': 'Community Helpers',
      'description': 'People who help us',
      'icon': '👨‍🚒',
      'color': const Color(0xFFF44336),
    },
    {
      'id': 'family',
      'title': 'Family & Relationships',
      'description': 'Learn about family',
      'icon': '👨‍👩‍👧‍👦',
      'color': const Color(0xFFE91E63),
    },
    {
      'id': 'maps',
      'title': 'Maps & Directions',
      'description': 'Learn to read maps',
      'icon': '🗺️',
      'color': const Color(0xFF2196F3),
    },
    {
      'id': 'countries_flags',
      'title': 'Countries & Flags',
      'description': 'Learn world flags',
      'icon': '🏳️',
      'color': const Color(0xFF673AB7),
    },
    {
      'id': 'cultures',
      'title': 'World Cultures',
      'description': 'Different cultures',
      'icon': '🌍',
      'color': const Color(0xFF009688),
    },

    // ========== MUSIC & ARTS ==========
    {
      'id': 'music_basics',
      'title': 'Music Basics',
      'description': 'Learn about music',
      'icon': '🎼',
      'color': const Color(0xFF9C27B0),
    },
    {
      'id': 'instruments',
      'title': 'Musical Instruments',
      'description': 'Learn instruments',
      'icon': '🎸',
      'color': const Color(0xFF795548),
    },
    {
      'id': 'singing',
      'title': 'Singing & Songs',
      'description': 'Learn to sing',
      'icon': '🎤',
      'color': const Color(0xFFFF4081),
    },
    {
      'id': 'dance',
      'title': 'Dance & Movement',
      'description': 'Learn dance moves',
      'icon': '💃',
      'color': const Color(0xFFE040FB),
    },
    {
      'id': 'art_crafts',
      'title': 'Arts & Crafts',
      'description': 'Creative art activities',
      'icon': '🎨',
      'color': const Color(0xFFFF5722),
    },

    // ========== ANIMATED CONTENT ==========
    {
      'id': 'animated_stories',
      'title': 'Animated Stories',
      'description': 'Watch & learn',
      'icon': '🎬',
      'color': const Color(0xFF3F51B5),
    },
    {
      'id': 'animated_rhymes',
      'title': 'Animated Rhymes',
      'description': 'Sing-along videos',
      'icon': '🎥',
      'color': const Color(0xFFE91E63),
    },
    {
      'id': 'animated_lessons',
      'title': 'Animated Lessons',
      'description': 'Video lessons',
      'icon': '📽️',
      'color': const Color(0xFF00BCD4),
    },
    {
      'id': 'cartoons',
      'title': 'Educational Cartoons',
      'description': 'Learn with cartoons',
      'icon': '📺',
      'color': const Color(0xFFFF9800),
    },

    // ========== FLASHCARDS & WORKSHEETS ==========
    {
      'id': 'flashcards',
      'title': 'Flashcard Sets',
      'description': 'All flashcards offline',
      'icon': '🃏',
      'color': const Color(0xFF607D8B),
    },
    {
      'id': 'worksheets',
      'title': 'Printable Worksheets',
      'description': 'Practice worksheets',
      'icon': '📄',
      'color': const Color(0xFF9E9E9E),
    },

    // ========== ASSESSMENT & QUIZ ==========
    {
      'id': 'assessment_tests',
      'title': 'Assessment Tests',
      'description': 'Test your learning',
      'icon': '📝',
      'color': const Color(0xFF673AB7),
    },
    {
      'id': 'quiz_bank',
      'title': 'Quiz Bank',
      'description': 'Thousands of quizzes',
      'icon': '❓',
      'color': const Color(0xFF00BCD4),
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
    offline = Get.isRegistered<OfflineContentService>()
        ? Get.find<OfflineContentService>()
        : Get.put(OfflineContentService());
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

  int get totalDownloaded => offline.readyCount;

  /// Real bytes, summed from the files that were actually read.
  String get totalSizeLabel => OfflineContentService.formatBytes(
        offline.readyBytes,
      );

  /// Really reads the category's files out of the app bundle. Categories
  /// whose lessons are code rather than files finish at once, because they
  /// already work offline.
  Future<void> _downloadContent(String id) => offline.prepare(id);

  void _deleteContent(String id) {
    // Find the content name for display
    final content = offlineCategories.firstWhere(
      (cat) => cat['id'] == id,
      orElse: () => {'name': 'Content'},
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF5F5), Color(0xFFFFE5E5), Color(0xFFFFF0F0)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
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
                      padding: EdgeInsets.all(16.r),
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
                            blurRadius: 10.r,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.white,
                        size: 40.r,
                      ),
                    ),
                    SizedBox(height: 12.h),
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
                padding: EdgeInsets.all(24.r),
                child: Column(
                  children: [
                    // Content info card
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFFF6B6B,
                            ).withValues(alpha: 0.1),
                            blurRadius: 8.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF6B6B),
                                  Color(0xFFFF8E53),
                                  Color(0xFFFFAA5A),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              content['icon'] ?? '📦',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          SizedBox(width: 12.w),
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
                                  offline.sizeLabel(id),
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

                    SizedBox(height: 16.h),

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

                    SizedBox(height: 24.h),

                    // Action buttons
                    Row(
                      children: [
                        // Cancel button
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () => Get.back(),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
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

                        SizedBox(width: 12.w),

                        // Delete button
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF6B6B),
                                  Color(0xFFFF8E53),
                                  Color(0xFFFFAA5A),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFF6B6B,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 8.r,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                                offline.remove(id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white,
                                    size: 20.r,
                                  ),
                                  SizedBox(width: 8.w),
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
          "Offline Learning",
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
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
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
    );
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
              if (isListening)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: _buildWaveAnimation(),
                  ),
                ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Icon(
                      isListening ? Icons.mic : Icons.search,
                      color: Colors.white,
                      size: 22.r,
                    ),
                  ),
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
                              hintText: 'Search content...',
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
            'No Content Found',
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

  Widget _buildStorageInfoCard() {
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.25),
              Colors.white.withValues(alpha: 0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Icon(
                  Icons.cloud_download_rounded,
                  color: Colors.white,
                  size: 28.r,
                ),
              ),
            ),
            SizedBox(width: 16.w),
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
                  SizedBox(height: 4.h),
                  Text(
                    '$totalDownloaded of ${offlineCategories.length} categories',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.r),
                    child: LinearProgressIndicator(
                      value: totalDownloaded / offlineCategories.length,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                      minHeight: 8.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                totalSizeLabel,
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
      // Touch the map so this rebuilds when the service updates.
      _entries.length;
      final isDownloaded = offline.isReady(id);
      final isDownloading = offline.isWorking(id);
      final progress = offline.progress[id] ?? 0.0;

      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: isDownloaded
              ? Border.all(color: const Color(0xFFFFD700), width: 3)
              : null,
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -15.h,
              right: -15.w,
              child: Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -20.h,
              left: -20.w,
              child: Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 64.w,
                    height: 64.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16.r),
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
                  SizedBox(width: 16.w),
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
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 2.r,
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isDownloaded)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFD700),
                                      Color(0xFFFFA500),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 12.r,
                                    ),
                                    SizedBox(width: 4.w),
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
                        SizedBox(height: 4.h),
                        Text(
                          offline.isBuiltIn(category['id'])
                              ? 'Built in • works with no internet'
                              : offline.sizeLabel(category['id']),
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        if (isDownloading) ...[
                          SizedBox(height: 8.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.3,
                              ),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              minHeight: 6.h,
                            ),
                          ),
                          SizedBox(height: 4.h),
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
                  SizedBox(width: 8.w),
                  // Action Button
                  if (isDownloading)
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.r,
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
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                            size: 22.r,
                          ),
                        ),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () => _downloadContent(id),
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                            size: 22.r,
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
