import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class DigitalEtiquettePage extends StatefulWidget {
  const DigitalEtiquettePage({super.key});

  @override
  State<DigitalEtiquettePage> createState() => _DigitalEtiquettePageState();
}

class _DigitalEtiquettePageState extends State<DigitalEtiquettePage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  int selectedIndex = -1;
  late AnimationController _bubbleController;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Digital Etiquette?',
      'emoji': '🌟',
      'subtitle': 'Introduction',
      'color': Color(0xFF9C27B0),
      'content':
          'Digital etiquette means having good manners online! It\'s how we should behave when using computers, phones, and the internet.',
      'comparison': [
        {
          'real': 'Say please and thank you',
          'digital': 'Use kind words in messages'
        },
        {
          'real': 'Don\'t yell at people',
          'digital': 'Don\'t write in ALL CAPS'
        },
        {
          'real': 'Wait your turn',
          'digital': 'Don\'t interrupt video calls'
        },
        {
          'real': 'Be respectful',
          'digital': 'Treat everyone kindly online'
        },
      ],
    },
    {
      'title': 'Messaging Manners',
      'emoji': '💬',
      'subtitle': 'Chat Rules',
      'color': Color(0xFF2196F3),
      'dos': [
        {'rule': 'Use proper spelling', 'emoji': '✏️'},
        {'rule': 'Say hi and bye', 'emoji': '👋'},
        {'rule': 'Read before replying', 'emoji': '👀'},
        {'rule': 'Be patient for replies', 'emoji': '⏰'},
        {'rule': 'Use emojis nicely', 'emoji': '😊'},
      ],
      'donts': [
        {'rule': 'Don\'t send too many messages', 'emoji': '📧❌'},
        {
          'rule': 'Don\'t use ALL CAPS (it\'s shouting!)',
          'emoji': '🗣️❌'
        },
        {'rule': 'Don\'t share mean messages', 'emoji': '😠❌'},
        {'rule': 'Don\'t send before thinking', 'emoji': '🤔'},
      ],
    },
    {
      'title': 'Video Call Rules',
      'emoji': '📹',
      'subtitle': 'Online Meetings',
      'color': Color(0xFF4CAF50),
      'before': [
        {'rule': 'Find a quiet place', 'emoji': '🤫'},
        {'rule': 'Check your background', 'emoji': '🖼️'},
        {'rule': 'Have good lighting', 'emoji': '💡'},
        {'rule': 'Test your microphone', 'emoji': '🎤'},
      ],
      'during': [
        {'rule': 'Mute when not talking', 'emoji': '🔇'},
        {'rule': 'Look at the camera', 'emoji': '👀'},
        {'rule': 'Don\'t eat on camera', 'emoji': '🍔❌'},
        {'rule': 'Raise hand to speak', 'emoji': '✋'},
        {'rule': 'Listen when others talk', 'emoji': '👂'},
      ],
    },
    {
      'title': 'Social Media Kindness',
      'emoji': '❤️',
      'subtitle': 'Spread Love',
      'color': Color(0xFFE91E63),
      'intro': 'Social media should be a happy place. Spread kindness!',
      'kindActions': [
        {'action': 'Post positive things', 'emoji': '🌈'},
        {'action': 'Give nice compliments', 'emoji': '💕'},
        {'action': 'Share helpful information', 'emoji': '📚'},
        {'action': 'Support your friends', 'emoji': '🤝'},
        {'action': 'Report mean content', 'emoji': '🛡️'},
      ],
      'thinkBeforePost': {
        'T': 'Is it True?',
        'H': 'Is it Helpful?',
        'I': 'Is it Inspiring?',
        'N': 'Is it Necessary?',
        'K': 'Is it Kind?',
      },
    },
    {
      'title': 'Gaming Etiquette',
      'emoji': '🎮',
      'subtitle': 'Fair Play',
      'color': Color(0xFFFF9800),
      'rules': [
        {'rule': 'Play fair - no cheating!', 'emoji': '⚖️'},
        {'rule': 'Be a good sport - win or lose', 'emoji': '🏆'},
        {'rule': 'Don\'t rage quit', 'emoji': '😤❌'},
        {'rule': 'Help new players', 'emoji': '🤝'},
        {'rule': 'Keep game chat friendly', 'emoji': '💬'},
        {'rule': 'Take breaks', 'emoji': '⏸️'},
        {'rule': 'Don\'t share personal info', 'emoji': '🔒'},
      ],
      'goodGamer': 'A good gamer makes the game fun for everyone!',
    },
    {
      'title': 'Email Basics',
      'emoji': '📧',
      'subtitle': 'Write Well',
      'color': Color(0xFF00BCD4),
      'parts': [
        {'part': 'To', 'desc': 'Who gets the email', 'emoji': '👤'},
        {
          'part': 'Subject',
          'desc': 'What it\'s about',
          'emoji': '📋'
        },
        {
          'part': 'Greeting',
          'desc': 'Say hi! (Dear..., Hi...)',
          'emoji': '👋'
        },
        {'part': 'Body', 'desc': 'Your message', 'emoji': '📝'},
        {
          'part': 'Closing',
          'desc': 'End nicely (Best, Thanks)',
          'emoji': '👍'
        },
        {'part': 'Signature', 'desc': 'Your name', 'emoji': '✍️'},
      ],
      'tips': [
        'Use a clear subject line',
        'Keep messages short and clear',
        'Check spelling before sending',
        'Be polite and respectful',
      ],
    },
    {
      'title': 'Respecting Others',
      'emoji': '🙏',
      'subtitle': 'Be Kind',
      'color': Color(0xFF795548),
      'rules': [
        {
          'rule': 'Ask before sharing someone\'s photo',
          'emoji': '📷'
        },
        {'rule': 'Respect different opinions', 'emoji': '🤔'},
        {'rule': 'Don\'t make fun of others', 'emoji': '😔❌'},
        {'rule': 'Keep secrets secret', 'emoji': '🤐'},
        {
          'rule': 'Give credit when sharing others\' work',
          'emoji': '🎨'
        },
        {'rule': 'Include everyone', 'emoji': '👫'},
      ],
      'golden':
          'The Golden Rule: Treat others online how you want to be treated!',
    },
    {
      'title': 'Digital Checklist',
      'emoji': '✅',
      'subtitle': 'Good Habits',
      'color': Color(0xFF673AB7),
      'checklist': [
        {'item': 'I am kind in all my messages', 'emoji': '💕'},
        {'item': 'I think before I post or send', 'emoji': '🤔'},
        {'item': 'I respect others\' privacy', 'emoji': '🔒'},
        {'item': 'I follow video call rules', 'emoji': '📹'},
        {'item': 'I am a good sport in games', 'emoji': '🎮'},
        {'item': 'I write polite emails', 'emoji': '📧'},
        {'item': 'I ask for permission', 'emoji': '✋'},
        {'item': 'I spread positivity online', 'emoji': '🌟'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    initGridAnimations(this, floatRange: 2.0, pulseMax: 1.0);
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Digital Etiquette',
      bottomNavigationBar: const AdsScreen(),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.refresh, color: Colors.white, size: 20),
          ),
          onPressed: () {
            ProgressService.to
                .resetProgress(ProgressService.kDigitalEtiquette);
            setState(() {});
          },
        ),
      ],
      body: Stack(
        children: [
          ..._buildFloatingBubbles(),
          Column(
            children: [
              Obx(() {
                final progress =
                    ProgressService.to.getProgressPercentage(
                          ProgressService.kDigitalEtiquette,
                        ) /
                        100;
                final progressString =
                    ProgressService.to.getProgressString(
                  ProgressService.kDigitalEtiquette,
                );
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
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
                            '$progressString completed',
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
                          backgroundColor:
                              Colors.white.withValues(alpha: 0.2),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4CAF50),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    final gradient =
                        AppColors.getGradientForIndex(index);

                    return Obx(() {
                      final isSelected = selectedIndex == index;
                      final isCompleted =
                          ProgressService.to.isItemCompleted(
                        ProgressService.kDigitalEtiquette,
                        index,
                      );

                      return buildFloatingItem(
                        index: index,
                        child: GradientCard(
                          gradient: gradient,
                          isSelected: isSelected,
                          showDecorations: true,
                          onTap: () {
                            TtsService.to.speak(section['title']);
                            setState(() {
                              selectedIndex = index;
                            });
                            ProgressService.to.markItemCompleted(
                              ProgressService.kDigitalEtiquette,
                              index,
                            );
                            Get.to(() =>
                                _DigitalEtiquetteDetailPage(
                                  section: section,
                                  sectionIndex: index,
                                ));
                          },
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 65,
                                      height: 65,
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.25),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          section['emoji'],
                                          style: const TextStyle(
                                              fontSize: 32),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      section['title'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow:
                                          TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      section['subtitle'],
                                      style: GoogleFonts.nunito(
                                        fontSize: 11,
                                        color: Colors.white
                                            .withValues(alpha: 0.9),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              if (isCompleted)
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(2),
                                    decoration:
                                        const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingBubbles() {
    final random = math.Random(42);
    return List.generate(8, (index) {
      final size = 20.0 + random.nextDouble() * 60;
      final left = random.nextDouble() * 400;
      final top = random.nextDouble() * 800;
      final delay = random.nextDouble();

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + delay) % 1.0;
          final yOffset = -progress * 200;
          final opacity = (1 - progress) * 0.15;

          return Positioned(
            left: left,
            top: top + yOffset,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: opacity),
                    Colors.white.withValues(alpha: opacity * 0.3),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

/// Detail page for each Digital Etiquette section
class _DigitalEtiquetteDetailPage extends StatefulWidget {
  final Map<String, dynamic> section;
  final int sectionIndex;

  const _DigitalEtiquetteDetailPage({
    required this.section,
    required this.sectionIndex,
  });

  @override
  State<_DigitalEtiquetteDetailPage> createState() =>
      _DigitalEtiquetteDetailPageState();
}

class _DigitalEtiquetteDetailPageState
    extends State<_DigitalEtiquetteDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  Map<String, dynamic> get section => widget.section;
  int get sectionIndex => widget.sectionIndex;
  late AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();
    initGridAnimations(this);
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: section['title'],
      bottomNavigationBar: const AdsScreen(),
      body: Stack(
        children: [
          ..._buildFloatingBubbles(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(section['emoji'],
                          style: const TextStyle(fontSize: 50)),
                      const SizedBox(height: 12),
                      Text(
                        section['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (section.containsKey('content')) ...[
                        const SizedBox(height: 12),
                        Text(
                          section['content'],
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      if (section.containsKey('intro')) ...[
                        const SizedBox(height: 12),
                        Text(
                          section['intro'],
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (sectionIndex) {
      case 0:
        return _buildIntro();
      case 1:
        return _buildMessaging();
      case 2:
        return _buildVideoCalls();
      case 3:
        return _buildSocialMedia();
      case 4:
        return _buildGaming();
      case 5:
        return _buildEmail();
      case 6:
        return _buildRespect();
      case 7:
        return _buildChecklist();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildIntro() {
    return Column(
      children: List.generate(
          (section['comparison'] as List).length, (index) {
        final item = section['comparison'][index];
        final gradient = AppColors.getGradientForIndex(index);
        return buildFloatingItem(
          index: index,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🏠 Real',
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        item['real'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text('=',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '💻 Digital',
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        item['digital'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMessaging() {
    int cardIndex = 0;
    return Column(
      children: [
        // Dos
        ...List.generate((section['dos'] as List).length, (index) {
          final item = section['dos'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: cardIndex++,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(item['emoji'],
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '✅ ${item['rule']}',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        // Don'ts
        ...List.generate(
            (section['donts'] as List).length, (index) {
          final item = section['donts'][index];
          final gradient =
              AppColors.getGradientForIndex(index + 5);
          return buildFloatingItem(
            index: cardIndex++,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(item['emoji'],
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '❌ ${item['rule']}',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildVideoCalls() {
    int cardIndex = 0;
    return Column(
      children: [
        // Before
        ...List.generate(
            (section['before'] as List).length, (index) {
          final item = section['before'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: cardIndex++,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(item['emoji'],
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '🔧 ${item['rule']}',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        // During
        ...List.generate(
            (section['during'] as List).length, (index) {
          final item = section['during'][index];
          final gradient =
              AppColors.getGradientForIndex(index + 4);
          return buildFloatingItem(
            index: cardIndex++,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(item['emoji'],
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '📹 ${item['rule']}',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSocialMedia() {
    int cardIndex = 0;
    return Column(
      children: [
        // Kind actions
        ...List.generate(
            (section['kindActions'] as List).length, (index) {
          final item = section['kindActions'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: cardIndex++,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(item['emoji'],
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(
                    item['action'],
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        // THINK before post
        buildFloatingItem(
          index: cardIndex++,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.getGradientForIndex(5),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getGradientForIndex(5)[0]
                      .withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🤔 THINK Before You Post:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                ...(section['thinkBeforePost'] as Map)
                    .entries
                    .map((entry) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          entry.value,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGaming() {
    return Column(
      children: [
        ...List.generate(
            (section['rules'] as List).length, (index) {
          final item = section['rules'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: index,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(item['emoji'],
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['rule'],
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('🌟',
                  style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['goodGamer'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmail() {
    int cardIndex = 0;
    return Column(
      children: [
        // Email parts
        ...List.generate(
            (section['parts'] as List).length, (index) {
          final part = section['parts'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: cardIndex++,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          part['part'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          part['desc'],
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(part['emoji'],
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        // Tips
        buildFloatingItem(
          index: cardIndex++,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.getGradientForIndex(6),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getGradientForIndex(6)[0]
                      .withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 Email Tips:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ...(section['tips'] as List).map((tip) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.white70, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tip,
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRespect() {
    return Column(
      children: [
        ...List.generate(
            (section['rules'] as List).length, (index) {
          final item = section['rules'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: index,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(item['emoji'],
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['rule'],
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('✨',
                  style: TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text(
                section['golden'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChecklist() {
    return Column(
      children: List.generate(
          (section['checklist'] as List).length, (index) {
        final item = section['checklist'][index];
        final gradient = AppColors.getGradientForIndex(index);
        return buildFloatingItem(
          index: index,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item['item'],
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(item['emoji'],
                    style: const TextStyle(fontSize: 22)),
              ],
            ),
          ),
        );
      }),
    );
  }

  List<Widget> _buildFloatingBubbles() {
    final random = math.Random(42);
    return List.generate(8, (index) {
      final size = 20.0 + random.nextDouble() * 60;
      final left = random.nextDouble() * 400;
      final top = random.nextDouble() * 800;
      final delay = random.nextDouble();

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + delay) % 1.0;
          final yOffset = -progress * 200;
          final opacity = (1 - progress) * 0.15;

          return Positioned(
            left: left,
            top: top + yOffset,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: opacity),
                    Colors.white.withValues(alpha: opacity * 0.3),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
