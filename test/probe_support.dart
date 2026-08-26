// Shared helpers for the layout probes.
//
// `overflow_probe.dart` builds every page that can be constructed directly;
// `navigation_probe.dart` reaches the ones that can only be opened by tapping
// through a parent. Both need the same services, the same device list and the
// same overflow measurement, so it lives here rather than in either file.

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/accessibility_service.dart';
import 'package:jiyan_learning/services/adaptive_learning_service.dart';
import 'package:jiyan_learning/services/age_content_service.dart';
import 'package:jiyan_learning/services/app_settings_service.dart';
import 'package:jiyan_learning/services/avatar_coins_service.dart';
import 'package:jiyan_learning/services/cloud_sync_service.dart';
import 'package:jiyan_learning/services/daily_goals_service.dart';
import 'package:jiyan_learning/services/festival_content_service.dart';
import 'package:jiyan_learning/services/leaderboard_service.dart';
import 'package:jiyan_learning/services/learning_outcomes_service.dart';
import 'package:jiyan_learning/services/multi_profile_service.dart';
import 'package:jiyan_learning/services/notification_service.dart';
import 'package:jiyan_learning/services/premium_service.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/services/resume_lesson_service.dart';
import 'package:jiyan_learning/services/rewards_service.dart';
import 'package:jiyan_learning/services/screen_time_service.dart';
import 'package:jiyan_learning/services/smart_learning_service.dart';
import 'package:jiyan_learning/services/speech_recognition_service.dart';
import 'package:jiyan_learning/services/syllabus_service.dart';
import 'package:jiyan_learning/services/tts_service.dart';
import 'package:jiyan_learning/view%20model/reading_fluency_controller/reading_fluency_controller.dart';
import 'package:jiyan_learning/view%20model/sentence_formation_controller/sentence_formation_controller.dart';
import 'package:jiyan_learning/view%20model/sight_words_controller/sight_words_controller.dart';
import 'package:jiyan_learning/view%20model/spelling_practice_controller/spelling_practice_controller.dart';
import 'package:jiyan_learning/utils/responsive.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/view/age_selection/age_selection_page.dart';
import 'package:jiyan_learning/view/assessment/adaptive_quiz_page.dart';
import 'package:jiyan_learning/view/assessment/skill_evaluation_page.dart';
import 'package:jiyan_learning/view/auth/forgot_password_page.dart';
import 'package:jiyan_learning/view/auth/login_page.dart';
import 'package:jiyan_learning/view/auth/signup_page.dart';
import 'package:jiyan_learning/view/cognitive/focus_improvement_page.dart';
import 'package:jiyan_learning/view/creativity/story_creation_page.dart';
import 'package:jiyan_learning/view/digital_literacy/computer_awareness_page.dart';
import 'package:jiyan_learning/view/digital_literacy/digital_etiquette_page.dart';
import 'package:jiyan_learning/view/digital_literacy/internet_safety_page.dart';
import 'package:jiyan_learning/view/digital_literacy/keyboard_mouse_page.dart';
import 'package:jiyan_learning/view/drawing/Drawing_Page.dart';
import 'package:jiyan_learning/view/early_learning/activity_based_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/audio_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/discovery_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/early_learning_hub_page.dart';
import 'package:jiyan_learning/view/early_learning/experiential_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/exploratory_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/kinesthetic_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/montessori_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/play_based_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/sensory_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/visual_learning_page.dart';
import 'package:jiyan_learning/view/executive_function/goal_setting_page.dart';
import 'package:jiyan_learning/view/executive_function/planning_skills_page.dart';
import 'package:jiyan_learning/view/executive_function/task_sequencing_page.dart';
import 'package:jiyan_learning/view/executive_function/working_memory_page.dart';
import 'package:jiyan_learning/view/games/drag_drop_game_page.dart';
import 'package:jiyan_learning/view/games/games_hub_page.dart';
import 'package:jiyan_learning/view/games/matching_game_page.dart';
import 'package:jiyan_learning/view/games/puzzle_game_page.dart';
import 'package:jiyan_learning/view/games/tracing_game_page.dart';
import 'package:jiyan_learning/view/global_awareness/famous_places_page.dart';
import 'package:jiyan_learning/view/global_awareness/global_cultures_page.dart';
import 'package:jiyan_learning/view/global_awareness/world_map_page.dart';
import 'package:jiyan_learning/view/health/body_safety_page.dart';
import 'package:jiyan_learning/view/health/exercise_fitness_page.dart';
import 'package:jiyan_learning/view/health/mental_health_basics_page.dart';
import 'package:jiyan_learning/view/health/nutrition_learning_page.dart';
import 'package:jiyan_learning/view/hindi%20world%20meaning/hindi_letters_page.dart';
import 'package:jiyan_learning/view/home/Home_Page.dart';
import 'package:jiyan_learning/view/home/widgets/app_drawer.dart';
import 'package:jiyan_learning/view/knowledge/environmental_studies_page.dart';
import 'package:jiyan_learning/view/knowledge/science_basics_page.dart';
import 'package:jiyan_learning/view/knowledge/social_awareness_page.dart';
import 'package:jiyan_learning/view/learn%20set/gk_learning_page.dart';
import 'package:jiyan_learning/view/learn%20set/learning_set_grid_page.dart';
import 'package:jiyan_learning/view/learn%20set/rhymes_page.dart';
import 'package:jiyan_learning/view/learn%20set/seasons_learning_page.dart';
import 'package:jiyan_learning/view/learn%20set/shapes_learning_page.dart';
import 'package:jiyan_learning/view/learn%20set/stories_page.dart';
import 'package:jiyan_learning/view/learn%20set/vehicles_learning_page.dart';
import 'package:jiyan_learning/view/life_skills/hygiene_habits_page.dart';
import 'package:jiyan_learning/view/life_skills/money_habits_page.dart';
import 'package:jiyan_learning/view/life_skills/safety_skills_page.dart';
import 'package:jiyan_learning/view/life_skills/time_management_page.dart';
import 'package:jiyan_learning/view/literacy/listening_skills_page.dart';
import 'package:jiyan_learning/view/literacy/reading_fluency_page.dart';
import 'package:jiyan_learning/view/literacy/sentence_formation_page.dart';
import 'package:jiyan_learning/view/literacy/sight_words_page.dart';
import 'package:jiyan_learning/view/literacy/spelling_practice_page.dart';
import 'package:jiyan_learning/view/main_navigation_screen.dart';
import 'package:jiyan_learning/view/math%20problem%20&%20solution/Problems_Pages.dart';
import 'package:jiyan_learning/view/math%20qustion/math_qust_grid_page.dart';
import 'package:jiyan_learning/view/math%20scanner/math_scanner_page.dart';
import 'package:jiyan_learning/view/math/money_concepts_page.dart';
import 'package:jiyan_learning/view/metacognition/learning_strategy_page.dart';
import 'package:jiyan_learning/view/metacognition/self_reflection_page.dart';
import 'package:jiyan_learning/view/metacognition/think_about_thinking_page.dart';
import 'package:jiyan_learning/view/numbers/Number_Page.dart';
import 'package:jiyan_learning/view/ocr/ocr_page.dart';
import 'package:jiyan_learning/view/premium/advanced_math_games_page.dart';
import 'package:jiyan_learning/view/premium/avatar_shop_page.dart';
import 'package:jiyan_learning/view/premium/certificates_page.dart';
import 'package:jiyan_learning/view/premium/custom_themes_page.dart';
import 'package:jiyan_learning/view/premium/flashcards_page.dart';
import 'package:jiyan_learning/view/premium/fun_games_page.dart';
import 'package:jiyan_learning/view/premium/handwriting_practice_page.dart';
import 'package:jiyan_learning/view/premium/leaderboard_page.dart';
import 'package:jiyan_learning/view/premium/offline_learning_page.dart';
import 'package:jiyan_learning/view/premium/parent_dashboard_page.dart';
import 'package:jiyan_learning/view/premium/pdf_downloads_page.dart';
import 'package:jiyan_learning/view/premium/premium_features_screen.dart';
import 'package:jiyan_learning/view/premium/premium_plans_page.dart';
import 'package:jiyan_learning/view/premium/progress_reports_page.dart';
import 'package:jiyan_learning/view/premium/quiz_battle_page.dart';
import 'package:jiyan_learning/view/premium/story_time_page.dart';
import 'package:jiyan_learning/view/premium/voice_learning_page.dart';
import 'package:jiyan_learning/view/premium/worksheets_page.dart';
import 'package:jiyan_learning/view/profiles/accessibility/accessibility_settings_page.dart';
import 'package:jiyan_learning/view/profiles/account/account_settings_page.dart';
import 'package:jiyan_learning/view/profiles/account/change_password_page.dart';
import 'package:jiyan_learning/view/profiles/account/edit_profile_page.dart';
import 'package:jiyan_learning/view/profiles/child_profiles/child_profiles_page.dart';
import 'package:jiyan_learning/view/profiles/help/help_page.dart';
import 'package:jiyan_learning/view/profiles/notification/notification_list_page.dart';
import 'package:jiyan_learning/view/profiles/notification/notification_settings_page.dart';
import 'package:jiyan_learning/view/profiles/policy/privacy_policy_page.dart';
import 'package:jiyan_learning/view/profiles/support/support_page.dart';
import 'package:jiyan_learning/view/profiles/sync/cloud_sync_page.dart';
import 'package:jiyan_learning/view/profiles/terms%20&%20condition/terms_conditions_page.dart';
import 'package:jiyan_learning/view/projects/diy_learning_page.dart';
import 'package:jiyan_learning/view/quiz/quiz_hub_page.dart';
import 'package:jiyan_learning/view/quiz/quiz_page.dart';
import 'package:jiyan_learning/view/rewards/daily_goals_page.dart';
import 'package:jiyan_learning/view/rewards/rewards_page.dart';
import 'package:jiyan_learning/view/rewards/surprise_rewards_page.dart';
import 'package:jiyan_learning/view/sel/confidence_building_page.dart';
import 'package:jiyan_learning/view/sel/emotional_regulation_page.dart';
import 'package:jiyan_learning/view/sel/empathy_learning_page.dart';
import 'package:jiyan_learning/view/sel/good_habits_page.dart';
import 'package:jiyan_learning/view/sel/mindfulness_page.dart';
import 'package:jiyan_learning/view/sel/self_awareness_page.dart';
import 'package:jiyan_learning/view/settings/app_settings_page.dart';
import 'package:jiyan_learning/view/settings/parental_control_page.dart';
import 'package:jiyan_learning/view/social_studies/citizenship_basics_page.dart';
import 'package:jiyan_learning/view/social_studies/family_relationships_page.dart';
import 'package:jiyan_learning/view/social_studies/rights_duties_page.dart';
import 'package:jiyan_learning/view/splash/splash_screen.dart';
import 'package:jiyan_learning/view/stem/design_thinking_page.dart';
import 'package:jiyan_learning/view/stem/engineering_kids_page.dart';
import 'package:jiyan_learning/view/stem/simple_experiments_page.dart';
import 'package:jiyan_learning/view/stem/steam_page.dart';
import 'package:jiyan_learning/view/stem/stem_challenges_page.dart';
import 'package:jiyan_learning/view/stem/stem_hub_page.dart';
import 'package:jiyan_learning/view/sustainability/climate_awareness_page.dart';
import 'package:jiyan_learning/view/sustainability/recycling_kids_page.dart';
import 'package:jiyan_learning/view/sustainability/sustainable_habits_page.dart';
import 'package:jiyan_learning/view/tables/Table_Page.dart';
import 'package:jiyan_learning/view/teacher/reports_page.dart';
import 'package:jiyan_learning/view/world%20meaning%20Alphabet%20/Alphabet_meaning.dart';
import 'package:jiyan_learning/view/writing/cursive_writing_page.dart';
import 'package:jiyan_learning/view/special_needs/adhd_support_page.dart';
import 'package:jiyan_learning/view/settings/ads_control_page.dart';
import 'package:jiyan_learning/view/digital_literacy/ai_awareness_page.dart';
import 'package:jiyan_learning/view/content/animated_videos_page.dart';
import 'package:jiyan_learning/view/cognitive/attention_training_page.dart';
import 'package:jiyan_learning/view/special_needs/autism_friendly_page.dart';
import 'package:jiyan_learning/view/executive_function/cognitive_flexibility_page.dart';
import 'package:jiyan_learning/view/social_studies/community_helpers_page.dart';
import 'package:jiyan_learning/view/speech/conversation_practice_page.dart';
import 'package:jiyan_learning/view/creativity/craft_ideas_page.dart';
import 'package:jiyan_learning/view/culture/cultural_awareness_page.dart';
import 'package:jiyan_learning/view/life_skills/daily_life_skills_page.dart';
import 'package:jiyan_learning/view/creativity/dance_activities_page.dart';
import 'package:jiyan_learning/view/settings/device_optimization_page.dart';
import 'package:jiyan_learning/view/drawing/Drawing_Image_Page.dart';
import 'package:jiyan_learning/view/sel/emotional_intelligence_page.dart';
import 'package:jiyan_learning/view/writing/fine_motor_skills_page.dart';
import 'package:jiyan_learning/view/culture/folk_tales_page.dart';
import 'package:jiyan_learning/view/projects/home_experiments_page.dart';
import 'package:jiyan_learning/view/creativity/imagination_page.dart';
import 'package:jiyan_learning/view/content/infographics_page.dart';
import 'package:jiyan_learning/view/learning/learning_outcomes_page.dart';
import 'package:jiyan_learning/view/learning/learning_path_page.dart';
import 'package:jiyan_learning/view/games/logic_game_page.dart';
import 'package:jiyan_learning/view/projects/maker_space_page.dart';
import 'package:jiyan_learning/view/social_studies/maps_directions_page.dart';
import 'package:jiyan_learning/view/projects/mini_projects_page.dart';
import 'package:jiyan_learning/view/creativity/music_learning_page.dart';
import 'package:jiyan_learning/view/literacy/phonics_page.dart';
import 'package:jiyan_learning/view/speech/pronunciation_practice_page.dart';
import 'package:jiyan_learning/view/culture/regional_languages_page.dart';
import 'package:jiyan_learning/view/creativity/rhythm_learning_page.dart';
import 'package:jiyan_learning/view/sustainability/save_environment_page.dart';
import 'package:jiyan_learning/view/digital_literacy/screen_responsibility_page.dart';
import 'package:jiyan_learning/view/executive_function/self_control_page.dart';
import 'package:jiyan_learning/view/writing/stroke_order_page.dart';
import 'package:jiyan_learning/view/teacher/teacher_mode_page.dart';
import 'package:jiyan_learning/view/literacy/word_building_page.dart';
import 'package:jiyan_learning/view/writing/writing_accuracy_page.dart';
import 'package:jiyan_learning/view/health/body_safety_detail_page.dart';
import 'package:jiyan_learning/view/social_studies/citizenship_basics_detail_page.dart';
import 'package:jiyan_learning/view/sustainability/climate_awareness_detail_page.dart';
import 'package:jiyan_learning/view/global_awareness/countries_flags_detail_page.dart';
import 'package:jiyan_learning/view/global_awareness/countries_flags_page.dart';
import 'package:jiyan_learning/view/auth/create_new_password_page.dart';
import 'package:jiyan_learning/view/stem/engineering_kids_detail_page.dart';
import 'package:jiyan_learning/view/health/exercise_fitness_detail_page.dart';
import 'package:jiyan_learning/view/social_studies/family_relationships_detail_page.dart';
import 'package:jiyan_learning/view/global_awareness/famous_places_detail_page.dart';
import 'package:jiyan_learning/view/culture/festival_learning_page.dart';
import 'package:jiyan_learning/view/Alphabets/generic_alphabet_page.dart';
import 'package:jiyan_learning/view/learn%20set/generic_learning_page.dart';
import 'package:jiyan_learning/view/math%20qustion/generic_math_questions_page.dart';
import 'package:jiyan_learning/view/global_awareness/global_cultures_detail_page.dart';
import 'package:jiyan_learning/view/metacognition/learning_strategy_detail_page.dart';
import 'package:jiyan_learning/view/health/mental_health_detail_page.dart';
import 'package:jiyan_learning/view/health/nutrition_learning_detail_page.dart';
import 'package:jiyan_learning/view/auth/otp_verification_page.dart';
import 'package:jiyan_learning/view/poem/poem_page.dart';
import 'package:jiyan_learning/view/profiles/profile/profile_page.dart';
import 'package:jiyan_learning/view/literacy/reading_fluency_detail_page.dart';
import 'package:jiyan_learning/view/sustainability/recycling_kids_detail_page.dart';
import 'package:jiyan_learning/view/metacognition/self_reflection_detail_page.dart';
import 'package:jiyan_learning/view/literacy/sentence_formation_detail_page.dart';
import 'package:jiyan_learning/view/literacy/sight_words_detail_page.dart';
import 'package:jiyan_learning/view/literacy/spelling_practice_detail_page.dart';
import 'package:jiyan_learning/view/stem/steam_detail_page.dart';
import 'package:jiyan_learning/view/stem/stem_challenges_detail_page.dart';
import 'package:jiyan_learning/view/sustainability/sustainable_habits_detail_page.dart';
import 'package:jiyan_learning/view/tables/Table_Count_Page.dart';
import 'package:jiyan_learning/view/metacognition/think_about_thinking_detail_page.dart';
import 'package:jiyan_learning/view/global_awareness/world_map_detail_page.dart';
import 'package:jiyan_learning/view%20model/alphabet%20controller/generic_alphabet_controller.dart'
    as alpha;
