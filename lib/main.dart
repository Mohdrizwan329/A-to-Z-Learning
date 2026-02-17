import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view%20model/auth%20controller/auth_controller.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/services/app_settings_service.dart';
import 'package:jiyan_learning/services/rewards_service.dart';
import 'package:jiyan_learning/services/daily_goals_service.dart';
import 'package:jiyan_learning/services/screen_time_service.dart';
// New services
import 'package:jiyan_learning/services/speech_recognition_service.dart';
import 'package:jiyan_learning/services/smart_learning_service.dart';
import 'package:jiyan_learning/services/avatar_coins_service.dart';
import 'package:jiyan_learning/services/leaderboard_service.dart';
import 'package:jiyan_learning/services/notification_service.dart';
import 'package:jiyan_learning/services/festival_content_service.dart';
import 'package:jiyan_learning/services/syllabus_service.dart';
import 'package:jiyan_learning/services/accessibility_service.dart';
import 'package:jiyan_learning/services/cloud_sync_service.dart';
import 'package:jiyan_learning/services/multi_profile_service.dart';
import 'package:jiyan_learning/services/age_content_service.dart';
import 'package:jiyan_learning/services/ad_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  // Firebase Initialization - only on mobile platforms (web requires separate config)
  if (!kIsWeb) {
    await Firebase.initializeApp();
  }

  // Initialize AuthController globally
  Get.put(AuthController(), permanent: true);

  // Initialize ProgressService globally
  Get.put(ProgressService(), permanent: true);

  // Initialize AppSettingsService globally (for dark mode, themes, etc.)
  Get.put(AppSettingsService(), permanent: true);

  // Initialize RewardsService globally (for stars, badges, trophies)
  Get.put(RewardsService(), permanent: true);

  // Initialize DailyGoalsService globally (for daily learning goals)
  Get.put(DailyGoalsService(), permanent: true);

  // Initialize ScreenTimeService globally (for parental controls)
  Get.put(ScreenTimeService(), permanent: true);

  // Initialize new services
  // Speech Recognition Service
  await Get.putAsync(() => SpeechRecognitionService().init(), permanent: true);

  // Smart Learning Service (AI-based learning analytics)
  await Get.putAsync(() => SmartLearningService().init(), permanent: true);

  // Avatar & Coins Service (gamification)
  await Get.putAsync(() => AvatarCoinsService().init(), permanent: true);

  // Leaderboard Service (social features)
  await Get.putAsync(() => LeaderboardService().init(), permanent: true);

  // Notification Service (push notifications)
  await Get.putAsync(() => NotificationService().init(), permanent: true);

  // Festival Content Service (themed content)
  await Get.putAsync(() => FestivalContentService().init(), permanent: true);

  // Syllabus Service (CBSE/ICSE curriculum)
  await Get.putAsync(() => SyllabusService().init(), permanent: true);

  // Accessibility Service (dyslexia font, color blind mode)
  await Get.putAsync(() => AccessibilityService().init(), permanent: true);

  // Cloud Sync Service (backup/restore)
  await Get.putAsync(() => CloudSyncService().init(), permanent: true);

  // Multi Profile Service (child profiles)
  await Get.putAsync(() => MultiProfileService().init(), permanent: true);

  // Age Content Service (age-wise content filtering)
  await Get.putAsync(() => AgeContentService().init(), permanent: true);

  // Ad Service (Google Mobile Ads)
  await Get.putAsync(() => AdService().init(), permanent: true);

  await dotenv.load(fileName: ".env");

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) {
      exit(1);
    }
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 57, 32, 99),
        ),
      ),
      initialRoute: '/',
      getPages: AppPages.routes,
    );
  }
}
