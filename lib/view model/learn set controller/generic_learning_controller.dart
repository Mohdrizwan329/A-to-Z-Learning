import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/progress_service.dart';

/// Configuration for a learning set category
class LearningSetConfig {
  final String title;
  final String emoji;
  final String progressKey;
  final String cacheKey;
  final List<Map<String, String>> items;

  const LearningSetConfig({
    required this.title,
    required this.emoji,
    required this.progressKey,
    required this.cacheKey,
    required this.items,
  });
}

/// All learning set configurations
class LearningSetData {
  static const List<Map<String, String>> animals = [
    {'name': 'Dog', 'emoji': '🐶'},
    {'name': 'Cat', 'emoji': '🐱'},
    {'name': 'Lion', 'emoji': '🦁'},
    {'name': 'Tiger', 'emoji': '🐯'},
    {'name': 'Elephant', 'emoji': '🐘'},
    {'name': 'Monkey', 'emoji': '🐵'},
    {'name': 'Cow', 'emoji': '🐄'},
    {'name': 'Horse', 'emoji': '🐴'},
    {'name': 'Goat', 'emoji': '🐐'},
    {'name': 'Sheep', 'emoji': '🐑'},
    {'name': 'Pig', 'emoji': '🐷'},
    {'name': 'Rabbit', 'emoji': '🐰'},
    {'name': 'Bear', 'emoji': '🐻'},
    {'name': 'Fox', 'emoji': '🦊'},
    {'name': 'Wolf', 'emoji': '🐺'},
    {'name': 'Kangaroo', 'emoji': '🦘'},
    {'name': 'Zebra', 'emoji': '🦓'},
    {'name': 'Giraffe', 'emoji': '🦒'},
    {'name': 'Panda', 'emoji': '🐼'},
    {'name': 'Camel', 'emoji': '🐫'},
    {'name': 'Deer', 'emoji': '🦌'},
    {'name': 'Crocodile', 'emoji': '🐊'},
    {'name': 'Hippopotamus', 'emoji': '🦛'},
    {'name': 'Rhinoceros', 'emoji': '🦏'},
    {'name': 'Bat', 'emoji': '🦇'},
    {'name': 'Squirrel', 'emoji': '🐿️'},
    {'name': 'Otter', 'emoji': '🦦'},
    {'name': 'Mouse', 'emoji': '🐭'},
    {'name': 'Frog', 'emoji': '🐸'},
    {'name': 'Duck', 'emoji': '🦆'},
  ];

  static const List<Map<String, String>> birds = [
    {'name': 'Parrot', 'emoji': '🦜'},
    {'name': 'Peacock', 'emoji': '🦚'},
    {'name': 'Sparrow', 'emoji': '🐦'},
    {'name': 'Crow', 'emoji': '🐦‍⬛'},
    {'name': 'Eagle', 'emoji': '🦅'},
    {'name': 'Owl', 'emoji': '🦉'},
    {'name': 'Penguin', 'emoji': '🐧'},
    {'name': 'Duck', 'emoji': '🦆'},
    {'name': 'Hen', 'emoji': '🐔'},
    {'name': 'Rooster', 'emoji': '🐓'},
    {'name': 'Pigeon', 'emoji': '🕊️'},
    {'name': 'Flamingo', 'emoji': '🦩'},
    {'name': 'Turkey', 'emoji': '🦃'},
    {'name': 'Swan', 'emoji': '🦢'},
    {'name': 'Woodpecker', 'emoji': '🪶'},
    {'name': 'Kingfisher', 'emoji': '🐦'},
    {'name': 'Hawk', 'emoji': '🦅'},
    {'name': 'Canary', 'emoji': '🐤'},
    {'name': 'Crane', 'emoji': '🦩'},
    {'name': 'Stork', 'emoji': '🦢'},
    {'name': 'Hummingbird', 'emoji': '🐦'},
    {'name': 'Quail', 'emoji': '🐔'},
    {'name': 'Magpie', 'emoji': '🐦‍⬛'},
    {'name': 'Robin', 'emoji': '🐦'},
    {'name': 'Seagull', 'emoji': '🕊️'},
    {'name': 'Lark', 'emoji': '🐦'},
    {'name': 'Cuckoo', 'emoji': '🐦'},
    {'name': 'Nightingale', 'emoji': '🐦'},
    {'name': 'Duckling', 'emoji': '🐥'},
    {'name': 'Chick', 'emoji': '🐤'},
  ];

