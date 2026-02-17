/// User model for the app
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final int age;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final bool isPremium;
  final String? parentEmail;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.age = 5,
    this.createdAt,
    this.lastLoginAt,
    this.isPremium = false,
    this.parentEmail,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      age: json['age'] ?? 5,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
      isPremium: json['isPremium'] ?? false,
      parentEmail: json['parentEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'age': age,
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isPremium': isPremium,
      'parentEmail': parentEmail,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    int? age,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isPremium,
    String? parentEmail,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isPremium: isPremium ?? this.isPremium,
      parentEmail: parentEmail ?? this.parentEmail,
    );
  }
}

/// Child profile model for multi-child support
class ChildProfileModel {
  final String id;
  final String name;
  final String avatar;
  final int age;
  final String? gradeLevel;
  final Map<String, dynamic>? progress;
  final DateTime? createdAt;

  const ChildProfileModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.age,
    this.gradeLevel,
    this.progress,
    this.createdAt,
  });

  factory ChildProfileModel.fromJson(Map<String, dynamic> json) {
    return ChildProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '🧒',
      age: json['age'] ?? 5,
      gradeLevel: json['gradeLevel'],
      progress: json['progress'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'age': age,
      'gradeLevel': gradeLevel,
      'progress': progress,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
