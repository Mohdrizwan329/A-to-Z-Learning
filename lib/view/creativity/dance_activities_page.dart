import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/utils/app_colors.dart';

class DanceActivitiesPage extends StatefulWidget {
  const DanceActivitiesPage({super.key});

  @override
  State<DanceActivitiesPage> createState() => _DanceActivitiesPageState();
}

class _DanceActivitiesPageState extends State<DanceActivitiesPage>
    with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  // Progress tracking
  Set<int> _viewedDances = {};
  Set<int> _viewedSongs = {};
  Set<int> _viewedMoves = {};
  int selectedDance = 0;
  bool _currentDanceTapped = false;

  // 50 Dance Activities
  final List<Map<String, dynamic>> danceActivities = [
    {
      'name': 'Jumping Jacks',
      'emoji': '🏃',
      'description': 'Jump with arms and legs out wide, then back together!',
    },
    {
      'name': 'Twirl Around',
      'emoji': '💃',
      'description': 'Spin slowly with arms out like a beautiful dancer!',
    },
    {
      'name': 'Clap Dance',
      'emoji': '👏',
      'description': 'Clap your hands while moving your feet!',
    },
    {
      'name': 'Animal Dance',
      'emoji': '🐻',
      'description': 'Move like your favorite animal - hop, crawl, or stomp!',
    },
    {
      'name': 'Freeze Dance',
      'emoji': '🧊',
      'description': 'Dance when music plays, freeze when it stops!',
    },
    {
      'name': 'Stretch Dance',
      'emoji': '🧘',
      'description': 'Reach up high, touch your toes, twist and stretch!',
    },
    {
      'name': 'Robot Dance',
      'emoji': '🤖',
      'description': 'Move stiff like a robot - beep boop!',
    },
    {
      'name': 'Butterfly Flutter',
      'emoji': '🦋',
      'description': 'Flap your arms like beautiful butterfly wings!',
    },
    {
      'name': 'Bunny Hop',
      'emoji': '🐰',
      'description': 'Hop hop hop like a happy bunny!',
    },
    {
      'name': 'Elephant Stomp',
      'emoji': '🐘',
      'description': 'Stomp your feet like a big elephant!',
    },
    {
      'name': 'Snake Slither',
      'emoji': '🐍',
      'description': 'Wiggle and wave your body like a snake!',
    },
    {
      'name': 'Bird Fly',
      'emoji': '🐦',
      'description': 'Flap your wings and soar through the sky!',
    },
    {
      'name': 'Frog Jump',
      'emoji': '🐸',
      'description': 'Crouch low and leap high like a frog!',
    },
    {
      'name': 'Cat Stretch',
      'emoji': '🐱',
      'description': 'Stretch your back like a sleepy cat!',
    },
    {
      'name': 'Dog Shake',
      'emoji': '🐕',
      'description': 'Shake your whole body like a wet dog!',
    },
    {
      'name': 'Penguin Waddle',
      'emoji': '🐧',
      'description': 'Walk side to side like a penguin!',
    },
    {
      'name': 'Kangaroo Bounce',
      'emoji': '🦘',
      'description': 'Bounce bounce bounce like a kangaroo!',
    },
    {
      'name': 'Monkey Swing',
      'emoji': '🐒',
      'description': 'Swing your arms like you are in the trees!',
    },
    {
      'name': 'Lion Roar',
      'emoji': '🦁',
      'description': 'Stretch big and roar like a brave lion!',
    },
    {
      'name': 'Fish Swim',
      'emoji': '🐠',
      'description': 'Move your body like swimming through water!',
    },
    {
      'name': 'Star Jump',
      'emoji': '⭐',
      'description': 'Jump and spread out like a star!',
    },
    {
      'name': 'Rainbow Reach',
      'emoji': '🌈',
      'description': 'Reach up and draw a rainbow in the air!',
    },
    {
      'name': 'Sun Spin',
      'emoji': '☀️',
      'description': 'Spin slowly like the warm sun!',
    },
    {
      'name': 'Moon Walk',
      'emoji': '🌙',
      'description': 'Walk slowly like you are on the moon!',
    },
    {
      'name': 'Cloud Float',
      'emoji': '☁️',
      'description': 'Move softly like a floating cloud!',
    },
    {
      'name': 'Wind Blow',
      'emoji': '💨',
      'description': 'Sway and move like the wind is blowing you!',
    },
    {
      'name': 'Rain Drop',
      'emoji': '🌧️',
      'description': 'Tap your fingers and feet like raindrops!',
    },
    {
      'name': 'Thunder Stomp',
      'emoji': '⚡',
      'description': 'Stomp loud like thunder booming!',
    },
    {
      'name': 'Flower Bloom',
      'emoji': '🌸',
      'description': 'Start small and open up like a flower!',
    },
    {
      'name': 'Tree Sway',
      'emoji': '🌳',
      'description': 'Stand tall and sway like a tree in the wind!',
    },
    {
      'name': 'Rocket Launch',
      'emoji': '🚀',
      'description': 'Crouch down and blast off to space!',
    },
    {
      'name': 'Airplane Fly',
      'emoji': '✈️',
      'description': 'Spread arms wide and fly around!',
    },
    {
      'name': 'Car Drive',
      'emoji': '🚗',
      'description': 'Pretend to hold a wheel and drive!',
    },
    {
      'name': 'Train Chug',
      'emoji': '🚂',
      'description': 'Chug chug like a train on tracks!',
    },
    {
      'name': 'Boat Row',
      'emoji': '⛵',
      'description': 'Row row row your boat gently!',
    },
    {
      'name': 'Bicycle Ride',
      'emoji': '🚲',
      'description': 'Pedal your legs like riding a bike!',
    },
    {
      'name': 'Helicopter Spin',
      'emoji': '🚁',
      'description': 'Spin your arms like helicopter blades!',
    },
    {
      'name': 'Superhero Pose',
      'emoji': '🦸',
      'description': 'Stand strong like a superhero!',
    },
    {
      'name': 'Princess Twirl',
      'emoji': '👸',
      'description': 'Twirl gracefully like royalty!',
    },
    {
      'name': 'Knight March',
      'emoji': '🏰',
      'description': 'March proudly like a brave knight!',
    },
    {
      'name': 'Wizard Wave',
      'emoji': '🧙',
      'description': 'Wave your magic wand and cast spells!',
    },
    {
      'name': 'Fairy Dance',
      'emoji': '🧚',
      'description': 'Dance lightly on your tiptoes!',
    },
    {
      'name': 'Pirate Jump',
      'emoji': '🏴‍☠️',
      'description': 'Jump around like a pirate on a ship!',
    },
    {
      'name': 'Cowboy Ride',
      'emoji': '🤠',
      'description': 'Gallop like riding a horse!',
    },
    {
      'name': 'Ninja Sneak',
      'emoji': '🥷',
      'description': 'Move quietly and quickly like a ninja!',
    },
    {
      'name': 'Ballerina Spin',
      'emoji': '🩰',
      'description': 'Spin gracefully on your toes!',
    },
    {
      'name': 'Disco Dance',
      'emoji': '🕺',
      'description': 'Point your finger up and down to the beat!',
    },
    {
      'name': 'Hip Hop Bounce',
      'emoji': '🎤',
      'description': 'Bounce to the rhythm with style!',
    },
    {
      'name': 'Salsa Step',
      'emoji': '💃',
      'description': 'Step side to side with spicy moves!',
    },
    {
      'name': 'Break Dance',
      'emoji': '🔥',
      'description': 'Move cool and show off your best moves!',
    },
  ];

  // 50 Action Songs
  final List<Map<String, dynamic>> actionSongs = [
    {
      'name': 'Head, Shoulders, Knees & Toes',
      'emoji': '👤',
      'action': 'Touch each body part as you sing!',
    },
    {
      'name': 'Hokey Pokey',
      'emoji': '🎪',
      'action': 'Put your hands in, out, and shake all about!',
    },
    {
      'name': 'If You\'re Happy & You Know It',
      'emoji': '😊',
      'action': 'Clap hands, stomp feet, do all three!',
    },
    {
      'name': 'Baby Shark',
      'emoji': '🦈',
      'action': 'Make shark shapes with your hands!',
    },
    {
      'name': 'Wheels on the Bus',
      'emoji': '🚌',
      'action': 'Roll your hands round and round!',
    },
    {
      'name': 'Itsy Bitsy Spider',
      'emoji': '🕷️',
      'action': 'Climb your fingers up like a spider!',
    },
    {
      'name': 'Row Your Boat',
      'emoji': '🚣',
      'action': 'Pretend to row while singing!',
    },
    {
      'name': 'Twinkle Twinkle',
      'emoji': '⭐',
      'action': 'Open and close hands like twinkling stars!',
    },
    {
      'name': 'Old MacDonald',
      'emoji': '🐄',
      'action': 'Make animal sounds and actions!',
    },
    {
      'name': 'Five Little Monkeys',
      'emoji': '🐵',
      'action': 'Jump on the bed and fall down!',
    },
    {
      'name': 'The Ants Go Marching',
      'emoji': '🐜',
      'action': 'March in place to the beat!',
    },
    {
      'name': 'London Bridge',
      'emoji': '🌉',
      'action': 'Make a bridge with your arms!',
    },
    {
      'name': 'Ring Around the Rosie',
      'emoji': '🌹',
      'action': 'Hold hands and spin in circles!',
    },
    {
      'name': 'Pat-a-Cake',
      'emoji': '🎂',
      'action': 'Clap hands with a partner!',
    },
    {
      'name': 'This Little Piggy',
      'emoji': '🐷',
      'action': 'Wiggle each toe as you sing!',
    },
    {
      'name': 'I\'m a Little Teapot',
      'emoji': '🫖',
      'action': 'Put one hand on hip and tip!',
    },
    {
      'name': 'The Alphabet Song',
      'emoji': '🔤',
      'action': 'Draw letters in the air!',
    },
    {'name': 'Bingo', 'emoji': '🐕', 'action': 'Clap for each letter!'},
    {
      'name': 'Mary Had a Little Lamb',
      'emoji': '🐑',
      'action': 'Prance like a little lamb!',
    },
    {
      'name': 'Jack and Jill',
      'emoji': '⛰️',
      'action': 'Pretend to climb a hill!',
    },
    {
      'name': 'Humpty Dumpty',
      'emoji': '🥚',
      'action': 'Sit tall then pretend to fall!',
    },
    {
      'name': 'Little Bo Peep',
      'emoji': '🐑',
      'action': 'Look around like searching!',
    },
    {
      'name': 'Hey Diddle Diddle',
      'emoji': '🌙',
      'action': 'Jump over pretend moon!',
    },
    {
      'name': 'Three Blind Mice',
      'emoji': '🐭',
      'action': 'Cover eyes and scurry around!',
    },
    {
      'name': 'Little Miss Muffet',
      'emoji': '🕷️',
      'action': 'Jump up scared of spider!',
    },
    {
      'name': 'Rain Rain Go Away',
      'emoji': '🌧️',
      'action': 'Wave hands to shoo rain!',
    },
    {
      'name': 'Hickory Dickory Dock',
      'emoji': '🐭',
      'action': 'Run up and down like a mouse!',
    },
    {'name': 'Five Little Ducks', 'emoji': '🦆', 'action': 'Waddle and quack!'},
    {
      'name': 'One Two Buckle My Shoe',
      'emoji': '👟',
      'action': 'Pretend to tie shoes!',
    },
    {
      'name': 'This Old Man',
      'emoji': '👴',
      'action': 'Pat knees and roll hands!',
    },
    {'name': 'Do Re Mi', 'emoji': '🎵', 'action': 'Step up the musical scale!'},
    {
      'name': 'ABC Rock',
      'emoji': '🎸',
      'action': 'Rock out while singing ABCs!',
    },
    {
      'name': 'Shake Your Sillies Out',
      'emoji': '🤪',
      'action': 'Shake your whole body!',
    },
    {
      'name': 'We Are the Dinosaurs',
      'emoji': '🦖',
      'action': 'Stomp and roar like a dino!',
    },
    {
      'name': 'Going on a Bear Hunt',
      'emoji': '🐻',
      'action': 'Slap legs and make sound effects!',
    },
    {
      'name': 'Open Shut Them',
      'emoji': '🤲',
      'action': 'Open and close hands!',
    },
    {
      'name': 'The Finger Family',
      'emoji': '👆',
      'action': 'Wiggle each finger as you sing!',
    },
    {
      'name': 'Johny Johny Yes Papa',
      'emoji': '🍬',
      'action': 'Shake head and hands!',
    },
    {
      'name': 'Five Little Speckled Frogs',
      'emoji': '🐸',
      'action': 'Jump like frogs into pool!',
    },
    {
      'name': 'Down by the Bay',
      'emoji': '🌊',
      'action': 'Make silly animal movements!',
    },
    {
      'name': 'Apples and Bananas',
      'emoji': '🍎',
      'action': 'Pretend to eat fruits!',
    },
    {
      'name': 'Peanut Butter Jelly Time',
      'emoji': '🥜',
      'action': 'Spread and dance!',
    },
    {
      'name': 'Cha Cha Slide',
      'emoji': '🎶',
      'action': 'Slide left, slide right, criss cross!',
    },
    {
      'name': 'Macarena',
      'emoji': '💃',
      'action': 'Arms out, flip, on hips, jump!',
    },
    {'name': 'Chicken Dance', 'emoji': '🐔', 'action': 'Flap arms and wiggle!'},
    {'name': 'YMCA', 'emoji': '🙆', 'action': 'Make letters with your arms!'},
    {
      'name': 'Electric Slide',
      'emoji': '⚡',
      'action': 'Grapevine left and right!',
    },
    {'name': 'Cupid Shuffle', 'emoji': '💘', 'action': 'Walk it by yourself!'},
    {
      'name': 'Cotton Eye Joe',
      'emoji': '🤠',
      'action': 'Kick your legs and dance!',
    },
    {
      'name': 'Twist and Shout',
      'emoji': '🎤',
      'action': 'Twist your body to the music!',
    },
  ];

  // 50 Dance Moves
  final List<Map<String, dynamic>> danceMoves = [
    {
      'move': 'Clap High',
      'emoji': '🙌',
      'how': 'Clap your hands above your head!',
    },
    {
      'move': 'Clap Low',
      'emoji': '👇',
      'how': 'Clap your hands near your feet!',
    },
    {'move': 'Stomp Left', 'emoji': '🦶', 'how': 'Stomp your left foot hard!'},
    {
      'move': 'Stomp Right',
      'emoji': '🦶',
      'how': 'Stomp your right foot hard!',
    },
    {
      'move': 'Wave Arms',
      'emoji': '👋',
      'how': 'Wave your arms like ocean waves!',
    },
    {
      'move': 'Shake Hips',
      'emoji': '💃',
      'how': 'Shake your hips side to side!',
    },
    {'move': 'Nod Head', 'emoji': '😊', 'how': 'Nod your head up and down!'},
    {'move': 'Shake Head', 'emoji': '🙂', 'how': 'Shake your head no no no!'},
    {
      'move': 'Roll Shoulders',
      'emoji': '💪',
      'how': 'Roll your shoulders in circles!',
    },
    {
      'move': 'Touch Toes',
      'emoji': '👟',
      'how': 'Bend down and touch your toes!',
    },
    {'move': 'Reach Sky', 'emoji': '🌟', 'how': 'Stretch up high to the sky!'},
    {'move': 'Spin Right', 'emoji': '↩️', 'how': 'Spin around to the right!'},
    {'move': 'Spin Left', 'emoji': '↪️', 'how': 'Spin around to the left!'},
    {'move': 'Jump Up', 'emoji': '⬆️', 'how': 'Jump as high as you can!'},
    {'move': 'Crouch Down', 'emoji': '⬇️', 'how': 'Crouch down really low!'},
    {'move': 'March in Place', 'emoji': '🚶', 'how': 'Lift your knees high!'},
    {'move': 'Skip Around', 'emoji': '😄', 'how': 'Skip happily in a circle!'},
    {
      'move': 'Hop on One Foot',
      'emoji': '🦩',
      'how': 'Balance and hop on one foot!',
    },
    {'move': 'Kick Forward', 'emoji': '🦵', 'how': 'Kick your leg in front!'},
    {'move': 'Kick Back', 'emoji': '🦵', 'how': 'Kick your leg behind you!'},
    {'move': 'Side Step', 'emoji': '👣', 'how': 'Step to the side!'},
    {
      'move': 'Cross Step',
      'emoji': '🚶',
      'how': 'Cross one foot over the other!',
    },
    {
      'move': 'Wiggle Fingers',
      'emoji': '🖐️',
      'how': 'Wiggle all your fingers!',
    },
    {
      'move': 'Make Fists',
      'emoji': '✊',
      'how': 'Make tight fists and punch air!',
    },
    {
      'move': 'Jazz Hands',
      'emoji': '🤗',
      'how': 'Spread fingers and shake hands!',
    },
    {
      'move': 'Robot Arms',
      'emoji': '🤖',
      'how': 'Move arms stiff like a robot!',
    },
    {'move': 'Flap Wings', 'emoji': '🐦', 'how': 'Flap your arms like wings!'},
    {'move': 'Swimming Arms', 'emoji': '🏊', 'how': 'Move arms like swimming!'},
    {'move': 'Climbing Up', 'emoji': '🧗', 'how': 'Pretend to climb a ladder!'},
    {
      'move': 'Punching Air',
      'emoji': '🥊',
      'how': 'Punch forward like a boxer!',
    },
    {'move': 'Karate Kick', 'emoji': '🥋', 'how': 'Kick out like karate!'},
    {
      'move': 'Ballet Pose',
      'emoji': '🩰',
      'how': 'Stand on tiptoes with arms up!',
    },
    {'move': 'Bow Down', 'emoji': '🙇', 'how': 'Take a bow like after a show!'},
    {
      'move': 'Heart Shape',
      'emoji': '❤️',
      'how': 'Make a heart with your hands!',
    },
    {
      'move': 'Star Shape',
      'emoji': '⭐',
      'how': 'Spread arms and legs like a star!',
    },
    {'move': 'Circle Arms', 'emoji': '⭕', 'how': 'Move arms in big circles!'},
    {
      'move': 'Snap Fingers',
      'emoji': '👌',
      'how': 'Snap your fingers to the beat!',
    },
    {'move': 'Pat Head', 'emoji': '👋', 'how': 'Pat your head gently!'},
    {'move': 'Rub Tummy', 'emoji': '😋', 'how': 'Rub your tummy in circles!'},
    {'move': 'Touch Shoulders', 'emoji': '🤷', 'how': 'Touch both shoulders!'},
    {
      'move': 'Touch Elbows',
      'emoji': '💪',
      'how': 'Try to touch your elbows together!',
    },
    {'move': 'Touch Knees', 'emoji': '🦵', 'how': 'Bend and touch your knees!'},
    {
      'move': 'Wiggle Hips',
      'emoji': '🕺',
      'how': 'Wiggle your hips like jelly!',
    },
    {'move': 'Shake Leg', 'emoji': '🦿', 'how': 'Shake one leg out!'},
    {'move': 'Freeze Pose', 'emoji': '🧊', 'how': 'Freeze in a fun pose!'},
    {'move': 'Silly Walk', 'emoji': '🤪', 'how': 'Walk in a silly way!'},
    {'move': 'Tip Toe Walk', 'emoji': '🩰', 'how': 'Walk quietly on tip toes!'},
    {'move': 'Giant Steps', 'emoji': '🦶', 'how': 'Take big giant steps!'},
    {'move': 'Baby Steps', 'emoji': '👣', 'how': 'Take tiny baby steps!'},
    {'move': 'Victory Pose', 'emoji': '🏆', 'how': 'Raise arms up in victory!'},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();

    // Float animation like confidence building page
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
      _viewedDances.clear();
      _viewedSongs.clear();
      _viewedMoves.clear();
      selectedDance = 0;
      _currentDanceTapped = false;
    });
  }

  void _nextDance() {
    if (!_currentDanceTapped) {
      return;
    }
    setState(() {
      selectedDance = (selectedDance + 1) % danceActivities.length;
      _currentDanceTapped = false;
    });
  }

  void _previousDance() {
    setState(() {
      selectedDance =
          (selectedDance - 1 + danceActivities.length) % danceActivities.length;
      _viewedDances.add(selectedDance);
    });
    final dance = danceActivities[selectedDance];
    _speakText("${dance['name']}. ${dance['description']}");
  }

  void _viewSong(int index) {
    setState(() {
      _viewedSongs.add(index);
    });
  }

  void _viewMove(int index) {
    setState(() {
      _viewedMoves.add(index);
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
      length: 3,
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
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFFF8E53),
                  Color(0xFFFFAA5A),
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
          elevation: 8,
          title: const Text(
            "Dance Activities",
            style: TextStyle(
              fontSize: 18,
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
            tabs: [
              Tab(text: "Dances"),
              Tab(text: "Songs"),
              Tab(text: "Moves"),
            ],
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
              stops: [0.0, 0.3, 0.7, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: TabBarView(
            children: [_buildDancesTab(), _buildSongsTab(), _buildMovesTab()],
          ),
        ),
        bottomNavigationBar: const AdsScreen(),
      ),
    );
  }

  Widget _buildDancesTab() {
    final dance = danceActivities[selectedDance];
    final isCompleted = _viewedDances.contains(selectedDance);
    final gradient = AppColors.getGradientForIndex(selectedDance);

    return Column(
      children: [
        _buildProgressBar(_viewedDances.length, danceActivities.length),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Main Dance Card with float animation
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
                      setState(() {
                        _viewedDances.add(selectedDance);
                        _currentDanceTapped = true;
                      });
                      _speakText("${dance['name']}. ${dance['description']}");
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
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
                                    dance['emoji'],
                                    style: const TextStyle(fontSize: 45),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                dance['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                dance['description'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
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
                      onPressed: _previousDance,
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
                      onPressed: _nextDance,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Next"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF56D97F),
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

  Widget _buildSongsTab() {
    return Column(
      children: [
        _buildProgressBar(_viewedSongs.length, actionSongs.length),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: actionSongs.length,
            itemBuilder: (context, index) {
              final song = actionSongs[index];
              final isCompleted = _viewedSongs.contains(index);
              final gradient = AppColors.getGradientForIndex(index);

              return GestureDetector(
                onTap: () {
                  _viewSong(index);
                  _speakText("${song['name']}. ${song['action']}");
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
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: gradient[0].withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: [
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
                                        song['emoji'],
                                        style: const TextStyle(fontSize: 28),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      song['name'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.volume_up,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                song['action'],
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Tick mark if completed
                        if (isCompleted)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
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
    );
  }

  Widget _buildMovesTab() {
    return Column(
      children: [
        _buildProgressBar(_viewedMoves.length, danceMoves.length),
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
                  itemCount: danceMoves.length,
                  itemBuilder: (context, index) {
                    final move = danceMoves[index];
                    final gradient = AppColors.getGradientForIndex(index);
                    final isCompleted = _viewedMoves.contains(index);

                    return GestureDetector(
                      onTap: () {
                        _viewMove(index);
                        _speakText("${move['move']}. ${move['how']}");
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
                              // Decorative circle
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
                                          move['emoji'],
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
                                        move['move'],
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
                  child: const Column(
                    children: [
                      Text(
                        "💃 Let's Dance!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Dancing makes you happy and healthy!",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Move your body every day!",
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
