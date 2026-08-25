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

class KeyboardMousePage extends StatefulWidget {
  const KeyboardMousePage({super.key});

  @override
  State<KeyboardMousePage> createState() => _KeyboardMousePageState();
}

class _KeyboardMousePageState extends State<KeyboardMousePage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  int selectedIndex = -1;
  late AnimationController _bubbleController;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Meet the Keyboard',
      'emoji': '⌨️',
      'subtitle': 'Introduction',
      'color': Color(0xFF2196F3),
      'intro':
          'The keyboard is how we type letters, numbers, and commands into the computer!',
      'keyAreas': [
        {'name': 'Letter Keys', 'emoji': '🔤', 'desc': 'A to Z - for typing words'},
        {
          'name': 'Number Keys',
          'emoji': '🔢',
          'desc': '0 to 9 - for typing numbers'
        },
        {
          'name': 'Space Bar',
          'emoji': '➖',
          'desc': 'The long key at bottom - adds spaces'
        },
        {
          'name': 'Enter/Return',
          'emoji': '↵',
          'desc': 'Start a new line or confirm'
        },
        {
          'name': 'Backspace',
          'emoji': '⌫',
          'desc': 'Delete letters you typed'
        },
        {
          'name': 'Arrow Keys',
          'emoji': '⬆️⬇️⬅️➡️',
          'desc': 'Move around the screen'
        },
      ],
    },
    {
      'title': 'Special Keys',
      'emoji': '🔑',
      'subtitle': 'Key Types',
      'color': Color(0xFF9C27B0),
      'keys': [
        {
          'key': 'Shift',
          'emoji': '⬆️',
          'does': 'Makes CAPITAL letters',
          'tip': 'Hold while typing'
        },
        {
          'key': 'Caps Lock',
          'emoji': '🔒',
          'does': 'ALL CAPS mode',
          'tip': 'Press once to turn on/off'
        },
        {
          'key': 'Tab',
          'emoji': '↹',
          'does': 'Moves to next space',
          'tip': 'Creates big space'
        },
        {
          'key': 'Ctrl/Cmd',
          'emoji': '⌃',
          'does': 'Special commands',
          'tip': 'Hold with other keys'
        },
        {
          'key': 'Alt/Option',
          'emoji': '⌥',
          'does': 'Extra functions',
          'tip': 'Use with other keys'
        },
        {
          'key': 'Escape (Esc)',
          'emoji': '⎋',
          'does': 'Cancel or exit',
          'tip': 'Top left corner'
        },
      ],
    },
    {
      'title': 'Keyboard Shortcuts',
      'emoji': '⚡',
      'subtitle': 'Quick Commands',
      'color': Color(0xFFFF9800),
      'intro': 'Shortcuts are quick key combinations!',
      'shortcuts': [
        {'keys': 'Ctrl + C', 'action': 'Copy', 'emoji': '📋'},
        {'keys': 'Ctrl + V', 'action': 'Paste', 'emoji': '📌'},
        {'keys': 'Ctrl + X', 'action': 'Cut', 'emoji': '✂️'},
        {'keys': 'Ctrl + Z', 'action': 'Undo (go back)', 'emoji': '↩️'},
        {'keys': 'Ctrl + S', 'action': 'Save', 'emoji': '💾'},
        {'keys': 'Ctrl + P', 'action': 'Print', 'emoji': '🖨️'},
        {'keys': 'Ctrl + A', 'action': 'Select All', 'emoji': '✅'},
      ],
      'note': 'On Mac, use Cmd instead of Ctrl!',
    },
    {
      'title': 'Typing Position',
      'emoji': '🖐️',
      'subtitle': 'Good Posture',
      'color': Color(0xFF4CAF50),
      'intro': 'Good posture helps you type better and stay comfortable!',
      'homeRow': ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      'fingerTips': [
        {'tip': 'Sit up straight', 'emoji': '🪑'},
        {'tip': 'Keep feet flat on floor', 'emoji': '🦶'},
        {'tip': 'Wrists should not rest on keyboard', 'emoji': '✋'},
        {'tip': 'Look at screen, not keyboard', 'emoji': '👀'},
        {'tip': 'Take breaks every 15-20 minutes', 'emoji': '⏰'},
      ],
      'fingers': [
        {'finger': 'Left Pinky', 'keys': 'A, Q, Z'},
        {'finger': 'Left Ring', 'keys': 'S, W, X'},
        {'finger': 'Left Middle', 'keys': 'D, E, C'},
        {'finger': 'Left Index', 'keys': 'F, R, V, G, T, B'},
        {'finger': 'Right Index', 'keys': 'J, U, M, H, Y, N'},
        {'finger': 'Right Middle', 'keys': 'K, I, comma'},
        {'finger': 'Right Ring', 'keys': 'L, O, period'},
        {'finger': 'Right Pinky', 'keys': 'P, semicolon, slash'},
        {'finger': 'Thumbs', 'keys': 'Space Bar'},
      ],
    },
    {
      'title': 'Meet the Mouse',
      'emoji': '🖱️',
      'subtitle': 'Mouse Basics',
      'color': Color(0xFFE91E63),
      'intro':
          'The mouse lets you point and click on things on the screen!',
      'parts': [
        {'part': 'Left Button', 'emoji': '👆', 'use': 'Click to select things'},
        {
          'part': 'Right Button',
          'emoji': '📋',
          'use': 'Shows more options (menu)'
        },
        {
          'part': 'Scroll Wheel',
          'emoji': '🔄',
          'use': 'Roll to move up and down'
        },
      ],
      'types': [
        {'type': 'Regular Mouse', 'emoji': '🖱️'},
        {'type': 'Wireless Mouse', 'emoji': '📡'},
        {'type': 'Trackpad/Touchpad', 'emoji': '⬜'},
        {'type': 'Trackball', 'emoji': '🎱'},
      ],
    },
    {
      'title': 'Mouse Actions',
      'emoji': '👆',
      'subtitle': 'Click & Drag',
      'color': Color(0xFF00BCD4),
      'actions': [
        {
          'action': 'Click',
          'emoji': '👆',
          'how': 'Press left button once',
          'when': 'Select something'
        },
        {
          'action': 'Double Click',
          'emoji': '👆👆',
          'how': 'Press left button twice fast',
          'when': 'Open files and programs'
        },
        {
          'action': 'Right Click',
          'emoji': '📋',
          'how': 'Press right button once',
          'when': 'See more options'
        },
        {
          'action': 'Drag',
          'emoji': '↔️',
          'how': 'Hold left button and move',
          'when': 'Move things around'
        },
        {
          'action': 'Scroll',
          'emoji': '⬆️⬇️',
          'how': 'Roll the wheel',
          'when': 'Move page up or down'
        },
        {
          'action': 'Hover',
          'emoji': '✨',
          'how': 'Move mouse without clicking',
          'when': 'See more info'
        },
      ],
    },
    {
      'title': 'The Cursor',
      'emoji': '➡️',
      'subtitle': 'Pointer Shapes',
      'color': Color(0xFF795548),
      'intro':
          'The cursor is the arrow on screen that shows where your mouse is pointing!',
      'cursorTypes': [
        {'shape': 'Arrow ➡️', 'meaning': 'Normal - ready to click'},
        {'shape': 'Hand 👆', 'meaning': 'Link - click to go somewhere'},
        {'shape': 'I-beam |', 'meaning': 'Text - ready to type'},
        {'shape': 'Hourglass ⏳', 'meaning': 'Wait - computer is busy'},
        {'shape': 'Crosshair +', 'meaning': 'Draw or select area'},
        {'shape': 'Resize ↔️', 'meaning': 'Change window size'},
      ],
    },
    {
      'title': 'Practice Tips',
      'emoji': '🎯',
      'subtitle': 'Fun Practice',
      'color': Color(0xFF673AB7),
      'keyboardPractice': [
        'Start with letter keys',
        'Practice typing your name',
        'Try typing slowly but correctly',
        'Speed comes with practice!',
        'Play typing games',
      ],
      'mousePractice': [
        'Practice moving the pointer',
        'Try clicking on icons',
        'Play simple clicking games',
        'Practice double-clicking',
        'Try using the scroll wheel',
      ],
      'games': [
        {
          'name': 'Typing Games',
          'emoji': '🎮',
          'desc': 'Fun way to practice typing'
        },
        {
          'name': 'Paint Programs',
          'emoji': '🎨',
          'desc': 'Practice mouse control'
        },
        {
          'name': 'Puzzle Games',
          'emoji': '🧩',
          'desc': 'Click and drag practice'
        },
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
      title: 'Keyboard & Mouse',
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.refresh, color: Colors.white, size: 20),
          ),
          onPressed: () {
            ProgressService.to
                .resetProgress(ProgressService.kKeyboardMouse);
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
                          ProgressService.kKeyboardMouse,
                        ) /
                        100;
                final progressString =
                    ProgressService.to.getProgressString(
                  ProgressService.kKeyboardMouse,
                );
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
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
                        ProgressService.kKeyboardMouse,
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
                              ProgressService.kKeyboardMouse,
                              index,
                            );
                            Get.to(() => _KeyboardMouseDetailPage(
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
                                      overflow: TextOverflow.ellipsis,
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
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
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
          final progress =
              (_bubbleController.value + delay) % 1.0;
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
                    Colors.white
                        .withValues(alpha: opacity * 0.3),
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

/// Detail page for each Keyboard & Mouse section
class _KeyboardMouseDetailPage extends StatefulWidget {
  final Map<String, dynamic> section;
  final int sectionIndex;

  const _KeyboardMouseDetailPage({
    required this.section,
    required this.sectionIndex,
  });

  @override
  State<_KeyboardMouseDetailPage> createState() =>
      _KeyboardMouseDetailPageState();
}

class _KeyboardMouseDetailPageState
    extends State<_KeyboardMouseDetailPage>
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
        return _buildKeyboardIntro();
      case 1:
        return _buildSpecialKeys();
      case 2:
        return _buildShortcuts();
      case 3:
        return _buildTypingPosition();
      case 4:
        return _buildMouseIntro();
      case 5:
        return _buildMouseActions();
      case 6:
        return _buildCursor();
      case 7:
        return _buildPractice();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildKeyboardIntro() {
    return Column(
      children:
          List.generate((section['keyAreas'] as List).length, (index) {
        final area = section['keyAreas'][index];
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
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(area['emoji'],
                        style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        area['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        area['desc'],
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
    );
  }

  Widget _buildSpecialKeys() {
    return Column(
      children:
          List.generate((section['keys'] as List).length, (index) {
        final key = section['keys'][index];
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    key['emoji'],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        key['key'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        key['does'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        '💡 ${key['tip']}',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontStyle: FontStyle.italic,
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
    );
  }

  Widget _buildShortcuts() {
    return Column(
      children: [
        ...List.generate(
            (section['shortcuts'] as List).length, (index) {
          final shortcut = section['shortcuts'][index];
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      shortcut['keys'],
                      style: GoogleFonts.sourceCodePro(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(shortcut['emoji'],
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      shortcut['action'],
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Text('🍎', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  section['note'],
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypingPosition() {
    return Column(
      children: [
        // Home Row Keys card
        buildFloatingItem(
          index: 0,
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
              children: [
                Text(
                  '🏠 Home Row Keys',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: (section['homeRow'] as List)
                      .map<Widget>((key) {
                    return Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color:
                            Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: 0.2),
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          key,
                          style: GoogleFonts.sourceCodePro(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rest your fingers here!',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Posture tips
        ...List.generate(
            (section['fingerTips'] as List).length, (index) {
          final tip = section['fingerTips'][index];
          final gradient =
              AppColors.getGradientForIndex(index + 1);
          return buildFloatingItem(
            index: index + 1,
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
                  Text(tip['emoji'],
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip['tip'],
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

  Widget _buildMouseIntro() {
    return Column(
      children: [
        // Mouse parts
        ...List.generate(
            (section['parts'] as List).length, (index) {
          final part = section['parts'][index];
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Text(part['emoji'],
                        style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          part['part'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          part['use'],
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
        const SizedBox(height: 12),
        // Mouse types
        buildFloatingItem(
          index: 3,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.getGradientForIndex(3),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getGradientForIndex(3)[0]
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
                  'Types of Mouse:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: (section['types'] as List)
                      .map<Widget>((type) {
                    return Column(
                      children: [
                        Text(type['emoji'],
                            style:
                                const TextStyle(fontSize: 28)),
                        Text(
                          type['type'],
                          style: GoogleFonts.nunito(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMouseActions() {
    return Column(
      children: List.generate(
          (section['actions'] as List).length, (index) {
        final action = section['actions'][index];
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(action['emoji'],
                            style:
                                const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      action['action'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '📌 How: ',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              action['how'],
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '✨ When: ',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              action['when'],
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildCursor() {
    return Column(
      children: List.generate(
          (section['cursorTypes'] as List).length, (index) {
        final cursor = section['cursorTypes'][index];
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
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color:
                        Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      cursor['shape'].split(' ').last,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        cursor['shape'].split(' ').first,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        cursor['meaning'],
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
    );
  }

  Widget _buildPractice() {
    int cardIndex = 0;
    return Column(
      children: [
        // Keyboard Practice
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
                  '⌨️ Keyboard Practice:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                ...(section['keyboardPractice'] as List)
                    .map((tip) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.white70, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          tip,
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
        const SizedBox(height: 16),
        // Mouse Practice
        buildFloatingItem(
          index: cardIndex++,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.getGradientForIndex(1),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getGradientForIndex(1)[0]
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
                  '🖱️ Mouse Practice:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                ...(section['mousePractice'] as List)
                    .map((tip) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.white70, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          tip,
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
        const SizedBox(height: 16),
        // Fun Games
        ...List.generate(
            (section['games'] as List).length, (index) {
          final game = section['games'][index];
          final gradient =
              AppColors.getGradientForIndex(index + 2);
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
                  Text(game['emoji'],
                      style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          game['name'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          game['desc'],
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
      ],
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
          final progress =
              (_bubbleController.value + delay) % 1.0;
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
                    Colors.white
                        .withValues(alpha: opacity * 0.3),
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