  static const List<Map<String, String>> fruits = [
    {'name': 'Apple', 'emoji': '🍎'},
    {'name': 'Banana', 'emoji': '🍌'},
    {'name': 'Orange', 'emoji': '🍊'},
    {'name': 'Grapes', 'emoji': '🍇'},
    {'name': 'Strawberry', 'emoji': '🍓'},
    {'name': 'Watermelon', 'emoji': '🍉'},
    {'name': 'Mango', 'emoji': '🥭'},
    {'name': 'Pineapple', 'emoji': '🍍'},
    {'name': 'Cherry', 'emoji': '🍒'},
    {'name': 'Peach', 'emoji': '🍑'},
    {'name': 'Pear', 'emoji': '🍐'},
    {'name': 'Lemon', 'emoji': '🍋'},
    {'name': 'Coconut', 'emoji': '🥥'},
    {'name': 'Kiwi', 'emoji': '🥝'},
    {'name': 'Pomegranate', 'emoji': '🍎'},
    {'name': 'Papaya', 'emoji': '🥭'},
    {'name': 'Guava', 'emoji': '🍐'},
    {'name': 'Litchi', 'emoji': '🍒'},
    {'name': 'Jackfruit', 'emoji': '🍈'},
    {'name': 'Fig', 'emoji': '🫐'},
    {'name': 'Plum', 'emoji': '🫐'},
    {'name': 'Apricot', 'emoji': '🍑'},
    {'name': 'Blueberry', 'emoji': '🫐'},
    {'name': 'Raspberry', 'emoji': '🍓'},
    {'name': 'Blackberry', 'emoji': '🫐'},
    {'name': 'Mulberry', 'emoji': '🫐'},
    {'name': 'Melon', 'emoji': '🍈'},
    {'name': 'Custard Apple', 'emoji': '🍏'},
    {'name': 'Dragon Fruit', 'emoji': '🍈'},
    {'name': 'Passion Fruit', 'emoji': '🍈'},
  ];

  static const List<Map<String, String>> vegetables = [
    {'name': 'Carrot', 'emoji': '🥕'},
    {'name': 'Potato', 'emoji': '🥔'},
    {'name': 'Tomato', 'emoji': '🍅'},
    {'name': 'Onion', 'emoji': '🧅'},
    {'name': 'Garlic', 'emoji': '🧄'},
    {'name': 'Broccoli', 'emoji': '🥦'},
    {'name': 'Cucumber', 'emoji': '🥒'},
    {'name': 'Corn', 'emoji': '🌽'},
    {'name': 'Eggplant', 'emoji': '🍆'},
    {'name': 'Pepper', 'emoji': '🌶️'},
    {'name': 'Lettuce', 'emoji': '🥬'},
    {'name': 'Cabbage', 'emoji': '🥬'},
    {'name': 'Spinach', 'emoji': '🥬'},
    {'name': 'Pumpkin', 'emoji': '🎃'},
    {'name': 'Mushroom', 'emoji': '🍄'},
    {'name': 'Peas', 'emoji': '🫛'},
    {'name': 'Beans', 'emoji': '🫘'},
    {'name': 'Radish', 'emoji': '🥕'},
    {'name': 'Beetroot', 'emoji': '🥕'},
    {'name': 'Cauliflower', 'emoji': '🥦'},
    {'name': 'Ginger', 'emoji': '🫚'},
    {'name': 'Sweet Potato', 'emoji': '🍠'},
    {'name': 'Celery', 'emoji': '🥬'},
    {'name': 'Asparagus', 'emoji': '🥒'},
    {'name': 'Turnip', 'emoji': '🥕'},
    {'name': 'Zucchini', 'emoji': '🥒'},
    {'name': 'Artichoke', 'emoji': '🥬'},
    {'name': 'Okra', 'emoji': '🥒'},
    {'name': 'Leek', 'emoji': '🧅'},
  ];

