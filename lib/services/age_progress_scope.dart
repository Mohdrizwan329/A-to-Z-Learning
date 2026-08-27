// Which progress categories belong to the child on screen.
//
// The home grid is filtered by age, but the drawer's reports were not: a
// Class 5-6 child still saw "Capital Letters" and "A to Z Words" rows in
// Progress Reports and certificates for topics their home screen no longer
// offers. This maps each home card to the progress categories it writes to,
// so those pages can show the same set of topics the child can actually open.
import 'package:get/get.dart';

import 'package:jiyan_learning/services/age_content_service.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/view%20model/home%20controller/home_controller.dart';

/// The progress categories each home card leads to. Cards with nothing to
/// track -- games, most Life Skills pages -- are simply absent.
const Map<String, List<String>> cardProgressKeys = {
  'Numbers': [ProgressService.kNumbers],
  'Capital Letters': [ProgressService.kCapitalLetters],
  'Small Letters': [ProgressService.kSmallLetters],
  'Hindi Letters': [ProgressService.kHindiLetters],
  'A to Z Words': [ProgressService.kAlphabetWords],
  'Tables': [ProgressService.kTables],
  'Learning Sets': [
    ProgressService.kAnimals,
    ProgressService.kBirds,
    ProgressService.kFruits,
    ProgressService.kVegetables,
    ProgressService.kFlowers,
    ProgressService.kColors,
    ProgressService.kBodyParts,
    ProgressService.kMonths,
    ProgressService.kWeekDays,
    ProgressService.kShapes,
    ProgressService.kVehicles,
    ProgressService.kSeasons,
  ],
  'General Knowledge': [ProgressService.kGK],
  'Stories': [ProgressService.kStories],
  'Rhymes & Songs': [ProgressService.kRhymes, ProgressService.kPoems],
  'Kids Drawing': [ProgressService.kColoring],
  'Math Problem Solve Practice': [
    ProgressService.kMathAddition,
    ProgressService.kMathSubtraction,
    ProgressService.kMathMultiplication,
    ProgressService.kMathDivision,
  ],
  'Math Practice': [
    ProgressService.kMathAddition,
    ProgressService.kMathSubtraction,
    ProgressService.kMathMultiplication,
    ProgressService.kMathDivision,
  ],
  'Science Basics': [ProgressService.kScienceTopics],
  'Environment': [ProgressService.kEnvironmentTopics],
  'Social Skills': [ProgressService.kSocialSkills],
  'STEM Hub': [
    ProgressService.kStemHub,
    ProgressService.kScienceExperiments,
  ],
  'Design Thinking': [ProgressService.kDesignThinking],
  'DIY Learning': [
    ProgressService.kDiyLearning,
    ProgressService.kMiniProjects,
  ],
  'Skill Evaluation': [ProgressService.kSkillEvaluation],
  'World Map': [ProgressService.kWorldMap, ProgressService.kCountriesFlags],
  'Famous Places': [ProgressService.kFamousPlaces],
  'Engineering for Kids': [ProgressService.kEngineeringKids],
  'STEM Challenges': [ProgressService.kStemChallenges],
  'STEAM Page': [ProgressService.kSteamLearning],
  'Climate Awareness': [ProgressService.kClimateAwareness],
  'Recycling': [ProgressService.kRecyclingKids],
  'Sustainable Habits': [ProgressService.kSustainableHabits],
  'Citizenship': [ProgressService.kCitizenshipBasics],
  'Rights & Duties': [ProgressService.kRights, ProgressService.kDuties],
  'Think About Thinking': [ProgressService.kThinkAboutThinking],
  'Self Reflection': [ProgressService.kSelfReflection],
  'Learning Strategy': [ProgressService.kLearningStrategy],
  'Nutrition': [ProgressService.kNutritionLearning],
  'Exercise': [ProgressService.kExerciseFitness],
  'Mental Health': [ProgressService.kMentalHealth],
  'Body Safety': [ProgressService.kBodySafety],
  'Family & Relationships': [ProgressService.kFamilyRelationships],
  'Global Cultures': [ProgressService.kGlobalCultures],
  'Sensory Learning': [ProgressService.kSensoryLearning],
  'Visual Learning': [ProgressService.kVisualLearning],
  'Audio Learning': [ProgressService.kAudioLearning],
  'Play Based Learning': [ProgressService.kPlayBasedLearning],
  'Montessori Learning': [ProgressService.kMontessoriLearning],
  'Activity Based': [ProgressService.kActivityBasedLearning],
  'Exploratory Learning': [ProgressService.kExploratoryLearning],
  'Discovery Learning': [ProgressService.kDiscoveryLearning],
  'Experiential Learning': [ProgressService.kExperientialLearning],
  'Kinesthetic Learning': [ProgressService.kKinestheticLearning],
  'Focus Improvement': [ProgressService.kFocusTraining],
  'Computer Awareness': [ProgressService.kComputerBasics],
  'Keyboard & Mouse': [ProgressService.kKeyboardMouse],
  'Internet Safety': [ProgressService.kInternetSafety],
  'Digital Etiquette': [ProgressService.kDigitalEtiquette],
  'Hygiene Habits': [ProgressService.kHygieneHabits],
  'Time Management': [ProgressService.kTimeManagement],
  'Safety Skills': [ProgressService.kSafetySkills],
  'Money Habits': [ProgressService.kMoneyHabits],
  'Planning Skills': [ProgressService.kPlanningSkills],
  'Goal Setting': [ProgressService.kGoalSetting],
  'Task Sequencing': [ProgressService.kTaskSequencing],
  'Working Memory': [ProgressService.kWorkingMemory],
};

