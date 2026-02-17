/// App-wide constants for Jiyan Learning
library;

class AppConstants {
  // App Info
  static const String appName = 'Jiyan Learning';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Fun Learning for Kids!';

  // Storage Keys
  static const String userKey = 'user_data';
  static const String childProfilesKey = 'child_profiles';
  static const String activeChildKey = 'active_child_id';
  static const String progressKey = 'learning_progress';
  static const String rewardsKey = 'rewards_data';
  static const String settingsKey = 'app_settings';
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'app_locale';
  static const String onboardingKey = 'onboarding_complete';
  static const String lastSyncKey = 'last_sync_date';

  // Age Groups
  static const int minAge = 2;
  static const int maxAge = 10;
  static const List<String> ageGroups = [
    '2-3 years',
    '3-4 years',
    '4-5 years',
    '5-6 years',
    '6-8 years',
    '8-10 years',
  ];

  // Learning Categories
  static const List<String> categories = [
    'numbers',
    'capital_letters',
    'small_letters',
    'hindi_letters',
    'tables',
    'animals',
    'birds',
    'fruits',
    'vegetables',
    'colors',
    'shapes',
    'body_parts',
    'flowers',
    'months',
    'weekdays',
  ];

  // Quiz Settings
  static const int defaultQuizQuestions = 10;
  static const int quizTimePerQuestion = 30; // seconds
  static const int minPassingScore = 60; // percentage

  // Reward Settings
  static const int dailySpinLimit = 3;
  static const int dailyMysteryBoxLimit = 2;
  static const int dailyScratchCardLimit = 1;
  static const int pointsPerCorrectAnswer = 10;
  static const int pointsPerCompletedLesson = 50;
  static const int pointsPerDailyGoal = 100;
  static const int streakBonusMultiplier = 2;

  // Animation Durations
  static const int shortAnimationMs = 200;
  static const int mediumAnimationMs = 400;
  static const int longAnimationMs = 800;
  static const int spinWheelDurationMs = 3000;

  // Parental Control
  static const String defaultParentPin = '1234';
  static const int maxDailyScreenTimeMinutes = 60;
  static const int sessionBreakMinutes = 15;

  // API & Network
  static const int connectionTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;

  // Cache Settings
  static const int maxCachedQuizResults = 100;
  static const int maxCachedLessons = 50;

  // Asset Paths
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';
  static const String soundsPath = 'assets/sounds/';
  static const String jsonPath = 'assets/json/';
  static const String animationsPath = 'assets/animations/';

  // Emojis for Categories
  static const Map<String, String> categoryEmojis = {
    'numbers': '🔢',
    'capital_letters': '🔤',
    'small_letters': '🔡',
    'hindi_letters': '📚',
    'tables': '✖️',
    'animals': '🦁',
    'birds': '🐦',
    'fruits': '🍎',
    'vegetables': '🥕',
    'colors': '🌈',
    'shapes': '🔷',
    'body_parts': '🫁',
    'flowers': '🌸',
    'months': '📅',
    'weekdays': '📆',
    'games': '🎮',
    'quiz': '📝',
    'drawing': '🎨',
    'music': '🎵',
    'stories': '📖',
  };

  // Badge Types
  static const List<String> badgeTypes = [
    'first_lesson',
    'streak_7',
    'streak_30',
    'quiz_master',
    'perfect_score',
    'speed_learner',
    'explorer',
    'creative_artist',
    'math_genius',
    'word_wizard',
  ];

  // Difficulty Levels
  static const List<String> difficultyLevels = [
    'easy',
    'medium',
    'hard',
    'expert',
  ];

  // Supported Languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'hi': 'Hindi',
    'ta': 'Tamil',
    'te': 'Telugu',
    'kn': 'Kannada',
    'ml': 'Malayalam',
    'bn': 'Bengali',
    'gu': 'Gujarati',
    'mr': 'Marathi',
    'pa': 'Punjabi',
  };

  // Hindi Vowels & Consonants
  static const List<String> hindiVowels = [
    'अ', 'आ', 'इ', 'ई', 'उ', 'ऊ', 'ऋ', 'ए', 'ऐ', 'ओ', 'औ', 'अं', 'अः'
  ];

  static const List<String> hindiConsonants = [
    'क', 'ख', 'ग', 'घ', 'ङ',
    'च', 'छ', 'ज', 'झ', 'ञ',
    'ट', 'ठ', 'ड', 'ढ', 'ण',
    'त', 'थ', 'द', 'ध', 'न',
    'प', 'फ', 'ब', 'भ', 'म',
    'य', 'र', 'ल', 'व',
    'श', 'ष', 'स', 'ह',
    'क्ष', 'त्र', 'ज्ञ',
  ];
}

/// Regex patterns for validation
class Patterns {
  static final RegExp email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp phone = RegExp(r'^[0-9]{10}$');
  static final RegExp pin = RegExp(r'^[0-9]{4,6}$');
  static final RegExp name = RegExp(r'^[a-zA-Z ]{2,30}$');
}

/// Error messages
class ErrorMessages {
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Something went wrong. Please try again';
  static const String invalidEmail = 'Please enter a valid email';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String invalidPin = 'PIN must be 4-6 digits';
  static const String invalidName = 'Please enter a valid name';
  static const String sessionExpired = 'Session expired. Please login again';
  static const String noDataFound = 'No data found';
  static const String permissionDenied = 'Permission denied';
}

/// Success messages
class SuccessMessages {
  static const String lessonCompleted = 'Great job! Lesson completed!';
  static const String quizCompleted = 'Quiz completed! Check your score!';
  static const String rewardEarned = 'Yay! You earned a reward!';
  static const String streakContinued = 'Keep it up! Streak continues!';
  static const String goalAchieved = 'Goal achieved! Well done!';
  static const String profileSaved = 'Profile saved successfully';
  static const String settingsSaved = 'Settings saved successfully';
}