import 'package:jiyan_learning/view%20model/qustion%20controller/generic_math_questions_controller.dart';
import 'package:jiyan_learning/widgets/base_grid_page.dart';

/// The screen sizes every page is probed against: the smallest phone still in
/// use, the two common Android sizes, the design canvas, a large phone, a
/// phone in landscape, and both tablet orientations.
class ProbeDevice {
  const ProbeDevice(
    this.label,
    this.size, {
    this.textScale = 1.0,
    this.padding = EdgeInsets.zero,
    this.keyboardInset = 0,
  });

  final String label;
  final Size size;

  /// The system font-size setting, before the shell clamps it.
  final double textScale;

  /// Status bar, notch and home-indicator insets.
  final EdgeInsets padding;

  /// Height the on-screen keyboard takes from the bottom of the window.
  final double keyboardInset;
}

/// Screen size is only one axis of "fits on this device". A page can be clean
/// at every size and still break when the reader turns their font size up, on a
/// notched phone, or with the keyboard open over a form, so those are probed as
/// their own device rows rather than assumed.
const List<ProbeDevice> probeDevices = [
  ProbeDevice('320x568 small phone', Size(320, 568)),
  ProbeDevice('360x640 android', Size(360, 640)),
  ProbeDevice('375x812 canvas', Size(375, 812)),
  ProbeDevice('414x896 large phone', Size(414, 896)),
  ProbeDevice('740x360 phone landscape', Size(740, 360)),
  ProbeDevice('768x1024 tablet', Size(768, 1024)),
  ProbeDevice('1024x768 tablet landscape', Size(1024, 768)),

  // Largest system font the shell allows, on the narrowest phone.
  ProbeDevice('320x568 largest font', Size(320, 568), textScale: 2.0),
  ProbeDevice('393x852 largest font', Size(393, 852), textScale: 2.0),

  // A notched phone: the safe area eats 47pt at the top and 34pt at the bottom.
  ProbeDevice(
    '393x852 notched',
    Size(393, 852),
    padding: EdgeInsets.only(top: 47, bottom: 34),
  ),

  // Keyboard open over a form, which is where the body is shortest.
  ProbeDevice(
    '360x640 keyboard',
    Size(360, 640),
    padding: EdgeInsets.only(top: 24),
    keyboardInset: 300,
  ),
];

