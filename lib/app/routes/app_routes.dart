import 'package:get/get_navigation/get_navigation.dart';

// Current existing paths - will be updated after file migration
import 'package:jiyan_learning/view/splash/splash_screen.dart';
import 'package:jiyan_learning/view/main_navigation_screen.dart';
import 'package:jiyan_learning/view/world%20meaning%20Alphabet%20/Alphabet_meaning.dart';
import 'package:jiyan_learning/view/numbers/Number_Page.dart';
import 'package:jiyan_learning/view/tables/Table_Page.dart';
import 'package:jiyan_learning/view/drawing/Drawing_Image_Page.dart';
import 'package:jiyan_learning/view/drawing/Drawing_Page.dart';
import 'package:jiyan_learning/view/math%20problem%20&%20solution/Problems_Pages.dart';
import 'package:jiyan_learning/view/auth/login_page.dart';
import 'package:jiyan_learning/view/auth/signup_page.dart';
import 'package:jiyan_learning/view/auth/forgot_password_page.dart';
import 'package:jiyan_learning/view/premium/premium_features_screen.dart';
import 'package:jiyan_learning/view/premium/premium_plans_page.dart';
import 'package:jiyan_learning/view/games/games_hub_page.dart';
import 'package:jiyan_learning/view/quiz/quiz_page.dart';
import 'package:jiyan_learning/view/quiz/quiz_hub_page.dart';
import 'package:jiyan_learning/view/rewards/rewards_page.dart';
import 'package:jiyan_learning/view/rewards/daily_goals_page.dart';
import 'package:jiyan_learning/view/rewards/surprise_rewards_page.dart';
import 'package:jiyan_learning/view/settings/app_settings_page.dart';
import 'package:jiyan_learning/view/settings/parental_control_page.dart';
import 'package:jiyan_learning/view/premium/avatar_shop_page.dart';
import 'package:jiyan_learning/view/premium/leaderboard_page.dart';
import 'package:jiyan_learning/view/premium/parent_dashboard_page.dart';
import 'package:jiyan_learning/view/profiles/accessibility/accessibility_settings_page.dart';
import 'package:jiyan_learning/view/profiles/child_profiles/child_profiles_page.dart';
import 'package:jiyan_learning/view/profiles/sync/cloud_sync_page.dart';
import 'package:jiyan_learning/view/profiles/notification/notification_settings_page.dart';
import 'package:jiyan_learning/view/profiles/notification/notification_list_page.dart';
// ProfileScreen is accessed via MainNavigationScreen (requires parameters)
import 'package:jiyan_learning/view/age_selection/age_selection_page.dart';
import 'package:jiyan_learning/view/early_learning/early_learning_hub_page.dart';
import 'package:jiyan_learning/view/early_learning/sensory_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/visual_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/audio_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/kinesthetic_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/play_based_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/exploratory_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/discovery_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/montessori_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/activity_based_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/experiential_learning_page.dart';

/// Route names as constants for type safety
abstract class Routes {
  // Auth
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';

  // Home
  static const home = '/home';

  // Learning
  static const numbers = '/numbers';
  static const alphabets = '/alphabets';
  static const alphabetMeaning = '/alphabet-meaning';
  static const tables = '/tables';
  static const mathProblems = '/math-problems';
  static const drawing = '/drawing';
  static const drawingImage = '/drawing-image';

  // Early Learning
  static const earlyLearning = '/early-learning';
  static const sensoryLearning = '/sensory-learning';
  static const visualLearning = '/visual-learning';
  static const audioLearning = '/audio-learning';
  static const kinestheticLearning = '/kinesthetic-learning';
  static const playBasedLearning = '/play-based-learning';
  static const exploratoryLearning = '/exploratory-learning';
  static const discoveryLearning = '/discovery-learning';
  static const montessoriLearning = '/montessori-learning';
  static const activityBasedLearning = '/activity-based-learning';
  static const experientialLearning = '/experiential-learning';

  // Games
  static const games = '/games';

  // Assessment
  static const quiz = '/quiz';
  static const quizHub = '/quiz-hub';

  // Rewards
  static const rewards = '/rewards';
  static const dailyGoals = '/daily-goals';
  static const surpriseRewards = '/surprise-rewards';

  // Parent Dashboard
  static const parentDashboard = '/parent-dashboard';
  static const leaderboard = '/leaderboard';
  static const avatarShop = '/avatar-shop';
  static const premiumFeatures = '/premium-features';

