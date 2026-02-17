import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FestivalContentService extends GetxService {
  final GetStorage _box = GetStorage();

  final Rx<FestivalTheme?> currentFestival = Rx<FestivalTheme?>(null);
  final RxList<FestivalLesson> festivalLessons = <FestivalLesson>[].obs;
  final RxList<String> completedFestivalLessons = <String>[].obs;
  final RxBool festivalModeEnabled = true.obs;

  // All festivals with their date ranges
  static final List<FestivalTheme> festivals = [
    // Diwali (October/November - varies by lunar calendar)
    FestivalTheme(
      id: 'diwali',
      name: 'Diwali',
      nameHindi: 'दीवाली',
      emoji: '🪔',
      description: 'Festival of Lights',
      colors: [0xFFFF9800, 0xFFFFEB3B, 0xFFE65100],
      month: 10, // Approximate
      dayStart: 20,
      dayEnd: 30,
      greeting: 'Happy Diwali!',
      greetingHindi: 'शुभ दीपावली!',
    ),
    // Holi (March)
    FestivalTheme(
      id: 'holi',
      name: 'Holi',
      nameHindi: 'होली',
      emoji: '🎨',
      description: 'Festival of Colors',
      colors: [0xFFE91E63, 0xFF9C27B0, 0xFF2196F3, 0xFF4CAF50, 0xFFFFEB3B],
      month: 3,
      dayStart: 1,
      dayEnd: 15,
      greeting: 'Happy Holi!',
      greetingHindi: 'होली मुबारक!',
    ),
    // Raksha Bandhan (August)
    FestivalTheme(
      id: 'raksha_bandhan',
      name: 'Raksha Bandhan',
      nameHindi: 'रक्षा बंधन',
      emoji: '🎀',
      description: 'Bond of Protection',
      colors: [0xFFE91E63, 0xFFF48FB1, 0xFFFFD700],
      month: 8,
      dayStart: 10,
      dayEnd: 20,
      greeting: 'Happy Raksha Bandhan!',
      greetingHindi: 'रक्षा बंधन की शुभकामनाएं!',
    ),
    // Ganesh Chaturthi (August/September)
    FestivalTheme(
      id: 'ganesh_chaturthi',
      name: 'Ganesh Chaturthi',
      nameHindi: 'गणेश चतुर्थी',
      emoji: '🐘',
      description: 'Lord Ganesha Festival',
      colors: [0xFFFF5722, 0xFFFFEB3B, 0xFF4CAF50],
      month: 9,
      dayStart: 1,
      dayEnd: 15,
      greeting: 'Ganpati Bappa Morya!',
      greetingHindi: 'गणपति बप्पा मोरया!',
    ),
    // Navratri/Durga Puja (September/October)
    FestivalTheme(
      id: 'navratri',
      name: 'Navratri',
      nameHindi: 'नवरात्रि',
      emoji: '🔱',
      description: 'Nine Nights Festival',
      colors: [0xFFE91E63, 0xFF9C27B0, 0xFFFF9800],
      month: 10,
      dayStart: 1,
      dayEnd: 15,
      greeting: 'Happy Navratri!',
      greetingHindi: 'नवरात्रि की शुभकामनाएं!',
    ),
    // Christmas (December)
    FestivalTheme(
      id: 'christmas',
      name: 'Christmas',
      nameHindi: 'क्रिसमस',
      emoji: '🎄',
      description: 'Christmas Celebration',
      colors: [0xFFC62828, 0xFF2E7D32, 0xFFFFD700],
      month: 12,
      dayStart: 20,
      dayEnd: 31,
      greeting: 'Merry Christmas!',
      greetingHindi: 'क्रिसमस की शुभकामनाएं!',
    ),
    // Republic Day (January)
    FestivalTheme(
      id: 'republic_day',
      name: 'Republic Day',
      nameHindi: 'गणतंत्र दिवस',
      emoji: '🇮🇳',
      description: 'Indian Republic Day',
      colors: [0xFFFF9933, 0xFFFFFFFF, 0xFF138808],
      month: 1,
      dayStart: 24,
      dayEnd: 28,
      greeting: 'Happy Republic Day!',
      greetingHindi: 'गणतंत्र दिवस की शुभकामनाएं!',
    ),
    // Independence Day (August)
    FestivalTheme(
      id: 'independence_day',
      name: 'Independence Day',
      nameHindi: 'स्वतंत्रता दिवस',
      emoji: '🇮🇳',
      description: 'Indian Independence Day',
      colors: [0xFFFF9933, 0xFFFFFFFF, 0xFF138808],
      month: 8,
      dayStart: 13,
      dayEnd: 17,
      greeting: 'Happy Independence Day!',
      greetingHindi: 'स्वतंत्रता दिवस की शुभकामनाएं!',
    ),
    // Makar Sankranti (January)
    FestivalTheme(
      id: 'makar_sankranti',
      name: 'Makar Sankranti',
      nameHindi: 'मकर संक्रांति',
      emoji: '🪁',
      description: 'Kite Festival',
      colors: [0xFF2196F3, 0xFFFFEB3B, 0xFFFF5722],
      month: 1,
      dayStart: 12,
      dayEnd: 16,
      greeting: 'Happy Makar Sankranti!',
      greetingHindi: 'मकर संक्रांति की शुभकामनाएं!',
    ),
    // Eid (varies)
    FestivalTheme(
      id: 'eid',
      name: 'Eid',
      nameHindi: 'ईद',
      emoji: '🌙',
      description: 'Eid Celebration',
      colors: [0xFF4CAF50, 0xFFFFD700, 0xFF2196F3],
      month: 4, // Approximate for Eid ul-Fitr
      dayStart: 1,
      dayEnd: 15,
      greeting: 'Eid Mubarak!',
      greetingHindi: 'ईद मुबारक!',
    ),
  ];

  // Festival-specific lessons
  static final Map<String, List<FestivalLesson>> festivalLessonsData = {
    'diwali': [
      FestivalLesson(
        id: 'diwali_1',
        title: 'What is Diwali?',
        titleHindi: 'दीवाली क्या है?',
        content: 'Diwali is the festival of lights celebrated across India. People light diyas (oil lamps) and candles to symbolize the victory of light over darkness.',
        contentHindi: 'दीवाली रोशनी का त्योहार है जो पूरे भारत में मनाया जाता है। लोग दीये और मोमबत्तियाँ जलाते हैं।',
        emoji: '🪔',
        type: LessonType.story,
      ),
      FestivalLesson(
        id: 'diwali_2',
        title: 'Count the Diyas',
        titleHindi: 'दीये गिनो',
        content: 'Learn to count with colorful diyas! 1 diya, 2 diyas, 3 diyas...',
        contentHindi: 'रंगीन दीयों के साथ गिनती सीखो! 1 दीया, 2 दीये, 3 दीये...',
        emoji: '🔢',
        type: LessonType.counting,
        items: ['🪔', '🪔🪔', '🪔🪔🪔', '🪔🪔🪔🪔', '🪔🪔🪔🪔🪔'],
      ),
      FestivalLesson(
        id: 'diwali_3',
        title: 'Diwali Rangoli Colors',
        titleHindi: 'दीवाली रंगोली के रंग',
        content: 'Learn colors used in Rangoli: Red, Yellow, Orange, Green, Blue',
        contentHindi: 'रंगोली में इस्तेमाल होने वाले रंग सीखो: लाल, पीला, नारंगी, हरा, नीला',
        emoji: '🎨',
        type: LessonType.colors,
      ),
      FestivalLesson(
        id: 'diwali_4',
        title: 'Diwali Sweets',
        titleHindi: 'दीवाली की मिठाइयाँ',
        content: 'Learn about Diwali sweets: Ladoo, Barfi, Gulab Jamun, Jalebi',
        contentHindi: 'दीवाली की मिठाइयाँ: लड्डू, बर्फी, गुलाब जामुन, जलेबी',
        emoji: '🍬',
        type: LessonType.vocabulary,
      ),
    ],
    'holi': [
      FestivalLesson(
        id: 'holi_1',
        title: 'What is Holi?',
        titleHindi: 'होली क्या है?',
        content: 'Holi is the festival of colors! People throw colored powder (gulal) and water at each other.',
        contentHindi: 'होली रंगों का त्योहार है! लोग एक दूसरे पर रंग और पानी डालते हैं।',
        emoji: '🎨',
        type: LessonType.story,
      ),
      FestivalLesson(
        id: 'holi_2',
        title: 'Rainbow Colors',
        titleHindi: 'इंद्रधनुष के रंग',
        content: 'Learn all the colors of the rainbow! Red, Orange, Yellow, Green, Blue, Indigo, Violet',
        contentHindi: 'इंद्रधनुष के सभी रंग सीखो! लाल, नारंगी, पीला, हरा, नीला, जामुनी, बैंगनी',
        emoji: '🌈',
        type: LessonType.colors,
      ),
      FestivalLesson(
        id: 'holi_3',
        title: 'Color Mixing',
        titleHindi: 'रंग मिलाना',
        content: 'Red + Yellow = Orange, Blue + Yellow = Green, Red + Blue = Purple',
        contentHindi: 'लाल + पीला = नारंगी, नीला + पीला = हरा, लाल + नीला = बैंगनी',
        emoji: '🎭',
        type: LessonType.activity,
      ),
    ],
    'republic_day': [
      FestivalLesson(
        id: 'republic_1',
        title: 'Our Flag',
        titleHindi: 'हमारा झंडा',
        content: 'The Indian flag has three colors: Saffron (courage), White (peace), Green (prosperity). The Ashoka Chakra has 24 spokes.',
        contentHindi: 'भारतीय झंडे में तीन रंग हैं: केसरिया (साहस), सफेद (शांति), हरा (समृद्धि)। अशोक चक्र में 24 तीलियाँ हैं।',
        emoji: '🇮🇳',
        type: LessonType.story,
      ),
      FestivalLesson(
        id: 'republic_2',
        title: 'National Symbols',
        titleHindi: 'राष्ट्रीय प्रतीक',
        content: 'National Bird: Peacock 🦚, National Animal: Tiger 🐯, National Flower: Lotus 🪷',
        contentHindi: 'राष्ट्रीय पक्षी: मोर 🦚, राष्ट्रीय पशु: बाघ 🐯, राष्ट्रीय फूल: कमल 🪷',
        emoji: '🦚',
        type: LessonType.vocabulary,
      ),
    ],
    'independence_day': [
      FestivalLesson(
        id: 'independence_1',
        title: 'Freedom Story',
        titleHindi: 'आज़ादी की कहानी',
        content: 'On 15th August 1947, India became free! We celebrate this day every year with flag hoisting.',
        contentHindi: '15 अगस्त 1947 को भारत आज़ाद हुआ! हम हर साल इस दिन को झंडा फहराकर मनाते हैं।',
        emoji: '🎉',
        type: LessonType.story,
      ),
      FestivalLesson(
        id: 'independence_2',
        title: 'Freedom Fighters',
        titleHindi: 'स्वतंत्रता सेनानी',
        content: 'Learn about our freedom fighters: Mahatma Gandhi, Jawaharlal Nehru, Subhash Chandra Bose',
        contentHindi: 'स्वतंत्रता सेनानियों के बारे में जानो: महात्मा गांधी, जवाहरलाल नेहरू, सुभाष चंद्र बोस',
        emoji: '🌟',
        type: LessonType.vocabulary,
      ),
    ],
    'ganesh_chaturthi': [
      FestivalLesson(
        id: 'ganesh_1',
        title: 'Lord Ganesha',
        titleHindi: 'भगवान गणेश',
        content: 'Ganesha is the elephant-headed god of wisdom and new beginnings. He is worshipped before starting any new work.',
        contentHindi: 'गणेश जी हाथी के सिर वाले बुद्धि और शुभ आरंभ के देवता हैं।',
        emoji: '🐘',
        type: LessonType.story,
      ),
      FestivalLesson(
        id: 'ganesh_2',
        title: 'Count Modaks',
        titleHindi: 'मोदक गिनो',
        content: 'Modak is Lord Ganesha\'s favorite sweet! Count the modaks: 1, 2, 3, 4, 5...',
        contentHindi: 'मोदक गणेश जी की पसंदीदा मिठाई है! मोदक गिनो: 1, 2, 3, 4, 5...',
        emoji: '🥟',
        type: LessonType.counting,
      ),
    ],
    'christmas': [
      FestivalLesson(
        id: 'christmas_1',
        title: 'Christmas Story',
        titleHindi: 'क्रिसमस की कहानी',
        content: 'Christmas celebrates the birth of Jesus Christ. People decorate Christmas trees and exchange gifts.',
        contentHindi: 'क्रिसमस ईसा मसीह के जन्म का त्योहार है। लोग क्रिसमस ट्री सजाते हैं और उपहार देते हैं।',
        emoji: '🎄',
        type: LessonType.story,
      ),
      FestivalLesson(
        id: 'christmas_2',
        title: 'Count the Gifts',
        titleHindi: 'उपहार गिनो',
        content: 'Count Santa\'s gifts! 🎁🎁🎁🎁🎁',
        contentHindi: 'सांता के उपहार गिनो! 🎁🎁🎁🎁🎁',
        emoji: '🎁',
        type: LessonType.counting,
      ),
    ],
    'makar_sankranti': [
      FestivalLesson(
        id: 'sankranti_1',
        title: 'Kite Festival',
        titleHindi: 'पतंग उत्सव',
        content: 'Makar Sankranti is celebrated by flying colorful kites! The sky fills with kites of all colors.',
        contentHindi: 'मकर संक्रांति पर रंग-बिरंगी पतंगें उड़ाई जाती हैं! आसमान पतंगों से भर जाता है।',
        emoji: '🪁',
        type: LessonType.story,
      ),
      FestivalLesson(
        id: 'sankranti_2',
        title: 'Kite Colors',
        titleHindi: 'पतंग के रंग',
        content: 'Identify kite colors: Red kite, Blue kite, Yellow kite, Green kite',
        contentHindi: 'पतंगों के रंग पहचानो: लाल पतंग, नीली पतंग, पीली पतंग, हरी पतंग',
        emoji: '🎨',
        type: LessonType.colors,
      ),
    ],
  };

  Future<FestivalContentService> init() async {
    await _loadSettings();
    _checkCurrentFestival();
    return this;
  }

  Future<void> _loadSettings() async {
    festivalModeEnabled.value = _box.read<bool>('festival_mode_enabled') ?? true;
    final completed = _box.read<List>('completed_festival_lessons');
    if (completed != null) {
      completedFestivalLessons.value = completed.cast<String>();
    }
  }

  Future<void> setFestivalMode(bool enabled) async {
    festivalModeEnabled.value = enabled;
    await _box.write('festival_mode_enabled', enabled);
    if (enabled) {
      _checkCurrentFestival();
    } else {
      currentFestival.value = null;
      festivalLessons.clear();
    }
  }

  void _checkCurrentFestival() {
    if (!festivalModeEnabled.value) return;

    final now = DateTime.now();

    for (final festival in festivals) {
      if (_isFestivalActive(festival, now)) {
        currentFestival.value = festival;
        _loadFestivalLessons(festival.id);
        return;
      }
    }

    // No active festival
    currentFestival.value = null;
    festivalLessons.clear();
  }

  bool _isFestivalActive(FestivalTheme festival, DateTime date) {
    if (date.month != festival.month) return false;
    return date.day >= festival.dayStart && date.day <= festival.dayEnd;
  }

  void _loadFestivalLessons(String festivalId) {
    final lessons = festivalLessonsData[festivalId];
    if (lessons != null) {
      festivalLessons.value = lessons;
    } else {
      festivalLessons.clear();
    }
  }

  // Get festival for a specific date (for preview)
  FestivalTheme? getFestivalForDate(DateTime date) {
    for (final festival in festivals) {
      if (_isFestivalActive(festival, date)) {
        return festival;
      }
    }
    return null;
  }

  // Get upcoming festivals
  List<FestivalTheme> getUpcomingFestivals() {
    final now = DateTime.now();
    final upcoming = <FestivalTheme>[];

    for (final festival in festivals) {
      final festivalDate = DateTime(now.year, festival.month, festival.dayStart);

      // If festival is in the future this year or next year
      if (festivalDate.isAfter(now)) {
        upcoming.add(festival);
      }
    }

    // Sort by date
    upcoming.sort((a, b) => a.month.compareTo(b.month));
    return upcoming.take(5).toList();
  }

  // Mark lesson as completed
  Future<void> completeLesson(String lessonId) async {
    if (!completedFestivalLessons.contains(lessonId)) {
      completedFestivalLessons.add(lessonId);
      await _box.write('completed_festival_lessons', completedFestivalLessons.toList());
    }
  }

  // Check if lesson is completed
  bool isLessonCompleted(String lessonId) {
    return completedFestivalLessons.contains(lessonId);
  }

  // Get progress for current festival
  double get currentFestivalProgress {
    if (festivalLessons.isEmpty) return 0;

    int completed = 0;
    for (final lesson in festivalLessons) {
      if (completedFestivalLessons.contains(lesson.id)) {
        completed++;
      }
    }

    return completed / festivalLessons.length;
  }

  // Preview a specific festival (for festival calendar)
  void previewFestival(String festivalId) {
    final festival = festivals.firstWhereOrNull((f) => f.id == festivalId);
    if (festival != null) {
      currentFestival.value = festival;
      _loadFestivalLessons(festivalId);
    }
  }

  // Get all festivals grouped by month
  Map<int, List<FestivalTheme>> getFestivalCalendar() {
    final calendar = <int, List<FestivalTheme>>{};

    for (final festival in festivals) {
      calendar.putIfAbsent(festival.month, () => []);
      calendar[festival.month]!.add(festival);
    }

    return calendar;
  }
}

class FestivalTheme {
  final String id;
  final String name;
  final String nameHindi;
  final String emoji;
  final String description;
  final List<int> colors;
  final int month;
  final int dayStart;
  final int dayEnd;
  final String greeting;
  final String greetingHindi;

  FestivalTheme({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.emoji,
    required this.description,
    required this.colors,
    required this.month,
    required this.dayStart,
    required this.dayEnd,
    required this.greeting,
    required this.greetingHindi,
  });
}

class FestivalLesson {
  final String id;
  final String title;
  final String titleHindi;
  final String content;
  final String contentHindi;
  final String emoji;
  final LessonType type;
  final List<String>? items;

  FestivalLesson({
    required this.id,
    required this.title,
    required this.titleHindi,
    required this.content,
    required this.contentHindi,
    required this.emoji,
    required this.type,
    this.items,
  });
}

enum LessonType {
  story,
  counting,
  colors,
  vocabulary,
  activity,
  quiz,
}
