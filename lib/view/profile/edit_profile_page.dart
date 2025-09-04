import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/custom_rounded_button.dart';
import 'package:learning_a_to_z/widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String gender = 'Male';

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Reusable TextField builder
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ConstStyle.smallText),
        const SizedBox(height: 8),
        CustomTextField(controller: controller, hintText: hintText ?? ''),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2,
        title: "Edit Profile",
        showBackButton: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: ConstColors.textColorWhit,
          ),
          onPressed: () => Get.back(),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: ConstColors.borderColor,
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : const AssetImage("assets/avatar.png") as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _showImageSourceActionSheet,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: ConstColors.textColorWhit,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: ConstColors.textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildTextField(
              "Full Name",
              nameController,
              hintText: "Enter your full name",
            ),
            const SizedBox(height: 16),

            _buildTextField(
              "Mobile Number",
              mobileController,
              hintText: "Enter your mobile number",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              "Email",
              emailController,
              hintText: "Enter your email",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Gender", style: ConstStyle.smallText),
                const SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    value: gender,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          color: ConstColors.textFieldBorderColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          color: ConstColors.textFieldBorderColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          color: ConstColors.textFieldBorderColor,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    dropdownColor: ConstColors.textColorWhit,
                    items: ['Male', 'Female', 'Other']
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, style: ConstStyle.smallText),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => gender = val);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            _buildTextField(
              "DOB",
              dobController,
              hintText: "DD/MM/YYYY",
              keyboardType: TextInputType.datetime,
            ),

            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: CustomLoadingButton(
                      text: "Cancel",
                      backgroundColor: ConstColors.appBarBackgroundcolor,
                      textStyle: ConstStyle.smallText3,
                      borderRadius: BorderRadius.circular(6),
                      asyncTask: () async {
                        await Future.delayed(const Duration(seconds: 2));
                      },
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: CustomLoadingButton(
                      text: "Update",
                      backgroundColor: ConstColors.appBarBackgroundcolor,
                      textStyle: ConstStyle.smallText3,
                      borderRadius: BorderRadius.circular(6),
                      asyncTask: () async {
                        await Future.delayed(const Duration(seconds: 2));
                      },
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 1, thickness: 1, color: Colors.grey.shade400),
          Container(
            height: SizeConfig.getProportionateScreenHeight(60),
            color: ConstColors.appBarBackgroundcolor,
            child: Center(child: AdsScreen()),
          ),
        ],
      ),
    );
  }
}
