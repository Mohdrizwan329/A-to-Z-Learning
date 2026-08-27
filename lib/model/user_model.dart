import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? childName;
  final int? childAge;
  final String? parentEmail;
  final String? parentPhone;
  final String? location;

  /// The profile picture, stored inline as base64 rather than in a bucket.
  ///
  /// A signup photo is capped at a few hundred pixels, so it lands well
  /// inside a Firestore document, and it works with nothing to set up --
  /// no storage bucket, no rules, no billing plan.
  final String? photoBase64;

  /// Set by a Google sign-in, which brings its own hosted picture.
  final String? photoUrl;

  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPremium;
  final DateTime? subscriptionExpiry;

  UserModel({
    required this.uid,
    this.childName,
    this.childAge,
    this.parentEmail,
    this.parentPhone,
    this.location,
    this.photoBase64,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isPremium = false,
    this.subscriptionExpiry,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final now = DateTime.now();
    return UserModel(
      uid: doc.id,
      childName: data['childName'],
      childAge: data['childAge'],
      parentEmail: data['parentEmail'],
      parentPhone: data['parentPhone'],
      location: data['location'],
      photoBase64: data['photoBase64'],
      photoUrl: data['photoUrl'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : now,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : now,
      isPremium: data['isPremium'] ?? false,
      subscriptionExpiry: data['subscriptionExpiry'] != null
          ? (data['subscriptionExpiry'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'childName': childName,
      'childAge': childAge,
      'parentEmail': parentEmail,
      'parentPhone': parentPhone,
      'location': location,
      'photoBase64': photoBase64,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isPremium': isPremium,
      'subscriptionExpiry': subscriptionExpiry != null
          ? Timestamp.fromDate(subscriptionExpiry!)
          : null,
    };
  }

  UserModel copyWith({
    String? uid,
    String? childName,
    int? childAge,
    String? parentEmail,
    String? parentPhone,
    String? location,
    String? photoBase64,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPremium,
    DateTime? subscriptionExpiry,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      childName: childName ?? this.childName,
      childAge: childAge ?? this.childAge,
      parentEmail: parentEmail ?? this.parentEmail,
      parentPhone: parentPhone ?? this.parentPhone,
      location: location ?? this.location,
      photoBase64: photoBase64 ?? this.photoBase64,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPremium: isPremium ?? this.isPremium,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
    );
  }
}

class ProgressModel {
  final int score;
  final int completedBatches;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime lastUpdated;

  ProgressModel({
    this.score = 0,
    this.completedBatches = 0,
    this.totalQuestions = 0,
    this.correctAnswers = 0,
    required this.lastUpdated,
  });

  factory ProgressModel.fromFirestore(Map<String, dynamic> data) {
    return ProgressModel(
      score: data['score'] ?? 0,
      completedBatches: data['completedBatches'] ?? 0,
      totalQuestions: data['totalQuestions'] ?? 0,
      correctAnswers: data['correctAnswers'] ?? 0,
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'score': score,
      'completedBatches': completedBatches,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}

class TransactionModel {
  final String transactionId;
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final String? planType;
  final String? paymentMethod;

  TransactionModel({
    required this.transactionId,
    required this.amount,
    this.currency = 'USD',
    required this.status,
    required this.createdAt,
    this.planType,
    this.paymentMethod,
  });

  factory TransactionModel.fromFirestore(Map<String, dynamic> data) {
    return TransactionModel(
      transactionId: data['transactionId'] ?? data['razorpayId'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      currency: data['currency'] ?? 'USD',
      status: data['status'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      planType: data['planType'],
      paymentMethod: data['paymentMethod'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'transactionId': transactionId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'planType': planType,
      'paymentMethod': paymentMethod,
    };
  }
}
