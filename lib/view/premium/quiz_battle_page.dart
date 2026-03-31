import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:async';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class QuizBattlePage extends StatefulWidget {
  const QuizBattlePage({Key? key}) : super(key: key);

  @override
  State<QuizBattlePage> createState() => _QuizBattlePageState();
}

class _QuizBattlePageState extends State<QuizBattlePage>
    with TickerProviderStateMixin {
  // Game State
  bool _gameStarted = false;
  bool _gameEnded = false;
  int _currentQuestion = 0;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  int _timeLeft = 10;
  Timer? _timer;
  String _selectedCategory = 'math';
  String _difficulty = 'easy';
  bool _answered = false;
  bool _isCorrect = false;

  // Animations
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late AnimationController _feedbackController;
  late Animation<double> _floatAnimation;
  late Animation<double> _feedbackAnimation;

  final List<Map<String, dynamic>> _questions = [];
  int? _selectedAnswer;

  final Map<String, Color> categoryColors = {
    'math': const Color(0xFFFF6B6B),
    'science': const Color(0xFF4ECDC4),
    'gk': const Color(0xFFFFAA5A),
    'english': const Color(0xFFA78BFA),
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _feedbackAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _feedbackController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  // Floating bubbles for playful effect
  List<Widget> _buildFloatingBubbles() {
    final random = Random(42);
    return List.generate(12, (index) {
      final size = 20.0 + random.nextDouble() * 50;
      final left = random.nextDouble() * 400;
      final top = random.nextDouble() * 800;
      final delay = random.nextDouble();

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + delay) % 1.0;
          final yOffset = -progress * 200;
          final opacity = (1 - progress) * 0.15;

          return Positioned(
            left: left,
            top: top + yOffset,
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

  void _startGame() {
    _generateQuestions();
    setState(() {
      _gameStarted = true;
      _gameEnded = false;
      _currentQuestion = 0;
      _score = 0;
      _streak = 0;
      _maxStreak = 0;
      _selectedAnswer = null;
      _answered = false;
      _isCorrect = false;
    });
    _startTimer();
  }

  void _generateQuestions() {
    _questions.clear();
    final random = Random();

    if (_selectedCategory == 'math') {
      // Math questions are dynamically generated - generate 60 for consistency
      for (int i = 0; i < 60; i++) {
        _questions.add(_generateMathQuestion(random));
      }
    } else {
      // For other categories, use ALL questions from the pool (shuffled)
      List<Map<String, dynamic>> pool;
      switch (_selectedCategory) {
        case 'science':
          pool = _getSciencePool();
          break;
        case 'gk':
          pool = _getGKPool();
          break;
        case 'english':
          pool = _getEnglishPool();
          break;
        default:
          pool = [];
      }
      pool.shuffle(random);
      for (int i = 0; i < pool.length; i++) {
        final q = pool[i];
        final options = List<String>.from(q['opts'] as List);
        options.shuffle(random);
        _questions.add({
          'question': q['q'],
          'options': options,
          'answer': q['a'],
          'emoji': _selectedCategory == 'science'
              ? '🔬'
              : (_selectedCategory == 'gk' ? '🌍' : '📚'),
        });
      }
    }
  }

  Map<String, dynamic> _generateMathQuestion(Random random) {
    int num1, num2, answer;
    String question;
    List<int> options;

    final maxNum =
        _difficulty == 'easy' ? 10 : (_difficulty == 'medium' ? 20 : 50);
    final operations = _difficulty == 'easy'
        ? ['+', '-']
        : (_difficulty == 'medium'
            ? ['+', '-', '×', '÷']
            : ['+', '-', '×', '÷', '²']);
    final op = operations[random.nextInt(operations.length)];

    num1 = random.nextInt(maxNum) + 1;
    num2 = random.nextInt(maxNum) + 1;

    switch (op) {
      case '+':
        answer = num1 + num2;
        question = '$num1 + $num2 = ?';
        break;
      case '-':
        if (num1 < num2) {
          final temp = num1;
          num1 = num2;
          num2 = temp;
        }
        answer = num1 - num2;
        question = '$num1 - $num2 = ?';
        break;
      case '×':
        num1 = random.nextInt(12) + 1;
        num2 = random.nextInt(12) + 1;
        answer = num1 * num2;
        question = '$num1 × $num2 = ?';
        break;
      case '÷':
        num2 = random.nextInt(10) + 1;
        answer = random.nextInt(10) + 1;
        num1 = num2 * answer;
        question = '$num1 ÷ $num2 = ?';
        break;
      case '²':
        num1 = random.nextInt(12) + 1;
        answer = num1 * num1;
        question = '$num1² = ?';
        break;
      default:
        answer = num1 + num2;
        question = '$num1 + $num2 = ?';
    }

    options = _generateOptions(answer, random);

    return {
      'question': question,
      'options': options,
      'answer': answer,
      'emoji': '🧮',
    };
  }

  List<int> _generateOptions(int answer, Random random) {
    final options = <int>{answer};
    while (options.length < 4) {
      final offset = random.nextInt(10) - 5;
      if (offset != 0) {
        options.add(answer + offset);
      }
    }
    return options.toList()..shuffle();
  }

  List<Map<String, dynamic>> _getSciencePool() {
    return [
      {'q': 'What planet is known as the Red Planet?', 'a': 'Mars', 'opts': ['Mars', 'Venus', 'Jupiter', 'Saturn']},
      {'q': 'What is the largest organ in the human body?', 'a': 'Skin', 'opts': ['Skin', 'Heart', 'Liver', 'Brain']},
      {'q': 'What gas do plants breathe in?', 'a': 'Carbon Dioxide', 'opts': ['Carbon Dioxide', 'Oxygen', 'Nitrogen', 'Hydrogen']},
      {'q': 'How many legs does a spider have?', 'a': '8', 'opts': ['8', '6', '4', '10']},
      {'q': 'What is frozen water called?', 'a': 'Ice', 'opts': ['Ice', 'Steam', 'Vapor', 'Frost']},
      {'q': 'Which planet is closest to the Sun?', 'a': 'Mercury', 'opts': ['Mercury', 'Venus', 'Earth', 'Mars']},
      {'q': 'What do caterpillars turn into?', 'a': 'Butterfly', 'opts': ['Butterfly', 'Bee', 'Bird', 'Beetle']},
      {'q': 'What is the hardest natural substance?', 'a': 'Diamond', 'opts': ['Diamond', 'Gold', 'Iron', 'Silver']},
      {'q': 'How many bones are in the human body?', 'a': '206', 'opts': ['206', '106', '306', '156']},
      {'q': 'What animal is known as man\'s best friend?', 'a': 'Dog', 'opts': ['Dog', 'Cat', 'Horse', 'Rabbit']},
      {'q': 'What is the largest planet in our solar system?', 'a': 'Jupiter', 'opts': ['Jupiter', 'Saturn', 'Neptune', 'Uranus']},
      {'q': 'What is the boiling point of water?', 'a': '100°C', 'opts': ['100°C', '90°C', '110°C', '80°C']},
      {'q': 'Which organ pumps blood in the body?', 'a': 'Heart', 'opts': ['Heart', 'Lungs', 'Brain', 'Liver']},
      {'q': 'What gas do humans breathe out?', 'a': 'Carbon Dioxide', 'opts': ['Carbon Dioxide', 'Oxygen', 'Nitrogen', 'Helium']},
      {'q': 'How many teeth do adults have?', 'a': '32', 'opts': ['32', '28', '30', '36']},
      {'q': 'What is the speed of light?', 'a': '300,000 km/s', 'opts': ['300,000 km/s', '150,000 km/s', '500,000 km/s', '200,000 km/s']},
      {'q': 'Which planet has rings around it?', 'a': 'Saturn', 'opts': ['Saturn', 'Jupiter', 'Mars', 'Neptune']},
      {'q': 'What is the center of an atom called?', 'a': 'Nucleus', 'opts': ['Nucleus', 'Electron', 'Proton', 'Neutron']},
      {'q': 'What force keeps us on the ground?', 'a': 'Gravity', 'opts': ['Gravity', 'Friction', 'Magnetism', 'Inertia']},
      {'q': 'Which animal lays the largest eggs?', 'a': 'Ostrich', 'opts': ['Ostrich', 'Eagle', 'Crocodile', 'Turtle']},
      {'q': 'What is the chemical symbol for water?', 'a': 'H2O', 'opts': ['H2O', 'CO2', 'O2', 'NaCl']},
      {'q': 'How many planets are in our solar system?', 'a': '8', 'opts': ['8', '7', '9', '10']},
      {'q': 'What is the smallest bone in the human body?', 'a': 'Stapes', 'opts': ['Stapes', 'Femur', 'Tibia', 'Radius']},
      {'q': 'Which vitamin comes from sunlight?', 'a': 'Vitamin D', 'opts': ['Vitamin D', 'Vitamin A', 'Vitamin C', 'Vitamin B']},
      {'q': 'What type of animal is a frog?', 'a': 'Amphibian', 'opts': ['Amphibian', 'Reptile', 'Mammal', 'Fish']},
      {'q': 'What makes up about 70% of Earth?', 'a': 'Water', 'opts': ['Water', 'Land', 'Air', 'Ice']},
      {'q': 'Which is the longest bone in the body?', 'a': 'Femur', 'opts': ['Femur', 'Tibia', 'Humerus', 'Spine']},
      {'q': 'What do bees make?', 'a': 'Honey', 'opts': ['Honey', 'Wax', 'Silk', 'Milk']},
      {'q': 'What is the freezing point of water?', 'a': '0°C', 'opts': ['0°C', '-10°C', '10°C', '5°C']},
      {'q': 'Which sense do ears help with?', 'a': 'Hearing', 'opts': ['Hearing', 'Sight', 'Smell', 'Touch']},
      {'q': 'What is baby frog called?', 'a': 'Tadpole', 'opts': ['Tadpole', 'Puppy', 'Calf', 'Cub']},
      {'q': 'Which is the hottest planet?', 'a': 'Venus', 'opts': ['Venus', 'Mercury', 'Mars', 'Jupiter']},
      {'q': 'What do we use to measure temperature?', 'a': 'Thermometer', 'opts': ['Thermometer', 'Barometer', 'Ruler', 'Scale']},
      {'q': 'Which part of the plant makes food?', 'a': 'Leaf', 'opts': ['Leaf', 'Root', 'Stem', 'Flower']},
      {'q': 'What is the process plants use to make food?', 'a': 'Photosynthesis', 'opts': ['Photosynthesis', 'Respiration', 'Digestion', 'Osmosis']},
      {'q': 'How many lungs do humans have?', 'a': '2', 'opts': ['2', '1', '3', '4']},
      {'q': 'What is the closest star to Earth?', 'a': 'Sun', 'opts': ['Sun', 'Sirius', 'Polaris', 'Alpha Centauri']},
      {'q': 'Which animal has the longest neck?', 'a': 'Giraffe', 'opts': ['Giraffe', 'Elephant', 'Ostrich', 'Camel']},
      {'q': 'What is the Earth\'s natural satellite?', 'a': 'Moon', 'opts': ['Moon', 'Sun', 'Mars', 'Star']},
      {'q': 'What type of animal is a snake?', 'a': 'Reptile', 'opts': ['Reptile', 'Amphibian', 'Mammal', 'Insect']},
      {'q': 'What is the main gas in the air we breathe?', 'a': 'Nitrogen', 'opts': ['Nitrogen', 'Oxygen', 'Carbon Dioxide', 'Hydrogen']},
      {'q': 'Which organ helps us see?', 'a': 'Eyes', 'opts': ['Eyes', 'Ears', 'Nose', 'Tongue']},
      {'q': 'What is the largest animal on Earth?', 'a': 'Blue Whale', 'opts': ['Blue Whale', 'Elephant', 'Giraffe', 'Shark']},
      {'q': 'How many chambers does the human heart have?', 'a': '4', 'opts': ['4', '2', '3', '6']},
      {'q': 'What is lava?', 'a': 'Melted rock', 'opts': ['Melted rock', 'Hot water', 'Liquid metal', 'Burning gas']},
      {'q': 'Which bird cannot fly?', 'a': 'Penguin', 'opts': ['Penguin', 'Eagle', 'Parrot', 'Sparrow']},
      {'q': 'What is the study of stars called?', 'a': 'Astronomy', 'opts': ['Astronomy', 'Astrology', 'Biology', 'Geography']},
      {'q': 'Which planet is known as Earth\'s twin?', 'a': 'Venus', 'opts': ['Venus', 'Mars', 'Mercury', 'Jupiter']},
      {'q': 'What do roots do for a plant?', 'a': 'Absorb water', 'opts': ['Absorb water', 'Make food', 'Produce seeds', 'Attract bees']},
      {'q': 'How many senses do humans have?', 'a': '5', 'opts': ['5', '4', '6', '3']},
      {'q': 'What is the chemical symbol for gold?', 'a': 'Au', 'opts': ['Au', 'Ag', 'Go', 'Gd']},
      {'q': 'Which gas is needed for fire to burn?', 'a': 'Oxygen', 'opts': ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen']},
      {'q': 'What is the largest land animal?', 'a': 'Elephant', 'opts': ['Elephant', 'Giraffe', 'Rhino', 'Hippo']},
      {'q': 'What are clouds made of?', 'a': 'Water droplets', 'opts': ['Water droplets', 'Cotton', 'Smoke', 'Dust']},
      {'q': 'Which planet is famous for its Great Red Spot?', 'a': 'Jupiter', 'opts': ['Jupiter', 'Mars', 'Saturn', 'Neptune']},
      {'q': 'What is the main source of energy for Earth?', 'a': 'Sun', 'opts': ['Sun', 'Moon', 'Wind', 'Water']},
      {'q': 'How many legs does an insect have?', 'a': '6', 'opts': ['6', '4', '8', '10']},
      {'q': 'What is the outer layer of Earth called?', 'a': 'Crust', 'opts': ['Crust', 'Mantle', 'Core', 'Surface']},
      {'q': 'Which is the fastest land animal?', 'a': 'Cheetah', 'opts': ['Cheetah', 'Lion', 'Horse', 'Tiger']},
      {'q': 'What is a group of stars called?', 'a': 'Constellation', 'opts': ['Constellation', 'Galaxy', 'Nebula', 'Cluster']},
    ];
  }

  List<Map<String, dynamic>> _getGKPool() {
    return [
      {'q': 'What is the capital of India?', 'a': 'New Delhi', 'opts': ['New Delhi', 'Mumbai', 'Kolkata', 'Chennai']},
      {'q': 'How many colors are in a rainbow?', 'a': '7', 'opts': ['7', '5', '6', '8']},
      {'q': 'Which is the largest ocean?', 'a': 'Pacific', 'opts': ['Pacific', 'Atlantic', 'Indian', 'Arctic']},
      {'q': 'What is the national bird of India?', 'a': 'Peacock', 'opts': ['Peacock', 'Parrot', 'Eagle', 'Sparrow']},
      {'q': 'How many days are in a week?', 'a': '7', 'opts': ['7', '5', '6', '8']},
      {'q': 'What is the national animal of India?', 'a': 'Tiger', 'opts': ['Tiger', 'Lion', 'Elephant', 'Cow']},
      {'q': 'How many months have 31 days?', 'a': '7', 'opts': ['7', '6', '5', '4']},
      {'q': 'Which festival is known as the Festival of Lights?', 'a': 'Diwali', 'opts': ['Diwali', 'Holi', 'Eid', 'Christmas']},
      {'q': 'What is the currency of India?', 'a': 'Rupee', 'opts': ['Rupee', 'Dollar', 'Pound', 'Euro']},
      {'q': 'Which is the smallest continent?', 'a': 'Australia', 'opts': ['Australia', 'Europe', 'Antarctica', 'Africa']},
      {'q': 'What is the capital of USA?', 'a': 'Washington DC', 'opts': ['Washington DC', 'New York', 'Los Angeles', 'Chicago']},
      {'q': 'How many continents are there?', 'a': '7', 'opts': ['7', '5', '6', '8']},
      {'q': 'Which country has the Taj Mahal?', 'a': 'India', 'opts': ['India', 'Pakistan', 'Nepal', 'Bangladesh']},
      {'q': 'What is the national flower of India?', 'a': 'Lotus', 'opts': ['Lotus', 'Rose', 'Sunflower', 'Lily']},
      {'q': 'How many hours are in a day?', 'a': '24', 'opts': ['24', '12', '20', '30']},
      {'q': 'Which is the longest river in the world?', 'a': 'Nile', 'opts': ['Nile', 'Amazon', 'Ganges', 'Yamuna']},
      {'q': 'How many minutes are in an hour?', 'a': '60', 'opts': ['60', '30', '45', '90']},
      {'q': 'What is the national game of India?', 'a': 'Hockey', 'opts': ['Hockey', 'Cricket', 'Football', 'Kabaddi']},
      {'q': 'How many players in a cricket team?', 'a': '11', 'opts': ['11', '9', '10', '12']},
      {'q': 'Which season comes after summer?', 'a': 'Autumn', 'opts': ['Autumn', 'Winter', 'Spring', 'Monsoon']},
      {'q': 'Which season comes after winter?', 'a': 'Spring', 'opts': ['Spring', 'Summer', 'Autumn', 'Monsoon']},
      {'q': 'How many weeks are in a year?', 'a': '52', 'opts': ['52', '50', '48', '54']},
      {'q': 'How many seconds are in a minute?', 'a': '60', 'opts': ['60', '30', '45', '100']},
      {'q': 'What is the capital of Japan?', 'a': 'Tokyo', 'opts': ['Tokyo', 'Osaka', 'Kyoto', 'Beijing']},
      {'q': 'What is the capital of France?', 'a': 'Paris', 'opts': ['Paris', 'London', 'Rome', 'Berlin']},
      {'q': 'Which is the largest country by area?', 'a': 'Russia', 'opts': ['Russia', 'China', 'USA', 'Canada']},
      {'q': 'What color is the stop sign?', 'a': 'Red', 'opts': ['Red', 'Green', 'Blue', 'Yellow']},
      {'q': 'How many months are in a year?', 'a': '12', 'opts': ['12', '10', '11', '13']},
      {'q': 'Which is the tallest building in the world?', 'a': 'Burj Khalifa', 'opts': ['Burj Khalifa', 'Eiffel Tower', 'Big Ben', 'Empire State']},
      {'q': 'What is the national fruit of India?', 'a': 'Mango', 'opts': ['Mango', 'Apple', 'Banana', 'Orange']},
      {'q': 'Which country is famous for Pyramids?', 'a': 'Egypt', 'opts': ['Egypt', 'India', 'China', 'Greece']},
      {'q': 'What is the capital of China?', 'a': 'Beijing', 'opts': ['Beijing', 'Shanghai', 'Tokyo', 'Seoul']},
      {'q': 'Which is the most spoken language?', 'a': 'English', 'opts': ['English', 'Hindi', 'Spanish', 'French']},
      {'q': 'What is the capital of UK?', 'a': 'London', 'opts': ['London', 'Paris', 'Dublin', 'Edinburgh']},
      {'q': 'How many states are in India?', 'a': '28', 'opts': ['28', '29', '30', '27']},
      {'q': 'Which planet is known as Blue Planet?', 'a': 'Earth', 'opts': ['Earth', 'Neptune', 'Uranus', 'Venus']},
      {'q': 'What shape is a football?', 'a': 'Sphere', 'opts': ['Sphere', 'Cube', 'Cylinder', 'Cone']},
      {'q': 'Which animal is called Ship of Desert?', 'a': 'Camel', 'opts': ['Camel', 'Horse', 'Elephant', 'Donkey']},
      {'q': 'Which country gave us the game of chess?', 'a': 'India', 'opts': ['India', 'China', 'Russia', 'England']},
      {'q': 'What is the national tree of India?', 'a': 'Banyan', 'opts': ['Banyan', 'Neem', 'Peepal', 'Mango']},
      {'q': 'Which festival is called Festival of Colors?', 'a': 'Holi', 'opts': ['Holi', 'Diwali', 'Eid', 'Pongal']},
      {'q': 'What is the currency of USA?', 'a': 'Dollar', 'opts': ['Dollar', 'Pound', 'Euro', 'Yen']},
      {'q': 'Which is the largest desert in the world?', 'a': 'Sahara', 'opts': ['Sahara', 'Thar', 'Gobi', 'Kalahari']},
      {'q': 'How many Olympic rings are there?', 'a': '5', 'opts': ['5', '4', '6', '7']},
      {'q': 'Which is the highest mountain in the world?', 'a': 'Mount Everest', 'opts': ['Mount Everest', 'K2', 'Kangchenjunga', 'Makalu']},
      {'q': 'What does Indian flag\'s green color represent?', 'a': 'Fertility', 'opts': ['Fertility', 'Peace', 'Courage', 'Truth']},
      {'q': 'Who was the first Prime Minister of India?', 'a': 'Nehru', 'opts': ['Nehru', 'Gandhi', 'Patel', 'Ambedkar']},
      {'q': 'Which river is called Ganga in India?', 'a': 'Ganges', 'opts': ['Ganges', 'Yamuna', 'Narmada', 'Godavari']},
      {'q': 'What is the capital of Australia?', 'a': 'Canberra', 'opts': ['Canberra', 'Sydney', 'Melbourne', 'Perth']},
      {'q': 'How many legs does a chair usually have?', 'a': '4', 'opts': ['4', '3', '2', '5']},
      {'q': 'Which day comes after Monday?', 'a': 'Tuesday', 'opts': ['Tuesday', 'Wednesday', 'Thursday', 'Sunday']},
      {'q': 'What is the first month of the year?', 'a': 'January', 'opts': ['January', 'February', 'March', 'December']},
      {'q': 'Which instrument is used to measure weight?', 'a': 'Scale', 'opts': ['Scale', 'Ruler', 'Thermometer', 'Clock']},
      {'q': 'What is the national anthem of India?', 'a': 'Jana Gana Mana', 'opts': ['Jana Gana Mana', 'Vande Mataram', 'Sare Jahan Se', 'Jai Ho']},
      {'q': 'Who invented the telephone?', 'a': 'Alexander Bell', 'opts': ['Alexander Bell', 'Edison', 'Newton', 'Tesla']},
      {'q': 'Which is the smallest planet?', 'a': 'Mercury', 'opts': ['Mercury', 'Mars', 'Venus', 'Pluto']},
      {'q': 'What does a barber do?', 'a': 'Cuts hair', 'opts': ['Cuts hair', 'Cooks food', 'Drives bus', 'Teaches']},
      {'q': 'Which animal gives us wool?', 'a': 'Sheep', 'opts': ['Sheep', 'Goat', 'Cow', 'Dog']},
      {'q': 'Which is the largest continent?', 'a': 'Asia', 'opts': ['Asia', 'Africa', 'Europe', 'America']},
      {'q': 'What is the capital of Germany?', 'a': 'Berlin', 'opts': ['Berlin', 'Munich', 'Hamburg', 'Frankfurt']},
    ];
  }

  List<Map<String, dynamic>> _getEnglishPool() {
    return [
      {'q': 'What is the opposite of "Hot"?', 'a': 'Cold', 'opts': ['Cold', 'Warm', 'Cool', 'Wet']},
      {'q': 'What is the plural of "Child"?', 'a': 'Children', 'opts': ['Children', 'Childs', 'Childrens', 'Child']},
      {'q': 'What is the past tense of "Go"?', 'a': 'Went', 'opts': ['Went', 'Goed', 'Gone', 'Going']},
      {'q': 'Which word means "Happy"?', 'a': 'Joyful', 'opts': ['Joyful', 'Sad', 'Angry', 'Tired']},
      {'q': 'What is the opposite of "Big"?', 'a': 'Small', 'opts': ['Small', 'Large', 'Huge', 'Tall']},
      {'q': 'What is a baby dog called?', 'a': 'Puppy', 'opts': ['Puppy', 'Kitten', 'Calf', 'Cub']},
      {'q': 'What rhymes with "Cat"?', 'a': 'Bat', 'opts': ['Bat', 'Dog', 'Cup', 'Sun']},
      {'q': 'What is the opposite of "Day"?', 'a': 'Night', 'opts': ['Night', 'Morning', 'Evening', 'Afternoon']},
      {'q': 'Which is a verb?', 'a': 'Run', 'opts': ['Run', 'Beautiful', 'Red', 'Table']},
      {'q': 'What is a group of fish called?', 'a': 'School', 'opts': ['School', 'Herd', 'Flock', 'Pack']},
      {'q': 'What is the opposite of "Fast"?', 'a': 'Slow', 'opts': ['Slow', 'Quick', 'Rapid', 'Speedy']},
      {'q': 'What is the plural of "Mouse"?', 'a': 'Mice', 'opts': ['Mice', 'Mouses', 'Mices', 'Mouse']},
      {'q': 'What is the past tense of "Eat"?', 'a': 'Ate', 'opts': ['Ate', 'Eated', 'Eaten', 'Eating']},
      {'q': 'What is the opposite of "Happy"?', 'a': 'Sad', 'opts': ['Sad', 'Angry', 'Tired', 'Bored']},
      {'q': 'Which is a noun?', 'a': 'Table', 'opts': ['Table', 'Run', 'Beautiful', 'Quickly']},
      {'q': 'What is a baby cat called?', 'a': 'Kitten', 'opts': ['Kitten', 'Puppy', 'Calf', 'Lamb']},
      {'q': 'What rhymes with "Sun"?', 'a': 'Fun', 'opts': ['Fun', 'Sit', 'Ran', 'Cup']},
      {'q': 'What is the opposite of "Up"?', 'a': 'Down', 'opts': ['Down', 'Over', 'Under', 'Side']},
      {'q': 'Which is an adjective?', 'a': 'Beautiful', 'opts': ['Beautiful', 'Run', 'Table', 'Quickly']},
      {'q': 'What is a group of lions called?', 'a': 'Pride', 'opts': ['Pride', 'Herd', 'Pack', 'Flock']},
      {'q': 'What is the opposite of "Old"?', 'a': 'Young', 'opts': ['Young', 'New', 'Fresh', 'Small']},
      {'q': 'What is the plural of "Tooth"?', 'a': 'Teeth', 'opts': ['Teeth', 'Tooths', 'Teeths', 'Toothes']},
      {'q': 'What is the past tense of "Run"?', 'a': 'Ran', 'opts': ['Ran', 'Runned', 'Running', 'Runed']},
      {'q': 'What is the opposite of "Light"?', 'a': 'Dark', 'opts': ['Dark', 'Bright', 'Dim', 'Heavy']},
      {'q': 'Which word is a color?', 'a': 'Blue', 'opts': ['Blue', 'Walk', 'House', 'Happy']},
      {'q': 'What is a baby cow called?', 'a': 'Calf', 'opts': ['Calf', 'Puppy', 'Kitten', 'Lamb']},
      {'q': 'What rhymes with "Dog"?', 'a': 'Log', 'opts': ['Log', 'Cup', 'Run', 'Sit']},
      {'q': 'What is the opposite of "Open"?', 'a': 'Close', 'opts': ['Close', 'Shut', 'Lock', 'Wide']},
      {'q': 'Which is an adverb?', 'a': 'Quickly', 'opts': ['Quickly', 'Quick', 'Table', 'Red']},
      {'q': 'What is a group of wolves called?', 'a': 'Pack', 'opts': ['Pack', 'Herd', 'Flock', 'Pride']},
      {'q': 'What is the opposite of "Tall"?', 'a': 'Short', 'opts': ['Short', 'Small', 'Tiny', 'Low']},
      {'q': 'What is the plural of "Foot"?', 'a': 'Feet', 'opts': ['Feet', 'Foots', 'Feets', 'Footes']},
      {'q': 'What is the past tense of "See"?', 'a': 'Saw', 'opts': ['Saw', 'Seed', 'Seen', 'Seeing']},
      {'q': 'What is the opposite of "Soft"?', 'a': 'Hard', 'opts': ['Hard', 'Rough', 'Strong', 'Tough']},
      {'q': 'What starts with "A" and keeps doctors away?', 'a': 'Apple', 'opts': ['Apple', 'Ant', 'Air', 'Arm']},
      {'q': 'What is a baby sheep called?', 'a': 'Lamb', 'opts': ['Lamb', 'Calf', 'Kid', 'Foal']},
      {'q': 'What rhymes with "Ball"?', 'a': 'Tall', 'opts': ['Tall', 'Bell', 'Bull', 'Bill']},
      {'q': 'What is the opposite of "Wet"?', 'a': 'Dry', 'opts': ['Dry', 'Cold', 'Hot', 'Warm']},
      {'q': 'Which word means "Very big"?', 'a': 'Huge', 'opts': ['Huge', 'Tiny', 'Small', 'Little']},
      {'q': 'What is a group of cows called?', 'a': 'Herd', 'opts': ['Herd', 'Pack', 'Flock', 'Pride']},
      {'q': 'What is the opposite of "Rich"?', 'a': 'Poor', 'opts': ['Poor', 'Cheap', 'Low', 'Empty']},
      {'q': 'What is the plural of "Man"?', 'a': 'Men', 'opts': ['Men', 'Mans', 'Mens', 'Manes']},
      {'q': 'What is the past tense of "Write"?', 'a': 'Wrote', 'opts': ['Wrote', 'Writed', 'Written', 'Writing']},
      {'q': 'What is the opposite of "Clean"?', 'a': 'Dirty', 'opts': ['Dirty', 'Messy', 'Ugly', 'Dark']},
      {'q': 'Which word means "Angry"?', 'a': 'Furious', 'opts': ['Furious', 'Happy', 'Tired', 'Calm']},
      {'q': 'What is a baby horse called?', 'a': 'Foal', 'opts': ['Foal', 'Calf', 'Lamb', 'Puppy']},
      {'q': 'What rhymes with "Star"?', 'a': 'Car', 'opts': ['Car', 'Sit', 'Run', 'Cup']},
      {'q': 'What is the opposite of "Push"?', 'a': 'Pull', 'opts': ['Pull', 'Press', 'Hit', 'Hold']},
      {'q': 'What is the plural of "Woman"?', 'a': 'Women', 'opts': ['Women', 'Womans', 'Womens', 'Womanes']},
      {'q': 'What is the past tense of "Sing"?', 'a': 'Sang', 'opts': ['Sang', 'Singed', 'Sung', 'Singing']},
      {'q': 'What is the opposite of "Love"?', 'a': 'Hate', 'opts': ['Hate', 'Like', 'Angry', 'Fear']},
      {'q': 'Which word means "Scared"?', 'a': 'Afraid', 'opts': ['Afraid', 'Brave', 'Happy', 'Strong']},
      {'q': 'What is the opposite of "Start"?', 'a': 'Stop', 'opts': ['Stop', 'End', 'Finish', 'Break']},
      {'q': 'What is a group of birds called?', 'a': 'Flock', 'opts': ['Flock', 'Herd', 'Pack', 'School']},
      {'q': 'What is the past tense of "Buy"?', 'a': 'Bought', 'opts': ['Bought', 'Buyed', 'Buying', 'Buyd']},
      {'q': 'What is the opposite of "Laugh"?', 'a': 'Cry', 'opts': ['Cry', 'Smile', 'Shout', 'Whisper']},
      {'q': 'Which word means "Very small"?', 'a': 'Tiny', 'opts': ['Tiny', 'Huge', 'Big', 'Large']},
      {'q': 'What rhymes with "Book"?', 'a': 'Cook', 'opts': ['Cook', 'Back', 'Bike', 'Bank']},
      {'q': 'What is the past tense of "Drink"?', 'a': 'Drank', 'opts': ['Drank', 'Drinked', 'Drunk', 'Drinking']},
      {'q': 'What is the opposite of "Full"?', 'a': 'Empty', 'opts': ['Empty', 'Half', 'Low', 'Less']},
    ];
  }

  void _startTimer() {
    _timeLeft =
        _difficulty == 'easy' ? 15 : (_difficulty == 'medium' ? 10 : 7);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    _timer?.cancel();
    setState(() {
      _streak = 0;
      _answered = true;
      _isCorrect = false;
    });
    _feedbackController.forward(from: 0);
  }

  void _selectAnswer(dynamic answer) {
    if (_answered) return;

    _timer?.cancel();
    final question = _questions[_currentQuestion];
    final correct = answer.toString() == question['answer'].toString();

    setState(() {
      _selectedAnswer = _questions[_currentQuestion]['options'].indexOf(answer);
      _answered = true;
      _isCorrect = correct;
      if (correct) {
        _score += 10 + (_streak * 2) + _timeLeft;
        _streak++;
        if (_streak > _maxStreak) _maxStreak = _streak;
      } else {
        _streak = 0;
      }
    });
    _feedbackController.forward(from: 0);
  }

  void _goToNextQuestion() {
    if (!_answered) return;

    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
        _answered = false;
        _isCorrect = false;
      });
      _startTimer();
    } else {
      _endGame();
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestion > 0) {
      _timer?.cancel();
      setState(() {
        _currentQuestion--;
        _selectedAnswer = null;
        _answered = false;
        _isCorrect = false;
      });
      _startTimer();
    }
  }

  void _clearAndTryAgain() {
    setState(() {
      _answered = false;
      _isCorrect = false;
      _selectedAnswer = null;
    });
    _startTimer();
  }

  void _endGame() {
    _timer?.cancel();
    setState(() {
      _gameEnded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_gameStarted,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _gameStarted) {
          _timer?.cancel();
          setState(() {
            _gameStarted = false;
            _gameEnded = false;
          });
        }
      },
      child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
          onPressed: () {
            if (_gameStarted) {
              _timer?.cancel();
              setState(() {
                _gameStarted = false;
                _gameEnded = false;
              });
            } else {
              Get.back();
            }
          },
        ),
        actions: [
          if (_gameStarted && !_gameEnded)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    const Icon(Icons.refresh, color: Colors.white, size: 20),
              ),
              onPressed: _startGame,
            ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF6B6B),
                Color(0xFFFF8E53),
                Color(0xFFFFAA5A)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        title: Text(
          "Quiz Battle",
          style: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFf5576c),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated floating bubbles background
            ..._buildFloatingBubbles(),

            // Main content
            SafeArea(
              child: _gameEnded
                  ? _buildResultScreen()
                  : (_gameStarted
                      ? _buildQuizScreen()
                      : _buildStartScreen()),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    ),
    );
  }

  Widget _buildStartScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Title Card with floating animation
          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value * 0.3),
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child:
                        const Text("⚔️", style: TextStyle(fontSize: 80)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Quiz Battle',
                    style: GoogleFonts.baloo2(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Test your knowledge and beat the clock!',
                    style: GoogleFonts.nunito(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Category Selection
          _buildSectionTitle('Select Category'),
          const SizedBox(height: 12),
          _buildCategoryGrid(),
          const SizedBox(height: 24),
          // Difficulty Selection
          _buildSectionTitle('Select Difficulty'),
          const SizedBox(height: 12),
          _buildDifficultySelector(),
          const SizedBox(height: 32),
          // Start Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: categoryColors[_selectedCategory],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'START BATTLE',
                    style: GoogleFonts.baloo2(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.baloo2(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'id': 'math', 'name': 'Math', 'icon': '🧮', 'count': '∞'},
      {'id': 'science', 'name': 'Science', 'icon': '🔬', 'count': '${_getSciencePool().length}'},
      {'id': 'gk', 'name': 'GK', 'icon': '🌍', 'count': '${_getGKPool().length}'},
      {'id': 'english', 'name': 'English', 'icon': '📚', 'count': '${_getEnglishPool().length}'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = _selectedCategory == cat['id'];
        final color = categoryColors[cat['id']]!;

        return AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            final floatOffset = (index % 2 == 0)
                ? _floatAnimation.value * 0.3
                : -_floatAnimation.value * 0.3;
            return Transform.translate(
              offset: Offset(0, floatOffset),
              child: child,
            );
          },
          child: GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat['id']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border:
                    isSelected ? null : Border.all(color: Colors.white30),
                boxShadow: [
                  BoxShadow(
                    color: (isSelected ? color : Colors.black)
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cat['icon']!,
                          style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Text(
                        cat['name']!,
                        style: GoogleFonts.nunito(
                          color: isSelected ? Colors.white : color,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${cat['count']} Questions',
                    style: GoogleFonts.nunito(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.8)
                          : color.withValues(alpha: 0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDifficultySelector() {
    final difficulties = [
      {'id': 'easy', 'name': 'Easy', 'icon': '😊'},
      {'id': 'medium', 'name': 'Medium', 'icon': '😐'},
      {'id': 'hard', 'name': 'Hard', 'icon': '😤'},
    ];

    return Row(
      children: difficulties.map((diff) {
        final isSelected = _difficulty == diff['id'];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _difficulty = diff['id']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                right: diff['id'] != 'hard' ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(diff['icon']!,
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(
                    diff['name']!,
                    style: GoogleFonts.nunito(
                      color:
                          isSelected ? Colors.black87 : Colors.white,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuizScreen() {
    final question = _questions[_currentQuestion];
    final options = question['options'] as List;
    final progress = (_currentQuestion + 1) / _questions.length;
    final progressPercent = (progress * 100).toInt();

    return Column(
      children: [
        // Progress Bar with percentage
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentQuestion + 1} of ${_questions.length}',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      // Timer badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _timeLeft <= 3
                              ? Colors.red.withValues(alpha: 0.8)
                              : Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$_timeLeft s',
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Progress badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$progressPercent%',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 6),
              // Score & Streak row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '⭐ Score: $_score',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '🔥 Streak: $_streak',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Question Card with floating animation
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value * 0.3),
              child: child,
            );
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(question['emoji'],
                    style: const TextStyle(fontSize: 36)),
                const SizedBox(height: 10),
                Text(
                  question['question'],
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Options as 2x2 animated grid cards
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = _selectedAnswer == index;
                      final isCorrectOption = option.toString() ==
                          question['answer'].toString();
                      final showResult = _answered;
                      final optionLabels = ['A', 'B', 'C', 'D'];

                      // Card gradient colors
                      final List<List<Color>> cardGradients = [
                        [
                          const Color(0xFFFF6B6B),
                          const Color(0xFFFF8E53),
                        ],
                        [
                          const Color(0xFF4ECDC4),
                          const Color(0xFF44A08D),
                        ],
                        [
                          const Color(0xFFa18cd1),
                          const Color(0xFFfbc2eb),
                        ],
                        [
                          const Color(0xFFFFD700),
                          const Color(0xFFFFA500),
                        ],
                      ];

                      List<Color> gradientColors = cardGradients[index];

                      if (showResult) {
                        if (isCorrectOption) {
                          gradientColors = [
                            const Color(0xFF56D97F),
                            const Color(0xFF11998E),
                          ];
                        } else if (isSelected) {
                          gradientColors = [
                            const Color(0xFFFF4444),
                            const Color(0xFFCC0000),
                          ];
                        }
                      }

                      return AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          final floatOffset = (index % 2 == 0)
                              ? _floatAnimation.value * 0.5
                              : -_floatAnimation.value * 0.5;
                          return Transform.translate(
                            offset: Offset(0, floatOffset),
                            child: child,
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            TtsService.to.speak(option);
                            _selectAnswer(option);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: gradientColors[0]
                                      .withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Decorative circle
                                Positioned(
                                  top: -15,
                                  right: -15,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white
                                          .withValues(alpha: 0.15),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -10,
                                  left: -10,
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white
                                          .withValues(alpha: 0.1),
                                    ),
                                  ),
                                ),
                                // Content
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Option label circle
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: Colors.white
                                                .withValues(alpha: 0.3),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: showResult &&
                                                    (isCorrectOption ||
                                                        isSelected)
                                                ? Icon(
                                                    isCorrectOption
                                                        ? Icons
                                                            .check_circle
                                                        : Icons.cancel,
                                                    color: Colors.white,
                                                    size: 24,
                                                  )
                                                : Text(
                                                    optionLabels[index],
                                                    style:
                                                        GoogleFonts.baloo2(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Option text
                                        Text(
                                          option.toString(),
                                          style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow:
                                              TextOverflow.ellipsis,
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
                    },
                  ),
                ),

                // Feedback message
                if (_answered)
                  AnimatedBuilder(
                    animation: _feedbackAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _feedbackAnimation.value,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _isCorrect ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _isCorrect
                                ? '✓ Correct! Great job!'
                                : _timeLeft == 0
                                    ? '⏰ Time\'s up!'
                                    : '✗ Wrong!',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),

        // Navigation buttons - Previous, Refresh, Next
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              // Previous button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _currentQuestion > 0
                      ? _goToPreviousQuestion
                      : null,
                  icon: const Icon(Icons.arrow_back_ios, size: 16),
                  label: Text(
                    'Previous',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.white.withValues(alpha: 0.9),
                    foregroundColor: const Color(0xFF667EEA),
                    disabledBackgroundColor:
                        Colors.white.withValues(alpha: 0.3),
                    disabledForegroundColor:
                        Colors.white.withValues(alpha: 0.5),
                    padding:
                        const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Refresh button
              ElevatedButton(
                onPressed: _answered ? _clearAndTryAgain : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      Colors.white.withValues(alpha: 0.3),
                  disabledForegroundColor:
                      Colors.white.withValues(alpha: 0.5),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: const Size(48, 48),
                ),
                child:
                    const Icon(Icons.refresh_rounded, size: 22),
              ),
              const SizedBox(width: 8),
              // Next button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _answered ? _goToNextQuestion : null,
                  icon: Text(
                    _currentQuestion == _questions.length - 1
                        ? 'Finish'
                        : 'Next',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  label: const Icon(Icons.arrow_forward_ios,
                      size: 16),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF56D97F),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        Colors.grey.withValues(alpha: 0.5),
                    disabledForegroundColor:
                        Colors.white.withValues(alpha: 0.5),
                    padding:
                        const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    final maxScore = _questions.length * 20;
    final percentage = (_score / maxScore * 100).clamp(0, 100).round();
    String grade;
    String emoji;
    Color gradeColor;

    if (percentage >= 90) {
      grade = 'EXCELLENT';
      emoji = '🏆';
      gradeColor = Colors.amber;
    } else if (percentage >= 70) {
      grade = 'GREAT';
      emoji = '⭐';
      gradeColor = Colors.green;
    } else if (percentage >= 50) {
      grade = 'GOOD';
      emoji = '👍';
      gradeColor = Colors.blue;
    } else {
      grade = 'KEEP TRYING';
      emoji = '💪';
      gradeColor = Colors.orange;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value * 0.3),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 80)),
                const SizedBox(height: 16),
                Text(
                  grade,
                  style: GoogleFonts.baloo2(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: gradeColor,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '$_score',
                  style: GoogleFonts.baloo2(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'POINTS',
                  style: GoogleFonts.nunito(
                    color: Colors.grey,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildResultStat('Max Streak', '🔥 $_maxStreak'),
                    Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.shade300),
                    _buildResultStat('Accuracy', '$percentage%'),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _gameStarted = false;
                            _gameEnded = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Menu',
                            style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _startGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              categoryColors[_selectedCategory],
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Play Again',
                            style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.baloo2(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.nunito(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