/// Walks a settled render tree and measures overflow directly, instead of
/// trusting `FlutterError`: overflow is reported once per render object, and
/// relayout boundaries mean a second layout pass will not report it again, so
/// the error stream is unreliable for a whole-app sweep.
///
/// For each flex, the children's extents along the main axis are summed and
/// compared with the space the flex actually got.
List<String> scanOverflow(RenderObject root) {
  final issues = <String>[];
  void visit(RenderObject o) {
    if (o is RenderFlex && o.hasSize) {
      var child = o.firstChild;
      var used = 0.0;
      var count = 0;
      while (child != null) {
        if (child.hasSize) {
          used += o.direction == Axis.horizontal
              ? child.size.width
              : child.size.height;
        }
        count++;
        child = o.childAfter(child);
      }
      if (count > 1) used += o.spacing * (count - 1);
      final available =
          o.direction == Axis.horizontal ? o.size.width : o.size.height;
      final over = used - available;
      if (over > 0.5) {
        var detail = '';
        if (const bool.fromEnvironment('DUMP')) {
          final parts = <String>[];
          var c2 = o.firstChild;
          while (c2 != null) {
            final text = firstText(c2);
            parts.add('${c2.runtimeType}'
                '${c2.hasSize ? c2.size.toString() : "(nosize)"}'
                '${text == null ? "" : " \"$text\""}');
            c2 = o.childAfter(c2);
          }
          detail = ' cons=${o.constraints} size=${o.size} kids=[${parts.join(", ")}]';
        }
        issues.add('${o.direction == Axis.horizontal ? "Row" : "Column"} '
            'overflows ${over.toStringAsFixed(1)}px at ${creatorOf(o)}$detail');
      }
    }
    o.visitChildren(visit);
  }
  visit(root);
  return issues;
}

