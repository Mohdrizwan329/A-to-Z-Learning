import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class MontessoriLearningPage extends StatefulWidget {
  const MontessoriLearningPage({super.key});

  @override
  State<MontessoriLearningPage> createState() => _MontessoriLearningPageState();
}

class _MontessoriLearningPageState extends State<MontessoriLearningPage>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  final GetStorage _box = GetStorage();
  int _currentArea = 0;

  // Track visited items per area
  final Map<int, Set<int>> _visitedItems = {};

  final List<MontessoriArea> _areas = [
    MontessoriArea(
      name: 'Practical Life',
      emoji: '🧹',
      materials: [
        MontessoriMaterial('Pouring', '🫖', 'Practice pouring water carefully', 'Develops concentration and motor skills'),
        MontessoriMaterial('Spooning', '🥄', 'Transfer beans with a spoon', 'Builds hand-eye coordination'),
        MontessoriMaterial('Buttoning', '🔘', 'Practice buttoning and unbuttoning', 'Develops fine motor skills'),
        MontessoriMaterial('Folding', '🧺', 'Learn to fold clothes neatly', 'Teaches order and sequence'),
        MontessoriMaterial('Polishing', '✨', 'Polish objects until they shine', 'Builds focus and patience'),
        MontessoriMaterial('Sweeping', '🧹', 'Practice sweeping with a small broom', 'Develops coordination'),
        MontessoriMaterial('Zipping', '🔐', 'Practice using zippers', 'Strengthens finger muscles'),
        MontessoriMaterial('Lacing', '👟', 'Thread laces through holes', 'Prepares for shoe tying'),
        MontessoriMaterial('Cutting', '✂️', 'Cut paper along lines', 'Develops scissor skills'),
        MontessoriMaterial('Washing Hands', '🧼', 'Learn proper hand washing', 'Teaches hygiene routine'),
        MontessoriMaterial('Table Setting', '🍽️', 'Arrange plates and utensils', 'Learns social customs'),
        MontessoriMaterial('Watering Plants', '🌿', 'Care for plants with water', 'Teaches responsibility'),
        MontessoriMaterial('Sorting', '📦', 'Organize objects by category', 'Develops classification skills'),
        MontessoriMaterial('Opening Jars', '🫙', 'Practice twisting lids open', 'Builds wrist strength'),
        MontessoriMaterial('Using Tongs', '🥢', 'Transfer objects with tongs', 'Refines grip control'),
        MontessoriMaterial('Sewing Cards', '🧵', 'Thread yarn through card holes', 'Prepares for sewing'),
        MontessoriMaterial('Dusting', '🪶', 'Clean surfaces with a duster', 'Teaches care of environment'),
        MontessoriMaterial('Spreading', '🧈', 'Spread butter on bread', 'Develops food preparation skills'),
        MontessoriMaterial('Peeling', '🍌', 'Peel fruits independently', 'Encourages self-sufficiency'),
        MontessoriMaterial('Dressing Frames', '👔', 'Practice clothing fasteners', 'Promotes independence'),
      ],
    ),
    MontessoriArea(
      name: 'Sensorial',
      emoji: '👁️',
      materials: [
        MontessoriMaterial('Pink Tower', '🏗️', 'Stack cubes from large to small', 'Teaches size discrimination'),
        MontessoriMaterial('Color Tablets', '🎨', 'Match and grade colors', 'Refines color perception'),
        MontessoriMaterial('Sound Cylinders', '🔊', 'Match cylinders by sound', 'Develops auditory sense'),
        MontessoriMaterial('Geometric Solids', '🔷', 'Explore 3D shapes by touch', 'Introduces geometry concepts'),
        MontessoriMaterial('Smelling Bottles', '👃', 'Match scents together', 'Refines olfactory sense'),
        MontessoriMaterial('Touch Boards', '✋', 'Feel different textures', 'Develops tactile sense'),
        MontessoriMaterial('Brown Stair', '🪜', 'Arrange prisms by thickness', 'Teaches dimension concepts'),
        MontessoriMaterial('Red Rods', '📏', 'Order rods by length', 'Develops visual sense of length'),
        MontessoriMaterial('Cylinder Blocks', '🎯', 'Fit cylinders in correct holes', 'Refines visual discrimination'),
        MontessoriMaterial('Knobless Cylinders', '🔴', 'Grade cylinders without knobs', 'Develops logical thinking'),
        MontessoriMaterial('Binomial Cube', '🧊', 'Build cube following pattern', 'Prepares for algebra'),
        MontessoriMaterial('Trinomial Cube', '📦', 'Assemble complex cube pattern', 'Advanced spatial awareness'),
        MontessoriMaterial('Tasting Bottles', '👅', 'Identify tastes sweet and sour', 'Refines gustatory sense'),
        MontessoriMaterial('Baric Tablets', '⚖️', 'Compare weights of tablets', 'Develops sense of weight'),
        MontessoriMaterial('Thermic Tablets', '🌡️', 'Feel temperature differences', 'Develops thermal sense'),
        MontessoriMaterial('Fabric Box', '🧣', 'Match fabrics by texture', 'Refines tactile discrimination'),
        MontessoriMaterial('Mystery Bag', '🎒', 'Identify objects by touch', 'Develops stereognostic sense'),
        MontessoriMaterial('Constructive Triangles', '📐', 'Build shapes from triangles', 'Explores geometry'),
        MontessoriMaterial('Color Box 3', '🌈', 'Grade nine colors by shade', 'Advanced color discrimination'),
        MontessoriMaterial('Geometric Cabinet', '🔲', 'Match shapes to insets', 'Learns geometric forms'),
      ],
    ),
    MontessoriArea(
      name: 'Language',
      emoji: '📖',
      materials: [
        MontessoriMaterial('Sandpaper Letters', '🔤', 'Trace letters with your finger', 'Learns letter shapes through touch'),
        MontessoriMaterial('Moveable Alphabet', '🔡', 'Build words with letter tiles', 'Develops spelling and reading'),
        MontessoriMaterial('Object Box', '📦', 'Match objects to sounds', 'Phonemic awareness'),
        MontessoriMaterial('Picture Cards', '🖼️', 'Match words to pictures', 'Builds vocabulary'),
        MontessoriMaterial('Story Sequence', '📚', 'Arrange pictures in order', 'Develops narrative skills'),
        MontessoriMaterial('Rhyming Pairs', '🎵', 'Find words that rhyme', 'Phonological awareness'),
        MontessoriMaterial('I Spy Game', '👀', 'Find objects by beginning sound', 'Develops phonemic awareness'),
        MontessoriMaterial('Metal Insets', '✏️', 'Trace shapes for writing prep', 'Develops pencil control'),
        MontessoriMaterial('Classified Cards', '🃏', 'Sort cards into categories', 'Builds vocabulary and classification'),
        MontessoriMaterial('Phonogram Cards', '📝', 'Learn letter combinations', 'Understands phonograms'),
        MontessoriMaterial('Word Building', '🏗️', 'Create words from letter tiles', 'Develops encoding skills'),
        MontessoriMaterial('Reading Cards', '📖', 'Read simple word cards', 'Practices decoding'),
        MontessoriMaterial('Command Cards', '📋', 'Read and follow instructions', 'Comprehension skills'),
        MontessoriMaterial('Sentence Building', '📝', 'Arrange words into sentences', 'Grammar introduction'),
        MontessoriMaterial('Grammar Symbols', '🔶', 'Learn parts of speech', 'Grammar foundations'),
        MontessoriMaterial('Noun Classification', '📂', 'Sort nouns by type', 'Develops categorization'),
        MontessoriMaterial('Verb Games', '🏃', 'Act out action words', 'Understands verbs'),
        MontessoriMaterial('Adjective Games', '🎨', 'Describe objects with words', 'Expands descriptive vocabulary'),
        MontessoriMaterial('Storytelling Cards', '📕', 'Create stories from pictures', 'Develops creative expression'),
        MontessoriMaterial('Poetry Reading', '🎭', 'Listen to and recite poems', 'Appreciates language rhythm'),
      ],
    ),
    MontessoriArea(
      name: 'Mathematics',
      emoji: '🔢',
      materials: [
        MontessoriMaterial('Number Rods', '📏', 'Count and compare rods', 'Introduces numbers 1-10'),
        MontessoriMaterial('Spindle Box', '🎯', 'Match spindles to numbers', 'Concept of quantity'),
        MontessoriMaterial('Golden Beads', '🔶', 'Learn place value with beads', 'Decimal system basics'),
        MontessoriMaterial('Teen Boards', '🔟', 'Build numbers 11-19', 'Understanding teen numbers'),
        MontessoriMaterial('Addition Strip', '➕', 'Practice addition facts', 'Mental math skills'),
        MontessoriMaterial('Bead Chains', '📿', 'Count and skip count', 'Number sequences'),
        MontessoriMaterial('Sandpaper Numbers', '🔢', 'Trace numbers with finger', 'Learns number symbols'),
        MontessoriMaterial('Cards and Counters', '🃏', 'Match quantities to numbers', 'One-to-one correspondence'),
        MontessoriMaterial('Hundred Board', '💯', 'Arrange numbers to 100', 'Number sequence to 100'),
        MontessoriMaterial('Ten Boards', '🔟', 'Build numbers 10-90', 'Understanding tens'),
        MontessoriMaterial('Subtraction Strip', '➖', 'Practice subtraction facts', 'Subtraction concepts'),
        MontessoriMaterial('Multiplication Board', '✖️', 'Learn multiplication facts', 'Multiplication basics'),
        MontessoriMaterial('Division Board', '➗', 'Practice division with beads', 'Division introduction'),
        MontessoriMaterial('Stamp Game', '📮', 'Do operations with stamps', 'Four operations practice'),
        MontessoriMaterial('Dot Game', '⚫', 'Practice place value addition', 'Large number operations'),
        MontessoriMaterial('Bead Frame', '🧮', 'Calculate on bead abacus', 'Mental calculation'),
        MontessoriMaterial('Fraction Circles', '🥧', 'Explore fraction pieces', 'Fraction introduction'),
        MontessoriMaterial('Fraction Skittles', '🎳', 'Compare fraction sizes', 'Fraction equivalence'),
        MontessoriMaterial('Geometry Sticks', '📐', 'Build geometric shapes', 'Geometry exploration'),
        MontessoriMaterial('Checkerboard', '♟️', 'Multiply large numbers', 'Advanced multiplication'),
      ],
    ),
    MontessoriArea(
      name: 'Culture',
      emoji: '🌍',
      materials: [
        MontessoriMaterial('Puzzle Maps', '🗺️', 'Learn continents and countries', 'Geographic awareness'),
        MontessoriMaterial('Land & Water', '🏔️', 'Explore landforms and water forms', 'Physical geography'),
        MontessoriMaterial('Animal Cards', '🦁', 'Classify animals by type', 'Zoology introduction'),
        MontessoriMaterial('Plant Parts', '🌱', 'Learn parts of plants', 'Botany basics'),
        MontessoriMaterial('Timeline', '📅', 'Sequence historical events', 'Sense of time'),
        MontessoriMaterial('Flags', '🏳️', 'Match flags to countries', 'Cultural awareness'),
        MontessoriMaterial('Globe', '🌐', 'Explore Earth as a sphere', 'Understands world geography'),
        MontessoriMaterial('Continent Box', '📦', 'Explore items from each continent', 'Cultural exploration'),
        MontessoriMaterial('Solar System', '🪐', 'Learn about planets', 'Astronomy basics'),
        MontessoriMaterial('Weather Chart', '🌤️', 'Track daily weather', 'Meteorology introduction'),
        MontessoriMaterial('Life Cycles', '🦋', 'Study animal life stages', 'Biology concepts'),
        MontessoriMaterial('Leaf Shapes', '🍃', 'Classify leaves by shape', 'Botany classification'),
        MontessoriMaterial('Rock Collection', '🪨', 'Identify different rocks', 'Geology introduction'),
        MontessoriMaterial('Magnet Experiments', '🧲', 'Explore magnetic properties', 'Physics basics'),
        MontessoriMaterial('Sink or Float', '🚢', 'Test object buoyancy', 'Scientific method'),
        MontessoriMaterial('Music Bells', '🔔', 'Learn musical notes', 'Music appreciation'),
        MontessoriMaterial('Art Appreciation', '🎨', 'Study famous artworks', 'Art history basics'),
        MontessoriMaterial('Cultural Celebrations', '🎉', 'Learn about world holidays', 'Cultural diversity'),
        MontessoriMaterial('Clock Work', '🕐', 'Learn to tell time', 'Time concepts'),
        MontessoriMaterial('Calendar Work', '📆', 'Understand days and months', 'Time organization'),
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
    _tabController = TabController(length: _areas.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentArea = _tabController.index);
        _speak(_areas[_tabController.index].name);
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
    for (int i = 0; i < _areas.length; i++) {
      final saved = _box.read<List>('montessori_progress_$i');
      if (saved != null) {
        _visitedItems[i] = saved.map((e) => e as int).toSet();
      } else {
        _visitedItems[i] = {};
      }
    }
  }

  void _markItemVisited(int areaIndex, int itemIndex) {
    _visitedItems[areaIndex] ??= {};
    if (!_visitedItems[areaIndex]!.contains(itemIndex)) {
      setState(() {
        _visitedItems[areaIndex]!.add(itemIndex);
      });
      _box.write('montessori_progress_$areaIndex', _visitedItems[areaIndex]!.toList());
    }
  }

  int get _totalItems {
    int total = 0;
    for (var area in _areas) {
      total += area.materials.length;
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
      for (int i = 0; i < _areas.length; i++) {
        _visitedItems[i] = {};
        _box.remove('montessori_progress_$i');
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

  void _onItemTap(MontessoriMaterial material, int itemIndex) {
    HapticFeedback.mediumImpact();
    _speak('${material.name}. ${material.description}');
    _markItemVisited(_currentArea, itemIndex);
    _showItemDetail(material);
  }

  void _showItemDetail(MontessoriMaterial material) {
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
                  child: Text(material.emoji, style: const TextStyle(fontSize: 60)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                material.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      material.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              material.benefit,
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
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGradientButton(
                    icon: Icons.volume_up,
                    label: 'Listen',
                    gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                    onTap: () => _speak('${material.name}. ${material.description}. ${material.benefit}'),
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
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final area = _areas[_currentArea];

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
          'Montessori Learning',
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
          tabs: _areas.map((a) {
            return Tab(
              child: Text(a.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              // Materials grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: area.materials.length,
                  itemBuilder: (context, index) {
                    final material = area.materials[index];
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
                        onTap: () => _onItemTap(material, index),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 75,
                                        height: 75,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.3),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            material.emoji,
                                            style: const TextStyle(fontSize: 42),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        material.name,
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
                              if (_visitedItems[_currentArea]?.contains(index) == true)
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

class MontessoriArea {
  final String name;
  final String emoji;
  final List<MontessoriMaterial> materials;

  MontessoriArea({
    required this.name,
    required this.emoji,
    required this.materials,
  });
}

class MontessoriMaterial {
  final String name;
  final String emoji;
  final String description;
  final String benefit;

  MontessoriMaterial(this.name, this.emoji, this.description, this.benefit);
}
