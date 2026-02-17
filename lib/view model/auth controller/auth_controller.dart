import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/model/user_model.dart';
import 'package:jiyan_learning/services/firebase_service.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseService _firebaseService = FirebaseService();

  // Observables
  final Rx<User?> _firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool otpSent = false.obs;
  final RxString phoneNumberForOtp = ''.obs;

  // Getters
  User? get firebaseUser => _firebaseUser.value;
  UserModel? get userModel => _userModel.value;
  bool get isLoggedIn => FirebaseService.isAvailable && _firebaseUser.value != null;
  String get userId => _firebaseUser.value?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    // Only initialize Firebase listeners on mobile platforms
    if (FirebaseService.isAvailable) {
      // Listen to auth state changes
      _firebaseUser.bindStream(_firebaseService.authStateChanges);
      ever(_firebaseUser, _handleAuthChanged);
    }
  }

  void _handleAuthChanged(User? user) async {
    if (user != null) {
      // Fetch user data from Firestore
      await fetchUserData();
    } else {
      _userModel.value = null;
    }
  }

  /// Fetch user data from Firestore
  Future<void> fetchUserData() async {
    if (_firebaseUser.value == null) return;

    try {
      final userData = await _firebaseService.getUserData(_firebaseUser.value!.uid);
      _userModel.value = userData;
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  /// Sign up with email
  Future<bool> signUp({
    required String email,
    required String password,
    String? childName,
    int? childAge,
    String? phoneNumber,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _firebaseService.signUpWithEmail(
        email: email,
        password: password,
        childName: childName,
        childAge: childAge,
        phoneNumber: phoneNumber,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getErrorMessage(e.code);
      return false;
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign in with email and password
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _firebaseService.signInWithEmail(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getErrorMessage(e.code);
      return false;
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Send OTP for phone login
  Future<bool> sendLoginOtp(String phoneNumber, {required String countryCode}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      otpSent.value = false;

      // Full phone number with country code for database lookup
      final fullPhoneNumber = '+$countryCode$phoneNumber';

      // Check if phone number exists in our database
      final exists = await _firebaseService.phoneNumberExists(fullPhoneNumber);
      if (!exists) {
        errorMessage.value = 'No account found with this phone number.';
        isLoading.value = false;
        return false;
      }

      phoneNumberForOtp.value = fullPhoneNumber;

      await _firebaseService.sendOtp(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
        onCodeSent: (verificationId) {
          otpSent.value = true;
          isLoading.value = false;
          Get.snackbar(
            'OTP Sent!',
            'Check your phone for the verification code.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        onError: (error) {
          errorMessage.value = error;
          isLoading.value = false;
        },
        onAutoVerify: (credential) async {
          // Auto verification - sign in directly
          try {
            await _firebaseService.signInWithPhoneCredential(credential);
            isLoading.value = false;
          } catch (e) {
            errorMessage.value = 'Auto verification failed.';
            isLoading.value = false;
          }
        },
      );

      return true;
    } catch (e) {
      errorMessage.value = 'Failed to send OTP. Please try again.';
      isLoading.value = false;
      return false;
    }
  }

  /// Verify OTP and sign in
  Future<bool> verifyOtpAndLogin(String otp) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _firebaseService.verifyOtpAndSignIn(otp);

      otpSent.value = false;
      phoneNumberForOtp.value = '';

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getErrorMessage(e.code);
      return false;
    } catch (e) {
      errorMessage.value = 'Invalid OTP. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset OTP state
  void resetOtpState() {
    otpSent.value = false;
    phoneNumberForOtp.value = '';
    errorMessage.value = '';
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _firebaseService.signOut();
    } catch (e) {
      errorMessage.value = 'Failed to sign out. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _firebaseService.resetPassword(email);

      Get.snackbar(
        'Success',
        'Password reset email sent. Check your inbox.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getErrorMessage(e.code);
      return false;
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update profile
  Future<bool> updateProfile({
    String? childName,
    int? childAge,
    String? parentEmail,
    String? parentPhone,
    String? location,
  }) async {
    if (!isLoggedIn) return false;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      debugPrint('Updating profile for user: $userId');
      debugPrint('Data: childName=$childName, parentEmail=$parentEmail, parentPhone=$parentPhone, location=$location');

      await _firebaseService.updateUserProfile(
        uid: userId,
        childName: childName,
        childAge: childAge,
        parentEmail: parentEmail,
        parentPhone: parentPhone,
        location: location,
      );

      debugPrint('Profile updated successfully, fetching user data...');
      await fetchUserData();
      debugPrint('User data fetched successfully');

      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      errorMessage.value = 'Failed to update profile.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!isLoggedIn) return false;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _firebaseService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getErrorMessage(e.code);
      return false;
    } catch (e) {
      debugPrint('Error changing password: $e');
      if (e.toString().contains('wrong-password')) {
        errorMessage.value = 'Current password is incorrect.';
      } else if (e.toString().contains('requires-recent-login')) {
        errorMessage.value = 'Please re-login and try again.';
      } else {
        errorMessage.value = 'Failed to change password. Please try again.';
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    try {
      isLoading.value = true;
      await _firebaseService.deleteAccount();
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to delete account. Please re-login and try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Save progress to Firestore
  Future<void> saveProgress({
    required String category,
    int? score,
    int? completedBatches,
    int? totalQuestions,
    int? correctAnswers,
  }) async {
    if (!isLoggedIn) return;

    try {
      await _firebaseService.updateProgress(
        uid: userId,
        category: category,
        score: score,
        completedBatches: completedBatches,
        totalQuestions: totalQuestions,
        correctAnswers: correctAnswers,
      );
    } catch (e) {
      debugPrint('Error saving progress: $e');
    }
  }

  /// Get progress from Firestore
  Future<ProgressModel?> getProgress(String category) async {
    if (!isLoggedIn) return null;

    try {
      return await _firebaseService.getProgress(
        uid: userId,
        category: category,
      );
    } catch (e) {
      debugPrint('Error getting progress: $e');
      return null;
    }
  }

  /// Check if user has premium subscription
  Future<bool> checkPremiumStatus() async {
    if (!isLoggedIn) return false;

    try {
      return await _firebaseService.isSubscriptionActive(userId);
    } catch (e) {
      return false;
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