/// Best-effort source location for a render object, read off the debug
/// creator that Flutter attaches in debug builds.
String creatorOf(RenderObject o) {
  final c = o.debugCreator;
  if (c is! DebugCreator) return 'unknown';
  // The creation location lives on the widget's debug creation record, which
  // is what Flutter itself renders into an error message. Reuse that rather
  // than re-deriving it.
  final props = DiagnosticsDebugCreator(c)
      .getProperties()
      .map((p) => p.toString())
      .join(' ');
  final m = RegExp(r'([\w %&.-]+\.dart):(\d+):(\d+)').firstMatch(props);
  if (m != null) return '${m.group(1)}:${m.group(2)}';
  return c.element.debugGetCreatorChain(6);
}

/// True when Flutter swapped an `ErrorWidget` into the tree, i.e. something
/// threw during build. Its render box is 100000px tall, which would otherwise
/// masquerade as an enormous overflow.
bool hasErrorBox(RenderObject root) {
  var found = false;
  void visit(RenderObject o) {
    if (o is RenderErrorBox) found = true;
    if (!found) o.visitChildren(visit);
  }
  visit(root);
  return found;
}

/// Registers every service a page might reach for.
///
/// Lazily and with `fenix`, for two reasons: several services resolve another
/// service in `onInit` (ProgressService reaches for RewardsService), so eager
/// registration drops whichever is built before its dependency, while lazy
/// registration resolves them on demand in whatever order the page needs; and
/// `fenix` rebuilds a service after a torn-down `GetMaterialApp` has cleared
/// the registry. The Firebase-backed services still throw when constructed,
/// and their pages are reported as not renderable.
void registerProbeServices() {
  Get.lazyPut<ReadingFluencyController>(() => ReadingFluencyController(), fenix: true);
  Get.lazyPut<SentenceFormationController>(() => SentenceFormationController(), fenix: true);
  Get.lazyPut<SightWordsController>(() => SightWordsController(), fenix: true);
  Get.lazyPut<SpellingPracticeController>(() => SpellingPracticeController(), fenix: true);
  Get.lazyPut<ProgressService>(() => ProgressService(), fenix: true);
  Get.lazyPut<AppSettingsService>(() => AppSettingsService(), fenix: true);
  Get.lazyPut<RewardsService>(() => RewardsService(), fenix: true);
  Get.lazyPut<DailyGoalsService>(() => DailyGoalsService(), fenix: true);
  Get.lazyPut<ScreenTimeService>(() => ScreenTimeService(), fenix: true);
  Get.lazyPut<AgeContentService>(() => AgeContentService(), fenix: true);
  Get.lazyPut<TtsService>(() => TtsService(), fenix: true);
  Get.lazyPut<SpeechRecognitionService>(() => SpeechRecognitionService(), fenix: true);
  Get.lazyPut<MultiProfileService>(() => MultiProfileService(), fenix: true);
  Get.lazyPut<LeaderboardService>(() => LeaderboardService(), fenix: true);
  Get.lazyPut<CloudSyncService>(() => CloudSyncService(), fenix: true);
  Get.lazyPut<AvatarCoinsService>(() => AvatarCoinsService(), fenix: true);
  Get.lazyPut<AccessibilityService>(() => AccessibilityService(), fenix: true);
  Get.lazyPut<SmartLearningService>(() => SmartLearningService(), fenix: true);
  Get.lazyPut<NotificationService>(() => NotificationService(), fenix: true);
  Get.lazyPut<FestivalContentService>(() => FestivalContentService(), fenix: true);
  Get.lazyPut<SyllabusService>(() => SyllabusService(), fenix: true);
  Get.lazyPut<PremiumService>(() => PremiumService(), fenix: true);
  Get.lazyPut<AdaptiveLearningService>(() => AdaptiveLearningService(), fenix: true);
  Get.lazyPut<ResumeLessonService>(() => ResumeLessonService(), fenix: true);
  Get.lazyPut<LearningOutcomesService>(() => LearningOutcomesService(), fenix: true);

  // Then force the ones that can be built now, so a page that reads a
  // service outside a reactive scope still finds a live instance.
  for (var pass = 0; pass < 2; pass++) {
    tryFind<ProgressService>();
    tryFind<AppSettingsService>();
    tryFind<RewardsService>();
    tryFind<DailyGoalsService>();
    tryFind<ScreenTimeService>();
    tryFind<AgeContentService>();
    tryFind<TtsService>();
    tryFind<SpeechRecognitionService>();
    tryFind<MultiProfileService>();
    tryFind<LeaderboardService>();
    tryFind<CloudSyncService>();
    tryFind<AvatarCoinsService>();
    tryFind<AccessibilityService>();
    tryFind<SmartLearningService>();
    tryFind<NotificationService>();
    tryFind<FestivalContentService>();
    tryFind<SyllabusService>();
    tryFind<PremiumService>();
    tryFind<AdaptiveLearningService>();
    tryFind<ResumeLessonService>();
    tryFind<LearningOutcomesService>();
  }
}