  static const List<Map<String, String>> flowers = [
    {'name': 'Rose', 'emoji': '🌹'},
    {'name': 'Sunflower', 'emoji': '🌻'},
    {'name': 'Tulip', 'emoji': '🌷'},
    {'name': 'Lotus', 'emoji': '🪷'},
    {'name': 'Hibiscus', 'emoji': '🌺'},
    {'name': 'Cherry Blossom', 'emoji': '🌸'},
    {'name': 'Daisy', 'emoji': '🌼'},
    {'name': 'Lily', 'emoji': '💐'},
    {'name': 'Jasmine', 'emoji': '🌸'},
    {'name': 'Marigold', 'emoji': '🌼'},
    {'name': 'Orchid', 'emoji': '🌺'},
    {'name': 'Lavender', 'emoji': '💜'},
    {'name': 'Daffodil', 'emoji': '🌼'},
    {'name': 'Carnation', 'emoji': '🌸'},
    {'name': 'Iris', 'emoji': '💜'},
    {'name': 'Peony', 'emoji': '🌸'},
    {'name': 'Magnolia', 'emoji': '🌸'},
    {'name': 'Poppy', 'emoji': '🌺'},
    {'name': 'Chrysanthemum', 'emoji': '🌼'},
    {'name': 'Gardenia', 'emoji': '🌸'},
    {'name': 'Camellia', 'emoji': '🌺'},
    {'name': 'Dahlia', 'emoji': '🌸'},
    {'name': 'Violet', 'emoji': '💜'},
    {'name': 'Bluebell', 'emoji': '💙'},
    {'name': 'Pansy', 'emoji': '💜'},
    {'name': 'Petunia', 'emoji': '🌸'},
    {'name': 'Zinnia', 'emoji': '🌼'},
    {'name': 'Aster', 'emoji': '💜'},
    {'name': 'Begonia', 'emoji': '🌺'},
    {'name': 'Geranium', 'emoji': '🌸'},
  ];

  static const List<Map<String, String>> colors = [
    {'name': 'Red', 'emoji': '🔴'},
    {'name': 'Blue', 'emoji': '🔵'},
    {'name': 'Green', 'emoji': '🟢'},
    {'name': 'Yellow', 'emoji': '🟡'},
    {'name': 'Orange', 'emoji': '🟠'},
    {'name': 'Purple', 'emoji': '🟣'},
    {'name': 'Pink', 'emoji': '💗'},
    {'name': 'Brown', 'emoji': '🟤'},
    {'name': 'Black', 'emoji': '⚫'},
    {'name': 'White', 'emoji': '⚪'},
    {'name': 'Gray', 'emoji': '🩶'},
    {'name': 'Cyan', 'emoji': '🩵'},
    {'name': 'Magenta', 'emoji': '💜'},
    {'name': 'Lime', 'emoji': '💚'},
    {'name': 'Teal', 'emoji': '🩵'},
    {'name': 'Navy', 'emoji': '💙'},
    {'name': 'Maroon', 'emoji': '❤️'},
    {'name': 'Gold', 'emoji': '💛'},
    {'name': 'Silver', 'emoji': '🩶'},
    {'name': 'Violet', 'emoji': '💜'},
  ];

