import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class SensoryLearningPage extends StatefulWidget {
  const SensoryLearningPage({super.key});

  @override
  State<SensoryLearningPage> createState() => _SensoryLearningPageState();
}

class _SensoryLearningPageState extends State<SensoryLearningPage>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final GetStorage _box = GetStorage();
  int _currentCategory = 0;

  // Track visited items per category - Map<categoryIndex, Set<itemIndex>>
  final Map<int, Set<int>> _visitedItems = {};

  final List<SensoryCategory> _categories = [
    SensoryCategory(
      name: 'Touch & Feel',
      emoji: '👋',
      color: Colors.orange,
      items: [
        SensoryItem('Soft', '🧸', 'Teddy bear is soft and fluffy', Colors.brown),
        SensoryItem('Hard', '🪨', 'Rock is hard and solid', Colors.grey),
        SensoryItem('Smooth', '🥚', 'Egg is smooth and round', Colors.white),
        SensoryItem('Rough', '🪵', 'Wood bark is rough', Colors.brown),
        SensoryItem('Wet', '💧', 'Water is wet and cool', Colors.blue),
        SensoryItem('Dry', '🏜️', 'Sand is dry and warm', Colors.amber),
        SensoryItem('Sticky', '🍯', 'Honey is sticky and sweet', Colors.orange),
        SensoryItem('Slimy', '🐌', 'Snail leaves slimy trail', Colors.green),
        SensoryItem('Fluffy', '☁️', 'Cloud looks fluffy and soft', Colors.white),
        SensoryItem('Bumpy', '🥒', 'Cucumber skin is bumpy', Colors.green),
        SensoryItem('Fuzzy', '🍑', 'Peach skin is fuzzy', Colors.orange),
        SensoryItem('Prickly', '🌵', 'Cactus is prickly', Colors.green),
        SensoryItem('Cold', '🧊', 'Ice is very cold', Colors.cyan),
        SensoryItem('Warm', '🔥', 'Fire makes things warm', Colors.red),
        SensoryItem('Heavy', '🏋️', 'Weights are heavy', Colors.grey),
        SensoryItem('Light', '🪶', 'Feather is very light', Colors.white),
        SensoryItem('Stretchy', '🎈', 'Balloon is stretchy', Colors.red),
        SensoryItem('Firm', '🍎', 'Apple is firm', Colors.red),
        SensoryItem('Squishy', '🧽', 'Sponge is squishy', Colors.yellow),
        SensoryItem('Silky', '🧣', 'Scarf is silky smooth', Colors.purple),
      ],
    ),
    SensoryCategory(
      name: 'Sounds',
      emoji: '👂',
      color: Colors.purple,
      items: [
        SensoryItem('Loud', '🔔', 'Bell rings loud', Colors.yellow),
        SensoryItem('Quiet', '🤫', 'Whisper is quiet', Colors.grey),
        SensoryItem('High', '🐦', 'Bird sings high notes', Colors.lightBlue),
        SensoryItem('Low', '🦁', 'Lion roars low', Colors.orange),
        SensoryItem('Fast', '🥁', 'Drums beat fast', Colors.red),
        SensoryItem('Slow', '🎵', 'Lullaby is slow', Colors.purple),
        SensoryItem('Buzzing', '🐝', 'Bee makes buzzing sound', Colors.yellow),
        SensoryItem('Chirping', '🦗', 'Cricket chirps at night', Colors.green),
        SensoryItem('Howling', '🐺', 'Wolf howls at moon', Colors.grey),
        SensoryItem('Splashing', '🌊', 'Water splashes loudly', Colors.blue),
        SensoryItem('Crackling', '🔥', 'Fire crackles softly', Colors.orange),
        SensoryItem('Rustling', '🍂', 'Leaves rustle in wind', Colors.brown),
        SensoryItem('Ticking', '⏰', 'Clock ticks steadily', Colors.grey),
        SensoryItem('Ringing', '📞', 'Phone rings loudly', Colors.blue),
        SensoryItem('Squeaking', '🐭', 'Mouse squeaks softly', Colors.grey),
        SensoryItem('Thundering', '⛈️', 'Thunder is very loud', Colors.indigo),
        SensoryItem('Whistling', '🎶', 'Wind whistles through trees', Colors.cyan),
        SensoryItem('Clapping', '👏', 'Hands clap together', Colors.pink),
        SensoryItem('Snoring', '😴', 'Sleeping makes snoring sounds', Colors.purple),
        SensoryItem('Giggling', '😄', 'Children giggle happily', Colors.yellow),
      ],
    ),
    SensoryCategory(
      name: 'Tastes',
      emoji: '👅',
      color: Colors.pink,
      items: [
        SensoryItem('Sweet', '🍬', 'Candy is sweet', Colors.pink),
        SensoryItem('Sour', '🍋', 'Lemon is sour', Colors.yellow),
        SensoryItem('Salty', '🧂', 'Salt is salty', Colors.white),
        SensoryItem('Bitter', '☕', 'Coffee is bitter', Colors.brown),
        SensoryItem('Spicy', '🌶️', 'Chili is spicy hot', Colors.red),
        SensoryItem('Mild', '🍚', 'Rice is mild', Colors.white),
        SensoryItem('Tangy', '🍊', 'Orange is tangy', Colors.orange),
        SensoryItem('Savory', '🍖', 'Meat is savory', Colors.brown),
        SensoryItem('Creamy', '🍦', 'Ice cream is creamy', Colors.white),
        SensoryItem('Crunchy', '🥕', 'Carrot is crunchy', Colors.orange),
        SensoryItem('Juicy', '🍇', 'Grapes are juicy', Colors.purple),
        SensoryItem('Minty', '🌿', 'Mint tastes fresh and cool', Colors.green),
        SensoryItem('Chocolatey', '🍫', 'Chocolate is rich and sweet', Colors.brown),
        SensoryItem('Fruity', '🍓', 'Strawberry is fruity', Colors.red),
        SensoryItem('Nutty', '🥜', 'Peanut has nutty taste', Colors.brown),
        SensoryItem('Buttery', '🧈', 'Butter is rich and smooth', Colors.yellow),
        SensoryItem('Cheesy', '🧀', 'Cheese has strong flavor', Colors.yellow),
        SensoryItem('Fizzy', '🥤', 'Soda is fizzy', Colors.brown),
        SensoryItem('Bland', '🥖', 'Bread can be bland', Colors.brown),
        SensoryItem('Zesty', '🫒', 'Olives are zesty', Colors.green),
      ],
    ),
    SensoryCategory(
      name: 'Smells',
      emoji: '👃',
      color: Colors.green,
      items: [
        SensoryItem('Fragrant', '🌹', 'Rose smells fragrant', Colors.red),
        SensoryItem('Fresh', '🍃', 'Mint smells fresh', Colors.green),
        SensoryItem('Sweet', '🍪', 'Cookies smell sweet', Colors.brown),
        SensoryItem('Fruity', '🍎', 'Apple smells fruity', Colors.red),
        SensoryItem('Earthy', '🌍', 'Rain on soil smells earthy', Colors.brown),
        SensoryItem('Citrus', '🍊', 'Orange smells citrusy', Colors.orange),
        SensoryItem('Floral', '🌸', 'Cherry blossom smells floral', Colors.pink),
        SensoryItem('Smoky', '🔥', 'Campfire smells smoky', Colors.grey),
        SensoryItem('Spicy', '🌶️', 'Peppers smell spicy', Colors.red),
        SensoryItem('Woody', '🌲', 'Pine trees smell woody', Colors.green),
        SensoryItem('Salty', '🌊', 'Ocean air smells salty', Colors.blue),
        SensoryItem('Herby', '🌿', 'Basil smells herby', Colors.green),
        SensoryItem('Baked', '🍞', 'Fresh bread smells baked', Colors.brown),
        SensoryItem('Coffee', '☕', 'Coffee has strong smell', Colors.brown),
        SensoryItem('Vanilla', '🍨', 'Vanilla is sweet smell', Colors.yellow),
        SensoryItem('Minty', '🫛', 'Peppermint smells minty', Colors.green),
        SensoryItem('Grassy', '🌱', 'Fresh cut grass smells grassy', Colors.green),
        SensoryItem('Perfumy', '💐', 'Flowers smell perfumy', Colors.purple),
        SensoryItem('Musky', '🦌', 'Forest smells musky', Colors.brown),
        SensoryItem('Clean', '🧼', 'Soap smells clean', Colors.blue),
      ],
    ),
    SensoryCategory(
      name: 'See & Look',
      emoji: '👀',
      color: Colors.blue,
      items: [
        SensoryItem('Bright', '☀️', 'Sun is bright', Colors.yellow),
        SensoryItem('Dark', '🌙', 'Night is dark', Colors.indigo),
        SensoryItem('Colorful', '🌈', 'Rainbow is colorful', Colors.purple),
        SensoryItem('Shiny', '💎', 'Diamond is shiny', Colors.cyan),
        SensoryItem('Big', '🐘', 'Elephant is big', Colors.grey),
        SensoryItem('Small', '🐜', 'Ant is small', Colors.brown),
        SensoryItem('Tall', '🦒', 'Giraffe is very tall', Colors.orange),
        SensoryItem('Short', '🐁', 'Mouse is short', Colors.grey),
        SensoryItem('Round', '🏀', 'Ball is round', Colors.orange),
        SensoryItem('Square', '📦', 'Box is square', Colors.brown),
        SensoryItem('Sparkly', '✨', 'Glitter is sparkly', Colors.yellow),
        SensoryItem('Dull', '🪨', 'Stone can be dull', Colors.grey),
        SensoryItem('Transparent', '🪟', 'Glass is transparent', Colors.cyan),
        SensoryItem('Opaque', '🧱', 'Brick is opaque', Colors.red),
        SensoryItem('Striped', '🦓', 'Zebra has stripes', Colors.grey),
        SensoryItem('Spotted', '🐆', 'Leopard has spots', Colors.orange),
        SensoryItem('Blurry', '🌫️', 'Fog makes things blurry', Colors.grey),
        SensoryItem('Clear', '💧', 'Water is clear', Colors.blue),
        SensoryItem('Wide', '🛤️', 'Road can be wide', Colors.grey),
        SensoryItem('Narrow', '🚪', 'Door can be narrow', Colors.brown),
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
      final saved = _box.read<List>('sensory_progress_$i');
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
      _box.write('sensory_progress_$categoryIndex', _visitedItems[categoryIndex]!.toList());
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
        _box.remove('sensory_progress_$i');
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

  void _onItemTap(SensoryItem item, int itemIndex) {
    TtsService.to.speak(item.name);
    HapticFeedback.mediumImpact();
    _speak('${item.name}. ${item.description}');
    _markItemVisited(_currentCategory, itemIndex);
    _showItemDetail(item);
  }

  void _showItemDetail(SensoryItem item) {
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
              Text(
                item.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGradientButton(
                    icon: Icons.volume_up,
                    label: 'Listen',
                    gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                    onTap: () => _speak('${item.name}. ${item.description}'),
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
    _audioPlayer.dispose();
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
          'Sensory Learning',
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
              // Progress bar with percentage
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
              // Sensory items grid
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                            item.emoji,
                                            style: const TextStyle(
                                              fontSize: 42,
                                            ),
                                          ),
                                        ),
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

class SensoryCategory {
  final String name;
  final String emoji;
  final Color color;
  final List<SensoryItem> items;

  SensoryCategory({
    required this.name,
    required this.emoji,
    required this.color,
    required this.items,
  });
}

class SensoryItem {
  final String name;
  final String emoji;
  final String description;
  final Color color;

  SensoryItem(this.name, this.emoji, this.description, this.color);
}
