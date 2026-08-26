import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class TeacherModePage extends StatefulWidget {
  const TeacherModePage({super.key});

  @override
  State<TeacherModePage> createState() => _TeacherModePageState();
}

class _TeacherModePageState extends State<TeacherModePage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> students = [
    {
      'name': 'Aarav',
      'age': 5,
      'progress': 85,
      'emoji': '👦',
      'lastActive': 'Today',
    },
    {
      'name': 'Ananya',
      'age': 6,
      'progress': 92,
      'emoji': '👧',
      'lastActive': 'Today',
    },
    {
      'name': 'Vihaan',
      'age': 5,
      'progress': 78,
      'emoji': '👦',
      'lastActive': 'Yesterday',
    },
    {
      'name': 'Diya',
      'age': 6,
      'progress': 88,
      'emoji': '👧',
      'lastActive': 'Today',
    },
    {
      'name': 'Arjun',
      'age': 5,
      'progress': 65,
      'emoji': '👦',
      'lastActive': '2 days ago',
    },
    {
      'name': 'Ishita',
      'age': 6,
      'progress': 95,
      'emoji': '👧',
      'lastActive': 'Today',
    },
  ];

  final List<Map<String, dynamic>> assignments = [
    {
      'title': 'Numbers 1-20',
      'emoji': '🔢',
      'dueDate': 'Tomorrow',
      'assigned': 6,
      'completed': 4,
      'status': 'Active',
      'color': Color(0xFF4ECDC4),
    },
    {
      'title': 'Capital Letters A-M',
      'emoji': '🔤',
      'dueDate': 'In 3 days',
      'assigned': 6,
      'completed': 2,
      'status': 'Active',
      'color': Color(0xFF667EEA),
    },
    {
      'title': 'Hindi Vowels',
      'emoji': '📚',
      'dueDate': 'Next Week',
      'assigned': 6,
      'completed': 0,
      'status': 'Upcoming',
      'color': Color(0xFFFFAA5A),
    },
    {
      'title': 'Addition Practice',
      'emoji': '➕',
      'dueDate': 'Yesterday',
      'assigned': 6,
      'completed': 6,
      'status': 'Completed',
      'color': Color(0xFF56D97F),
    },
  ];

  final List<Map<String, dynamic>> curriculum = [
    {
      'topic': 'Numbers',
      'emoji': '🔢',
      'lessons': 10,
      'completed': 7,
      'color': Color(0xFF4ECDC4),
    },
    {
      'topic': 'Alphabets',
      'emoji': '🔤',
      'lessons': 8,
      'completed': 5,
      'color': Color(0xFF667EEA),
    },
    {
      'topic': 'Hindi',
      'emoji': '📚',
      'lessons': 12,
      'completed': 3,
      'color': Color(0xFFFFAA5A),
    },
    {
      'topic': 'Math',
      'emoji': '➕',
      'lessons': 15,
      'completed': 10,
      'color': Color(0xFF56D97F),
    },
    {
      'topic': 'Science',
      'emoji': '🔬',
      'lessons': 8,
      'completed': 2,
      'color': Color(0xFFA78BFA),
    },
    {
      'topic': 'Culture',
      'emoji': '🏛️',
      'lessons': 6,
      'completed': 1,
      'color': Color(0xFFFF6B6B),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10.r,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: Text(
          "Teacher Mode",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3.r,
          isScrollable: true,
          labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
          tabs: [
            Tab(
              text: "Dashboard",
              icon: Icon(Icons.dashboard, size: 18.r),
            ),
            Tab(
              text: "Students",
              icon: Icon(Icons.people, size: 18.r),
            ),
            Tab(
              text: "Assignments",
              icon: Icon(Icons.assignment, size: 18.r),
            ),
            Tab(
              text: "Curriculum",
              icon: Icon(Icons.menu_book, size: 18.r),
            ),
          ],
        ),
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
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildDashboardTab(),
            _buildStudentsTab(),
            _buildAssignmentsTab(),
            _buildCurriculumTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    final totalStudents = students.length;
    final avgProgress =
        students.map((s) => s['progress'] as int).reduce((a, b) => a + b) ~/
        totalStudents;
    final activeToday = students
        .where((s) => s['lastActive'] == 'Today')
        .length;
    final pendingAssignments = assignments
        .where((a) => a['status'] == 'Active')
        .length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          const Text("📊", style: TextStyle(fontSize: 50)),
          SizedBox(height: 8.h),
          const Text(
            "Class Overview",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),

          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  "👨‍👩‍👧‍👦",
                  "Students",
                  totalStudents.toString(),
                  Color(0xFF4ECDC4),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  "📈",
                  "Avg Progress",
                  "$avgProgress%",
                  Color(0xFF56D97F),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  "✅",
                  "Active Today",
                  activeToday.toString(),
                  Color(0xFF667EEA),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  "📋",
                  "Pending Tasks",
                  pendingAssignments.toString(),
                  Color(0xFFFFAA5A),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Top Performers
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "🏆",
                        style: TextStyle(fontSize: 24),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        "Top Performers",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                ...students
                    .where((s) => (s['progress'] as int) >= 85)
                    .map(
                      (s) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          children: [
                            Text(
                              s['emoji'],
                              style: const TextStyle(fontSize: 30),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Age ${s['age']}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF56D97F).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                "${s['progress']}%",
                                style: const TextStyle(
                                  color: Color(0xFF56D97F),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Needs Attention
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "⚠️",
                        style: TextStyle(fontSize: 24),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        "Needs Attention",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                ...students
                    .where((s) => (s['progress'] as int) < 75)
                    .map(
                      (s) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          children: [
                            Text(
                              s['emoji'],
                              style: const TextStyle(fontSize: 30),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Last active: ${s['lastActive']}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFFF6B6B).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                "${s['progress']}%",
                                style: const TextStyle(
                                  color: Color(0xFFFF6B6B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String emoji, String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 30)),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: students.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("👨‍👩‍👧‍👦", style: TextStyle(fontSize: 50)),
              SizedBox(height: 8.h),
              const Text(
                "My Students",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "${students.length} students enrolled",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          );
        }

        if (index == students.length + 1) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: ElevatedButton.icon(
              onPressed: () => _showAddStudentDialog(),
              icon: const Icon(Icons.add),
              label: const Text("Add New Student"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF667EEA),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          );
        }

        final student = students[index - 1];
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16.r),
            leading: Container(
              width: 55.w,
              height: 55.h,
              decoration: BoxDecoration(
                color: _getProgressColor(
                  student['progress'],
                ).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: Text(
                  student['emoji'],
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            title: Text(
              student['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Age ${student['age']} • ${student['lastActive']}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                SizedBox(height: 8.h),
                LinearProgressIndicator(
                  value: student['progress'] / 100,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(
                    _getProgressColor(student['progress']),
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: _getProgressColor(
                  student['progress'],
                ).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                "${student['progress']}%",
                style: TextStyle(
                  color: _getProgressColor(student['progress']),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () => _showStudentDetails(student),
          ),
        );
      },
    );
  }

  Color _getProgressColor(int progress) {
    if (progress >= 85) return Color(0xFF56D97F);
    if (progress >= 70) return Color(0xFF4ECDC4);
    if (progress >= 50) return Color(0xFFFFAA5A);
    return Color(0xFFFF6B6B);
  }

  Widget _buildAssignmentsTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: assignments.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("📋", style: TextStyle(fontSize: 50)),
              SizedBox(height: 8.h),
              const Text(
                "Assignments",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Track and manage class assignments",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          );
        }

        if (index == assignments.length + 1) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: ElevatedButton.icon(
              onPressed: () => _showCreateAssignmentDialog(),
              icon: const Icon(Icons.add),
              label: const Text("Create New Assignment"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF667EEA),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          );
        }

        final assignment = assignments[index - 1];
        final completionRate =
            (assignment['completed'] / assignment['assigned'] * 100).toInt();

        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      assignment['color'],
                      assignment['color'].withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      assignment['emoji'],
                      style: const TextStyle(fontSize: 30),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Due: ${assignment['dueDate']}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        assignment['status'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Completion: ${assignment['completed']}/${assignment['assigned']}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        Text(
                          "$completionRate%",
                          style: TextStyle(
                            color: assignment['color'],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    LinearProgressIndicator(
                      value: completionRate / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(assignment['color']),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurriculumTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: curriculum.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("📚", style: TextStyle(fontSize: 50)),
              SizedBox(height: 8.h),
              const Text(
                "Curriculum",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Track lesson progress across topics",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          );
        }

        final topic = curriculum[index - 1];
        final progress = (topic['completed'] / topic['lessons'] * 100).toInt();

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
                width: 55.w,
                height: 55.h,
                decoration: BoxDecoration(
                  color: topic['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Text(
                    topic['emoji'],
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic['topic'],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: topic['color'],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "${topic['completed']}/${topic['lessons']} lessons completed",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(topic['color']),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "$progress%",
                style: TextStyle(
                  color: topic['color'],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddStudentDialog() {
    Get.snackbar(
      "Add Student",
      "Coming soon! You'll be able to add students via code or email.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Color(0xFF667EEA),
      margin: EdgeInsets.all(16.r),
      borderRadius: 12.r,
    );
  }

  void _showCreateAssignmentDialog() {
    Get.snackbar(
      "Create Assignment",
      "Coming soon! Create custom assignments for your class.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Color(0xFF667EEA),
      margin: EdgeInsets.all(16.r),
      borderRadius: 12.r,
    );
  }

  void _showStudentDetails(Map<String, dynamic> student) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(student['emoji'], style: const TextStyle(fontSize: 60)),
            SizedBox(height: 12.h),
            Text(
              student['name'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Age ${student['age']} • Last active: ${student['lastActive']}",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: _getProgressColor(
                  student['progress'],
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  const Text(
                    "📊 Overall Progress",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "${student['progress']}%",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: _getProgressColor(student['progress']),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  LinearProgressIndicator(
                    value: student['progress'] / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(
                      _getProgressColor(student['progress']),
                    ),
                    minHeight: 8.h,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.message),
                    label: const Text("Message Parent"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF667EEA),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.bar_chart),
                    label: const Text("Full Report"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF56D97F),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
