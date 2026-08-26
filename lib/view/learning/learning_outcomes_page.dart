import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/learning_outcomes_service.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class LearningOutcomesPage extends StatefulWidget {
  const LearningOutcomesPage({super.key});

  @override
  State<LearningOutcomesPage> createState() => _LearningOutcomesPageState();
}

class _LearningOutcomesPageState extends State<LearningOutcomesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late LearningOutcomesService _service;

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'name': 'All', 'emoji': '📊'},
    {'id': 'numbers', 'name': 'Numbers', 'emoji': '🔢'},
    {'id': 'alphabet', 'name': 'Alphabet', 'emoji': '🔤'},
    {'id': 'math', 'name': 'Math', 'emoji': '➕'},
    {'id': 'hindi', 'name': 'Hindi', 'emoji': '📚'},
    {'id': 'gk', 'name': 'GK', 'emoji': '🌍'},
  ];

  @override
  void initState() {
    super.initState();
    _service = Get.put(LearningOutcomesService());
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          'Learning Outcomes',
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
              _buildOverallProgress(),
              _buildTabBar(),
              Expanded(child: _buildTabContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallProgress() {
    return Obx(() {
      final progress = _service.overallProgress;
      final completed = _service.completedOutcomesCount;
      final total = _service.outcomes.length;
      final milestones = _service.unlockedMilestonesCount;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Equal shares so the longest label wraps in its own column.
                Expanded(
                  child: _buildStat('📊', '${progress.round()}%', 'Progress'),
                ),
                Expanded(
                  child: _buildStat('✅', '$completed/$total', 'Completed'),
                ),
                Expanded(child: _buildStat('🏆', '$milestones', 'Milestones')),
              ],
            ),
            SizedBox(height: 16.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 80
                      ? Colors.green
                      : progress >= 50
                      ? Colors.orange
                      : const Color(0xFF667EEA),
                ),
                minHeight: 10.h,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStat(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        SizedBox(height: 4.h),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        labelColor: const Color(0xFF667EEA),
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        padding: EdgeInsets.all(4.r),
        labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
        tabs: _categories.map((cat) {
          return Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                children: [
                  Text(cat['emoji']!, style: const TextStyle(fontSize: 16)),
                  SizedBox(width: 4.w),
                  Text(cat['name']!),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: _categories.map((cat) {
        return _buildOutcomesList(cat['id']!);
      }).toList(),
    );
  }

  Widget _buildOutcomesList(String categoryId) {
    return Obx(() {
      List<LearningOutcome> outcomesList;

      if (categoryId == 'all') {
        outcomesList = _service.outcomes.values.toList();
      } else {
        outcomesList = _service.getOutcomesForModule(categoryId);
      }

      if (outcomesList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('📭', style: TextStyle(fontSize: 64)),
              SizedBox(height: 16.h),
              Text(
                'No outcomes yet',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      }

      // Sort: incomplete first, then by progress
      outcomesList.sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        return b.progressPercentage.compareTo(a.progressPercentage);
      });

      return ListView.builder(
        padding: EdgeInsets.all(16.r),
        itemCount: outcomesList.length,
        itemBuilder: (context, index) {
          return _buildOutcomeCard(outcomesList[index]);
        },
      );
    });
  }

  Widget _buildOutcomeCard(LearningOutcome outcome) {
    final moduleEmoji = _getModuleEmoji(outcome.moduleId);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            TtsService.to.speak(outcome.title);
            _showOutcomeDetails(outcome);
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: outcome.isCompleted
                            ? Colors.green.shade50
                            : const Color(0xFF667EEA).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: outcome.isCompleted
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 28.r,
                              )
                            : Text(
                                moduleEmoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            outcome.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            outcome.description,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: outcome.isCompleted
                            ? Colors.green.shade100
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '${outcome.progressPercentage.round()}%',
                        style: TextStyle(
                          color: outcome.isCompleted
                              ? Colors.green
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: outcome.progressPercentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      outcome.isCompleted
                          ? Colors.green
                          : const Color(0xFF667EEA),
                    ),
                    minHeight: 6.h,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.r,
                  runSpacing: 4.r,
                  children: outcome.objectives.take(3).map((obj) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        obj,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOutcomeDetails(LearningOutcome outcome) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
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
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            width: 56.w,
                            height: 56.h,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF667EEA,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Center(
                              child: Text(
                                _getModuleEmoji(outcome.moduleId),
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
                                  outcome.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3436),
                                  ),
                                ),
                                Text(
                                  outcome.description,
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

                      SizedBox(height: 24.h),

                      // Progress
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: outcome.isCompleted
                              ? Colors.green.shade50
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Progress',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    '${outcome.currentScore}/${outcome.targetScore}',
                                    style: TextStyle(
                                      color: outcome.isCompleted
                                          ? Colors.green
                                          : const Color(0xFF667EEA),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: LinearProgressIndicator(
                                value: outcome.progressPercentage / 100,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  outcome.isCompleted
                                      ? Colors.green
                                      : const Color(0xFF667EEA),
                                ),
                                minHeight: 12.h,
                              ),
                            ),
                            if (outcome.isCompleted &&
                                outcome.completedAt != null) ...[
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20.r,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Completed on ${_formatDate(outcome.completedAt!)}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Objectives
                      const Text(
                        'Learning Objectives',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ...outcome.objectives.map((obj) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            children: [
                              Container(
                                width: 24.w,
                                height: 24.h,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF667EEA,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 14.r,
                                    color: Color(0xFF667EEA),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  obj,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF2D3436),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      SizedBox(height: 24.h),

                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigate to learning module
                            _navigateToModule(outcome.moduleId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667EEA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            outcome.isCompleted ? 'Review' : 'Start Learning',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
        return '��';
      case 'hindi':
        return '📚';
      case 'gk':
        return '🌍';
      default:
        return '📖';
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _navigateToModule(String moduleId) {
    // Navigate based on module
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
