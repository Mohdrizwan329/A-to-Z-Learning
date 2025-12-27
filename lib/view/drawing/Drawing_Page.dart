import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:painter/painter.dart';

class KidsDrowingScreen extends StatefulWidget {
  const KidsDrowingScreen({super.key});

  @override
  State<KidsDrowingScreen> createState() => _KidsDrowingScreenState();
}

class _KidsDrowingScreenState extends State<KidsDrowingScreen>
    with TickerProviderStateMixin {
  late PainterController controller;
  Color selectedColor = Colors.black;
  bool isToolMenuOpen = false;
  bool isColorMenuOpen = false;
  late AnimationController _animationController;
  late AnimationController _colorAnimationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _colorExpandAnimation;

  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.pink,
    Colors.brown,
    Colors.black,
    Colors.teal,
    Colors.cyan,
    Colors.lime,
    Colors.indigo,
    Colors.amber,
    Colors.grey,
  ];

  @override
  void initState() {
    super.initState();
    controller = _newController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _colorAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _colorExpandAnimation = CurvedAnimation(
      parent: _colorAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _colorAnimationController.dispose();
    super.dispose();
  }

  void _toggleToolMenu() {
    setState(() {
      isToolMenuOpen = !isToolMenuOpen;
      if (isToolMenuOpen) {
        _animationController.forward();
        // Close color menu if open
        if (isColorMenuOpen) {
          isColorMenuOpen = false;
          _colorAnimationController.reverse();
        }
      } else {
        _animationController.reverse();
      }
    });
  }

  void _toggleColorMenu() {
    setState(() {
      isColorMenuOpen = !isColorMenuOpen;
      if (isColorMenuOpen) {
        _colorAnimationController.forward();
        // Close tool menu if open
        if (isToolMenuOpen) {
          isToolMenuOpen = false;
          _animationController.reverse();
        }
      } else {
        _colorAnimationController.reverse();
      }
    });
  }

  PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.white;
    return controller;
  }

  void _refreshCanvas() {
    setState(() {
      controller = _newController();
      selectedColor = Colors.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
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
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("🎨", style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              "Kids Drawing",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Text("🖌️", style: TextStyle(fontSize: 24)),
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
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 90),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Painter(controller),
                ),
              ),
              // Grey overlay when menu is open
              if (isToolMenuOpen || isColorMenuOpen)
                GestureDetector(
                  onTap: () {
                    if (isToolMenuOpen) _toggleToolMenu();
                    if (isColorMenuOpen) _toggleColorMenu();
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              _buildBottomToolBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomToolBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Expandable menus row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Color menu popup (left side)
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: SizeTransition(
                  sizeFactor: _colorExpandAnimation,
                  axisAlignment: 1.0,
                  child: Container(
                    height: 280,
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: colors.map((color) {
                          final isSelected = selectedColor == color;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = color;
                                controller.eraseMode = false;
                                controller.drawColor = color;
                              });
                              _toggleColorMenu();
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              margin: EdgeInsets.symmetric(vertical: 3),
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.black : Colors.white,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withOpacity(0.4),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: isSelected
                                  ? Icon(Icons.check, color: _getContrastColor(color), size: 18)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              // Tool menu popup (right side)
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: SizeTransition(
                  sizeFactor: _expandAnimation,
                  axisAlignment: 1.0,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildToolOption(Icons.brush, Colors.purple, () {
                          setState(() {
                            controller.eraseMode = false;
                            controller.drawColor = selectedColor;
                            controller.thickness = 5.0;
                          });
                          _toggleToolMenu();
                        }),
                        _buildToolOption(Icons.auto_fix_high, Colors.orange, () {
                          setState(() {
                            controller.eraseMode = true;
                            controller.thickness = 20.0;
                          });
                          _toggleToolMenu();
                        }),
                        _buildToolOption(Icons.add, Colors.green, () {
                          setState(() {
                            if (controller.thickness < 30) controller.thickness += 3;
                          });
                        }),
                        _buildToolOption(Icons.remove, Colors.red, () {
                          setState(() {
                            if (controller.thickness > 2) controller.thickness -= 3;
                          });
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Bottom bar with both buttons
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Color button
                GestureDetector(
                  onTap: _toggleColorMenu,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isColorMenuOpen
                            ? [Color(0xFFFF6B6B), Color(0xFFFF8E53)]
                            : [selectedColor, selectedColor.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: (isColorMenuOpen ? Color(0xFFFF6B6B) : selectedColor)
                              .withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isColorMenuOpen ? Icons.close : Icons.palette,
                      color: isColorMenuOpen ? Colors.white : _getContrastColor(selectedColor),
                      size: 24,
                    ),
                  ),
                ),
                // Refresh button (center)
                GestureDetector(
                  onTap: _refreshCanvas,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4ECDC4), Color(0xFF44B09E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF4ECDC4).withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                // Tool button
                GestureDetector(
                  onTap: _toggleToolMenu,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isToolMenuOpen
                            ? [Color(0xFFFF6B6B), Color(0xFFFF8E53)]
                            : [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isToolMenuOpen ? Color(0xFFFF6B6B) : Color(0xFF667EEA))
                              .withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isToolMenuOpen ? Icons.close : Icons.brush,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolOption(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Color _getContrastColor(Color color) {
    double luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
