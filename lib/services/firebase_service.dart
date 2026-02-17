import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:jiyan_learning/model/user_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Lazy initialization to avoid accessing Firebase on web before it's configured
  FirebaseAuth get _auth {
    if (kIsWeb) {
      throw UnsupportedError('Firebase is not configured for web platform');
    }
    return FirebaseAuth.instance;
  }

  FirebaseFirestore get _firestore {
    if (kIsWeb) {
      throw UnsupportedError('Firebase is not configured for web platform');
    }
    return FirebaseFirestore.instance;
  }

  // Check if Firebase is available
  static bool get isAvailable => !kIsWeb;

  // Auth getters
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Collection references
  CollectionReference get usersCollection => _firestore.collection('users');

  DocumentReference userDoc(String uid) => usersCollection.doc(uid);

  CollectionReference progressCollection(String uid) =>
      userDoc(uid).collection('progress');

  CollectionReference transactionsCollection(String uid) =>
      userDoc(uid).collection('transactions');

  // ==================== AUTH METHODS ====================

  /// Sign up with email and password
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    String? childName,
    int? childAge,
    String? phoneNumber,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Create user document in Firestore
    if (credential.user != null) {
      await createUserDocument(
        uid: credential.user!.uid,
        email: email,
        childName: childName,
        childAge: childAge,
        phoneNumber: phoneNumber,
      );
    }

    return credential;
  }

  /// Get email by phone number from Firestore
  Future<String?> getEmailByPhone(String phoneNumber) async {
    final snapshot = await usersCollection
        .where('parentPhone', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.get('parentEmail') as String?;
    }
    return null;
  }

  /// Sign in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Phone verification ID storage
  String? _verificationId;
  int? _resendToken;

  String? get verificationId => _verificationId;

  /// Send OTP to phone number
  Future<void> sendOtp({
    required String phoneNumber,
    required String countryCode,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
    required Function(PhoneAuthCredential credential) onAutoVerify,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+$countryCode$phoneNumber',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verification (Android only)
        onAutoVerify(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(_getPhoneAuthError(e.code));
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
      forceResendingToken: _resendToken,
    );
  }

  /// Verify OTP and sign in
  Future<UserCredential> verifyOtpAndSignIn(String otp) async {
    if (_verificationId == null) {
      throw Exception('Verification ID not found. Please request OTP again.');
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    return await _auth.signInWithCredential(credential);
  }

  /// Link phone credential to existing account or sign in
  Future<UserCredential> signInWithPhoneCredential(PhoneAuthCredential credential) async {
    return await _auth.signInWithCredential(credential);
  }

  /// Check if phone number exists in Firestore
  Future<bool> phoneNumberExists(String phoneNumber) async {
    final snapshot = await usersCollection
        .where('parentPhone', isEqualTo: phoneNumber)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  /// Get user data by phone number
  Future<Map<String, dynamic>?> getUserByPhone(String phoneNumber) async {
    final snapshot = await usersCollection
        .where('parentPhone', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data() as Map<String, dynamic>?;
    }
    return null;
  }

  String _getPhoneAuthError(String code) {
    switch (code) {
      case 'invalid-phone-number':
        return 'Invalid phone number format.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';
      case 'invalid-verification-code':
        return 'Invalid OTP. Please enter correct code.';
      case 'session-expired':
        return 'OTP expired. Please request a new one.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'user-not-found', message: 'No user logged in');
    }

    final email = user.email;
    if (email == null) {
      throw FirebaseAuthException(code: 'no-email', message: 'User has no email');
    }

    // Re-authenticate user with current password
    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);

    // Update to new password
    await user.updatePassword(newPassword);
  }

  /// Delete account
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Delete user data from Firestore
      await deleteUserData(user.uid);
      // Delete auth account
      await user.delete();
    }
  }

  // ==================== FIRESTORE METHODS ====================

  /// Create user document
  Future<void> createUserDocument({
    required String uid,
    required String email,
    String? childName,
    int? childAge,
    String? phoneNumber,
  }) async {
    final now = DateTime.now();
    final user = UserModel(
      uid: uid,
      childName: childName,
      childAge: childAge,
      parentEmail: email,
      parentPhone: phoneNumber,
      createdAt: now,
      updatedAt: now,
    );

    await userDoc(uid).set(user.toFirestore());
  }

  /// Get user data
  Future<UserModel?> getUserData(String uid) async {
    final doc = await userDoc(uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? childName,
    int? childAge,
    String? parentEmail,
    String? parentPhone,
    String? location,
  }) async {
    // Check if document exists first
    final docSnapshot = await userDoc(uid).get();
    final now = Timestamp.now();

    final updates = <String, dynamic>{
      'updatedAt': now,
    };

    // Add createdAt only if document doesn't exist
    if (!docSnapshot.exists) {
      updates['createdAt'] = now;
    }

    if (childName != null) updates['childName'] = childName;
    if (childAge != null) updates['childAge'] = childAge;
    if (parentEmail != null) updates['parentEmail'] = parentEmail;
    if (parentPhone != null) updates['parentPhone'] = parentPhone;
    if (location != null) updates['location'] = location;

    // Use set with merge to create document if it doesn't exist
    await userDoc(uid).set(updates, SetOptions(merge: true));
  }

  /// Delete user data
  Future<void> deleteUserData(String uid) async {
    // Delete subcollections first
    final progressDocs = await progressCollection(uid).get();
    for (var doc in progressDocs.docs) {
      await doc.reference.delete();
    }

    final transactionDocs = await transactionsCollection(uid).get();
    for (var doc in transactionDocs.docs) {
      await doc.reference.delete();
    }

    // Delete user document
    await userDoc(uid).delete();
  }

  // ==================== PROGRESS METHODS ====================

  /// Save progress for a specific category
  Future<void> saveProgress({
    required String uid,
    required String category, // e.g., 'math_addition', 'numbers', 'alphabets'
    required ProgressModel progress,
  }) async {
    await progressCollection(uid).doc(category).set(progress.toFirestore());
  }

  /// Get progress for a specific category
  Future<ProgressModel?> getProgress({
    required String uid,
    required String category,
  }) async {
    final doc = await progressCollection(uid).doc(category).get();
    if (doc.exists) {
      return ProgressModel.fromFirestore(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Get all progress
  Future<Map<String, ProgressModel>> getAllProgress(String uid) async {
    final snapshot = await progressCollection(uid).get();
    final progressMap = <String, ProgressModel>{};

    for (var doc in snapshot.docs) {
      progressMap[doc.id] = ProgressModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
      );
    }

    return progressMap;
  }

  /// Update specific progress fields
  Future<void> updateProgress({
    required String uid,
    required String category,
    int? score,
    int? completedBatches,
    int? totalQuestions,
    int? correctAnswers,
  }) async {
    final updates = <String, dynamic>{
      'lastUpdated': Timestamp.now(),
    };

    if (score != null) updates['score'] = score;
    if (completedBatches != null) updates['completedBatches'] = completedBatches;
    if (totalQuestions != null) updates['totalQuestions'] = totalQuestions;
    if (correctAnswers != null) updates['correctAnswers'] = correctAnswers;

    await progressCollection(uid).doc(category).set(
      updates,
      SetOptions(merge: true),
    );
  }

  // ==================== TRANSACTION METHODS ====================

  /// Save transaction
  Future<void> saveTransaction({
    required String uid,
    required TransactionModel transaction,
  }) async {
    await transactionsCollection(uid).add(transaction.toFirestore());
  }

  /// Get all transactions
  Future<List<TransactionModel>> getTransactions(String uid) async {
    final snapshot = await transactionsCollection(uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return TransactionModel.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // ==================== SUBSCRIPTION METHODS ====================

  /// Update subscription status
  Future<void> updateSubscription({
    required String uid,
    required bool isPremium,
    DateTime? expiryDate,
  }) async {
    await userDoc(uid).update({
      'isPremium': isPremium,
      'subscriptionExpiry': expiryDate != null
          ? Timestamp.fromDate(expiryDate)
          : null,
      'updatedAt': Timestamp.now(),
    });
  }

  /// Check if subscription is active
  Future<bool> isSubscriptionActive(String uid) async {
    final user = await getUserData(uid);
    if (user == null || !user.isPremium) return false;

    if (user.subscriptionExpiry == null) return true;
    return user.subscriptionExpiry!.isAfter(DateTime.now());
  }
}
