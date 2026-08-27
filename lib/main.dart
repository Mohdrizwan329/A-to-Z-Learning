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
//  New services
import 'package:jiyan_learning/services/speech_recognition_service.dart';
import 'package:jiyan_learning/services/avatar_coins_service.dart';
import 'package:jiyan_learning/services/leaderboard_service.dart';
import 'package:jiyan_learning/services/notification_service.dart';
import 'package:jiyan_learning/services/accessibility_service.dart';
import 'package:jiyan_learning/services/cloud_sync_service.dart';
import 'package:jiyan_learning/services/multi_profile_service.dart';
import 'package:jiyan_learning/services/age_content_service.dart';
import 'package:jiyan_learning/services/ad_service.dart';
import 'package:jiyan_learning/services/certificate_vault.dart';
import 'package:jiyan_learning/services/offline_content_service.dart';
import 'package:jiyan_learning/services/study_alarm_service.dart';
import 'package:jiyan_learning/services/user_profile_service.dart';
import 'package:jiyan_learning/services/tts_service.dart';
import 'package:jiyan_learning/utils/responsive.dart';
import 'package:jiyan_learning/widgets/app_tint_shell.dart';
import 'package:jiyan_learning/widgets/global_ad_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  // Device Optimisation settings the widget tree reads directly: reduced
  // animations and the image-cache cap. Loaded before the first frame.
  DeviceTuning.load(GetStorage());
  // Runs before any scratch file is opened, so nothing in use is removed.
  await DeviceTuning.autoCleanIfAsked(GetStorage());

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

  // Initialize essential services (non-blocking for faster startup)
  // Ad Service (needed for home screen ads)
  await Get.putAsync(() => AdService().init(), permanent: true);

  // Age Content Service (needed for content filtering)
  await Get.putAsync(() => AgeContentService().init(), permanent: true);

  // TTS Service (Text-to-Speech for all screens)
  await Get.putAsync(() => TtsService().init(), permanent: true);

  // Study alarms. Started up front, not lazily: re-arming what the user has
  // already set must not wait for them to open the alarm tab.
  await Get.putAsync(() => StudyAlarmService().init(), permanent: true);

  // Reads the asset manifest once so the offline screen knows what is
  // really bundled with the app.
  await Get.putAsync(() => OfflineContentService().init(), permanent: true);

  // Knows which certificates are already saved on the device, and forgets
  // any whose file has since gone.
  await Get.putAsync(() => CertificateVault().init(), permanent: true);

  // The user's own name, email, location and photo. Needed as soon as the
  // profile tab is built, so it is ready before the first frame.
  await Get.putAsync(() => UserProfileService().init(), permanent: true);

  // Lazy-load services that are not needed at startup (saves memory)
  Get.lazyPut(() => SpeechRecognitionService(), fenix: true);
  Get.lazyPut(() => AvatarCoinsService(), fenix: true);
  Get.lazyPut(() => LeaderboardService(), fenix: true);
  Get.lazyPut(() => NotificationService(), fenix: true);
  Get.lazyPut(() => AccessibilityService(), fenix: true);
  Get.lazyPut(() => CloudSyncService(), fenix: true);
  Get.lazyPut(() => MultiProfileService(), fenix: true);

  await dotenv.load(fileName: ".env");

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
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
          seedColor: const Color.fromARGB(255, 57, 32, 99),
        ),
      ),
      // Reaches the surfaces this app does not paint itself -- dialogs,
      // pickers, text fields, bottom sheets. The pages' own gradients are
      // handled by AppTintShell below.
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 57, 32, 99),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: AppSettingsService.startupThemeMode(),
      initialRoute: '/',
      getPages: AppPages.routes,
      // Mouse and trackpad drag-scrolling, which desktop and web lack by default.
      scrollBehavior: const AppScrollBehavior(),
      // Keeps the app-wide banner in step with navigation, so it can stay off
      // the splash, the auth flow and the pages selling the ad-free upgrade.
      routingCallback: GlobalAdShell.onRouteChanged,
      // Keeps R in step with the live MediaQuery on every rotation and window
      // resize, clamps system font scaling, and centres the layout instead of
      // stretching it on tablets, desktop and the web.
      builder: (context, child) => ResponsiveShell(
        // Sits inside ResponsiveShell so the banner is laid out against the
        // clamped MediaQuery the rest of the app sees, and inside the tint so
        // Dark and Eye-Friendly mode cover every pixel.
        child: AppTintShell(
          child: GlobalAdShell(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}
