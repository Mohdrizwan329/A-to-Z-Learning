import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/age_content_service.dart';
import 'package:jiyan_learning/widgets/common_app_bar.dart';
import 'dart:math' as math;

import 'package:jiyan_learning/utils/responsive.dart';

class AgeSelectionPage extends StatefulWidget {
  final bool isInitialSetup;

  const AgeSelectionPage({super.key, this.isInitialSetup = true});

  @override
  State<AgeSelectionPage> createState() => _AgeSelectionPageState();
}

class _AgeSelectionPageState extends State<AgeSelectionPage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bounceController;
  late AnimationController _sparkleController;
  late Animation<double> _floatAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bounceController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ageContentService = Get.find<AgeContentService>();

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Select your Age Group',
        showBackButton: !widget.isInitialSetup,
        gradientColors: const [
          Color(0xFFFF6B6B),
          Color(0xFFFF8E53),
          Color(0xFFFFAA5A),
        ],
      ),
      body: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(),

          // Floating decorations
          ..._buildFloatingDecorations(),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 16.h),

                // Age Group Cards
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: AgeGroup.values.asMap().entries.map((entry) {
                          final index = entry.key;
                          final ageGroup = entry.value;
                          return _FunAgeCard(
                            ageGroup: ageGroup,
                            index: index,
                            bounceAnimation: _bounceAnimation,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                // Fun Continue Button
                _buildContinueButton(ageContentService),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
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
    );
  }

  List<Widget> _buildFloatingDecorations() {
    return [
      // Bottom left cloud
      Positioned(
        bottom: 150.h,
        left: 15.w,
        child: AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_floatAnimation.value * 0.5, 0),
              child: Text(
                '☁️',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            );
          },
        ),
      ),
      // Sparkles
      Positioned(
        top: 200.h,
        right: 50.w,
        child: AnimatedBuilder(
          animation: _sparkleController,
          builder: (context, child) {
            return Opacity(
              opacity:
                  (math.sin(_sparkleController.value * math.pi * 2) + 1) / 2,
              child: const Text('✨', style: TextStyle(fontSize: 20)),
            );
          },
        ),
      ),
      Positioned(
        bottom: 250.h,
        right: 25.w,
        child: AnimatedBuilder(
          animation: _sparkleController,
          builder: (context, child) {
            return Opacity(
              opacity:
                  (math.cos(_sparkleController.value * math.pi * 2) + 1) / 2,
              child: const Text('✨', style: TextStyle(fontSize: 16)),
            );
          },
        ),
      ),
    ];
  }

  Widget _buildContinueButton(AgeContentService ageContentService) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 10.h),
      child: Obx(() {
        final hasSelected = ageContentService.hasSelectedAge.value;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: GestureDetector(
            onTap: hasSelected ? () => Get.offAllNamed('/home') : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 60.h,
              decoration: BoxDecoration(
                gradient: hasSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF56D97F), Color(0xFF10B981)],
                      )
                    : null,
                color: hasSelected ? null : Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: hasSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF56D97F).withValues(alpha: 0.5),
                          blurRadius: 20.r,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      hasSelected ? "Let's Start! " : 'Select Age Group',
                      style: GoogleFonts.fredoka(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: hasSelected ? Colors.white : Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hasSelected)
                    AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_bounceAnimation.value * 0.5, 0),
                          child: const Text(
                            '🚀',
                            style: TextStyle(fontSize: 24),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _FunAgeCard extends StatefulWidget {
  final AgeGroup ageGroup;
  final int index;
  final Animation<double> bounceAnimation;

  const _FunAgeCard({
    required this.ageGroup,
    required this.index,
    required this.bounceAnimation,
  });

  @override
  State<_FunAgeCard> createState() => _FunAgeCardState();
}

class _FunAgeCardState extends State<_FunAgeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ageContentService = Get.find<AgeContentService>();
    final cardData = _getCardData();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (widget.index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        // Clamp opacity to valid range (easeOutBack can exceed 1.0)
        final clampedOpacity = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: clampedOpacity,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: Transform.scale(scale: 0.8 + (0.2 * value), child: child),
          ),
        );
      },
      child: Obx(() {
        final isSelected =
            ageContentService.currentAgeGroup.value == widget.ageGroup &&
            ageContentService.hasSelectedAge.value;

        return GestureDetector(
          onTapDown: (_) {
            _scaleController.reverse();
          },
          onTapUp: (_) {
            _scaleController.forward();
            _selectAgeGroup(ageContentService);
          },
          onTapCancel: () {
            _scaleController.forward();
          },
          child: ScaleTransition(
            scale: _scaleController,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          cardData['color'] as Color,
                          (cardData['color'] as Color).withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: isSelected
                    ? Border.all(color: Colors.white, width: 3)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? (cardData['color'] as Color).withValues(alpha: 0.5)
                        : Colors.black.withValues(alpha: 0.1),
                    blurRadius: isSelected ? 25 : 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Fun character/emoji container
                  _buildCharacterContainer(cardData, isSelected),
                  SizedBox(width: 12.w),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Age label with fun badge
                        Row(
                          children: [
                            // Flexible so a long name shortens instead of
                            // pushing the "Selected" badge off a narrow screen.
                            Flexible(
                              child: Text(
                                cardData['title'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.fredoka(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : cardData['color'] as Color,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            if (isSelected)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: const Text(
                                  '✓ Selected',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 4.h),

                        // Subtitle
                        Text(
                          cardData['subtitle'] as String,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.9)
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Selection indicator with animation
                  _buildSelectionIndicator(isSelected, cardData),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCharacterContainer(
    Map<String, dynamic> cardData,
    bool isSelected,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 58.w,
      height: 58.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isSelected
              ? [
                  Colors.white.withValues(alpha: 0.3),
                  Colors.white.withValues(alpha: 0.1),
                ]
              : [
                  (cardData['color'] as Color).withValues(alpha: 0.15),
                  (cardData['color'] as Color).withValues(alpha: 0.05),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.5)
              : (cardData['color'] as Color).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            cardData['character'] as String,
            style: const TextStyle(fontSize: 32),
          ),
          // Small badge showing age range
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : cardData['color'] as Color,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                cardData['ageRange'] as String,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? cardData['color'] as Color : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionIndicator(
    bool isSelected,
    Map<String, dynamic> cardData,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 36.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.grey.shade100,
        shape: BoxShape.circle,
        border: isSelected
            ? null
            : Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.5),
                  blurRadius: 10.r,
                  spreadRadius: 2.r,
                ),
              ]
            : null,
      ),
      child: isSelected
          ? Icon(
              Icons.check_rounded,
              color: cardData['color'] as Color,
              size: 22.r,
            )
          : Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
              size: 16.r,
            ),
    );
  }

  Map<String, dynamic> _getCardData() {
    switch (widget.ageGroup) {
      case AgeGroup.toddler:
        return {
          'title': 'Tiny Tots',
          'subtitle': '2-4 Years (Nursery)',
          'description': 'Fun shapes, colors & sounds!',
          'character': '🧒',
          'funIcon': '🎨',
          'ageRange': '2-4',
          'color': const Color(0xFFFF6B6B),
        };
      case AgeGroup.lkgUkg:
        return {
          'title': 'Little Stars',
          'subtitle': '4-6 Years (LKG/UKG)',
          'description': 'ABCs, 123s & rhymes!',
          'character': '👧',
          'funIcon': '📚',
          'ageRange': '4-6',
          'color': const Color(0xFF4ECDC4),
        };
      case AgeGroup.class1To2:
        return {
          'title': 'Smart Kids',
          'subtitle': '6-8 Years (Class 1-2)',
          'description': 'Reading, writing & math!',
          'character': '👦',
          'funIcon': '✏️',
          'ageRange': '6-8',
          'color': const Color(0xFF45B7D1),
        };
      case AgeGroup.class3To4:
        return {
          'title': 'Explorers',
          'subtitle': '8-10 Years (Class 3-4)',
          'description': 'Science, STEM & creativity!',
          'character': '🧑',
          'funIcon': '🔬',
          'ageRange': '8-10',
          'color': const Color(0xFFFFBE0B),
        };
      case AgeGroup.class5To6:
        return {
          'title': 'Champions',
          'subtitle': '10-12 Years (Class 5-6)',
          'description': 'Advanced learning & projects!',
          'character': '🧑‍🎓',
          'funIcon': '🏆',
          'ageRange': '10-12',
          'color': const Color(0xFF9B5DE5),
        };
    }
  }

  void _selectAgeGroup(AgeContentService service) async {
    await service.setAgeGroup(widget.ageGroup);
  }
}

/// Widget for selecting child's exact age
class AgeInputPage extends StatefulWidget {
  const AgeInputPage({super.key});

  @override
  State<AgeInputPage> createState() => _AgeInputPageState();
}

class _AgeInputPageState extends State<AgeInputPage>
    with SingleTickerProviderStateMixin {
  int selectedAge = 4;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
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
        child: SafeArea(
          child: LayoutBuilder(
            // Portrait-shaped content: in landscape the body is barely 300pt tall,
            // which is shorter than this column needs. Scroll when that happens and
            // stay exactly as before whenever there is room.
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 40.h),

                    // Title with bouncing cake
                    AnimatedBuilder(
                      animation: _bounceController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, -_bounceController.value * 10),
                          child: const Text(
                            '🎂',
                            style: TextStyle(fontSize: 70),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "How old are you?",
                      style: GoogleFonts.fredoka(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "We'll make learning perfect for you!",
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: 50.h),

                    // Age selector wheel
                    SizedBox(
                      // A share of the viewport rather than `Expanded`:
                      // `Expanded` inside a scroll view needs an `IntrinsicHeight`
                      // above it, and a scrollable cannot report an intrinsic
                      // height - it throws.
                      height: math.max(200.h, constraints.maxHeight * 0.55),
                      child: Center(
                        child: SizedBox(
                          height: 220.h,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 90,
                            perspective: 0.003,
                            diameterRatio: 1.2,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedAge = index + 2;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 11, // Ages 2-12
                              builder: (context, index) {
                                final age = index + 2;
                                final isSelected = age == selectedAge;
                                final emoji = _getAgeEmoji(age);
                                return Center(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 50.w,
                                      vertical: 16.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFF56D97F),
                                                Color(0xFF10B981),
                                              ],
                                            )
                                          : null,
                                      color: isSelected
                                          ? null
                                          : Colors.white.withValues(
                                              alpha: 0.15,
                                            ),
                                      borderRadius: BorderRadius.circular(25.r),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF56D97F,
                                                ).withValues(alpha: 0.5),
                                                blurRadius: 20.r,
                                                offset: const Offset(0, 5),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          emoji,
                                          style: TextStyle(
                                            fontSize: isSelected ? 32 : 24,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Text(
                                          '$age years',
                                          style: GoogleFonts.fredoka(
                                            fontSize: isSelected ? 28 : 22,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Age group preview card
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.w),
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AgeContentService.getAgeGroupFromAge(
                              selectedAge,
                            ).emoji,
                            style: const TextStyle(fontSize: 36),
                          ),
                          SizedBox(width: 16.w),
                          // Takes the width left beside the emoji so the level name
                          // wraps instead of running off the card.
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Learning Level:',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  AgeContentService.getAgeGroupFromAge(
                                    selectedAge,
                                  ).displayName,
                                  style: GoogleFonts.fredoka(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Continue button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: GestureDetector(
                        onTap: _onContinue,
                        child: Container(
                          width: double.infinity,
                          height: 60.h,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF56D97F), Color(0xFF10B981)],
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF56D97F,
                                ).withValues(alpha: 0.5),
                                blurRadius: 20.r,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Let's Go! ",
                                style: GoogleFonts.fredoka(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text('🚀', style: TextStyle(fontSize: 24)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getAgeEmoji(int age) {
    if (age <= 3) return '👶';
    if (age <= 5) return '🧒';
    if (age <= 7) return '👧';
    if (age <= 9) return '👦';
    if (age <= 11) return '🧑';
    return '🧑‍🎓';
  }

  void _onContinue() async {
    final ageContentService = Get.find<AgeContentService>();
    await ageContentService.setChildAge(selectedAge);

    Get.snackbar(
      '',
      '',
      titleText: Row(
        children: [
          const Text('🎉 ', style: TextStyle(fontSize: 24)),
          Text(
            'Awesome!',
            style: GoogleFonts.fredoka(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
      messageText: Text(
        'Learning set for $selectedAge years old! Let\'s have fun! 🌟',
        style: const TextStyle(color: Colors.white),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF56D97F),
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.all(16.r),
      borderRadius: 16.r,
    );

    await Future.delayed(const Duration(milliseconds: 500));
    Get.offAllNamed('/home');
  }
}
