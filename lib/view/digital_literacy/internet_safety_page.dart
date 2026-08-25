import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class InternetSafetyPage extends StatefulWidget {
  const InternetSafetyPage({super.key});

  @override
  State<InternetSafetyPage> createState() => _InternetSafetyPageState();
}

class _InternetSafetyPageState extends State<InternetSafetyPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  int selectedIndex = -1;
  late AnimationController _bubbleController;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is the Internet?',
      'emoji': '🌐',
      'subtitle': 'Introduction',
      'color': Color(0xFF2196F3),
      'content':
          'The internet connects computers all around the world! It\'s like a giant web where you can find information, play games, and talk to people.',
      'visualItems': [
        {'emoji': '🏠', 'label': 'Your Home'},
        {'emoji': '↔️', 'label': ''},
        {'emoji': '🌍', 'label': 'Whole World'},
      ],
      'goodThings': [
        'Learn new things',
        'Play fun games',
        'Talk to family far away',
        'Watch videos',
      ],
    },
    {
      'title': 'Personal Information',
      'emoji': '🔒',
      'subtitle': 'Stay Private',
      'color': Color(0xFFE91E63),
      'warning': 'NEVER share these online with strangers:',
      'neverShare': [
        {'item': 'Your full name', 'emoji': '👤'},
        {'item': 'Your address', 'emoji': '🏠'},
        {'item': 'Your phone number', 'emoji': '📱'},
        {'item': 'Your school name', 'emoji': '🏫'},
        {'item': 'Your password', 'emoji': '🔑'},
        {'item': 'Your photos', 'emoji': '📷'},
      ],
      'tip':
          'If someone asks for this information, tell a parent or teacher right away!',
    },
    {
      'title': 'Strong Passwords',
      'emoji': '🔐',
      'subtitle': 'Be Secure',
      'color': Color(0xFF9C27B0),
      'intro':
          'A password is like a key to your online house. Make it strong!',
      'goodPassword': [
        {
          'rule': 'Use letters AND numbers',
          'example': 'Cat123',
          'emoji': '🔤'
        },
        {
          'rule': 'Add special characters',
          'example': 'Cat@123!',
          'emoji': '✨'
        },
        {
          'rule': 'Make it long',
          'example': '8+ characters',
          'emoji': '📏'
        },
        {
          'rule': 'Mix UPPER and lower',
          'example': 'CaT@123!',
          'emoji': '🔠'
        },
      ],
      'badPassword': ['123456', 'password', 'your name', 'your birthday'],
      'remember': 'Never tell anyone your password except parents!',
    },
    {
      'title': 'Stranger Danger',
      'emoji': '⚠️',
      'subtitle': 'Stay Alert',
      'color': Color(0xFFFF5722),
      'message': 'Not everyone online is who they say they are!',
      'rules': [
        {'rule': 'Don\'t talk to strangers online', 'emoji': '🚫'},
        {'rule': 'Never meet online friends in person', 'emoji': '👋❌'},
        {'rule': 'Tell parents if someone bothers you', 'emoji': '👨‍👩‍👧'},
        {'rule': 'Block people who are mean', 'emoji': '🛑'},
        {
          'rule': 'Don\'t accept friend requests from strangers',
          'emoji': '❌'
        },
      ],
      'remember':
          'Online friends should stay online. Real friends you meet in real life!',
    },
    {
      'title': 'Safe Websites',
      'emoji': '✅',
      'subtitle': 'Browse Smart',
      'color': Color(0xFF4CAF50),
      'intro': 'Not all websites are safe for kids. Here\'s how to know:',
      'safeSignals': [
        {'signal': 'Ask a parent first', 'emoji': '👨‍👩‍👧'},
        {'signal': 'Look for kid-friendly sites', 'emoji': '👧'},
        {'signal': 'Check for "https" at start', 'emoji': '🔒'},
        {'signal': 'Use search with Safe Mode', 'emoji': '🔍'},
      ],
      'dangerSigns': [
        {'sign': 'Lots of pop-ups', 'emoji': '⚠️'},
        {'sign': 'Asks for personal info', 'emoji': '❌'},
        {'sign': 'Looks weird or scary', 'emoji': '😰'},
        {'sign': 'Says you won a prize', 'emoji': '🎁❌'},
      ],
    },
    {
      'title': 'Cyberbullying',
      'emoji': '🛡️',
      'subtitle': 'Be Kind',
      'color': Color(0xFFFF9800),
      'intro': 'Cyberbullying is when someone is mean to others online.',
      'whatItIs': [
        'Sending mean messages',
        'Sharing embarrassing photos',
        'Leaving someone out on purpose',
        'Spreading rumors online',
      ],
      'whatToDo': [
        {'action': 'Don\'t respond', 'emoji': '🤐'},
        {'action': 'Save the evidence', 'emoji': '📸'},
        {'action': 'Block the bully', 'emoji': '🚫'},
        {'action': 'Tell a trusted adult', 'emoji': '👨‍👩‍👧'},
        {'action': 'Be kind online', 'emoji': '💝'},
      ],
      'golden': 'Treat others online the way you want to be treated!',
    },
    {
      'title': 'Screen Time',
      'emoji': '⏰',
      'subtitle': 'Stay Balanced',
      'color': Color(0xFF00BCD4),
      'intro': 'Too much screen time isn\'t healthy. Balance is key!',
      'balance': [
        {'activity': 'Play outside', 'emoji': '🏃'},
        {'activity': 'Read books', 'emoji': '📚'},
        {'activity': 'Play with friends', 'emoji': '👫'},
        {'activity': 'Do homework first', 'emoji': '✏️'},
        {'activity': 'Help at home', 'emoji': '🏠'},
        {'activity': 'Get enough sleep', 'emoji': '😴'},
      ],
      'tips': [
        'Take breaks every 30 minutes',
        'No screens before bed',
        'Keep screens in family areas',
        'Follow time limits set by parents',
      ],
    },
    {
      'title': 'Digital Citizen',
      'emoji': '🌟',
      'subtitle': 'Be Responsible',
      'color': Color(0xFF673AB7),
      'intro':
          'A good digital citizen uses the internet safely and kindly!',
      'pledges': [
        {'pledge': 'I will be kind online', 'emoji': '💕'},
        {'pledge': 'I will protect my information', 'emoji': '🔒'},
        {
          'pledge': 'I will tell adults if I see something bad',
          'emoji': '🗣️'
        },
        {
          'pledge': 'I will not share others\' photos without asking',
          'emoji': '📷'
        },
        {'pledge': 'I will balance my screen time', 'emoji': '⚖️'},
        {'pledge': 'I will think before I post', 'emoji': '🤔'},
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
      title: 'Internet Safety',
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
                .resetProgress(ProgressService.kInternetSafety);
            setState(() {});
          },
        ),
      ],
      body: Stack(
        children: [
          ..._buildFloatingBubbles(),
          Column(
            children: [
              // Progress bar
              Obx(() {
                final progress =
                    ProgressService.to.getProgressPercentage(
                          ProgressService.kInternetSafety,
                        ) /
                        100;
                final progressString =
                    ProgressService.to.getProgressString(
                  ProgressService.kInternetSafety,
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
              // Grid
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
                        ProgressService.kInternetSafety,
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
                              ProgressService.kInternetSafety,
                              index,
                            );
                            Get.to(() => _InternetSafetyDetailPage(
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

/// Detail page for each Internet Safety section
class _InternetSafetyDetailPage extends StatefulWidget {
  final Map<String, dynamic> section;
  final int sectionIndex;

  const _InternetSafetyDetailPage({
    required this.section,
    required this.sectionIndex,
  });

  @override
  State<_InternetSafetyDetailPage> createState() =>
      _InternetSafetyDetailPageState();
}

class _InternetSafetyDetailPageState
    extends State<_InternetSafetyDetailPage>
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
      body: Stack(
        children: [
          ..._buildFloatingBubbles(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header card
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
        return _buildInternetIntro();
      case 1:
        return _buildPersonalInfo();
      case 2:
        return _buildPasswords();
      case 3:
        return _buildStrangerDanger();
      case 4:
        return _buildSafeWebsites();
      case 5:
        return _buildCyberbullying();
      case 6:
        return _buildScreenTime();
      case 7:
        return _buildDigitalCitizen();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInternetIntro() {
    int cardIndex = 0;
    return Column(
      children: [
        // Visual connection
        buildFloatingItem(
          index: cardIndex++,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.getGradientForIndex(0),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getGradientForIndex(0)[0]
                      .withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: (section['visualItems'] as List)
                  .map<Widget>((item) {
                return Column(
                  children: [
                    Text(item['emoji'],
                        style: const TextStyle(fontSize: 36)),
                    if ((item['label'] as String).isNotEmpty)
                      Text(
                        item['label'],
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Good things
        ...List.generate(
            (section['goodThings'] as List).length, (index) {
          final thing = section['goodThings'][index];
          final gradient =
              AppColors.getGradientForIndex(index + 1);
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
                  const Icon(Icons.check_circle,
                      color: Colors.white70, size: 22),
                  const SizedBox(width: 12),
                  Text(
                    thing,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  Widget _buildPersonalInfo() {
    int cardIndex = 0;
    return Column(
      children: [
        // Warning card
        buildFloatingItem(
          index: cardIndex++,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF5252), Color(0xFFFF1744)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color:
                      Color(0xFFFF5252).withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Text('🚨',
                    style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    section['warning'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Never share items
        ...List.generate(
            (section['neverShare'] as List).length, (index) {
          final item = section['neverShare'][index];
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
                  Expanded(
                    child: Text(
                      item['item'],
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(Icons.close,
                      color: Colors.white70),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        // Tip
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('💡',
                  style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['tip'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswords() {
    int cardIndex = 0;
    return Column(
      children: [
        // Good password tips
        ...List.generate(
            (section['goodPassword'] as List).length, (index) {
          final item = section['goodPassword'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: cardIndex++,
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
                  Text(item['emoji'],
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['rule'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Example: ${item['example']}',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        // Bad passwords
        buildFloatingItem(
          index: cardIndex++,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF5252), Color(0xFFFF1744)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color:
                      Color(0xFFFF5252).withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '❌ Bad Passwords:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (section['badPassword'] as List)
                      .map<Widget>((bad) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        bad,
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Remember
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Text('🔑',
                  style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  section['remember'],
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStrangerDanger() {
    int cardIndex = 0;
    return Column(
      children: [
        // Warning message
        buildFloatingItem(
          index: cardIndex++,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color:
                      Color(0xFFFF9800).withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Text('⚠️',
                    style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section['message'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Rules
        ...List.generate(
            (section['rules'] as List).length, (index) {
          final rule = section['rules'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: cardIndex++,
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
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(rule['emoji'],
                          style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      rule['rule'],
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
        // Remember
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('💭',
                  style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['remember'],
                  style: GoogleFonts.nunito(
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

  Widget _buildSafeWebsites() {
    int cardIndex = 0;
    return Column(
      children: [
        // Safe signals
        ...List.generate(
            (section['safeSignals'] as List).length, (index) {
          final item = section['safeSignals'][index];
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
                  Expanded(
                    child: Text(
                      '✅ ${item['signal']}',
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
        // Danger signs
        ...List.generate(
            (section['dangerSigns'] as List).length, (index) {
          final item = section['dangerSigns'][index];
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
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '❌ ${item['sign']}',
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

  Widget _buildCyberbullying() {
    int cardIndex = 0;
    return Column(
      children: [
        // What it is
        buildFloatingItem(
          index: cardIndex++,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.getGradientForIndex(0),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getGradientForIndex(0)[0]
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
                  'Cyberbullying includes:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ...(section['whatItIs'] as List).map((item) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.remove,
                            size: 16, color: Colors.white70),
                        const SizedBox(width: 8),
                        Text(
                          item,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
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
        const SizedBox(height: 12),
        // What to do
        ...List.generate(
            (section['whatToDo'] as List).length, (index) {
          final item = section['whatToDo'][index];
          final gradient =
              AppColors.getGradientForIndex(index + 1);
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
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        // Golden rule
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('💝',
                  style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['golden'],
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

  Widget _buildScreenTime() {
    int cardIndex = 0;
    return Column(
      children: [
        // Balance activities
        ...List.generate(
            (section['balance'] as List).length, (index) {
          final item = section['balance'][index];
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Text(item['emoji'],
                        style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    item['activity'],
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
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
                  '💡 Tips:',
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
                            size: 18, color: Colors.white70),
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

  Widget _buildDigitalCitizen() {
    return Column(
      children: List.generate(
          (section['pledges'] as List).length, (index) {
        final item = section['pledges'][index];
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
                Text(item['emoji'],
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item['pledge'],
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(Icons.check_circle,
                    color: Colors.white70),
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
