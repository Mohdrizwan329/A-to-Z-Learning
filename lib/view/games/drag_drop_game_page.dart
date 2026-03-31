import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class DragDropGamePage extends StatefulWidget {
  const DragDropGamePage({super.key});

  @override
  State<DragDropGamePage> createState() => _DragDropGamePageState();
}

class _DragDropGamePageState extends State<DragDropGamePage>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  late AnimationController _celebrationController;
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;

  int _currentLevel = 0;
  bool _showCelebration = false;

  final List<GameLevel> _levels = [
    // Level 1: Farm Animals
    GameLevel(
      title: 'Farm Animals',
      instruction: 'Drag the animal to its name!',
      emoji: '🐾',
      items: [
        DragItem(id: 'cat', emoji: '🐱', label: 'Cat'),
        DragItem(id: 'dog', emoji: '🐶', label: 'Dog'),
        DragItem(id: 'cow', emoji: '🐄', label: 'Cow'),
        DragItem(id: 'pig', emoji: '🐷', label: 'Pig'),
      ],
    ),
    // Level 2: Wild Animals
    GameLevel(
      title: 'Wild Animals',
      instruction: 'Drag the wild animal to its name!',
      emoji: '🦁',
      items: [
        DragItem(id: 'lion', emoji: '🦁', label: 'Lion'),
        DragItem(id: 'tiger', emoji: '🐯', label: 'Tiger'),
        DragItem(id: 'elephant', emoji: '🐘', label: 'Elephant'),
        DragItem(id: 'monkey', emoji: '🐵', label: 'Monkey'),
      ],
    ),
    // Level 3: Sea Animals
    GameLevel(
      title: 'Sea Animals',
      instruction: 'Drag the sea creature to its name!',
      emoji: '🐠',
      items: [
        DragItem(id: 'fish', emoji: '🐟', label: 'Fish'),
        DragItem(id: 'dolphin', emoji: '🐬', label: 'Dolphin'),
        DragItem(id: 'whale', emoji: '🐋', label: 'Whale'),
        DragItem(id: 'octopus', emoji: '🐙', label: 'Octopus'),
      ],
    ),
    // Level 4: Birds
    GameLevel(
      title: 'Birds',
      instruction: 'Drag the bird to its name!',
      emoji: '🐦',
      items: [
        DragItem(id: 'bird', emoji: '🐦', label: 'Bird'),
        DragItem(id: 'owl', emoji: '🦉', label: 'Owl'),
        DragItem(id: 'eagle', emoji: '🦅', label: 'Eagle'),
        DragItem(id: 'parrot', emoji: '🦜', label: 'Parrot'),
      ],
    ),
    // Level 5: Insects
    GameLevel(
      title: 'Insects',
      instruction: 'Drag the insect to its name!',
      emoji: '🐛',
      items: [
        DragItem(id: 'butterfly', emoji: '🦋', label: 'Butterfly'),
        DragItem(id: 'bee', emoji: '🐝', label: 'Bee'),
        DragItem(id: 'ladybug', emoji: '🐞', label: 'Ladybug'),
        DragItem(id: 'ant', emoji: '🐜', label: 'Ant'),
      ],
    ),
    // Level 6: Fruits 1
    GameLevel(
      title: 'Fruits 1',
      instruction: 'Drag the fruit to its name!',
      emoji: '🍎',
      items: [
        DragItem(id: 'apple', emoji: '🍎', label: 'Apple'),
        DragItem(id: 'banana', emoji: '🍌', label: 'Banana'),
        DragItem(id: 'orange', emoji: '🍊', label: 'Orange'),
        DragItem(id: 'grape', emoji: '🍇', label: 'Grapes'),
      ],
    ),
    // Level 7: Fruits 2
    GameLevel(
      title: 'Fruits 2',
      instruction: 'Drag the fruit to its name!',
      emoji: '🍓',
      items: [
        DragItem(id: 'strawberry', emoji: '🍓', label: 'Strawberry'),
        DragItem(id: 'watermelon', emoji: '🍉', label: 'Watermelon'),
        DragItem(id: 'pineapple', emoji: '🍍', label: 'Pineapple'),
        DragItem(id: 'mango', emoji: '🥭', label: 'Mango'),
      ],
    ),
    // Level 8: Fruits 3
    GameLevel(
      title: 'Fruits 3',
      instruction: 'Drag the fruit to its name!',
      emoji: '🍑',
      items: [
        DragItem(id: 'peach', emoji: '🍑', label: 'Peach'),
        DragItem(id: 'cherry', emoji: '🍒', label: 'Cherry'),
        DragItem(id: 'lemon', emoji: '🍋', label: 'Lemon'),
        DragItem(id: 'coconut', emoji: '🥥', label: 'Coconut'),
      ],
    ),
    // Level 9: Vegetables 1
    GameLevel(
      title: 'Vegetables 1',
      instruction: 'Drag the vegetable to its name!',
      emoji: '🥕',
      items: [
        DragItem(id: 'carrot', emoji: '🥕', label: 'Carrot'),
        DragItem(id: 'broccoli', emoji: '🥦', label: 'Broccoli'),
        DragItem(id: 'corn', emoji: '🌽', label: 'Corn'),
        DragItem(id: 'tomato', emoji: '🍅', label: 'Tomato'),
      ],
    ),
    // Level 10: Vegetables 2
    GameLevel(
      title: 'Vegetables 2',
      instruction: 'Drag the vegetable to its name!',
      emoji: '🥒',
      items: [
        DragItem(id: 'cucumber', emoji: '🥒', label: 'Cucumber'),
        DragItem(id: 'potato', emoji: '🥔', label: 'Potato'),
        DragItem(id: 'eggplant', emoji: '🍆', label: 'Eggplant'),
        DragItem(id: 'pepper', emoji: '🌶️', label: 'Pepper'),
      ],
    ),
    // Level 11: Numbers 1-4
    GameLevel(
      title: 'Numbers 1-4',
      instruction: 'Drag the number to match the count!',
      emoji: '🔢',
      items: [
        DragItem(id: '1', emoji: '1️⃣', label: 'One'),
        DragItem(id: '2', emoji: '2️⃣', label: 'Two'),
        DragItem(id: '3', emoji: '3️⃣', label: 'Three'),
        DragItem(id: '4', emoji: '4️⃣', label: 'Four'),
      ],
    ),
    // Level 12: Numbers 5-8
    GameLevel(
      title: 'Numbers 5-8',
      instruction: 'Drag the number to match the count!',
      emoji: '🔢',
      items: [
        DragItem(id: '5', emoji: '5️⃣', label: 'Five'),
        DragItem(id: '6', emoji: '6️⃣', label: 'Six'),
        DragItem(id: '7', emoji: '7️⃣', label: 'Seven'),
        DragItem(id: '8', emoji: '8️⃣', label: 'Eight'),
      ],
    ),
    // Level 13: Numbers 9-10
    GameLevel(
      title: 'Numbers 9-10',
      instruction: 'Drag the number to match the count!',
      emoji: '🔢',
      items: [
        DragItem(id: '9', emoji: '9️⃣', label: 'Nine'),
        DragItem(id: '10', emoji: '🔟', label: 'Ten'),
        DragItem(id: '0', emoji: '0️⃣', label: 'Zero'),
        DragItem(id: '100', emoji: '💯', label: 'Hundred'),
      ],
    ),
    // Level 14: Colors 1
    GameLevel(
      title: 'Colors 1',
      instruction: 'Drag the color to its name!',
      emoji: '🌈',
      items: [
        DragItem(id: 'red', emoji: '🔴', label: 'Red'),
        DragItem(id: 'blue', emoji: '🔵', label: 'Blue'),
        DragItem(id: 'green', emoji: '🟢', label: 'Green'),
        DragItem(id: 'yellow', emoji: '🟡', label: 'Yellow'),
      ],
    ),
    // Level 15: Colors 2
    GameLevel(
      title: 'Colors 2',
      instruction: 'Drag the color to its name!',
      emoji: '🎨',
      items: [
        DragItem(id: 'purple', emoji: '🟣', label: 'Purple'),
        DragItem(id: 'orange', emoji: '🟠', label: 'Orange'),
        DragItem(id: 'brown', emoji: '🟤', label: 'Brown'),
        DragItem(id: 'black', emoji: '⚫', label: 'Black'),
      ],
    ),
    // Level 16: Shapes 1
    GameLevel(
      title: 'Shapes 1',
      instruction: 'Drag the shape to its name!',
      emoji: '🔷',
      items: [
        DragItem(id: 'circle', emoji: '⭕', label: 'Circle'),
        DragItem(id: 'square', emoji: '🟥', label: 'Square'),
        DragItem(id: 'triangle', emoji: '🔺', label: 'Triangle'),
        DragItem(id: 'star', emoji: '⭐', label: 'Star'),
      ],
    ),
    // Level 17: Shapes 2
    GameLevel(
      title: 'Shapes 2',
      instruction: 'Drag the shape to its name!',
      emoji: '💠',
      items: [
        DragItem(id: 'heart', emoji: '❤️', label: 'Heart'),
        DragItem(id: 'diamond', emoji: '💎', label: 'Diamond'),
        DragItem(id: 'hexagon', emoji: '⬡', label: 'Hexagon'),
        DragItem(id: 'moon', emoji: '🌙', label: 'Moon'),
      ],
    ),
    // Level 18: Vehicles 1
    GameLevel(
      title: 'Vehicles 1',
      instruction: 'Drag the vehicle to its name!',
      emoji: '🚗',
      items: [
        DragItem(id: 'car', emoji: '🚗', label: 'Car'),
        DragItem(id: 'bus', emoji: '🚌', label: 'Bus'),
        DragItem(id: 'plane', emoji: '✈️', label: 'Plane'),
        DragItem(id: 'boat', emoji: '⛵', label: 'Boat'),
      ],
    ),
    // Level 19: Vehicles 2
    GameLevel(
      title: 'Vehicles 2',
      instruction: 'Drag the vehicle to its name!',
      emoji: '🚂',
      items: [
        DragItem(id: 'train', emoji: '🚂', label: 'Train'),
        DragItem(id: 'helicopter', emoji: '🚁', label: 'Helicopter'),
        DragItem(id: 'rocket', emoji: '🚀', label: 'Rocket'),
        DragItem(id: 'bicycle', emoji: '🚲', label: 'Bicycle'),
      ],
    ),
    // Level 20: Vehicles 3
    GameLevel(
      title: 'Vehicles 3',
      instruction: 'Drag the vehicle to its name!',
      emoji: '🏍️',
      items: [
        DragItem(id: 'motorcycle', emoji: '🏍️', label: 'Motorcycle'),
        DragItem(id: 'ambulance', emoji: '🚑', label: 'Ambulance'),
        DragItem(id: 'firetruck', emoji: '🚒', label: 'Fire Truck'),
        DragItem(id: 'taxi', emoji: '🚕', label: 'Taxi'),
      ],
    ),
    // Level 21: Food 1
    GameLevel(
      title: 'Food 1',
      instruction: 'Drag the food to its name!',
      emoji: '🍕',
      items: [
        DragItem(id: 'pizza', emoji: '🍕', label: 'Pizza'),
        DragItem(id: 'burger', emoji: '🍔', label: 'Burger'),
        DragItem(id: 'fries', emoji: '🍟', label: 'Fries'),
        DragItem(id: 'hotdog', emoji: '🌭', label: 'Hot Dog'),
      ],
    ),
    // Level 22: Food 2
    GameLevel(
      title: 'Food 2',
      instruction: 'Drag the food to its name!',
      emoji: '🍰',
      items: [
        DragItem(id: 'cake', emoji: '🎂', label: 'Cake'),
        DragItem(id: 'icecream', emoji: '🍦', label: 'Ice Cream'),
        DragItem(id: 'cookie', emoji: '🍪', label: 'Cookie'),
        DragItem(id: 'donut', emoji: '🍩', label: 'Donut'),
      ],
    ),
    // Level 23: Food 3
    GameLevel(
      title: 'Food 3',
      instruction: 'Drag the food to its name!',
      emoji: '🍜',
      items: [
        DragItem(id: 'noodles', emoji: '🍜', label: 'Noodles'),
        DragItem(id: 'rice', emoji: '🍚', label: 'Rice'),
        DragItem(id: 'bread', emoji: '🍞', label: 'Bread'),
        DragItem(id: 'egg', emoji: '🥚', label: 'Egg'),
      ],
    ),
    // Level 24: Drinks
    GameLevel(
      title: 'Drinks',
      instruction: 'Drag the drink to its name!',
      emoji: '🥤',
      items: [
        DragItem(id: 'juice', emoji: '🧃', label: 'Juice'),
        DragItem(id: 'milk', emoji: '🥛', label: 'Milk'),
        DragItem(id: 'water', emoji: '💧', label: 'Water'),
        DragItem(id: 'tea', emoji: '🍵', label: 'Tea'),
      ],
    ),
    // Level 25: Weather
    GameLevel(
      title: 'Weather',
      instruction: 'Drag the weather to its name!',
      emoji: '🌤️',
      items: [
        DragItem(id: 'sun', emoji: '☀️', label: 'Sun'),
        DragItem(id: 'cloud', emoji: '☁️', label: 'Cloud'),
        DragItem(id: 'rain', emoji: '🌧️', label: 'Rain'),
        DragItem(id: 'snow', emoji: '❄️', label: 'Snow'),
      ],
    ),
    // Level 26: Seasons
    GameLevel(
      title: 'Seasons',
      instruction: 'Drag the season to its name!',
      emoji: '🌸',
      items: [
        DragItem(id: 'spring', emoji: '🌸', label: 'Spring'),
        DragItem(id: 'summer', emoji: '☀️', label: 'Summer'),
        DragItem(id: 'autumn', emoji: '🍂', label: 'Autumn'),
        DragItem(id: 'winter', emoji: '⛄', label: 'Winter'),
      ],
    ),
    // Level 27: Body Parts 1
    GameLevel(
      title: 'Body Parts 1',
      instruction: 'Drag the body part to its name!',
      emoji: '👀',
      items: [
        DragItem(id: 'eye', emoji: '👁️', label: 'Eye'),
        DragItem(id: 'ear', emoji: '👂', label: 'Ear'),
        DragItem(id: 'nose', emoji: '👃', label: 'Nose'),
        DragItem(id: 'mouth', emoji: '👄', label: 'Mouth'),
      ],
    ),
    // Level 28: Body Parts 2
    GameLevel(
      title: 'Body Parts 2',
      instruction: 'Drag the body part to its name!',
      emoji: '🖐️',
      items: [
        DragItem(id: 'hand', emoji: '🖐️', label: 'Hand'),
        DragItem(id: 'foot', emoji: '🦶', label: 'Foot'),
        DragItem(id: 'leg', emoji: '🦵', label: 'Leg'),
        DragItem(id: 'brain', emoji: '🧠', label: 'Brain'),
      ],
    ),
    // Level 29: Family
    GameLevel(
      title: 'Family',
      instruction: 'Drag the family member to their name!',
      emoji: '👨‍👩‍👧‍👦',
      items: [
        DragItem(id: 'mother', emoji: '👩', label: 'Mother'),
        DragItem(id: 'father', emoji: '👨', label: 'Father'),
        DragItem(id: 'boy', emoji: '👦', label: 'Boy'),
        DragItem(id: 'girl', emoji: '👧', label: 'Girl'),
      ],
    ),
    // Level 30: Professions 1
    GameLevel(
      title: 'Professions 1',
      instruction: 'Drag the profession to its name!',
      emoji: '👨‍⚕️',
      items: [
        DragItem(id: 'doctor', emoji: '👨‍⚕️', label: 'Doctor'),
        DragItem(id: 'teacher', emoji: '👩‍🏫', label: 'Teacher'),
        DragItem(id: 'police', emoji: '👮', label: 'Police'),
        DragItem(id: 'firefighter', emoji: '👨‍🚒', label: 'Firefighter'),
      ],
    ),
    // Level 31: Professions 2
    GameLevel(
      title: 'Professions 2',
      instruction: 'Drag the profession to its name!',
      emoji: '👨‍🍳',
      items: [
        DragItem(id: 'chef', emoji: '👨‍🍳', label: 'Chef'),
        DragItem(id: 'farmer', emoji: '👨‍🌾', label: 'Farmer'),
        DragItem(id: 'pilot', emoji: '👨‍✈️', label: 'Pilot'),
        DragItem(id: 'astronaut', emoji: '👨‍🚀', label: 'Astronaut'),
      ],
    ),
    // Level 32: Sports 1
    GameLevel(
      title: 'Sports 1',
      instruction: 'Drag the sport to its name!',
      emoji: '⚽',
      items: [
        DragItem(id: 'soccer', emoji: '⚽', label: 'Soccer'),
        DragItem(id: 'basketball', emoji: '🏀', label: 'Basketball'),
        DragItem(id: 'tennis', emoji: '🎾', label: 'Tennis'),
        DragItem(id: 'baseball', emoji: '⚾', label: 'Baseball'),
      ],
    ),
    // Level 33: Sports 2
    GameLevel(
      title: 'Sports 2',
      instruction: 'Drag the sport to its name!',
      emoji: '🏊',
      items: [
        DragItem(id: 'swimming', emoji: '🏊', label: 'Swimming'),
        DragItem(id: 'golf', emoji: '⛳', label: 'Golf'),
        DragItem(id: 'skiing', emoji: '⛷️', label: 'Skiing'),
        DragItem(id: 'cycling', emoji: '🚴', label: 'Cycling'),
      ],
    ),
    // Level 34: Music
    GameLevel(
      title: 'Music',
      instruction: 'Drag the instrument to its name!',
      emoji: '🎵',
      items: [
        DragItem(id: 'guitar', emoji: '🎸', label: 'Guitar'),
        DragItem(id: 'piano', emoji: '🎹', label: 'Piano'),
        DragItem(id: 'drum', emoji: '🥁', label: 'Drum'),
        DragItem(id: 'violin', emoji: '🎻', label: 'Violin'),
      ],
    ),
    // Level 35: Space
    GameLevel(
      title: 'Space',
      instruction: 'Drag the space object to its name!',
      emoji: '🌌',
      items: [
        DragItem(id: 'sun2', emoji: '🌞', label: 'Sun'),
        DragItem(id: 'moon2', emoji: '🌝', label: 'Moon'),
        DragItem(id: 'star2', emoji: '🌟', label: 'Star'),
        DragItem(id: 'earth', emoji: '🌍', label: 'Earth'),
      ],
    ),
    // Level 36: Flowers
    GameLevel(
      title: 'Flowers',
      instruction: 'Drag the flower to its name!',
      emoji: '🌸',
      items: [
        DragItem(id: 'rose', emoji: '🌹', label: 'Rose'),
        DragItem(id: 'sunflower', emoji: '🌻', label: 'Sunflower'),
        DragItem(id: 'tulip', emoji: '🌷', label: 'Tulip'),
        DragItem(id: 'hibiscus', emoji: '🌺', label: 'Hibiscus'),
      ],
    ),
    // Level 37: Trees
    GameLevel(
      title: 'Trees & Plants',
      instruction: 'Drag the plant to its name!',
      emoji: '🌳',
      items: [
        DragItem(id: 'tree', emoji: '🌳', label: 'Tree'),
        DragItem(id: 'palm', emoji: '🌴', label: 'Palm'),
        DragItem(id: 'cactus', emoji: '🌵', label: 'Cactus'),
        DragItem(id: 'leaf', emoji: '🍀', label: 'Clover'),
      ],
    ),
    // Level 38: Tools
    GameLevel(
      title: 'Tools',
      instruction: 'Drag the tool to its name!',
      emoji: '🔧',
      items: [
        DragItem(id: 'hammer', emoji: '🔨', label: 'Hammer'),
        DragItem(id: 'wrench', emoji: '🔧', label: 'Wrench'),
        DragItem(id: 'scissors', emoji: '✂️', label: 'Scissors'),
        DragItem(id: 'key', emoji: '🔑', label: 'Key'),
      ],
    ),
    // Level 39: School 1
    GameLevel(
      title: 'School 1',
      instruction: 'Drag the school item to its name!',
      emoji: '📚',
      items: [
        DragItem(id: 'book', emoji: '📚', label: 'Book'),
        DragItem(id: 'pencil', emoji: '✏️', label: 'Pencil'),
        DragItem(id: 'ruler', emoji: '📏', label: 'Ruler'),
        DragItem(id: 'backpack', emoji: '🎒', label: 'Backpack'),
      ],
    ),
    // Level 40: School 2
    GameLevel(
      title: 'School 2',
      instruction: 'Drag the school item to its name!',
      emoji: '📝',
      items: [
        DragItem(id: 'notebook', emoji: '📓', label: 'Notebook'),
        DragItem(id: 'crayon', emoji: '🖍️', label: 'Crayon'),
        DragItem(id: 'globe', emoji: '🌐', label: 'Globe'),
        DragItem(id: 'microscope', emoji: '🔬', label: 'Microscope'),
      ],
    ),
    // Level 41: Home 1
    GameLevel(
      title: 'Home 1',
      instruction: 'Drag the home item to its name!',
      emoji: '🏠',
      items: [
        DragItem(id: 'house', emoji: '🏠', label: 'House'),
        DragItem(id: 'bed', emoji: '🛏️', label: 'Bed'),
        DragItem(id: 'chair', emoji: '🪑', label: 'Chair'),
        DragItem(id: 'lamp', emoji: '💡', label: 'Lamp'),
      ],
    ),
    // Level 42: Home 2
    GameLevel(
      title: 'Home 2',
      instruction: 'Drag the home item to its name!',
      emoji: '🛋️',
      items: [
        DragItem(id: 'sofa', emoji: '🛋️', label: 'Sofa'),
        DragItem(id: 'tv', emoji: '📺', label: 'TV'),
        DragItem(id: 'clock', emoji: '🕐', label: 'Clock'),
        DragItem(id: 'door', emoji: '🚪', label: 'Door'),
      ],
    ),
    // Level 43: Clothes 1
    GameLevel(
      title: 'Clothes 1',
      instruction: 'Drag the clothing to its name!',
      emoji: '👕',
      items: [
        DragItem(id: 'shirt', emoji: '👕', label: 'Shirt'),
        DragItem(id: 'pants', emoji: '👖', label: 'Pants'),
        DragItem(id: 'dress', emoji: '👗', label: 'Dress'),
        DragItem(id: 'shoe', emoji: '👟', label: 'Shoe'),
      ],
    ),
    // Level 44: Clothes 2
    GameLevel(
      title: 'Clothes 2',
      instruction: 'Drag the clothing to its name!',
      emoji: '🧢',
      items: [
        DragItem(id: 'hat', emoji: '🧢', label: 'Hat'),
        DragItem(id: 'gloves', emoji: '🧤', label: 'Gloves'),
        DragItem(id: 'socks', emoji: '🧦', label: 'Socks'),
        DragItem(id: 'scarf', emoji: '🧣', label: 'Scarf'),
      ],
    ),
    // Level 45: Emotions 1
    GameLevel(
      title: 'Emotions 1',
      instruction: 'Drag the emotion to its name!',
      emoji: '😊',
      items: [
        DragItem(id: 'happy', emoji: '😊', label: 'Happy'),
        DragItem(id: 'sad', emoji: '😢', label: 'Sad'),
        DragItem(id: 'angry', emoji: '😠', label: 'Angry'),
        DragItem(id: 'surprised', emoji: '😲', label: 'Surprised'),
      ],
    ),
    // Level 46: Emotions 2
    GameLevel(
      title: 'Emotions 2',
      instruction: 'Drag the emotion to its name!',
      emoji: '🤔',
      items: [
        DragItem(id: 'thinking', emoji: '🤔', label: 'Thinking'),
        DragItem(id: 'sleepy', emoji: '😴', label: 'Sleepy'),
        DragItem(id: 'love', emoji: '🥰', label: 'Love'),
        DragItem(id: 'scared', emoji: '😨', label: 'Scared'),
      ],
    ),
    // Level 47: Time
    GameLevel(
      title: 'Time',
      instruction: 'Drag the time to its name!',
      emoji: '⏰',
      items: [
        DragItem(id: 'morning', emoji: '🌅', label: 'Morning'),
        DragItem(id: 'afternoon', emoji: '🌞', label: 'Afternoon'),
        DragItem(id: 'evening', emoji: '🌆', label: 'Evening'),
        DragItem(id: 'night', emoji: '🌙', label: 'Night'),
      ],
    ),
    // Level 48: Nature
    GameLevel(
      title: 'Nature',
      instruction: 'Drag the nature element to its name!',
      emoji: '🏔️',
      items: [
        DragItem(id: 'mountain', emoji: '🏔️', label: 'Mountain'),
        DragItem(id: 'ocean', emoji: '🌊', label: 'Ocean'),
        DragItem(id: 'river', emoji: '🏞️', label: 'River'),
        DragItem(id: 'rainbow', emoji: '🌈', label: 'Rainbow'),
      ],
    ),
    // Level 49: Celebration
    GameLevel(
      title: 'Celebration',
      instruction: 'Drag the celebration item to its name!',
      emoji: '🎉',
      items: [
        DragItem(id: 'balloon', emoji: '🎈', label: 'Balloon'),
        DragItem(id: 'gift', emoji: '🎁', label: 'Gift'),
        DragItem(id: 'confetti', emoji: '🎊', label: 'Confetti'),
        DragItem(id: 'fireworks', emoji: '🎆', label: 'Fireworks'),
      ],
    ),
    // Level 50: Symbols
    GameLevel(
      title: 'Symbols',
      instruction: 'Drag the symbol to its name!',
      emoji: '💯',
      items: [
        DragItem(id: 'tick', emoji: '✅', label: 'Tick'),
        DragItem(id: 'cross', emoji: '❌', label: 'Cross'),
        DragItem(id: 'question', emoji: '❓', label: 'Question'),
        DragItem(id: 'exclaim', emoji: '❗', label: 'Exclaim'),
      ],
    ),
    // Level 51: Zoo Animals
    GameLevel(
      title: 'Zoo Animals',
      instruction: 'Drag the zoo animal to its name!',
      emoji: '🦒',
      items: [
        DragItem(id: 'giraffe', emoji: '🦒', label: 'Giraffe'),
        DragItem(id: 'zebra', emoji: '🦓', label: 'Zebra'),
        DragItem(id: 'hippo', emoji: '🦛', label: 'Hippo'),
        DragItem(id: 'rhino', emoji: '🦏', label: 'Rhino'),
      ],
    ),
    // Level 52: Reptiles
    GameLevel(
      title: 'Reptiles',
      instruction: 'Drag the reptile to its name!',
      emoji: '🐍',
      items: [
        DragItem(id: 'snake', emoji: '🐍', label: 'Snake'),
        DragItem(id: 'turtle', emoji: '🐢', label: 'Turtle'),
        DragItem(id: 'crocodile', emoji: '🐊', label: 'Crocodile'),
        DragItem(id: 'lizard', emoji: '🦎', label: 'Lizard'),
      ],
    ),
    // Level 53: Pets
    GameLevel(
      title: 'Pets',
      instruction: 'Drag the pet to its name!',
      emoji: '🐹',
      items: [
        DragItem(id: 'hamster', emoji: '🐹', label: 'Hamster'),
        DragItem(id: 'rabbit', emoji: '🐰', label: 'Rabbit'),
        DragItem(id: 'mouse', emoji: '🐭', label: 'Mouse'),
        DragItem(id: 'frog', emoji: '🐸', label: 'Frog'),
      ],
    ),
    // Level 54: Farm Animals 2
    GameLevel(
      title: 'Farm Animals 2',
      instruction: 'Drag the farm animal to its name!',
      emoji: '🐴',
      items: [
        DragItem(id: 'horse', emoji: '🐴', label: 'Horse'),
        DragItem(id: 'sheep', emoji: '🐑', label: 'Sheep'),
        DragItem(id: 'goat', emoji: '🐐', label: 'Goat'),
        DragItem(id: 'chicken', emoji: '🐔', label: 'Chicken'),
      ],
    ),
    // Level 55: Tropical Fruits
    GameLevel(
      title: 'Tropical Fruits',
      instruction: 'Drag the tropical fruit to its name!',
      emoji: '🥝',
      items: [
        DragItem(id: 'kiwi', emoji: '🥝', label: 'Kiwi'),
        DragItem(id: 'papaya', emoji: '🍈', label: 'Melon'),
        DragItem(id: 'avocado', emoji: '🥑', label: 'Avocado'),
        DragItem(id: 'pear', emoji: '🍐', label: 'Pear'),
      ],
    ),
    // Level 56: Berries
    GameLevel(
      title: 'Berries',
      instruction: 'Drag the berry to its name!',
      emoji: '🫐',
      items: [
        DragItem(id: 'blueberry', emoji: '🫐', label: 'Blueberry'),
        DragItem(id: 'strawberry2', emoji: '🍓', label: 'Strawberry'),
        DragItem(id: 'grape2', emoji: '🍇', label: 'Grape'),
        DragItem(id: 'cherry2', emoji: '🍒', label: 'Cherry'),
      ],
    ),
    // Level 57: Vegetables 3
    GameLevel(
      title: 'Vegetables 3',
      instruction: 'Drag the vegetable to its name!',
      emoji: '🧅',
      items: [
        DragItem(id: 'onion', emoji: '🧅', label: 'Onion'),
        DragItem(id: 'garlic', emoji: '🧄', label: 'Garlic'),
        DragItem(id: 'lettuce', emoji: '🥬', label: 'Lettuce'),
        DragItem(id: 'mushroom', emoji: '🍄', label: 'Mushroom'),
      ],
    ),
    // Level 58: Snacks
    GameLevel(
      title: 'Snacks',
      instruction: 'Drag the snack to its name!',
      emoji: '🍿',
      items: [
        DragItem(id: 'popcorn', emoji: '🍿', label: 'Popcorn'),
        DragItem(id: 'pretzel', emoji: '🥨', label: 'Pretzel'),
        DragItem(id: 'candy', emoji: '🍬', label: 'Candy'),
        DragItem(id: 'chocolate', emoji: '🍫', label: 'Chocolate'),
      ],
    ),
    // Level 59: Breakfast
    GameLevel(
      title: 'Breakfast',
      instruction: 'Drag the breakfast food to its name!',
      emoji: '🥞',
      items: [
        DragItem(id: 'pancake', emoji: '🥞', label: 'Pancake'),
        DragItem(id: 'bacon', emoji: '🥓', label: 'Bacon'),
        DragItem(id: 'croissant', emoji: '🥐', label: 'Croissant'),
        DragItem(id: 'waffle', emoji: '🧇', label: 'Waffle'),
      ],
    ),
    // Level 60: Desserts
    GameLevel(
      title: 'Desserts',
      instruction: 'Drag the dessert to its name!',
      emoji: '🧁',
      items: [
        DragItem(id: 'cupcake', emoji: '🧁', label: 'Cupcake'),
        DragItem(id: 'pie', emoji: '🥧', label: 'Pie'),
        DragItem(id: 'pudding', emoji: '🍮', label: 'Pudding'),
        DragItem(id: 'lollipop', emoji: '🍭', label: 'Lollipop'),
      ],
    ),
    // Level 61: Asian Food
    GameLevel(
      title: 'Asian Food',
      instruction: 'Drag the food to its name!',
      emoji: '🍱',
      items: [
        DragItem(id: 'bento', emoji: '🍱', label: 'Bento'),
        DragItem(id: 'sushi', emoji: '🍣', label: 'Sushi'),
        DragItem(id: 'ramen', emoji: '🍜', label: 'Ramen'),
        DragItem(id: 'dumpling', emoji: '🥟', label: 'Dumpling'),
      ],
    ),
    // Level 62: Beverages
    GameLevel(
      title: 'Beverages',
      instruction: 'Drag the beverage to its name!',
      emoji: '🧋',
      items: [
        DragItem(id: 'bubbletea', emoji: '🧋', label: 'Bubble Tea'),
        DragItem(id: 'coffee', emoji: '☕', label: 'Coffee'),
        DragItem(id: 'smoothie', emoji: '🥤', label: 'Smoothie'),
        DragItem(id: 'cocoa', emoji: '🍵', label: 'Hot Cocoa'),
      ],
    ),
    // Level 63: Weather 2
    GameLevel(
      title: 'Weather 2',
      instruction: 'Drag the weather to its name!',
      emoji: '🌪️',
      items: [
        DragItem(id: 'tornado', emoji: '🌪️', label: 'Tornado'),
        DragItem(id: 'lightning', emoji: '⚡', label: 'Lightning'),
        DragItem(id: 'fog', emoji: '🌫️', label: 'Fog'),
        DragItem(id: 'wind', emoji: '💨', label: 'Wind'),
      ],
    ),
    // Level 64: Ocean Life
    GameLevel(
      title: 'Ocean Life',
      instruction: 'Drag the ocean creature to its name!',
      emoji: '🦀',
      items: [
        DragItem(id: 'crab', emoji: '🦀', label: 'Crab'),
        DragItem(id: 'shrimp', emoji: '🦐', label: 'Shrimp'),
        DragItem(id: 'squid', emoji: '🦑', label: 'Squid'),
        DragItem(id: 'jellyfish', emoji: '🪼', label: 'Jellyfish'),
      ],
    ),
    // Level 65: Dinosaurs
    GameLevel(
      title: 'Dinosaurs',
      instruction: 'Drag the dinosaur to its name!',
      emoji: '🦕',
      items: [
        DragItem(id: 'sauropod', emoji: '🦕', label: 'Sauropod'),
        DragItem(id: 'trex', emoji: '🦖', label: 'T-Rex'),
        DragItem(id: 'dino_egg', emoji: '🥚', label: 'Dino Egg'),
        DragItem(id: 'fossil', emoji: '🦴', label: 'Fossil'),
      ],
    ),
    // Level 66: Camping
    GameLevel(
      title: 'Camping',
      instruction: 'Drag the camping item to its name!',
      emoji: '🏕️',
      items: [
        DragItem(id: 'tent', emoji: '⛺', label: 'Tent'),
        DragItem(id: 'campfire', emoji: '🔥', label: 'Campfire'),
        DragItem(id: 'flashlight', emoji: '🔦', label: 'Flashlight'),
        DragItem(id: 'compass', emoji: '🧭', label: 'Compass'),
      ],
    ),
    // Level 67: Beach
    GameLevel(
      title: 'Beach',
      instruction: 'Drag the beach item to its name!',
      emoji: '🏖️',
      items: [
        DragItem(id: 'umbrella', emoji: '⛱️', label: 'Umbrella'),
        DragItem(id: 'shell', emoji: '🐚', label: 'Shell'),
        DragItem(id: 'sandcastle', emoji: '🏰', label: 'Sandcastle'),
        DragItem(id: 'wave', emoji: '🌊', label: 'Wave'),
      ],
    ),
    // Level 68: Buildings
    GameLevel(
      title: 'Buildings',
      instruction: 'Drag the building to its name!',
      emoji: '🏠',
      items: [
        DragItem(id: 'hospital', emoji: '🏥', label: 'Hospital'),
        DragItem(id: 'school', emoji: '🏫', label: 'School'),
        DragItem(id: 'bank', emoji: '🏦', label: 'Bank'),
        DragItem(id: 'church', emoji: '⛪', label: 'Church'),
      ],
    ),
    // Level 69: Places
    GameLevel(
      title: 'Places',
      instruction: 'Drag the place to its name!',
      emoji: '🏟️',
      items: [
        DragItem(id: 'stadium', emoji: '🏟️', label: 'Stadium'),
        DragItem(id: 'park', emoji: '🏞️', label: 'Park'),
        DragItem(id: 'factory', emoji: '🏭', label: 'Factory'),
        DragItem(id: 'castle', emoji: '🏰', label: 'Castle'),
      ],
    ),
    // Level 70: Transportation 1
    GameLevel(
      title: 'Transportation 1',
      instruction: 'Drag the transport to its name!',
      emoji: '🚇',
      items: [
        DragItem(id: 'metro', emoji: '🚇', label: 'Metro'),
        DragItem(id: 'tram', emoji: '🚊', label: 'Tram'),
        DragItem(id: 'trolley', emoji: '🚎', label: 'Trolley'),
        DragItem(id: 'monorail', emoji: '🚝', label: 'Monorail'),
      ],
    ),
    // Level 71: Emergency Vehicles
    GameLevel(
      title: 'Emergency',
      instruction: 'Drag the vehicle to its name!',
      emoji: '🚨',
      items: [
        DragItem(id: 'police_car', emoji: '🚓', label: 'Police Car'),
        DragItem(id: 'ambulance2', emoji: '🚑', label: 'Ambulance'),
        DragItem(id: 'fire_engine', emoji: '🚒', label: 'Fire Engine'),
        DragItem(id: 'siren', emoji: '🚨', label: 'Siren'),
      ],
    ),
    // Level 72: Water Transport
    GameLevel(
      title: 'Water Transport',
      instruction: 'Drag the boat to its name!',
      emoji: '🚢',
      items: [
        DragItem(id: 'ship', emoji: '🚢', label: 'Ship'),
        DragItem(id: 'speedboat', emoji: '🚤', label: 'Speedboat'),
        DragItem(id: 'sailboat', emoji: '⛵', label: 'Sailboat'),
        DragItem(id: 'canoe', emoji: '🛶', label: 'Canoe'),
      ],
    ),
    // Level 73: Air Transport
    GameLevel(
      title: 'Air Transport',
      instruction: 'Drag the aircraft to its name!',
      emoji: '🛩️',
      items: [
        DragItem(id: 'small_plane', emoji: '🛩️', label: 'Small Plane'),
        DragItem(id: 'airplane', emoji: '✈️', label: 'Airplane'),
        DragItem(id: 'helicopter2', emoji: '🚁', label: 'Helicopter'),
        DragItem(id: 'balloon2', emoji: '🎈', label: 'Balloon'),
      ],
    ),
    // Level 74: Kitchen Items
    GameLevel(
      title: 'Kitchen Items',
      instruction: 'Drag the kitchen item to its name!',
      emoji: '🍳',
      items: [
        DragItem(id: 'pan', emoji: '🍳', label: 'Pan'),
        DragItem(id: 'pot', emoji: '🍲', label: 'Pot'),
        DragItem(id: 'knife', emoji: '🔪', label: 'Knife'),
        DragItem(id: 'spoon', emoji: '🥄', label: 'Spoon'),
      ],
    ),
    // Level 75: Bathroom Items
    GameLevel(
      title: 'Bathroom Items',
      instruction: 'Drag the item to its name!',
      emoji: '🛁',
      items: [
        DragItem(id: 'bathtub', emoji: '🛁', label: 'Bathtub'),
        DragItem(id: 'shower', emoji: '🚿', label: 'Shower'),
        DragItem(id: 'toilet', emoji: '🚽', label: 'Toilet'),
        DragItem(id: 'toothbrush', emoji: '🪥', label: 'Toothbrush'),
      ],
    ),
    // Level 76: Office Items
    GameLevel(
      title: 'Office Items',
      instruction: 'Drag the office item to its name!',
      emoji: '💼',
      items: [
        DragItem(id: 'briefcase', emoji: '💼', label: 'Briefcase'),
        DragItem(id: 'computer', emoji: '💻', label: 'Computer'),
        DragItem(id: 'printer', emoji: '🖨️', label: 'Printer'),
        DragItem(id: 'phone', emoji: '📱', label: 'Phone'),
      ],
    ),
    // Level 77: Electronics
    GameLevel(
      title: 'Electronics',
      instruction: 'Drag the electronic to its name!',
      emoji: '📷',
      items: [
        DragItem(id: 'camera', emoji: '📷', label: 'Camera'),
        DragItem(id: 'radio', emoji: '📻', label: 'Radio'),
        DragItem(id: 'speaker', emoji: '🔊', label: 'Speaker'),
        DragItem(id: 'headphones', emoji: '🎧', label: 'Headphones'),
      ],
    ),
    // Level 78: Gaming
    GameLevel(
      title: 'Gaming',
      instruction: 'Drag the gaming item to its name!',
      emoji: '🎮',
      items: [
        DragItem(id: 'controller', emoji: '🎮', label: 'Controller'),
        DragItem(id: 'joystick', emoji: '🕹️', label: 'Joystick'),
        DragItem(id: 'dice', emoji: '🎲', label: 'Dice'),
        DragItem(id: 'puzzle', emoji: '🧩', label: 'Puzzle'),
      ],
    ),
    // Level 79: Art Supplies
    GameLevel(
      title: 'Art Supplies',
      instruction: 'Drag the art supply to its name!',
      emoji: '🎨',
      items: [
        DragItem(id: 'palette', emoji: '🎨', label: 'Palette'),
        DragItem(id: 'paintbrush', emoji: '🖌️', label: 'Paintbrush'),
        DragItem(id: 'crayon2', emoji: '🖍️', label: 'Crayon'),
        DragItem(id: 'frame', emoji: '🖼️', label: 'Frame'),
      ],
    ),
    // Level 80: Music 2
    GameLevel(
      title: 'Music 2',
      instruction: 'Drag the instrument to its name!',
      emoji: '🎺',
      items: [
        DragItem(id: 'trumpet', emoji: '🎺', label: 'Trumpet'),
        DragItem(id: 'saxophone', emoji: '🎷', label: 'Saxophone'),
        DragItem(id: 'accordion', emoji: '🪗', label: 'Accordion'),
        DragItem(id: 'banjo', emoji: '🪕', label: 'Banjo'),
      ],
    ),
    // Level 81: Dance & Performance
    GameLevel(
      title: 'Performance',
      instruction: 'Drag the item to its name!',
      emoji: '🎭',
      items: [
        DragItem(id: 'masks', emoji: '🎭', label: 'Masks'),
        DragItem(id: 'ticket', emoji: '🎫', label: 'Ticket'),
        DragItem(id: 'microphone', emoji: '🎤', label: 'Microphone'),
        DragItem(id: 'spotlight', emoji: '🔦', label: 'Spotlight'),
      ],
    ),
    // Level 82: Sports Equipment
    GameLevel(
      title: 'Sports Gear',
      instruction: 'Drag the sports gear to its name!',
      emoji: '🏈',
      items: [
        DragItem(id: 'football', emoji: '🏈', label: 'Football'),
        DragItem(id: 'volleyball', emoji: '🏐', label: 'Volleyball'),
        DragItem(id: 'rugby', emoji: '🏉', label: 'Rugby Ball'),
        DragItem(id: 'cricket', emoji: '🏏', label: 'Cricket'),
      ],
    ),
    // Level 83: Winter Sports
    GameLevel(
      title: 'Winter Sports',
      instruction: 'Drag the sport to its name!',
      emoji: '⛷️',
      items: [
        DragItem(id: 'skiing2', emoji: '⛷️', label: 'Skiing'),
        DragItem(id: 'snowboard', emoji: '🏂', label: 'Snowboard'),
        DragItem(id: 'sled', emoji: '🛷', label: 'Sled'),
        DragItem(id: 'iceskate', emoji: '⛸️', label: 'Ice Skate'),
      ],
    ),
    // Level 84: Water Sports
    GameLevel(
      title: 'Water Sports',
      instruction: 'Drag the sport to its name!',
      emoji: '🏄',
      items: [
        DragItem(id: 'surfing', emoji: '🏄', label: 'Surfing'),
        DragItem(id: 'rowing', emoji: '🚣', label: 'Rowing'),
        DragItem(id: 'diving', emoji: '🤿', label: 'Diving'),
        DragItem(id: 'waterpolo', emoji: '🤽', label: 'Water Polo'),
      ],
    ),
    // Level 85: Fitness
    GameLevel(
      title: 'Fitness',
      instruction: 'Drag the fitness item to its name!',
      emoji: '🏋️',
      items: [
        DragItem(id: 'weightlifting', emoji: '🏋️', label: 'Weightlifting'),
        DragItem(id: 'yoga', emoji: '🧘', label: 'Yoga'),
        DragItem(id: 'running', emoji: '🏃', label: 'Running'),
        DragItem(id: 'climbing', emoji: '🧗', label: 'Climbing'),
      ],
    ),
    // Level 86: Space 2
    GameLevel(
      title: 'Space 2',
      instruction: 'Drag the space item to its name!',
      emoji: '🛸',
      items: [
        DragItem(id: 'ufo', emoji: '🛸', label: 'UFO'),
        DragItem(id: 'satellite', emoji: '🛰️', label: 'Satellite'),
        DragItem(id: 'rocket2', emoji: '🚀', label: 'Rocket'),
        DragItem(id: 'meteor', emoji: '☄️', label: 'Meteor'),
      ],
    ),
    // Level 87: Planets
    GameLevel(
      title: 'Planets',
      instruction: 'Drag the planet to its name!',
      emoji: '🪐',
      items: [
        DragItem(id: 'saturn', emoji: '🪐', label: 'Saturn'),
        DragItem(id: 'earth2', emoji: '🌍', label: 'Earth'),
        DragItem(id: 'moon3', emoji: '🌙', label: 'Moon'),
        DragItem(id: 'sun3', emoji: '☀️', label: 'Sun'),
      ],
    ),
    // Level 88: Garden
    GameLevel(
      title: 'Garden',
      instruction: 'Drag the garden item to its name!',
      emoji: '🌱',
      items: [
        DragItem(id: 'seedling', emoji: '🌱', label: 'Seedling'),
        DragItem(id: 'blossom', emoji: '🌼', label: 'Blossom'),
        DragItem(id: 'herb', emoji: '🌿', label: 'Herb'),
        DragItem(id: 'potted', emoji: '🪴', label: 'Plant'),
      ],
    ),
    // Level 89: Bugs
    GameLevel(
      title: 'Bugs',
      instruction: 'Drag the bug to its name!',
      emoji: '🐛',
      items: [
        DragItem(id: 'caterpillar', emoji: '🐛', label: 'Caterpillar'),
        DragItem(id: 'snail', emoji: '🐌', label: 'Snail'),
        DragItem(id: 'spider', emoji: '🕷️', label: 'Spider'),
        DragItem(id: 'cricket2', emoji: '🦗', label: 'Cricket'),
      ],
    ),
    // Level 90: Fantasy
    GameLevel(
      title: 'Fantasy',
      instruction: 'Drag the fantasy creature to its name!',
      emoji: '🦄',
      items: [
        DragItem(id: 'unicorn', emoji: '🦄', label: 'Unicorn'),
        DragItem(id: 'dragon', emoji: '🐉', label: 'Dragon'),
        DragItem(id: 'fairy', emoji: '🧚', label: 'Fairy'),
        DragItem(id: 'mermaid', emoji: '🧜', label: 'Mermaid'),
      ],
    ),
    // Level 91: Magic
    GameLevel(
      title: 'Magic',
      instruction: 'Drag the magic item to its name!',
      emoji: '🪄',
      items: [
        DragItem(id: 'wand', emoji: '🪄', label: 'Wand'),
        DragItem(id: 'crystal', emoji: '🔮', label: 'Crystal Ball'),
        DragItem(id: 'wizard', emoji: '🧙', label: 'Wizard'),
        DragItem(id: 'sparkles', emoji: '✨', label: 'Sparkles'),
      ],
    ),
    // Level 92: Holidays
    GameLevel(
      title: 'Holidays',
      instruction: 'Drag the holiday item to its name!',
      emoji: '🎄',
      items: [
        DragItem(id: 'christmas', emoji: '🎄', label: 'Christmas'),
        DragItem(id: 'pumpkin', emoji: '🎃', label: 'Pumpkin'),
        DragItem(id: 'egg2', emoji: '🥚', label: 'Easter Egg'),
        DragItem(id: 'heart2', emoji: '💝', label: 'Valentine'),
      ],
    ),
    // Level 93: Party
    GameLevel(
      title: 'Party',
      instruction: 'Drag the party item to its name!',
      emoji: '🎊',
      items: [
        DragItem(id: 'confetti2', emoji: '🎊', label: 'Confetti'),
        DragItem(id: 'disco', emoji: '🪩', label: 'Disco Ball'),
        DragItem(id: 'cake2', emoji: '🎂', label: 'Birthday Cake'),
        DragItem(id: 'pinata', emoji: '🪅', label: 'Pinata'),
      ],
    ),
    // Level 94: Jewelry
    GameLevel(
      title: 'Jewelry',
      instruction: 'Drag the jewelry to its name!',
      emoji: '💍',
      items: [
        DragItem(id: 'ring', emoji: '💍', label: 'Ring'),
        DragItem(id: 'crown', emoji: '👑', label: 'Crown'),
        DragItem(id: 'gem', emoji: '💎', label: 'Gem'),
        DragItem(id: 'necklace', emoji: '📿', label: 'Necklace'),
      ],
    ),
    // Level 95: Money
    GameLevel(
      title: 'Money',
      instruction: 'Drag the money item to its name!',
      emoji: '💰',
      items: [
        DragItem(id: 'moneybag', emoji: '💰', label: 'Money Bag'),
        DragItem(id: 'coin', emoji: '🪙', label: 'Coin'),
        DragItem(id: 'dollar', emoji: '💵', label: 'Dollar'),
        DragItem(id: 'card', emoji: '💳', label: 'Card'),
      ],
    ),
    // Level 96: Communication
    GameLevel(
      title: 'Communication',
      instruction: 'Drag the item to its name!',
      emoji: '📬',
      items: [
        DragItem(id: 'mailbox', emoji: '📬', label: 'Mailbox'),
        DragItem(id: 'envelope', emoji: '✉️', label: 'Envelope'),
        DragItem(id: 'phone2', emoji: '📞', label: 'Telephone'),
        DragItem(id: 'email', emoji: '📧', label: 'Email'),
      ],
    ),
    // Level 97: Safety
    GameLevel(
      title: 'Safety',
      instruction: 'Drag the safety item to its name!',
      emoji: '🦺',
      items: [
        DragItem(id: 'vest', emoji: '🦺', label: 'Safety Vest'),
        DragItem(id: 'helmet', emoji: '⛑️', label: 'Helmet'),
        DragItem(id: 'lock', emoji: '🔒', label: 'Lock'),
        DragItem(id: 'shield', emoji: '🛡️', label: 'Shield'),
      ],
    ),
    // Level 98: Directions
    GameLevel(
      title: 'Directions',
      instruction: 'Drag the direction to its name!',
      emoji: '⬆️',
      items: [
        DragItem(id: 'up', emoji: '⬆️', label: 'Up'),
        DragItem(id: 'down', emoji: '⬇️', label: 'Down'),
        DragItem(id: 'left', emoji: '⬅️', label: 'Left'),
        DragItem(id: 'right', emoji: '➡️', label: 'Right'),
      ],
    ),
    // Level 99: Hearts
    GameLevel(
      title: 'Hearts',
      instruction: 'Drag the heart to its name!',
      emoji: '❤️',
      items: [
        DragItem(id: 'redheart', emoji: '❤️', label: 'Red Heart'),
        DragItem(id: 'pinkheart', emoji: '💗', label: 'Pink Heart'),
        DragItem(id: 'blueheart', emoji: '💙', label: 'Blue Heart'),
        DragItem(id: 'greenheart', emoji: '💚', label: 'Green Heart'),
      ],
    ),
    // Level 100: Stars
    GameLevel(
      title: 'Stars',
      instruction: 'Drag the star to its name!',
      emoji: '⭐',
      items: [
        DragItem(id: 'yellowstar', emoji: '⭐', label: 'Yellow Star'),
        DragItem(id: 'glowstar', emoji: '🌟', label: 'Glow Star'),
        DragItem(id: 'sparkle', emoji: '✨', label: 'Sparkle'),
        DragItem(id: 'shootingstar', emoji: '💫', label: 'Shooting Star'),
      ],
    ),
  ];

  List<DragItem> _currentItems = [];
  List<String> _shuffledTargets = [];
  Map<String, bool> _matchedItems = {};

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Home screen style animations
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _initTts();
    _loadLevel();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.4);
    await _tts.setPitch(1.2);
  }

  void _loadLevel() {
    if (_currentLevel >= _levels.length) {
      _showGameComplete();
      return;
    }

    final level = _levels[_currentLevel];
    _currentItems = List.from(level.items);
    _shuffledTargets = level.items.map((e) => e.id).toList()..shuffle();
    _matchedItems = {for (var item in level.items) item.id: false};

    setState(() {});
    _speak(level.instruction);
  }

  Future<void> _speak(String text) async {
    TtsService.to.speak(text);
    await _tts.speak(text);
  }

  void _onDragCompleted(String itemId, String targetId) {
    if (itemId == targetId && !_matchedItems[itemId]!) {
      setState(() {
        _matchedItems[itemId] = true;
      });

      _speak('Correct! Well done!');

      // Check if level complete
      if (_matchedItems.values.every((matched) => matched)) {
        _onLevelComplete();
      }
    } else if (itemId != targetId) {
      _speak('Try again!');
    }
  }

  void _onLevelComplete() {
    setState(() {
      _showCelebration = true;
    });
    _celebrationController.forward(from: 0);
    _speak('Great job! Level complete!');

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showCelebration = false;
        _currentLevel++;
      });
      _loadLevel();
    });
  }

  void _resetCurrentLevel() {
    setState(() {
      _currentLevel = 0;
    });
    _loadLevel();
  }

  void _showGameComplete() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 70)),
            const SizedBox(height: 16),
            Text(
              'Congratulations!',
              style: GoogleFonts.baloo2(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF56D97F),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You completed all levels!',
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Exit',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      setState(() {
                        _currentLevel = 0;
                      });
                      _loadLevel();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF56D97F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Play Again',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    _tts.stop();
    super.dispose();
  }

  // Build floating bubbles like home screen
  List<Widget> _buildFloatingBubbles() {
    return List.generate(10, (index) {
      final random = Random(index + 42);
      final size = 20.0 + random.nextDouble() * 50;
      final left = random.nextDouble() * MediaQuery.of(context).size.width;
      final startTop = random.nextDouble() * MediaQuery.of(context).size.height;

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + index * 0.1) % 1.0;
          final top =
              startTop - (progress * MediaQuery.of(context).size.height * 0.5);
          final opacity = (1 - progress).clamp(0.0, 0.15);

          return Positioned(
            left: left,
            top: top,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: opacity),
                    Colors.white.withValues(alpha: opacity * 0.3),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLevel >= _levels.length) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
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
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final level = _levels[_currentLevel];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 8,
        shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x40FF6B6B),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
        ),
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
        title: Text(
          'Drag & Drop',
          style: GoogleFonts.baloo2(
            fontSize: 22,
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
            onPressed: _resetCurrentLevel,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFf093fb),
              Color(0xFFf5576c),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Floating bubbles background
            ..._buildFloatingBubbles(),

            SafeArea(
              child: Column(
                children: [
                  // Score & Progress
                  _buildScoreBar(),

                  const SizedBox(height: 12),

                  // Instruction
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            level.instruction,
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Drag Items
                  _buildDragItems(),

                  const SizedBox(height: 24),

                  // Drop Targets
                  Expanded(child: _buildDropTargets()),
                ],
              ),
            ),

            // Celebration overlay
            if (_showCelebration) _buildCelebration(),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildScoreBar() {
    // Current level progress
    final matchedCount = _matchedItems.values.where((v) => v).length;
    final totalItems = _matchedItems.length;
    final currentLevelProgress =
        matchedCount / (totalItems == 0 ? 1 : totalItems);

    // Overall progress (levels completed)
    final totalLevels = _levels.length;
    final overallProgress =
        (_currentLevel + currentLevelProgress) / totalLevels;
    final overallPercentage = (overallProgress * 100).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Overall Progress section like other screens
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
                'Level ${_currentLevel + 1} / $totalLevels ($overallPercentage%)',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Overall progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: overallProgress,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF56D97F),
              ),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragItems() {
    // Home screen style gradients
    final gradients = [
      [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      [const Color(0xFFA78BFA), const Color(0xFF8B5CF6)],
      [const Color(0xFF56D97F), const Color(0xFF11998E)],
      [const Color(0xFFFF6EB4), const Color(0xFFFF9A9E)],
      [const Color(0xFF667EEA), const Color(0xFF764BA2)],
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: _currentItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isMatched = _matchedItems[item.id] ?? false;
          final gradient = gradients[index % gradients.length];

          if (isMatched) {
            return Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.check_circle, color: Colors.white, size: 36),
              ),
            );
          }

          return AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              final offset = index.isEven
                  ? _floatAnimation.value * 0.5
                  : -_floatAnimation.value * 0.5;
              return Transform.translate(
                offset: Offset(0, offset),
                child: child,
              );
            },
            child: Draggable<String>(
              data: item.id,
              onDragStarted: () {
                _speak(item.label);
              },
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  width: 105,
                  height: 125,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: gradient[0].withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -8,
                        right: -8,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              item.emoji,
                              style: const TextStyle(fontSize: 44),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              childWhenDragging: Container(
                width: 95,
                height: 115,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
              ),
              child: Container(
                width: 95,
                height: 115,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Decorative circle
                    Positioned(
                      top: -10,
                      right: -10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    // Emoji in circular container
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            item.emoji,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDropTargets() {
    // Home screen style gradients for targets
    final targetGradients = [
      [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      [const Color(0xFFFFAA5A), const Color(0xFFFF8E53)],
      [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: _shuffledTargets.asMap().entries.map((entry) {
          final index = entry.key;
          final targetId = entry.value;
          final item = _currentItems.firstWhere((i) => i.id == targetId);
          final isMatched = _matchedItems[targetId] ?? false;
          final gradient = targetGradients[index % targetGradients.length];

          return DragTarget<String>(
            onWillAcceptWithDetails: (details) => !isMatched,
            onAcceptWithDetails: (details) {
              _onDragCompleted(details.data, targetId);
            },
            builder: (context, candidateData, rejectedData) {
              final isHovering = candidateData.isNotEmpty;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 150,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  gradient: isMatched
                      ? const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : isHovering
                      ? LinearGradient(
                          colors: [
                            const Color(0xFFFFE66D),
                            const Color(0xFFFFAA5A),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(20),
                  border: isHovering && !isMatched
                      ? Border.all(color: const Color(0xFFFFE66D), width: 3)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: isHovering
                          ? const Color(0xFFFFE66D).withValues(alpha: 0.5)
                          : gradient[0].withValues(alpha: 0.4),
                      blurRadius: isHovering ? 15 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Decorative circle
                    Positioned(
                      top: -15,
                      right: -15,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    // Content
                    Center(
                      child: isMatched
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.emoji,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    item.label,
                                    style: GoogleFonts.nunito(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            )
                          : Text(
                              item.label,
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCelebration() {
    return AnimatedBuilder(
      animation: _celebrationController,
      builder: (context, child) {
        return Stack(
          children: List.generate(20, (index) {
            final random = Random(index);
            final startX =
                random.nextDouble() * MediaQuery.of(context).size.width;
            final endY = MediaQuery.of(context).size.height;
            final emoji = ['⭐', '🎉', '✨', '🌟', '💫'][random.nextInt(5)];

            return Positioned(
              left: startX,
              top: _celebrationController.value * endY - 50,
              child: Opacity(
                opacity: 1 - _celebrationController.value,
                child: Transform.rotate(
                  angle: _celebrationController.value * 4 * pi,
                  child: Text(emoji, style: const TextStyle(fontSize: 30)),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class GameLevel {
  final String title;
  final String instruction;
  final String emoji;
  final List<DragItem> items;

  GameLevel({
    required this.title,
    required this.instruction,
    required this.emoji,
    required this.items,
  });
}

class DragItem {
  final String id;
  final String emoji;
  final String label;

  DragItem({required this.id, required this.emoji, required this.label});
}
