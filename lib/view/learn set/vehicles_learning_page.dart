import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view%20model/learn%20set%20controller/vehicles_learning_controller.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class VehiclesLearningPage extends StatefulWidget {
  const VehiclesLearningPage({super.key});

  @override
  State<VehiclesLearningPage> createState() => _VehiclesLearningPageState();
}

class _VehiclesLearningPageState extends State<VehiclesLearningPage>
    with TickerProviderStateMixin {
  final controller = Get.put(VehiclesLearningController());

  late AnimationController _floatController;
  late AnimationController _pulseController;
  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;

  final List<List<Color>> cardGradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    [Color(0xFF56D97F), Color(0xFF81E89E)],
    [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
    [Color(0xFF45B7D1), Color(0xFF74C9DB)],
    [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
    [Color(0xFFFF6EB4), Color(0xFFFF9ECE)],
    [Color(0xFFFFE66D), Color(0xFFFFF59D)],
    [Color(0xFF4ECDC4), Color(0xFF7EDDD6)],
    [Color(0xFF5C6BC0), Color(0xFF8E99D4)],
    [Color(0xFFEC407A), Color(0xFFF06292)],
  ];

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  List<Color> _getGradient(int index) {
    return cardGradients[index % cardGradients.length];
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Vehicles',
      emoji: '',
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.refresh, color: Colors.white, size: 20.r),
          ),
          onPressed: () {
            setState(() {
              controller.resetSelection();
            });
          },
        ),
      ],
      body: Column(
        children: [
          // Progress bar with percentage
          Obx(() {
            final progress = controller.progressPercentage / 100;
            final progressString = controller.progressString;
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // The reader's font size can be 30% larger than this row was drawn for.
                      Flexible(
                        child: const Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '$progressString completed',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10.h,
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
              padding: EdgeInsets.all(12.r),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.r,
                crossAxisSpacing: 16.r,
                childAspectRatio: 1.2,
              ),
              itemCount: controller.vehicles.length,
              itemBuilder: (context, index) {
                final item = controller.vehicles[index];
                final gradient = _getGradient(index);

                return Obx(() {
                  final isSelected = controller.selectedIndex.value == index;
                  final isCompleted = controller.isItemCompleted(index);

                  return AnimatedBuilder(
                    animation: _floatController,
                    builder: (_, child) {
                      final offset = (index % 2 == 0)
                          ? _floatAnimation.value
                          : -_floatAnimation.value;
                      return Transform.translate(
                        offset: Offset(0, offset),
                        child: child,
                      );
                    },
                    child: _buildCard(
                      item,
                      gradient,
                      isSelected,
                      isCompleted,
                      index,
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    Map<String, String> item,
    List<Color> gradient,
    bool isSelected,
    bool isCompleted,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        TtsService.to.speak(item['name']!);
        setState(() {
          controller.selectVehicle(index);
        });
      },
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? _pulseAnimation.value : 1.0,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSelected
                  ? [Color(0xFFFFD700), Color(0xFFFFA500)]
                  : gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: (isSelected ? Color(0xFFFFD700) : gradient[0])
                    .withValues(alpha: 0.4),
                blurRadius: isSelected ? 15 : 10,
                offset: Offset(0, 6),
                spreadRadius: isSelected ? 2 : 0,
              ),
            ],
            border: isSelected
                ? Border.all(color: Colors.white, width: 3)
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 75.w,
                        height: 75.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            item['emoji']!,
                            style: TextStyle(fontSize: 42),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Flexible(
                        child: Text(
                          item['name']!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Show checkmark if completed
              if (isCompleted)
                Positioned(
                  top: 4.h,
                  right: 4.w,
                  child: Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 12.r),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
