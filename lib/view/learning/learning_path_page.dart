import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/learning_outcomes_service.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class LearningPathPage extends StatefulWidget {
  const LearningPathPage({super.key});

  @override
  State<LearningPathPage> createState() => _LearningPathPageState();
}

class _LearningPathPageState extends State<LearningPathPage>
    with SingleTickerProviderStateMixin {
  late LearningOutcomesService _service;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _service = Get.put(LearningOutcomesService());
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
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
        title: Text(
          'Learning Path',
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNextRecommended(),
                      SizedBox(height: 24.h),
                      _buildLearningPath(),
                      SizedBox(height: 24.h),
                      _buildMilestones(),
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

  Widget _buildNextRecommended() {
    return Obx(() {
      final next = _service.nextRecommendedOutcome;
      if (next == null) {
        return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              Text('🎉', style: TextStyle(fontSize: 48)),
              SizedBox(height: 12.h),
              Text(
                'Amazing! All caught up!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'You\'ve completed all learning outcomes',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: _animController, curve: Curves.easeOut),
            ),
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20.r,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Text('⭐', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 4.w),
                        Text(
                          'Recommended Next',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Container(
                    width: 64.w,
                    height: 64.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Text(
                        _getModuleEmoji(next.moduleId),
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          next.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          next.description,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Progress',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${next.progressPercentage.round()}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF667EEA),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: LinearProgressIndicator(
                            value: next.progressPercentage / 100,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF667EEA),
                            ),
                            minHeight: 8.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  ElevatedButton(
                    onPressed: () {
                      TtsService.to.speak(next.title);
                      _navigateToModule(next.moduleId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF11998E),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Start',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18.r,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLearningPath() {
    return Obx(() {
      final path = _service.recommendedPath;

      return Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('📍', style: TextStyle(fontSize: 24)),
                SizedBox(width: 8.w),
                Text(
                  'Your Path',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (path.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Text('Complete all outcomes to finish your path!'),
                ),
              )
            else
              ...List.generate(path.length, (index) {
                final outcomeId = path[index];
                final outcome = _service.outcomes[outcomeId];
                if (outcome == null) return const SizedBox.shrink();

                final isFirst = index == 0;
                final isLast = index == path.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Path line
                    Column(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: isFirst
                                ? const Color(0xFF11998E)
                                : (outcome.isCompleted
                                      ? Colors.green
                                      : Colors.grey.shade300),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: isFirst
                                ? Icon(
                                    Icons.flag,
                                    color: Colors.white,
                                    size: 16.r,
                                  )
                                : (outcome.isCompleted
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16.r,
                                        )
                                      : Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2.w,
                            height: 40.h,
                            color: outcome.isCompleted
                                ? Colors.green
                                : Colors.grey.shade300,
                          ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    // Content
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: isFirst
                              ? const Color(0xFF11998E).withValues(alpha: 0.1)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                          border: isFirst
                              ? Border.all(
                                  color: const Color(0xFF11998E),
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Row(
                          children: [
                            Text(
                              _getModuleEmoji(outcome.moduleId),
                              style: const TextStyle(fontSize: 24),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    outcome.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: outcome.isCompleted
                                          ? Colors.green
                                          : const Color(0xFF2D3436),
                                    ),
                                  ),
                                  Text(
                                    '${outcome.progressPercentage.round()}% complete',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (outcome.isCompleted)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            else if (isFirst)
                              const Icon(
                                Icons.play_circle_fill,
                                color: Color(0xFF11998E),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
          ],
        ),
      );
    });
  }

  Widget _buildMilestones() {
    return Obx(() {
      final allMilestones = _service.milestones.values.toList();
      allMilestones.sort((a, b) {
        if (a.isUnlocked != b.isUnlocked) {
          return a.isUnlocked ? -1 : 1;
        }
        return b.progressPercentage.compareTo(a.progressPercentage);
      });

      return Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          '🏆',
                          style: TextStyle(fontSize: 24),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          'Milestones',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3436),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '${_service.unlockedMilestonesCount}/${allMilestones.length}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ...allMilestones
                .take(5)
                .map((milestone) => _buildMilestoneItem(milestone)),
            if (allMilestones.length > 5)
              TextButton(
                onPressed: () => _showAllMilestones(allMilestones),
                child: Text(
                  'View all ${allMilestones.length} milestones',
                  style: const TextStyle(color: Color(0xFF11998E)),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildMilestoneItem(LearningMilestone milestone) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: milestone.isUnlocked
            ? Colors.amber.shade50
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: milestone.isUnlocked
            ? Border.all(color: Colors.amber, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: milestone.isUnlocked
                  ? Colors.amber.shade200
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                milestone.emoji,
                style: TextStyle(
                  fontSize: 24,
                  color: milestone.isUnlocked ? null : Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        milestone.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: milestone.isUnlocked
                              ? Colors.amber.shade800
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                    if (milestone.isUnlocked)
                      Icon(Icons.verified, color: Colors.amber, size: 20.r),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  milestone.description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: milestone.progressPercentage / 100,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            milestone.isUnlocked ? Colors.amber : Colors.grey,
                          ),
                          minHeight: 4.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${milestone.currentOutcomes}/${milestone.requiredOutcomes}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAllMilestones(List<LearningMilestone> allMilestones) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Text(
                  '🏆 All Milestones',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: allMilestones.length,
                  itemBuilder: (context, index) {
                    return _buildMilestoneItem(allMilestones[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getModuleEmoji(String moduleId) {
    switch (moduleId) {
      case 'numbers':
        return '🔢';
      case 'alphabet':
        return '🔤';
      case 'math':
        return '➕';
      case 'colors':
        return '🌈';
      case 'shapes':
        return '🔷';
      case 'hindi':
        return '📚';
      case 'gk':
        return '🌍';
      default:
        return '📖';
    }
  }

  void _navigateToModule(String moduleId) {
    switch (moduleId) {
      case 'numbers':
        Get.toNamed('/numbers');
        break;
      case 'alphabet':
        Get.toNamed('/alphabets');
        break;
      case 'math':
        Get.toNamed('/math-problems');
        break;
      case 'hindi':
        Get.toNamed('/hindi-letters');
        break;
      default:
        Get.toNamed('/home');
    }
  }
}
