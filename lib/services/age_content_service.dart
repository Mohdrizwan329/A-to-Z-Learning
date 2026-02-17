import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Age groups for content filtering
enum AgeGroup {
  toddler, // 2-4 years (Toddler / Nursery)
  lkgUkg, // 4-6 years (LKG / UKG)
  class1To2, // 6-8 years (Class 1-2)
  class3To4, // 8-10 years (Class 3-4)
  class5To6, // 10-12 years (Class 5-6)
}

/// Extension to get age group details
extension AgeGroupExtension on AgeGroup {
  String get displayName {
    switch (this) {
      case AgeGroup.toddler:
        return '2-4 Years';
      case AgeGroup.lkgUkg:
        return '4-6 Years';
      case AgeGroup.class1To2:
        return '6-8 Years';
      case AgeGroup.class3To4:
        return '8-10 Years';
      case AgeGroup.class5To6:
        return '10-12 Years';
    }
  }

  String get subtitle {
    switch (this) {
      case AgeGroup.toddler:
        return 'Toddler / Nursery';
      case AgeGroup.lkgUkg:
        return 'LKG / UKG';
      case AgeGroup.class1To2:
        return 'Class 1-2';
      case AgeGroup.class3To4:
        return 'Class 3-4';
      case AgeGroup.class5To6:
        return 'Class 5-6';
    }
  }

  String get emoji {
    switch (this) {
      case AgeGroup.toddler:
        return '👶';
      case AgeGroup.lkgUkg:
        return '💒';
      case AgeGroup.class1To2:
        return '👦';
      case AgeGroup.class3To4:
        return '🧒';
      case AgeGroup.class5To6:
        return '🎓';
    }
  }

  String get description {
    switch (this) {
      case AgeGroup.toddler:
        return 'Basic learning with colorful visuals and simple sounds';
      case AgeGroup.lkgUkg:
        return 'Interactive learning with games and activities';
      case AgeGroup.class1To2:
        return 'Foundational reading, writing and basic math';
      case AgeGroup.class3To4:
        return 'Advanced concepts with quizzes and challenges';
      case AgeGroup.class5To6:
        return 'Complex problem solving and critical thinking';
    }
  }

  int get minAge {
    switch (this) {
      case AgeGroup.toddler:
        return 2;
      case AgeGroup.lkgUkg:
        return 4;
      case AgeGroup.class1To2:
        return 6;
      case AgeGroup.class3To4:
        return 8;
      case AgeGroup.class5To6:
        return 10;
    }
  }

  int get maxAge {
    switch (this) {
      case AgeGroup.toddler:
        return 4;
      case AgeGroup.lkgUkg:
        return 6;
      case AgeGroup.class1To2:
        return 8;
      case AgeGroup.class3To4:
        return 10;
      case AgeGroup.class5To6:
        return 12;
    }
  }
}

/// Content difficulty levels
enum ContentDifficulty { easy, medium, hard }

/// Content item with age-appropriate metadata
class AgeContent {
  final String id;
  final String title;
  final String category;
  final List<AgeGroup> suitableAgeGroups;
  final ContentDifficulty difficulty;
  final bool hasVoice;
  final bool hasAnimation;
  final bool hasGame;

  const AgeContent({
    required this.id,
    required this.title,
    required this.category,
    required this.suitableAgeGroups,
    required this.difficulty,
    this.hasVoice = true,
    this.hasAnimation = false,
    this.hasGame = false,
  });
}

/// Service for managing age-appropriate content
class AgeContentService extends GetxService {
  final GetStorage _box = GetStorage();

  // Current age group
  final Rx<AgeGroup> currentAgeGroup = AgeGroup.lkgUkg.obs;

  // Whether age has been selected
  final RxBool hasSelectedAge = false.obs;

  // Child's actual age (if provided)
  final RxInt childAge = 5.obs;

  Future<AgeContentService> init() async {
    _loadSettings();
    return this;
  }

