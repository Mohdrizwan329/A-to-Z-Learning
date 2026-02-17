import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class KeyboardMousePage extends StatefulWidget {
  const KeyboardMousePage({super.key});

  @override
  State<KeyboardMousePage> createState() => _KeyboardMousePageState();
}

class _KeyboardMousePageState extends State<KeyboardMousePage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Meet the Keyboard',
      'emoji': '⌨️',
      'color': Color(0xFF2196F3),
      'intro': 'The keyboard is how we type letters, numbers, and commands into the computer!',
      'keyAreas': [
        {'name': 'Letter Keys', 'emoji': '🔤', 'desc': 'A to Z - for typing words'},
        {'name': 'Number Keys', 'emoji': '🔢', 'desc': '0 to 9 - for typing numbers'},
        {'name': 'Space Bar', 'emoji': '➖', 'desc': 'The long key at bottom - adds spaces'},
        {'name': 'Enter/Return', 'emoji': '↵', 'desc': 'Start a new line or confirm'},
        {'name': 'Backspace', 'emoji': '⌫', 'desc': 'Delete letters you typed'},
        {'name': 'Arrow Keys', 'emoji': '⬆️⬇️⬅️➡️', 'desc': 'Move around the screen'},
      ],
    },
    {
      'title': 'Special Keys',
      'emoji': '🔑',
      'color': Color(0xFF9C27B0),
      'keys': [
        {'key': 'Shift', 'emoji': '⬆️', 'does': 'Makes CAPITAL letters', 'tip': 'Hold while typing'},
        {'key': 'Caps Lock', 'emoji': '🔒', 'does': 'ALL CAPS mode', 'tip': 'Press once to turn on/off'},
        {'key': 'Tab', 'emoji': '↹', 'does': 'Moves to next space', 'tip': 'Creates big space'},
        {'key': 'Ctrl/Cmd', 'emoji': '⌃', 'does': 'Special commands', 'tip': 'Hold with other keys'},
        {'key': 'Alt/Option', 'emoji': '⌥', 'does': 'Extra functions', 'tip': 'Use with other keys'},
        {'key': 'Escape (Esc)', 'emoji': '⎋', 'does': 'Cancel or exit', 'tip': 'Top left corner'},
      ],
    },
    {
      'title': 'Keyboard Shortcuts',
      'emoji': '⚡',
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
      'color': Color(0xFFE91E63),
      'intro': 'The mouse lets you point and click on things on the screen!',
      'parts': [
        {'part': 'Left Button', 'emoji': '👆', 'use': 'Click to select things'},
        {'part': 'Right Button', 'emoji': '📋', 'use': 'Shows more options (menu)'},
        {'part': 'Scroll Wheel', 'emoji': '🔄', 'use': 'Roll to move up and down'},
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
      'color': Color(0xFF795548),
      'intro': 'The cursor is the arrow on screen that shows where your mouse is pointing!',
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
        {'name': 'Typing Games', 'emoji': '🎮', 'desc': 'Fun way to practice typing'},
        {'name': 'Paint Programs', 'emoji': '🎨', 'desc': 'Practice mouse control'},
        {'name': 'Puzzle Games', 'emoji': '🧩', 'desc': 'Click and drag practice'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final section = sections[currentSection];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Keyboard & Mouse',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildProgressDots(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildSectionContent(section),
                ),
              ),
              _buildNavButtons(section),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildProgressDots() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(sections.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: index == currentSection ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: index == currentSection
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionContent(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(section['emoji'], style: const TextStyle(fontSize: 50)),
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
                  style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (section['title'] == 'Meet the Keyboard')
          _buildKeyboardIntro(section),
        if (section['title'] == 'Special Keys')
          _buildSpecialKeys(section),
        if (section['title'] == 'Keyboard Shortcuts')
          _buildShortcuts(section),
        if (section['title'] == 'Typing Position')
          _buildTypingPosition(section),
        if (section['title'] == 'Meet the Mouse')
          _buildMouseIntro(section),
        if (section['title'] == 'Mouse Actions')
          _buildMouseActions(section),
        if (section['title'] == 'The Cursor')
          _buildCursor(section),
        if (section['title'] == 'Practice Tips')
          _buildPractice(section),
      ],
    );
  }

  Widget _buildKeyboardIntro(Map<String, dynamic> section) {
    return Column(
      children: (section['keyAreas'] as List).map<Widget>((area) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(area['emoji'], style: const TextStyle(fontSize: 24)),
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
                        color: section['color'],
                      ),
                    ),
                    Text(
                      area['desc'],
                      style: GoogleFonts.nunito(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSpecialKeys(Map<String, dynamic> section) {
    return Column(
      children: (section['keys'] as List).map<Widget>((key) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: section['color'],
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
                        color: section['color'],
                      ),
                    ),
                    Text(
                      key['does'],
                      style: GoogleFonts.nunito(fontSize: 12),
                    ),
                    Text(
                      '💡 ${key['tip']}',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildShortcuts(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: (section['shortcuts'] as List).map<Widget>((shortcut) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: section['color'],
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
                    Text(shortcut['emoji'], style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Text(
                      shortcut['action'],
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Text('🍎', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  section['note'],
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypingPosition(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                '🏠 Home Row Keys',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: (section['homeRow'] as List).map<Widget>((key) {
                  return Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: section['color'],
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
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
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '💺 Good Posture Tips:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...(section['fingerTips'] as List).map((tip) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(tip['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(tip['tip'], style: GoogleFonts.nunito(fontSize: 13)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMouseIntro(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🖱️ Mouse Parts:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...(section['parts'] as List).map((part) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(part['emoji'], style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              part['part'],
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              part['use'],
                              style: GoogleFonts.nunito(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: section['color'].withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Types of Mouse:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: (section['types'] as List).map<Widget>((type) {
                  return Column(
                    children: [
                      Text(type['emoji'], style: const TextStyle(fontSize: 28)),
                      Text(
                        type['type'],
                        style: GoogleFonts.nunito(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMouseActions(Map<String, dynamic> section) {
    return Column(
      children: (section['actions'] as List).map<Widget>((action) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
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
                      color: section['color'].withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(action['emoji'], style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    action['action'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: section['color'],
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
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('📌 How: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(child: Text(action['how'], style: GoogleFonts.nunito(fontSize: 12))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('✨ When: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(child: Text(action['when'], style: GoogleFonts.nunito(fontSize: 12))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCursor(Map<String, dynamic> section) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cursor Shapes & Meanings:',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...(section['cursorTypes'] as List).map((cursor) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: section['color'].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        cursor['shape'].split(' ').last,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cursor['shape'].split(' ').first,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          cursor['meaning'],
                          style: GoogleFonts.nunito(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPractice(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '⌨️ Keyboard Practice:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...(section['keyboardPractice'] as List).map((tip) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.blue, size: 18),
                      const SizedBox(width: 8),
                      Text(tip, style: GoogleFonts.nunito(fontSize: 13)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🖱️ Mouse Practice:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...(section['mousePractice'] as List).map((tip) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.pink, size: 18),
                      const SizedBox(width: 8),
                      Text(tip, style: GoogleFonts.nunito(fontSize: 13)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🎮 Fun Practice Games:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...(section['games'] as List).map((game) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(game['emoji'], style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game['name'],
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              game['desc'],
                              style: GoogleFonts.nunito(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavButtons(Map<String, dynamic> section) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentSection > 0)
            ElevatedButton.icon(
              onPressed: () => setState(() => currentSection--),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            const SizedBox(width: 100),
          if (currentSection < sections.length - 1)
            ElevatedButton.icon(
              onPressed: () => setState(() => currentSection++),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.check),
              label: const Text('Done!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
