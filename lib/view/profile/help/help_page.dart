import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/setting%20controller/help_controller.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:learning_a_to_z/widgets/custom_rounded_button.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final HelpController controller = Get.put(HelpController());
  final _formKey = GlobalKey<FormState>();

  InputDecoration _fieldDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: ConstStyle.smallText,

    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ConstColors.textColor),
    ),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2,
        title: "Help",
        showBackButton: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: ConstColors.textColorWhit,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            children: [
              Text(
                'Your Feedback matters more for us. We are listening',
                style: ConstStyle.smallText,
              ),
              const SizedBox(height: 25),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: _fieldDecoration('Name :'),
                      initialValue: controller.name.value,
                      onSaved: (v) => controller.name.value = v ?? '',
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: _fieldDecoration('Contact number :'),
                      keyboardType: TextInputType.phone,
                      initialValue: controller.phone.value,
                      onSaved: (v) => controller.phone.value = v ?? '',
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: _fieldDecoration('Email id :'),
                      keyboardType: TextInputType.emailAddress,
                      initialValue: controller.email.value,
                      onSaved: (v) => controller.email.value = v ?? '',
                      validator: (v) {
                        if (v != null && v.isNotEmpty) {
                          final emailRegex = RegExp(r'^\S+@\S+\.\S+$');
                          if (!emailRegex.hasMatch(v)) {
                            return 'Invalid email';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 26),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tell us how we can Help You',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ConstColors.textColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                      initialValue: controller.message.value,
                      onSaved: (v) => controller.message.value = v ?? '',
                      maxLines: 6,
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: CustomLoadingButton(
                        // controller: _loginController,
                        text: "Submit",
                        backgroundColor: ConstColors.appBarBackgroundcolor,
                        textStyle: ConstStyle.smallText3,
                        borderRadius: BorderRadius.circular(6),
                        asyncTask: () async {
                          await Future.delayed(const Duration(seconds: 2));
                        },
                        onPressed: () {
                          // controller.submitFeedback(
                          // routeName: 'feedback',
                          // formKey: _formKey,
                          // );
                        },
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
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
