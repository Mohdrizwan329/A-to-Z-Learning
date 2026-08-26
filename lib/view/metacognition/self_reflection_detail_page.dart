import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class SelfReflectionDetailPage extends StatefulWidget {
  final int sectionIndex;

  const SelfReflectionDetailPage({super.key, required this.sectionIndex});

  @override
  State<SelfReflectionDetailPage> createState() =>
      _SelfReflectionDetailPageState();
}

class _SelfReflectionDetailPageState extends State<SelfReflectionDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  int? selectedIndex;

  static final List<Map<String, dynamic>> reflectionSections = [
    {
      'title': 'How Am I Feeling Today?',
      'emoji': '😊',
      'type': 'mood',
      'options': [
        {'emoji': '😄', 'text': 'Super Happy'},
        {'emoji': '🙂', 'text': 'Good'},
        {'emoji': '😐', 'text': 'Okay'},
        {'emoji': '😔', 'text': 'A Little Sad'},
        {'emoji': '😢', 'text': 'Not Good'},
      ],
    },
    {
      'title': 'What Did I Do Well Today?',
      'emoji': '⭐',
      'type': 'achievements',
      'options': [
        {'emoji': '📚', 'text': 'I studied hard'},
        {'emoji': '🤝', 'text': 'I helped someone'},
        {'emoji': '🎯', 'text': 'I finished my work'},
        {'emoji': '😊', 'text': 'I was kind'},
        {'emoji': '🧹', 'text': 'I cleaned up'},
      ],
    },
    {
      'title': 'What Can I Do Better?',
      'emoji': '🌱',
      'type': 'improvement',
      'options': [
        {'emoji': '👂', 'text': 'Listen more carefully'},
        {'emoji': '⏰', 'text': 'Be on time'},
        {'emoji': '📖', 'text': 'Read more'},
        {'emoji': '🤫', 'text': 'Be more patient'},
        {'emoji': '💪', 'text': 'Try harder'},
      ],
    },
    {
      'title': 'What Makes Me Special?',
      'emoji': '🌟',
      'type': 'strengths',
      'options': [
        {'emoji': '🎨', 'text': 'I am creative'},
        {'emoji': '❤️', 'text': 'I am kind'},
        {'emoji': '🧠', 'text': 'I am smart'},
        {'emoji': '💪', 'text': 'I am brave'},
        {'emoji': '😄', 'text': 'I am funny'},
      ],
    },
    {
      'title': 'What Am I Grateful For?',
      'emoji': '🙏',
      'type': 'gratitude',
      'options': [
        {'emoji': '👨‍👩‍👧', 'text': 'My family'},
        {'emoji': '👫', 'text': 'My friends'},
        {'emoji': '🏠', 'text': 'My home'},
        {'emoji': '🍎', 'text': 'Good food'},
        {'emoji': '📚', 'text': 'Learning new things'},
      ],
    },
    {
      'title': 'My Goal for Tomorrow',
      'emoji': '🎯',
      'type': 'goals',
      'options': [
        {'emoji': '📖', 'text': 'Learn something new'},
        {'emoji': '🤝', 'text': 'Make a new friend'},
        {'emoji': '💪', 'text': 'Do my best'},
        {'emoji': '😊', 'text': 'Be happy'},
        {'emoji': '🌟', 'text': 'Be helpful'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    initGridAnimations(this, floatRange: 3.0);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final section = reflectionSections[widget.sectionIndex];
    final gradient = AppColors.getGradientForIndex(widget.sectionIndex);

    return GradientScaffold(
      title: section['title'],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // Header Card
            buildFloatingItem(
              index: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withValues(alpha: 0.4),
                      blurRadius: 12.r,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      section['emoji'],
                      style: const TextStyle(fontSize: 60),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      section['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Options
            ...List.generate((section['options'] as List).length, (index) {
              final option = section['options'][index];
              final isSelected = selectedIndex == index;
              final cardGradient = AppColors.getGradientForIndex(
                widget.sectionIndex + index + 1,
              );

              return buildFloatingItem(
                index: index + 1,
                child: GestureDetector(
                  onTap: () {
                    TtsService.to.speak(option['text']);
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: AppColors.selectedGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: cardGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isSelected
                                      ? AppColors.selectedGradient[0]
                                      : cardGradient[0])
                                  .withValues(alpha: 0.4),
                          blurRadius: isSelected ? 12 : 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              option['emoji'],
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Text(
                            option['text'],
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 28.w,
                            height: 28.h,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: AppColors.selectedGradient[0],
                              size: 18.r,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
