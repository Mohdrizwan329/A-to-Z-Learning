import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view model/home controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());

  late AnimationController _floatController;
  late AnimationController _scaleController;
  late Animation<double> _floatAnimation;

  // Colorful gradients for each card
  final List<List<Color>> cardGradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E8E)], // Red
    [Color(0xFF4ECDC4), Color(0xFF44A08D)], // Teal
    [Color(0xFFFFE66D), Color(0xFFFFA502)], // Yellow-Orange
    [Color(0xFFA8E6CF), Color(0xFF56AB91)], // Green
    [Color(0xFFDDA0DD), Color(0xFFBA68C8)], // Purple
    [Color(0xFF74B9FF), Color(0xFF0984E3)], // Blue
    [Color(0xFFFFB8B8), Color(0xFFFF7675)], // Pink
    [Color(0xFF81ECEC), Color(0xFF00CEC9)], // Cyan
    [Color(0xFFFDCB6E), Color(0xFFE17055)], // Orange
    [Color(0xFFA29BFE), Color(0xFF6C5CE7)], // Violet
    [Color(0xFF55EFC4), Color(0xFF00B894)], // Mint
    [Color(0xFFFF9FF3), Color(0xFFF368E0)], // Magenta
  ];

  // Fun emojis for each category
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
  };

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _floatAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("🎓", style: TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.white, Color(0xFFFFE66D)],
              ).createShader(bounds),
              child: const Text(
                "Learning For Kids",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text("🌟", style: TextStyle(fontSize: 28)),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Obx(() {
            var items = controller.filteredItems;
            if (items.isEmpty) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Search Bar
                    _buildSearchBar(),
                    SizedBox(height: 100),
                    Text("��", style: TextStyle(fontSize: 60)),
                    SizedBox(height: 16),
                    Text(
                      "Kuch nahi mila!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  // Search Bar - now scrolls with content
                  _buildSearchBar(),
                  // Grid Items
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final gradient =
                          cardGradients[index % cardGradients.length];
                      final emoji = categoryEmojis[item.title] ?? '⭐';

                      return AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          // Stagger the float animation for each card
                          final offset = (index % 2 == 0)
                              ? _floatAnimation.value
                              : -_floatAnimation.value;
                          return Transform.translate(
                            offset: Offset(0, offset),
                            child: child,
                          );
                        },
                        child: _buildCard(item, gradient, emoji, index),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: TextField(
          onChanged: controller.updateSearch,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Kya dhundh rahe ho? 🔍",
            hintStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.search, color: Colors.white70),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    ClassItem item,
    List<Color> gradient,
    String emoji,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        if (item.pageBuilder != null) {
          Get.to(item.pageBuilder!);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decoration circles
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            // Content
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Emoji container
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(emoji, style: TextStyle(fontSize: 42)),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Title
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