  static const List<Map<String, String>> bodyParts = [
    {'name': 'Head', 'emoji': '🗣️'},
    {'name': 'Hair', 'emoji': '💇'},
    {'name': 'Face', 'emoji': '😊'},
    {'name': 'Eye', 'emoji': '👁️'},
    {'name': 'Ear', 'emoji': '👂'},
    {'name': 'Nose', 'emoji': '👃'},
    {'name': 'Mouth', 'emoji': '👄'},
    {'name': 'Teeth', 'emoji': '🦷'},
    {'name': 'Tongue', 'emoji': '👅'},
    {'name': 'Lips', 'emoji': '💋'},
    {'name': 'Chin', 'emoji': '🧔'},
    {'name': 'Neck', 'emoji': '🦒'},
    {'name': 'Shoulder', 'emoji': '💪'},
    {'name': 'Arm', 'emoji': '💪'},
    {'name': 'Elbow', 'emoji': '💪'},
    {'name': 'Wrist', 'emoji': '⌚'},
    {'name': 'Hand', 'emoji': '🖐️'},
    {'name': 'Finger', 'emoji': '☝️'},
    {'name': 'Thumb', 'emoji': '👍'},
    {'name': 'Nail', 'emoji': '💅'},
    {'name': 'Chest', 'emoji': '🫁'},
    {'name': 'Back', 'emoji': '🔙'},
    {'name': 'Stomach', 'emoji': '🫃'},
    {'name': 'Waist', 'emoji': '👗'},
    {'name': 'Hip', 'emoji': '🦵'},
    {'name': 'Leg', 'emoji': '🦵'},
    {'name': 'Thigh', 'emoji': '🦵'},
    {'name': 'Knee', 'emoji': '🦵'},
    {'name': 'Ankle', 'emoji': '🦶'},
    {'name': 'Foot', 'emoji': '🦶'},
    {'name': 'Toe', 'emoji': '🦶'},
    {'name': 'Heel', 'emoji': '🦶'},
    {'name': 'Heart', 'emoji': '❤️'},
    {'name': 'Brain', 'emoji': '🧠'},
    {'name': 'Lungs', 'emoji': '🫁'},
    {'name': 'Bone', 'emoji': '🦴'},
    {'name': 'Skin', 'emoji': '🤚'},
  ];

  static const List<Map<String, String>> months = [
    {'name': 'January', 'emoji': '❄️'},
    {'name': 'February', 'emoji': '💝'},
    {'name': 'March', 'emoji': '🌸'},
    {'name': 'April', 'emoji': '🌷'},
    {'name': 'May', 'emoji': '🌺'},
    {'name': 'June', 'emoji': '☀️'},
    {'name': 'July', 'emoji': '🏖️'},
    {'name': 'August', 'emoji': '🌻'},
    {'name': 'September', 'emoji': '🍂'},
    {'name': 'October', 'emoji': '🎃'},
    {'name': 'November', 'emoji': '🍁'},
    {'name': 'December', 'emoji': '🎄'},
  ];

  static const List<Map<String, String>> weekDays = [
    {'name': 'Sunday', 'emoji': '☀️'},
    {'name': 'Monday', 'emoji': '🌙'},
    {'name': 'Tuesday', 'emoji': '🔥'},
    {'name': 'Wednesday', 'emoji': '💚'},
    {'name': 'Thursday', 'emoji': '⚡'},
    {'name': 'Friday', 'emoji': '💙'},
    {'name': 'Saturday', 'emoji': '💜'},
  ];