  void _loadSettings() {
    final savedAgeGroup = _box.read<int>('age_group');
    if (savedAgeGroup != null && savedAgeGroup < AgeGroup.values.length) {
      currentAgeGroup.value = AgeGroup.values[savedAgeGroup];
      hasSelectedAge.value = true;
    }

    final savedAge = _box.read<int>('child_age');
    if (savedAge != null) {
      childAge.value = savedAge;
    }
  }

  /// Set age group directly
  Future<void> setAgeGroup(AgeGroup ageGroup) async {
    currentAgeGroup.value = ageGroup;
    hasSelectedAge.value = true;
    await _box.write('age_group', ageGroup.index);
  }

  /// Set child's age and automatically determine age group
  Future<void> setChildAge(int age) async {
    childAge.value = age;
    await _box.write('child_age', age);

    // Auto-determine age group based on new ranges
    if (age >= 10) {
      await setAgeGroup(AgeGroup.class5To6); // 10-12 years (Class 5-6)
    } else if (age >= 8) {
      await setAgeGroup(AgeGroup.class3To4); // 8-10 years (Class 3-4)
    } else if (age >= 6) {
      await setAgeGroup(AgeGroup.class1To2); // 6-8 years (Class 1-2)
    } else if (age >= 4) {
      await setAgeGroup(AgeGroup.lkgUkg); // 4-6 years (LKG / UKG)
    } else {
      await setAgeGroup(AgeGroup.toddler); // 2-4 years (Toddler / Nursery)
    }
  }

  /// Get age group from age number
  static AgeGroup getAgeGroupFromAge(int age) {
    if (age >= 10) return AgeGroup.class5To6; // 10-12 years (Class 5-6)
    if (age >= 8) return AgeGroup.class3To4; // 8-10 years (Class 3-4)
    if (age >= 6) return AgeGroup.class1To2; // 6-8 years (Class 1-2)
    if (age >= 4) return AgeGroup.lkgUkg; // 4-6 years (LKG / UKG)
    return AgeGroup.toddler; // 2-4 years (Toddler / Nursery)
  }

  /// Check if content is suitable for current age group
  bool isContentSuitable(AgeContent content) {
    return content.suitableAgeGroups.contains(currentAgeGroup.value);
  }

  /// Filter content list by current age group
  List<T> filterContentByAge<T>(
    List<T> items,
    AgeGroup Function(T) getAgeGroup,
  ) {
    return items
        .where((item) => getAgeGroup(item) == currentAgeGroup.value)
        .toList();
  }

