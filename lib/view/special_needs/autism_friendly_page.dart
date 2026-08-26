import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class AutismFriendlyPage extends StatefulWidget {
  const AutismFriendlyPage({super.key});

  @override
  State<AutismFriendlyPage> createState() => _AutismFriendlyPageState();
}

class _AutismFriendlyPageState extends State<AutismFriendlyPage>
    with TickerProviderStateMixin {
  final GetStorage _storage = GetStorage();
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  // Autism-friendly settings
  bool simplifiedMode = false;
  bool reducedColors = false;
  bool consistentLayout = true;
  bool predictableTransitions = true;
  bool minimalAnimations = true;
  bool quietMode = false;
  bool visualSchedule = true;
  bool clearInstructions = true;
  double sensoryLevel = 0.5; // 0 = minimal, 1 = full
  String preferredColor = 'blue'; // calming color preference

  // Visual schedule items
  final List<Map<String, dynamic>> scheduleItems = [
    {
      'task': 'Learn Numbers',
      'emoji': '🔢',
      'completed': false,
      'time': '5 min',
    },
    {
      'task': 'Practice Letters',
      'emoji': '🔤',
      'completed': false,
      'time': '5 min',
    },
    {'task': 'Break Time', 'emoji': '🧘', 'completed': false, 'time': '3 min'},
    {'task': 'Play a Game', 'emoji': '🎮', 'completed': false, 'time': '5 min'},
    {'task': 'Story Time', 'emoji': '📖', 'completed': false, 'time': '5 min'},
  ];

  // Calming activities
  final List<Map<String, dynamic>> calmingActivities = [
    {
      'name': 'Deep Breathing',
      'emoji': '🌬️',
      'color': Color(0xFF4ECDC4),
      'description': 'Breathe in slowly, breathe out slowly',
    },
    {
      'name': 'Count to 10',
      'emoji': '🔢',
      'color': Color(0xFF667EEA),
      'description': 'Count slowly from 1 to 10',
    },
    {
      'name': 'Squeeze Hands',
      'emoji': '✊',
      'color': Color(0xFFFFAA5A),
      'description': 'Make fists and release',
    },
    {
      'name': 'Look at Nature',
      'emoji': '🌳',
      'color': Color(0xFF56D97F),
      'description': 'Imagine a peaceful garden',
    },
    {
      'name': 'Hum a Song',
      'emoji': '🎵',
      'color': Color(0xFFA78BFA),
      'description': 'Hum your favorite tune',
    },
    {
      'name': 'Touch Something Soft',
      'emoji': '🧸',
      'color': Color(0xFFFF8E53),
      'description': 'Feel something cozy',
    },
  ];

  // Social stories
  final List<Map<String, dynamic>> socialStories = [
    {
      'title': 'Taking Turns',
      'emoji': '🔄',
      'color': Color(0xFF4ECDC4),
      'story':
          'When I play with friends, I wait for my turn. I can say "Your turn!" and then wait. When it is my turn, I can play. Taking turns is fair and makes everyone happy.',
    },
    {
      'title': 'Asking for Help',
      'emoji': '🙋',
      'color': Color(0xFF667EEA),
      'story':
          'When I need help, I can raise my hand or say "Help please." Adults like to help me. It is okay to ask for help when I am stuck.',
    },
    {
      'title': 'Feeling Frustrated',
      'emoji': '😤',
      'color': Color(0xFFFF6B6B),
      'story':
          'Sometimes things are hard and I feel frustrated. I can take a deep breath. I can ask for a break. I can try again later. It is okay to feel frustrated.',
    },
    {
      'title': 'Making Friends',
      'emoji': '👫',
      'color': Color(0xFF56D97F),
      'story':
          'To make a friend, I can say "Hi, my name is..." I can ask "Do you want to play?" Friends are nice to each other and share.',
    },
    {
      'title': 'Loud Noises',
      'emoji': '🔊',
      'color': Color(0xFFFFAA5A),
      'story':
          'Sometimes there are loud noises. I can cover my ears. I can find a quiet place. I can tell someone I need quiet. Loud noises will stop.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 4, vsync: this);
    _loadSettings();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.35); // Slower for clarity
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  void _loadSettings() {
    setState(() {
      simplifiedMode = _storage.read('autism_simplified') ?? false;
      reducedColors = _storage.read('autism_reduced_colors') ?? false;
      consistentLayout = _storage.read('autism_consistent_layout') ?? true;
      predictableTransitions = _storage.read('autism_predictable') ?? true;
      minimalAnimations = _storage.read('autism_minimal_animations') ?? true;
      quietMode = _storage.read('autism_quiet_mode') ?? false;
      visualSchedule = _storage.read('autism_visual_schedule') ?? true;
      clearInstructions = _storage.read('autism_clear_instructions') ?? true;
      sensoryLevel = _storage.read('autism_sensory_level') ?? 0.5;
      preferredColor = _storage.read('autism_preferred_color') ?? 'blue';
    });
  }

  void _saveSetting(String key, dynamic value) {
    _storage.write(key, value);
  }

  @override
  void dispose() {
    _tabController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Color _getCalmColor() {
    switch (preferredColor) {
      case 'blue':
        return Color(0xFF667EEA);
      case 'green':
        return Color(0xFF56D97F);
      case 'purple':
        return Color(0xFFA78BFA);
      case 'neutral':
        return Color(0xFF9CA3AF);
      default:
        return Color(0xFF667EEA);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10.r,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: Text(
          "Calm Learning",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3.r,
          isScrollable: true,
          labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
          tabs: [
            Tab(
              text: "Settings",
              icon: Icon(Icons.settings, size: 18.r),
            ),
            Tab(
              text: "Schedule",
              icon: Icon(Icons.schedule, size: 18.r),
            ),
            Tab(
              text: "Calm Down",
              icon: Icon(Icons.spa, size: 18.r),
            ),
            Tab(
              text: "Stories",
              icon: Icon(Icons.auto_stories, size: 18.r),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildSettingsTab(),
            _buildScheduleTab(),
            _buildCalmDownTab(),
            _buildStoriesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: EdgeInsets.all(16.r),
      children: [
        const Text(
          "🧩",
          style: TextStyle(fontSize: 50),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          "Comfort Settings",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _getCalmColor(),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Text(
          "Make learning comfortable for you",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),

        // Quick Enable
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: _getCalmColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Center(
                    child: Text("✨", style: TextStyle(fontSize: 26)),
                  ),
                ),
                title: const Text(
                  "Simplified Mode",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Less visual complexity"),
                trailing: Switch(
                  value: simplifiedMode,
                  onChanged: (v) {
                    setState(() {
                      simplifiedMode = v;
                      if (v) {
                        reducedColors = true;
                        minimalAnimations = true;
                      }
                    });
                    _saveSetting('autism_simplified', v);
                    _saveSetting('autism_reduced_colors', reducedColors);
                    _saveSetting(
                      'autism_minimal_animations',
                      minimalAnimations,
                    );
                  },
                  activeTrackColor: _getCalmColor().withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Visual Settings
        _buildSectionHeader("👁️", "Visual Comfort"),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              _buildSwitchTile(
                "🎨",
                "Reduced Colors",
                "Calm, muted color palette",
                reducedColors,
                (v) {
                  setState(() => reducedColors = v);
                  _saveSetting('autism_reduced_colors', v);
                },
              ),
              Divider(height: 1.h),
              _buildSwitchTile(
                "📐",
                "Consistent Layout",
                "Same layout on all screens",
                consistentLayout,
                (v) {
                  setState(() => consistentLayout = v);
                  _saveSetting('autism_consistent_layout', v);
                },
              ),
              Divider(height: 1.h),
              _buildSwitchTile(
                "🎬",
                "Minimal Animations",
                "Reduce moving elements",
                minimalAnimations,
                (v) {
                  setState(() => minimalAnimations = v);
                  _saveSetting('autism_minimal_animations', v);
                },
              ),
              Divider(height: 1.h),
              ListTile(
                leading: Container(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: _getCalmColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Center(
                    child: Text("🌈", style: TextStyle(fontSize: 22)),
                  ),
                ),
                title: const Text(
                  "Calming Color",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text("Current: ${preferredColor.capitalizeFirst}"),
                trailing: DropdownButton<String>(
                  value: preferredColor,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'blue', child: Text("Blue 💙")),
                    DropdownMenuItem(value: 'green', child: Text("Green 💚")),
                    DropdownMenuItem(value: 'purple', child: Text("Purple 💜")),
                    DropdownMenuItem(
                      value: 'neutral',
                      child: Text("Neutral 🤍"),
                    ),
                  ],
                  onChanged: (v) {
                    setState(() => preferredColor = v ?? 'blue');
                    _saveSetting('autism_preferred_color', preferredColor);
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Audio Settings
        _buildSectionHeader("🔊", "Audio Comfort"),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              _buildSwitchTile(
                "🔇",
                "Quiet Mode",
                "Reduce sound effects",
                quietMode,
                (v) {
                  setState(() => quietMode = v);
                  _saveSetting('autism_quiet_mode', v);
                },
              ),
              Divider(height: 1.h),
              ListTile(
                leading: Container(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: _getCalmColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Center(
                    child: Text("🎚️", style: TextStyle(fontSize: 22)),
                  ),
                ),
                title: const Text(
                  "Sensory Level",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(_getSensoryLevelText()),
                trailing: SizedBox(
                  width: 150.w,
                  child: Slider(
                    value: sensoryLevel,
                    min: 0,
                    max: 1,
                    divisions: 4,
                    activeColor: _getCalmColor(),
                    onChanged: (v) {
                      setState(() => sensoryLevel = v);
                      _saveSetting('autism_sensory_level', v);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Learning Settings
        _buildSectionHeader("📚", "Learning Support"),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              _buildSwitchTile(
                "📅",
                "Visual Schedule",
                "Show task schedule",
                visualSchedule,
                (v) {
                  setState(() => visualSchedule = v);
                  _saveSetting('autism_visual_schedule', v);
                },
              ),
              Divider(height: 1.h),
              _buildSwitchTile(
                "📝",
                "Clear Instructions",
                "Simple step-by-step guidance",
                clearInstructions,
                (v) {
                  setState(() => clearInstructions = v);
                  _saveSetting('autism_clear_instructions', v);
                },
              ),
              Divider(height: 1.h),
              _buildSwitchTile(
                "🔄",
                "Predictable Transitions",
                "Warn before changes",
                predictableTransitions,
                (v) {
                  setState(() => predictableTransitions = v);
                  _saveSetting('autism_predictable', v);
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildScheduleTab() {
    return ListView(
      padding: EdgeInsets.all(16.r),
      children: [
        const Text(
          "📅",
          style: TextStyle(fontSize: 50),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          "Today's Schedule",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _getCalmColor(),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Text(
          "Check off tasks as you complete them",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),

        ...scheduleItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: item['completed']
                  ? Border.all(color: Color(0xFF56D97F), width: 2)
                  : null,
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.r),
              leading: Container(
                width: 55.w,
                height: 55.h,
                decoration: BoxDecoration(
                  color: item['completed']
                      ? Color(0xFF56D97F).withValues(alpha: 0.2)
                      : _getCalmColor().withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: item['completed']
                      ? Icon(Icons.check, color: Color(0xFF56D97F), size: 30.r)
                      : Text(
                          item['emoji'],
                          style: const TextStyle(fontSize: 28),
                        ),
                ),
              ),
              title: Text(
                item['task'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  decoration: item['completed']
                      ? TextDecoration.lineThrough
                      : null,
                  color: item['completed'] ? Colors.grey : Colors.black,
                ),
              ),
              subtitle: Text(
                "${item['time']}",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              trailing: Checkbox(
                value: item['completed'],
                onChanged: (v) {
                  setState(() {
                    scheduleItems[index]['completed'] = v ?? false;
                  });
                  if (v == true) {
                    _speakText("Great job! ${item['task']} is done!");
                  }
                },
                activeColor: Color(0xFF56D97F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              onTap: () => _speakText(item['task']),
            ),
          );
        }).toList(),

        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Color(0xFF56D97F).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("🌟", style: TextStyle(fontSize: 24)),
              SizedBox(width: 12.w),
              Text(
                "${scheduleItems.where((i) => i['completed']).length}/${scheduleItems.length} Tasks Done!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF56D97F),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalmDownTab() {
    return ListView(
      padding: EdgeInsets.all(16.r),
      children: [
        const Text(
          "🧘",
          style: TextStyle(fontSize: 50),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          "Calm Down Corner",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _getCalmColor(),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Text(
          "Tap an activity when you need to relax",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.r,
            crossAxisSpacing: 12.r,
            childAspectRatio: 1.0,
          ),
          itemCount: calmingActivities.length,
          itemBuilder: (context, index) {
            final activity = calmingActivities[index];
            return GestureDetector(
              onTap: () {
                TtsService.to.speak(activity['name']);
                _speakText("${activity['name']}. ${activity['description']}");
                _showCalmingActivity(activity);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: activity['color'].withValues(alpha: 0.2),
                      blurRadius: 8.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: activity['color'].withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Text(
                          activity['emoji'],
                          style: const TextStyle(fontSize: 35),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      activity['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: activity['color'],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStoriesTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: socialStories.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("📖", style: TextStyle(fontSize: 50)),
              SizedBox(height: 8.h),
              Text(
                "Social Stories",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _getCalmColor(),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Stories to help understand social situations",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              SizedBox(height: 24.h),
            ],
          );
        }

        final story = socialStories[index - 1];
        return GestureDetector(
          onTap: () {
            TtsService.to.speak(story['title']);
            _speakText(story['story']);
            _showStoryDetail(story);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: story['color'].withValues(alpha: 0.2),
                  blurRadius: 8.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        story['color'],
                        story['color'].withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        story['emoji'],
                        style: const TextStyle(fontSize: 35),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Text(
                          story['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(Icons.volume_up, color: Colors.white70),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Text(
                    story['story'],
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String emoji, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Flexible(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: _getCalmColor(),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Container(
        width: 45.w,
        height: 45.h,
        decoration: BoxDecoration(
          color: _getCalmColor().withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(child: Text(icon, style: const TextStyle(fontSize: 22))),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: _getCalmColor().withValues(alpha: 0.5),
      ),
    );
  }

  String _getSensoryLevelText() {
    if (sensoryLevel <= 0.25) return "Minimal - Very calm";
    if (sensoryLevel <= 0.5) return "Low - Gentle";
    if (sensoryLevel <= 0.75) return "Medium - Balanced";
    return "Full - Regular";
  }

  void _showCalmingActivity(Map<String, dynamic> activity) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(32.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(activity['emoji'], style: const TextStyle(fontSize: 80)),
            SizedBox(height: 20.h),
            Text(
              activity['name'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: activity['color'],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              activity['description'],
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.check),
              label: const Text("I Feel Better"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF56D97F),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStoryDetail(Map<String, dynamic> story) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(Get.context!).size.height * 0.6,
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          children: [
            Text(story['emoji'], style: const TextStyle(fontSize: 60)),
            SizedBox(height: 16.h),
            Text(
              story['title'],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: story['color'],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  story['story'],
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                    height: 1.8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () => _speakText(story['story']),
              icon: const Icon(Icons.volume_up),
              label: const Text("Read to Me"),
              style: ElevatedButton.styleFrom(
                backgroundColor: story['color'],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
