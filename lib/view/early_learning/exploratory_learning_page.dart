import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class ExploratoryLearningPage extends StatefulWidget {
  const ExploratoryLearningPage({super.key});

  @override
  State<ExploratoryLearningPage> createState() =>
      _ExploratoryLearningPageState();
}

class _ExploratoryLearningPageState extends State<ExploratoryLearningPage>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  final GetStorage _box = GetStorage();
  int _currentWorld = 0;

  // Track visited items per world
  final Map<int, Set<int>> _visitedItems = {};

  final List<ExploreWorld> _worlds = [
    ExploreWorld(
      name: 'Ocean World',
      emoji: '🌊',
      items: [
        ExploreItem('Fish', '🐟', 'Fish swim in the water with fins'),
        ExploreItem('Whale', '🐋', 'Whales are the biggest animals!'),
        ExploreItem('Dolphin', '🐬', 'Dolphins are very smart and playful'),
        ExploreItem('Octopus', '🐙', 'Octopus has 8 arms'),
        ExploreItem('Crab', '🦀', 'Crabs walk sideways'),
        ExploreItem('Starfish', '⭐', 'Starfish live on the ocean floor'),
        ExploreItem('Shark', '🦈', 'Sharks have many sharp teeth'),
        ExploreItem('Turtle', '🐢', 'Sea turtles live for many years'),
        ExploreItem('Jellyfish', '🪼', 'Jellyfish can glow in the dark'),
        ExploreItem('Seahorse', '🦭', 'Seahorses swim upright'),
        ExploreItem('Lobster', '🦞', 'Lobsters have big claws'),
        ExploreItem('Shrimp', '🦐', 'Shrimps are small and tasty'),
        ExploreItem('Coral', '🪸', 'Corals are living creatures'),
        ExploreItem('Seal', '🦭', 'Seals love to play in water'),
        ExploreItem('Squid', '🦑', 'Squids can change colors'),
        ExploreItem('Clam', '🐚', 'Clams make beautiful pearls'),
        ExploreItem('Eel', '🐍', 'Electric eels can shock you'),
        ExploreItem('Penguin', '🐧', 'Penguins are excellent swimmers'),
        ExploreItem('Orca', '🐋', 'Orcas are also called killer whales'),
        ExploreItem('Stingray', '🐠', 'Stingrays glide through water'),
      ],
    ),
    ExploreWorld(
      name: 'Jungle Safari',
      emoji: '🌴',
      items: [
        ExploreItem('Lion', '🦁', 'Lions are the king of the jungle'),
        ExploreItem('Elephant', '🐘', 'Elephants have long trunks'),
        ExploreItem('Monkey', '🐵', 'Monkeys love bananas'),
        ExploreItem('Giraffe', '🦒', 'Giraffes have the longest necks'),
        ExploreItem('Zebra', '🦓', 'Zebras have black and white stripes'),
        ExploreItem('Tiger', '🐅', 'Tigers have orange and black stripes'),
        ExploreItem('Leopard', '🐆', 'Leopards have spots on their body'),
        ExploreItem('Gorilla', '🦍', 'Gorillas are very strong'),
        ExploreItem('Hippo', '🦛', 'Hippos love to stay in water'),
        ExploreItem('Rhino', '🦏', 'Rhinos have a big horn'),
        ExploreItem('Cheetah', '🐆', 'Cheetahs are the fastest animals'),
        ExploreItem('Parrot', '🦜', 'Parrots can talk like humans'),
        ExploreItem('Toucan', '🦜', 'Toucans have colorful beaks'),
        ExploreItem('Snake', '🐍', 'Snakes slither on the ground'),
        ExploreItem('Crocodile', '🐊', 'Crocodiles have powerful jaws'),
        ExploreItem('Orangutan', '🦧', 'Orangutans are very intelligent'),
        ExploreItem('Panther', '🐆', 'Panthers are black leopards'),
        ExploreItem('Sloth', '🦥', 'Sloths move very slowly'),
        ExploreItem('Koala', '🐨', 'Koalas love eucalyptus leaves'),
        ExploreItem('Panda', '🐼', 'Pandas eat bamboo all day'),
      ],
    ),
    ExploreWorld(
      name: 'Space Adventure',
      emoji: '🚀',
      items: [
        ExploreItem('Sun', '☀️', 'The Sun gives us light and heat'),
        ExploreItem('Moon', '🌙', 'The Moon comes out at night'),
        ExploreItem('Star', '⭐', 'Stars twinkle in the sky'),
        ExploreItem('Earth', '🌍', 'Earth is our home planet'),
        ExploreItem('Rocket', '🚀', 'Rockets fly to space'),
        ExploreItem('Saturn', '🪐', 'Saturn has beautiful rings'),
        ExploreItem('Mars', '🔴', 'Mars is called the red planet'),
        ExploreItem('Jupiter', '🟤', 'Jupiter is the biggest planet'),
        ExploreItem('Venus', '🌟', 'Venus is the hottest planet'),
        ExploreItem('Mercury', '⚫', 'Mercury is closest to the Sun'),
        ExploreItem('Neptune', '🔵', 'Neptune is very far away'),
        ExploreItem('Uranus', '🔵', 'Uranus spins on its side'),
        ExploreItem('Asteroid', '☄️', 'Asteroids are space rocks'),
        ExploreItem('Comet', '☄️', 'Comets have long tails'),
        ExploreItem('Astronaut', '👨‍🚀', 'Astronauts explore space'),
        ExploreItem('Galaxy', '🌌', 'Galaxies have billions of stars'),
        ExploreItem('Black Hole', '⚫', 'Black holes are super powerful'),
        ExploreItem('Satellite', '🛰️', 'Satellites orbit Earth'),
        ExploreItem('Meteor', '💫', 'Meteors are shooting stars'),
        ExploreItem('Space Station', '🛸', 'Astronauts live in space stations'),
      ],
    ),
    ExploreWorld(
      name: 'Farm Life',
      emoji: '🚜',
      items: [
        ExploreItem('Cow', '🐄', 'Cows give us milk'),
        ExploreItem('Chicken', '🐔', 'Chickens lay eggs'),
        ExploreItem('Pig', '🐷', 'Pigs roll in the mud'),
        ExploreItem('Horse', '🐴', 'Horses can run very fast'),
        ExploreItem('Sheep', '🐑', 'Sheep give us wool'),
        ExploreItem('Dog', '🐕', 'Dogs guard the farm'),
        ExploreItem('Cat', '🐱', 'Cats catch mice on farms'),
        ExploreItem('Duck', '🦆', 'Ducks swim in the pond'),
        ExploreItem('Goose', '🦢', 'Geese are good guards'),
        ExploreItem('Goat', '🐐', 'Goats love to climb'),
        ExploreItem('Donkey', '🫏', 'Donkeys carry heavy loads'),
        ExploreItem('Turkey', '🦃', 'Turkeys go gobble gobble'),
        ExploreItem('Rooster', '🐓', 'Roosters wake us up early'),
        ExploreItem('Rabbit', '🐰', 'Rabbits have long ears'),
        ExploreItem('Tractor', '🚜', 'Tractors help farmers work'),
        ExploreItem('Barn', '🏠', 'Animals sleep in the barn'),
        ExploreItem('Hay', '🌾', 'Hay is food for animals'),
        ExploreItem('Corn', '🌽', 'Corn grows in fields'),
        ExploreItem('Carrot', '🥕', 'Carrots grow underground'),
        ExploreItem('Apple Tree', '🍎', 'Apple trees give us fruits'),
      ],
    ),
    ExploreWorld(
      name: 'Insect World',
      emoji: '🦋',
      items: [
        ExploreItem('Butterfly', '🦋', 'Butterflies have colorful wings'),
        ExploreItem('Bee', '🐝', 'Bees make honey'),
        ExploreItem('Ladybug', '🐞', 'Ladybugs bring good luck'),
        ExploreItem('Ant', '🐜', 'Ants work together'),
        ExploreItem('Spider', '🕷️', 'Spiders make webs'),
        ExploreItem('Caterpillar', '🐛', 'Caterpillars become butterflies'),
        ExploreItem('Dragonfly', '🪰', 'Dragonflies fly very fast'),
        ExploreItem('Grasshopper', '🦗', 'Grasshoppers can jump high'),
        ExploreItem('Cricket', '🦗', 'Crickets chirp at night'),
        ExploreItem('Beetle', '🪲', 'Beetles have hard shells'),
        ExploreItem('Firefly', '✨', 'Fireflies glow in the dark'),
        ExploreItem('Mosquito', '🦟', 'Mosquitoes buzz around'),
        ExploreItem('Fly', '🪰', 'Flies have compound eyes'),
        ExploreItem('Moth', '🦋', 'Moths are attracted to light'),
        ExploreItem('Wasp', '🐝', 'Wasps can sting'),
        ExploreItem('Cockroach', '🪳', 'Cockroaches are very old insects'),
        ExploreItem('Centipede', '🐛', 'Centipedes have many legs'),
        ExploreItem('Snail', '🐌', 'Snails carry their homes'),
        ExploreItem('Worm', '🪱', 'Worms live in the soil'),
        ExploreItem('Praying Mantis', '🦗', 'Mantis catches other bugs'),
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
    _tabController = TabController(length: _worlds.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentWorld = _tabController.index);
        _speak('Welcome to ${_worlds[_tabController.index].name}!');
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
    for (int i = 0; i < _worlds.length; i++) {
      final saved = _box.read<List>('explore_progress_$i');
      if (saved != null) {
        _visitedItems[i] = saved.map((e) => e as int).toSet();
      } else {
        _visitedItems[i] = {};
      }
    }
  }

  void _markItemVisited(int worldIndex, int itemIndex) {
    _visitedItems[worldIndex] ??= {};
    if (!_visitedItems[worldIndex]!.contains(itemIndex)) {
      setState(() {
        _visitedItems[worldIndex]!.add(itemIndex);
      });
      _box.write(
        'explore_progress_$worldIndex',
        _visitedItems[worldIndex]!.toList(),
      );
    }
  }

  int get _totalItems {
    int total = 0;
    for (var world in _worlds) {
      total += world.items.length;
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
      for (int i = 0; i < _worlds.length; i++) {
        _visitedItems[i] = {};
        _box.remove('explore_progress_$i');
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

  void _onItemTap(ExploreItem item, int itemIndex) {
    TtsService.to.speak(item.name);
    HapticFeedback.mediumImpact();
    _speak('${item.name}. ${item.fact}');
    _markItemVisited(_currentWorld, itemIndex);
    _showItemDetail(item);
  }

  void _showItemDetail(ExploreItem item) {
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
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(item.emoji, style: const TextStyle(fontSize: 60)),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  item.fact,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
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
                    onTap: () => _speak('${item.name}. ${item.fact}'),
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
    final world = _worlds[_currentWorld];

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
          'Explore & Learn',
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
          tabs: _worlds.map((w) {
            return Tab(
              child: Text(
                w.name,
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
              // Explore grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(12.r),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.r,
                    crossAxisSpacing: 16.r,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: world.items.length,
                  itemBuilder: (context, index) {
                    final item = world.items[index];
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
                        onTap: () => _onItemTap(item, index),
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
                                        width: 75.w,
                                        height: 75.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            item.emoji,
                                            style: const TextStyle(
                                              fontSize: 42,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        item.name,
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
                              if (_visitedItems[_currentWorld]?.contains(
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

class ExploreWorld {
  final String name;
  final String emoji;
  final List<ExploreItem> items;

  ExploreWorld({required this.name, required this.emoji, required this.items});
}

class ExploreItem {
  final String name;
  final String emoji;
  final String fact;

  ExploreItem(this.name, this.emoji, this.fact);
}
