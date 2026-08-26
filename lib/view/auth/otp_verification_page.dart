import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view/auth/create_new_password_page.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationPage({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  bool _isLoading = false;
  int _resendTimer = 30;
  Timer? _timer;
  bool _canResend = false;

  final String _demoOtp = '1234';

  late AnimationController _animController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _showDemoOtpSnackbar();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  void _showDemoOtpSnackbar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        'Secret Code!',
        'Use: $_demoOtp',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF66BB6A),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        margin: EdgeInsets.all(16.r),
        borderRadius: 16.r,
      );
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  void _resendOtp() {
    if (!_canResend) return;

    Get.snackbar(
      'Code Sent!',
      'Check your phone +91 ${widget.phoneNumber}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF66BB6A),
      colorText: Colors.white,
      margin: EdgeInsets.all(16.r),
      borderRadius: 16.r,
    );

    _startResendTimer();
    _showDemoOtpSnackbar();
  }

  String _getEnteredOtp() {
    return _otpControllers.map((c) => c.text).join();
  }

  Future<void> _verifyOtp() async {
    final enteredOtp = _getEnteredOtp();

    if (enteredOtp.length != 4) {
      Get.snackbar(
        'Oops!',
        'Enter all 4 digits of the code!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[400],
        colorText: Colors.white,
        margin: EdgeInsets.all(16.r),
        borderRadius: 16.r,
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (enteredOtp == _demoOtp) {
      Get.snackbar(
        'Correct!',
        'Code verified successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF66BB6A),
        colorText: Colors.white,
        margin: EdgeInsets.all(16.r),
        borderRadius: 16.r,
      );

      Get.off(() => CreateNewPasswordPage(phoneNumber: widget.phoneNumber));
    } else {
      Get.snackbar(
        'Wrong Code!',
        'Try again with the correct code!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        margin: EdgeInsets.all(16.r),
        borderRadius: 16.r,
      );

      for (var controller in _otpControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
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
          'OTP Verification',
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
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8.r,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_rounded,
                            size: 20.r,
                            color: Color(0xFF29B6F6),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: Color(0xFF29B6F6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                // Animated mascot
                AnimatedBuilder(
                  animation: _floatAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_floatAnimation.value),
                      child: child,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 15.r,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Text('🔐', style: TextStyle(fontSize: 50)),
                  ),
                ),
                SizedBox(height: 20.h),

                // Title
                const Text(
                  'Enter Secret Code!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0277BD),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Code sent to +91 ${widget.phoneNumber}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0288D1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                // OTP Card
                Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(
                      color: const Color(0xFF81D4FA),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15.r,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // OTP Input Fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 58.w,
                            height: 65.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: _otpControllers[index].text.isNotEmpty
                                    ? const Color(0xFF29B6F6)
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: TextFormField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              enableInteractiveSelection: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0277BD),
                              ),
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {});
                                if (value.isNotEmpty && index < 3) {
                                  _focusNodes[index + 1].requestFocus();
                                } else if (value.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }

                                if (_getEnteredOtp().length == 4) {
                                  _verifyOtp();
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 24.h),

                      // Verify Button
                      SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF29B6F6),
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: const Color(
                              0xFF29B6F6,
                            ).withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27.r),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 24.h,
                                  width: 24.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3.r,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 24.r,
                                    ),
                                    SizedBox(width: 8.w),
                                    Flexible(
                                      child: Text(
                                        'Verify Code',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Resend OTP
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Didn't get it? ",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _canResend
                                ? GestureDetector(
                                    onTap: _resendOtp,
                                    child: const Text(
                                      'Send Again!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF29B6F6),
                                      ),
                                    ),
                                  )
                                : Text(
                                    '${_resendTimer}s',
                                    style: const TextStyle(
                                      color: Color(0xFFFF7043),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ],
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
}
