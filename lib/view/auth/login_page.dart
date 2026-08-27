import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:jiyan_learning/services/age_content_service.dart';
import 'package:jiyan_learning/view%20model/auth%20controller/auth_controller.dart';
import 'package:jiyan_learning/view/auth/forgot_password_page.dart';
import 'package:jiyan_learning/view/auth/signup_page.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();

  AuthController get _authController {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
    return Get.find<AuthController>();
  }

  bool _obscurePassword = true;
  bool _usePhoneLogin = false;
  String _selectedCountryDialCode = '91';

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    _authController.resetOtpState();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _authController.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success) {
      await _openApp();
    } else {
      _showError();
    }
  }

  Future<void> _handleGoogleLogin() async {
    final success = await _authController.signInWithGoogle();
    if (!mounted) return;

    if (success) {
      await _openApp();
    } else if (_authController.errorMessage.value.isNotEmpty) {
      // An empty message means the user simply closed the account chooser,
      // which is not something to complain about.
      _showError();
    }
  }

  Widget _buildGoogleButton() {
    return Column(
      children: [
        SizedBox(height: 18.h),
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                'or',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          ],
        ),
        SizedBox(height: 14.h),
        Obx(
          () => GestureDetector(
            onTap: _authController.isLoading.value ? null : _handleGoogleLogin,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google's four colours, without shipping their asset.
                  Container(
                    width: 22.w,
                    height: 22.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          Color(0xFF4285F4),
                          Color(0xFF34A853),
                          Color(0xFFFBBC05),
                          Color(0xFFEA4335),
                          Color(0xFF4285F4),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'G',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Continue with Google',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3C4043),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSendOtp() async {
    if (_phoneController.text.trim().length < 6) {
      Get.snackbar(
        'Invalid Number',
        'Please enter a valid phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        margin: EdgeInsets.all(16.r),
        borderRadius: 16.r,
      );
      return;
    }

    final fullPhoneNumber = _phoneController.text.trim();
    await _authController.sendLoginOtp(
      fullPhoneNumber,
      countryCode: _selectedCountryDialCode,
    );

    if (_authController.errorMessage.isNotEmpty) {
      _showError();
    }
  }

  Future<void> _handleVerifyOtp() async {
    if (_otpController.text.trim().length != 6) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter the 6-digit OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        margin: EdgeInsets.all(16.r),
        borderRadius: 16.r,
      );
      return;
    }

    final success = await _authController.verifyOtpAndLogin(
      _otpController.text.trim(),
    );

    if (success) {
      await _openApp();
    } else {
      _showError();
    }
  }

  /// Where a successful login lands: the age question, and the app after it.
  ///
  /// Asked on every login, not just the first -- a phone is shared, and the
  /// parent says who is using it this time. The age on the account, where
  /// there is one, arrives already chosen so the parent only has to confirm.
  Future<void> _openApp() async {
    final age = Get.isRegistered<AgeContentService>()
        ? Get.find<AgeContentService>()
        : null;

    if (age != null && !age.hasSelectedAge.value) {
      // The record is read on the auth stream, which may not have come back
      // yet; asking for it here means the age is in hand before the question
      // is put on screen.
      await _authController.fetchUserData();
      final childAge = _authController.userModel?.childAge;
      if (childAge != null) {
        await age.setChildAge(childAge);
      }
    }

    Get.offAllNamed('/age-selection');
  }

  void _showError() {
    Get.snackbar(
      'Oops!',
      _authController.errorMessage.value,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[400],
      colorText: Colors.white,
      margin: EdgeInsets.all(16.r),
      borderRadius: 16.r,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Login',
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
        width: double.infinity,
        height: double.infinity,
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEB3B).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: const Text(
                    "Let's learn & play!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5D4037),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                // Login Card
                Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: const Color(0xFFFFB74D),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20.r,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Login Type Toggle
                        Obx(
                          () => _authController.otpSent.value
                              ? const SizedBox.shrink()
                              : Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _usePhoneLogin = false;
                                            });
                                            _authController.resetOtpState();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: !_usePhoneLogin
                                                  ? const Color(0xFF42A5F5)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(22.r),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.email_rounded,
                                                  size: 18.r,
                                                  color: !_usePhoneLogin
                                                      ? Colors.white
                                                      : Colors.grey[600],
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  'Email',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: !_usePhoneLogin
                                                        ? Colors.white
                                                        : Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _usePhoneLogin = true;
                                            });
                                            _authController.resetOtpState();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _usePhoneLogin
                                                  ? const Color(0xFF26A69A)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(22.r),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.phone_rounded,
                                                  size: 18.r,
                                                  color: _usePhoneLogin
                                                      ? Colors.white
                                                      : Colors.grey[600],
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  'Phone',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: _usePhoneLogin
                                                        ? Colors.white
                                                        : Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(height: 20.h),

                        // Email Login Fields
                        if (!_usePhoneLogin) ...[
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            enableInteractiveSelection: true,
                            autofocus: false,
                            readOnly: false,
                            showCursor: true,
                            cursorColor: const Color(0xFF42A5F5),
                            decoration: _buildInputDecoration(
                              label: 'Email',
                              icon: Icons.email_rounded,
                              color: const Color(0xFF42A5F5),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!GetUtils.isEmail(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            enableInteractiveSelection: true,
                            readOnly: false,
                            showCursor: true,
                            cursorColor: const Color(0xFFAB47BC),
                            decoration: _buildInputDecoration(
                              label: 'Password',
                              icon: Icons.lock_rounded,
                              color: const Color(0xFFAB47BC),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: Colors.grey[500],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  Get.to(() => const ForgotPasswordPage()),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Color(0xFFFF7043),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 56.h,
                              child: ElevatedButton(
                                onPressed: _authController.isLoading.value
                                    ? null
                                    : _handleEmailLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF66BB6A),
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                  shadowColor: const Color(
                                    0xFF66BB6A,
                                  ).withValues(alpha: 0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28.r),
                                  ),
                                ),
                                child: _authController.isLoading.value
                                    ? SizedBox(
                                        height: 24.h,
                                        width: 24.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3.r,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.login_rounded, size: 28.r),
                                          SizedBox(width: 8.w),
                                          Text(
                                            "Login",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ],

                        // Phone Login Fields
                        if (_usePhoneLogin) ...[
                          Obx(
                            () => !_authController.otpSent.value
                                ? Column(
                                    children: [
                                      // Phone number input with country code
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                          color: Colors.grey[50],
                                        ),
                                        child: Row(
                                          children: [
                                            // Country Code Picker
                                            CountryCodePicker(
                                              onChanged: (CountryCode code) {
                                                setState(() {
                                                  _selectedCountryDialCode =
                                                      code.dialCode?.replaceAll(
                                                        '+',
                                                        '',
                                                      ) ??
                                                      '91';
                                                });
                                              },
                                              initialSelection: 'IN',
                                              favorite: const [
                                                '+91',
                                                '+1',
                                                '+44',
                                                '+971',
                                              ],
                                              showCountryOnly: false,
                                              showOnlyCountryWhenClosed: false,
                                              alignLeft: false,
                                              padding: EdgeInsets.zero,
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF26A69A),
                                              ),
                                              dialogTextStyle: const TextStyle(
                                                fontSize: 16,
                                              ),
                                              searchDecoration: InputDecoration(
                                                hintText: 'Search country',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.r,
                                                      ),
                                                ),
                                              ),
                                              dialogSize: Size(
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.85,
                                                MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.7,
                                              ),
                                            ),
                                            Container(
                                              width: 1.w,
                                              height: 30.h,
                                              color: Colors.grey[300],
                                            ),
                                            // Phone Number Input
                                            Expanded(
                                              child: TextFormField(
                                                controller: _phoneController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                    15,
                                                  ),
                                                ],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                ),
                                                enableInteractiveSelection:
                                                    true,
                                                readOnly: false,
                                                showCursor: true,
                                                cursorColor: const Color(
                                                  0xFF26A69A,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: 'Phone Number',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                        horizontal: 12.w,
                                                        vertical: 16.h,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      // Send OTP Button
                                      Obx(
                                        () => SizedBox(
                                          width: double.infinity,
                                          height: 56.h,
                                          child: ElevatedButton(
                                            onPressed:
                                                _authController.isLoading.value
                                                ? null
                                                : _handleSendOtp,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF26A69A,
                                              ),
                                              foregroundColor: Colors.white,
                                              elevation: 4,
                                              shadowColor: const Color(
                                                0xFF26A69A,
                                              ).withValues(alpha: 0.4),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(28.r),
                                              ),
                                            ),
                                            child:
                                                _authController.isLoading.value
                                                ? SizedBox(
                                                    height: 24.h,
                                                    width: 24.w,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 3.r,
                                                          color: Colors.white,
                                                        ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.send_rounded,
                                                        size: 24.r,
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      Text(
                                                        "Send OTP",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      // OTP sent message
                                      Container(
                                        padding: EdgeInsets.all(12.r),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF26A69A,
                                          ).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              color: Color(0xFF26A69A),
                                            ),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: Text(
                                                'OTP sent to ${_authController.phoneNumberForOtp.value}',
                                                style: const TextStyle(
                                                  color: Color(0xFF26A69A),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _authController.resetOtpState();
                                                _otpController.clear();
                                              },
                                              child: const Text(
                                                'Change',
                                                style: TextStyle(
                                                  color: Color(0xFFFF7043),
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      // OTP Input
                                      TextFormField(
                                        controller: _otpController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 6,
                                        textAlign: TextAlign.center,
                                        enableInteractiveSelection: true,
                                        readOnly: false,
                                        showCursor: true,
                                        cursorColor: const Color(0xFF26A69A),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 8,
                                          color: Colors.black87,
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          labelText: 'Enter OTP',
                                          labelStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[600],
                                          ),
                                          counterText: '',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey[300]!,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey[300]!,
                                              width: 2,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF26A69A),
                                              width: 2,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 16.h,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                      // Resend OTP
                                      GestureDetector(
                                        onTap: _handleSendOtp,
                                        child: const Text(
                                          'Resend OTP',
                                          style: TextStyle(
                                            color: Color(0xFF26A69A),
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      // Verify OTP Button
                                      Obx(
                                        () => SizedBox(
                                          width: double.infinity,
                                          height: 56.h,
                                          child: ElevatedButton(
                                            onPressed:
                                                _authController.isLoading.value
                                                ? null
                                                : _handleVerifyOtp,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF66BB6A,
                                              ),
                                              foregroundColor: Colors.white,
                                              elevation: 4,
                                              shadowColor: const Color(
                                                0xFF66BB6A,
                                              ).withValues(alpha: 0.4),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(28.r),
                                              ),
                                            ),
                                            child:
                                                _authController.isLoading.value
                                                ? SizedBox(
                                                    height: 24.h,
                                                    width: 24.w,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 3.r,
                                                          color: Colors.white,
                                                        ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.verified_rounded,
                                                        size: 24.r,
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      Text(
                                                        "Verify & Login",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],

                        // Google, under whichever login form is showing.
                        _buildGoogleButton(),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Sign Up Link
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10.r,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: const Text(
                          "New here? ",
                          style: TextStyle(
                            color: Color(0xFF5D4037),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => const SignupPage()),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFFFF7043),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFFF7043),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    required Color color,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.grey[600],
      ),
      prefixIcon: Container(
        margin: EdgeInsets.all(8.r),
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, color: color, size: 22.r),
      ),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: color, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    );
  }
}
