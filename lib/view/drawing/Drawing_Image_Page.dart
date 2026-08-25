import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class ImageDrowingScreen extends StatefulWidget {
  final String imagePath;

  const ImageDrowingScreen({super.key, required this.imagePath});

  @override
  State<ImageDrowingScreen> createState() => _ImageDrowingScreenState();
}

class _ImageDrowingScreenState extends State<ImageDrowingScreen>
    with TickerProviderStateMixin {
  Color selectedColor = Colors.red;
  double brushSize = 20.0;
  bool isToolMenuOpen = false;
  bool isColorMenuOpen = false;
  bool isErasing = false;
  late AnimationController _animationController;
  late AnimationController _colorAnimationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _colorExpandAnimation;

  // Drawing data
  List<DrawingPoint?> drawingPoints = [];

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
        if (isToolMenuOpen) {
          isToolMenuOpen = false;
          _animationController.reverse();
        }
      } else {
        _colorAnimationController.reverse();
      }
    });
  }

  void _refreshCanvas() {
    setState(() {
      drawingPoints.clear();
      selectedColor = Colors.red;
      isErasing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GradientScaffold(
      title: 'Kids Coloring',
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
          onPressed: _refreshCanvas,
        ),
      ],
      body: SafeArea(
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
                  child: _buildColoringCanvas(),
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
    );
  }

  Widget _buildColoringCanvas() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final filledSvgPath = widget.imagePath.replaceAll('.svg', '_filled.svg');

        return GestureDetector(
          onPanStart: (details) {
            setState(() {
              drawingPoints.add(
                DrawingPoint(
                  offset: details.localPosition,
                  color: isErasing ? Colors.white : selectedColor,
                  strokeWidth: isErasing ? brushSize * 2 : brushSize,
                ),
              );
            });
          },
          onPanUpdate: (details) {
            setState(() {
              drawingPoints.add(
                DrawingPoint(
                  offset: details.localPosition,
                  color: isErasing ? Colors.white : selectedColor,
                  strokeWidth: isErasing ? brushSize * 2 : brushSize,
                ),
              );
            });
          },
          onPanEnd: (details) {
            setState(() {
              drawingPoints.add(null);
            });
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // White background
              Container(color: Colors.white),
              // Drawing with mask - only visible inside shape
              if (widget.imagePath.endsWith('.svg'))
                RepaintBoundary(
                  child: CustomPaint(
                    foregroundPainter: MaskPainter(
                      svgMaskPath: filledSvgPath,
                      canvasSize: constraints.biggest,
                    ),
                    child: CustomPaint(
                      painter: DrawingPainter(drawingPoints: drawingPoints),
                      size: Size.infinite,
                    ),
                  ),
                )
              else
                CustomPaint(
                  painter: DrawingPainter(drawingPoints: drawingPoints),
                  size: Size.infinite,
                ),
              // SVG outline on top
              IgnorePointer(
                child: widget.imagePath.endsWith('.svg')
                    ? SvgPicture.asset(
                        widget.imagePath,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(widget.imagePath, fit: BoxFit.contain),
              ),
            ],
          ),
        );
      },
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
                                isErasing = false;
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
                            isErasing = false;
                          });
                          _toggleToolMenu();
                        }),
                        _buildToolOption(Icons.auto_fix_high, Colors.orange, () {
                          setState(() {
                            isErasing = true;
                          });
                          _toggleToolMenu();
                        }),
                        _buildToolOption(Icons.add, Colors.green, () {
                          setState(() {
                            if (brushSize < 50) brushSize += 5;
                          });
                        }),
                        _buildToolOption(Icons.remove, Colors.red, () {
                          setState(() {
                            if (brushSize > 5) brushSize -= 5;
                          });
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Bottom bar with buttons
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
                            ? [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)]
                            : [selectedColor, selectedColor.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: (isColorMenuOpen ? Color(0xFFFF6B6B) : selectedColor)
                              .withOpacity(0.4),
                          blurRadius: 6,
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
                            ? [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)]
                            : [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isToolMenuOpen ? Color(0xFFFF6B6B) : Color(0xFF667EEA))
                              .withOpacity(0.4),
                          blurRadius: 6,
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

// Drawing point class
class DrawingPoint {
  final Offset offset;
  final Color color;
  final double strokeWidth;

  DrawingPoint({
    required this.offset,
    required this.color,
    required this.strokeWidth,
  });
}

// Drawing painter
class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  DrawingPainter({required this.drawingPoints});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        final paint = Paint()
          ..color = drawingPoints[i]!.color
          ..strokeWidth = drawingPoints[i]!.strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke;

        canvas.drawLine(
          drawingPoints[i]!.offset,
          drawingPoints[i + 1]!.offset,
          paint,
        );
      } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
        final paint = Paint()
          ..color = drawingPoints[i]!.color
          ..strokeWidth = drawingPoints[i]!.strokeWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          drawingPoints[i]!.offset,
          drawingPoints[i]!.strokeWidth / 2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return true;
  }
}