  static LearningSetConfig getConfig(String type) {
    switch (type) {
      case 'animals':
        return LearningSetConfig(
          title: 'Animals',
          emoji: '🦁',
          progressKey: ProgressService.kAnimals,
          cacheKey: 'selectedAnimalIndex',
          items: animals,
        );
      case 'birds':
        return LearningSetConfig(
          title: 'Birds',
          emoji: '🦜',
          progressKey: ProgressService.kBirds,
          cacheKey: 'selectedBirdIndex',
          items: birds,
        );
      case 'fruits':
        return LearningSetConfig(
          title: 'Fruits',
          emoji: '🍎',
          progressKey: ProgressService.kFruits,
          cacheKey: 'selectedFruitIndex',
          items: fruits,
        );
      case 'vegetables':
        return LearningSetConfig(
          title: 'Vegetables',
          emoji: '🥕',
          progressKey: ProgressService.kVegetables,
          cacheKey: 'selectedVegetableIndex',
          items: vegetables,
        );
      case 'flowers':
        return LearningSetConfig(
          title: 'Flowers',
          emoji: '🌸',
          progressKey: ProgressService.kFlowers,
          cacheKey: 'selectedFlowerIndex',
          items: flowers,
        );
      case 'colors':
        return LearningSetConfig(
          title: 'Colors',
          emoji: '🎨',
          progressKey: ProgressService.kColors,
          cacheKey: 'selectedColorIndex',
          items: colors,
        );
      case 'bodyparts':
        return LearningSetConfig(
          title: 'Body Parts',
          emoji: '🦴',
          progressKey: ProgressService.kBodyParts,
          cacheKey: 'selectedBodyPartIndex',
          items: bodyParts,
        );
      case 'months':
        return LearningSetConfig(
          title: 'Months',
          emoji: '📅',
          progressKey: ProgressService.kMonths,
          cacheKey: 'selectedMonthIndex',
          items: months,
        );
      case 'weekdays':
        return LearningSetConfig(
          title: 'Week Days',
          emoji: '📆',
          progressKey: ProgressService.kWeekDays,
          cacheKey: 'selectedWeekDayIndex',
          items: weekDays,
        );
      default:
        return LearningSetConfig(
          title: 'Animals',
          emoji: '🦁',
          progressKey: ProgressService.kAnimals,
          cacheKey: 'selectedAnimalIndex',
          items: animals,
        );
    }
  }
}

/// Generic Learning Controller that handles all learning set types
class GenericLearningController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final GetStorage box = GetStorage();
  final ProgressService _progressService = Get.find<ProgressService>();

  final String type;
  late final LearningSetConfig config;

  final RxnInt selectedIndex = RxnInt(null);

  // Local reactive set to track completed items for this category
  final RxSet<int> _completedItems = <int>{}.obs;

  GenericLearningController({required this.type}) {
    config = LearningSetData.getConfig(type);
  }

  List<Map<String, String>> get items => config.items;
  String get title => config.title;
  String get emoji => config.emoji;

  @override
  void onInit() {
    super.onInit();
    _loadSelection();
    _loadCompletedItems();
    _configureTTS();
  }

  void _loadCompletedItems() {
    final completed = _progressService.getCompletedItemsList(config.progressKey);
    _completedItems.addAll(completed);
  }

  Future<void> _configureTTS() async {
    try {
      await flutterTts.setLanguage("en-IN");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.awaitSpeakCompletion(false);
    } catch (e) {
      debugPrint("TTS configuration error: $e");
    }
  }

  void _loadSelection() {
    final savedIndex = box.read<int>(config.cacheKey);
    if (savedIndex != null && savedIndex >= 0 && savedIndex < items.length) {
      selectedIndex.value = savedIndex;
    }
  }

  Future<void> speak(String text) async {
    try {
      await flutterTts.stop();
      await flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS Error: $e");
    }
  }

  void selectItem(int index) {
    if (index < 0 || index >= items.length) return;
    if (selectedIndex.value == index) return;

    selectedIndex.value = index;
    box.write(config.cacheKey, index);
    final name = items[index]['name'];
    if (name != null) {
      speak(name);
    }
    _progressService.markItemCompleted(config.progressKey, index);
    // Update local reactive set for UI updates
    _completedItems.add(index);
  }

  // Use local reactive set for progress calculation
  double get progressPercentage {
    final total = items.length;
    if (total == 0) return 0;
    return (_completedItems.length / total) * 100;
  }

  String get progressString {
    final total = items.length;
    return '${_completedItems.length}/$total';
  }

  bool isItemCompleted(int index) => _completedItems.contains(index);

  int get completedCount => _completedItems.length;

  void resetSelection() {
    selectedIndex.value = null;
    box.remove(config.cacheKey);
    // Reset progress as well
    _progressService.resetProgress(config.progressKey);
    // Clear local reactive set
    _completedItems.clear();
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
