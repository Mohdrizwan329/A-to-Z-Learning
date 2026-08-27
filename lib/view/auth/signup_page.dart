import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiyan_learning/services/device_location_service.dart';
import 'package:jiyan_learning/services/user_profile_service.dart';
import 'package:jiyan_learning/utils/image_source_picker.dart';
import 'package:jiyan_learning/view%20model/auth%20controller/auth_controller.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _childNameController = TextEditingController();
  final _childAgeController = TextEditingController();
  final _locationController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  /// The chosen profile picture, already shrunk and encoded, ready to store.
  String? _photoBase64;

  /// True while the device is being asked where it is.
  bool _findingLocation = false;

  AuthController get _authController {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
    return Get.find<AuthController>();
  }

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedCountryCode = '+91';

  @override
  void initState() {
    super.initState();

    // Filled in for the parent as the form opens. It runs after the first
    // frame so the permission prompt appears over a form they can already
    // see, and a refusal just leaves the field to be typed.
    WidgetsBinding.instance.addPostFrameCallback((_) => _useMyLocation());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _childNameController.dispose();
    _childAgeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    // Full phone number with country code
    final fullPhoneNumber =
        '$_selectedCountryCode${_phoneController.text.trim()}';

    final success = await _authController.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      childName: _childNameController.text.trim(),
      childAge: int.tryParse(_childAgeController.text.trim()),
      phoneNumber: fullPhoneNumber,
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      photoBase64: _photoBase64,
    );

    if (success) {
      await _saveOnDevice(fullPhoneNumber);
      await _authController.signOut();
      Get.offAllNamed('/login');
      Get.snackbar(
        'Account Created!',
        'Now login to start learning!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
        margin: EdgeInsets.all(16.r),
        borderRadius: 16.r,
        duration: const Duration(seconds: 3),
      );
    } else {
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
  }

  /// Keeps a copy of what was just signed up with on the device.
  ///
  /// Signup drops the user back at the login screen, so without this the
  /// profile and edit screens have nothing to show until a login has gone
  /// through and the Firestore read has come back -- which is what made a
  /// freshly created profile look like it had never been entered.
  Future<void> _saveOnDevice(String fullPhoneNumber) async {
    if (!Get.isRegistered<UserProfileService>()) return;
    final local = Get.find<UserProfileService>();

    await local.save(
      name: _childNameController.text.trim(),
      email: _emailController.text.trim(),
      // The form's own digits: the edit screen shows the number without a
      // country code and validates it as ten digits.
      phone: _phoneController.text.trim(),
      location: _locationController.text.trim(),
    );

    final photo = _photoBase64;
    if (photo != null && photo.isNotEmpty) {
      await local.savePhotoBytes(base64Decode(photo));
    }
  }

  /// Camera or gallery, then shrunk enough to live inside the profile
  /// document -- a full-size photo would not fit and is not needed for a
  /// picture shown at 70pt.
  Future<void> _pickPhoto() async {
    final source = await askImageSource(
      title: "Profile picture",
      cameraSubtitle: "Take a photo now",
      gallerySubtitle: "Choose one from the gallery",
    );
    if (source == null) return;

    try {
      final image = await _picker.pickImage(
        source: source,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 70,
      );
      if (image == null) return;

      final bytes = await File(image.path).readAsBytes();
      // Firestore caps a document at 1MB. 400px at quality 70 lands far
      // under this, but a stubborn file is refused rather than silently
      // breaking the signup.
      if (bytes.length > 600 * 1024) {
        Get.snackbar(
          'Photo too large',
          'Please choose a smaller picture.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(16.r),
          borderRadius: 16.r,
        );
        return;
      }

      setState(() => _photoBase64 = base64Encode(bytes));
    } catch (e) {
      Get.snackbar(
        'Could not use that photo',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        margin: EdgeInsets.all(16.r),
        borderRadius: 16.r,
      );
    }
  }

  /// Fills the location field from where the device actually is. It stays a
  /// plain text field, so a parent who refuses the permission can still type
  /// their city.
  Future<void> _useMyLocation() async {
    setState(() => _findingLocation = true);
    final result = await DeviceLocationService.current();
    if (!mounted) return;

    setState(() {
      _findingLocation = false;
      if (result.isFound) _locationController.text = result.place!;
    });

    if (!result.isFound) {
      Get.snackbar(
        'Location',
        result.error!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[400],
        colorText: Colors.white,
        margin: EdgeInsets.all(16.r),
        borderRadius: 16.r,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Widget _buildPhotoPicker() {
    final image = _photoBase64 == null ? null : base64Decode(_photoBase64!);

    return Column(
      children: [
        GestureDetector(
          onTap: _pickPhoto,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 96.w,
                height: 96.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF3E0),
                  border: Border.all(color: const Color(0xFFFFCC80), width: 3),
                ),
                clipBehavior: Clip.antiAlias,
                child: image != null
                    ? Image.memory(image, fit: BoxFit.cover)
                    : Icon(
                        Icons.add_a_photo_rounded,
                        color: const Color(0xFFFF7043),
                        size: 34.r,
                      ),
              ),
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF7043),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  image != null ? Icons.edit_rounded : Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 14.r,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          image != null ? "Tap to change photo" : "Add a profile photo",
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF795548),
          ),
        ),
      ],
    );
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
          'Sign Up',
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
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                SizedBox(height: 20.h),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: const Text(
                    "Create your child's account",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF795548),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Form Card
                Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(
                      color: const Color(0xFFFFCC80),
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
                        // Profile Picture
                        _buildPhotoPicker(),
                        SizedBox(height: 16.h),

                        // Child Name Field
                        TextFormField(
                          controller: _childNameController,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          enableInteractiveSelection: true,
                          readOnly: false,
                          showCursor: true,
                          cursorColor: const Color(0xFFFF7043),
                          decoration: _buildInputDecoration(
                            label: "Child's Name",
                            icon: Icons.face_rounded,
                            color: const Color(0xFFFF7043),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter child's name";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 14.h),

                        // Child Age Field
                        TextFormField(
                          controller: _childAgeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          enableInteractiveSelection: true,
                          readOnly: false,
                          showCursor: true,
                          cursorColor: const Color(0xFFFFB74D),
                          decoration: _buildInputDecoration(
                            label: "Child's Age",
                            icon: Icons.cake_rounded,
                            color: const Color(0xFFFFB74D),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter child's age";
                            }
                            final age = int.tryParse(value);
                            if (age == null || age < 3 || age > 12) {
                              return 'Age should be 3-12 years';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 14.h),

                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          enableInteractiveSelection: true,
                          readOnly: false,
                          showCursor: true,
                          cursorColor: const Color(0xFF42A5F5),
                          decoration: _buildInputDecoration(
                            label: "Parent's Email",
                            icon: Icons.email_rounded,
                            color: const Color(0xFF42A5F5),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            if (!GetUtils.isEmail(value)) {
                              return 'Please enter valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 14.h),

                        // Phone Number Field with Country Code Picker
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(14.r),
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF26A69A),
                                ),
                                dialogTextStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                searchStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                flagWidth: 24,
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
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  enableInteractiveSelection: true,
                                  readOnly: false,
                                  showCursor: true,
                                  cursorColor: const Color(0xFF26A69A),
                                  decoration: InputDecoration(
                                    hintText: "Parent's Phone",
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[500],
                                    ),
                                    counterText: '',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 14.h,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter phone number';
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
                        SizedBox(height: 14.h),

                        // Location Field, fillable from the device itself
                        TextFormField(
                          controller: _locationController,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          cursorColor: const Color(0xFF66BB6A),
                          decoration: _buildInputDecoration(
                            label: "City / Location",
                            icon: Icons.location_on_rounded,
                            color: const Color(0xFF66BB6A),
                          ).copyWith(
                            suffixIcon: _findingLocation
                                ? Padding(
                                    padding: EdgeInsets.all(12.r),
                                    child: SizedBox(
                                      width: 18.w,
                                      height: 18.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.r,
                                        color: const Color(0xFF66BB6A),
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    tooltip: 'Use my location',
                                    onPressed: _useMyLocation,
                                    icon: Icon(
                                      Icons.my_location_rounded,
                                      color: const Color(0xFF66BB6A),
                                      size: 22.r,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 14.h),

                        // Password Field
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
                              return 'Please enter password';
                            }
                            if (value.length < 6) {
                              return 'Password must be 6+ characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 14.h),

                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          enableInteractiveSelection: true,
                          readOnly: false,
                          showCursor: true,
                          cursorColor: const Color(0xFF66BB6A),
                          decoration: _buildInputDecoration(
                            label: 'Confirm Password',
                            icon: Icons.lock_outline_rounded,
                            color: const Color(0xFF66BB6A),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: Colors.grey[500],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),

                        // Signup Button
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 54.h,
                            child: ElevatedButton(
                              onPressed: _authController.isLoading.value
                                  ? null
                                  : _handleSignup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF66BB6A),
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor: const Color(
                                  0xFF66BB6A,
                                ).withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27.r),
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
                                        Icon(
                                          Icons.person_add_rounded,
                                          size: 24.r,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
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

                // Login Link
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Flexible(
                        child: Text(
                          'Already a member? ',
                          style: TextStyle(
                            color: Color(0xFF5D4037),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Text(
                          'Login!',
                          style: TextStyle(
                            color: Color(0xFFFF7043),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFFF7043),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
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
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.grey[600],
      ),
      prefixIcon: Container(
        margin: EdgeInsets.all(8.r),
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: color, size: 20.r),
      ),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: color, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    );
  }
}