// Mask painter - paints white overlay outside the shape to hide drawing
class MaskPainter extends CustomPainter {
  final String svgMaskPath;
  final Size canvasSize;

  MaskPainter({
    required this.svgMaskPath,
    required this.canvasSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // This painter creates a white overlay that covers everything
    // except the shape area (which remains transparent to show drawing)

    // Calculate centered position for the shape (matching BoxFit.contain)
    const double svgSize = 200.0; // SVG viewBox size
    final double scale = (size.width < size.height ? size.width : size.height) / svgSize;
    final double offsetX = (size.width - svgSize * scale) / 2;
    final double offsetY = (size.height - svgSize * scale) / 2;

    // Create the shape path based on SVG name
    final Path shapePath = _createShapePath(svgMaskPath, scale, offsetX, offsetY);

    // Create outer rectangle path
    final Path outerPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Combine paths - outer minus shape (creates hole in the middle)
    final Path maskPath = Path.combine(PathOperation.difference, outerPath, shapePath);

    // Draw white mask (covers everything except shape area)
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawPath(maskPath, paint);
  }

  Path _createShapePath(String svgPath, double scale, double offsetX, double offsetY) {
    final Path path = Path();

    // Extract shape name from path
    final shapeName = svgPath.split('/').last.replaceAll('_filled.svg', '');

    // Create appropriate shape based on SVG - all 40 images
    switch (shapeName) {
      // Animals (15)
      case 'elephant':
        _addElephantPath(path, scale, offsetX, offsetY);
        break;
      case 'butterfly':
        _addButterflyPath(path, scale, offsetX, offsetY);
        break;
      case 'fish':
        _addFishPath(path, scale, offsetX, offsetY);
        break;
      case 'cat':
        _addCatPath(path, scale, offsetX, offsetY);
        break;
      case 'dog':
        _addDogPath(path, scale, offsetX, offsetY);
        break;
      case 'bird':
        _addBirdPath(path, scale, offsetX, offsetY);
        break;
      case 'lion':
        _addLionPath(path, scale, offsetX, offsetY);
        break;
      case 'rabbit':
        _addRabbitPath(path, scale, offsetX, offsetY);
        break;
      case 'bear':
        _addBearPath(path, scale, offsetX, offsetY);
        break;
      case 'turtle':
        _addTurtlePath(path, scale, offsetX, offsetY);
        break;
      case 'frog':
        _addFrogPath(path, scale, offsetX, offsetY);
        break;
      case 'owl':
        _addOwlPath(path, scale, offsetX, offsetY);
        break;
      case 'penguin':
        _addPenguinPath(path, scale, offsetX, offsetY);
        break;
      case 'dolphin':
        _addDolphinPath(path, scale, offsetX, offsetY);
        break;
      case 'unicorn':
        _addUnicornPath(path, scale, offsetX, offsetY);
        break;
      // Nature (10)
      case 'flower':
        _addFlowerPath(path, scale, offsetX, offsetY);
        break;
      case 'tree':
        _addTreePath(path, scale, offsetX, offsetY);
        break;
      case 'sun':
        _addSunPath(path, scale, offsetX, offsetY);
        break;
      case 'moon':
        _addMoonPath(path, scale, offsetX, offsetY);
        break;
      case 'rainbow':
        _addRainbowPath(path, scale, offsetX, offsetY);
        break;
      case 'cloud':
        _addCloudPath(path, scale, offsetX, offsetY);
        break;
      case 'mountain':
        _addMountainPath(path, scale, offsetX, offsetY);
        break;
      case 'mushroom':
        _addMushroomPath(path, scale, offsetX, offsetY);
        break;
      case 'leaf':
        _addLeafPath(path, scale, offsetX, offsetY);
        break;
      case 'cactus':
        _addCactusPath(path, scale, offsetX, offsetY);
        break;
      // Objects (10)
      case 'star':
        _addStarPath(path, scale, offsetX, offsetY);
        break;
      case 'heart':
        _addHeartPath(path, scale, offsetX, offsetY);
        break;
      case 'house':
        _addHousePath(path, scale, offsetX, offsetY);
        break;
      case 'car':
        _addCarPath(path, scale, offsetX, offsetY);
        break;
      case 'rocket':
        _addRocketPath(path, scale, offsetX, offsetY);
        break;
      case 'airplane':
        _addAirplanePath(path, scale, offsetX, offsetY);
        break;
      case 'boat':
        _addBoatPath(path, scale, offsetX, offsetY);
        break;
      case 'balloon':
        _addBalloonPath(path, scale, offsetX, offsetY);
        break;
      case 'gift':
        _addGiftPath(path, scale, offsetX, offsetY);
        break;
      case 'crown':
        _addCrownPath(path, scale, offsetX, offsetY);
        break;
      // Food (5)
      case 'apple':
        _addApplePath(path, scale, offsetX, offsetY);
        break;
      case 'icecream':
        _addIcecreamPath(path, scale, offsetX, offsetY);
        break;
      case 'cupcake':
        _addCupcakePath(path, scale, offsetX, offsetY);
        break;
      case 'pizza':
        _addPizzaPath(path, scale, offsetX, offsetY);
        break;
      case 'watermelon':
        _addWatermelonPath(path, scale, offsetX, offsetY);
        break;
      default:
        _addDefaultPath(path, scale, offsetX, offsetY);
    }

    return path;
  }

  void _addElephantPath(Path path, double scale, double ox, double oy) {
    // Elephant body
    path.addOval(Rect.fromCenter(
      center: Offset(ox + 100 * scale, oy + 110 * scale),
      width: 120 * scale,
      height: 80 * scale,
    ));
    // Head
    path.addOval(Rect.fromCenter(
      center: Offset(ox + 155 * scale, oy + 80 * scale),
      width: 50 * scale,
      height: 50 * scale,
    ));
    // Ear
    path.addOval(Rect.fromCenter(
      center: Offset(ox + 175 * scale, oy + 70 * scale),
      width: 30 * scale,
      height: 40 * scale,
    ));
  }

  void _addButterflyPath(Path path, double scale, double ox, double oy) {
    // Wings
    path.addOval(Rect.fromCenter(
      center: Offset(ox + 60 * scale, oy + 80 * scale),
      width: 70 * scale,
      height: 90 * scale,
    ));
    path.addOval(Rect.fromCenter(
      center: Offset(ox + 140 * scale, oy + 80 * scale),
      width: 70 * scale,
      height: 90 * scale,
    ));
    path.addOval(Rect.fromCenter(
      center: Offset(ox + 60 * scale, oy + 140 * scale),
      width: 50 * scale,
      height: 60 * scale,
    ));
    path.addOval(Rect.fromCenter(
      center: Offset(ox + 140 * scale, oy + 140 * scale),
      width: 50 * scale,
      height: 60 * scale,
    ));
    // Body
    path.addOval(Rect.fromCenter(
      center: Offset(ox + 100 * scale, oy + 100 * scale),
      width: 20 * scale,
      height: 100 * scale,
    ));
  }

  void _addFishPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(
      center: Offset(ox + 100 * scale, oy + 100 * scale),
      width: 140 * scale,
      height: 80 * scale,
    ));
  }

  void _addCatPath(Path path, double scale, double ox, double oy) {
    // Head
    path.addOval(Rect.fromCenter(
      center: Offset(ox + 100 * scale, oy + 100 * scale),
      width: 120 * scale,
      height: 100 * scale,
    ));
    // Ears
    path.moveTo(ox + 50 * scale, oy + 60 * scale);
    path.lineTo(ox + 35 * scale, oy + 20 * scale);
    path.lineTo(ox + 70 * scale, oy + 50 * scale);
    path.close();
    path.moveTo(ox + 150 * scale, oy + 60 * scale);
    path.lineTo(ox + 165 * scale, oy + 20 * scale);
    path.lineTo(ox + 130 * scale, oy + 50 * scale);
    path.close();
  }

  void _addHeartPath(Path path, double scale, double ox, double oy) {
    path.moveTo(ox + 100 * scale, oy + 170 * scale);
    path.cubicTo(
      ox + 30 * scale, oy + 120 * scale,
      ox + 30 * scale, oy + 50 * scale,
      ox + 100 * scale, oy + 70 * scale,
    );
    path.cubicTo(
      ox + 170 * scale, oy + 50 * scale,
      ox + 170 * scale, oy + 120 * scale,
      ox + 100 * scale, oy + 170 * scale,
    );
  }

  void _addStarPath(Path path, double scale, double ox, double oy) {
    path.moveTo(ox + 100 * scale, oy + 20 * scale);
    path.lineTo(ox + 120 * scale, oy + 75 * scale);
    path.lineTo(ox + 180 * scale, oy + 80 * scale);
    path.lineTo(ox + 135 * scale, oy + 120 * scale);
    path.lineTo(ox + 150 * scale, oy + 175 * scale);
    path.lineTo(ox + 100 * scale, oy + 145 * scale);
    path.lineTo(ox + 50 * scale, oy + 175 * scale);
    path.lineTo(ox + 65 * scale, oy + 120 * scale);
    path.lineTo(ox + 20 * scale, oy + 80 * scale);
    path.lineTo(ox + 80 * scale, oy + 75 * scale);
    path.close();
  }

  void _addFlowerPath(Path path, double scale, double ox, double oy) {
    // Petals
    for (int i = 0; i < 8; i++) {
      final angle = i * 3.14159 / 4;
      path.addOval(Rect.fromCenter(
        center: Offset(
          ox + 100 * scale + 45 * scale * (angle == 0 ? 1 : (angle.abs() < 2 ? (1 - angle.abs() / 2) : -1 + (angle.abs() - 2) / 2)),
          oy + 100 * scale + 45 * scale * (i < 4 ? (i - 2).abs() - 1 : (i - 6).abs() - 1),
        ),
        width: 40 * scale,
        height: 40 * scale,
      ));
    }
    // Center
    path.addOval(Rect.fromCenter(
      center: Offset(ox + 100 * scale, oy + 100 * scale),
      width: 50 * scale,
      height: 50 * scale,
    ));
  }

  void _addSunPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(
      center: Offset(ox + 100 * scale, oy + 100 * scale),
      width: 100 * scale,
      height: 100 * scale,
    ));
  }

  // Animals
  void _addDogPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 100 * scale), width: 100 * scale, height: 90 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 45 * scale, oy + 70 * scale), width: 40 * scale, height: 50 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 155 * scale, oy + 70 * scale), width: 40 * scale, height: 50 * scale));
  }

  void _addBirdPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 100 * scale), width: 80 * scale, height: 60 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 150 * scale, oy + 85 * scale), width: 40 * scale, height: 35 * scale));
  }

  void _addLionPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 100 * scale), width: 140 * scale, height: 140 * scale));
  }

  void _addRabbitPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 120 * scale), width: 80 * scale, height: 70 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 70 * scale), width: 60 * scale, height: 50 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 75 * scale, oy + 30 * scale), width: 20 * scale, height: 50 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 125 * scale, oy + 30 * scale), width: 20 * scale, height: 50 * scale));
  }

  void _addBearPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 60 * scale, oy + 50 * scale), width: 50 * scale, height: 50 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 140 * scale, oy + 50 * scale), width: 50 * scale, height: 50 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 100 * scale), width: 120 * scale, height: 100 * scale));
  }

  void _addTurtlePath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 110 * scale), width: 140 * scale, height: 100 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 160 * scale, oy + 80 * scale), width: 36 * scale, height: 36 * scale));
  }

  void _addFrogPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 120 * scale), width: 130 * scale, height: 90 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 60 * scale, oy + 70 * scale), width: 50 * scale, height: 50 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 140 * scale, oy + 70 * scale), width: 50 * scale, height: 50 * scale));
  }

  void _addOwlPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 110 * scale), width: 110 * scale, height: 130 * scale));
  }

  void _addPenguinPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 120 * scale), width: 100 * scale, height: 130 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 55 * scale), width: 70 * scale, height: 70 * scale));
  }

  void _addDolphinPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 110 * scale), width: 150 * scale, height: 70 * scale));
  }

  void _addUnicornPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 130 * scale), width: 120 * scale, height: 80 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 145 * scale, oy + 85 * scale), width: 60 * scale, height: 60 * scale));
  }

  // Nature
  void _addTreePath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 70 * scale), width: 120 * scale, height: 100 * scale));
    path.addRect(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 150 * scale), width: 30 * scale, height: 60 * scale));
  }

  void _addMoonPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 100 * scale), width: 120 * scale, height: 120 * scale));
  }

  void _addRainbowPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 120 * scale), width: 160 * scale, height: 100 * scale));
  }

  void _addCloudPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 70 * scale, oy + 110 * scale), width: 80 * scale, height: 60 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 120 * scale, oy + 100 * scale), width: 90 * scale, height: 70 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 160 * scale, oy + 115 * scale), width: 60 * scale, height: 50 * scale));
  }

  void _addMountainPath(Path path, double scale, double ox, double oy) {
    path.moveTo(ox + 20 * scale, oy + 170 * scale);
    path.lineTo(ox + 80 * scale, oy + 50 * scale);
    path.lineTo(ox + 140 * scale, oy + 170 * scale);
    path.close();
    path.moveTo(ox + 60 * scale, oy + 170 * scale);
    path.lineTo(ox + 120 * scale, oy + 70 * scale);
    path.lineTo(ox + 180 * scale, oy + 170 * scale);
    path.close();
  }

  void _addMushroomPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 70 * scale), width: 140 * scale, height: 80 * scale));
    path.addRect(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 145 * scale), width: 50 * scale, height: 70 * scale));
  }

  void _addLeafPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 100 * scale), width: 100 * scale, height: 140 * scale));
  }

  void _addCactusPath(Path path, double scale, double ox, double oy) {
    path.addRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 115 * scale), width: 40 * scale, height: 130 * scale), Radius.circular(20 * scale)));
    path.addRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(ox + 60 * scale, oy + 125 * scale), width: 40 * scale, height: 50 * scale), Radius.circular(15 * scale)));
    path.addRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(ox + 140 * scale, oy + 100 * scale), width: 40 * scale, height: 45 * scale), Radius.circular(15 * scale)));
  }

  // Objects
  void _addHousePath(Path path, double scale, double ox, double oy) {
    path.addRect(Rect.fromLTWH(ox + 40 * scale, oy + 90 * scale, 120 * scale, 90 * scale));
    path.moveTo(ox + 30 * scale, oy + 95 * scale);
    path.lineTo(ox + 100 * scale, oy + 30 * scale);
    path.lineTo(ox + 170 * scale, oy + 95 * scale);
    path.close();
  }

  void _addCarPath(Path path, double scale, double ox, double oy) {
    path.addRect(Rect.fromLTWH(ox + 30 * scale, oy + 90 * scale, 140 * scale, 40 * scale));
    path.moveTo(ox + 50 * scale, oy + 90 * scale);
    path.lineTo(ox + 70 * scale, oy + 60 * scale);
    path.lineTo(ox + 140 * scale, oy + 60 * scale);
    path.lineTo(ox + 160 * scale, oy + 90 * scale);
    path.close();
    path.addOval(Rect.fromCenter(center: Offset(ox + 60 * scale, oy + 130 * scale), width: 40 * scale, height: 40 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 150 * scale, oy + 130 * scale), width: 40 * scale, height: 40 * scale));
  }

  void _addRocketPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 90 * scale), width: 60 * scale, height: 120 * scale));
    path.moveTo(ox + 70 * scale, oy + 140 * scale);
    path.lineTo(ox + 100 * scale, oy + 180 * scale);
    path.lineTo(ox + 130 * scale, oy + 140 * scale);
    path.close();
  }

  void _addAirplanePath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 100 * scale), width: 140 * scale, height: 40 * scale));
    path.moveTo(ox + 70 * scale, oy + 100 * scale);
    path.lineTo(ox + 30 * scale, oy + 70 * scale);
    path.lineTo(ox + 30 * scale, oy + 130 * scale);
    path.close();
  }

  void _addBoatPath(Path path, double scale, double ox, double oy) {
    path.moveTo(ox + 30 * scale, oy + 130 * scale);
    path.lineTo(ox + 50 * scale, oy + 160 * scale);
    path.lineTo(ox + 150 * scale, oy + 160 * scale);
    path.lineTo(ox + 170 * scale, oy + 130 * scale);
    path.close();
    path.addRect(Rect.fromLTWH(ox + 90 * scale, oy + 70 * scale, 8 * scale, 60 * scale));
    path.moveTo(ox + 98 * scale, oy + 75 * scale);
    path.lineTo(ox + 150 * scale, oy + 100 * scale);
    path.lineTo(ox + 98 * scale, oy + 130 * scale);
    path.close();
  }

  void _addBalloonPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 80 * scale), width: 90 * scale, height: 110 * scale));
  }

  void _addGiftPath(Path path, double scale, double ox, double oy) {
    path.addRect(Rect.fromLTWH(ox + 40 * scale, oy + 80 * scale, 120 * scale, 100 * scale));
    path.addRect(Rect.fromLTWH(ox + 35 * scale, oy + 60 * scale, 130 * scale, 25 * scale));
  }

  void _addCrownPath(Path path, double scale, double ox, double oy) {
    path.moveTo(ox + 30 * scale, oy + 150 * scale);
    path.lineTo(ox + 30 * scale, oy + 80 * scale);
    path.lineTo(ox + 60 * scale, oy + 110 * scale);
    path.lineTo(ox + 100 * scale, oy + 60 * scale);
    path.lineTo(ox + 140 * scale, oy + 110 * scale);
    path.lineTo(ox + 170 * scale, oy + 80 * scale);
    path.lineTo(ox + 170 * scale, oy + 150 * scale);
    path.close();
  }

  // Food
  void _addApplePath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 110 * scale), width: 100 * scale, height: 110 * scale));
  }

  void _addIcecreamPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 60 * scale), width: 80 * scale, height: 60 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 65 * scale, oy + 85 * scale), width: 50 * scale, height: 40 * scale));
    path.addOval(Rect.fromCenter(center: Offset(ox + 135 * scale, oy + 85 * scale), width: 50 * scale, height: 40 * scale));
    path.moveTo(ox + 55 * scale, oy + 100 * scale);
    path.lineTo(ox + 100 * scale, oy + 190 * scale);
    path.lineTo(ox + 145 * scale, oy + 100 * scale);
    path.close();
  }

  void _addCupcakePath(Path path, double scale, double ox, double oy) {
    path.moveTo(ox + 60 * scale, oy + 100 * scale);
    path.lineTo(ox + 55 * scale, oy + 180 * scale);
    path.lineTo(ox + 145 * scale, oy + 180 * scale);
    path.lineTo(ox + 140 * scale, oy + 100 * scale);
    path.close();
    path.addOval(Rect.fromCenter(center: Offset(ox + 100 * scale, oy + 65 * scale), width: 80 * scale, height: 60 * scale));
  }

  void _addPizzaPath(Path path, double scale, double ox, double oy) {
    path.moveTo(ox + 100 * scale, oy + 30 * scale);
    path.lineTo(ox + 30 * scale, oy + 170 * scale);
    path.lineTo(ox + 170 * scale, oy + 170 * scale);
    path.close();
  }

  void _addWatermelonPath(Path path, double scale, double ox, double oy) {
    path.moveTo(ox + 30 * scale, oy + 120 * scale);
    path.quadraticBezierTo(ox + 100 * scale, oy + 20 * scale, ox + 170 * scale, oy + 120 * scale);
    path.close();
  }

  void _addDefaultPath(Path path, double scale, double ox, double oy) {
    path.addOval(Rect.fromCenter(
      center: Offset(ox + 100 * scale, oy + 100 * scale),
      width: 140 * scale,
      height: 140 * scale,
    ));
  }

  @override
  bool shouldRepaint(covariant MaskPainter oldDelegate) {
    return false;
  }
}