  /// Get content configuration for current age group
  AgeContentConfig getContentConfig() {
    switch (currentAgeGroup.value) {
      case AgeGroup.toddler:
        return const AgeContentConfig(
          showNumbers: true,
          maxNumber: 10,
          showAlphabets: true,
          alphabetType: AlphabetType.capitalOnly,
          showColors: true,
          maxColors: 6,
          showShapes: true,
          maxShapes: 4,
          showAnimals: true,
          maxAnimals: 10,
          showMathOperations: false,
          showTables: false,
          showQuiz: false,
          showGames: true,
          gameComplexity: 1,
          voiceSpeed: 0.7,
          animationSpeed: 0.8,
          showHindiContent: true,
          hindiComplexity: 1,
        );
      case AgeGroup.lkgUkg:
        return const AgeContentConfig(
          showNumbers: true,
          maxNumber: 50,
          showAlphabets: true,
          alphabetType: AlphabetType.both,
          showColors: true,
          maxColors: 12,
          showShapes: true,
          maxShapes: 8,
          showAnimals: true,
          maxAnimals: 20,
          showMathOperations: true,
          mathOperations: [MathOperation.addition, MathOperation.subtraction],
          showTables: true,
          maxTable: 5,
          showQuiz: true,
          quizComplexity: 1,
          showGames: true,
          gameComplexity: 2,
          voiceSpeed: 0.85,
          animationSpeed: 1.0,
          showHindiContent: true,
          hindiComplexity: 2,
        );
      case AgeGroup.class1To2:
        return const AgeContentConfig(
          showNumbers: true,
          maxNumber: 100,
          showAlphabets: true,
          alphabetType: AlphabetType.both,
          showColors: true,
          maxColors: 20,
          showShapes: true,
          maxShapes: 12,
          showAnimals: true,
          maxAnimals: 50,
          showMathOperations: true,
          mathOperations: [
            MathOperation.addition,
            MathOperation.subtraction,
            MathOperation.multiplication,
          ],
          showTables: true,
          maxTable: 10,
          showQuiz: true,
          quizComplexity: 2,
          showGames: true,
          gameComplexity: 2,
          voiceSpeed: 0.9,
          animationSpeed: 1.0,
          showHindiContent: true,
          hindiComplexity: 2,
        );
      case AgeGroup.class3To4:
        return const AgeContentConfig(
          showNumbers: true,
          maxNumber: 1000,
          showAlphabets: true,
          alphabetType: AlphabetType.both,
          showColors: true,
          maxColors: 30,
          showShapes: true,
          maxShapes: 15,
          showAnimals: true,
          maxAnimals: 80,
          showMathOperations: true,
          mathOperations: [
            MathOperation.addition,
            MathOperation.subtraction,
            MathOperation.multiplication,
            MathOperation.division,
          ],
          showTables: true,
          maxTable: 15,
          showQuiz: true,
          quizComplexity: 3,
          showGames: true,
          gameComplexity: 3,
          voiceSpeed: 1.0,
          animationSpeed: 1.0,
          showHindiContent: true,
          hindiComplexity: 3,
        );
      case AgeGroup.class5To6:
        return const AgeContentConfig(
          showNumbers: true,
          maxNumber: 10000,
          showAlphabets: true,
          alphabetType: AlphabetType.both,
          showColors: true,
          maxColors: 50,
          showShapes: true,
          maxShapes: 20,
          showAnimals: true,
          maxAnimals: 100,
          showMathOperations: true,
          mathOperations: [
            MathOperation.addition,
            MathOperation.subtraction,
            MathOperation.multiplication,
            MathOperation.division,
          ],
          showTables: true,
          maxTable: 20,
          showQuiz: true,
          quizComplexity: 4,
          showGames: true,
          gameComplexity: 4,
          voiceSpeed: 1.0,
          animationSpeed: 1.0,
          showHindiContent: true,
          hindiComplexity: 4,
        );
    }
  }

