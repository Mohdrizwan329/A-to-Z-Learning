import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class CraftIdeasPage extends StatefulWidget {
  const CraftIdeasPage({super.key});

  @override
  State<CraftIdeasPage> createState() => _CraftIdeasPageState();
}

class _CraftIdeasPageState extends State<CraftIdeasPage>
    with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _floatController;
  int selectedCraft = -1;

  final List<Map<String, dynamic>> craftCategories = [
    {
      'name': 'Paper Crafts',
      'emoji': '📄',
      'color': Color(0xFF4ECDC4),
      'crafts': [
        {
          'name': 'Paper Airplane',
          'emoji': '✈️',
          'materials': ['Paper', 'Scissors'],
          'steps': [
            'Fold paper in half',
            'Fold corners to center',
            'Fold wings down',
            'Throw and fly!',
          ],
        },
        {
          'name': 'Paper Boat',
          'emoji': '⛵',
          'materials': ['Paper'],
          'steps': [
            'Fold paper in half',
            'Fold corners down',
            'Open bottom',
            'Shape the boat',
          ],
        },
        {
          'name': 'Paper Hat',
          'emoji': '🎩',
          'materials': ['Newspaper', 'Tape'],
          'steps': [
            'Fold newspaper in half',
            'Fold corners to center',
            'Fold bottom up',
            'Wear your hat!',
          ],
        },
        {
          'name': 'Paper Fan',
          'emoji': '🪭',
          'materials': ['Colored paper', 'Stick'],
          'steps': [
            'Fold paper accordion style',
            'Pinch one end',
            'Tape together',
            'Attach stick',
          ],
        },
      ],
    },
    {
      'name': 'Nature Crafts',
      'emoji': '🍃',
      'color': Color(0xFF56D97F),
      'crafts': [
        {
          'name': 'Leaf Art',
          'emoji': '🍂',
          'materials': ['Leaves', 'Paper', 'Glue'],
          'steps': [
            'Collect colorful leaves',
            'Arrange on paper',
            'Glue them down',
            'Create a picture!',
          ],
        },
        {
          'name': 'Flower Crown',
          'emoji': '💐',
          'materials': ['Flowers', 'String'],
          'steps': [
            'Pick small flowers',
            'Braid stems together',
            'Form a circle',
            'Wear as crown!',
          ],
        },
        {
          'name': 'Rock Painting',
          'emoji': '🪨',
          'materials': ['Smooth rocks', 'Paint', 'Brush'],
          'steps': [
            'Find smooth rocks',
            'Clean and dry them',
            'Paint fun designs',
            'Let dry',
          ],
        },
        {
          'name': 'Stick Art',
          'emoji': '🌳',
          'materials': ['Sticks', 'String', 'Paint'],
          'steps': [
            'Collect sticks',
            'Tie together with string',
            'Paint if you want',
            'Hang as decoration',
          ],
        },
      ],
    },
    {
      'name': 'Recycled Crafts',
      'emoji': '♻️',
      'color': Color(0xFF667EEA),
      'crafts': [
        {
          'name': 'Bottle Robot',
          'emoji': '🤖',
          'materials': ['Plastic bottle', 'Caps', 'Markers'],
          'steps': [
            'Clean the bottle',
            'Add caps for eyes',
            'Draw face and buttons',
            'Your robot is ready!',
          ],
        },
        {
          'name': 'Cardboard House',
          'emoji': '🏠',
          'materials': ['Cardboard box', 'Paint', 'Scissors'],
          'steps': [
            'Get a box',
            'Cut windows and door',
            'Paint the house',
            'Add roof',
          ],
        },
        {
          'name': 'Egg Carton Caterpillar',
          'emoji': '🐛',
          'materials': ['Egg carton', 'Paint', 'Pipe cleaners'],
          'steps': [
            'Cut row from carton',
            'Paint it green',
            'Add googly eyes',
            'Add pipe cleaner antennae',
          ],
        },
        {
          'name': 'Paper Roll Binoculars',
          'emoji': '🔭',
          'materials': ['2 toilet rolls', 'String', 'Paint'],
          'steps': [
            'Paint the rolls',
            'Glue together',
            'Add string',
            'Go exploring!',
          ],
        },
      ],
    },
    {
      'name': 'Holiday Crafts',
      'emoji': '🎄',
      'color': Color(0xFFFF6B6B),
      'crafts': [
        {
          'name': 'Birthday Card',
          'emoji': '🎂',
          'materials': ['Card paper', 'Crayons', 'Stickers'],
          'steps': [
            'Fold paper in half',
            'Draw birthday cake',
            'Write a message',
            'Decorate with stickers',
          ],
        },
        {
          'name': 'Paper Snowflake',
          'emoji': '❄️',
          'materials': ['White paper', 'Scissors'],
          'steps': [
            'Fold paper into triangle',
            'Fold again',
            'Cut patterns',
            'Unfold to see snowflake!',
          ],
        },
        {
          'name': 'Diwali Diya',
          'emoji': '🪔',
          'materials': ['Clay or dough', 'Paint'],
          'steps': [
            'Shape clay into bowl',
            'Make a small spout',
            'Let dry',
            'Paint with bright colors',
          ],
        },
        {
          'name': 'Rakhi Bracelet',
          'emoji': '📿',
          'materials': ['Thread', 'Beads', 'Decorations'],
          'steps': [
            'Cut thread to size',
            'Add beads',
            'Tie securely',
            'Gift to sibling!',
          ],
        },
      ],
    },
    {
      'name': 'Easy Origami',
      'emoji': '🦢',
      'color': Color(0xFFA78BFA),
      'crafts': [
        {
          'name': 'Origami Dog',
          'emoji': '🐕',
          'materials': ['Square paper'],
          'steps': [
            'Fold into triangle',
            'Fold ears down',
            'Fold nose up',
            'Draw face',
          ],
        },
        {
          'name': 'Origami Cat',
          'emoji': '🐱',
          'materials': ['Square paper'],
          'steps': [
            'Fold into triangle',
            'Fold corners for ears',
            'Flip over',
            'Draw face',
          ],
        },
        {
          'name': 'Origami Fish',
          'emoji': '🐟',
          'materials': ['Colored paper'],
          'steps': ['Fold into triangle', 'Fold fins', 'Make tail', 'Add eye'],
        },
        {
          'name': 'Origami Heart',
          'emoji': '❤️',
          'materials': ['Red paper'],
          'steps': [
            'Fold paper in half',
            'Fold top corners',
            'Fold bottom up',
            'Shape the heart',
          ],
        },
      ],
    },
    {
      'name': 'Fun Projects',
      'emoji': '🎨',
      'color': Color(0xFFFFAA5A),
      'crafts': [
        {
          'name': 'Handprint Art',
          'emoji': '✋',
          'materials': ['Paint', 'Paper'],
          'steps': [
            'Put paint on hand',
            'Press on paper',
            'Make different colors',
            'Create animals or flowers',
          ],
        },
        {
          'name': 'Puppet Making',
          'emoji': '🧦',
          'materials': ['Sock', 'Buttons', 'Fabric'],
          'steps': [
            'Get an old sock',
            'Glue on button eyes',
            'Add fabric for hair',
            'Put on a show!',
          ],
        },
        {
          'name': 'Bookmark',
          'emoji': '📚',
          'materials': ['Card paper', 'Colors', 'Ribbon'],
          'steps': [
            'Cut a rectangle',
            'Decorate with colors',
            'Make a hole on top',
            'Add ribbon',
          ],
        },
        {
          'name': 'Photo Frame',
          'emoji': '🖼️',
          'materials': ['Cardboard', 'Decorations', 'Glue'],
          'steps': [
            'Cut frame shape',
            'Decorate with buttons',
            'Add shells or beads',
            'Insert your photo',
          ],
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  @override
  void dispose() {
    _floatController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Craft Ideas',
      emoji: '',
      body: selectedCraft == -1 ? _buildCategoryList() : _buildCraftDetails(),
    );
  }

  Widget _buildCategoryList() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          // Category Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.r,
              crossAxisSpacing: 16.r,
              childAspectRatio: 1.0,
            ),
            itemCount: craftCategories.length,
            itemBuilder: (context, index) {
              final category = craftCategories[index];
              return GestureDetector(
                onTap: () {
                  TtsService.to.speak(category['name']);
                  setState(() => selectedCraft = index);
                  _speakText(category['name']);
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        category['color'],
                        category['color'].withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: category['color'].withValues(alpha: 0.4),
                        blurRadius: 12.r,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          category['emoji'],
                          style: const TextStyle(fontSize: 45),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Flexible(
                        child: Text(
                          category['name'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Flexible(
                        child: Text(
                          "${(category['crafts'] as List).length} crafts",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 24.h),

          // Tip section
        ],
      ),
    );
  }

  Widget _buildCraftDetails() {
    final category = craftCategories[selectedCraft];
    final crafts = category['crafts'] as List<Map<String, dynamic>>;

    return Column(
      children: [
        // Back button and title
        Container(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => selectedCraft = -1),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white, size: 20.r),
                      SizedBox(width: 4.w),
                      Text("Back", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Text(category['emoji'], style: const TextStyle(fontSize: 30)),
              SizedBox(width: 8.w),
              Text(
                category['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Crafts list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: crafts.length,
            itemBuilder: (context, index) {
              final craft = crafts[index];
              return _buildCraftCard(craft, category['color']);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCraftCard(Map<String, dynamic> craft, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)],
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(craft['emoji'], style: const TextStyle(fontSize: 28)),
          ),
        ),
        title: Text(
          craft['name'],
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        subtitle: GestureDetector(
          onTap: () => _speakText(craft['name']),
          child: Row(
            children: [
              Icon(Icons.volume_up, size: 16.r, color: Colors.grey.shade600),
              SizedBox(width: 4.w),
              Text(
                "Tap to hear",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Materials
                Row(
                  children: [
                    const Text("📦", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8.w),
                    Text(
                      "Materials:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.r,
                  runSpacing: 8.r,
                  children: (craft['materials'] as List<String>).map((
                    material,
                  ) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: color.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        material,
                        style: TextStyle(color: color, fontSize: 13),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),
                // Steps
                Row(
                  children: [
                    const Text("📝", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8.w),
                    Text(
                      "Steps:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ...(craft['steps'] as List<String>).asMap().entries.map((
                  entry,
                ) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "${entry.key + 1}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 8.h),
                // Read aloud button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      String allSteps = (craft['steps'] as List<String>).join(
                        ". Then, ",
                      );
                      _speakText(
                        "Let's make a ${craft['name']}. First, $allSteps",
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Read Steps Aloud"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
