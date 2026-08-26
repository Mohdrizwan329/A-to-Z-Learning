import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class DiscoveryLearningPage extends StatefulWidget {
  const DiscoveryLearningPage({super.key});

  @override
  State<DiscoveryLearningPage> createState() => _DiscoveryLearningPageState();
}

class _DiscoveryLearningPageState extends State<DiscoveryLearningPage>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  final GetStorage _box = GetStorage();
  int _currentTopic = 0;

  // Track visited items per topic
  final Map<int, Set<int>> _visitedItems = {};

  final List<DiscoveryTopic> _topics = [
    DiscoveryTopic(
      name: 'How Things Work',
      emoji: '⚙️',
      questions: [
        DiscoveryQuestion(
          'Why is the sky blue?',
          '🌤️',
          'Sunlight bounces off tiny bits in the air and blue light bounces the most!',
          'On Mars, the sky is pink!',
        ),
        DiscoveryQuestion(
          'Why do birds fly?',
          '🐦',
          'Birds have light bones and strong wings that push air down!',
          'Penguins are birds but cannot fly!',
        ),
        DiscoveryQuestion(
          'Why does ice float?',
          '🧊',
          'Ice is lighter than water because it has tiny air bubbles!',
          'Only the tip of an iceberg is visible!',
        ),
        DiscoveryQuestion(
          'Why do we have shadows?',
          '👤',
          'When light cannot pass through you, it creates a dark shape!',
          'Your shadow is longest in the morning!',
        ),
        DiscoveryQuestion(
          'How do magnets work?',
          '🧲',
          'Magnets have invisible force fields that pull certain metals!',
          'Earth itself is a giant magnet!',
        ),
        DiscoveryQuestion(
          'Why do things fall down?',
          '🍎',
          'Gravity pulls everything toward the center of Earth!',
          'On the Moon, you would weigh less!',
        ),
        DiscoveryQuestion(
          'How do airplanes fly?',
          '✈️',
          'Wings push air down and the plane goes up!',
          'The first airplane flight was only 12 seconds!',
        ),
        DiscoveryQuestion(
          'Why do boats float?',
          '🚢',
          'Boats push water aside and water pushes back to hold them up!',
          'Even heavy ships float because of their shape!',
        ),
        DiscoveryQuestion(
          'How do batteries work?',
          '🔋',
          'Batteries store energy and release it when needed!',
          'The first battery was invented over 200 years ago!',
        ),
        DiscoveryQuestion(
          'Why do wheels roll?',
          '🛞',
          'Wheels reduce friction and make things easier to move!',
          'The wheel was invented about 5500 years ago!',
        ),
        DiscoveryQuestion(
          'How do mirrors work?',
          '🪞',
          'Mirrors reflect light back to your eyes to show your image!',
          'Ancient mirrors were made of polished metal!',
        ),
        DiscoveryQuestion(
          'Why is fire hot?',
          '🔥',
          'Fire releases energy stored in fuel as heat and light!',
          'Fire needs oxygen to burn!',
        ),
        DiscoveryQuestion(
          'How do clocks work?',
          '🕐',
          'Clocks count regular movements to measure time!',
          'The first clocks used the Sun and shadows!',
        ),
        DiscoveryQuestion(
          'Why do bubbles pop?',
          '��',
          'Bubbles pop when the water film gets too thin!',
          'Bubbles are always round because of surface tension!',
        ),
        DiscoveryQuestion(
          'How does sound travel?',
          '🔊',
          'Sound travels as vibrations through air, water, and solids!',
          'Sound travels faster in water than in air!',
        ),
        DiscoveryQuestion(
          'Why do colors mix?',
          '🎨',
          'Colors combine to create new colors based on light or pigment!',
          'Red, blue, and yellow are primary colors!',
        ),
        DiscoveryQuestion(
          'How do phones work?',
          '📱',
          'Phones send signals through the air to towers and other phones!',
          'The first phone call was made in 1876!',
        ),
        DiscoveryQuestion(
          'Why does metal shine?',
          '✨',
          'Metal reflects light very well, making it look shiny!',
          'Gold never rusts or tarnishes!',
        ),
        DiscoveryQuestion(
          'How do bridges stay up?',
          '🌉',
          'Bridges balance forces and spread weight evenly!',
          'The longest bridge is over 100 miles long!',
        ),
        DiscoveryQuestion(
          'Why does water evaporate?',
          '💨',
          'Heat gives water molecules energy to escape into the air!',
          'Water vapor is invisible!',
        ),
      ],
    ),
    DiscoveryTopic(
      name: 'Nature Secrets',
      emoji: '🌿',
      questions: [
        DiscoveryQuestion(
          'Why do leaves fall?',
          '🍂',
          'Trees rest in winter and drop leaves to save energy!',
          'Some trees keep leaves all year - evergreens!',
        ),
        DiscoveryQuestion(
          'Why do flowers smell nice?',
          '🌸',
          'Flowers smell nice to attract bees and butterflies!',
          'Bees can smell flowers from far away!',
        ),
        DiscoveryQuestion(
          'Why does it rain?',
          '🌧️',
          'Water from oceans goes up to clouds and falls back down!',
          'The same water has been on Earth for millions of years!',
        ),
        DiscoveryQuestion(
          'Why is grass green?',
          '🌱',
          'Plants have something called chlorophyll that makes them green!',
          'Plants use sunlight to make their food!',
        ),
        DiscoveryQuestion(
          'Why do bees make honey?',
          '🍯',
          'Bees make honey from flower nectar to eat in winter!',
          'One bee makes only a tiny bit of honey in its life!',
        ),
        DiscoveryQuestion(
          'Why do volcanoes erupt?',
          '🌋',
          'Hot melted rock from deep inside Earth pushes up and out!',
          'There are volcanoes on other planets too!',
        ),
        DiscoveryQuestion(
          'Why do mountains exist?',
          '🏔️',
          'Earth plates push together and land rises up to form mountains!',
          'Mount Everest is still growing taller!',
        ),
        DiscoveryQuestion(
          'Why is the ocean salty?',
          '🌊',
          'Rivers carry minerals and salt into the ocean over millions of years!',
          'You cannot drink ocean water!',
        ),
        DiscoveryQuestion(
          'Why do earthquakes happen?',
          '🌍',
          'Earth plates move and bump into each other causing shaking!',
          'There are thousands of earthquakes every day!',
        ),
        DiscoveryQuestion(
          'Why do deserts have sand?',
          '🏜️',
          'Wind and water break rocks into tiny sand particles!',
          'Not all deserts are hot - some are cold!',
        ),
        DiscoveryQuestion(
          'Why do trees grow tall?',
          '🌲',
          'Trees grow tall to reach sunlight above other plants!',
          'The tallest tree is over 300 feet tall!',
        ),
        DiscoveryQuestion(
          'Why does snow form?',
          '❄️',
          'Water vapor freezes into ice crystals in cold clouds!',
          'Every snowflake is unique!',
        ),
        DiscoveryQuestion(
          'Why do rivers flow?',
          '🏞️',
          'Gravity pulls water downhill from mountains to oceans!',
          'The Nile is the longest river in the world!',
        ),
        DiscoveryQuestion(
          'Why are caves dark?',
          '🦇',
          'Light cannot reach deep inside caves!',
          'Some caves have crystals inside!',
        ),
        DiscoveryQuestion(
          'Why do we have seasons?',
          '🌸',
          'Earth tilts as it orbits the Sun creating different seasons!',
          'When it is summer here, it is winter somewhere else!',
        ),
        DiscoveryQuestion(
          'Why does lightning happen?',
          '⚡',
          'Electric charges in clouds jump to the ground as lightning!',
          'Lightning is hotter than the surface of the Sun!',
        ),
        DiscoveryQuestion(
          'Why are rainbows curved?',
          '🌈',
          'Light bends in raindrops and forms an arc shape!',
          'You can see a full circle rainbow from an airplane!',
        ),
        DiscoveryQuestion(
          'Why do rocks have colors?',
          '🪨',
          'Different minerals inside rocks give them different colors!',
          'Rubies and sapphires are colored rocks!',
        ),
        DiscoveryQuestion(
          'Why do ponds have algae?',
          '🟢',
          'Algae grows where there is water and sunlight!',
          'Algae produces most of Earths oxygen!',
        ),
        DiscoveryQuestion(
          'Why do waterfalls form?',
          '💧',
          'Rivers flow over cliffs and the water falls down!',
          'Niagara Falls is one of the most famous waterfalls!',
        ),
      ],
    ),
    DiscoveryTopic(
      name: 'Animal Wonders',
      emoji: '🦋',
      questions: [
        DiscoveryQuestion(
          'Why do cats purr?',
          '🐱',
          'Cats purr when they are happy or want to feel calm!',
          'Big cats like lions cannot purr!',
        ),
        DiscoveryQuestion(
          'Why do dogs wag tails?',
          '🐕',
          'Dogs wag their tails to show they are happy to see you!',
          'Dogs wag right when happy, left when nervous!',
        ),
        DiscoveryQuestion(
          'Why do fireflies glow?',
          '✨',
          'Fireflies have a special light to find friends at night!',
          'Firefly light makes no heat - its cold light!',
        ),
        DiscoveryQuestion(
          'Why do zebras have stripes?',
          '🦓',
          'Stripes confuse lions and keep flies away!',
          'Every zebra has different stripes - like fingerprints!',
        ),
        DiscoveryQuestion(
          'Why do elephants have big ears?',
          '🐘',
          'Big ears help elephants cool down in hot weather!',
          'Elephants can hear other elephants from miles away!',
        ),
        DiscoveryQuestion(
          'Why do fish have scales?',
          '🐟',
          'Scales protect fish like armor and help them swim faster!',
          'Some fish scales can be used to make lipstick!',
        ),
        DiscoveryQuestion(
          'Why do birds sing?',
          '🐦',
          'Birds sing to attract mates and mark their territory!',
          'Some birds can mimic human speech!',
        ),
        DiscoveryQuestion(
          'Why do snakes shed skin?',
          '🐍',
          'Snakes shed skin because they outgrow it as they get bigger!',
          'Snakes shed skin several times a year!',
        ),
        DiscoveryQuestion(
          'Why do bats hang upside down?',
          '🦇',
          'Bats hang to take off quickly and stay safe from predators!',
          'Bats are the only mammals that can fly!',
        ),
        DiscoveryQuestion(
          'Why do dolphins jump?',
          '🐬',
          'Dolphins jump to breathe, play, and communicate!',
          'Dolphins sleep with one eye open!',
        ),
        DiscoveryQuestion(
          'Why do chameleons change color?',
          '🦎',
          'Chameleons change color to communicate and control body temperature!',
          'Color change happens in seconds!',
        ),
        DiscoveryQuestion(
          'Why do owls hoot?',
          '🦉',
          'Owls hoot to talk to other owls and claim territory!',
          'Owls can turn their heads almost all the way around!',
        ),
        DiscoveryQuestion(
          'Why do rabbits hop?',
          '🐰',
          'Hopping is faster and helps rabbits escape from predators!',
          'Rabbits can see almost 360 degrees around them!',
        ),
        DiscoveryQuestion(
          'Why do turtles have shells?',
          '🐢',
          'Shells protect turtles from predators like armor!',
          'A turtles shell is part of its skeleton!',
        ),
        DiscoveryQuestion(
          'Why do peacocks show feathers?',
          '🦚',
          'Male peacocks display feathers to attract female mates!',
          'Peacock feathers have eye-like spots!',
        ),
        DiscoveryQuestion(
          'Why do giraffes have long necks?',
          '🦒',
          'Long necks help giraffes eat leaves high in trees!',
          'Giraffes have the same number of neck bones as humans!',
        ),
        DiscoveryQuestion(
          'Why do penguins waddle?',
          '🐧',
          'Penguins waddle because their legs are set far back!',
          'Emperor penguins can dive over 1000 feet deep!',
        ),
        DiscoveryQuestion(
          'Why do kangaroos have pouches?',
          '🦘',
          'Pouches keep baby kangaroos safe and warm!',
          'Baby kangaroos are called joeys!',
        ),
        DiscoveryQuestion(
          'Why do bears hibernate?',
          '🐻',
          'Bears sleep through winter when food is scarce!',
          'Bears can go months without eating during hibernation!',
        ),
        DiscoveryQuestion(
          'Why do whales sing?',
          '🐋',
          'Whales sing to communicate with other whales far away!',
          'Whale songs can travel thousands of miles!',
        ),
      ],
    ),
    DiscoveryTopic(
      name: 'Body Facts',
      emoji: '🧠',
      questions: [
        DiscoveryQuestion(
          'Why do we yawn?',
          '🥱',
          'Yawning sends more oxygen to your brain to wake it up!',
          'Yawns are contagious - seeing one makes you yawn!',
        ),
        DiscoveryQuestion(
          'Why do we dream?',
          '💭',
          'Dreams help our brain sort and remember things!',
          'We forget most dreams within 5 minutes of waking!',
        ),
        DiscoveryQuestion(
          'Why do we get hiccups?',
          '😮',
          'Hiccups happen when a muscle under your lungs jumps!',
          'Drinking water upside down can stop hiccups!',
        ),
        DiscoveryQuestion(
          'Why do we blink?',
          '👁️',
          'Blinking keeps your eyes wet and clean!',
          'You blink about 15 times every minute!',
        ),
        DiscoveryQuestion(
          'Why do we sneeze?',
          '🤧',
          'Sneezing pushes out germs and dust from your nose!',
          'Sneezes can travel at 100 miles per hour!',
        ),
        DiscoveryQuestion(
          'Why do we have fingerprints?',
          '👆',
          'Fingerprints help us grip things better!',
          'No two people have the same fingerprints!',
        ),
        DiscoveryQuestion(
          'Why do we sweat?',
          '💦',
          'Sweating cools your body down when you are hot!',
          'You sweat about a cup of water every day!',
        ),
        DiscoveryQuestion(
          'Why do we get goosebumps?',
          '🥶',
          'Tiny muscles pull your hair up when you are cold or scared!',
          'Animals get goosebumps to look bigger!',
        ),
        DiscoveryQuestion(
          'Why do we have teeth?',
          '🦷',
          'Teeth help us bite, chew, and grind food!',
          'You get two sets of teeth in your lifetime!',
        ),
        DiscoveryQuestion(
          'Why does our heart beat?',
          '❤️',
          'Your heart pumps blood to every part of your body!',
          'Your heart beats about 100,000 times a day!',
        ),
        DiscoveryQuestion(
          'Why do we have eyebrows?',
          '🤨',
          'Eyebrows keep sweat and rain out of your eyes!',
          'Eyebrows help us show emotions!',
        ),
        DiscoveryQuestion(
          'Why do we get tired?',
          '😴',
          'Your body and brain need rest to recharge energy!',
          'You spend one-third of your life sleeping!',
        ),
        DiscoveryQuestion(
          'Why do we have tummy rumbles?',
          '🤭',
          'Your stomach muscles squeeze air and food around!',
          'Tummy rumbles happen even when you are full!',
        ),
        DiscoveryQuestion(
          'Why do cuts heal?',
          '🩹',
          'Your blood clots and skin cells grow to fix the wound!',
          'Your body is always repairing itself!',
        ),
        DiscoveryQuestion(
          'Why do we have nails?',
          '💅',
          'Nails protect the tips of your fingers and toes!',
          'Fingernails grow faster than toenails!',
        ),
        DiscoveryQuestion(
          'Why do we have bones?',
          '🦴',
          'Bones give your body shape and protect organs!',
          'Babies have more bones than adults!',
        ),
        DiscoveryQuestion(
          'Why do we breathe?',
          '😤',
          'Breathing brings oxygen to your blood and removes carbon dioxide!',
          'You breathe about 20,000 times a day!',
        ),
        DiscoveryQuestion(
          'Why do we have taste buds?',
          '👅',
          'Taste buds help you enjoy food and avoid bad things!',
          'You have about 10,000 taste buds!',
        ),
        DiscoveryQuestion(
          'Why do we shiver?',
          '🥶',
          'Shivering makes muscles work to warm your body!',
          'Shivering can warm you up quickly!',
        ),
        DiscoveryQuestion(
          'Why do we have ears?',
          '👂',
          'Ears collect sound waves and send them to your brain!',
          'Your ears also help you balance!',
        ),
      ],
    ),
    DiscoveryTopic(
      name: 'Space Mysteries',
      emoji: '🌟',
      questions: [
        DiscoveryQuestion(
          'Why do stars twinkle?',
          '⭐',
          'Stars look like they twinkle because air moves around them!',
          'Stars in space dont actually twinkle!',
        ),
        DiscoveryQuestion(
          'Why is the Moon round?',
          '🌙',
          'Gravity pulls everything equally to make a ball shape!',
          'The Moon is slowly moving away from Earth!',
        ),
        DiscoveryQuestion(
          'Why is space dark?',
          '🌌',
          'Space is dark because there is nothing for light to bounce off!',
          'Space is not completely dark - it has faint light!',
        ),
        DiscoveryQuestion(
          'What makes a shooting star?',
          '🌠',
          'Shooting stars are rocks that burn up in our atmosphere!',
          'You can wish on them - but they are not real stars!',
        ),
        DiscoveryQuestion(
          'Why does the Sun rise?',
          '🌅',
          'Earth spins around, making the Sun seem to rise and set!',
          'The Sun is actually a star!',
        ),
        DiscoveryQuestion(
          'What are planets made of?',
          '🪐',
          'Some planets are rocky like Earth, others are gas giants!',
          'Jupiter is so big, 1000 Earths could fit inside!',
        ),
        DiscoveryQuestion(
          'Why do we have day and night?',
          '🌓',
          'Earth spins and one side faces the Sun while the other is dark!',
          'A day on Venus is longer than a year on Venus!',
        ),
        DiscoveryQuestion(
          'Why is Mars red?',
          '🔴',
          'Mars has rusty iron in its soil that makes it look red!',
          'Mars has the biggest volcano in our solar system!',
        ),
        DiscoveryQuestion(
          'What are asteroids?',
          '☄️',
          'Asteroids are rocky leftovers from when planets formed!',
          'An asteroid belt exists between Mars and Jupiter!',
        ),
        DiscoveryQuestion(
          'Why does Saturn have rings?',
          '🪐',
          'Saturn rings are made of ice, rock, and dust orbiting it!',
          'Saturn is not the only planet with rings!',
        ),
        DiscoveryQuestion(
          'What is a galaxy?',
          '🌌',
          'A galaxy is a huge collection of stars, planets, and dust!',
          'Our galaxy is called the Milky Way!',
        ),
        DiscoveryQuestion(
          'Why do astronauts float?',
          '👨‍🚀',
          'In space, there is very little gravity to pull them down!',
          'Astronauts grow taller in space!',
        ),
        DiscoveryQuestion(
          'How far is the Sun?',
          '☀️',
          'The Sun is about 93 million miles away from Earth!',
          'Light from the Sun takes 8 minutes to reach us!',
        ),
        DiscoveryQuestion(
          'What is a black hole?',
          '⚫',
          'A black hole is a place where gravity is super strong!',
          'Nothing can escape a black hole, not even light!',
        ),
        DiscoveryQuestion(
          'Why does the Moon have craters?',
          '🌑',
          'Rocks from space crashed into the Moon over billions of years!',
          'The Moon has no wind to erase the craters!',
        ),
        DiscoveryQuestion(
          'What is a comet?',
          '☄️',
          'A comet is a ball of ice and dust with a glowing tail!',
          'Some comets take thousands of years to orbit the Sun!',
        ),
        DiscoveryQuestion(
          'How do rockets work?',
          '🚀',
          'Rockets push gas out the bottom to fly up!',
          'Rockets can travel over 17,000 miles per hour!',
        ),
        DiscoveryQuestion(
          'Is there water on other planets?',
          '💧',
          'Mars and some moons have frozen water!',
          'Europa, a moon of Jupiter, may have an ocean!',
        ),
        DiscoveryQuestion(
          'How many moons does Jupiter have?',
          '🌙',
          'Jupiter has over 90 moons!',
          'Ganymede is bigger than the planet Mercury!',
        ),
        DiscoveryQuestion(
          'What is the Milky Way?',
          '🌌',
          'The Milky Way is our home galaxy with billions of stars!',
          'You can see the Milky Way on dark nights!',
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
    _tabController = TabController(length: _topics.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentTopic = _tabController.index);
        _speak(_topics[_tabController.index].name);
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
    for (int i = 0; i < _topics.length; i++) {
      final saved = _box.read<List>('discovery_progress_$i');
      if (saved != null) {
        _visitedItems[i] = saved.map((e) => e as int).toSet();
      } else {
        _visitedItems[i] = {};
      }
    }
  }

  void _markItemVisited(int topicIndex, int itemIndex) {
    _visitedItems[topicIndex] ??= {};
    if (!_visitedItems[topicIndex]!.contains(itemIndex)) {
      setState(() {
        _visitedItems[topicIndex]!.add(itemIndex);
      });
      _box.write(
        'discovery_progress_$topicIndex',
        _visitedItems[topicIndex]!.toList(),
      );
    }
  }

  int get _totalItems {
    int total = 0;
    for (var topic in _topics) {
      total += topic.questions.length;
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
      for (int i = 0; i < _topics.length; i++) {
        _visitedItems[i] = {};
        _box.remove('discovery_progress_$i');
      }
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

  void _onItemTap(DiscoveryQuestion question, int itemIndex) {
    TtsService.to.speak(question.question);
    HapticFeedback.mediumImpact();
    _speak(question.answer);
    _markItemVisited(_currentTopic, itemIndex);
    _showItemDetail(question);
  }

  void _showItemDetail(DiscoveryQuestion question) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    question.emoji,
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.amber, size: 20.r),
                        SizedBox(width: 8.w),
                        const Text(
                          'Answer:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      question.answer,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    const Text('🌟', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Fun Fact: ${question.funFact}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGradientButton(
                    icon: Icons.volume_up,
                    label: 'Listen',
                    gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                    onTap: () =>
                        _speak('${question.answer} ${question.funFact}'),
                  ),
                  _buildGradientButton(
                    icon: Icons.close,
                    label: 'Close',
                    gradient: const [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                    onTap: () => Get.back(),
                  ),
                ],
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20.r),
            SizedBox(width: 8.w),
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
    final topic = _topics[_currentTopic];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 8,
        shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20.r,
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
          'Discovery Learning',
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
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.refresh, color: Colors.white, size: 20.r),
            ),
            onPressed: _resetProgress,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3.r,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabAlignment: TabAlignment.start,
          labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
          tabs: _topics.map((t) {
            return Tab(
              child: Text(
                t.name,
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
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: const Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '$_progressString completed',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: _progressPercentage,
                        minHeight: 10.h,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Questions grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(12.r),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.r,
                    crossAxisSpacing: 16.r,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: topic.questions.length,
                  itemBuilder: (context, index) {
                    final question = topic.questions[index];
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
                        onTap: () => _onItemTap(question, index),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: gradient[0].withValues(alpha: 0.4),
                                blurRadius: 12.r,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -20.h,
                                right: -20.w,
                                child: Container(
                                  width: 60.w,
                                  height: 60.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 60.w,
                                        height: 60.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            question.emoji,
                                            style: const TextStyle(
                                              fontSize: 32,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        question.question,
                                        style: const TextStyle(
                                          fontSize: 12,
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
                              if (_visitedItems[_currentTopic]?.contains(
                                    index,
                                  ) ==
                                  true)
                                Positioned(
                                  top: 8.h,
                                  right: 8.w,
                                  child: Container(
                                    padding: EdgeInsets.all(4.r),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: gradient[0],
                                      size: 16.r,
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
    );
  }
}

class DiscoveryTopic {
  final String name;
  final String emoji;
  final List<DiscoveryQuestion> questions;

  DiscoveryTopic({
    required this.name,
    required this.emoji,
    required this.questions,
  });
}

class DiscoveryQuestion {
  final String question;
  final String emoji;
  final String answer;
  final String funFact;

  DiscoveryQuestion(this.question, this.emoji, this.answer, this.funFact);
}