class DrowingScreen extends StatefulWidget {
  const DrowingScreen({super.key});

  @override
  State<DrowingScreen> createState() => _DrowingScreenState();
}

class _DrowingScreenState extends State<DrowingScreen> with TickerProviderStateMixin {
  // Home screen style animations
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;

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

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  List<Widget> _buildFloatingBubbles() {
    return List.generate(6, (index) {
      final random = math.Random(index);
      final size = 30.0 + random.nextDouble() * 50;
      final left = random.nextDouble() * MediaQuery.of(context).size.width;
      final startTop = random.nextDouble() * MediaQuery.of(context).size.height;

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + index * 0.15) % 1.0;
          final top = startTop - (progress * MediaQuery.of(context).size.height * 0.5);
          final opacity = (1 - progress).clamp(0.0, 0.15);

          return Positioned(
            left: left,
            top: top,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: opacity),
              ),
            ),
          );
        },
      );
    });
  }

  // 40+ Coloring pages list - SVG outline images for coloring
  final List<Map<String, dynamic>> images = const [
    // Animals (15)
    {"name": "Elephant", "path": "assets/coloring/elephant.svg", "emoji": "🐘"},
    {"name": "Butterfly", "path": "assets/coloring/butterfly.svg", "emoji": "🦋"},
    {"name": "Fish", "path": "assets/coloring/fish.svg", "emoji": "🐟"},
    {"name": "Cat", "path": "assets/coloring/cat.svg", "emoji": "🐱"},
    {"name": "Dog", "path": "assets/coloring/dog.svg", "emoji": "🐕"},
    {"name": "Bird", "path": "assets/coloring/bird.svg", "emoji": "🐦"},
    {"name": "Lion", "path": "assets/coloring/lion.svg", "emoji": "🦁"},
    {"name": "Rabbit", "path": "assets/coloring/rabbit.svg", "emoji": "🐰"},
    {"name": "Bear", "path": "assets/coloring/bear.svg", "emoji": "🐻"},
    {"name": "Turtle", "path": "assets/coloring/turtle.svg", "emoji": "🐢"},
    {"name": "Frog", "path": "assets/coloring/frog.svg", "emoji": "🐸"},
    {"name": "Owl", "path": "assets/coloring/owl.svg", "emoji": "🦉"},
    {"name": "Penguin", "path": "assets/coloring/penguin.svg", "emoji": "🐧"},
    {"name": "Dolphin", "path": "assets/coloring/dolphin.svg", "emoji": "🐬"},
    {"name": "Unicorn", "path": "assets/coloring/unicorn.svg", "emoji": "🦄"},
    // Nature (10)
    {"name": "Flower", "path": "assets/coloring/flower.svg", "emoji": "🌸"},
    {"name": "Tree", "path": "assets/coloring/tree.svg", "emoji": "🌳"},
    {"name": "Sun", "path": "assets/coloring/sun.svg", "emoji": "☀️"},
    {"name": "Moon", "path": "assets/coloring/moon.svg", "emoji": "🌙"},
    {"name": "Rainbow", "path": "assets/coloring/rainbow.svg", "emoji": "🌈"},
    {"name": "Cloud", "path": "assets/coloring/cloud.svg", "emoji": "☁️"},
    {"name": "Mountain", "path": "assets/coloring/mountain.svg", "emoji": "⛰️"},
    {"name": "Mushroom", "path": "assets/coloring/mushroom.svg", "emoji": "🍄"},
    {"name": "Leaf", "path": "assets/coloring/leaf.svg", "emoji": "🍃"},
    {"name": "Cactus", "path": "assets/coloring/cactus.svg", "emoji": "🌵"},
    // Shapes & Objects (10)
    {"name": "Star", "path": "assets/coloring/star.svg", "emoji": "⭐"},
    {"name": "Heart", "path": "assets/coloring/heart.svg", "emoji": "❤️"},
    {"name": "House", "path": "assets/coloring/house.svg", "emoji": "🏠"},
    {"name": "Car", "path": "assets/coloring/car.svg", "emoji": "🚗"},
    {"name": "Rocket", "path": "assets/coloring/rocket.svg", "emoji": "🚀"},
    {"name": "Airplane", "path": "assets/coloring/airplane.svg", "emoji": "✈️"},
    {"name": "Boat", "path": "assets/coloring/boat.svg", "emoji": "⛵"},
    {"name": "Balloon", "path": "assets/coloring/balloon.svg", "emoji": "🎈"},
    {"name": "Gift", "path": "assets/coloring/gift.svg", "emoji": "🎁"},
    {"name": "Crown", "path": "assets/coloring/crown.svg", "emoji": "👑"},
    // Food (5)
    {"name": "Apple", "path": "assets/coloring/apple.svg", "emoji": "🍎"},
    {"name": "Ice Cream", "path": "assets/coloring/icecream.svg", "emoji": "🍦"},
    {"name": "Cupcake", "path": "assets/coloring/cupcake.svg", "emoji": "🧁"},
    {"name": "Pizza", "path": "assets/coloring/pizza.svg", "emoji": "🍕"},
    {"name": "Watermelon", "path": "assets/coloring/watermelon.svg", "emoji": "��"},
  ];

  final List<List<Color>> cardGradients = const [
    [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
    [Color(0xFF4ECDC4), Color(0xFF7EDDD6)],
    [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
    [Color(0xFF56D97F), Color(0xFF81E89E)],
    [Color(0xFF45B7D1), Color(0xFF74C9DB)],
    [Color(0xFFFF6EB4), Color(0xFFFF9ECE)],
    [Color(0xFF5C6BC0), Color(0xFF8E99D4)],
    [Color(0xFFEC407A), Color(0xFFF06292)],
    [Color(0xFFFFE66D), Color(0xFFFFF59D)],
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GradientScaffold(
      title: 'Choose Picture',
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
          onPressed: () async {
            await ProgressService.to.resetProgress(ProgressService.kColoring);
            setState(() {});
          },
        ),
      ],
      body: Stack(
        children: [
          // Floating bubbles background
          ..._buildFloatingBubbles(),
          // Main content
          Column(
            children: [
              // Progress bar
              Obx(() {
                final progress =
                    ProgressService.to.getProgressPercentage(
                      ProgressService.kColoring,
                    ) /
                    100;
                final progressString = ProgressService.to.getProgressString(
                  ProgressService.kColoring,
                );
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
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
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: SizeConfig.getProportionateScreenWidth(10),
                    mainAxisSpacing: SizeConfig.getProportionateScreenHeight(10),
                    childAspectRatio: 0.85,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final image = images[index];
                    final gradient = cardGradients[index % cardGradients.length];
                    return AnimatedBuilder(
                      animation: _floatAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, index.isEven ? _floatAnimation.value : -_floatAnimation.value),
                          child: child,
                        );
                      },
                      child: GestureDetector(
                        onTap: () => Get.to(() => ImageDrowingScreen(imagePath: image["path"]!)),
                        child: Container(
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
                          child: Stack(
                            children: [
                              Positioned(
                                top: -10,
                                right: -10,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -15,
                                left: -15,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.3),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            image['emoji'] ?? "🎨",
                                            style: const TextStyle(fontSize: 28),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        image["name"]!,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1.1,
                                          shadows: [
                                            Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
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
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
