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
  static const String kSkillEvaluation = 'progress_skill_evaluation';
  static const String kDesignThinking = 'progress_design_thinking';
  static const String kMiniProjects = 'progress_mini_projects';
  static const String kStemHub = 'progress_stem_hub';
  static const String kScienceExperiments = 'progress_science_experiments';
  static const String kScienceTopics = 'progress_science_topics';
  static const String kEnvironmentTopics = 'progress_environment_topics';
  static const String kSocialSkills = 'progress_social_skills';
  static const String kCulturalAwareness = 'progress_cultural_awareness';
  static const String kFestivalLearning = 'progress_festival_learning';
  static const String kFolkTales = 'progress_folk_tales';
  static const String kRegionalLanguages = 'progress_regional_languages';
  static const String kComputerBasics = 'progress_computer_basics';
  static const String kKeyboardMouse = 'progress_keyboard_mouse';
  static const String kInternetSafety = 'progress_internet_safety';
  static const String kDigitalEtiquette = 'progress_digital_etiquette';
  static const String kDiyLearning = 'progress_diy_learning';
  static const String kHygieneHabits = 'progress_hygiene_habits';
  static const String kTimeManagement = 'progress_time_management';
  static const String kSafetySkills = 'progress_safety_skills';
  static const String kMoneyHabits = 'progress_money_habits';
  static const String kPlanningSkills = 'progress_planning_skills';
  static const String kGoalSetting = 'progress_goal_setting';
  static const String kTaskSequencing = 'progress_task_sequencing';
  static const String kWorkingMemory = 'progress_working_memory';
  static const String kFunGames = 'progress_fun_games';
  static const String kFocusTraining = 'progress_focus_training';
  static const String kAttentionTraining = 'progress_attention_training';

  // Sight Words progress keys
  static const String kSightWordsPreK = 'progress_sight_words_prek';
  static const String kSightWordsKindergarten = 'progress_sight_words_kindergarten';
  static const String kSightWordsGrade1 = 'progress_sight_words_grade1';
  static const String kSightWordsGrade2 = 'progress_sight_words_grade2';
  static const String kSightWordsGrade3 = 'progress_sight_words_grade3';
  static const String kSightWordsNouns = 'progress_sight_words_nouns';

  // Spelling Practice progress keys
  static const String kSpellingEasy = 'progress_spelling_easy';
  static const String kSpellingMedium = 'progress_spelling_medium';
  static const String kSpellingHard = 'progress_spelling_hard';
  static const String kSpellingAnimals = 'progress_spelling_animals';
  static const String kSpellingFood = 'progress_spelling_food';
  static const String kSpellingNature = 'progress_spelling_nature';

  // Sentence Formation progress keys
  static const String kSentenceAnimals = 'progress_sentence_animals';
  static const String kSentenceFamily = 'progress_sentence_family';
  static const String kSentenceNature = 'progress_sentence_nature';
  static const String kSentenceSchool = 'progress_sentence_school';
  static const String kSentenceFood = 'progress_sentence_food';
  static const String kSentenceActions = 'progress_sentence_actions';

  // Reading Fluency progress keys
  static const String kReadingAnimals = 'progress_reading_animals';
  static const String kReadingFamily = 'progress_reading_family';
  static const String kReadingNature = 'progress_reading_nature';
  static const String kReadingSchool = 'progress_reading_school';
  static const String kReadingAdventure = 'progress_reading_adventure';
  static const String kReadingFriendship = 'progress_reading_friendship';

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
    kSkillEvaluation: 60,
    kDesignThinking: 8,
    kMiniProjects: 8,
    kStemHub: 4,
    kScienceExperiments: 8,
    kScienceTopics: 6,
    kEnvironmentTopics: 6,
    kSocialSkills: 4,
    kCulturalAwareness: 4,
    kFestivalLearning: 5,
    kFolkTales: 3,
    kRegionalLanguages: 3,
    kComputerBasics: 7,
    kKeyboardMouse: 8,
    kInternetSafety: 8,
    kDigitalEtiquette: 8,
    kDiyLearning: 5,
    kHygieneHabits: 8,
    kTimeManagement: 8,
    kSafetySkills: 8,
    kMoneyHabits: 8,
    kPlanningSkills: 7,
    kGoalSetting: 7,
    kTaskSequencing: 7,
    kWorkingMemory: 7,
    kFunGames: 3,
    kFocusTraining: 4,
    kAttentionTraining: 5,
    // Sight Words categories (Dolch Sight Words)
    kSightWordsPreK: 40,
    kSightWordsKindergarten: 52,
    kSightWordsGrade1: 41,
    kSightWordsGrade2: 45,
    kSightWordsGrade3: 41,
    kSightWordsNouns: 94,
    // Spelling Practice categories
    kSpellingEasy: 15,
    kSpellingMedium: 15,
    kSpellingHard: 15,
    kSpellingAnimals: 15,
    kSpellingFood: 15,
    kSpellingNature: 15,
    // Sentence Formation categories (10 sentences each)
    kSentenceAnimals: 10,
    kSentenceFamily: 10,
    kSentenceNature: 10,
    kSentenceSchool: 10,
    kSentenceFood: 10,
    kSentenceActions: 10,
    // Reading Fluency categories (5 stories each)
    kReadingAnimals: 5,
    kReadingFamily: 5,
    kReadingNature: 5,
    kReadingSchool: 5,
    kReadingAdventure: 5,
    kReadingFriendship: 5,
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
