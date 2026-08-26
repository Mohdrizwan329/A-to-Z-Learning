import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class ScreenResponsibilityPage extends StatefulWidget {
  const ScreenResponsibilityPage({super.key});

  @override
  State<ScreenResponsibilityPage> createState() =>
      _ScreenResponsibilityPageState();
}

class _ScreenResponsibilityPageState extends State<ScreenResponsibilityPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Screen Time Balance',
      'emoji': '⚖️',
      'color': Color(0xFF2196F3),
      'description':
          'Screens are fun, but balance is key! Learn how to use screens wisely and stay healthy.',
      'tips': [
        {
          'icon': '⏰',
          'title': 'Set a Timer',
          'desc': 'Take breaks every 20-30 minutes',
        },
        {
          'icon': '🌳',
          'title': 'Go Outside',
          'desc': 'Play outdoors after screen time',
        },
        {
          'icon': '👀',
          'title': 'Rest Your Eyes',
          'desc': 'Look at something far away',
        },
        {
          'icon': '🤸',
          'title': 'Move & Stretch',
          'desc': 'Keep your body active',
        },
      ],
    },
    {
      'title': 'Healthy Screen Habits',
      'emoji': '💚',
      'color': Color(0xFF4CAF50),
      'description':
          'Good habits keep us healthy when using screens. Let\'s learn the right way!',
      'habits': [
        {
          'good': 'Sit up straight',
          'bad': 'Slouching',
          'goodEmoji': '🧍',
          'badEmoji': '😩',
        },
        {
          'good': 'Screen at arm\'s length',
          'bad': 'Too close to screen',
          'goodEmoji': '📏',
          'badEmoji': '👃',
        },
        {
          'good': 'Good lighting',
          'bad': 'Dark room',
          'goodEmoji': '💡',
          'badEmoji': '🌑',
        },
        {
          'good': 'Blink often',
          'bad': 'Staring without blinking',
          'goodEmoji': '😊',
          'badEmoji': '👁️',
        },
      ],
    },
    {
      'title': 'The 20-20-20 Rule',
      'emoji': '👁️',
      'color': Color(0xFF9C27B0),
      'description': 'A special rule to keep your eyes healthy and happy!',
      'rules': [
        {'number': '20', 'unit': 'minutes', 'action': 'Use screen'},
        {'number': '20', 'unit': 'seconds', 'action': 'Look away'},
        {'number': '20', 'unit': 'feet', 'action': 'Far distance'},
      ],
      'reminder': 'Set a timer to remind you to take eye breaks!',
    },
    {
      'title': 'Before Bed Rules',
      'emoji': '🌙',
      'color': Color(0xFF3F51B5),
      'description':
          'Screens can make it hard to sleep. Follow these rules for better sleep!',
      'rules': [
        {
          'icon': '📵',
          'title': 'No Screens Before Bed',
          'desc': 'Stop 1 hour before sleep time',
        },
        {
          'icon': '📖',
          'title': 'Read a Book Instead',
          'desc': 'Books are better for bedtime',
        },
        {
          'icon': '🌅',
          'title': 'Night Mode',
          'desc': 'Use warm colors in the evening',
        },
        {
          'icon': '🛏️',
          'title': 'No Devices in Bed',
          'desc': 'Keep phones away from pillows',
        },
      ],
      'funFact': 'Blue light from screens tells your brain it\'s daytime!',
    },
    {
      'title': 'Screen-Free Activities',
      'emoji': '🎨',
      'color': Color(0xFFFF5722),
      'description':
          'There are SO many fun things to do without screens! Try these:',
      'activities': [
        {'name': 'Draw & Color', 'emoji': '🖍️'},
        {'name': 'Read Books', 'emoji': '📚'},
        {'name': 'Play Outside', 'emoji': '🏃'},
        {'name': 'Build with Lego', 'emoji': '🧱'},
        {'name': 'Play Board Games', 'emoji': '🎲'},
        {'name': 'Cook & Bake', 'emoji': '🍪'},
        {'name': 'Garden & Plants', 'emoji': '🌱'},
        {'name': 'Play Music', 'emoji': '🎵'},
        {'name': 'Do Puzzles', 'emoji': '🧩'},
        {'name': 'Play with Pets', 'emoji': '🐕'},
        {'name': 'Arts & Crafts', 'emoji': '✂️'},
        {'name': 'Sports & Games', 'emoji': '⚽'},
      ],
    },
    {
      'title': 'Being a Good Digital Citizen',
      'emoji': '🌟',
      'color': Color(0xFF00BCD4),
      'description': 'When we use screens, we should be kind and responsible!',
      'citizenship': [
        {
          'icon': '💬',
          'title': 'Be Kind Online',
          'desc': 'Use nice words, no bullying',
        },
        {
          'icon': '🤫',
          'title': 'Keep Secrets Safe',
          'desc': 'Don\'t share personal info',
        },
        {
          'icon': '👨‍👩‍👧',
          'title': 'Tell an Adult',
          'desc': 'If something feels wrong',
        },
        {
          'icon': '✅',
          'title': 'Ask Permission',
          'desc': 'Before downloading or clicking',
        },
      ],
    },
    {
      'title': 'My Screen Time Plan',
      'emoji': '📋',
      'color': Color(0xFFFF9800),
      'description': 'Create your own healthy screen time schedule!',
      'schedule': [
        {
          'time': 'Morning',
          'emoji': '🌅',
          'activity': 'Get ready, eat breakfast, no screens!',
        },
        {
          'time': 'School Time',
          'emoji': '📚',
          'activity': 'Learning screens only',
        },
        {
          'time': 'After School',
          'emoji': '🏃',
          'activity': 'Play outside first, then some screen time',
        },
        {
          'time': 'Evening',
          'emoji': '🌙',
          'activity': 'Family time, limit screens',
        },
        {
          'time': 'Bedtime',
          'emoji': '😴',
          'activity': 'No screens, read a book!',
        },
      ],
    },
    {
      'title': 'Screen Responsibility Pledge',
      'emoji': '🤝',
      'color': Color(0xFFE91E63),
      'pledges': [
        'I will take breaks from screens',
        'I will go outside and play',
        'I will sit properly when using screens',
        'I will be kind online',
        'I will tell an adult if I see something bad',
        'I will not use screens before bedtime',
        'I will balance screens with other activities',
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
          'Screen Responsibility',
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildProgressDots(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.r),
                  child: _buildSectionContent(section),
                ),
              ),
              _buildNavigationButtons(section),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressDots() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(sections.length, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: currentSection == index ? 24 : 8,
            height: 8.h,
            decoration: BoxDecoration(
              color: currentSection == index
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4.r),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionContent(Map<String, dynamic> section) {
    switch (currentSection) {
      case 0:
        return _buildBalanceSection(section);
      case 1:
        return _buildHabitsSection(section);
      case 2:
        return _build2020Section(section);
      case 3:
        return _buildBeforeBedsection(section);
      case 4:
        return _buildActivitiesSection(section);
      case 5:
        return _buildCitizenshipSection(section);
      case 6:
        return _buildScheduleSection(section);
      case 7:
        return _buildPledgeSection(section);
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildBalanceSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16.h),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24.h),
        ...List.generate(section['tips'].length, (index) {
          final tip = section['tips'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8.r,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(tip['icon'], style: TextStyle(fontSize: 28)),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Text(
                        tip['desc'],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHabitsSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16.h),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24.h),
        ...List.generate(section['habits'].length, (index) {
          final habit = section['habits'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Text(
                              habit['goodEmoji'],
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                habit['good'],
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            Icon(Icons.check_circle, color: Colors.green),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Text(
                              habit['badEmoji'],
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                habit['bad'],
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Icon(Icons.cancel, color: Colors.red),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _build2020Section(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16.h),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 32.h),
        Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            children: [
              Text(
                'Every...',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(section['rules'].length, (index) {
                  final rule = section['rules'][index];
                  return Column(
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: section['color'],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            rule['number'],
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        rule['unit'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Text(
                        rule['action'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Text('💡', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        section['reminder'],
                        style: GoogleFonts.nunito(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBeforeBedsection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16.h),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24.h),
        ...List.generate(section['rules'].length, (index) {
          final rule = section['rules'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(rule['icon'], style: TextStyle(fontSize: 28)),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rule['title'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Text(
                        rule['desc'],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Text('🔬', style: TextStyle(fontSize: 28)),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fun Fact!',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      section['funFact'],
                      style: GoogleFonts.nunito(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivitiesSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16.h),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24.h),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: List.generate(section['activities'].length, (index) {
            final activity = section['activities'][index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(activity['emoji'], style: TextStyle(fontSize: 32)),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      activity['name'],
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCitizenshipSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16.h),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24.h),
        ...List.generate(section['citizenship'].length, (index) {
          final item = section['citizenship'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(item['icon'], style: TextStyle(fontSize: 24)),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Text(
                        item['desc'],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildScheduleSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16.h),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24.h),
        ...List.generate(section['schedule'].length, (index) {
          final schedule = section['schedule'][index];
          final colors = [
            Color(0xFFFF9800),
            Color(0xFF2196F3),
            Color(0xFF4CAF50),
            Color(0xFF9C27B0),
            Color(0xFF3F51B5),
          ];
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: colors[index], width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      schedule['emoji'],
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule['time'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: colors[index],
                        ),
                      ),
                      Text(
                        schedule['activity'],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPledgeSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16.h),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          'I promise to...',
          style: GoogleFonts.nunito(
            fontSize: 18,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24.h),
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10.r,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: List.generate(section['pledges'].length, (index) {
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: section['color'],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18.r,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        section['pledges'][index],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 24.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Text(
            '🌟 I am a responsible screen user! 🌟',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(Map<String, dynamic> section) {
    return Container(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          if (currentSection > 0)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    currentSection--;
                  });
                  TtsService.to.speak(sections[currentSection]['title']);
                },
                icon: Icon(Icons.arrow_back),
                label: Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
          if (currentSection > 0) SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                if (currentSection < sections.length - 1) {
                  setState(() {
                    currentSection++;
                  });
                  TtsService.to.speak(sections[currentSection]['title']);
                } else {
                  Get.back();
                }
              },
              icon: Icon(
                currentSection < sections.length - 1
                    ? Icons.arrow_forward
                    : Icons.check_circle,
              ),
              label: Text(
                currentSection < sections.length - 1 ? 'Next' : 'Done',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'] as Color,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
