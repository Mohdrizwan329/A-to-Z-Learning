import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherModePage extends StatefulWidget {
  const TeacherModePage({super.key});

  @override
  State<TeacherModePage> createState() => _TeacherModePageState();
}

class _TeacherModePageState extends State<TeacherModePage> with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> students = [
    {'name': 'Aarav', 'age': 5, 'progress': 85, 'emoji': '👦', 'lastActive': 'Today'},
    {'name': 'Ananya', 'age': 6, 'progress': 92, 'emoji': '👧', 'lastActive': 'Today'},
    {'name': 'Vihaan', 'age': 5, 'progress': 78, 'emoji': '👦', 'lastActive': 'Yesterday'},
    {'name': 'Diya', 'age': 6, 'progress': 88, 'emoji': '👧', 'lastActive': 'Today'},
    {'name': 'Arjun', 'age': 5, 'progress': 65, 'emoji': '👦', 'lastActive': '2 days ago'},
    {'name': 'Ishita', 'age': 6, 'progress': 95, 'emoji': '👧', 'lastActive': 'Today'},
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
    {'topic': 'Numbers', 'emoji': '🔢', 'lessons': 10, 'completed': 7, 'color': Color(0xFF4ECDC4)},
    {'topic': 'Alphabets', 'emoji': '🔤', 'lessons': 8, 'completed': 5, 'color': Color(0xFF667EEA)},
    {'topic': 'Hindi', 'emoji': '📚', 'lessons': 12, 'completed': 3, 'color': Color(0xFFFFAA5A)},
    {'topic': 'Math', 'emoji': '➕', 'lessons': 15, 'completed': 10, 'color': Color(0xFF56D97F)},
    {'topic': 'Science', 'emoji': '🔬', 'lessons': 8, 'completed': 2, 'color': Color(0xFFA78BFA)},
    {'topic': 'Culture', 'emoji': '🏛️', 'lessons': 6, 'completed': 1, 'color': Color(0xFFFF6B6B)},
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text("Teacher Mode", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          isScrollable: true,
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: const [
            Tab(text: "Dashboard", icon: Icon(Icons.dashboard, size: 18)),
            Tab(text: "Students", icon: Icon(Icons.people, size: 18)),
            Tab(text: "Assignments", icon: Icon(Icons.assignment, size: 18)),
            Tab(text: "Curriculum", icon: Icon(Icons.menu_book, size: 18)),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
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
    final avgProgress = students.map((s) => s['progress'] as int).reduce((a, b) => a + b) ~/ totalStudents;
    final activeToday = students.where((s) => s['lastActive'] == 'Today').length;
    final pendingAssignments = assignments.where((a) => a['status'] == 'Active').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("📊", style: TextStyle(fontSize: 50)),
          const SizedBox(height: 8),
          const Text("Class Overview", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Quick Stats
          Row(
            children: [
              Expanded(child: _buildStatCard("👨‍👩‍👧‍👦", "Students", totalStudents.toString(), Color(0xFF4ECDC4))),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard("📈", "Avg Progress", "$avgProgress%", Color(0xFF56D97F))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard("✅", "Active Today", activeToday.toString(), Color(0xFF667EEA))),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard("📋", "Pending Tasks", pendingAssignments.toString(), Color(0xFFFFAA5A))),
            ],
          ),
          const SizedBox(height: 24),

          // Top Performers
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text("🏆", style: TextStyle(fontSize: 24)),
                    SizedBox(width: 8),
                    Text("Top Performers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                ...students
                    .where((s) => (s['progress'] as int) >= 85)
                    .map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Text(s['emoji'], style: const TextStyle(fontSize: 30)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(s['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Age ${s['age']}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFF56D97F).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text("${s['progress']}%", style: const TextStyle(color: Color(0xFF56D97F), fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Needs Attention
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text("⚠️", style: TextStyle(fontSize: 24)),
                    SizedBox(width: 8),
                    Text("Needs Attention", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                ...students
                    .where((s) => (s['progress'] as int) < 75)
                    .map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Text(s['emoji'], style: const TextStyle(fontSize: 30)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(s['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Last active: ${s['lastActive']}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF6B6B).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text("${s['progress']}%", style: const TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ))
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildStudentsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: students.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("👨‍👩‍👧‍👦", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("My Students", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("${students.length} students enrolled", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        if (index == students.length + 1) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton.icon(
              onPressed: () => _showAddStudentDialog(),
              icon: const Icon(Icons.add),
              label: const Text("Add New Student"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF667EEA),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          );
        }

        final student = students[index - 1];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: _getProgressColor(student['progress']).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: Text(student['emoji'], style: const TextStyle(fontSize: 30))),
            ),
            title: Text(student['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Age ${student['age']} • ${student['lastActive']}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: student['progress'] / 100,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(_getProgressColor(student['progress'])),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getProgressColor(student['progress']).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${student['progress']}%",
                style: TextStyle(color: _getProgressColor(student['progress']), fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.all(16),
      itemCount: assignments.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("📋", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Assignments", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Track and manage class assignments", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        if (index == assignments.length + 1) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton.icon(
              onPressed: () => _showCreateAssignmentDialog(),
              icon: const Icon(Icons.add),
              label: const Text("Create New Assignment"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF667EEA),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          );
        }

        final assignment = assignments[index - 1];
        final completionRate = (assignment['completed'] / assignment['assigned'] * 100).toInt();

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [assignment['color'], assignment['color'].withValues(alpha: 0.7)]),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Text(assignment['emoji'], style: const TextStyle(fontSize: 30)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(assignment['title'], style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                          Text("Due: ${assignment['dueDate']}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(assignment['status'], style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Completion: ${assignment['completed']}/${assignment['assigned']}", style: TextStyle(color: Colors.grey.shade700)),
                        Text("$completionRate%", style: TextStyle(color: assignment['color'], fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: completionRate / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(assignment['color']),
                      borderRadius: BorderRadius.circular(4),
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
      padding: const EdgeInsets.all(16),
      itemCount: curriculum.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("📚", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Curriculum", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Track lesson progress across topics", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final topic = curriculum[index - 1];
        final progress = (topic['completed'] / topic['lessons'] * 100).toInt();

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: topic['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(child: Text(topic['emoji'], style: const TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topic['topic'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: topic['color'])),
                    const SizedBox(height: 4),
                    Text("${topic['completed']}/${topic['lessons']} lessons completed", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(topic['color']),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text("$progress%", style: TextStyle(color: topic['color'], fontWeight: FontWeight.bold, fontSize: 16)),
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
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _showCreateAssignmentDialog() {
    Get.snackbar(
      "Create Assignment",
      "Coming soon! Create custom assignments for your class.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Color(0xFF667EEA),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _showStudentDetails(Map<String, dynamic> student) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 20),
            Text(student['emoji'], style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 12),
            Text(student['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Age ${student['age']} • Last active: ${student['lastActive']}", style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getProgressColor(student['progress']).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text("📊 Overall Progress", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text("${student['progress']}%", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: _getProgressColor(student['progress']))),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: student['progress'] / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(_getProgressColor(student['progress'])),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.bar_chart),
                    label: const Text("Full Report"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF56D97F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
