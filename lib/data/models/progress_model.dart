/// Learning progress model
class ProgressModel {
  final String category;
  final int completed;
  final int total;
  final double accuracy;
  final int streak;
  final DateTime? lastPracticed;

  const ProgressModel({
    required this.category,
    this.completed = 0,
    required this.total,
    this.accuracy = 0.0,
    this.streak = 0,
    this.lastPracticed,
  });

  double get percentage => total > 0 ? (completed / total) * 100 : 0;

  bool get isCompleted => completed >= total;

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      category: json['category'] ?? '',
      completed: json['completed'] ?? 0,
      total: json['total'] ?? 0,
      accuracy: (json['accuracy'] ?? 0).toDouble(),
      streak: json['streak'] ?? 0,
      lastPracticed: json['lastPracticed'] != null
          ? DateTime.parse(json['lastPracticed'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'completed': completed,
      'total': total,
      'accuracy': accuracy,
      'streak': streak,
      'lastPracticed': lastPracticed?.toIso8601String(),
    };
  }

  ProgressModel copyWith({
    String? category,
    int? completed,
    int? total,
    double? accuracy,
    int? streak,
    DateTime? lastPracticed,
  }) {
    return ProgressModel(
      category: category ?? this.category,
      completed: completed ?? this.completed,
      total: total ?? this.total,
      accuracy: accuracy ?? this.accuracy,
      streak: streak ?? this.streak,
      lastPracticed: lastPracticed ?? this.lastPracticed,
    );
  }
}

/// Quiz result model
class QuizResultModel {
  final String quizId;
  final String category;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final Duration timeTaken;
  final DateTime completedAt;

  const QuizResultModel({
    required this.quizId,
    required this.category,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.timeTaken,
    required this.completedAt,
  });

  double get percentage => totalQuestions > 0
      ? (correctAnswers / totalQuestions) * 100
      : 0;

  bool get isPerfect => correctAnswers == totalQuestions;

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      quizId: json['quizId'] ?? '',
      category: json['category'] ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      wrongAnswers: json['wrongAnswers'] ?? 0,
      timeTaken: Duration(seconds: json['timeTakenSeconds'] ?? 0),
      completedAt: DateTime.parse(json['completedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'category': category,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'timeTakenSeconds': timeTaken.inSeconds,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}

/// Daily goal model
class DailyGoalModel {
  final String id;
  final String title;
  final String icon;
  final int target;
  final int current;
  final int rewardStars;
  final int rewardXp;

  const DailyGoalModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.target,
    this.current = 0,
    this.rewardStars = 5,
    this.rewardXp = 10,
  });

  bool get isCompleted => current >= target;
  double get progress => target > 0 ? (current / target).clamp(0.0, 1.0) : 0;

  factory DailyGoalModel.fromJson(Map<String, dynamic> json) {
    return DailyGoalModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      icon: json['icon'] ?? '⭐',
      target: json['target'] ?? 1,
      current: json['current'] ?? 0,
      rewardStars: json['rewardStars'] ?? 5,
      rewardXp: json['rewardXp'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'target': target,
      'current': current,
      'rewardStars': rewardStars,
      'rewardXp': rewardXp,
    };
  }
}
