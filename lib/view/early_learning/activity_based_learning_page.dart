import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:math';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class ActivityBasedLearningPage extends StatefulWidget {
  const ActivityBasedLearningPage({super.key});

  @override
  State<ActivityBasedLearningPage> createState() =>
      _ActivityBasedLearningPageState();
}

class _ActivityBasedLearningPageState extends State<ActivityBasedLearningPage>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  final GetStorage _box = GetStorage();
  int _currentCategory = 0;
  int _totalPoints = 0;

  // Track visited items per category
  final Map<int, Set<int>> _visitedItems = {};

  final List<ActivityCategory> _categories = [
    ActivityCategory(
      name: 'Counting Fun',
      emoji: '🔢',
      activities: [
        LearningActivity(
          name: 'Count the Stars',
          emoji: '⭐',
          type: ActivityType.counting,
          data: {'count': 5, 'item': '⭐'},
        ),
        LearningActivity(
          name: 'Count the Apples',
          emoji: '🍎',
          type: ActivityType.counting,
          data: {'count': 7, 'item': '🍎'},
        ),
        LearningActivity(
          name: 'Count the Balloons',
          emoji: '🎈',
          type: ActivityType.counting,
          data: {'count': 4, 'item': '🎈'},
        ),
        LearningActivity(
          name: 'Count the Flowers',
          emoji: '🌸',
          type: ActivityType.counting,
          data: {'count': 6, 'item': '🌸'},
        ),
        LearningActivity(
          name: 'Count the Hearts',
          emoji: '❤️',
          type: ActivityType.counting,
          data: {'count': 8, 'item': '❤️'},
        ),
        LearningActivity(
          name: 'Count the Fish',
          emoji: '🐟',
          type: ActivityType.counting,
          data: {'count': 3, 'item': '🐟'},
        ),
        LearningActivity(
          name: 'Count the Bananas',
          emoji: '🍌',
          type: ActivityType.counting,
          data: {'count': 9, 'item': '🍌'},
        ),
        LearningActivity(
          name: 'Count the Butterflies',
          emoji: '🦋',
          type: ActivityType.counting,
          data: {'count': 5, 'item': '🦋'},
        ),
        LearningActivity(
          name: 'Count the Cookies',
          emoji: '🍪',
          type: ActivityType.counting,
          data: {'count': 10, 'item': '🍪'},
        ),
        LearningActivity(
          name: 'Count the Cars',
          emoji: '🚗',
          type: ActivityType.counting,
          data: {'count': 4, 'item': '🚗'},
        ),
        LearningActivity(
          name: 'Count the Birds',
          emoji: '🐦',
          type: ActivityType.counting,
          data: {'count': 7, 'item': '🐦'},
        ),
        LearningActivity(
          name: 'Count the Dogs',
          emoji: '🐕',
          type: ActivityType.counting,
          data: {'count': 6, 'item': '🐕'},
        ),
        LearningActivity(
          name: 'Count the Cats',
          emoji: '🐱',
          type: ActivityType.counting,
          data: {'count': 8, 'item': '🐱'},
        ),
        LearningActivity(
          name: 'Count the Trees',
          emoji: '🌲',
          type: ActivityType.counting,
          data: {'count': 5, 'item': '🌲'},
        ),
        LearningActivity(
          name: 'Count the Suns',
          emoji: '☀️',
          type: ActivityType.counting,
          data: {'count': 3, 'item': '☀️'},
        ),
        LearningActivity(
          name: 'Count the Moons',
          emoji: '🌙',
          type: ActivityType.counting,
          data: {'count': 4, 'item': '🌙'},
        ),
        LearningActivity(
          name: 'Count the Rainbows',
          emoji: '🌈',
          type: ActivityType.counting,
          data: {'count': 6, 'item': '🌈'},
        ),
        LearningActivity(
          name: 'Count the Grapes',
          emoji: '🍇',
          type: ActivityType.counting,
          data: {'count': 9, 'item': '🍇'},
        ),
        LearningActivity(
          name: 'Count the Rockets',
          emoji: '🚀',
          type: ActivityType.counting,
          data: {'count': 5, 'item': '🚀'},
        ),
        LearningActivity(
          name: 'Count the Diamonds',
          emoji: '💎',
          type: ActivityType.counting,
          data: {'count': 7, 'item': '💎'},
        ),
      ],
    ),
    ActivityCategory(
      name: 'Matching',
      emoji: '🔗',
      activities: [
        LearningActivity(
          name: 'Match Animals',
          emoji: '🐕',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '🐕', 'name': 'Dog'},
              {'emoji': '🐱', 'name': 'Cat'},
              {'emoji': '🐘', 'name': 'Elephant'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Colors',
          emoji: '🎨',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '🔴', 'name': 'Red'},
              {'emoji': '🔵', 'name': 'Blue'},
              {'emoji': '🟢', 'name': 'Green'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Fruits',
          emoji: '🍎',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '🍎', 'name': 'Apple'},
              {'emoji': '🍌', 'name': 'Banana'},
              {'emoji': '🍇', 'name': 'Grapes'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Shapes',
          emoji: '🔷',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '⭐', 'name': 'Star'},
              {'emoji': '❤️', 'name': 'Heart'},
              {'emoji': '🔷', 'name': 'Diamond'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Numbers',
          emoji: '🔢',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '1️⃣', 'name': 'One'},
              {'emoji': '2️⃣', 'name': 'Two'},
              {'emoji': '3️⃣', 'name': 'Three'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Vehicles',
          emoji: '🚗',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '🚗', 'name': 'Car'},
              {'emoji': '🚌', 'name': 'Bus'},
              {'emoji': '✈️', 'name': 'Plane'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Birds',
          emoji: '🐦',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '🐦', 'name': 'Bird'},
              {'emoji': '🦅', 'name': 'Eagle'},
              {'emoji': '🦉', 'name': 'Owl'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Flowers',
          emoji: '🌸',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '🌸', 'name': 'Blossom'},
              {'emoji': '🌹', 'name': 'Rose'},
              {'emoji': '🌻', 'name': 'Sunflower'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Food',
          emoji: '🍕',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '🍕', 'name': 'Pizza'},
              {'emoji': '🍔', 'name': 'Burger'},
              {'emoji': '🍟', 'name': 'Fries'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Weather',
          emoji: '☀️',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '☀️', 'name': 'Sun'},
              {'emoji': '🌧️', 'name': 'Rain'},
              {'emoji': '❄️', 'name': 'Snow'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Sports',
          emoji: '⚽',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '⚽', 'name': 'Soccer'},
              {'emoji': '🏀', 'name': 'Basketball'},
              {'emoji': '🎾', 'name': 'Tennis'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Insects',
          emoji: '🦋',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '🦋', 'name': 'Butterfly'},
              {'emoji': '🐝', 'name': 'Bee'},
              {'emoji': '🐞', 'name': 'Ladybug'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Ocean',
          emoji: '🐟',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '🐟', 'name': 'Fish'},
              {'emoji': '🐙', 'name': 'Octopus'},
              {'emoji': '🦀', 'name': 'Crab'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Music',
          emoji: '🎸',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '🎸', 'name': 'Guitar'},
              {'emoji': '🎹', 'name': 'Piano'},
              {'emoji': '🥁', 'name': 'Drums'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Space',
          emoji: '🌙',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '🌙', 'name': 'Moon'},
              {'emoji': '⭐', 'name': 'Star'},
              {'emoji': '🚀', 'name': 'Rocket'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Vegetables',
          emoji: '🥕',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '🥕', 'name': 'Carrot'},
              {'emoji': '🥦', 'name': 'Broccoli'},
              {'emoji': '🌽', 'name': 'Corn'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Desserts',
          emoji: '🍰',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '🍰', 'name': 'Cake'},
              {'emoji': '🍦', 'name': 'Ice Cream'},
              {'emoji': '🍩', 'name': 'Donut'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Clothes',
          emoji: '👕',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '👕', 'name': 'Shirt'},
              {'emoji': '👖', 'name': 'Pants'},
              {'emoji': '👟', 'name': 'Shoes'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Tools',
          emoji: '🔨',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '🔨', 'name': 'Hammer'},
              {'emoji': '🔧', 'name': 'Wrench'},
              {'emoji': '✂️', 'name': 'Scissors'},
            ],
          },
        ),
        LearningActivity(
          name: 'Match Emotions',
          emoji: '😊',
          type: ActivityType.matching,
          data: {
            'pairs': [
              {'emoji': '😊', 'name': 'Happy'},
              {'emoji': '😢', 'name': 'Sad'},
              {'emoji': '😡', 'name': 'Angry'},
            ],
          },
        ),
      ],
    ),
    ActivityCategory(
      name: 'Patterns',
      emoji: '🧩',
      activities: [
        LearningActivity(
          name: 'Red Blue Pattern',
          emoji: '🔴',
          type: ActivityType.pattern,
          data: {
            'pattern': ['🔴', '🔵', '🔴', '🔵'],
            'next': '🔴',
          },
        ),
        LearningActivity(
          name: 'Emoji Pattern',
          emoji: '😊',
          type: ActivityType.pattern,
          data: {
            'pattern': ['😊', '😢', '😊', '😢'],
            'next': '😊',
          },
        ),
        LearningActivity(
          name: 'Shape Pattern',
          emoji: '⭐',
          type: ActivityType.pattern,
          data: {
            'pattern': ['⭐', '❤️', '⭐', '❤️'],
            'next': '⭐',
          },
        ),
        LearningActivity(
          name: 'Animal Pattern',
          emoji: '🐕',
          type: ActivityType.pattern,
          data: {
            'pattern': ['🐕', '🐱', '🐕', '🐱'],
            'next': '🐕',
          },
        ),
        LearningActivity(
          name: 'Fruit Pattern',
          emoji: '🍎',
          type: ActivityType.pattern,
          data: {
            'pattern': ['🍎', '🍌', '🍎', '🍌'],
            'next': '🍎',
          },
        ),
        LearningActivity(
          name: 'Triple Pattern',
          emoji: '🔵',
          type: ActivityType.pattern,
          data: {
            'pattern': ['🔴', '🔵', '🟢', '🔴', '🔵'],
            'next': '🟢',
          },
        ),
        LearningActivity(
          name: 'Flower Pattern',
          emoji: '🌸',
          type: ActivityType.pattern,
          data: {
            'pattern': ['🌸', '🌺', '🌸', '🌺'],
            'next': '🌸',
          },
        ),
        LearningActivity(
          name: 'Weather Pattern',
          emoji: '☀️',
          type: ActivityType.pattern,
          data: {
            'pattern': ['☀️', '🌧️', '☀️', '🌧️'],
            'next': '☀️',
          },
        ),
        LearningActivity(
          name: 'Vehicle Pattern',
          emoji: '🚗',
          type: ActivityType.pattern,
          data: {
            'pattern': ['🚗', '🚌', '🚗', '🚌'],
            'next': '🚗',
          },
        ),
        LearningActivity(
          name: 'Sport Pattern',
          emoji: '⚽',
          type: ActivityType.pattern,
          data: {
            'pattern': ['⚽', '🏀', '⚽', '🏀'],
            'next': '⚽',
          },
        ),
        LearningActivity(
          name: 'Food Pattern',
          emoji: '🍕',
          type: ActivityType.pattern,
          data: {
            'pattern': ['🍕', '🍔', '🍕', '🍔'],
            'next': '🍕',
          },
        ),
        LearningActivity(
          name: 'Bird Pattern',
          emoji: '🐦',
          type: ActivityType.pattern,
          data: {
            'pattern': ['🐦', '🦅', '🐦', '🦅'],
            'next': '🐦',
          },
        ),
        LearningActivity(
          name: 'Ocean Pattern',
          emoji: '🐟',
          type: ActivityType.pattern,
          data: {
            'pattern': ['🐟', '🐙', '🐟', '🐙'],
            'next': '🐟',
          },
        ),
        LearningActivity(
          name: 'Number Pattern',
          emoji: '1️⃣',
          type: ActivityType.pattern,
          data: {
            'pattern': ['1️⃣', '2️⃣', '1️⃣', '2️⃣'],
            'next': '1️⃣',
          },
        ),
        LearningActivity(
          name: 'Triple Color Pattern',
          emoji: '🟡',
          type: ActivityType.pattern,
          data: {
            'pattern': ['🔴', '🟡', '🔵', '🔴', '🟡'],
            'next': '🔵',
          },
        ),
        LearningActivity(
          name: 'Heart Pattern',
          emoji: '❤️',
          type: ActivityType.pattern,
          data: {
            'pattern': ['❤️', '💙', '❤️', '💙'],
            'next': '❤️',
          },
        ),
        LearningActivity(
          name: 'Tree Pattern',
          emoji: '🌲',
          type: ActivityType.pattern,
          data: {
            'pattern': ['🌲', '🌳', '🌲', '🌳'],
            'next': '🌲',
          },
        ),
        LearningActivity(
          name: 'Insect Pattern',
          emoji: '🦋',
          type: ActivityType.pattern,
          data: {
            'pattern': ['🦋', '🐝', '🦋', '🐝'],
            'next': '🦋',
          },
        ),
        LearningActivity(
          name: 'Music Pattern',
          emoji: '🎵',
          type: ActivityType.pattern,
          data: {
            'pattern': ['🎵', '🎶', '🎵', '🎶'],
            'next': '🎵',
          },
        ),
        LearningActivity(
          name: 'Space Pattern',
          emoji: '🌙',
          type: ActivityType.pattern,
          data: {
            'pattern': ['🌙', '⭐', '🌙', '⭐'],
            'next': '🌙',
          },
        ),
      ],
    ),
    ActivityCategory(
      name: 'Sorting',
      emoji: '📦',
      activities: [
        LearningActivity(
          name: 'Sort by Size',
          emoji: '📏',
          type: ActivityType.sorting,
          data: {
            'items': ['🐘', '🐕', '🐁'],
            'order': 'big to small',
          },
        ),
        LearningActivity(
          name: 'Sort by Color',
          emoji: '🌈',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Red': ['🍎', '🍓'],
              'Yellow': ['🍌', '🌟'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Numbers',
          emoji: '🔢',
          type: ActivityType.sorting,
          data: {
            'items': ['3', '1', '2'],
            'order': 'small to big',
          },
        ),
        LearningActivity(
          name: 'Sort Animals',
          emoji: '🐕',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Farm': ['🐄', '🐷'],
              'Wild': ['🦁', '🐘'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Shapes',
          emoji: '⬛',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Round': ['⚪', '🔴'],
              'Square': ['⬛', '🟥'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Food',
          emoji: '🍎',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Fruits': ['🍎', '🍌'],
              'Vegetables': ['🥕', '🥦'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Birds',
          emoji: '🐦',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Flying': ['🦅', '🐦'],
              'Swimming': ['🦢', '🦆'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Vehicles',
          emoji: '🚗',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Land': ['🚗', '🚌'],
              'Air': ['✈️', '🚁'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Weather',
          emoji: '☀️',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Hot': ['☀️', '🔥'],
              'Cold': ['❄️', '🌨️'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Sports',
          emoji: '⚽',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Ball': ['⚽', '🏀'],
              'Racket': ['🎾', '🏸'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Insects',
          emoji: '🦋',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Flying': ['🦋', '🐝'],
              'Crawling': ['🐞', '🐜'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Ocean',
          emoji: '🐟',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Fish': ['🐟', '🐠'],
              'Shell': ['🦀', '🦐'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Music',
          emoji: '🎸',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'String': ['🎸', '🎻'],
              'Percussion': ['🥁', '🎹'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Flowers',
          emoji: '🌸',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Pink': ['🌸', '🌺'],
              'Yellow': ['🌻', '🌼'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Desserts',
          emoji: '🍰',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Cake': ['🍰', '🎂'],
              'Frozen': ['🍦', '🍨'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Trees',
          emoji: '🌲',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Green': ['🌲', '🌳'],
              'Palm': ['🌴', '🎄'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Drinks',
          emoji: '🥤',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Hot': ['☕', '🍵'],
              'Cold': ['🥤', '🧃'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Tools',
          emoji: '🔨',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Building': ['🔨', '🔧'],
              'Cutting': ['✂️', '🔪'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Emotions',
          emoji: '😊',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Happy': ['😊', '😁'],
              'Sad': ['😢', '😭'],
            },
          },
        ),
        LearningActivity(
          name: 'Sort Space',
          emoji: '🌙',
          type: ActivityType.sorting,
          data: {
            'groups': {
              'Natural': ['🌙', '⭐'],
              'Man-made': ['🚀', '🛸'],
            },
          },
        ),
      ],
    ),
    ActivityCategory(
      name: 'Creative',
      emoji: '🎨',
      activities: [
        LearningActivity(
          name: 'Color by Number',
          emoji: '🖌️',
          type: ActivityType.coloring,
          data: {
            'colors': ['Red', 'Blue', 'Green'],
          },
        ),
        LearningActivity(
          name: 'Build a Story',
          emoji: '📖',
          type: ActivityType.story,
          data: {
            'cards': ['🏠', '🐕', '🌳', '☀️'],
          },
        ),
        LearningActivity(
          name: 'Draw a Face',
          emoji: '😊',
          type: ActivityType.coloring,
          data: {
            'parts': ['👀', '👃', '👄'],
          },
        ),
        LearningActivity(
          name: 'Make a Scene',
          emoji: '🌅',
          type: ActivityType.story,
          data: {
            'cards': ['⛰️', '🌊', '🌴', '🐦'],
          },
        ),
        LearningActivity(
          name: 'Create Pattern',
          emoji: '🎨',
          type: ActivityType.coloring,
          data: {
            'colors': ['Yellow', 'Orange', 'Pink'],
          },
        ),
        LearningActivity(
          name: 'Story Time',
          emoji: '📚',
          type: ActivityType.story,
          data: {
            'cards': ['🐰', '🥕', '🏡', '🌈'],
          },
        ),
        LearningActivity(
          name: 'Rainbow Colors',
          emoji: '🌈',
          type: ActivityType.coloring,
          data: {
            'colors': ['Red', 'Orange', 'Yellow', 'Green', 'Blue', 'Purple'],
          },
        ),
        LearningActivity(
          name: 'Space Adventure',
          emoji: '🚀',
          type: ActivityType.story,
          data: {
            'cards': ['🚀', '🌙', '⭐', '👨‍🚀'],
          },
        ),
        LearningActivity(
          name: 'Draw Animals',
          emoji: '🐕',
          type: ActivityType.coloring,
          data: {
            'parts': ['🐕', '🐱', '🐰'],
          },
        ),
        LearningActivity(
          name: 'Ocean Story',
          emoji: '🌊',
          type: ActivityType.story,
          data: {
            'cards': ['🌊', '🐟', '🦀', '🐚'],
          },
        ),
        LearningActivity(
          name: 'Fruit Colors',
          emoji: '🍎',
          type: ActivityType.coloring,
          data: {
            'colors': ['Red', 'Yellow', 'Orange', 'Green'],
          },
        ),
        LearningActivity(
          name: 'Forest Tale',
          emoji: '🌲',
          type: ActivityType.story,
          data: {
            'cards': ['🌲', '🦊', '🍄', '🌸'],
          },
        ),
        LearningActivity(
          name: 'Draw Shapes',
          emoji: '⭐',
          type: ActivityType.coloring,
          data: {
            'parts': ['⭐', '❤️', '🔷'],
          },
        ),
        LearningActivity(
          name: 'Farm Story',
          emoji: '🐄',
          type: ActivityType.story,
          data: {
            'cards': ['🏠', '🐄', '🐷', '🌾'],
          },
        ),
        LearningActivity(
          name: 'Nature Colors',
          emoji: '🌻',
          type: ActivityType.coloring,
          data: {
            'colors': ['Green', 'Brown', 'Yellow', 'Blue'],
          },
        ),
        LearningActivity(
          name: 'Jungle Adventure',
          emoji: '🦁',
          type: ActivityType.story,
          data: {
            'cards': ['🦁', '🐘', '🌴', '🦋'],
          },
        ),
        LearningActivity(
          name: 'Draw Food',
          emoji: '🍕',
          type: ActivityType.coloring,
          data: {
            'parts': ['🍕', '🍔', '🍟'],
          },
        ),
        LearningActivity(
          name: 'Weather Story',
          emoji: '☀️',
          type: ActivityType.story,
          data: {
            'cards': ['☀️', '🌧️', '🌈', '☁️'],
          },
        ),
        LearningActivity(
          name: 'Vehicle Colors',
          emoji: '🚗',
          type: ActivityType.coloring,
          data: {
            'colors': ['Red', 'Blue', 'Yellow', 'Green'],
          },
        ),
        LearningActivity(
          name: 'Garden Story',
          emoji: '🌷',
          type: ActivityType.story,
          data: {
            'cards': ['🌷', '🐝', '🦋', '🌻'],
          },
        ),
      ],
    ),
  ];

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadProgress();
    _loadPoints();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentCategory = _tabController.index);
        _speak(_categories[_tabController.index].name);
      }
    });
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  void _loadProgress() {
    for (int i = 0; i < _categories.length; i++) {
      final saved = _box.read<List>('activity_progress_$i');
      if (saved != null) {
        _visitedItems[i] = saved.map((e) => e as int).toSet();
      } else {
        _visitedItems[i] = {};
      }
    }
  }

  void _loadPoints() {
    _totalPoints = _box.read<int>('activity_total_points') ?? 0;
  }

  void _savePoints() {
    _box.write('activity_total_points', _totalPoints);
  }

  void _markItemVisited(int categoryIndex, int itemIndex) {
    _visitedItems[categoryIndex] ??= {};
    if (!_visitedItems[categoryIndex]!.contains(itemIndex)) {
      setState(() {
        _visitedItems[categoryIndex]!.add(itemIndex);
      });
      _box.write(
        'activity_progress_$categoryIndex',
        _visitedItems[categoryIndex]!.toList(),
      );
    }
  }

  int get _totalItems {
    int total = 0;
    for (var cat in _categories) {
      total += cat.activities.length;
    }
    return total;
  }

  int get _completedItems {
    int completed = 0;
    for (var entry in _visitedItems.entries) {
      completed += entry.value.length;
    }
    return completed;
  }

  double get _progressPercentage {
    if (_totalItems == 0) return 0;
    return _completedItems / _totalItems;
  }

  String get _progressString => '$_completedItems/$_totalItems';

  void _resetProgress() {
    setState(() {
      for (int i = 0; i < _categories.length; i++) {
        _visitedItems[i] = {};
        _box.remove('activity_progress_$i');
      }
      _totalPoints = 0;
      _box.remove('activity_total_points');
    });
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.4);
    await _tts.setPitch(1.2);
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
  }

  void _startActivity(LearningActivity activity, int index) {
    HapticFeedback.mediumImpact();
    _markItemVisited(_currentCategory, index);

    switch (activity.type) {
      case ActivityType.counting:
        _showCountingActivity(activity);
        break;
      case ActivityType.matching:
        _showMatchingActivity(activity);
        break;
      case ActivityType.pattern:
        _showPatternActivity(activity);
        break;
      default:
        _showGenericActivity(activity);
    }
  }

  void _showCountingActivity(LearningActivity activity) {
    final count = activity.data['count'] as int;
    final item = activity.data['item'] as String;
    int tappedCount = 0;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Count to $count',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$tappedCount / $count',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: List.generate(count, (index) {
                      final isTapped = index < tappedCount;
                      return GestureDetector(
                        onTap: !isTapped
                            ? () {
                                HapticFeedback.lightImpact();
                                setDialogState(() => tappedCount++);
                                if (tappedCount == count) {
                                  Future.delayed(
                                    const Duration(milliseconds: 500),
                                    () {
                                      setState(() => _totalPoints += 10);
                                      _savePoints();
                                      Get.back();
                                    },
                                  );
                                }
                              }
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isTapped
                                  ? [
                                      const Color(0xFF4CAF50),
                                      const Color(0xFF66BB6A),
                                    ]
                                  : [
                                      Colors.white.withValues(alpha: 0.3),
                                      Colors.white.withValues(alpha: 0.1),
                                    ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              item,
                              style: TextStyle(fontSize: isTapped ? 28 : 22),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  if (tappedCount == count)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🎉', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8),
                          Text(
                            'Great! +10 points',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      barrierDismissible: false,
    );
  }

  void _showMatchingActivity(LearningActivity activity) {
    final pairs = (activity.data['pairs'] as List).cast<Map<String, String>>();
    int? selectedEmojiIndex;
    Set<int> matched = {};
    List<String> shuffledNames = pairs.map((p) => p['name']!).toList()
      ..shuffle();

    Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Match the pairs!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap emoji, then tap its name!',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 20),

                  // Emojis row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(pairs.length, (index) {
                      final isMatched = matched.contains(index);
                      final isSelected = selectedEmojiIndex == index;
                      return GestureDetector(
                        onTap: isMatched
                            ? null
                            : () {
                                HapticFeedback.lightImpact();
                                setDialogState(
                                  () => selectedEmojiIndex = index,
                                );
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isMatched
                                  ? [
                                      const Color(0xFF4CAF50),
                                      const Color(0xFF66BB6A),
                                    ]
                                  : (isSelected
                                        ? [
                                            const Color(0xFFFF6B6B),
                                            const Color(0xFFFF8E53),
                                          ]
                                        : [
                                            Colors.white.withValues(alpha: 0.2),
                                            Colors.white.withValues(alpha: 0.1),
                                          ]),
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              pairs[index]['emoji']!,
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  // Names
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: shuffledNames.map((name) {
                      final isMatched = pairs.any(
                        (p) =>
                            p['name'] == name &&
                            matched.contains(pairs.indexOf(p)),
                      );
                      return GestureDetector(
                        onTap: isMatched || selectedEmojiIndex == null
                            ? null
                            : () {
                                final selectedPair = pairs[selectedEmojiIndex!];
                                if (selectedPair['name'] == name) {
                                  HapticFeedback.mediumImpact();
                                  setDialogState(() {
                                    matched.add(selectedEmojiIndex!);
                                    selectedEmojiIndex = null;
                                  });

                                  if (matched.length == pairs.length) {
                                    Future.delayed(
                                      const Duration(milliseconds: 500),
                                      () {
                                        setState(() => _totalPoints += 15);
                                        _savePoints();
                                        Get.back();
                                      },
                                    );
                                  }
                                } else {
                                  setDialogState(
                                    () => selectedEmojiIndex = null,
                                  );
                                }
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isMatched
                                  ? [
                                      const Color(0xFF4CAF50),
                                      const Color(0xFF66BB6A),
                                    ]
                                  : [
                                      const Color(0xFFFF6B6B),
                                      const Color(0xFFFF8E53),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  if (matched.length == pairs.length)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🎉', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8),
                          Text(
                            'Perfect! +15 points',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      barrierDismissible: false,
    );
  }

  void _showPatternActivity(LearningActivity activity) {
    final pattern = (activity.data['pattern'] as List).cast<String>();
    final correctAnswer = activity.data['next'] as String;
    String? selectedAnswer;
    List<String> options = [correctAnswer, '🟢', '🟡']..shuffle();

    Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          final isCorrect = selectedAnswer == correctAnswer;
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Complete the Pattern',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'What comes next?',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 24),

                  // Pattern display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...pattern.map(
                        (p) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(p, style: const TextStyle(fontSize: 32)),
                        ),
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        margin: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            selectedAnswer ?? '?',
                            style: TextStyle(
                              fontSize: selectedAnswer != null ? 28 : 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: options.map((option) {
                      return GestureDetector(
                        onTap: selectedAnswer == null
                            ? () {
                                HapticFeedback.mediumImpact();
                                setDialogState(() => selectedAnswer = option);

                                if (option == correctAnswer) {
                                  Future.delayed(
                                    const Duration(milliseconds: 500),
                                    () {
                                      setState(() => _totalPoints += 10);
                                      _savePoints();
                                      Get.back();
                                    },
                                  );
                                }
                              }
                            : null,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Center(
                            child: Text(
                              option,
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  if (selectedAnswer != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCorrect ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isCorrect ? '🎉' : '😢',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isCorrect ? 'Correct! +10 points' : 'Try again!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),

                  // Retry button for wrong answer
                  if (selectedAnswer != null && !isCorrect) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        setDialogState(() => selectedAnswer = null);
                      },
                      child: const Text(
                        'Try Again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      barrierDismissible: false,
    );
  }

  void _showGenericActivity(LearningActivity activity) {
    _speak(activity.name);
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    activity.emoji,
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                activity.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Coming Soon!',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 20),
              _buildGradientButton(
                icon: Icons.check,
                label: 'OK',
                gradient: const [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _floatController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = _categories[_currentCategory];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 8,
        shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Activity Learning',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.refresh, color: Colors.white, size: 20),
            ),
            onPressed: _resetProgress,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabAlignment: TabAlignment.start,
          tabs: _categories.map((cat) {
            return Tab(
              child: Text(
                cat.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$_progressString completed',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _progressPercentage,
                        minHeight: 10,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Activities grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: category.activities.length,
                  itemBuilder: (context, index) {
                    final activity = category.activities[index];
                    final gradients = [
                      [const Color(0xFFFF6B6B), const Color(0xFFFF8E8E)],
                      [const Color(0xFF45B7D1), const Color(0xFF74C9DB)],
                      [const Color(0xFFA78BFA), const Color(0xFFC4B5FD)],
                      [const Color(0xFF56D97F), const Color(0xFF81E89E)],
                      [const Color(0xFFFF6EB4), const Color(0xFFFF9ECE)],
                      [const Color(0xFF4ECDC4), const Color(0xFF7EDDD6)],
                    ];
                    final gradient = gradients[index % gradients.length];

                    return AnimatedBuilder(
                      animation: _floatController,
                      builder: (_, child) {
                        final offset = (index % 2 == 0)
                            ? _floatAnimation.value
                            : -_floatAnimation.value;
                        return Transform.translate(
                          offset: Offset(0, offset),
                          child: child,
                        );
                      },
                      child: GestureDetector(
                        onTap: () => _startActivity(activity, index),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: gradient[0].withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -20,
                                right: -20,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 75,
                                        height: 75,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            activity.emoji,
                                            style: const TextStyle(
                                              fontSize: 42,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        activity.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1.1,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Checkmark badge when visited
                              if (_visitedItems[_currentCategory]?.contains(
                                    index,
                                  ) ==
                                  true)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: gradient[0],
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }
}

// Counting Activity Screen
class _CountingActivityScreen extends StatefulWidget {
  final int count;
  final String item;
  final Function(int) onComplete;

  const _CountingActivityScreen({
    required this.count,
    required this.item,
    required this.onComplete,
  });

  @override
  State<_CountingActivityScreen> createState() =>
      _CountingActivityScreenState();
}

class _CountingActivityScreenState extends State<_CountingActivityScreen> {
  int _tappedCount = 0;

  void _onItemTap() {
    if (_tappedCount < widget.count) {
      HapticFeedback.lightImpact();
      setState(() => _tappedCount++);

      if (_tappedCount == widget.count) {
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.onComplete(10);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Count to ${widget.count}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Text(
                '$_tappedCount / ${widget.count}',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: List.generate(widget.count, (index) {
                      final isTapped = index < _tappedCount;
                      return GestureDetector(
                        onTap: !isTapped ? _onItemTap : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isTapped
                                  ? [
                                      const Color(0xFF4CAF50),
                                      const Color(0xFF66BB6A),
                                    ]
                                  : [
                                      Colors.white.withValues(alpha: 0.3),
                                      Colors.white.withValues(alpha: 0.1),
                                    ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.item,
                              style: TextStyle(fontSize: isTapped ? 36 : 28),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              if (_tappedCount == widget.count)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🎉', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 12),
                        Text(
                          'Great Job! +10 points',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Matching Activity Screen
class _MatchingActivityScreen extends StatefulWidget {
  final List<Map<String, String>> pairs;
  final Function(int) onComplete;

  const _MatchingActivityScreen({
    required this.pairs,
    required this.onComplete,
  });

  @override
  State<_MatchingActivityScreen> createState() =>
      _MatchingActivityScreenState();
}

class _MatchingActivityScreenState extends State<_MatchingActivityScreen> {
  int? _selectedEmojiIndex;
  final Set<int> _matched = {};
  final Random _random = Random();
  late List<String> _shuffledNames;

  @override
  void initState() {
    super.initState();
    _shuffledNames = widget.pairs.map((p) => p['name']!).toList()
      ..shuffle(_random);
  }

  void _onEmojiTap(int index) {
    if (_matched.contains(index)) return;
    HapticFeedback.lightImpact();
    setState(() => _selectedEmojiIndex = index);
  }

  void _onNameTap(String name) {
    if (_selectedEmojiIndex == null) return;

    final selectedPair = widget.pairs[_selectedEmojiIndex!];
    if (selectedPair['name'] == name) {
      HapticFeedback.mediumImpact();
      setState(() {
        _matched.add(_selectedEmojiIndex!);
        _selectedEmojiIndex = null;
      });

      if (_matched.length == widget.pairs.length) {
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.onComplete(15);
        });
      }
    } else {
      setState(() => _selectedEmojiIndex = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Match the pairs!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Tap emoji, then tap its name!',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 30),

                // Emojis
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(widget.pairs.length, (index) {
                    final isMatched = _matched.contains(index);
                    final isSelected = _selectedEmojiIndex == index;
                    return GestureDetector(
                      onTap: () => _onEmojiTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isMatched
                                ? [
                                    const Color(0xFF4CAF50),
                                    const Color(0xFF66BB6A),
                                  ]
                                : (isSelected
                                      ? [
                                          const Color(0xFFFF6B6B),
                                          const Color(0xFFFF8E53),
                                        ]
                                      : [
                                          Colors.white.withValues(alpha: 0.2),
                                          Colors.white.withValues(alpha: 0.1),
                                        ]),
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.pairs[index]['emoji']!,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 40),

                // Names
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: _shuffledNames.map((name) {
                    final isMatched = widget.pairs.any(
                      (p) =>
                          p['name'] == name &&
                          _matched.contains(widget.pairs.indexOf(p)),
                    );
                    return GestureDetector(
                      onTap: isMatched ? null : () => _onNameTap(name),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isMatched
                                ? [
                                    const Color(0xFF4CAF50),
                                    const Color(0xFF66BB6A),
                                  ]
                                : [
                                    const Color(0xFF667EEA),
                                    const Color(0xFF764BA2),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const Spacer(),

                if (_matched.length == widget.pairs.length)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🎉', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 12),
                        Text(
                          'Perfect! +15 points',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Pattern Activity Screen
class _PatternActivityScreen extends StatefulWidget {
  final List<String> pattern;
  final String correctAnswer;
  final Function(int) onComplete;

  const _PatternActivityScreen({
    required this.pattern,
    required this.correctAnswer,
    required this.onComplete,
  });

  @override
  State<_PatternActivityScreen> createState() => _PatternActivityScreenState();
}

class _PatternActivityScreenState extends State<_PatternActivityScreen> {
  String? _selectedAnswer;
  late List<String> _options;

  @override
  void initState() {
    super.initState();
    _options = [widget.correctAnswer, '🟢', '🟡']..shuffle();
  }

  void _checkAnswer(String answer) {
    HapticFeedback.mediumImpact();
    setState(() => _selectedAnswer = answer);

    if (answer == widget.correctAnswer) {
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.onComplete(10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCorrect = _selectedAnswer == widget.correctAnswer;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Complete the Pattern',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              const Text(
                "What comes next?",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              const SizedBox(height: 30),

              // Pattern display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...widget.pattern.map(
                    (p) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(p, style: const TextStyle(fontSize: 40)),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _selectedAnswer ?? '?',
                        style: TextStyle(
                          fontSize: _selectedAnswer != null ? 30 : 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Options
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _options.map((option) {
                  return GestureDetector(
                    onTap: _selectedAnswer == null
                        ? () => _checkAnswer(option)
                        : null,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Center(
                        child: Text(
                          option,
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              if (_selectedAnswer != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCorrect ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isCorrect ? '🎉' : '😢',
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isCorrect ? 'Correct! +10 points' : 'Try again!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

enum ActivityType {
  counting,
  matching,
  sorting,
  pattern,
  missing,
  coloring,
  story,
}

class ActivityCategory {
  final String name;
  final String emoji;
  final List<LearningActivity> activities;

  ActivityCategory({
    required this.name,
    required this.emoji,
    required this.activities,
  });
}

class LearningActivity {
  final String name;
  final String emoji;
  final ActivityType type;
  final Map<String, dynamic> data;

  LearningActivity({
    required this.name,
    required this.emoji,
    required this.type,
    required this.data,
  });
}
