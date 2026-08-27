import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/model/user_model.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';
import 'package:jiyan_learning/services/user_profile_service.dart';
import 'package:jiyan_learning/view%20model/auth%20controller/auth_controller.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  File? _selectedImage;
  // The picture stored on the account, shown until the user picks a new one.
  Uint8List? _accountPhoto;
  // Set when the user removes the photo. Nothing is deleted until save, so
  // leaving the screen without saving keeps the old photo.
  bool _photoCleared = false;
  final ImagePicker _picker = ImagePicker();
  bool _isSaving = false;
  // Fires when the account record lands after this screen was already built.
  Worker? _accountWorker;

  /// The device-local copy of the profile -- the only copy a guest has, and
  /// the only place the photo lives even for a signed-in account.
  UserProfileService? get _profileService =>
      Get.isRegistered<UserProfileService>()
          ? Get.find<UserProfileService>()
          : null;

  late AuthController _authController;
  late AnimationController _bubbleController;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  // Floating bubbles for playful effect - same as home page
  List<Widget> _buildFloatingBubbles() {
    final random = math.Random(42);
    return List.generate(8, (index) {
      final size = 20.0 + random.nextDouble() * 60;
      final left = random.nextDouble() * 400;
      final top = random.nextDouble() * 800;
      final delay = random.nextDouble();

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + delay) % 1.0;
          final yOffset = -progress * 200;
          final opacity = (1 - progress) * 0.15;

          return Positioned(
            left: left,
            top: top + yOffset,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: opacity),
                    Colors.white.withValues(alpha: opacity * 0.3),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // Location suggestions
  List<String> _locationSuggestions = [];
  bool _showLocationSuggestions = false;

  // Indian cities list for autocomplete
  final List<String> _indianCities = [
    'Mumbai, Maharashtra',
    'Delhi, Delhi',
    'Bangalore, Karnataka',
    'Hyderabad, Telangana',
    'Ahmedabad, Gujarat',
    'Chennai, Tamil Nadu',
    'Kolkata, West Bengal',
    'Surat, Gujarat',
    'Pune, Maharashtra',
    'Jaipur, Rajasthan',
    'Lucknow, Uttar Pradesh',
    'Kanpur, Uttar Pradesh',
    'Nagpur, Maharashtra',
    'Indore, Madhya Pradesh',
    'Thane, Maharashtra',
    'Bhopal, Madhya Pradesh',
    'Visakhapatnam, Andhra Pradesh',
    'Pimpri-Chinchwad, Maharashtra',
    'Patna, Bihar',
    'Vadodara, Gujarat',
    'Ghaziabad, Uttar Pradesh',
    'Ludhiana, Punjab',
    'Agra, Uttar Pradesh',
    'Nashik, Maharashtra',
    'Faridabad, Haryana',
    'Meerut, Uttar Pradesh',
    'Rajkot, Gujarat',
    'Kalyan-Dombivli, Maharashtra',
    'Vasai-Virar, Maharashtra',
    'Varanasi, Uttar Pradesh',
    'Srinagar, Jammu & Kashmir',
    'Aurangabad, Maharashtra',
    'Dhanbad, Jharkhand',
    'Amritsar, Punjab',
    'Navi Mumbai, Maharashtra',
    'Allahabad, Uttar Pradesh',
    'Ranchi, Jharkhand',
    'Howrah, West Bengal',
    'Coimbatore, Tamil Nadu',
    'Jabalpur, Madhya Pradesh',
    'Gwalior, Madhya Pradesh',
    'Vijayawada, Andhra Pradesh',
    'Jodhpur, Rajasthan',
    'Madurai, Tamil Nadu',
    'Raipur, Chhattisgarh',
    'Kota, Rajasthan',
    'Guwahati, Assam',
    'Chandigarh, Chandigarh',
    'Solapur, Maharashtra',
    'Hubli-Dharwad, Karnataka',
    'Bareilly, Uttar Pradesh',
    'Moradabad, Uttar Pradesh',
    'Mysore, Karnataka',
    'Gurgaon, Haryana',
    'Aligarh, Uttar Pradesh',
    'Jalandhar, Punjab',
    'Tiruchirappalli, Tamil Nadu',
    'Bhubaneswar, Odisha',
    'Salem, Tamil Nadu',
    'Mira-Bhayandar, Maharashtra',
    'Warangal, Telangana',
    'Thiruvananthapuram, Kerala',
    'Guntur, Andhra Pradesh',
    'Bhiwandi, Maharashtra',
    'Saharanpur, Uttar Pradesh',
    'Gorakhpur, Uttar Pradesh',
    'Bikaner, Rajasthan',
    'Amravati, Maharashtra',
    'Noida, Uttar Pradesh',
    'Jamshedpur, Jharkhand',
    'Bhilai, Chhattisgarh',
    'Cuttack, Odisha',
    'Firozabad, Uttar Pradesh',
    'Kochi, Kerala',
    'Nellore, Andhra Pradesh',
    'Bhavnagar, Gujarat',
    'Dehradun, Uttarakhand',
    'Durgapur, West Bengal',
    'Asansol, West Bengal',
    'Rourkela, Odisha',
    'Nanded, Maharashtra',
    'Kolhapur, Maharashtra',
    'Ajmer, Rajasthan',
    'Akola, Maharashtra',
    'Gulbarga, Karnataka',
    'Jamnagar, Gujarat',
    'Ujjain, Madhya Pradesh',
    'Loni, Uttar Pradesh',
    'Siliguri, West Bengal',
    'Jhansi, Uttar Pradesh',
    'Ulhasnagar, Maharashtra',
    'Jammu, Jammu & Kashmir',
    'Sangli-Miraj & Kupwad, Maharashtra',
    'Mangalore, Karnataka',
    'Erode, Tamil Nadu',
    'Belgaum, Karnataka',
    'Ambattur, Tamil Nadu',
    'Tirunelveli, Tamil Nadu',
    'Malegaon, Maharashtra',
    'Shimla, Himachal Pradesh',
    'Gangtok, Sikkim',
    'Shillong, Meghalaya',
    'Aizawl, Mizoram',
    'Itanagar, Arunachal Pradesh',
    'Imphal, Manipur',
    'Kohima, Nagaland',
    'Agartala, Tripura',
    'Panaji, Goa',
    'Port Blair, Andaman & Nicobar',
    'Silvassa, Dadra & Nagar Haveli',
    'Daman, Daman & Diu',
    'Kavaratti, Lakshadweep',
    'Puducherry, Puducherry',
  ];

  void _onLocationChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _locationSuggestions = [];
        _showLocationSuggestions = false;
      });
      return;
    }

    final suggestions = _indianCities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .take(5)
        .toList();

    setState(() {
      _locationSuggestions = suggestions;
      _showLocationSuggestions = suggestions.isNotEmpty;
    });
  }

  void _selectLocation(String location) {
    _locationController.text = location;
    setState(() {
      _showLocationSuggestions = false;
      _locationSuggestions = [];
    });
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter child name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter phone number';
    }
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter location';
    }
    if (value.trim().length < 3) {
      return 'Location must be at least 3 characters';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Initialize AuthController
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController(), permanent: true);
    }
    // Pre-fill form with existing user data
    _loadUserData();

    // On a cold start the Firestore read is often still in flight when this
    // screen opens, which is what left the form blank: it was filled once,
    // from nothing. Fill it again when the record lands, and ask for it in
    // case the earlier fetch failed.
    _accountWorker = ever<UserModel?>(
      _authController.userModelRx,
      (_) => _fillBlanksFromAccount(),
    );
    _refreshAccount();
  }

  Future<void> _refreshAccount() async {
    if (!_authController.isLoggedIn) return;
    await _authController.fetchUserData();
    _fillBlanksFromAccount();
  }

  /// Fills in whatever is still blank from the account record.
  ///
  /// Only blanks: anything already on screen is either the user's own typing
  /// or the copy saved on this device, and neither should be overwritten by a
  /// read that happens to land a moment later.
  void _fillBlanksFromAccount() {
    if (!mounted) return;
    final user = _authController.userModel;
    if (user == null) return;

    setState(() {
      if (_nameController.text.trim().isEmpty) {
        _nameController.text = user.childName?.trim() ?? '';
      }
      if (_emailController.text.trim().isEmpty) {
        _emailController.text =
            _authController.firebaseUser?.email ?? user.parentEmail ?? '';
      }
      if (_phoneController.text.trim().isEmpty) {
        _phoneController.text =
            user.parentPhone?.replaceFirst('+91', '').trim() ?? '';
      }
      if (_locationController.text.trim().isEmpty) {
        _locationController.text = user.location?.trim() ?? '';
      }
      if (_selectedImage == null && !_photoCleared) {
        _accountPhoto = _decodePhoto(user.photoBase64);
      }
    });
  }

  /// The account's picture, or null when it has none or the stored text is
  /// not readable as an image.
  Uint8List? _decodePhoto(String? base64Text) {
    final text = base64Text?.trim() ?? '';
    if (text.isEmpty) return null;
    try {
      return base64Decode(text);
    } catch (_) {
      return null;
    }
  }

  /// What the avatar circle shows: the newly picked file, else the account's
  /// picture, else nothing (the name's initial takes over).
  ImageProvider? get _avatarImage {
    final picked = _selectedImage;
    if (picked != null) return FileImage(picked);
    final stored = _accountPhoto;
    if (stored != null) return MemoryImage(stored);
    if (_photoCleared) return null;
    // A Google account brings a hosted picture rather than inline bytes.
    final hosted = _authController.userModel?.photoUrl?.trim() ?? '';
    if (hosted.isNotEmpty) return NetworkImage(hosted);
    return null;
  }

  void _loadUserData() {
    final user = _authController.userModel;
    final firebaseUser = _authController.firebaseUser;
    final saved = _profileService;

    // The account is the source of truth where it has a value; the locally
    // saved copy fills in for a guest, or for fields the account never held.
    _nameController.text = user?.childName?.trim().isNotEmpty == true
        ? user!.childName!
        : (saved?.name.value ?? '');

    final accountPhone = user?.parentPhone?.replaceFirst('+91', '') ?? '';
    _phoneController.text =
        accountPhone.isNotEmpty ? accountPhone : (saved?.phone.value ?? '');

    _locationController.text = user?.location?.trim().isNotEmpty == true
        ? user!.location!
        : (saved?.location.value ?? '');

    final accountEmail = firebaseUser?.email ?? user?.parentEmail ?? '';
    _emailController.text =
        accountEmail.isNotEmpty ? accountEmail : (saved?.email.value ?? '');

    // Show the photo the user already picked, if any, otherwise the one the
    // account was created with.
    _selectedImage = saved?.photoFile;
    _accountPhoto = _decodePhoto(user?.photoBase64);
  }

  @override
  void dispose() {
    _accountWorker?.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final avatar = _avatarImage;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated floating bubbles background
            ..._buildFloatingBubbles(),

            // Main content
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingS,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar Section with Animation
                      AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnimation.value * 0.5),
                            child: child,
                          );
                        },
                        child: Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: _showImagePickerOptions,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100.w,
                                      height: 100.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.2,
                                            ),
                                            blurRadius: 15.r,
                                          ),
                                        ],
                                        image: avatar != null
                                            ? DecorationImage(
                                                image: avatar,
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: avatar == null
                                          ? Center(
                                              child: ValueListenableBuilder<
                                                  TextEditingValue>(
                                                valueListenable:
                                                    _nameController,
                                                builder: (context, value, _) {
                                                  final name =
                                                      value.text.trim();
                                                  return Text(
                                                    name.isEmpty
                                                        ? 'U'
                                                        : name[0]
                                                            .toUpperCase(),
                                                    style:
                                                        GoogleFonts.poppins(
                                                      fontSize: 42,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                        0xFF4ECDC4,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : null,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(6.r),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF4ECDC4),
                                              Color(0xFF44A08D),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          color: Colors.white,
                                          size: 16.r,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppTheme.spacingS),
                      _buildStorageNote(),
                      SizedBox(height: AppTheme.spacingL),

                      // Child Name Field
                      _buildFieldLabel(
                        'Child Name',
                        Icons.person_outline_rounded,
                      ),
                      SizedBox(height: AppTheme.spacingS),
                      _buildTextField(
                        controller: _nameController,
                        hint: 'Enter child name',
                        validator: _validateName,
                      ),
                      SizedBox(height: AppTheme.spacingM),

                      // Parent Email Field
                      _buildFieldLabel('Parent Email', Icons.email_outlined),
                      SizedBox(height: AppTheme.spacingS),
                      _buildTextField(
                        controller: _emailController,
                        hint: 'Enter parent email',
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      SizedBox(height: AppTheme.spacingM),

                      // Phone Number Field
                      _buildFieldLabel('Phone Number', Icons.phone_outlined),
                      SizedBox(height: AppTheme.spacingS),
                      _buildTextField(
                        controller: _phoneController,
                        hint: 'Enter phone number',
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                      ),
                      SizedBox(height: AppTheme.spacingM),

                      // Location Field
                      _buildFieldLabel('Location', Icons.location_on_outlined),
                      SizedBox(height: AppTheme.spacingS),
                      _buildLocationField(),
                      SizedBox(height: AppTheme.spacingXL),

                      // Save Button
                      _buildSaveButton(),
                      SizedBox(height: AppTheme.spacingM),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A line under the avatar saying where a save actually goes, so a guest
  /// is not left wondering why their details are not on any other device.
  Widget _buildStorageNote() {
    final signedIn = _authController.isLoggedIn;
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            signedIn
                ? Icons.cloud_done_rounded
                : Icons.phone_iphone_rounded,
            size: 14.r,
            color: Colors.white.withValues(alpha: 0.85),
          ),
          SizedBox(width: AppTheme.spacingXS),
          Flexible(
            child: Text(
              signedIn
                  ? 'Saved to your account'
                  : 'Saved on this phone - sign in to keep it everywhere',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 8,
      shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20.r,
          ),
        ),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x40FF6B6B),
              blurRadius: 15.r,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
      title: Text(
        'Edit Profile',
        style: GoogleFonts.baloo2(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4.r,
              offset: const Offset(1, 2),
            ),
          ],
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildLocationField() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingS,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: _locationController,
            cursorColor: Colors.white,
            cursorWidth: 2.5,
            cursorHeight: 20,
            validator: _validateLocation,
            onChanged: _onLocationChanged,
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Search city...',
              hintStyle: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.5),
              ),
              errorStyle: GoogleFonts.nunito(
                fontSize: 12,
                color: const Color(0xFFFFCB80),
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8.h),
              suffixIcon: _locationController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _locationController.clear();
                        setState(() {
                          _showLocationSuggestions = false;
                          _locationSuggestions = [];
                        });
                      },
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 20.r,
                      ),
                    )
                  : null,
            ),
          ),
        ),
        // Suggestions dropdown
        if (_showLocationSuggestions && _locationSuggestions.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Column(
                children: _locationSuggestions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final city = entry.value;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _selectLocation(city),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          border: index < _locationSuggestions.length - 1
                              ? Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                  ),
                                )
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: const Color(0xFF667EEA),
                              size: 20.r,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                city,
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF333333),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: Colors.white, size: 18.r),
        ),
        SizedBox(width: AppTheme.spacingS),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 2.r,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: Colors.white,
        cursorWidth: 2.5,
        cursorHeight: 20,
        validator: validator,
        style: GoogleFonts.nunito(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          errorStyle: GoogleFonts.nunito(
            fontSize: 12,
            color: const Color(0xFFFFCB80),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Choose Photo',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  gradient: const [
                    Color(0xFFFF6B6B),
                    Color(0xFFFF8E53),
                    Color(0xFFFFAA5A),
                  ],
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _buildPickerOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  gradient: const [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Only worth offering once there is a photo to take away.
            if (_avatarImage != null)
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                    _accountPhoto = null;
                    _photoCleared = true;
                  });
                },
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                  size: 20.r,
                ),
                label: Text(
                  'Remove Photo',
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.4),
                  blurRadius: 12.r,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 32.r),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _photoCleared = false;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B),
        colorText: Colors.white,
        borderRadius: 16.r,
        margin: EdgeInsets.all(16.r),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Save on the device first. This is what the profile card reads, and it
      // has to work for a guest too -- signing in is not required to set your
      // own name, email, location or photo.
      final profile = _profileService;
      if (profile != null) {
        await profile.save(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          location: _locationController.text.trim(),
        );
        final picked = _selectedImage;
        if (_photoCleared) {
          await profile.removePhoto();
        } else if (picked != null && picked.path != profile.photoPath.value) {
          await profile.savePhoto(picked);
        }
      }

      // Mirror it to the account when there is one. A guest simply keeps the
      // local copy.
      final success = !_authController.isLoggedIn ||
          await _authController.updateProfile(
            childName: _nameController.text.trim(),
            parentEmail: _emailController.text.trim(),
            parentPhone: _phoneController.text.trim(),
            location: _locationController.text.trim(),
            photoBase64: await _photoForAccount(),
          );

      if (success) {
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4ECDC4),
          colorText: Colors.white,
          borderRadius: 16.r,
          margin: EdgeInsets.all(16.r),
        );
        // Go back to Profile screen (pop Edit Profile and Account Settings)
        Get.close(2);
      } else {
        Get.snackbar(
          'Error',
          _authController.errorMessage.value.isNotEmpty
              ? _authController.errorMessage.value
              : 'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFF6B6B),
          colorText: Colors.white,
          borderRadius: 16.r,
          margin: EdgeInsets.all(16.r),
        );
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B),
        colorText: Colors.white,
        borderRadius: 16.r,
        margin: EdgeInsets.all(16.r),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  /// What to store on the account for the photo: the bytes of a newly picked
  /// one, '' when the user took theirs away, and null to leave it as it is.
  ///
  /// It goes inline into the Firestore document the same way the signup photo
  /// does -- the picker already caps it at 512px, so it fits comfortably.
  Future<String?> _photoForAccount() async {
    if (_photoCleared) return '';
    final picked = _selectedImage;
    if (picked == null || !picked.existsSync()) return null;

    final bytes = await picked.readAsBytes();
    // Firestore caps a document at 1MB. 512px at quality 80 lands far under
    // that; anything that somehow does not stays on the phone rather than
    // failing the whole save.
    if (bytes.length > 600 * 1024) return null;
    return base64Encode(bytes);
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _isSaving ? null : _saveProfile,
      child: Container(
        width: double.infinity,
        height: AppTheme.buttonHeight,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4ECDC4).withValues(alpha: 0.4),
              blurRadius: 16.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: _isSaving
              ? SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5.r,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_rounded, color: Colors.white, size: 22.r),
                    SizedBox(width: AppTheme.spacingS),
                    Text(
                      'Save Changes',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