/// Some services touch Firebase in their constructor, which is unavailable
/// here. Registering each independently keeps one failure from taking the
/// whole probe down.
/// Resolves a lazily-registered service, ignoring the ones whose constructor
/// needs a platform Firebase app.
void tryFind<T>() {
  try {
    Get.find<T>();
  } catch (_) {
    // Its pages will be reported as not renderable.
  }
}

/// Everything the probes need before any page is pumped: a temp path_provider,
/// GetStorage, and a stub Firebase app for the pages that reach it while they
/// build.
Future<void> initProbeBinding() async {
  final dir = await Directory.systemTemp.createTemp('jiyan_probe');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (call) async => dir.path,
  );
  await GetStorage.init();
  setupFirebaseCoreMocks();
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Firebase-backed pages stay in the not-renderable list.
  }
  Get.testMode = true;
}

/// First piece of text under a render object, used to make an overflow report
/// greppable: a size alone does not say which widget in the file it is.
String? firstText(RenderObject o) {
  String? found;
  void visit(RenderObject r) {
    if (found != null) return;
    if (r is RenderParagraph) {
      final t = r.text.toPlainText().trim().replaceAll('\n', ' ');
      if (t.isNotEmpty) found = t.length > 40 ? '${t.substring(0, 40)}…' : t;
      return;
    }
    r.visitChildren(visit);
  }
  visit(o);
  return found;
}

/// Applies a device row to the test view and wraps the app so the shell sees
/// the same font setting the reader chose.
void applyDevice(WidgetTester tester, ProbeDevice device) {
  tester.view.physicalSize = device.size;
  tester.view.devicePixelRatio = 1.0;
  tester.view.padding = FakeViewPadding(
    top: device.padding.top,
    bottom: device.padding.bottom,
    left: device.padding.left,
    right: device.padding.right,
  );
  tester.view.viewInsets = FakeViewPadding(bottom: device.keyboardInset);
  tester.view.viewPadding = FakeViewPadding(
    top: device.padding.top,
    bottom: device.padding.bottom,
  );
}

