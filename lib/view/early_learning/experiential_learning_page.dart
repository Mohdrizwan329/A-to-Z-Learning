import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class ExperientialLearningPage extends StatefulWidget {
  const ExperientialLearningPage({super.key});

  @override
  State<ExperientialLearningPage> createState() =>
      _ExperientialLearningPageState();
}

class _ExperientialLearningPageState extends State<ExperientialLearningPage>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  final GetStorage _box = GetStorage();
  int _currentTheme = 0;

  // Track visited items per theme
  final Map<int, Set<int>> _visitedItems = {};

  final List<ExperienceTheme> _themes = [
    ExperienceTheme(
      name: 'Science Experiments',
      emoji: '🔬',
      experiences: [
        Experience(
          'Volcano Eruption',
          '🌋',
          'Make a volcano with baking soda and vinegar',
          ['Baking soda', 'Vinegar', 'Food coloring'],
          'Chemical reactions create gas bubbles!',
        ),
        Experience(
          'Rainbow Water',
          '🌈',
          'Layer colored water by density',
          ['Sugar', 'Water', 'Food coloring'],
          'Dense liquids sink to the bottom!',
        ),
        Experience(
          'Plant Growing',
          '🌱',
          'Watch a seed sprout into a plant',
          ['Seeds', 'Soil', 'Water'],
          'Plants need light, water, and soil!',
        ),
        Experience(
          'Magnet Fun',
          '🧲',
          'Discover what magnets attract',
          ['Magnets', 'Metal objects'],
          'Magnets attract iron and steel!',
        ),
        Experience(
          'Float or Sink',
          '🚢',
          'Test which objects float in water',
          ['Bowl of water', 'Various objects'],
          'Density determines floating!',
        ),
        Experience(
          'Ice Melting',
          '🧊',
          'Explore what makes ice melt faster',
          ['Ice cubes', 'Salt', 'Sugar'],
          'Salt lowers the freezing point!',
        ),
        Experience(
          'Lemon Battery',
          '🍋',
          'Make electricity with a lemon',
          ['Lemon', 'Copper coin', 'Zinc nail'],
          'Acids can create electricity!',
        ),
        Experience(
          'Invisible Ink',
          '✍️',
          'Write secret messages with lemon juice',
          ['Lemon juice', 'Paper', 'Heat source'],
          'Heat reveals hidden writing!',
        ),
        Experience(
          'Static Electricity',
          '⚡',
          'Make hair stand up with a balloon',
          ['Balloon', 'Wool cloth'],
          'Rubbing creates static charge!',
        ),
        Experience(
          'Crystal Growing',
          '💎',
          'Grow beautiful crystals from salt',
          ['Salt', 'Water', 'String'],
          'Crystals form as water evaporates!',
        ),
        Experience(
          'Egg in Bottle',
          '🥚',
          'Get an egg inside a bottle',
          ['Hard boiled egg', 'Bottle', 'Paper'],
          'Air pressure pushes the egg!',
        ),
        Experience(
          'Color Mixing',
          '🎨',
          'Mix primary colors to make new ones',
          ['Red', 'Blue', 'Yellow paint'],
          'Primary colors make all colors!',
        ),
        Experience(
          'Bubble Science',
          '🫧',
          'Make giant bubbles with dish soap',
          ['Dish soap', 'Water', 'Glycerin'],
          'Surface tension holds bubbles together!',
        ),
        Experience(
          'Tornado in a Bottle',
          '🌪️',
          'Create a water tornado',
          ['Two bottles', 'Water', 'Tape'],
          'Spinning creates a vortex!',
        ),
        Experience(
          'Oobleck',
          '🟢',
          'Make a liquid that acts like solid',
          ['Cornstarch', 'Water'],
          'Its both liquid and solid!',
        ),
        Experience(
          'Dancing Raisins',
          '🍇',
          'Watch raisins dance in soda',
          ['Raisins', 'Clear soda'],
          'Gas bubbles lift the raisins!',
        ),
        Experience(
          'Balloon Rocket',
          '🎈',
          'Make a balloon zoom on a string',
          ['Balloon', 'Straw', 'String'],
          'Air pushes the balloon forward!',
        ),
        Experience(
          'Rain Cloud',
          '🌧️',
          'Make rain inside a jar',
          ['Jar', 'Shaving cream', 'Food coloring'],
          'Water falls when clouds get heavy!',
        ),
        Experience(
          'Walking Water',
          '💧',
          'Watch water climb up paper',
          ['Paper towels', 'Cups', 'Food coloring'],
          'Capillary action moves water!',
        ),
        Experience(
          'Fossil Making',
          '🦴',
          'Create fossils with clay',
          ['Clay', 'Leaves', 'Shells'],
          'Fossils preserve ancient life!',
        ),
      ],
    ),
    ExperienceTheme(
      name: 'Nature Adventures',
      emoji: '🌳',
      experiences: [
        Experience(
          'Bug Hunt',
          '🐛',
          'Find and observe insects outside',
          ['Magnifying glass', 'Container'],
          'Insects have 6 legs and 3 body parts!',
        ),
        Experience(
          'Cloud Watching',
          '☁️',
          'Identify different cloud shapes',
          ['Blanket', 'Notebook'],
          'Clouds are made of water droplets!',
        ),
        Experience(
          'Leaf Collection',
          '🍂',
          'Collect and compare different leaves',
          ['Bag', 'Paper'],
          'Leaves come in many shapes and colors!',
        ),
        Experience(
          'Bird Watching',
          '🐦',
          'Spot and identify local birds',
          ['Binoculars', 'Bird book'],
          'Birds have different beaks for food!',
        ),
        Experience(
          'Rock Hunting',
          '🪨',
          'Find interesting rocks and stones',
          ['Bag', 'Brush'],
          'Rocks are formed in different ways!',
        ),
        Experience(
          'Weather Journal',
          '🌤️',
          'Record daily weather observations',
          ['Notebook', 'Thermometer'],
          'Weather changes with seasons!',
        ),
        Experience(
          'Tree Identification',
          '🌲',
          'Learn to identify different trees',
          ['Tree guide', 'Camera'],
          'Trees can be identified by bark and leaves!',
        ),
        Experience(
          'Flower Pressing',
          '🌸',
          'Press and preserve beautiful flowers',
          ['Flowers', 'Heavy book', 'Paper'],
          'Pressing keeps flowers forever!',
        ),
        Experience(
          'Nature Scavenger Hunt',
          '🔍',
          'Find items on a nature list',
          ['List', 'Bag'],
          'Nature has many treasures!',
        ),
        Experience(
          'Pond Exploration',
          '🐸',
          'Discover life in a pond',
          ['Net', 'Container', 'Magnifying glass'],
          'Ponds are full of life!',
        ),
        Experience(
          'Star Gazing',
          '⭐',
          'Learn constellations at night',
          ['Star map', 'Blanket'],
          'Stars form patterns in the sky!',
        ),
        Experience(
          'Soil Layers',
          '🪴',
          'Explore different soil types',
          ['Jars', 'Soil samples', 'Water'],
          'Soil has many layers!',
        ),
        Experience('Rain Gauge', '🌧️', 'Measure rainfall amounts', [
          'Clear container',
          'Ruler',
        ], 'Rain varies by season!'),
        Experience(
          'Shadow Tracing',
          '👤',
          'Trace shadows throughout the day',
          ['Paper', 'Chalk', 'Pencil'],
          'Shadows move with the Sun!',
        ),
        Experience(
          'Wind Direction',
          '💨',
          'Make a wind vane',
          ['Paper', 'Straw', 'Pin'],
          'Wind comes from different directions!',
        ),
        Experience(
          'Animal Tracks',
          '🐾',
          'Find and identify animal footprints',
          ['Guide book', 'Camera'],
          'Animals leave tracks behind!',
        ),
        Experience(
          'Seed Dispersal',
          '🌰',
          'Learn how seeds travel',
          ['Various seeds', 'Magnifying glass'],
          'Seeds travel in many ways!',
        ),
        Experience(
          'Butterfly Garden',
          '🦋',
          'Create a butterfly-friendly garden',
          ['Flowers', 'Soil', 'Water'],
          'Butterflies love colorful flowers!',
        ),
        Experience(
          'Beach Exploration',
          '🏖️',
          'Discover seashells and sea life',
          ['Bucket', 'Magnifying glass'],
          'Beaches have many treasures!',
        ),
        Experience(
          'Nature Journal',
          '📓',
          'Draw and write about nature',
          ['Journal', 'Colored pencils'],
          'Journaling helps you remember!',
        ),
      ],
    ),
    ExperienceTheme(
      name: 'Art & Creativity',
      emoji: '🎨',
      experiences: [
        Experience(
          'Finger Painting',
          '🖐️',
          'Create art using your fingers',
          ['Paint', 'Paper'],
          'Express feelings through colors!',
        ),
        Experience('Clay Shapes', '🏺', 'Mold clay into fun shapes', [
          'Clay or playdough',
        ], 'Sculpture is 3D art!'),
        Experience(
          'Collage Making',
          '✂️',
          'Create pictures from cut paper',
          ['Magazines', 'Glue', 'Scissors'],
          'Combine shapes to tell a story!',
        ),
        Experience(
          'Nature Art',
          '🌸',
          'Make art from natural materials',
          ['Leaves', 'Flowers', 'Twigs'],
          'Nature provides beautiful materials!',
        ),
        Experience(
          'Music Making',
          '🎵',
          'Create sounds with homemade instruments',
          ['Pots', 'Spoons', 'Bottles'],
          'Everything can make music!',
        ),
        Experience(
          'Story Drawing',
          '📖',
          'Draw pictures that tell a story',
          ['Paper', 'Crayons'],
          'Pictures communicate ideas!',
        ),
        Experience(
          'Tie Dye',
          '👕',
          'Create colorful tie dye patterns',
          ['White shirt', 'Dye', 'Rubber bands'],
          'Twisting creates cool patterns!',
        ),
        Experience(
          'Stamp Art',
          '🔖',
          'Make stamps from vegetables',
          ['Potatoes', 'Paint', 'Paper'],
          'Anything can be a stamp!',
        ),
        Experience(
          'Sand Art',
          '🏖️',
          'Create layered sand pictures',
          ['Colored sand', 'Jar', 'Glue'],
          'Layers make beautiful designs!',
        ),
        Experience(
          'Puppets',
          '🧦',
          'Make sock or paper bag puppets',
          ['Socks', 'Buttons', 'Fabric'],
          'Puppets can tell stories!',
        ),
        Experience(
          'Mask Making',
          '🎭',
          'Design and create fun masks',
          ['Paper plates', 'Paint', 'Elastic'],
          'Masks let you be anyone!',
        ),
        Experience(
          'Wind Chimes',
          '🎐',
          'Build wind chimes from found objects',
          ['Sticks', 'String', 'Objects'],
          'Wind makes beautiful music!',
        ),
        Experience(
          'Friendship Bracelets',
          '📿',
          'Weave colorful bracelets',
          ['String', 'Beads'],
          'Handmade gifts are special!',
        ),
        Experience(
          'Paper Flowers',
          '🌺',
          'Create flowers from paper',
          ['Colored paper', 'Scissors', 'Glue'],
          'Paper flowers last forever!',
        ),
        Experience('Photo Album', '📷', 'Create a memory album', [
          'Photos',
          'Album',
          'Stickers',
        ], 'Photos capture memories!'),
        Experience(
          'Mosaic Art',
          '🎨',
          'Create pictures from small pieces',
          ['Paper pieces', 'Glue', 'Cardboard'],
          'Small pieces make big pictures!',
        ),
        Experience(
          'Dream Catcher',
          '🕸️',
          'Weave a dream catcher',
          ['Hoop', 'String', 'Feathers'],
          'Dream catchers catch bad dreams!',
        ),
        Experience('Pop-up Cards', '💌', 'Make 3D greeting cards', [
          'Paper',
          'Scissors',
          'Glue',
        ], '3D cards surprise people!'),
        Experience(
          'Face Painting',
          '🎭',
          'Paint fun designs on faces',
          ['Face paint', 'Brushes', 'Sponges'],
          'Face painting is transformative!',
        ),
        Experience(
          'Origami',
          '🦢',
          'Fold paper into shapes',
          ['Square paper'],
          'Folding creates amazing shapes!',
        ),
      ],
    ),
    ExperienceTheme(
      name: 'Kitchen Fun',
      emoji: '👨‍🍳',
      experiences: [
        Experience(
          'Fruit Salad',
          '🍓',
          'Make a colorful fruit salad',
          ['Various fruits', 'Bowl'],
          'Fruits have vitamins and minerals!',
        ),
        Experience(
          'Cookie Making',
          '🍪',
          'Bake simple cookies together',
          ['Flour', 'Sugar', 'Butter'],
          'Measuring is like math!',
        ),
        Experience(
          'Smoothie Blend',
          '🥤',
          'Blend fruits into a smoothie',
          ['Fruits', 'Yogurt', 'Blender'],
          'Mixing creates new flavors!',
        ),
        Experience(
          'Sandwich Art',
          '🥪',
          'Create fun sandwich shapes',
          ['Bread', 'Fillings', 'Cutters'],
          'Food can be fun and healthy!',
        ),
        Experience(
          'Pizza Faces',
          '🍕',
          'Decorate mini pizzas with toppings',
          ['Pizza base', 'Toppings'],
          'Creativity makes eating fun!',
        ),
        Experience(
          'Juice Mixing',
          '🧃',
          'Mix different fruit juices',
          ['Various juices'],
          'Combinations create new tastes!',
        ),
        Experience(
          'Pancake Art',
          '🥞',
          'Draw shapes with pancake batter',
          ['Pancake mix', 'Squeeze bottle'],
          'Pancakes can be any shape!',
        ),
        Experience(
          'Veggie Animals',
          '🥕',
          'Create animals from vegetables',
          ['Various vegetables', 'Toothpicks'],
          'Veggies are fun to eat!',
        ),
        Experience('Ice Cream', '🍦', 'Make ice cream in a bag', [
          'Milk',
          'Sugar',
          'Ice',
          'Salt',
        ], 'Salt makes ice colder!'),
        Experience('Fruit Kabobs', '🍇', 'Thread fruits on sticks', [
          'Fruits',
          'Wooden skewers',
        ], 'Kabobs make fruit fun!'),
        Experience('Bread Making', '🍞', 'Knead and bake bread', [
          'Flour',
          'Yeast',
          'Water',
        ], 'Yeast makes bread rise!'),
        Experience(
          'Salad Dressing',
          '🥗',
          'Mix your own salad dressing',
          ['Oil', 'Vinegar', 'Herbs'],
          'Oil and vinegar dont mix!',
        ),
        Experience('Trail Mix', '🥜', 'Create your own trail mix', [
          'Nuts',
          'Dried fruits',
          'Chocolate',
        ], 'Trail mix gives energy!'),
        Experience('Lemonade', '🍋', 'Make fresh lemonade', [
          'Lemons',
          'Sugar',
          'Water',
        ], 'Sweet and sour balance!'),
        Experience(
          'Banana Pops',
          '🍌',
          'Dip bananas in chocolate',
          ['Bananas', 'Chocolate', 'Sticks'],
          'Frozen treats are refreshing!',
        ),
        Experience(
          'Ants on a Log',
          '🥒',
          'Celery with peanut butter and raisins',
          ['Celery', 'Peanut butter', 'Raisins'],
          'Healthy snacks are tasty!',
        ),
        Experience('Cheese Quesadilla', '🧀', 'Make a simple quesadilla', [
          'Tortilla',
          'Cheese',
        ], 'Heat melts cheese!'),
        Experience(
          'Apple Slices',
          '🍎',
          'Cut apples into fun shapes',
          ['Apples', 'Cookie cutters'],
          'Apples are great snacks!',
        ),
        Experience('Popcorn', '🍿', 'Pop corn kernels', [
          'Popcorn kernels',
          'Oil',
        ], 'Heat makes kernels pop!'),
        Experience(
          'Yogurt Parfait',
          '🥛',
          'Layer yogurt with fruits and granola',
          ['Yogurt', 'Granola', 'Fruits'],
          'Layers look beautiful!',
        ),
      ],
    ),
    ExperienceTheme(
      name: 'Building & Making',
      emoji: '🔨',
      experiences: [
        Experience(
          'Block Tower',
          '🏗️',
          'Build the tallest tower possible',
          ['Building blocks'],
          'Balance and foundation are key!',
        ),
        Experience(
          'Paper Airplane',
          '✈️',
          'Fold and fly paper airplanes',
          ['Paper'],
          'Aerodynamics help things fly!',
        ),
        Experience(
          'Box Fort',
          '📦',
          'Create a fort from cardboard boxes',
          ['Boxes', 'Tape'],
          'Reuse materials creatively!',
        ),
        Experience(
          'Bead String',
          '📿',
          'String beads into patterns',
          ['Beads', 'String'],
          'Patterns repeat in sequence!',
        ),
        Experience(
          'Bridge Building',
          '🌉',
          'Build a bridge that holds weight',
          ['Popsicle sticks', 'Glue'],
          'Triangles make strong structures!',
        ),
        Experience(
          'Robot Friend',
          '🤖',
          'Create a robot from recycled items',
          ['Boxes', 'Bottles', 'Caps'],
          'Imagination turns trash into art!',
        ),
        Experience('Bird Feeder', '🐦', 'Make a bird feeder', [
          'Pinecone',
          'Peanut butter',
          'Seeds',
        ], 'Birds need food in winter!'),
        Experience(
          'Kite Making',
          '🪁',
          'Build and fly a simple kite',
          ['Sticks', 'Paper', 'String'],
          'Wind lifts kites into the air!',
        ),
        Experience(
          'Boat Building',
          '⛵',
          'Make a boat that floats',
          ['Foil', 'Straws', 'Paper'],
          'Shape determines buoyancy!',
        ),
        Experience(
          'Marble Run',
          '🔵',
          'Create a track for marbles',
          ['Cardboard tubes', 'Tape'],
          'Gravity pulls marbles down!',
        ),
        Experience('Catapult', '🏹', 'Build a launching catapult', [
          'Popsicle sticks',
          'Rubber bands',
          'Spoon',
        ], 'Tension creates force!'),
        Experience('Birdhouse', '🏠', 'Construct a small birdhouse', [
          'Wood pieces',
          'Glue',
          'Nails',
        ], 'Birds need safe homes!'),
        Experience('Windmill', '🌀', 'Make a spinning windmill', [
          'Paper',
          'Pin',
          'Stick',
        ], 'Wind makes things spin!'),
        Experience(
          'Parachute',
          '🪂',
          'Create a working parachute',
          ['Plastic bag', 'String', 'Weight'],
          'Air resistance slows falling!',
        ),
        Experience(
          'Maze Building',
          '🌀',
          'Design a maze for marbles',
          ['Cardboard', 'Straws', 'Glue'],
          'Mazes test problem solving!',
        ),
        Experience(
          'Telescope',
          '🔭',
          'Make a simple telescope',
          ['Tubes', 'Magnifying glasses'],
          'Lenses make things look bigger!',
        ),
        Experience(
          'Rain Stick',
          '🌧️',
          'Create a rain sound maker',
          ['Tube', 'Rice', 'Nails'],
          'Tumbling creates rain sounds!',
        ),
        Experience('Pinwheel', '🎡', 'Fold a spinning pinwheel', [
          'Paper',
          'Pin',
          'Stick',
        ], 'Air makes pinwheels spin!'),
        Experience(
          'Straw Structures',
          '🥤',
          'Build shapes with straws',
          ['Straws', 'Connectors'],
          'Geometry creates stability!',
        ),
        Experience(
          'Paper Chain',
          '🔗',
          'Make decorative paper chains',
          ['Paper strips', 'Glue'],
          'Chains decorate spaces!',
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
    _tabController = TabController(length: _themes.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentTheme = _tabController.index);
        _speak(_themes[_tabController.index].name);
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
    for (int i = 0; i < _themes.length; i++) {
      final saved = _box.read<List>('experiential_progress_$i');
      if (saved != null) {
        _visitedItems[i] = saved.map((e) => e as int).toSet();
      } else {
        _visitedItems[i] = {};
      }
    }
  }

  void _markItemVisited(int themeIndex, int itemIndex) {
    _visitedItems[themeIndex] ??= {};
    if (!_visitedItems[themeIndex]!.contains(itemIndex)) {
      setState(() {
        _visitedItems[themeIndex]!.add(itemIndex);
      });
      _box.write(
        'experiential_progress_$themeIndex',
        _visitedItems[themeIndex]!.toList(),
      );
    }
  }

  int get _totalItems {
    int total = 0;
    for (var theme in _themes) {
      total += theme.experiences.length;
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
      for (int i = 0; i < _themes.length; i++) {
        _visitedItems[i] = {};
        _box.remove('experiential_progress_$i');
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

  void _onItemTap(Experience experience, int itemIndex) {
    TtsService.to.speak(experience.name);
    HapticFeedback.mediumImpact();
    _speak('${experience.name}. ${experience.description}');
    _markItemVisited(_currentTheme, itemIndex);
    _showItemDetail(experience);
  }

  void _showItemDetail(Experience experience) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: SingleChildScrollView(
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
                      experience.emoji,
                      style: const TextStyle(fontSize: 50),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  experience.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  experience.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.list, color: Colors.white, size: 18.r),
                          SizedBox(width: 8.w),
                          Text(
                            'You will need:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 6.r,
                        runSpacing: 6.r,
                        children: experience.materials.map((m) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              m,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber, size: 18.r),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          experience.learning,
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGradientButton(
                      icon: Icons.volume_up,
                      label: 'Listen',
                      gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                      onTap: () => _speak(
                        '${experience.name}. ${experience.description}. ${experience.learning}',
                      ),
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
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
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
            Icon(icon, color: Colors.white, size: 18.r),
            SizedBox(width: 6.w),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
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
    final theme = _themes[_currentTheme];

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
          'Experiential Learning',
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
          tabs: _themes.map((t) {
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
              // Experiences grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(12.r),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.r,
                    crossAxisSpacing: 16.r,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: theme.experiences.length,
                  itemBuilder: (context, index) {
                    final experience = theme.experiences[index];
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
                        onTap: () => _onItemTap(experience, index),
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
                                            experience.emoji,
                                            style: const TextStyle(
                                              fontSize: 42,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        experience.name,
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
                              if (_visitedItems[_currentTheme]?.contains(
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

class ExperienceTheme {
  final String name;
  final String emoji;
  final List<Experience> experiences;

  ExperienceTheme({
    required this.name,
    required this.emoji,
    required this.experiences,
  });
}

class Experience {
  final String name;
  final String emoji;
  final String description;
  final List<String> materials;
  final String learning;

  Experience(
    this.name,
    this.emoji,
    this.description,
    this.materials,
    this.learning,
  );
}