/// Keys the certificates page invented for itself, which never made it into
/// [ProgressService]. They cannot be earned as things stand, but they can at
/// least be pointed at the card they belong to, so an age group is not offered
/// a certificate for a topic it no longer has.
const Map<String, List<String>> cardLooseKeys = {
  'Kids Drawing': ['progress_drawing'],
  'Drawing Image': ['progress_drawing_image'],
  'Sight Words': ['progress_sight_words'],
  'Spelling Practice': ['progress_spelling'],
  'Reading Fluency': ['progress_reading_fluency'],
  'Sentence Formation': ['progress_sentence_formation'],
  'Listening Skills': ['progress_listening'],
  'Cursive Writing': ['progress_cursive'],
  'Quiz Time': ['progress_quiz'],
  'Quiz Battle': ['progress_quiz_battle'],
  'Drag & Drop': ['progress_drag_drop'],
  'Matching Game': ['progress_matching_game'],
  'Tracing Game': ['progress_tracing'],
  'Puzzle Game': ['progress_puzzle'],
  'Memory Match': ['progress_memory'],
  'Science Basics': ['progress_science'],
  'Environment': ['progress_environment'],
  'World Map': ['progress_world_map', 'progress_maps', 'progress_flags'],
  'Famous Places': ['progress_famous_places'],
  'Global Cultures': ['progress_cultures'],
  'STEM Hub': ['progress_stem', 'progress_experiments'],
  'STEM Challenges': ['progress_stem_challenges'],
  'DIY Learning': ['progress_diy', 'progress_mini_projects'],
  'Design Thinking': ['progress_design_thinking'],
  'Engineering for Kids': ['progress_engineering'],
  'Good Habits': ['progress_good_habits'],
  'Hygiene Habits': ['progress_hygiene'],
  'Time Management': ['progress_time_management'],
  'Safety Skills': ['progress_safety'],
  'Money Habits': ['progress_money_habits'],
  'Planning Skills': ['progress_planning'],
  'Goal Setting': ['progress_goal_setting'],
  'Task Sequencing': ['progress_task_sequencing'],
  'Working Memory': ['progress_working_memory'],
  'Nutrition': ['progress_nutrition'],
  'Exercise': ['progress_fitness'],
  'Mental Health': ['progress_mental_health'],
  'Body Safety': ['progress_body_safety'],
  'Mindfulness': ['progress_mindfulness'],
  'Calm Down': ['progress_calm_down', 'progress_emotions'],
  'Empathy Learning': ['progress_empathy'],
  'Confidence': ['progress_confidence'],
  'Know Yourself': ['progress_self_awareness'],
  'Focus Improvement': ['progress_focus'],
  'Think About Thinking': ['progress_metacognition'],
  'Self Reflection': ['progress_self_reflection'],
  'Learning Strategy': ['progress_learning_strategy'],
  'Computer Awareness': ['progress_computer'],
  'Keyboard & Mouse': ['progress_keyboard'],
  'Internet Safety': ['progress_internet_safety'],
  'Digital Etiquette': ['progress_digital_etiquette'],
  'Climate Awareness': ['progress_climate'],
  'Recycling': ['progress_recycling'],
  'Sustainable Habits': ['progress_sustainable'],
  'Citizenship': ['progress_citizenship'],
  'Rights & Duties': ['progress_rights_duties'],
  'Family & Relationships': ['progress_family'],
};

/// The progress categories reachable from this child's home screen.
///
/// Empty when the card list cannot be read -- a page built without the home
/// controller, or a test. Callers treat empty as "no scope known" and show
/// everything, so a report is never blank just because the scope was missing.
Set<String> visibleProgressKeys() {
  final HomeController home;
  try {
    home = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
  } catch (_) {
    return const {};
  }

  final keys = <String>{};
  for (final item in home.displayItems) {
    keys.addAll(cardProgressKeys[item.title] ?? const []);
    keys.addAll(cardLooseKeys[item.title] ?? const []);
  }
  return keys;
}

/// Every progress category some home card writes to. A key outside this set
/// -- the maths scanner, free drawing -- belongs to no card at all, so age has
/// nothing to say about it and it is always in scope.
final Set<String> _mappedKeys = {
  for (final keys in cardProgressKeys.values) ...keys,
  for (final keys in cardLooseKeys.values) ...keys,
};

/// The card titles on this child's home screen. Empty when the card list
/// cannot be read, and callers then treat every card as present.
Set<String> visibleCardTitles() {
  final HomeController home;
  try {
    home = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
  } catch (_) {
    return const {};
  }
  return home.displayItems.map((i) => i.title).toSet();
}

/// Whether this child can open a card at all -- used where there is no
/// progress key to go on, such as a daily goal about playing a game.
bool homeHasAnyCard(List<String> titles) {
  final shown = visibleCardTitles();
  if (shown.isEmpty) return true;
  return titles.any(shown.contains);
}

/// Whether a report row belongs on screen for this child. True when the key
/// belongs to no card, and true when no scope could be worked out, so nothing
/// disappears by accident.
bool progressKeyInScope(String key) {
  if (!_mappedKeys.contains(key)) return true;
  final scope = visibleProgressKeys();
  return scope.isEmpty || scope.contains(key);
}

/// Rebuilds [rebuild] whenever the age group changes, so a report on screen
/// follows the home grid instead of waiting to be reopened. Returns the worker
/// to dispose with the page, or null when there is no service to listen to.
Worker? watchAgeGroup(void Function() rebuild) {
  if (!Get.isRegistered<AgeContentService>()) return null;
  return ever(Get.find<AgeContentService>().currentAgeGroup, (_) => rebuild());
}
