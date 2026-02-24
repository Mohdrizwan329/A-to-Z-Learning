import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/rewards_service.dart';

class ProgressService extends GetxService {
  static ProgressService get to => Get.find<ProgressService>();

  final GetStorage _storage = GetStorage();

  // Progress keys for all screens
  static const String kNumbers = 'progress_numbers';
  static const String kCapitalLetters = 'progress_capital_letters';
  static const String kSmallLetters = 'progress_small_letters';
  static const String kHindiLetters = 'progress_hindi_letters';
  static const String kAlphabetWords = 'progress_alphabet_words';
  static const String kTables = 'progress_tables';
  static const String kMathAddition = 'progress_math_addition';
  static const String kMathSubtraction = 'progress_math_subtraction';
  static const String kMathMultiplication = 'progress_math_multiplication';
  static const String kMathDivision = 'progress_math_division';
  static const String kAnimals = 'progress_animals';
  static const String kBirds = 'progress_birds';
  static const String kFruits = 'progress_fruits';
  static const String kVegetables = 'progress_vegetables';
  static const String kFlowers = 'progress_flowers';
  static const String kColors = 'progress_colors';
  static const String kBodyParts = 'progress_bodyparts';
  static const String kMonths = 'progress_months';
  static const String kWeekDays = 'progress_weekdays';
  static const String kPoems = 'progress_poems';
  static const String kShapes = 'progress_shapes';
  static const String kVehicles = 'progress_vehicles';
  static const String kSeasons = 'progress_seasons';
  static const String kGK = 'progress_gk';
  static const String kStories = 'progress_stories';
  static const String kRhymes = 'progress_rhymes';
  static const String kColoring = 'progress_coloring';
  static const String kMusicNotes = 'progress_music_notes';
  static const String kMusicInstruments = 'progress_music_instruments';
  static const String kMusicFacts = 'progress_music_facts';
  static const String kRhythm = 'progress_rhythm';
  static const String kWorldMap = 'progress_world_map';
  static const String kCountriesFlags = 'progress_countries_flags';
  static const String kFamousPlaces = 'progress_famous_places';
  static const String kEngineeringKids = 'progress_engineering_kids';
  static const String kStemChallenges = 'progress_stem_challenges';
  static const String kSteamLearning = 'progress_steam_learning';
  static const String kClimateAwareness = 'progress_climate_awareness';
  static const String kRecyclingKids = 'progress_recycling_kids';
  static const String kSustainableHabits = 'progress_sustainable_habits';
  static const String kCitizenshipBasics = 'progress_citizenship_basics';
  static const String kRights = 'progress_rights';
  static const String kDuties = 'progress_duties';
  static const String kThinkAboutThinking = 'progress_think_about_thinking';
  static const String kSelfReflection = 'progress_self_reflection';
  static const String kLearningStrategy = 'progress_learning_strategy';
  static const String kNutritionLearning = 'progress_nutrition_learning';
  static const String kExerciseFitness = 'progress_exercise_fitness';
  static const String kMentalHealth = 'progress_mental_health';
  static const String kBodySafety = 'progress_body_safety';
  static const String kFamilyRelationships = 'progress_family_relationships';
  static const String kGlobalCultures = 'progress_global_cultures';

  // Animated Videos progress keys
  static const String kAnimatedABC = 'progress_animated_abc';
  static const String kAnimatedNumbers = 'progress_animated_numbers';
  static const String kAnimatedRhymes = 'progress_animated_rhymes';
  static const String kAnimatedStories = 'progress_animated_stories';

  // Early Learning progress keys
  static const String kSensoryLearning = 'progress_sensory_learning';
  static const String kVisualLearning = 'progress_visual_learning';
  static const String kAudioLearning = 'progress_audio_learning';
  static const String kKinestheticLearning = 'progress_kinesthetic_learning';
  static const String kPlayBasedLearning = 'progress_play_based_learning';
  static const String kExploratoryLearning = 'progress_exploratory_learning';
  static const String kDiscoveryLearning = 'progress_discovery_learning';
  static const String kMontessoriLearning = 'progress_montessori_learning';
  static const String kActivityBasedLearning = 'progress_activity_based_learning';
  static const String kExperientialLearning = 'progress_experiential_learning';

  // Observable progress maps
  final RxMap<String, int> completedItems = <String, int>{}.obs;
  final RxMap<String, int> totalItems = <String, int>{}.obs;