  /// Get recommended features for current age group
  List<RecommendedFeature> getRecommendedFeatures() {
    switch (currentAgeGroup.value) {
      case AgeGroup.toddler:
        return [
          const RecommendedFeature(
            icon: '🔢',
            title: 'Numbers 1-10',
            route: '/NumbersScreen',
            priority: 1,
          ),
          const RecommendedFeature(
            icon: '🔤',
            title: 'ABC Alphabets',
            route: '/AlphabetMeaning',
            priority: 2,
          ),
          const RecommendedFeature(
            icon: '🎨',
            title: 'Colors',
            route: '/home',
            priority: 3,
          ),
          const RecommendedFeature(
            icon: '✍️',
            title: 'Drawing',
            route: '/DrowingScreen',
            priority: 4,
          ),
        ];
      case AgeGroup.lkgUkg:
        return [
          const RecommendedFeature(
            icon: '🔢',
            title: 'Numbers 1-50',
            route: '/NumbersScreen',
            priority: 1,
          ),
          const RecommendedFeature(
            icon: '🔤',
            title: 'Alphabets A-Z',
            route: '/AlphabetMeaning',
            priority: 2,
          ),
          const RecommendedFeature(
            icon: '➕',
            title: 'Addition',
            route: '/MathGridScreen',
            priority: 3,
          ),
          const RecommendedFeature(
            icon: '📊',
            title: 'Tables 1-5',
            route: '/TableScreen',
            priority: 4,
          ),
          const RecommendedFeature(
            icon: '🎮',
            title: 'Games',
            route: '/games',
            priority: 5,
          ),
        ];
      case AgeGroup.class1To2:
        return [
          const RecommendedFeature(
            icon: '🔢',
            title: 'Numbers',
            route: '/NumbersScreen',
            priority: 1,
          ),
          const RecommendedFeature(
            icon: '📊',
            title: 'Tables 1-10',
            route: '/TableScreen',
            priority: 2,
          ),
          const RecommendedFeature(
            icon: '➕',
            title: 'Math Operations',
            route: '/MathGridScreen',
            priority: 3,
          ),
          const RecommendedFeature(
            icon: '📝',
            title: 'Quiz',
            route: '/quiz',
            priority: 4,
          ),
          const RecommendedFeature(
            icon: '🎮',
            title: 'Games',
            route: '/games',
            priority: 5,
          ),
        ];
      case AgeGroup.class3To4:
        return [
          const RecommendedFeature(
            icon: '🔢',
            title: 'Numbers',
            route: '/NumbersScreen',
            priority: 1,
          ),
          const RecommendedFeature(
            icon: '📊',
            title: 'Tables 1-15',
            route: '/TableScreen',
            priority: 2,
          ),
          const RecommendedFeature(
            icon: '➗',
            title: 'All Math Operations',
            route: '/MathGridScreen',
            priority: 3,
          ),
          const RecommendedFeature(
            icon: '📝',
            title: 'Quiz',
            route: '/quiz',
            priority: 4,
          ),
          const RecommendedFeature(
            icon: '🏆',
            title: 'Leaderboard',
            route: '/leaderboard',
            priority: 5,
          ),
        ];
      case AgeGroup.class5To6:
        return [
          const RecommendedFeature(
            icon: '🔢',
            title: 'Advanced Numbers',
            route: '/NumbersScreen',
            priority: 1,
          ),
          const RecommendedFeature(
            icon: '📊',
            title: 'Tables 1-20',
            route: '/TableScreen',
            priority: 2,
          ),
          const RecommendedFeature(
            icon: '➗',
            title: 'Advanced Math',
            route: '/MathGridScreen',
            priority: 3,
          ),
          const RecommendedFeature(
            icon: '📝',
            title: 'Quiz',
            route: '/quiz',
            priority: 4,
          ),
          const RecommendedFeature(
            icon: '🏆',
            title: 'Leaderboard',
            route: '/leaderboard',
            priority: 5,
          ),
        ];
    }
  }

  /// Reset age selection (for changing child profile)
  Future<void> resetAgeSelection() async {
    hasSelectedAge.value = false;
    await _box.remove('age_group');
    await _box.remove('child_age');
  }
}

/// Configuration for age-appropriate content
class AgeContentConfig {
  final bool showNumbers;
  final int maxNumber;
  final bool showAlphabets;
  final AlphabetType alphabetType;
  final bool showColors;
  final int maxColors;
  final bool showShapes;
  final int maxShapes;
  final bool showAnimals;
  final int maxAnimals;
  final bool showMathOperations;
  final List<MathOperation> mathOperations;
  final bool showTables;
  final int maxTable;
  final bool showQuiz;
  final int quizComplexity;
  final bool showGames;
  final int gameComplexity;
  final double voiceSpeed;
  final double animationSpeed;
  final bool showHindiContent;
  final int hindiComplexity;

  const AgeContentConfig({
    this.showNumbers = true,
    this.maxNumber = 100,
    this.showAlphabets = true,
    this.alphabetType = AlphabetType.both,
    this.showColors = true,
    this.maxColors = 20,
    this.showShapes = true,
    this.maxShapes = 12,
    this.showAnimals = true,
    this.maxAnimals = 50,
    this.showMathOperations = true,
    this.mathOperations = const [MathOperation.addition],
    this.showTables = true,
    this.maxTable = 20,
    this.showQuiz = true,
    this.quizComplexity = 1,
    this.showGames = true,
    this.gameComplexity = 1,
    this.voiceSpeed = 1.0,
    this.animationSpeed = 1.0,
    this.showHindiContent = true,
    this.hindiComplexity = 1,
  });
}

enum AlphabetType { capitalOnly, smallOnly, both }

enum MathOperation { addition, subtraction, multiplication, division }

/// Recommended feature for home screen
class RecommendedFeature {
  final String icon;
  final String title;
  final String route;
  final int priority;

  const RecommendedFeature({
    required this.icon,
    required this.title,
    required this.route,
    required this.priority,
  });
}
