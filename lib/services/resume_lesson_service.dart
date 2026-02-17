import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Model for last lesson data
class LastLessonData {
  final String category;
  final String lessonId;
  final String lessonTitle;
  final String emoji;
  final int progress; // 0-100
  final DateTime accessedAt;
  final String routePath;
  final Map<String, dynamic>? extraData;

  LastLessonData({
    required this.category,
    required this.lessonId,
    required this.lessonTitle,
    required this.emoji,
    required this.progress,
    required this.accessedAt,
    required this.routePath,
    this.extraData,
  });

  factory LastLessonData.fromJson(Map<String, dynamic> json) {
    return LastLessonData(
      category: json['category'] ?? '',
      lessonId: json['lessonId'] ?? '',
      lessonTitle: json['lessonTitle'] ?? '',
      emoji: json['emoji'] ?? '📚',
      progress: json['progress'] ?? 0,
      accessedAt: DateTime.parse(json['accessedAt'] ?? DateTime.now().toIso8601String()),
      routePath: json['routePath'] ?? '',
      extraData: json['extraData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'lessonId': lessonId,
      'lessonTitle': lessonTitle,
      'emoji': emoji,
      'progress': progress,
      'accessedAt': accessedAt.toIso8601String(),
      'routePath': routePath,
      'extraData': extraData,
    };
  }
}

/// Service to track and resume last lesson
class ResumeLessonService extends GetxService {
  static ResumeLessonService get to => Get.find();

  final GetStorage _storage = GetStorage();
  static const String _lastLessonKey = 'last_lesson';
  static const String _recentLessonsKey = 'recent_lessons';
  static const int _maxRecentLessons = 5;

  final Rx<LastLessonData?> lastLesson = Rx<LastLessonData?>(null);
  final RxList<LastLessonData> recentLessons = <LastLessonData>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadLastLesson();
    _loadRecentLessons();
  }

  /// Load last lesson from storage
  void _loadLastLesson() {
    final data = _storage.read(_lastLessonKey);
    if (data != null) {
      lastLesson.value = LastLessonData.fromJson(Map<String, dynamic>.from(data));
    }
  }

  /// Load recent lessons from storage
  void _loadRecentLessons() {
    final data = _storage.read(_recentLessonsKey);
    if (data != null) {
      recentLessons.value = (data as List)
          .map((e) => LastLessonData.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  /// Save current lesson as last accessed
  Future<void> saveLastLesson({
    required String category,
    required String lessonId,
    required String lessonTitle,
    required String emoji,
    required String routePath,
    int progress = 0,
    Map<String, dynamic>? extraData,
  }) async {
    final lesson = LastLessonData(
      category: category,
      lessonId: lessonId,
      lessonTitle: lessonTitle,
      emoji: emoji,
      progress: progress,
      accessedAt: DateTime.now(),
      routePath: routePath,
      extraData: extraData,
    );

    lastLesson.value = lesson;
    await _storage.write(_lastLessonKey, lesson.toJson());

    // Add to recent lessons
    await _addToRecentLessons(lesson);
  }

  /// Update progress of current lesson
  Future<void> updateProgress(int progress) async {
    if (lastLesson.value != null) {
      final updated = LastLessonData(
        category: lastLesson.value!.category,
        lessonId: lastLesson.value!.lessonId,
        lessonTitle: lastLesson.value!.lessonTitle,
        emoji: lastLesson.value!.emoji,
        progress: progress,
        accessedAt: DateTime.now(),
        routePath: lastLesson.value!.routePath,
        extraData: lastLesson.value!.extraData,
      );
      lastLesson.value = updated;
      await _storage.write(_lastLessonKey, updated.toJson());
    }
  }

  /// Add lesson to recent lessons list
  Future<void> _addToRecentLessons(LastLessonData lesson) async {
    // Remove if already exists
    recentLessons.removeWhere((l) => l.lessonId == lesson.lessonId);

    // Add at beginning
    recentLessons.insert(0, lesson);

    // Keep only max recent lessons
    if (recentLessons.length > _maxRecentLessons) {
      recentLessons.removeRange(_maxRecentLessons, recentLessons.length);
    }

    await _storage.write(
      _recentLessonsKey,
      recentLessons.map((l) => l.toJson()).toList(),
    );
  }

  /// Check if there's a lesson to resume
  bool get hasLessonToResume => lastLesson.value != null;

  /// Get time since last lesson
  String get timeSinceLastLesson {
    if (lastLesson.value == null) return '';

    final difference = DateTime.now().difference(lastLesson.value!.accessedAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    }
  }

  /// Clear last lesson
  Future<void> clearLastLesson() async {
    lastLesson.value = null;
    await _storage.remove(_lastLessonKey);
  }

  /// Clear all recent lessons
  Future<void> clearRecentLessons() async {
    recentLessons.clear();
    await _storage.remove(_recentLessonsKey);
  }
}
