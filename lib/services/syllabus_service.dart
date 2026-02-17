import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SyllabusService extends GetxService {
  final GetStorage _box = GetStorage();

  final Rx<SyllabusBoard> selectedBoard = SyllabusBoard.cbse.obs;
  final Rx<GradeLevel> selectedGrade = GradeLevel.lkg.obs;
  final RxBool syllabusMode = false.obs;
  final RxList<SyllabusTopic> currentTopics = <SyllabusTopic>[].obs;
  final RxMap<String, double> topicProgress = <String, double>{}.obs;

  // CBSE Curriculum for Early Years
  static final Map<GradeLevel, List<SyllabusTopic>> cbseCurriculum = {
    GradeLevel.nursery: [
      SyllabusTopic(
        id: 'nursery_alphabets',
        name: 'Alphabets Recognition',
        nameHindi: 'वर्णमाला पहचान',
        category: 'English',
        objectives: [
          'Recognize capital letters A-Z',
          'Identify letter sounds',
          'Trace letters',
        ],
        appFeatures: ['generic_alphabet_page', 'tracing_game'],
        iconEmoji: '🔤',
      ),
      SyllabusTopic(
        id: 'nursery_numbers',
        name: 'Numbers 1-10',
        nameHindi: 'संख्या 1-10',
        category: 'Mathematics',
        objectives: [
          'Count objects 1-10',
          'Recognize number symbols',
          'Write numbers',
        ],
        appFeatures: ['Number_Page'],
        iconEmoji: '🔢',
      ),
      SyllabusTopic(
        id: 'nursery_colors',
        name: 'Colors & Shapes',
        nameHindi: 'रंग और आकार',
        category: 'EVS',
        objectives: [
          'Identify primary colors',
          'Recognize basic shapes',
          'Color recognition in environment',
        ],
        appFeatures: ['colors_learning', 'shapes_learning'],
        iconEmoji: '🎨',
      ),
      SyllabusTopic(
        id: 'nursery_rhymes',
        name: 'Nursery Rhymes',
        nameHindi: 'बाल गीत',
        category: 'Language',
        objectives: [
          'Recite simple rhymes',
          'Understand rhythm and rhyme',
          'Vocabulary building',
        ],
        appFeatures: ['rhymes_page', 'poem_page'],
        iconEmoji: '🎵',
      ),
      SyllabusTopic(
        id: 'nursery_body',
        name: 'My Body',
        nameHindi: 'मेरा शरीर',
        category: 'EVS',
        objectives: [
          'Name body parts',
          'Understand body functions',
          'Hygiene habits',
        ],
        appFeatures: ['bodyparts_learning'],
        iconEmoji: '🧒',
      ),
    ],
    GradeLevel.lkg: [
      SyllabusTopic(
        id: 'lkg_alphabets',
        name: 'Alphabets & Phonics',
        nameHindi: 'वर्णमाला और ध्वनि',
        category: 'English',
        objectives: [
          'Capital and small letters',
          'Letter sounds (phonics)',
          'Simple three-letter words',
        ],
        appFeatures: [
          'generic_alphabet_page',
          'Alphabet_meaning',
        ],
        iconEmoji: '📖',
      ),
      SyllabusTopic(
        id: 'lkg_numbers',
        name: 'Numbers 1-20',
        nameHindi: 'संख्या 1-20',
        category: 'Mathematics',
        objectives: ['Count 1-20', 'Number names', 'Before and after numbers'],
        appFeatures: ['Number_Page'],
        iconEmoji: '🔢',
      ),
      SyllabusTopic(
        id: 'lkg_hindi',
        name: 'Hindi Varnamala',
        nameHindi: 'हिंदी वर्णमाला',
        category: 'Hindi',
        objectives: [
          'Hindi alphabets recognition',
          'Swar and Vyanjan',
          'Simple Hindi words',
        ],
        appFeatures: ['hindi_letters_page'],
        iconEmoji: '🇮🇳',
      ),
      SyllabusTopic(
        id: 'lkg_evs',
        name: 'My Environment',
        nameHindi: 'मेरा पर्यावरण',
        category: 'EVS',
        objectives: [
          'Animals and their homes',
          'Fruits and vegetables',
          'Seasons',
        ],
        appFeatures: [
          'animals_learning',
          'fruits_learning',
          'vegetables_learning',
          'seasons_learning',
        ],
        iconEmoji: '🌳',
      ),
      SyllabusTopic(
        id: 'lkg_gk',
        name: 'General Knowledge',
        nameHindi: 'सामान्य ज्ञान',
        category: 'GK',
        objectives: [
          'Days of week',
          'Months of year',
          'Common birds and flowers',
        ],
        appFeatures: [
          'weekday_learning',
          'month_learning',
          'birds_learning',
          'flowers_learning',
        ],
        iconEmoji: '🌟',
      ),
    ],
    GradeLevel.ukg: [
      SyllabusTopic(
        id: 'ukg_english',
        name: 'Reading & Writing',
        nameHindi: 'पढ़ना और लिखना',
        category: 'English',
        objectives: [
          'Read simple sentences',
          'Write words and sentences',
          'Picture reading',
        ],
        appFeatures: ['stories_page', 'Alphabet_meaning'],
        iconEmoji: '📝',
      ),
      SyllabusTopic(
        id: 'ukg_math',
        name: 'Numbers & Addition',
        nameHindi: 'संख्या और जोड़',
        category: 'Mathematics',
        objectives: ['Numbers 1-50', 'Simple addition', 'Number patterns'],
        appFeatures: ['Number_Page', 'generic_math_questions_page', 'Table_Page'],
        iconEmoji: '➕',
      ),
      SyllabusTopic(
        id: 'ukg_hindi',
        name: 'Hindi Reading',
        nameHindi: 'हिंदी पठन',
        category: 'Hindi',
        objectives: [
          'Matra combinations',
          'Simple Hindi sentences',
          'Hindi rhymes',
        ],
        appFeatures: ['hindi_letters_page'],
        iconEmoji: '📚',
      ),
      SyllabusTopic(
        id: 'ukg_evs',
        name: 'World Around Us',
        nameHindi: 'हमारे आसपास',
        category: 'EVS',
        objectives: ['Means of transport', 'Occupations', 'Festivals of India'],
        appFeatures: ['vehicles_learning', 'gk_learning', 'festival_content'],
        iconEmoji: '🌍',
      ),
    ],
    GradeLevel.class1: [
      SyllabusTopic(
        id: 'class1_english',
        name: 'English Language',
        nameHindi: 'अंग्रेजी भाषा',
        category: 'English',
        objectives: [
          'Read short stories',
          'Grammar basics',
          'Creative writing',
        ],
        appFeatures: ['stories_page', 'Alphabet_meaning'],
        iconEmoji: '📖',
      ),
      SyllabusTopic(
        id: 'class1_math',
        name: 'Mathematics',
        nameHindi: 'गणित',
        category: 'Mathematics',
        objectives: [
          'Numbers',
          'Addition & Subtraction',
          'Shapes and patterns',
        ],
        appFeatures: [
          'Number_Page',
          'generic_math_questions_page',
          'shapes_learning',
        ],
        iconEmoji: '🔢',
      ),
      SyllabusTopic(
        id: 'class1_hindi',
        name: 'Hindi Bhasha',
        nameHindi: 'हिंदी भाषा',
        category: 'Hindi',
        objectives: [
          'Hindi reading fluency',
          'Writing practice',
          'Comprehension',
        ],
        appFeatures: ['hindi_letters_page'],
        iconEmoji: '🇮🇳',
      ),
      SyllabusTopic(
        id: 'class1_evs',
        name: 'Environmental Studies',
        nameHindi: 'पर्यावरण अध्ययन',
        category: 'EVS',
        objectives: [
          'Living and non-living things',
          'Plants and animals',
          'Our helpers',
        ],
        appFeatures: ['animals_learning', 'birds_learning', 'gk_learning'],
        iconEmoji: '🌱',
      ),
    ],
    GradeLevel.class2: [
      SyllabusTopic(
        id: 'class2_english',
        name: 'English Comprehension',
        nameHindi: 'अंग्रेजी समझ',
        category: 'English',
        objectives: [
          'Story comprehension',
          'Vocabulary building',
          'Sentence formation',
        ],
        appFeatures: ['stories_page', 'Alphabet_meaning'],
        iconEmoji: '📚',
      ),
      SyllabusTopic(
        id: 'class2_math',
        name: 'Multiplication & Division',
        nameHindi: 'गुणा और भाग',
        category: 'Mathematics',
        objectives: [
          'Tables 2-10',
          'Multiplication concepts',
          'Simple division',
        ],
        appFeatures: ['Table_Page', 'generic_math_questions_page'],
        iconEmoji: '✖️',
      ),
      SyllabusTopic(
        id: 'class2_hindi',
        name: 'Hindi Vyakaran',
        nameHindi: 'हिंदी व्याकरण',
        category: 'Hindi',
        objectives: ['Sangya, Sarvanam', 'Sentence types', 'Essay writing'],
        appFeatures: ['hindi_letters_page'],
        iconEmoji: '✍️',
      ),
      SyllabusTopic(
        id: 'class2_evs',
        name: 'Our Environment',
        nameHindi: 'हमारा पर्यावरण',
        category: 'EVS',
        objectives: ['Water and air', 'Food and nutrition', 'Safety rules'],
        appFeatures: ['gk_learning', 'fruits_learning', 'vegetables_learning'],
        iconEmoji: '🌊',
      ),
    ],
  };

  // ICSE has similar but different emphasis
  static final Map<GradeLevel, List<SyllabusTopic>> icseCurriculum = {
    // ICSE has more focus on English and creative learning
    GradeLevel.nursery: [
      SyllabusTopic(
        id: 'icse_nursery_english',
        name: 'Pre-Reading Skills',
        nameHindi: 'पूर्व पठन कौशल',
        category: 'English',
        objectives: [
          'Picture recognition',
          'Listening skills',
          'Alphabet introduction',
        ],
        appFeatures: ['generic_alphabet_page', 'stories_page'],
        iconEmoji: '👀',
      ),
      SyllabusTopic(
        id: 'icse_nursery_math',
        name: 'Pre-Number Concepts',
        nameHindi: 'पूर्व संख्या अवधारणाएं',
        category: 'Mathematics',
        objectives: [
          'Sorting and matching',
          'Big/Small concepts',
          'Counting 1-5',
        ],
        appFeatures: ['Number_Page', 'shapes_learning'],
        iconEmoji: '🔢',
      ),
    ],
    GradeLevel.lkg: cbseCurriculum[GradeLevel.lkg]!,
    GradeLevel.ukg: cbseCurriculum[GradeLevel.ukg]!,
    GradeLevel.class1: cbseCurriculum[GradeLevel.class1]!,
    GradeLevel.class2: cbseCurriculum[GradeLevel.class2]!,
  };

  Future<SyllabusService> init() async {
    await _loadSettings();
    _loadCurrentTopics();
    return this;
  }

  Future<void> _loadSettings() async {
    final board = _box.read<String>('syllabus_board');
    if (board != null) {
      selectedBoard.value = SyllabusBoard.values.firstWhere(
        (b) => b.name == board,
        orElse: () => SyllabusBoard.cbse,
      );
    }

    final grade = _box.read<String>('syllabus_grade');
    if (grade != null) {
      selectedGrade.value = GradeLevel.values.firstWhere(
        (g) => g.name == grade,
        orElse: () => GradeLevel.lkg,
      );
    }

    syllabusMode.value = _box.read<bool>('syllabus_mode') ?? false;

    // Load progress
    final progress = _box.read<Map>('topic_progress');
    if (progress != null) {
      topicProgress.value = progress.cast<String, double>();
    }
  }

  Future<void> setBoard(SyllabusBoard board) async {
    selectedBoard.value = board;
    await _box.write('syllabus_board', board.name);
    _loadCurrentTopics();
  }

  Future<void> setGrade(GradeLevel grade) async {
    selectedGrade.value = grade;
    await _box.write('syllabus_grade', grade.name);
    _loadCurrentTopics();
  }

  Future<void> setSyllabusMode(bool enabled) async {
    syllabusMode.value = enabled;
    await _box.write('syllabus_mode', enabled);
  }

  void _loadCurrentTopics() {
    final curriculum = selectedBoard.value == SyllabusBoard.cbse
        ? cbseCurriculum
        : icseCurriculum;

    currentTopics.value = curriculum[selectedGrade.value] ?? [];
  }

  // Update progress for a topic
  Future<void> updateTopicProgress(String topicId, double progress) async {
    topicProgress[topicId] = progress.clamp(0.0, 1.0);
    await _box.write('topic_progress', topicProgress.toJson());
  }

  // Get progress for a topic
  double getTopicProgress(String topicId) {
    return topicProgress[topicId] ?? 0.0;
  }

  // Get overall syllabus progress
  double get overallProgress {
    if (currentTopics.isEmpty) return 0;

    double total = 0;
    for (final topic in currentTopics) {
      total += getTopicProgress(topic.id);
    }

    return total / currentTopics.length;
  }

  // Get topics by category
  Map<String, List<SyllabusTopic>> getTopicsByCategory() {
    final grouped = <String, List<SyllabusTopic>>{};

    for (final topic in currentTopics) {
      grouped.putIfAbsent(topic.category, () => []);
      grouped[topic.category]!.add(topic);
    }

    return grouped;
  }

  // Get recommended topics (incomplete ones)
  List<SyllabusTopic> getRecommendedTopics() {
    return currentTopics
        .where((topic) => getTopicProgress(topic.id) < 1.0)
        .take(3)
        .toList();
  }

  // Check if app feature maps to current syllabus
  bool isFeatureInSyllabus(String featureName) {
    for (final topic in currentTopics) {
      if (topic.appFeatures.contains(featureName)) {
        return true;
      }
    }
    return false;
  }

  // Get syllabus topic for an app feature
  SyllabusTopic? getTopicForFeature(String featureName) {
    for (final topic in currentTopics) {
      if (topic.appFeatures.contains(featureName)) {
        return topic;
      }
    }
    return null;
  }

  // Grade display names
  static String getGradeDisplayName(GradeLevel grade) {
    switch (grade) {
      case GradeLevel.nursery:
        return 'Nursery';
      case GradeLevel.lkg:
        return 'LKG';
      case GradeLevel.ukg:
        return 'UKG';
      case GradeLevel.class1:
        return 'Class 1';
      case GradeLevel.class2:
        return 'Class 2';
    }
  }

  // Board display names
  static String getBoardDisplayName(SyllabusBoard board) {
    switch (board) {
      case SyllabusBoard.cbse:
        return 'CBSE';
      case SyllabusBoard.icse:
        return 'ICSE';
      case SyllabusBoard.state:
        return 'State Board';
    }
  }
}

enum SyllabusBoard { cbse, icse, state }

enum GradeLevel { nursery, lkg, ukg, class1, class2 }

class SyllabusTopic {
  final String id;
  final String name;
  final String nameHindi;
  final String category;
  final List<String> objectives;
  final List<String> appFeatures;
  final String iconEmoji;

  SyllabusTopic({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.category,
    required this.objectives,
    required this.appFeatures,
    required this.iconEmoji,
  });
}
