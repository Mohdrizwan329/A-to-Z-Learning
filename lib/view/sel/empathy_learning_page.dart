import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class EmpathyLearningPage extends StatefulWidget {
  const EmpathyLearningPage({super.key});

  @override
  State<EmpathyLearningPage> createState() => _EmpathyLearningPageState();
}

class _EmpathyLearningPageState extends State<EmpathyLearningPage>
    with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  int selectedScenario = 0;
  bool _currentScenarioTapped = false;
  Set<int> _viewedScenarios = {};
  Set<int> _viewedKindness = {};
  Set<int> _viewedFeelings = {};

  final List<Map<String, dynamic>> empathyScenarios = [
    {
      'title': 'A Friend Falls Down',
      'emoji': '🤕',
      'situation': 'Your friend trips and falls on the playground.',
      'howTheyFeel': 'They might feel hurt, embarrassed, and sad.',
      'kindActions': [
        'Help them get up',
        'Ask if they are okay',
        'Get an adult if needed',
        'Stay with them',
      ],
    },
    {
      'title': 'Someone is Alone',
      'emoji': '😔',
      'situation': 'A classmate is sitting alone at lunch.',
      'howTheyFeel': 'They might feel lonely, left out, or shy.',
      'kindActions': [
        'Invite them to sit with you',
        'Say hello and smile',
        'Ask if they want to play',
        'Be their friend',
      ],
    },
    {
      'title': 'Lost Toy',
      'emoji': '🧸',
      'situation': 'Your little sibling can\'t find their favorite toy.',
      'howTheyFeel': 'They might feel sad, worried, and upset.',
      'kindActions': [
        'Help them look for it',
        'Give them a hug',
        'Share your toys',
        'Don\'t make fun of them',
      ],
    },
    {
      'title': 'New Student',
      'emoji': '🆕',
      'situation': 'A new student joins your class and looks nervous.',
      'howTheyFeel': 'They might feel scared, shy, and worried.',
      'kindActions': [
        'Introduce yourself',
        'Show them around',
        'Invite them to play',
        'Be patient and kind',
      ],
    },
    {
      'title': 'Someone Made a Mistake',
      'emoji': '❌',
      'situation': 'A friend accidentally spills their juice.',
      'howTheyFeel': 'They might feel embarrassed and sorry.',
      'kindActions': [
        'Help clean up',
        'Say it\'s okay',
        'Don\'t laugh at them',
        'Share your drink',
      ],
    },
    {
      'title': 'Pet is Sick',
      'emoji': '🐕',
      'situation': 'Your friend\'s pet is sick and they are sad.',
      'howTheyFeel': 'They might feel worried, scared, and sad.',
      'kindActions': [
        'Listen to them',
        'Give a hug',
        'Make a card',
        'Be there for them',
      ],
    },
    {
      'title': 'Someone is Crying',
      'emoji': '😭',
      'situation': 'You see a child crying in the park.',
      'howTheyFeel': 'They might feel scared, lost, or hurt.',
      'kindActions': [
        'Ask if they need help',
        'Find their parents',
        'Stay with them',
        'Comfort them',
      ],
    },
    {
      'title': 'Friend Got Bad Grade',
      'emoji': '📝',
      'situation': 'Your friend is upset about a bad test score.',
      'howTheyFeel': 'They might feel disappointed and worried.',
      'kindActions': [
        'Tell them it\'s okay',
        'Offer to study together',
        'Remind them everyone makes mistakes',
        'Be encouraging',
      ],
    },
    {
      'title': 'Grandparent is Unwell',
      'emoji': '👴',
      'situation': 'A friend\'s grandparent is in the hospital.',
      'howTheyFeel': 'They might feel scared, sad, and worried.',
      'kindActions': [
        'Listen to them',
        'Send a card',
        'Be extra kind',
        'Check on them daily',
      ],
    },
    {
      'title': 'Moving Away',
      'emoji': '🏠',
      'situation': 'Your best friend is moving to another city.',
      'howTheyFeel': 'They might feel sad, scared, and excited.',
      'kindActions': [
        'Plan fun last days together',
        'Make a memory book',
        'Promise to stay in touch',
        'Be supportive',
      ],
    },
    {
      'title': 'Birthday Forgotten',
      'emoji': '🎂',
      'situation': 'Someone forgot your friend\'s birthday.',
      'howTheyFeel': 'They might feel hurt, sad, and forgotten.',
      'kindActions': [
        'Make them feel special',
        'Plan a surprise',
        'Give them a card',
        'Spend time with them',
      ],
    },
    {
      'title': 'Lost in Store',
      'emoji': '🛒',
      'situation': 'A little kid is lost in a store.',
      'howTheyFeel': 'They might feel scared, confused, and alone.',
      'kindActions': [
        'Find a store worker',
        'Stay with them',
        'Keep them calm',
        'Help find their parents',
      ],
    },
    {
      'title': 'Team Lost Game',
      'emoji': '⚽',
      'situation': 'Your team lost an important game.',
      'howTheyFeel': 'Everyone might feel disappointed and sad.',
      'kindActions': [
        'Say good game',
        'Focus on having fun',
        'Practice for next time',
        'Support teammates',
      ],
    },
    {
      'title': 'Feeling Left Out',
      'emoji': '🚶',
      'situation': 'Someone wasn\'t invited to a party.',
      'howTheyFeel': 'They might feel sad, left out, and hurt.',
      'kindActions': [
        'Include them in your plans',
        'Invite them to play',
        'Be a good friend',
        'Make them feel valued',
      ],
    },
    {
      'title': 'Fear of Dark',
      'emoji': '🌙',
      'situation': 'Your younger sibling is scared of the dark.',
      'howTheyFeel': 'They might feel scared, anxious, and worried.',
      'kindActions': [
        'Stay with them',
        'Get a night light',
        'Read them a story',
        'Tell them it\'s safe',
      ],
    },
    {
      'title': 'Broke Something',
      'emoji': '💔',
      'situation': 'A friend accidentally broke your toy.',
      'howTheyFeel': 'They might feel guilty, sorry, and scared.',
      'kindActions': [
        'Tell them accidents happen',
        'Don\'t get angry',
        'Forgive them',
        'It\'s just a thing',
      ],
    },
    {
      'title': 'Stage Fright',
      'emoji': '🎭',
      'situation': 'Someone is nervous about performing.',
      'howTheyFeel': 'They might feel scared, anxious, and worried.',
      'kindActions': [
        'Encourage them',
        'Say they will do great',
        'Practice with them',
        'Cheer for them',
      ],
    },
    {
      'title': 'First Day of School',
      'emoji': '🏫',
      'situation': 'A child is nervous on their first day.',
      'howTheyFeel': 'They might feel scared, excited, and anxious.',
      'kindActions': [
        'Be welcoming',
        'Show them around',
        'Introduce them to others',
        'Be friendly',
      ],
    },
    {
      'title': 'Lost Pet',
      'emoji': '🐱',
      'situation': 'A friend\'s pet ran away.',
      'howTheyFeel': 'They might feel heartbroken, worried, and sad.',
      'kindActions': [
        'Help search',
        'Make lost posters',
        'Be supportive',
        'Check on them',
      ],
    },
    {
      'title': 'Parent Away',
      'emoji': '✈️',
      'situation': 'A friend\'s parent is traveling for work.',
      'howTheyFeel': 'They might feel lonely, sad, and missing them.',
      'kindActions': [
        'Spend time with them',
        'Invite them over',
        'Be understanding',
        'Help distract them',
      ],
    },
    {
      'title': 'Glasses Teasing',
      'emoji': '👓',
      'situation': 'Someone is being teased for wearing glasses.',
      'howTheyFeel': 'They might feel embarrassed, sad, and hurt.',
      'kindActions': [
        'Stand up for them',
        'Tell them glasses are cool',
        'Be their friend',
        'Report bullying',
      ],
    },
    {
      'title': 'Haircut Gone Wrong',
      'emoji': '💇',
      'situation': 'A friend doesn\'t like their new haircut.',
      'howTheyFeel': 'They might feel embarrassed and upset.',
      'kindActions': [
        'Tell them it looks nice',
        'Say hair grows back',
        'Don\'t tease them',
        'Boost their confidence',
      ],
    },
    {
      'title': 'Difficulty Reading',
      'emoji': '📖',
      'situation': 'A classmate struggles to read aloud.',
      'howTheyFeel': 'They might feel embarrassed and frustrated.',
      'kindActions': [
        'Don\'t laugh',
        'Offer to help',
        'Be patient',
        'Encourage them',
      ],
    },
    {
      'title': 'Homesick at Camp',
      'emoji': '🏕️',
      'situation': 'Someone is homesick at summer camp.',
      'howTheyFeel': 'They might feel sad, lonely, and scared.',
      'kindActions': [
        'Spend time with them',
        'Talk about fun activities',
        'Help them write home',
        'Be their buddy',
      ],
    },
    {
      'title': 'Argument with Friend',
      'emoji': '😤',
      'situation': 'Two friends had a fight.',
      'howTheyFeel': 'Both might feel angry, hurt, and sad.',
      'kindActions': [
        'Help them talk',
        'Don\'t take sides',
        'Suggest making up',
        'Be a peacemaker',
      ],
    },
    {
      'title': 'Didn\'t Make Team',
      'emoji': '🏀',
      'situation': 'Someone didn\'t make the sports team.',
      'howTheyFeel': 'They might feel disappointed and sad.',
      'kindActions': [
        'Tell them they did their best',
        'Suggest other activities',
        'Practice with them',
        'Be supportive',
      ],
    },
    {
      'title': 'Braces Problems',
      'emoji': '😬',
      'situation': 'A friend just got braces and feels weird.',
      'howTheyFeel': 'They might feel uncomfortable and self-conscious.',
      'kindActions': [
        'Tell them it\'s temporary',
        'Share braces stories',
        'Don\'t tease',
        'Be understanding',
      ],
    },
    {
      'title': 'Forgot Lunch',
      'emoji': '🍱',
      'situation': 'Someone forgot their lunch at home.',
      'howTheyFeel': 'They might feel hungry, upset, and embarrassed.',
      'kindActions': [
        'Share your food',
        'Help them get lunch',
        'Don\'t make a big deal',
        'Be helpful',
      ],
    },
    {
      'title': 'Nightmare',
      'emoji': '😰',
      'situation': 'Your sibling had a scary nightmare.',
      'howTheyFeel': 'They might feel scared, anxious, and tired.',
      'kindActions': [
        'Comfort them',
        'Stay with them',
        'Tell them it\'s not real',
        'Help them feel safe',
      ],
    },
    {
      'title': 'Learning Disability',
      'emoji': '🧩',
      'situation': 'A classmate learns differently than others.',
      'howTheyFeel': 'They might feel frustrated and different.',
      'kindActions': [
        'Be patient',
        'Offer help',
        'Include them',
        'Treat them equally',
      ],
    },
    {
      'title': 'Parents Arguing',
      'emoji': '🏡',
      'situation': 'A friend is upset because parents are fighting.',
      'howTheyFeel': 'They might feel scared, sad, and worried.',
      'kindActions': [
        'Listen to them',
        'Let them talk',
        'Be supportive',
        'Remind them it\'s not their fault',
      ],
    },
    {
      'title': 'Allergic Reaction',
      'emoji': '🤧',
      'situation': 'Someone can\'t eat the birthday cake due to allergies.',
      'howTheyFeel': 'They might feel left out and sad.',
      'kindActions': [
        'Share something they can eat',
        'Don\'t make a big deal',
        'Include them in fun',
        'Be understanding',
      ],
    },
    {
      'title': 'Wheelchair User',
      'emoji': '♿',
      'situation': 'A new student uses a wheelchair.',
      'howTheyFeel': 'They might feel different and nervous.',
      'kindActions': [
        'Be welcoming',
        'Include them in activities',
        'Ask how you can help',
        'Treat them normally',
      ],
    },
    {
      'title': 'Speech Difficulty',
      'emoji': '🗣️',
      'situation': 'A classmate has trouble speaking clearly.',
      'howTheyFeel': 'They might feel frustrated and embarrassed.',
      'kindActions': [
        'Listen patiently',
        'Don\'t finish their sentences',
        'Be encouraging',
        'Never mock them',
      ],
    },
    {
      'title': 'Different Culture',
      'emoji': '🌍',
      'situation': 'A student from another country joins class.',
      'howTheyFeel': 'They might feel confused, lonely, and different.',
      'kindActions': [
        'Learn about their culture',
        'Teach them about yours',
        'Be a friend',
        'Help them fit in',
      ],
    },
    {
      'title': 'Shy to Participate',
      'emoji': '🙈',
      'situation': 'Someone is too shy to raise their hand.',
      'howTheyFeel': 'They might feel nervous and unsure.',
      'kindActions': [
        'Partner with them',
        'Encourage quietly',
        'Don\'t put pressure',
        'Be patient',
      ],
    },
    {
      'title': 'Lost Money',
      'emoji': '💰',
      'situation': 'A friend lost their lunch money.',
      'howTheyFeel': 'They might feel worried, upset, and scared.',
      'kindActions': [
        'Help them look',
        'Share if you can',
        'Tell a teacher',
        'Be supportive',
      ],
    },
    {
      'title': 'Embarrassed in Class',
      'emoji': '😳',
      'situation': 'Someone gave a wrong answer and feels embarrassed.',
      'howTheyFeel': 'They might feel stupid and ashamed.',
      'kindActions': [
        'Tell them everyone makes mistakes',
        'Share your own mistakes',
        'Don\'t laugh',
        'Be kind',
      ],
    },
    {
      'title': 'Bully Target',
      'emoji': '😢',
      'situation': 'Someone is being bullied by others.',
      'howTheyFeel': 'They might feel scared, sad, and alone.',
      'kindActions': [
        'Stand up for them',
        'Tell an adult',
        'Be their friend',
        'Don\'t join bullies',
      ],
    },
    {
      'title': 'Sick and Missing School',
      'emoji': '🤒',
      'situation': 'A friend has been sick for a week.',
      'howTheyFeel': 'They might feel lonely, bored, and worried.',
      'kindActions': [
        'Send get well wishes',
        'Help with homework',
        'Video call them',
        'Make them a card',
      ],
    },
    {
      'title': 'Dropped Ice Cream',
      'emoji': '🍦',
      'situation': 'A child drops their ice cream cone.',
      'howTheyFeel': 'They might feel sad and disappointed.',
      'kindActions': [
        'Share yours',
        'Help buy a new one',
        'Comfort them',
        'Don\'t laugh',
      ],
    },
    {
      'title': 'Can\'t Afford Trip',
      'emoji': '🚌',
      'situation': 'Someone can\'t afford the class field trip.',
      'howTheyFeel': 'They might feel embarrassed and left out.',
      'kindActions': [
        'Don\'t make them feel bad',
        'Ask teacher for help',
        'Be sensitive',
        'Include them otherwise',
      ],
    },
    {
      'title': 'Divorced Parents',
      'emoji': '💔',
      'situation': 'A friend\'s parents are getting divorced.',
      'howTheyFeel': 'They might feel confused, sad, and scared.',
      'kindActions': [
        'Listen to them',
        'Be extra kind',
        'Don\'t ask too many questions',
        'Just be there',
      ],
    },
    {
      'title': 'Wrong Clothes',
      'emoji': '👕',
      'situation': 'Someone wore wrong outfit for an event.',
      'howTheyFeel': 'They might feel embarrassed and out of place.',
      'kindActions': [
        'Tell them they look fine',
        'Don\'t point it out',
        'Be supportive',
        'Help them feel included',
      ],
    },
    {
      'title': 'Forgotten Lines',
      'emoji': '🎬',
      'situation': 'Someone forgets their lines in the school play.',
      'howTheyFeel': 'They might feel embarrassed and panicked.',
      'kindActions': [
        'Whisper a hint',
        'Don\'t laugh',
        'Tell them it happens',
        'Encourage them',
      ],
    },
    {
      'title': 'Lost Game',
      'emoji': '🎮',
      'situation': 'A friend keeps losing at a game.',
      'howTheyFeel': 'They might feel frustrated and upset.',
      'kindActions': [
        'Help them learn',
        'Let them win sometimes',
        'Say it\'s just a game',
        'Be a good sport',
      ],
    },
    {
      'title': 'Hearing Difficulty',
      'emoji': '👂',
      'situation': 'A classmate has hearing problems.',
      'howTheyFeel': 'They might feel isolated and frustrated.',
      'kindActions': [
        'Speak clearly',
        'Face them when talking',
        'Include them',
        'Be patient',
      ],
    },
    {
      'title': 'Vision Problems',
      'emoji': '👀',
      'situation': 'Someone can\'t see the board clearly.',
      'howTheyFeel': 'They might feel frustrated and left out.',
      'kindActions': [
        'Help them read notes',
        'Tell the teacher',
        'Be understanding',
        'Don\'t tease',
      ],
    },
    {
      'title': 'New Baby Sibling',
      'emoji': '👶',
      'situation': 'A friend feels ignored after new baby arrives.',
      'howTheyFeel': 'They might feel jealous, sad, and left out.',
      'kindActions': [
        'Spend time with them',
        'Listen to their feelings',
        'Remind them they\'re loved',
        'Be understanding',
      ],
    },
    {
      'title': 'Failure Fear',
      'emoji': '😟',
      'situation': 'Someone is afraid to try new things.',
      'howTheyFeel': 'They might feel scared and unsure.',
      'kindActions': [
        'Encourage them',
        'Try together',
        'Celebrate small wins',
        'Be supportive',
      ],
    },
  ];

  final List<Map<String, dynamic>> kindnessIdeas = [
    {'action': 'Give someone a compliment', 'emoji': '💬'},
    {'action': 'Help someone carry things', 'emoji': '🎒'},
    {'action': 'Share your snacks', 'emoji': '🍪'},
    {'action': 'Include everyone in games', 'emoji': '⚽'},
    {'action': 'Write a thank you note', 'emoji': '✉️'},
    {'action': 'Help with chores at home', 'emoji': '🏠'},
    {'action': 'Smile at people', 'emoji': '😊'},
    {'action': 'Pick up trash you see', 'emoji': '🗑️'},
    {'action': 'Hold the door for others', 'emoji': '🚪'},
    {'action': 'Say please and thank you', 'emoji': '🙏'},
    {'action': 'Let someone go first', 'emoji': '👆'},
    {'action': 'Help a younger kid', 'emoji': '👦'},
    {'action': 'Make a card for someone', 'emoji': '🎨'},
    {'action': 'Listen when others talk', 'emoji': '👂'},
    {'action': 'Give a sincere apology', 'emoji': '💕'},
    {'action': 'Cheer for others', 'emoji': '📣'},
    {'action': 'Share your toys', 'emoji': '🧸'},
    {'action': 'Help set the table', 'emoji': '🍽️'},
    {'action': 'Water the plants', 'emoji': '🌱'},
    {'action': 'Feed the pets', 'emoji': '🐕'},
    {'action': 'Make your bed', 'emoji': '🛏️'},
    {'action': 'Call grandparents', 'emoji': '📞'},
    {'action': 'Draw a picture for someone', 'emoji': '🖼️'},
    {'action': 'Tell a joke to make someone laugh', 'emoji': '😂'},
    {'action': 'Help carry groceries', 'emoji': '🛒'},
    {'action': 'Read to a younger sibling', 'emoji': '📚'},
    {'action': 'Give a hug when needed', 'emoji': '🤗'},
    {'action': 'Wave to neighbors', 'emoji': '👋'},
    {'action': 'Leave a nice note', 'emoji': '📝'},
    {'action': 'Offer your seat to elders', 'emoji': '💺'},
    {'action': 'Help someone who dropped something', 'emoji': '📦'},
    {'action': 'Be patient in line', 'emoji': '⏳'},
    {'action': 'Clean up without being asked', 'emoji': '🧹'},
    {'action': 'Donate old toys', 'emoji': '🎁'},
    {'action': 'Write an encouraging message', 'emoji': '✨'},
    {'action': 'Help a friend study', 'emoji': '📖'},
    {'action': 'Share your umbrella', 'emoji': '☂️'},
    {'action': 'Invite someone to play', 'emoji': '🎮'},
    {'action': 'Remember birthdays', 'emoji': '🎂'},
    {'action': 'Offer to help teachers', 'emoji': '👩‍🏫'},
    {'action': 'Be a good listener', 'emoji': '🎧'},
    {'action': 'Give genuine compliments', 'emoji': '⭐'},
    {'action': 'Help with homework', 'emoji': '✏️'},
    {'action': 'Make someone feel included', 'emoji': '🤝'},
    {'action': 'Celebrate others\' success', 'emoji': '🎉'},
    {'action': 'Be thankful out loud', 'emoji': '💝'},
    {'action': 'Forgive quickly', 'emoji': '💗'},
    {'action': 'Stand up against bullying', 'emoji': '🦸'},
    {'action': 'Help plant a tree', 'emoji': '🌳'},
    {'action': 'Send a kind text', 'emoji': '📱'},
  ];

  final List<Map<String, dynamic>> feelings = [
    {
      'feeling': 'Happy',
      'emoji': '😊',
      'description': 'Feeling joyful and content',
    },
    {'feeling': 'Sad', 'emoji': '😢', 'description': 'Feeling down or unhappy'},
    {
      'feeling': 'Scared',
      'emoji': '😨',
      'description': 'Feeling afraid or frightened',
    },
    {
      'feeling': 'Angry',
      'emoji': '😠',
      'description': 'Feeling mad or frustrated',
    },
    {
      'feeling': 'Excited',
      'emoji': '🤩',
      'description': 'Feeling enthusiastic and eager',
    },
    {
      'feeling': 'Worried',
      'emoji': '😟',
      'description': 'Feeling anxious about something',
    },
    {
      'feeling': 'Surprised',
      'emoji': '😲',
      'description': 'Feeling shocked or amazed',
    },
    {
      'feeling': 'Confused',
      'emoji': '😕',
      'description': 'Feeling unsure or puzzled',
    },
    {
      'feeling': 'Proud',
      'emoji': '🥹',
      'description': 'Feeling good about achievements',
    },
    {
      'feeling': 'Shy',
      'emoji': '😳',
      'description': 'Feeling nervous around others',
    },
    {
      'feeling': 'Lonely',
      'emoji': '😔',
      'description': 'Feeling alone or isolated',
    },
    {
      'feeling': 'Grateful',
      'emoji': '🥰',
      'description': 'Feeling thankful and appreciative',
    },
    {
      'feeling': 'Jealous',
      'emoji': '😒',
      'description': 'Wanting what others have',
    },
    {
      'feeling': 'Embarrassed',
      'emoji': '😅',
      'description': 'Feeling awkward or ashamed',
    },
    {'feeling': 'Bored', 'emoji': '😑', 'description': 'Feeling uninterested'},
    {
      'feeling': 'Nervous',
      'emoji': '😰',
      'description': 'Feeling uneasy or tense',
    },
    {
      'feeling': 'Hopeful',
      'emoji': '🤞',
      'description': 'Feeling optimistic about future',
    },
    {
      'feeling': 'Disappointed',
      'emoji': '😞',
      'description': 'Feeling let down',
    },
    {
      'feeling': 'Calm',
      'emoji': '😌',
      'description': 'Feeling peaceful and relaxed',
    },
    {
      'feeling': 'Frustrated',
      'emoji': '😤',
      'description': 'Feeling annoyed or stuck',
    },
    {
      'feeling': 'Loving',
      'emoji': '🥰',
      'description': 'Feeling affection for others',
    },
    {
      'feeling': 'Curious',
      'emoji': '🤔',
      'description': 'Wanting to learn or know more',
    },
    {'feeling': 'Brave', 'emoji': '😎', 'description': 'Feeling courageous'},
    {
      'feeling': 'Tired',
      'emoji': '😴',
      'description': 'Feeling sleepy or exhausted',
    },
    {
      'feeling': 'Silly',
      'emoji': '🤪',
      'description': 'Feeling playful and goofy',
    },
    {
      'feeling': 'Peaceful',
      'emoji': '☺️',
      'description': 'Feeling serene and tranquil',
    },
    {
      'feeling': 'Determined',
      'emoji': '💪',
      'description': 'Feeling focused on a goal',
    },
    {'feeling': 'Hurt', 'emoji': '🥺', 'description': 'Feeling emotional pain'},
    {
      'feeling': 'Cheerful',
      'emoji': '😄',
      'description': 'Feeling bright and happy',
    },
    {
      'feeling': 'Anxious',
      'emoji': '😬',
      'description': 'Feeling worried and restless',
    },
    {
      'feeling': 'Content',
      'emoji': '🙂',
      'description': 'Feeling satisfied and at ease',
    },
    {
      'feeling': 'Overwhelmed',
      'emoji': '😵',
      'description': 'Feeling too much at once',
    },
    {
      'feeling': 'Inspired',
      'emoji': '✨',
      'description': 'Feeling motivated to create',
    },
    {
      'feeling': 'Guilty',
      'emoji': '😓',
      'description': 'Feeling bad about something done',
    },
    {
      'feeling': 'Relaxed',
      'emoji': '😊',
      'description': 'Feeling loose and comfortable',
    },
    {
      'feeling': 'Appreciated',
      'emoji': '💖',
      'description': 'Feeling valued by others',
    },
    {
      'feeling': 'Misunderstood',
      'emoji': '😶',
      'description': 'Feeling not understood',
    },
    {
      'feeling': 'Impatient',
      'emoji': '⏰',
      'description': 'Wanting things to happen faster',
    },
    {
      'feeling': 'Amazed',
      'emoji': '🤯',
      'description': 'Feeling wonder and awe',
    },
    {
      'feeling': 'Safe',
      'emoji': '🏠',
      'description': 'Feeling protected and secure',
    },
    {
      'feeling': 'Uncomfortable',
      'emoji': '😣',
      'description': 'Feeling uneasy physically or emotionally',
    },
    {
      'feeling': 'Joyful',
      'emoji': '😁',
      'description': 'Feeling great happiness',
    },
    {
      'feeling': 'Thoughtful',
      'emoji': '💭',
      'description': 'Thinking deeply about something',
    },
    {
      'feeling': 'Confident',
      'emoji': '😏',
      'description': 'Feeling sure of yourself',
    },
    {
      'feeling': 'Generous',
      'emoji': '🤲',
      'description': 'Feeling like sharing with others',
    },
    {
      'feeling': 'Helpless',
      'emoji': '😿',
      'description': 'Feeling unable to do anything',
    },
    {
      'feeling': 'Optimistic',
      'emoji': '🌈',
      'description': 'Expecting good things',
    },
    {
      'feeling': 'Grumpy',
      'emoji': '😾',
      'description': 'Feeling irritable and cranky',
    },
    {
      'feeling': 'Friendly',
      'emoji': '👋',
      'description': 'Feeling warm towards others',
    },
    {
      'feeling': 'Respected',
      'emoji': '🙌',
      'description': 'Feeling honored by others',
    },
  ];

  void _resetProgress() {
    setState(() {
      _viewedScenarios.clear();
      _viewedKindness.clear();
      _viewedFeelings.clear();
      selectedScenario = 0;
      _currentScenarioTapped = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initTts();

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

  void _viewKindness(int index) {
    setState(() {
      _viewedKindness.add(index);
    });
  }

  void _viewFeeling(int index) {
    setState(() {
      _viewedFeelings.add(index);
    });
  }

  void _nextScenario() {
    if (!_currentScenarioTapped) {
      return;
    }
    setState(() {
      selectedScenario = (selectedScenario + 1) % empathyScenarios.length;
      _currentScenarioTapped = false;
    });
  }

  void _previousScenario() {
    setState(() {
      selectedScenario =
          (selectedScenario - 1 + empathyScenarios.length) %
          empathyScenarios.length;
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            "Empathy & Kindness",
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
            labelPadding: EdgeInsets.symmetric(horizontal: 20),
            tabs: [
              Tab(text: "Understand"),
              Tab(text: "Kindness"),
              Tab(text: "Feelings"),
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
            children: [
              _buildUnderstandTab(),
              _buildKindnessTab(),
              _buildFeelingsTab(),
            ],
          ),
        ),
        bottomNavigationBar: const AdsScreen(),
      ),
    );
  }

  Widget _buildUnderstandTab() {
    final scenario = empathyScenarios[selectedScenario];
    final isCompleted = _viewedScenarios.contains(selectedScenario);
    final gradient = AppColors.getGradientForIndex(selectedScenario);

    return Column(
      children: [
        _buildProgressBar(_viewedScenarios.length, empathyScenarios.length),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),
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
                      TtsService.to.speak(empathyScenarios[selectedScenario]['title']);
                      setState(() {
                        _viewedScenarios.add(selectedScenario);
                        _currentScenarioTapped = true;
                      });
                      _speakText(
                        "${scenario['title']}. ${scenario['situation']}. ${scenario['howTheyFeel']}",
                      );
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
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    scenario['emoji'],
                                    style: const TextStyle(fontSize: 45),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                scenario['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                scenario['situation'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "💭 How they feel:",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      scenario['howTheyFeel'],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Icon(
                                Icons.volume_up,
                                color: Colors.white70,
                                size: 30,
                              ),
                            ],
                          ),
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

                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _previousScenario,
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
                      onPressed: _nextScenario,
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

  Widget _buildKindnessTab() {
    return Column(
      children: [
        _buildProgressBar(_viewedKindness.length, kindnessIdeas.length),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: kindnessIdeas.length,
            itemBuilder: (context, index) {
              final idea = kindnessIdeas[index];
              final isCompleted = _viewedKindness.contains(index);
              final gradient = AppColors.getGradientForIndex(index);

              return GestureDetector(
                onTap: () {
                  _viewKindness(index);
                  _speakText(idea['action']);
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
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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
                        Row(
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  idea['emoji'],
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                idea['action'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Icon(Icons.volume_up, color: Colors.white70),
                          ],
                        ),
                        if (isCompleted)
                          Positioned(
                            top: 0,
                            right: 0,
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

  Widget _buildFeelingsTab() {
    return Column(
      children: [
        _buildProgressBar(_viewedFeelings.length, feelings.length),
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
                    childAspectRatio: 1.1,
                  ),
                  itemCount: feelings.length,
                  itemBuilder: (context, index) {
                    final feeling = feelings[index];
                    final isCompleted = _viewedFeelings.contains(index);
                    final gradient = AppColors.getGradientForIndex(index);

                    return GestureDetector(
                      onTap: () {
                        _viewFeeling(index);
                        _speakText(
                          "${feeling['feeling']}. ${feeling['description']}",
                        );
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
                                          feeling['emoji'],
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
                                        feeling['feeling'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                        "💡 Tip!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Look at people's eyes and mouth to understand how they feel.",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
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
