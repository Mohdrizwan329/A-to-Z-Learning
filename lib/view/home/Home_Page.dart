import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';
import 'package:jiyan_learning/view model/home controller/home_controller.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/services/age_content_service.dart';
import 'package:jiyan_learning/services/speech_recognition_service.dart';
import 'package:jiyan_learning/view/home/widgets/app_drawer.dart';
import 'package:jiyan_learning/view/profiles/notification/notification_list_page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());
  final AgeContentService ageService = Get.find<AgeContentService>();
  final SpeechRecognitionService speechService =
      Get.find<SpeechRecognitionService>();
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late AnimationController _starController;
  late Animation<double> _floatAnimation;

  // Fun emojis for each category (kept for backwards compatibility)
  final Map<String, String> categoryEmojis = {
    '1 to 100': '🔢',
    'Capital Letters': '🅰️',
    'Small Letters': '🔤',
    'Hindi Letters': '🇮🇳',
    'Alphabet': '📖',
    'Math Problem': '🧮',
    '2 to 40': '✖️',
    'Drawing': '🎨',
    'Drawing Image': '🖼️',
    'Math Questions': '❓',
    'Learning Sets': '📚',
    'Poetry': '📝',
    'Question Scanner': '📷',
    'Games Hub': '🎮',
    'Matching Game': '🃏',
    'Puzzle Game': '🧩',
    'Tracing Game': '✍️',
    'Quiz': '❔',
    'Rewards': '🏆',
    'Daily Goals': '🎯',
    'Certificates': '📜',
    'Shapes': '🔷',
    'Vehicles': '🚗',
    'Seasons': '🌤️',
    'GK': '🧠',
    'Stories': '📚',
    'Rhymes': '🎵',
    'Settings': '⚙️',
    'Parental Control': '👨‍👩‍👧',
    'Parent Dashboard': '📊',
    'Offline Learning': '📥',
    'Early Learning': '👶',
    'Sensory Learning': '👋',
    'Visual Learning': '👁️',
    'Audio Learning': '🔊',
    'Kinesthetic': '🤸',
    'Play-based': '🎮',
    'Exploratory': '🔭',
    'Discovery': '🔍',
    'Montessori': '🎓',
    'Activity-based': '🎯',
    'Experiential': '🎪',
    'World Map': '🗺️',
    'Global Cultures': '🌍',
    'Famous Places': '🏛️',
    'Think About Thinking': '🧠',
    'Self Reflection': '🪞',
    'Learning Strategies': '🎓',
    'Mini Projects': '🔬',
    'Home Experiments': '🧪',
    'DIY Learning': '🛠️',
    'Maker Space': '🔧',
    'Community Helpers': '👨‍🚒',
    'Family & Relationships': '👨‍👩‍👧‍👦',
    'Maps & Directions': '🗺️',
    'Citizenship Basics': '🏛️',
    'Rights & Duties': '⚖️',
    'Recycling for Kids': '♻️',
    'Climate Awareness': '🌍',
    'Sustainable Habits': '🌱',
    'Nutrition Learning': '🥗',
    'Exercise & Fitness': '🏃',
    'Body Safety': '🛡️',
    'Mental Health': '🧠',
    'Save Environment': '🌍',
    'Design Thinking': '💡',
    'Screen Responsibility': '📱',
    'Self Control': '🧘',
    'Daily Life Skills': '🏠',
    'Hygiene Habits': '🧼',
    'Money Habits': '💰',
    'Time Management': '⏰',
    'Safety Skills': '🦺',
    'Fun Games': '🎯',
    'Progress Reports': '📈',
    'Voice Learning': '🎤',
    'Quiz Battle': '⚔️',
    'Story Time': '📖',
    'Avatar Shop': '🧑‍🎨',
    'Leaderboard': '🏅',
    'Transaction': '💳',
  };

  // Mapping categories to progress keys
  final Map<String, String> categoryProgressKeys = {
    '1 to 100': ProgressService.kNumbers,
    'Capital Letters': ProgressService.kCapitalLetters,
    'Small Letters': ProgressService.kSmallLetters,
    'Hindi Letters': ProgressService.kHindiLetters,
    'Alphabet': ProgressService.kAlphabetWords,
    '2 to 40': ProgressService.kTables,
  };

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bubbleController.dispose();
    _starController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      drawer: AppDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Kid-friendly rainbow gradient background
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA), // Soft Purple
              Color(0xFF764BA2), // Deep Purple
              Color(0xFFf093fb), // Pink
              Color(0xFFf5576c), // Coral
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated floating bubbles background
            ..._buildFloatingBubbles(),

            // Main content
            SafeArea(
              child: Obx(() {
                var items = controller.filteredItems;
                if (items.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildContent(items);
              }),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 8,
      shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
      backgroundColor: Colors.transparent,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.menu_rounded, color: Colors.white, size: 22.r),
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          // Vibrant kid-friendly gradient - Coral to Pink to Orange
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF6B6B), // Coral Red
              Color(0xFFFF8E53), // Orange
              Color(0xFFFFAA5A), // Light Orange
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          boxShadow: [
            BoxShadow(
              color: Color(0x40FF6B6B),
              blurRadius: 15.r,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),

      title: FittedBox(
        // The title is a Row of separately styled words, so it cannot
        // ellipsize; scaling it down keeps the whole title readable on a
        // narrow phone instead of clipping the last word.
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Jiyan ',
              style: GoogleFonts.baloo2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4.r,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
            ),
            Text(
              'Kids ',
              style: GoogleFonts.baloo2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 136, 240, 1),
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4.r,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
            ),
            Text(
              'Learning',
              style: GoogleFonts.baloo2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFE66D),
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4.r,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
          ],
        ),
      ),
      actions: [
        // Notification Button
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          child: Container(
            // padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              icon: Icon(
                Icons.notifications_rounded,
                color: Colors.white,
                size: 22.r,
              ),
              onPressed: () => Get.to(() => NotificationListPage()),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  // Floating bubbles for playful effect
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

  Widget _buildEmptyState() {
    return Column(
      children: [
        _buildGlassSearchBar(),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated sad emoji
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: child,
                    );
                  },
                  child: Container(
                    width: 120.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 3,
                      ),
                    ),
                    child: const Center(
                      child: Text('🔍', style: TextStyle(fontSize: 60)),
                    ),
                  ),
                ),
                SizedBox(height: AppTheme.spacingL),
                Text(
                  'Oops! Nothing Found',
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppTheme.spacingS),
                Text(
                  'Try searching something else!',
                  style: GoogleFonts.nunito(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(List<ClassItem> items) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Glass Search Bar
          _buildGlassSearchBar(),

          // Category-wise content
          Obx(() {
            final categories = controller.orderedCategories;

            if (categories.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...categories.map((entry) {
                  final categoryName = entry.key;
                  final categoryItems = entry.value;
                  final categoryData =
                      HomeController.categoryMeta[categoryName];

                  return _buildCategorySection(
                    categoryName,
                    categoryData?.emoji ?? '📚',
                    categoryItems,
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    String title,
    String emoji,
    List<ClassItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: 8.h,
          ),
          child: Center(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      title,
                      style: GoogleFonts.baloo2(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),

        // Category Items Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.r,
            crossAxisSpacing: 16.r,
            childAspectRatio: 1.1,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildCategoryCard(item, index);
          },
        ),

        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildCategoryCard(ClassItem item, int index) {
    return GestureDetector(
      onTap: () {
        TtsService.to.speak(item.title);
        if (item.pageBuilder != null) {
          Get.to(item.pageBuilder!);
        }
      },
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          final offset = (index % 2 == 0)
              ? _floatAnimation.value * 0.5
              : -_floatAnimation.value * 0.5;
          return Transform.translate(offset: Offset(0, offset), child: child);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: item.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: item.gradient[0].withValues(alpha: 0.4),
                blurRadius: 8.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                top: -15.h,
                right: -15.w,
                child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              // Content
              Center(
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Emoji
                      Container(
                        width: 75.w,
                        height: 75.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            item.emoji,
                            style: const TextStyle(fontSize: 35),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Title
                      Text(
                        item.title,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Obx(() {
            final isListening = speechService.isListening.value;
            final recognizedText = speechService.recognizedText.value;

            return Container(
              height: 56.h,
              decoration: BoxDecoration(
                color: isListening
                    ? const Color(0xFFFF6B6B).withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isListening
                      ? const Color(0xFFFF6B6B).withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Stack(
                children: [
                  // Wave Animation (visible when listening)
                  if (isListening)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18.r),
                        child: _buildWaveAnimation(),
                      ),
                    ),

                  // Search Field or Listening Text
                  Row(
                    children: [
                      // Prefix Icon
                      Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: Icon(
                          isListening ? Icons.mic : Icons.search,
                          color: Colors.white,
                          size: 22.r,
                        ),
                      ),

                      // Text Field or Listening Status
                      Expanded(
                        child: isListening
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Text(
                                  recognizedText.isEmpty
                                      ? 'Listening...'
                                      : recognizedText,
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : TextField(
                                controller: _searchController,
                                onChanged: controller.updateSearch,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  hintStyle: GoogleFonts.nunito(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 15,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 16.h,
                                  ),
                                ),
                              ),
                      ),

                      // Mic / Stop Button
                      GestureDetector(
                        onTap: _toggleVoiceSearch,
                        child: Container(
                          margin: EdgeInsets.all(8.r),
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            gradient: isListening
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B6B),
                                      Color(0xFFFF8E53),
                                    ],
                                  )
                                : null,
                            color: isListening
                                ? null
                                : Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: isListening
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFF6B6B,
                                      ).withValues(alpha: 0.4),
                                      blurRadius: 8.r,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            isListening
                                ? Icons.stop_rounded
                                : Icons.mic_none_rounded,
                            color: Colors.white,
                            size: 20.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // Wave animation for voice search
  Widget _buildWaveAnimation() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return CustomPaint(
          painter: _WavePainter(
            animationValue: _floatController.value,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          size: Size.infinite,
        );
      },
    );
  }

  void _toggleVoiceSearch() async {
    if (speechService.isListening.value) {
      await speechService.stopListening();
      // Apply the recognized text to search
      final text = speechService.recognizedText.value;
      if (text.isNotEmpty) {
        _searchController.text = text;
        controller.updateSearch(text);
      }
    } else {
      // Check if speech recognition is available
      if (!speechService.isAvailable.value) {
        Get.snackbar(
          '🎤 Microphone',
          'Speech recognition is not available. Please check microphone permissions.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFF6B6B),
          colorText: Colors.white,
          margin: EdgeInsets.all(16.r),
          borderRadius: 12.r,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Clear previous text
      speechService.recognizedText.value = '';

      try {
        await speechService.startListening(
          locale: 'en_IN',
          onResultCallback: (recognizedText) {
            _searchController.text = recognizedText;
            controller.updateSearch(recognizedText);
          },
        );
      } catch (e) {
        Get.snackbar(
          '🎤 Error',
          'Failed to start listening: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFF6B6B),
          colorText: Colors.white,
          margin: EdgeInsets.all(16.r),
          borderRadius: 12.r,
        );
      }
    }
  }
}

// Wave Painter for voice search animation
class _WavePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _WavePainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 8.0;
    final waveLength = size.width / 3;

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y =
          size.height / 2 +
          waveHeight *
              math.sin(
                (x / waveLength * 2 * math.pi) + (animationValue * 2 * math.pi),
              ) +
          waveHeight *
              0.5 *
              math.sin(
                (x / waveLength * 4 * math.pi) + (animationValue * 4 * math.pi),
              );
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Second wave layer
    final paint2 = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y =
          size.height / 2 +
          waveHeight *
              math.sin(
                (x / waveLength * 2 * math.pi) +
                    (animationValue * 2 * math.pi) +
                    math.pi,
              ) +
          waveHeight *
              0.3 *
              math.cos(
                (x / waveLength * 3 * math.pi) + (animationValue * 3 * math.pi),
              );
      path2.lineTo(x, y);
    }

    path2.lineTo(size.width, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