  // Profile
  static const profile = '/profile';
  static const childProfiles = '/child-profiles';
  static const ageSelection = '/age-selection';
  static const ageInput = '/age-input';

  // Settings
  static const settings = '/settings';
  static const parentalControls = '/parental-controls';
  static const accessibility = '/accessibility';
  static const cloudSync = '/cloud-sync';
  static const notificationSettings = '/notification-settings';
  static const notifications = '/notifications';

  // Payment
  static const premium = '/premium';
}

/// GetX Route Pages
class AppPages {
  static final routes = [
    // Auth Routes
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(name: Routes.login, page: () => const LoginPage()),
    GetPage(name: Routes.signup, page: () => SignupPage()),
    GetPage(name: Routes.forgotPassword, page: () => const ForgotPasswordPage()),

    // Home Routes
    GetPage(name: Routes.home, page: () => MainNavigationScreen()),

    // Learning Routes
    GetPage(name: Routes.numbers, page: () => NumbersScreen()),
    GetPage(name: Routes.alphabetMeaning, page: () => AlphabetMeaning()),
    GetPage(name: Routes.tables, page: () => TableScreen()),
    GetPage(name: Routes.mathProblems, page: () => MathGridScreen()),
    GetPage(name: Routes.drawing, page: () => KidsDrowingScreen()),
    GetPage(name: Routes.drawingImage, page: () => DrowingScreen()),

    // Early Learning Routes
    GetPage(name: Routes.earlyLearning, page: () => const EarlyLearningHubPage()),
    GetPage(name: Routes.sensoryLearning, page: () => const SensoryLearningPage()),
    GetPage(name: Routes.visualLearning, page: () => const VisualLearningPage()),
    GetPage(name: Routes.audioLearning, page: () => const AudioLearningPage()),
    GetPage(name: Routes.kinestheticLearning, page: () => const KinestheticLearningPage()),
    GetPage(name: Routes.playBasedLearning, page: () => const PlayBasedLearningPage()),
    GetPage(name: Routes.exploratoryLearning, page: () => const ExploratoryLearningPage()),
    GetPage(name: Routes.discoveryLearning, page: () => const DiscoveryLearningPage()),
    GetPage(name: Routes.montessoriLearning, page: () => const MontessoriLearningPage()),
    GetPage(name: Routes.activityBasedLearning, page: () => const ActivityBasedLearningPage()),
    GetPage(name: Routes.experientialLearning, page: () => const ExperientialLearningPage()),

    // Games Routes
    GetPage(name: Routes.games, page: () => const GamesHubPage()),

    // Assessment Routes
    GetPage(name: Routes.quiz, page: () => const QuizPage()),
    GetPage(name: Routes.quizHub, page: () => const QuizHubPage()),

    // Rewards Routes
    GetPage(name: Routes.rewards, page: () => const RewardsPage()),
    GetPage(name: Routes.dailyGoals, page: () => const DailyGoalsPage()),
    GetPage(name: Routes.surpriseRewards, page: () => const SurpriseRewardsPage()),

    // Parent Dashboard Routes
    GetPage(name: Routes.parentDashboard, page: () => const ParentDashboardPage()),
    GetPage(name: Routes.leaderboard, page: () => const LeaderboardPage()),
    GetPage(name: Routes.avatarShop, page: () => const AvatarShopPage()),
    GetPage(name: Routes.premiumFeatures, page: () => const PremiumFeaturesScreen()),

    // Profile Routes (ProfileScreen accessed via MainNavigationScreen)
    GetPage(name: Routes.childProfiles, page: () => const ChildProfilesPage()),
    GetPage(name: Routes.ageSelection, page: () => const AgeSelectionPage()),
    GetPage(name: Routes.ageInput, page: () => const AgeInputPage()),

    // Settings Routes
    GetPage(name: Routes.settings, page: () => const AppSettingsPage()),
    GetPage(name: Routes.parentalControls, page: () => const ParentalControlPage()),
    GetPage(name: Routes.accessibility, page: () => const AccessibilitySettingsPage()),
    GetPage(name: Routes.cloudSync, page: () => const CloudSyncPage()),
    GetPage(name: Routes.notificationSettings, page: () => const NotificationSettingsScreen()),
    GetPage(name: Routes.notifications, page: () => NotificationListPage()),

    // Payment Routes
    GetPage(name: Routes.premium, page: () => const PremiumPlansPage()),
  ];
}