/// The app under test, with the device row's font setting applied above the
/// shell so the shell clamps it exactly as it would on a real device.
Widget probeApp(ProbeDevice device, Widget home) {
  return GetMaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(device.textScale)),
      child: ResponsiveShell(child: child ?? const SizedBox()),
    ),
    home: home,
  );
}

/// Every page the probes can build directly, keyed by the name they are
/// reported under.
final Map<String, Widget Function()> probePages = {
  // The shared grid shell. It has no callers in the app today, so the tile here
  // is a stand-in; at the default four columns a 320pt phone gives each tile
  // about 65pt, which is why the caption is scaled to fit rather than stacked
  // at a fixed size.
  'SimpleGridPage': () => SimpleGridPage(
    title: 'Shapes',
    emoji: '🔷',
    subtitle: 'Tap a shape to hear its name',
    itemCount: 24,
    itemBuilder: (context, index, gradient, pulse) => Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔷', style: TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text('Shape $index', style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    ),
  ),
  // Two detail pages whose constructors take real content rather than an
  // index. The fixtures mirror the shape their parents pass in.
  'CertificateViewPage': () => CertificateViewPage(
    cert: const {
      'title': 'Sensory Learner',
      'description': 'Complete sensory learning',
      'icon': '👆',
      'color': Color(0xFFFFB74D),
    },
  ),
  'EnvironmentTopicDetailPage': () => EnvironmentTopicDetailPage(
    title: 'Save Water',
    facts: const [
      'Turn off the tap while brushing your teeth.',
      'A dripping tap can waste a bucket of water a day.',
      'Rain water can be collected and reused in the garden.',
    ],
    tip: 'Use a mug instead of a running tap.',
    color: const Color(0xFF4FC3F7),
    emoji: '💧',
    speakText: (_) {},
  ),
  'GenericAlphabetPage(capital)': () =>
      GenericAlphabetPage(type: alpha.AlphabetType.capital),
  'GenericAlphabetPage(small)': () =>
      GenericAlphabetPage(type: alpha.AlphabetType.small),
  'GenericMathQuestionsPage(addition)': () =>
      const GenericMathQuestionsPage(operationType: MathOperationType.addition),
  'GenericMathQuestionsPage(division)': () =>
      const GenericMathQuestionsPage(operationType: MathOperationType.division),
  'AdditionPage': () => AdditionPage(),
  'BodySafetyDetailPage': () => BodySafetyDetailPage(sectionIndex: 0),
  'CitizenshipBasicsDetailPage': () => CitizenshipBasicsDetailPage(sectionIndex: 0),
  'ClimateAwarenessDetailPage': () => ClimateAwarenessDetailPage(sectionIndex: 0),
  'CountriesFlagsDetailPage': () => CountriesFlagsDetailPage(sectionIndex: 0),
  'CountriesFlagsPage': () => CountriesFlagsPage(),
  'CreateNewPasswordPage': () => CreateNewPasswordPage(phoneNumber: 'A'),
  'DivisionPage': () => DivisionPage(),
  'EngineeringKidsDetailPage': () => EngineeringKidsDetailPage(sectionIndex: 0),
  'ExerciseFitnessDetailPage': () => ExerciseFitnessDetailPage(sectionIndex: 0),
  'FamilyRelationshipsDetailPage': () => FamilyRelationshipsDetailPage(sectionIndex: 0),
  'FamousPlacesDetailPage': () => FamousPlacesDetailPage(sectionIndex: 0),
  'FestivalLearningPage': () => FestivalLearningPage(),
  'GenericLearningPage': () => GenericLearningPage(type: 'A'),
  'GlobalCulturesDetailPage': () => GlobalCulturesDetailPage(sectionIndex: 0),
  // Takes an asset path, not a label; the auto-generated 'A' made the page
  // report a missing asset rather than a layout problem.
  'ImageDrowingScreen': () =>
      ImageDrowingScreen(imagePath: 'assets/coloring/apple.svg'),
  'LearningStrategyDetailPage': () => LearningStrategyDetailPage(sectionIndex: 0),
  'MathWorksheetScreen': () => MathWorksheetScreen(title: 'A', type: 'A'),
  'MemoryGamePage': () => MemoryGamePage(),
  'MentalHealthDetailPage': () => MentalHealthDetailPage(sectionIndex: 0),
  'MultiplicationPage': () => MultiplicationPage(),
  'NumberQuizPage': () => NumberQuizPage(),
  'NutritionLearningDetailPage': () => NutritionLearningDetailPage(sectionIndex: 0),
  'OtpVerificationPage': () => OtpVerificationPage(phoneNumber: 'A'),
  'PoemListPage': () => PoemListPage(),
  'ProfileScreen': () => ProfileScreen(name: 'A', email: 'A', appVersion: 'A'),
  'ReadingFluencyDetailPage': () => ReadingFluencyDetailPage(levelIndex: 0),
  'RecyclingKidsDetailPage': () => RecyclingKidsDetailPage(sectionIndex: 0),
  'SelfReflectionDetailPage': () => SelfReflectionDetailPage(sectionIndex: 0),
  'SentenceFormationDetailPage': () => SentenceFormationDetailPage(levelIndex: 0),
  'SightWordsDetailPage': () => SightWordsDetailPage(levelIndex: 0),
  'SpellingPracticeDetailPage': () => SpellingPracticeDetailPage(levelIndex: 0),
  'SteamDetailPage': () => SteamDetailPage(sectionIndex: 0),
  'StemChallengesDetailPage': () => StemChallengesDetailPage(challengeIndex: 0),
  'SubtractionPage': () => SubtractionPage(),
  'SustainableHabitsDetailPage': () => SustainableHabitsDetailPage(sectionIndex: 0),
  'TableDetailScreen': () => TableDetailScreen(number: 0),
  'ThinkAboutThinkingDetailPage': () => ThinkAboutThinkingDetailPage(sectionIndex: 0),
  'WorldMapDetailPage': () => WorldMapDetailPage(sectionIndex: 0),
  'AccessibilitySettingsPage': () => const AccessibilitySettingsPage(),
  'AdhdSupportPage': () => const AdhdSupportPage(),
  'AdsControlPage': () => const AdsControlPage(),
  'AgeInputPage': () => const AgeInputPage(),
  'AiAwarenessPage': () => const AiAwarenessPage(),
  'AnimatedVideosPage': () => const AnimatedVideosPage(),
  'AttentionTrainingPage': () => const AttentionTrainingPage(),
  'AutismFriendlyPage': () => const AutismFriendlyPage(),
  'CognitiveFlexibilityPage': () => const CognitiveFlexibilityPage(),
  'ColorMatchPage': () => const ColorMatchPage(),
  'CommunityHelpersPage': () => const CommunityHelpersPage(),
  'ConversationPracticePage': () => const ConversationPracticePage(),
  'CraftIdeasPage': () => const CraftIdeasPage(),
  'CulturalAwarenessPage': () => const CulturalAwarenessPage(),
  'DailyLifeSkillsPage': () => const DailyLifeSkillsPage(),
  'DanceActivitiesPage': () => const DanceActivitiesPage(),
  'DeviceOptimizationPage': () => const DeviceOptimizationPage(),
  'DrowingScreen': () => const DrowingScreen(),
  'EmotionalIntelligencePage': () => const EmotionalIntelligencePage(),
  'FineMotorSkillsPage': () => const FineMotorSkillsPage(),
  'FolkTalesPage': () => const FolkTalesPage(),
  'HomeExperimentsPage': () => const HomeExperimentsPage(),
  'ImaginationPage': () => const ImaginationPage(),
  'InfographicsPage': () => const InfographicsPage(),
  'LearningOutcomesPage': () => const LearningOutcomesPage(),
  'LearningPathPage': () => const LearningPathPage(),
  'LogicGamePage': () => const LogicGamePage(),
  'MakerSpacePage': () => const MakerSpacePage(),
  'MapsDirectionsPage': () => const MapsDirectionsPage(),
  'MiniProjectsPage': () => const MiniProjectsPage(),
  'MusicLearningPage': () => const MusicLearningPage(),
  'PhonicsPage': () => const PhonicsPage(),
  'PronunciationPracticePage': () => const PronunciationPracticePage(),
  'RegionalLanguagesPage': () => const RegionalLanguagesPage(),
  'RhythmLearningPage': () => const RhythmLearningPage(),
  'SaveEnvironmentPage': () => const SaveEnvironmentPage(),
  'ScreenResponsibilityPage': () => const ScreenResponsibilityPage(),
  'SelfControlPage': () => const SelfControlPage(),
  'StrokeOrderPage': () => const StrokeOrderPage(),
  'TeacherModePage': () => const TeacherModePage(),
  'WordBuildingPage': () => const WordBuildingPage(),
  'WritingAccuracyPage': () => const WritingAccuracyPage(),
'AccessibilitySettingsPage': () => AccessibilitySettingsPage(),
  'AccountSettingsScreen': () => AccountSettingsScreen(),
  'ActivityBasedLearningPage': () => ActivityBasedLearningPage(),
  'AdaptiveQuizPage': () => AdaptiveQuizPage(),
  'AdsScreen': () => AdsScreen(),
  'AdvancedMathGamesPage': () => AdvancedMathGamesPage(),
  'AgeSelectionPage': () => AgeSelectionPage(),
  'AlphabetMeaning': () => AlphabetMeaning(),
  'AppDrawer': () => AppDrawer(),
  'AppSettingsPage': () => AppSettingsPage(),
  'AudioLearningPage': () => AudioLearningPage(),
  'AvatarShopPage': () => AvatarShopPage(),
  'BodySafetyPage': () => BodySafetyPage(),
  'CertificatesPage': () => CertificatesPage(),
  'ChangePasswordScreen': () => ChangePasswordScreen(),
  'ChildProfilesPage': () => ChildProfilesPage(),
  'CitizenshipBasicsPage': () => CitizenshipBasicsPage(),
  'ClimateAwarenessPage': () => ClimateAwarenessPage(),
  'CloudSyncPage': () => CloudSyncPage(),
  'ComputerAwarenessPage': () => ComputerAwarenessPage(),
  'ConfidenceBuildingPage': () => ConfidenceBuildingPage(),
  'CursiveWritingPage': () => CursiveWritingPage(),
  'CustomThemesPage': () => CustomThemesPage(),
  'DailyGoalsPage': () => DailyGoalsPage(),
  'DesignThinkingPage': () => DesignThinkingPage(),
  'DigitalEtiquettePage': () => DigitalEtiquettePage(),
  'DiscoveryLearningPage': () => DiscoveryLearningPage(),
  'DiyLearningPage': () => DiyLearningPage(),
  'DragDropGamePage': () => DragDropGamePage(),
  'EarlyLearningHubPage': () => EarlyLearningHubPage(),
  'EditProfileScreen': () => EditProfileScreen(),
  'EmotionalRegulationPage': () => EmotionalRegulationPage(),
  'EmpathyLearningPage': () => EmpathyLearningPage(),
  'EngineeringKidsPage': () => EngineeringKidsPage(),
  'EnvironmentalStudiesPage': () => EnvironmentalStudiesPage(),
  'ExerciseFitnessPage': () => ExerciseFitnessPage(),
  'ExperientialLearningPage': () => ExperientialLearningPage(),
  'ExploratoryLearningPage': () => ExploratoryLearningPage(),
  'FamilyRelationshipsPage': () => FamilyRelationshipsPage(),
  'FamousPlacesPage': () => FamousPlacesPage(),
  'FlashcardsPage': () => FlashcardsPage(),
  'FocusImprovementPage': () => FocusImprovementPage(),
  'ForgotPasswordPage': () => ForgotPasswordPage(),
  'FunGamesPage': () => FunGamesPage(),
  'GKLearningPage': () => GKLearningPage(),
  'GamesHubPage': () => GamesHubPage(),
  'GlobalCulturesPage': () => GlobalCulturesPage(),
  'GoalSettingPage': () => GoalSettingPage(),
  'GoodHabitsPage': () => GoodHabitsPage(),
  'HandwritingPracticePage': () => HandwritingPracticePage(),
  'HelpScreen': () => HelpScreen(),
  'HindiLettersPage': () => HindiLettersPage(),
  'HomeScreen': () => HomeScreen(),
  'HygieneHabitsPage': () => HygieneHabitsPage(),
  'InternetSafetyPage': () => InternetSafetyPage(),
  'KeyboardMousePage': () => KeyboardMousePage(),
  'KidsDrowingScreen': () => KidsDrowingScreen(),
  'KinestheticLearningPage': () => KinestheticLearningPage(),
  'LeaderboardPage': () => LeaderboardPage(),
  'LearningSetsGridScreen': () => LearningSetsGridScreen(),
  'LearningStrategyPage': () => LearningStrategyPage(),
  'ListeningSkillsPage': () => ListeningSkillsPage(),
  'LoginPage': () => LoginPage(),
  'MainNavigationScreen': () => MainNavigationScreen(),
  'MatchingGamePage': () => MatchingGamePage(),
  'MathGridScreen': () => MathGridScreen(),
  'MathQustionGridScreen': () => MathQustionGridScreen(),
  'MathScannerPage': () => MathScannerPage(),
  'MentalHealthBasicsPage': () => MentalHealthBasicsPage(),
  'MindfulnessPage': () => MindfulnessPage(),
  'MoneyConceptsPage': () => MoneyConceptsPage(),
  'MoneyHabitsPage': () => MoneyHabitsPage(),
  'MontessoriLearningPage': () => MontessoriLearningPage(),
  'NotificationListPage': () => NotificationListPage(),
  'NotificationSettingsScreen': () => NotificationSettingsScreen(),
  'NumbersScreen': () => NumbersScreen(),
  'NutritionLearningPage': () => NutritionLearningPage(),
  'OcrScreen': () => OcrScreen(),
  'OfflineLearningPage': () => OfflineLearningPage(),
  'ParentDashboardPage': () => ParentDashboardPage(),
  'ParentalControlPage': () => ParentalControlPage(),
  'PdfDownloadsPage': () => PdfDownloadsPage(),
  'PlanningSkillsPage': () => PlanningSkillsPage(),
  'PlayBasedLearningPage': () => PlayBasedLearningPage(),
  'PremiumFeaturesScreen': () => PremiumFeaturesScreen(),
  'PremiumPlansPage': () => PremiumPlansPage(),
  'PrivacyPolicyScreen': () => PrivacyPolicyScreen(),
  'ProgressReportsPage': () => ProgressReportsPage(),
  'PuzzleGamePage': () => PuzzleGamePage(),
  'QuizBattlePage': () => QuizBattlePage(),
  'QuizHubPage': () => QuizHubPage(),
  'QuizPage': () => QuizPage(),
  'ReadingFluencyPage': () => ReadingFluencyPage(),
  'RecyclingKidsPage': () => RecyclingKidsPage(),
  'ReportsPage': () => ReportsPage(),
  'RewardsPage': () => RewardsPage(),
  'RhymesPage': () => RhymesPage(),
  'RightsDutiesPage': () => RightsDutiesPage(),
  'SafetySkillsPage': () => SafetySkillsPage(),
  'ScienceBasicsPage': () => ScienceBasicsPage(),
  'SeasonsLearningPage': () => SeasonsLearningPage(),
  'SelfAwarenessPage': () => SelfAwarenessPage(),
  'SelfReflectionPage': () => SelfReflectionPage(),
  'SensoryLearningPage': () => SensoryLearningPage(),
  'SentenceFormationPage': () => SentenceFormationPage(),
  'ShapesLearningPage': () => ShapesLearningPage(),
  'SightWordsPage': () => SightWordsPage(),
  'SignupPage': () => SignupPage(),
  'SimpleExperimentsPage': () => SimpleExperimentsPage(),
  'SkillEvaluationPage': () => SkillEvaluationPage(),
  'SocialAwarenessPage': () => SocialAwarenessPage(),
  'SpellingPracticePage': () => SpellingPracticePage(),
  'SplashScreen': () => SplashScreen(),
  'SteamPage': () => SteamPage(),
  'StemChallengesPage': () => StemChallengesPage(),
  'StemHubPage': () => StemHubPage(),
  'StoriesPage': () => StoriesPage(),
  'StoryCreationPage': () => StoryCreationPage(),
  'StoryTimePage': () => StoryTimePage(),
  'SupportScreen': () => SupportScreen(),
  'SurpriseRewardsPage': () => SurpriseRewardsPage(),
  'SustainableHabitsPage': () => SustainableHabitsPage(),
  'TableScreen': () => TableScreen(),
  'TaskSequencingPage': () => TaskSequencingPage(),
  'TermsConditionsScreen': () => TermsConditionsScreen(),
  'ThinkAboutThinkingPage': () => ThinkAboutThinkingPage(),
  'TimeManagementPage': () => TimeManagementPage(),
  'TracingGamePage': () => TracingGamePage(),
  'VehiclesLearningPage': () => VehiclesLearningPage(),
  'VisualLearningPage': () => VisualLearningPage(),
  'VoiceLearningPage': () => VoiceLearningPage(),
  'WorkingMemoryPage': () => WorkingMemoryPage(),
  'WorksheetsPage': () => WorksheetsPage(),
  'WorldMapPage': () => WorldMapPage(),
};
