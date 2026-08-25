import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class StoryCreationPage extends StatefulWidget {
  const StoryCreationPage({super.key});

  @override
  State<StoryCreationPage> createState() => _StoryCreationPageState();
}

class _StoryCreationPageState extends State<StoryCreationPage>
    with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  // Progress tracking
  Set<int> _viewedStories = {};
  Set<int> _viewedPrompts = {};
  int selectedStoryIndex = 0;
  bool _currentStoryTapped = false;

  // 50 Story Starters
  final List<Map<String, dynamic>> storyStarters = [
    {
      'title': 'The Lost Puppy',
      'emoji': '🐕',
      'story':
          'One sunny morning, a little puppy got lost in the big city. A kind child found the puppy and helped it find its way home. The puppy was so happy!',
      'color': Color(0xFFFFAA5A),
    },
    {
      'title': 'The Magic Garden',
      'emoji': '🌻',
      'story':
          'In a tiny garden, flowers could talk! They sang songs every morning and told stories every night. Children loved to listen.',
      'color': Color(0xFF56D97F),
    },
    {
      'title': 'The Brave Little Star',
      'emoji': '⭐',
      'story':
          'A small star wanted to shine the brightest. It tried and tried until one night, it glowed so bright that everyone on Earth could see it!',
      'color': Color(0xFFFFD700),
    },
    {
      'title': 'The Friendly Monster',
      'emoji': '👹',
      'story':
          'Under the bed lived a friendly monster. It scared away bad dreams and helped children sleep peacefully every night.',
      'color': Color(0xFFA78BFA),
    },
    {
      'title': 'Rainbow Fish',
      'emoji': '🐠',
      'story':
          'A colorful fish had sparkling scales. It learned that sharing its scales made everyone happy, including itself!',
      'color': Color(0xFF4ECDC4),
    },
    {
      'title': 'The Flying Elephant',
      'emoji': '🐘',
      'story':
          'An elephant dreamed of flying. With the help of magical birds, it soared through the clouds and saw the world from above!',
      'color': Color(0xFF667EEA),
    },
    {
      'title': 'The Tiny Hero',
      'emoji': '🦸',
      'story':
          'A small ant saved its entire colony from a flood. It proved that even the smallest can be the bravest!',
      'color': Color(0xFFFF6B6B),
    },
    {
      'title': 'The Dancing Trees',
      'emoji': '🌳',
      'story':
          'In a magical forest, trees could dance when the wind blew. Children would come to watch them sway and twirl!',
      'color': Color(0xFF10B981),
    },
    {
      'title': 'The Singing Moon',
      'emoji': '🌙',
      'story':
          'Every night, the moon sang lullabies to all the sleeping children. Its gentle voice brought sweet dreams.',
      'color': Color(0xFF8B5CF6),
    },
    {
      'title': 'The Brave Bunny',
      'emoji': '🐰',
      'story':
          'A small bunny ventured into the dark forest to find medicine for its sick friend. Its bravery saved the day!',
      'color': Color(0xFFEC4899),
    },
    {
      'title': 'The Cloud Maker',
      'emoji': '☁️',
      'story':
          'A young wizard learned to make clouds. Each cloud was shaped like animals and made everyone smile!',
      'color': Color(0xFF60A5FA),
    },
    {
      'title': 'The Helpful Robot',
      'emoji': '🤖',
      'story':
          'A little robot wanted to help everyone. It fixed broken toys and made children happy all day long.',
      'color': Color(0xFF64748B),
    },
    {
      'title': 'The Secret Door',
      'emoji': '🚪',
      'story':
          'Behind a old bookshelf was a secret door. It led to a world where animals could talk and magic was real!',
      'color': Color(0xFFF59E0B),
    },
    {
      'title': 'The Wish Flower',
      'emoji': '🌸',
      'story':
          'A magical flower granted one wish each year. A kind girl wished for happiness for everyone, and it came true!',
      'color': Color(0xFFF472B6),
    },
    {
      'title': 'The Adventure Balloon',
      'emoji': '🎈',
      'story':
          'A red balloon took a child on adventures around the world. They visited mountains, oceans, and deserts!',
      'color': Color(0xFFEF4444),
    },
    {
      'title': 'The Laughing Sun',
      'emoji': '☀️',
      'story':
          'The sun loved to laugh. Every time it giggled, sunbeams danced and made everyone feel warm and happy!',
      'color': Color(0xFFFBBF24),
    },
    {
      'title': 'The Invisible Friend',
      'emoji': '👻',
      'story':
          'A lonely child made friends with an invisible creature. Together they had the best adventures!',
      'color': Color(0xFFC084FC),
    },
    {
      'title': 'The Kindness Knight',
      'emoji': '⚔️',
      'story':
          'A knight who used kindness instead of swords saved the kingdom from an angry dragon by making friends with it!',
      'color': Color(0xFF6366F1),
    },
    {
      'title': 'The Time-Traveling Clock',
      'emoji': '⏰',
      'story':
          'An old clock could take children back in time. They met dinosaurs and saw how the pyramids were built!',
      'color': Color(0xFF14B8A6),
    },
    {
      'title': 'The Sharing Squirrel',
      'emoji': '🐿️',
      'story':
          'A squirrel shared its acorns with all the forest animals during winter. Everyone stayed warm and fed!',
      'color': Color(0xFFD97706),
    },
    {
      'title': 'The Dream Catcher',
      'emoji': '🕸️',
      'story':
          'A magical spider wove dream catchers that turned bad dreams into beautiful butterflies!',
      'color': Color(0xFF7C3AED),
    },
    {
      'title': 'The Talking Teddy',
      'emoji': '🧸',
      'story':
          'At midnight, teddy bears came alive! They had tea parties and told stories until morning.',
      'color': Color(0xFFBE185D),
    },
    {
      'title': 'The Color Fairy',
      'emoji': '🧚',
      'story':
          'A fairy could paint rainbows in the sky. Every morning, she made the world more colorful!',
      'color': Color(0xFFE879F9),
    },
    {
      'title': 'The Brave Little Train',
      'emoji': '🚂',
      'story':
          'A small train climbed the highest mountain to deliver toys to children. "I think I can!" it said.',
      'color': Color(0xFF0EA5E9),
    },
    {
      'title': 'The Magic Paintbrush',
      'emoji': '🖌️',
      'story':
          'Whatever a girl painted with her magic brush became real! She painted food for the hungry.',
      'color': Color(0xFFDC2626),
    },
    {
      'title': 'The Curious Cat',
      'emoji': '🐱',
      'story':
          'A cat discovered a hidden world inside a mirror. It was full of friendly creatures and endless yarn!',
      'color': Color(0xFFF97316),
    },
    {
      'title': 'The Helping Hands',
      'emoji': '🤲',
      'story':
          'Magical hands appeared whenever someone needed help. They cleaned, cooked, and comforted everyone!',
      'color': Color(0xFF22C55E),
    },
    {
      'title': 'The Snow Princess',
      'emoji': '❄️',
      'story':
          'A princess could make snow fall from her hands. She created winter wonderlands for children to play in!',
      'color': Color(0xFF38BDF8),
    },
    {
      'title': 'The Forest Friends',
      'emoji': '🦊',
      'story':
          'All the forest animals worked together to plant trees. Soon, the forest was greener than ever!',
      'color': Color(0xFFEA580C),
    },
    {
      'title': 'The Giggling Ghost',
      'emoji': '👻',
      'story':
          'A ghost loved making people laugh instead of scaring them. It became the most popular ghost ever!',
      'color': Color(0xFF9333EA),
    },
    {
      'title': 'The Courage Cape',
      'emoji': '🦸‍♂️',
      'story':
          'A magical cape gave whoever wore it courage. A shy child became the bravest helper in town!',
      'color': Color(0xFF3B82F6),
    },
    {
      'title': 'The Wishing Well',
      'emoji': '🪙',
      'story':
          'A well granted wishes, but only kind ones. Everyone learned to wish for good things for others!',
      'color': Color(0xFF2DD4BF),
    },
    {
      'title': 'The Starlight Express',
      'emoji': '🌟',
      'story':
          'A train made of starlight took children to visit the moon. They danced with moonbeams all night!',
      'color': Color(0xFFEAB308),
    },
    {
      'title': 'The Gentle Giant',
      'emoji': '🗿',
      'story':
          'A giant helped build houses and carry heavy things. The village loved their big friend!',
      'color': Color(0xFF78716C),
    },
    {
      'title': 'The Music Box',
      'emoji': '🎵',
      'story':
          'A magic music box played songs that made plants grow. Gardens became forests full of fruits!',
      'color': Color(0xFFEC4899),
    },
    {
      'title': 'The Sunset Painter',
      'emoji': '🎨',
      'story':
          'Every evening, an artist painted the sunset. Each day was more beautiful than the last!',
      'color': Color(0xFFF43F5E),
    },
    {
      'title': 'The Rainy Day Friend',
      'emoji': '🌧️',
      'story':
          'A cloud became friends with a child. It rained only when gardens needed water!',
      'color': Color(0xFF0284C7),
    },
    {
      'title': 'The Happy Hippo',
      'emoji': '🦛',
      'story':
          'A hippo taught everyone that it is okay to be different. Being unique makes us special!',
      'color': Color(0xFFA855F7),
    },
    {
      'title': 'The Treasure Map',
      'emoji': '🗺️',
      'story':
          'Children found a treasure map. The real treasure was the friends they made on the journey!',
      'color': Color(0xFFCA8A04),
    },
    {
      'title': 'The Lighthouse Keeper',
      'emoji': '🏠',
      'story':
          'A kind keeper lit the lighthouse every night. Ships safely found their way home because of them!',
      'color': Color(0xFF059669),
    },
    {
      'title': 'The Butterfly Effect',
      'emoji': '🦋',
      'story':
          'A butterfly flapped its wings and started a chain of kindness around the world!',
      'color': Color(0xFFD946EF),
    },
    {
      'title': 'The Sleepy Dragon',
      'emoji': '🐲',
      'story':
          'A dragon who loved to nap guarded a village. Everyone felt safe with their sleepy protector!',
      'color': Color(0xFF16A34A),
    },
    {
      'title': 'The Magic Seed',
      'emoji': '🌱',
      'story':
          'A child planted a seed that grew into a tree with golden apples. They shared with everyone!',
      'color': Color(0xFF65A30D),
    },
    {
      'title': 'The Friendly Alien',
      'emoji': '👽',
      'story':
          'An alien landed on Earth to learn about kindness. Humans taught it, and it taught them about stars!',
      'color': Color(0xFF8B5CF6),
    },
    {
      'title': 'The Blanket Fort',
      'emoji': '🏰',
      'story':
          'A blanket fort became a real castle at night. Children were kings and queens of their dreams!',
      'color': Color(0xFFDB2777),
    },
    {
      'title': 'The Healing Hug',
      'emoji': '🤗',
      'story':
          'A grandmother is hugs could heal any sadness. Her love made everyone feel better instantly!',
      'color': Color(0xFFFB7185),
    },
    {
      'title': 'The Adventure Book',
      'emoji': '📖',
      'story':
          'A book took readers inside its stories. Children lived amazing adventures every time they read!',
      'color': Color(0xFF0891B2),
    },
    {
      'title': 'The Moonlight Dance',
      'emoji': '💃',
      'story':
          'Animals danced under the moonlight every full moon. Even the shyest creatures joined in!',
      'color': Color(0xFFC026D3),
    },
    {
      'title': 'The Grateful Garden',
      'emoji': '🌺',
      'story':
          'A garden thanked everyone who cared for it by blooming the most beautiful flowers!',
      'color': Color(0xFFE11D48),
    },
    {
      'title': 'The Dream Team',
      'emoji': '🏅',
      'story':
          'Friends from different places came together. Their teamwork made impossible dreams come true!',
      'color': Color(0xFF0D9488),
    },
  ];

  // 50 Story Prompts
  final List<Map<String, dynamic>> storyPrompts = [
    {'prompt': 'What if animals could talk?', 'emoji': '🦜'},
    {'prompt': 'You find a magic lamp...', 'emoji': '🪔'},
    {'prompt': 'A dragon moves next door', 'emoji': '🐉'},
    {'prompt': 'You can fly for one day', 'emoji': '🦅'},
    {'prompt': 'Your toy comes alive!', 'emoji': '🧸'},
    {'prompt': 'You shrink to ant size', 'emoji': '🐜'},
    {'prompt': 'A rainbow leads to...', 'emoji': '🌈'},
    {'prompt': 'You meet your future self', 'emoji': '🔮'},
    {'prompt': 'Clouds become solid', 'emoji': '☁️'},
    {'prompt': 'You can talk to plants', 'emoji': '🌱'},
    {'prompt': 'A secret tunnel under school', 'emoji': '🕳️'},
    {'prompt': 'Your pet saves the day!', 'emoji': '🐕‍🦺'},
    {'prompt': 'You visit the moon', 'emoji': '🌙'},
    {'prompt': 'Time freezes except you', 'emoji': '⏱️'},
    {'prompt': 'You can read minds', 'emoji': '🧠'},
    {'prompt': 'A mermaid needs help', 'emoji': '🧜‍♀️'},
    {'prompt': 'You become invisible', 'emoji': '👻'},
    {'prompt': 'A genie grants 3 wishes', 'emoji': '🧞'},
    {'prompt': 'You enter a painting', 'emoji': '🖼️'},
    {'prompt': 'Dinosaurs return!', 'emoji': '🦕'},
    {'prompt': 'You can breathe underwater', 'emoji': '🤿'},
    {'prompt': 'A tree grows in your room', 'emoji': '🌳'},
    {'prompt': 'You swap lives with a king', 'emoji': '👑'},
    {'prompt': 'Your shadow runs away', 'emoji': '🏃'},
    {'prompt': 'You find treasure in attic', 'emoji': '💎'},
    {'prompt': 'A robot becomes your friend', 'emoji': '🤖'},
    {'prompt': 'You can control weather', 'emoji': '⛈️'},
    {'prompt': 'A magical door appears', 'emoji': '🚪'},
    {'prompt': 'You join a circus', 'emoji': '🎪'},
    {'prompt': 'Your drawings come alive', 'emoji': '✏️'},
    {'prompt': 'You discover superpowers', 'emoji': '⚡'},
    {'prompt': 'A spaceship lands nearby', 'emoji': '🛸'},
    {'prompt': 'You can talk to stars', 'emoji': '⭐'},
    {'prompt': 'A phoenix befriends you', 'emoji': '🔥'},
    {'prompt': 'You find a time machine', 'emoji': '⏰'},
    {'prompt': 'Giants need your help', 'emoji': '🗿'},
    {'prompt': 'You become a superhero', 'emoji': '🦸'},
    {'prompt': 'A whale swallows you', 'emoji': '🐋'},
    {'prompt': 'You can jump super high', 'emoji': '🦘'},
    {'prompt': 'A fairy grants a wish', 'emoji': '🧚'},
    {'prompt': 'You find a golden key', 'emoji': '🔑'},
    {'prompt': 'Your bike can fly!', 'emoji': '🚲'},
    {'prompt': 'You meet a talking cat', 'emoji': '🐱'},
    {'prompt': 'A witch needs a favor', 'emoji': '🧙‍♀️'},
    {'prompt': 'You can make things float', 'emoji': '🎈'},
    {'prompt': 'A pirate asks for help', 'emoji': '🏴‍☠️'},
    {'prompt': 'You find a magic wand', 'emoji': '🪄'},
    {'prompt': 'Monsters are friendly', 'emoji': '👹'},
    {'prompt': 'You discover a new planet', 'emoji': '🪐'},
    {'prompt': 'A unicorn visits you', 'emoji': '🦄'},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();

    // Float animation like home screen
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  void _resetProgress() {
    setState(() {
      _viewedStories.clear();
      _viewedPrompts.clear();
      selectedStoryIndex = 0;
      _currentStoryTapped = false;
    });
  }

  void _nextStory() {
    if (!_currentStoryTapped) {
      return;
    }
    setState(() {
      selectedStoryIndex = (selectedStoryIndex + 1) % storyStarters.length;
      _currentStoryTapped = false;
    });
  }

  void _previousStory() {
    setState(() {
      selectedStoryIndex =
          (selectedStoryIndex - 1 + storyStarters.length) %
          storyStarters.length;
      _viewedStories.add(selectedStoryIndex);
    });
    final story = storyStarters[selectedStoryIndex];
    _speakText("${story['title']}. ${story['story']}");
  }

  void _viewPrompt(int index) {
    setState(() {
      _viewedPrompts.add(index);
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Widget _buildProgressBar(int viewed, int total) {
    final progress = total > 0 ? viewed / total : 0.0;
    final percentage = (progress * 100).round();
    return Padding(
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
                '$viewed / $total ($percentage%)',
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
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF4CAF50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
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
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
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
          elevation: 8,
          title: const Text(
            "Story Creation",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _resetProgress,
                child: Container(
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
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            labelPadding: EdgeInsets.symmetric(horizontal: 20),
            tabs: [
              Tab(text: "Stories"),
              Tab(text: "Prompts"),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
              stops: [0.0, 0.3, 0.7, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: TabBarView(
            children: [_buildStoryTimeTab(), _buildPromptsTab()],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryTimeTab() {
    final story = storyStarters[selectedStoryIndex];
    final isCompleted = _viewedStories.contains(selectedStoryIndex);
    final gradient = AppColors.getGradientForIndex(selectedStoryIndex);

    return Column(
      children: [
        _buildProgressBar(_viewedStories.length, storyStarters.length),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Main Story Card with float animation
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: child,
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      TtsService.to.speak(story['title']);
                      setState(() {
                        _viewedStories.add(selectedStoryIndex);
                        _currentStoryTapped = true;
                      });
                      _speakText("${story['title']}. ${story['story']}");
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
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
                          // Decorative circle
                          Positioned(
                            top: -20,
                            right: -20,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              // Emoji in circle
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    story['emoji'],
                                    style: const TextStyle(fontSize: 45),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                story['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                story['story'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              const Icon(
                                Icons.volume_up,
                                color: Colors.white70,
                                size: 30,
                              ),
                            ],
                          ),
                          // Tick mark if completed
                          if (isCompleted)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _previousStory,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Previous"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _nextStory,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Next"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF56D97F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromptsTab() {
    return Column(
      children: [
        _buildProgressBar(_viewedPrompts.length, storyPrompts.length),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: storyPrompts.length,
                  itemBuilder: (context, index) {
                    final prompt = storyPrompts[index];
                    final gradient = AppColors.getGradientForIndex(index);
                    final isCompleted = _viewedPrompts.contains(index);

                    return GestureDetector(
                      onTap: () {
                        TtsService.to.speak(prompt['prompt']);
                        _viewPrompt(index);
                        _speakText(prompt['prompt']);
                      },
                      child: AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          final offset = (index % 2 == 0)
                              ? _floatAnimation.value * 0.5
                              : -_floatAnimation.value * 0.5;
                          return Transform.translate(
                            offset: Offset(0, offset),
                            child: child,
                          );
                        },
                        child: Container(
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
                            children: [
                              // Decorative circle like home screen
                              Positioned(
                                top: -15,
                                right: -15,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Emoji in circle like home screen
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          prompt['emoji'],
                                          style: const TextStyle(fontSize: 28),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        prompt['prompt'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Tick mark if completed
                              if (isCompleted)
                                Positioned(
                                  bottom: 6,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
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
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        "💡 Tips!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Tap any prompt to hear it!",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Use these ideas to create your own stories!",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
