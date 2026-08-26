import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:jiyan_learning/view/auth/otp_verification_page.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String _selectedCountryCode = '+91';

  late AnimationController _animController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Full phone number with country code
    final fullPhoneNumber =
        '$_selectedCountryCode${_phoneController.text.trim()}';

    Get.to(() => OtpVerificationPage(phoneNumber: fullPhoneNumber));
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
          'Forgot Password',
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
                            color: Color(0xFFAB47BC),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: Color(0xFFAB47BC),
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
                      offset: Offset(_floatAnimation.value, 0),
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
                    child: const Text('🔐', style: TextStyle(fontSize: 55)),
                  ),
                ),
                SizedBox(height: 20.h),

                // Title
                const Text(
                  'Oops! Forgot?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: const Text(
                    "No worries! We'll help you!",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6A1B9A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                // Form Card
                Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(
                      color: const Color(0xFFCE93D8),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Enter your mobile number',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Phone Field with Country Code Picker
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Country Code Picker
                              CountryCodePicker(
                                onChanged: (CountryCode code) {
                                  setState(() {
                                    _selectedCountryCode =
                                        code.dialCode ?? '+91';
                                  });
                                },
                                initialSelection: 'IN',
                                favorite: const ['+91', '+1', '+44', '+971'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                                padding: EdgeInsets.zero,
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFAB47BC),
                                ),
                                dialogTextStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                searchStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                flagWidth: 28,
                              ),
                              Container(
                                width: 1.w,
                                height: 35.h,
                                color: Colors.grey[300],
                              ),
                              // Phone Number Input
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 2,
                                    color: Colors.black87,
                                  ),
                                  enableInteractiveSelection: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    hintText: '9876543210',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      letterSpacing: 2,
                                    ),
                                    border: InputBorder.none,
                                    counterText: '',
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 14.h,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter mobile number';
                                    }
                                    if (value.length < 7) {
                                      return 'Enter valid phone number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Send OTP Button
                        SizedBox(
                          width: double.infinity,
                          height: 54.h,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _sendOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFAB47BC),
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: const Color(
                                0xFFAB47BC,
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
                                      Icon(Icons.send_rounded, size: 22.r),
                                      SizedBox(width: 8.w),
                                      Flexible(
                                        child: Text(
                                          'Send Magic Code',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Info Text
                SizedBox(height: 24.h),
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Text('💡', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'We will send a 4-digit code to your phone!',
                          style: TextStyle(
                            color: Color(0xFF7B1FA2),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
}