  // Total items for each category
  final Map<String, int> categoryTotals = {
    kNumbers: 100,
    kCapitalLetters: 26,
    kSmallLetters: 26,
    kHindiLetters: 48,
    kAlphabetWords: 26,
    kTables: 39, // 2 to 40
    kMathAddition: 90,
    kMathSubtraction: 90,
    kMathMultiplication: 90,
    kMathDivision: 90,
    kAnimals: 30,
    kBirds: 30,
    kFruits: 30,
    kVegetables: 29,
    kFlowers: 30,
    kColors: 20,
    kBodyParts: 37,
    kMonths: 12,
    kWeekDays: 7,
    kPoems: 10,
    kShapes: 15,
    kVehicles: 20,
    kSeasons: 6,
    kGK: 50,
    kStories: 10,
    kRhymes: 15,
    kColoring: 35,
    kMusicNotes: 8,
    kMusicInstruments: 8,
    kMusicFacts: 10,
    kRhythm: 5,
    kWorldMap: 8,
    kCountriesFlags: 8,
    kFamousPlaces: 8,
    kEngineeringKids: 7,
    kStemChallenges: 8,
    kSteamLearning: 7,
    kClimateAwareness: 8,
    kRecyclingKids: 7,
    kSustainableHabits: 7,
    kCitizenshipBasics: 6,
    kRights: 8,
    kDuties: 8,
    kThinkAboutThinking: 6,
    kSelfReflection: 6,
    kLearningStrategy: 8,
    kNutritionLearning: 7,
    kExerciseFitness: 8,
    kMentalHealth: 9,
    kBodySafety: 8,
    kFamilyRelationships: 6,
    kGlobalCultures: 9,
    // Animated Videos categories
    kAnimatedABC: 8,
    kAnimatedNumbers: 10,
    kAnimatedRhymes: 5,
    kAnimatedStories: 3,
    // Early Learning categories (1 item each - visited = completed)
    kSensoryLearning: 1,
    kVisualLearning: 1,
    kAudioLearning: 1,
    kKinestheticLearning: 1,
    kPlayBasedLearning: 1,
    kExploratoryLearning: 1,
    kDiscoveryLearning: 1,
    kMontessoriLearning: 1,
    kActivityBasedLearning: 1,
    kExperientialLearning: 1,
  };

  @override
  void onInit() {
    super.onInit();
    _loadAllProgress();
  }

  void _loadAllProgress() {
    for (var key in categoryTotals.keys) {
      final saved = _storage.read<List<dynamic>>('${key}_completed');
      if (saved != null) {
        completedItems[key] = saved.length;
      } else {
        completedItems[key] = 0;
      }
      totalItems[key] = categoryTotals[key] ?? 0;
    }
  }

  // Get completed items list for a category
  List<int> getCompletedItemsList(String category) {
    final saved = _storage.read<List<dynamic>>('${category}_completed');
    if (saved != null) {
      return saved.cast<int>();
    }
    return [];
  }

  // Mark an item as completed
  Future<void> markItemCompleted(String category, int itemIndex) async {
    List<int> completed = getCompletedItemsList(category);
    if (!completed.contains(itemIndex)) {
      completed.add(itemIndex);
      await _storage.write('${category}_completed', completed);
      completedItems[category] = completed.length;

      // Track for rewards - auto unlock badges/trophies
      if (Get.isRegistered<RewardsService>()) {
        await Get.find<RewardsService>().trackItemCompleted();
      }
    }
  }

  // Mark an item as uncompleted
  Future<void> markItemUncompleted(String category, int itemIndex) async {
    List<int> completed = getCompletedItemsList(category);
    if (completed.contains(itemIndex)) {
      completed.remove(itemIndex);
      await _storage.write('${category}_completed', completed);
      completedItems[category] = completed.length;
    }
  }

  // Mark multiple items as completed
  Future<void> markItemsCompleted(String category, List<int> itemIndexes) async {
    List<int> completed = getCompletedItemsList(category);
    int newItems = 0;
    for (var index in itemIndexes) {
      if (!completed.contains(index)) {
        completed.add(index);
        newItems++;
      }
    }
    await _storage.write('${category}_completed', completed);
    completedItems[category] = completed.length;

    // Track for rewards - auto unlock badges/trophies
    if (newItems > 0 && Get.isRegistered<RewardsService>()) {
      final rewardsService = Get.find<RewardsService>();
      for (int i = 0; i < newItems; i++) {
        await rewardsService.trackItemCompleted();
      }
    }
  }

  // Check if item is completed
  bool isItemCompleted(String category, int itemIndex) {
    // Access observable to register with GetX reactivity
    completedItems[category];
    return getCompletedItemsList(category).contains(itemIndex);
  }

  // Get progress percentage for a category
  double getProgressPercentage(String category) {
    final completed = completedItems[category] ?? 0;
    final total = totalItems[category] ?? categoryTotals[category] ?? 1;
    if (total == 0) return 0;
    return (completed / total) * 100;
  }

  // Get progress fraction string (e.g., "5/26")
  String getProgressString(String category) {
    final completed = completedItems[category] ?? 0;
    final total = totalItems[category] ?? categoryTotals[category] ?? 0;
    return '$completed/$total';
  }

  // Get completed count for a category
  int getCompletedCount(String category) {
    return completedItems[category] ?? 0;
  }

  // Get total count for a category
  int getTotalCount(String category) {
    return totalItems[category] ?? 0;
  }

  // Reset progress for a category
  Future<void> resetProgress(String category) async {
    await _storage.remove('${category}_completed');
    completedItems[category] = 0;
  }

  // Reset all progress
  Future<void> resetAllProgress() async {
    for (var key in categoryTotals.keys) {
      await _storage.remove('${key}_completed');
      completedItems[key] = 0;
    }
  }

  // Get overall app progress
  double getOverallProgress() {
    int totalCompleted = 0;
    int totalAll = 0;

    for (var key in categoryTotals.keys) {
      totalCompleted += completedItems[key] ?? 0;
      totalAll += totalItems[key] ?? 0;
    }

    if (totalAll == 0) return 0;
    return (totalCompleted / totalAll) * 100;
  }
}
