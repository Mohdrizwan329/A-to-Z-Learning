import 'package:get/get.dart';

// Services
import 'package:jiyan_learning/services/accessibility_service.dart';
import 'package:jiyan_learning/services/age_content_service.dart';
import 'package:jiyan_learning/services/app_settings_service.dart';
import 'package:jiyan_learning/services/avatar_coins_service.dart';
import 'package:jiyan_learning/services/cloud_sync_service.dart';
import 'package:jiyan_learning/services/daily_goals_service.dart';
import 'package:jiyan_learning/services/festival_content_service.dart';
import 'package:jiyan_learning/services/firebase_service.dart';
import 'package:jiyan_learning/services/leaderboard_service.dart';
import 'package:jiyan_learning/services/multi_profile_service.dart';
import 'package:jiyan_learning/services/notification_service.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/services/rewards_service.dart';
import 'package:jiyan_learning/services/screen_time_service.dart';
import 'package:jiyan_learning/services/smart_learning_service.dart';
import 'package:jiyan_learning/services/speech_recognition_service.dart';
import 'package:jiyan_learning/services/syllabus_service.dart';

// Controllers
import 'package:jiyan_learning/view%20model/home%20controller/home_controller.dart';
import 'package:jiyan_learning/view%20model/auth%20controller/auth_controller.dart';

/// Initial bindings that are loaded when the app starts
/// This registers all global services and controllers with GetX
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Core Services - Permanent (lazy loaded, stays in memory)
    Get.lazyPut<FirebaseService>(() => FirebaseService(), fenix: true);
    Get.lazyPut<AppSettingsService>(() => AppSettingsService(), fenix: true);

    // User & Profile Services
    Get.lazyPut<MultiProfileService>(() => MultiProfileService(), fenix: true);
    Get.lazyPut<AgeContentService>(() => AgeContentService(), fenix: true);

    // Learning & Progress Services
    Get.lazyPut<ProgressService>(() => ProgressService(), fenix: true);
    Get.lazyPut<SmartLearningService>(() => SmartLearningService(), fenix: true);
    Get.lazyPut<SyllabusService>(() => SyllabusService(), fenix: true);

    // Gamification Services
    Get.lazyPut<RewardsService>(() => RewardsService(), fenix: true);
    Get.lazyPut<DailyGoalsService>(() => DailyGoalsService(), fenix: true);
    Get.lazyPut<AvatarCoinsService>(() => AvatarCoinsService(), fenix: true);
    Get.lazyPut<LeaderboardService>(() => LeaderboardService(), fenix: true);

    // Content Services
    Get.lazyPut<FestivalContentService>(() => FestivalContentService(), fenix: true);

    // Utility Services
    Get.lazyPut<AccessibilityService>(() => AccessibilityService(), fenix: true);
    Get.lazyPut<CloudSyncService>(() => CloudSyncService(), fenix: true);
    Get.lazyPut<NotificationService>(() => NotificationService(), fenix: true);
    Get.lazyPut<ScreenTimeService>(() => ScreenTimeService(), fenix: true);
    Get.lazyPut<SpeechRecognitionService>(() => SpeechRecognitionService(), fenix: true);

    // Core Controllers
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}

/// Splash screen bindings
class SplashBindings extends Bindings {
  @override
  void dependencies() {
    // Any splash-specific dependencies
  }
}

/// Auth module bindings
class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

/// Home module bindings
class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

/// Learning module bindings
class LearningBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProgressService>(() => ProgressService());
    Get.lazyPut<SmartLearningService>(() => SmartLearningService());
  }
}

/// Games module bindings
class GamesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RewardsService>(() => RewardsService());
  }
}

/// Assessment (Quiz) module bindings
class AssessmentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RewardsService>(() => RewardsService());
    Get.lazyPut<ProgressService>(() => ProgressService());
  }
}

/// Rewards module bindings
class RewardsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RewardsService>(() => RewardsService());
    Get.lazyPut<DailyGoalsService>(() => DailyGoalsService());
    Get.lazyPut<AvatarCoinsService>(() => AvatarCoinsService());
  }
}

/// Parent Dashboard module bindings
class ParentDashboardBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProgressService>(() => ProgressService());
    Get.lazyPut<ScreenTimeService>(() => ScreenTimeService());
    Get.lazyPut<MultiProfileService>(() => MultiProfileService());
  }
}

/// Settings module bindings
class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppSettingsService>(() => AppSettingsService());
    Get.lazyPut<AccessibilityService>(() => AccessibilityService());
    Get.lazyPut<ScreenTimeService>(() => ScreenTimeService());
  }
}
