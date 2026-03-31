import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class AudioLearningPage extends StatefulWidget {
  const AudioLearningPage({super.key});

  @override
  State<AudioLearningPage> createState() => _AudioLearningPageState();
}

class _AudioLearningPageState extends State<AudioLearningPage>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  final GetStorage _box = GetStorage();
  int _currentCategory = 0;
  bool _isPlaying = false;
  int? _playingIndex;

  // Track visited items per category
  final Map<int, Set<int>> _visitedItems = {};

  final List<AudioCategory> _categories = [
    AudioCategory(
      name: 'Animal Sounds',
      emoji: '🐾',
      color: Colors.green,
      items: [
        AudioItem('Dog', '🐕', 'Woof woof! Bark bark!', 'Dogs bark and woof'),
        AudioItem('Cat', '🐱', 'Meow meow! Purr purr!', 'Cats meow and purr'),
        AudioItem('Cow', '🐄', 'Moo moo!', 'Cows say moo'),
        AudioItem('Duck', '🦆', 'Quack quack!', 'Ducks go quack'),
        AudioItem('Rooster', '🐓', 'Cock-a-doodle-doo!', 'Roosters crow at dawn'),
        AudioItem('Lion', '🦁', 'Roar roar!', 'Lions roar loudly'),
        AudioItem('Frog', '🐸', 'Ribbit ribbit!', 'Frogs croak ribbit'),
        AudioItem('Sheep', '🐑', 'Baa baa!', 'Sheep say baa'),
        AudioItem('Horse', '🐴', 'Neigh neigh! Clip clop!', 'Horses neigh and gallop'),
        AudioItem('Pig', '🐷', 'Oink oink!', 'Pigs oink happily'),
        AudioItem('Elephant', '🐘', 'Trumpet! Pawoo!', 'Elephants trumpet loud'),
        AudioItem('Owl', '🦉', 'Hoot hoot! Who who!', 'Owls hoot at night'),
        AudioItem('Snake', '🐍', 'Hiss hiss!', 'Snakes hiss softly'),
        AudioItem('Monkey', '🐵', 'Ooh ooh! Ah ah!', 'Monkeys chatter loudly'),
        AudioItem('Wolf', '🐺', 'Howl! Awooo!', 'Wolves howl at moon'),
        AudioItem('Bee', '🐝', 'Buzz buzz buzz!', 'Bees buzz around'),
        AudioItem('Dolphin', '🐬', 'Click click! Squeak!', 'Dolphins click and squeak'),
        AudioItem('Donkey', '🫏', 'Hee-haw! Hee-haw!', 'Donkeys bray hee-haw'),
        AudioItem('Turkey', '🦃', 'Gobble gobble!', 'Turkeys gobble loudly'),
        AudioItem('Crow', '🐦‍⬛', 'Caw caw caw!', 'Crows caw in trees'),
      ],
    ),
    AudioCategory(
      name: 'Vehicle Sounds',
      emoji: '🚗',
      color: Colors.blue,
      items: [
        AudioItem('Car', '🚗', 'Vroom vroom! Beep beep!', 'Cars go vroom'),
        AudioItem('Train', '🚂', 'Choo choo! Chugga chugga!', 'Trains go choo choo'),
        AudioItem('Airplane', '✈️', 'Whoooosh! Zoom!', 'Planes fly with a whoosh'),
        AudioItem('Ambulance', '🚑', 'Wee-woo wee-woo!', 'Ambulance siren'),
        AudioItem('Fire Truck', '🚒', 'Nee-naw nee-naw!', 'Fire truck siren'),
        AudioItem('Bicycle', '🚲', 'Ring ring! Ding ding!', 'Bicycle bell rings'),
        AudioItem('Boat', '🚤', 'Honk honk! Splash!', 'Boat horn honks'),
        AudioItem('Helicopter', '🚁', 'Whop whop whop!', 'Helicopter blades spin'),
        AudioItem('Motorcycle', '🏍️', 'Vroom vroom! Rev rev!', 'Motorcycle engines rev'),
        AudioItem('Bus', '🚌', 'Beep beep! Psshh!', 'Bus doors open with psshh'),
        AudioItem('Truck', '🚚', 'Honk honk! Rumble!', 'Trucks rumble loudly'),
        AudioItem('Police Car', '🚔', 'Wee-oo wee-oo!', 'Police siren wails'),
        AudioItem('Tractor', '🚜', 'Putt putt putt!', 'Tractors putt along'),
        AudioItem('Rocket', '🚀', 'Whoooosh! Boom!', 'Rockets blast off'),
        AudioItem('Subway', '🚇', 'Whoosh! Screech!', 'Subway trains screech'),
        AudioItem('Scooter', '🛵', 'Beep beep! Putt putt!', 'Scooters putt around'),
        AudioItem('Jet', '🛩️', 'Roarrr! Zoom!', 'Jets roar through sky'),
        AudioItem('Ship', '🚢', 'Hoooonk! Splash!', 'Ships honk their horns'),
        AudioItem('Race Car', '🏎️', 'Vroooom! Screech!', 'Race cars zoom fast'),
        AudioItem('Ice Cream Truck', '🍦', 'Ding ding! Jingle!', 'Ice cream truck jingles'),
      ],
    ),
    AudioCategory(
      name: 'Nature Sounds',
      emoji: '🌿',
      color: Colors.teal,
      items: [
        AudioItem('Rain', '🌧️', 'Pitter patter! Drip drop!', 'Rain falls softly'),
        AudioItem('Thunder', '⛈️', 'Boom! Rumble rumble!', 'Thunder rumbles loud'),
        AudioItem('Wind', '💨', 'Whoooosh! Swish swish!', 'Wind blows whoosh'),
        AudioItem('Waves', '🌊', 'Splash! Swoosh swoosh!', 'Waves crash on shore'),
        AudioItem('Bird', '🐦', 'Tweet tweet! Chirp chirp!', 'Birds sing tweets'),
        AudioItem('Bee', '🐝', 'Buzz buzz buzz!', 'Bees buzz around'),
        AudioItem('Fire', '🔥', 'Crackle crackle! Pop!', 'Fire crackles warmly'),
        AudioItem('Waterfall', '💦', 'Roar! Splash splash!', 'Waterfall roars'),
        AudioItem('Stream', '🏞️', 'Babble babble! Gurgle!', 'Streams babble along'),
        AudioItem('Leaves', '🍂', 'Rustle rustle! Crunch!', 'Leaves rustle in wind'),
        AudioItem('Cricket', '🦗', 'Chirp chirp! Cricket!', 'Crickets chirp at night'),
        AudioItem('Frog Pond', '🐸', 'Croak croak! Ribbit!', 'Frogs croak by ponds'),
        AudioItem('Volcano', '🌋', 'Rumble! Boom boom!', 'Volcanoes rumble loud'),
        AudioItem('Earthquake', '🌍', 'Rumble rumble! Shake!', 'Earthquakes shake ground'),
        AudioItem('Tornado', '🌪️', 'Whoooosh! Roar!', 'Tornadoes roar loudly'),
        AudioItem('Snowfall', '❄️', 'Soft soft! Silence!', 'Snow falls silently'),
        AudioItem('Hail', '🧊', 'Tap tap tap! Ping!', 'Hail taps on windows'),
        AudioItem('Ocean', '🌊', 'Whoosh whoosh! Roar!', 'Ocean waves roar'),
        AudioItem('Forest', '🌲', 'Rustle! Hoot! Tweet!', 'Forest sounds mix'),
        AudioItem('Campfire', '🏕️', 'Crackle pop! Sizzle!', 'Campfire crackles nicely'),
      ],
    ),
    AudioCategory(
      name: 'Musical Sounds',
      emoji: '🎵',
      color: Colors.purple,
      items: [
        AudioItem('Drum', '🥁', 'Boom boom! Tap tap!', 'Drums go boom'),
        AudioItem('Piano', '🎹', 'Ding ding! Plink plink!', 'Piano keys tinkle'),
        AudioItem('Guitar', '🎸', 'Strum strum! Twang!', 'Guitar strings strum'),
        AudioItem('Trumpet', '🎺', 'Toot toot! Ta-da!', 'Trumpet toots loudly'),
        AudioItem('Bell', '🔔', 'Ding dong! Ring ring!', 'Bells ring ding dong'),
        AudioItem('Whistle', '📯', 'Tweeeeet!', 'Whistle blows tweet'),
        AudioItem('Clap', '👏', 'Clap clap clap!', 'Hands clap together'),
        AudioItem('Tambourine', '🎀', 'Jingle jangle!', 'Tambourine jingles'),
        AudioItem('Violin', '🎻', 'Screech! Melody!', 'Violin plays melody'),
        AudioItem('Flute', '🪈', 'Toot toot! Melody!', 'Flute plays softly'),
        AudioItem('Xylophone', '🎶', 'Ting ting ting!', 'Xylophone tings'),
        AudioItem('Harmonica', '🎵', 'Whee whoo whee!', 'Harmonica plays tunes'),
        AudioItem('Cymbals', '🥁', 'Crash! Ching ching!', 'Cymbals crash loudly'),
        AudioItem('Maracas', '🪇', 'Shake shake shake!', 'Maracas shake rhythm'),
        AudioItem('Triangle', '📐', 'Ting! Ting ting!', 'Triangle rings clear'),
        AudioItem('Harp', '🪕', 'Twang twang! Glissando!', 'Harp strings shimmer'),
        AudioItem('Accordion', '🪗', 'Squeeze! Wheeze!', 'Accordion wheezes'),
        AudioItem('Saxophone', '🎷', 'Honk! Jazz melody!', 'Saxophone plays jazz'),
        AudioItem('Singing', '🎤', 'La la la! Do re mi!', 'Voice sings beautifully'),
        AudioItem('Snap', '🫰', 'Snap snap snap!', 'Fingers snap rhythm'),
      ],
    ),
  ];

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadProgress();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentCategory = _tabController.index);
        _tts.speak(_categories[_tabController.index].name);
      }
    });
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _waveAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  void _loadProgress() {
    for (int i = 0; i < _categories.length; i++) {
      final saved = _box.read<List>('audio_progress_$i');
      if (saved != null) {
        _visitedItems[i] = saved.map((e) => e as int).toSet();
      } else {
        _visitedItems[i] = {};
      }
    }
  }

  void _markItemVisited(int categoryIndex, int itemIndex) {
    _visitedItems[categoryIndex] ??= {};
    if (!_visitedItems[categoryIndex]!.contains(itemIndex)) {
      setState(() {
        _visitedItems[categoryIndex]!.add(itemIndex);
      });
      _box.write('audio_progress_$categoryIndex', _visitedItems[categoryIndex]!.toList());
    }
  }

  int get _totalItems {
    int total = 0;
    for (var cat in _categories) {
      total += cat.items.length;
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
        _box.remove('audio_progress_$i');
      }
    });
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.35);
    await _tts.setPitch(1.3);
  }

  Future<void> _playSound(AudioItem item, int index) async {
    HapticFeedback.mediumImpact();
    _markItemVisited(_currentCategory, index);

    setState(() {
      _isPlaying = true;
      _playingIndex = index;
    });

    _waveController.repeat(reverse: true);

    await _tts.speak(item.name);
    await Future.delayed(const Duration(milliseconds: 500));
    await _tts.setSpeechRate(0.3);
    await _tts.speak(item.soundText);
    await _tts.setSpeechRate(0.4);
    await Future.delayed(const Duration(milliseconds: 500));
    await _tts.speak(item.description);

    setState(() {
      _isPlaying = false;
      _playingIndex = null;
    });
    _waveController.stop();
    _waveController.reset();
  }

  void _showItemDetail(AudioItem item, int index) {
    TtsService.to.speak(item.name);
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
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(item.emoji, style: const TextStyle(fontSize: 60)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  item.soundText,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGradientButton(
                    icon: Icons.volume_up,
                    label: 'Listen',
                    gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                    onTap: () {
                      Get.back();
                      _playSound(item, index);
                    },
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
    _waveController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = _categories[_currentCategory];

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
          'Audio Learning',
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
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 20,
              ),
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
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: _categories.map((cat) {
            return Tab(
              child: Text(cat.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              // Audio items grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: category.items.length,
                  itemBuilder: (context, index) {
                    final item = category.items[index];
                    final isCurrentlyPlaying = _playingIndex == index;
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
                        onTap: _isPlaying ? null : () => _showItemDetail(item, index),
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
                            border: isCurrentlyPlaying
                                ? Border.all(color: Colors.white, width: 3)
                                : null,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          if (isCurrentlyPlaying)
                                            AnimatedBuilder(
                                              animation: _waveAnimation,
                                              builder: (context, child) {
                                                return Container(
                                                  width: 85 * _waveAnimation.value,
                                                  height: 85 * _waveAnimation.value,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.white.withValues(alpha: 0.5),
                                                      width: 2,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          Container(
                                            width: 75,
                                            height: 75,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.3),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                item.emoji,
                                                style: const TextStyle(fontSize: 42),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
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
                              if (_visitedItems[_currentCategory]?.contains(index) == true)
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

class AudioCategory {
  final String name;
  final String emoji;
  final Color color;
  final List<AudioItem> items;

  AudioCategory({
    required this.name,
    required this.emoji,
    required this.color,
    required this.items,
  });
}

class AudioItem {
  final String name;
  final String emoji;
  final String soundText;
  final String description;

  AudioItem(this.name, this.emoji, this.soundText, this.description);
}
