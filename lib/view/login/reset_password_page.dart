import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/view%20model/login%20controller/register_controller.dart';
import 'package:learning_a_to_z/view/login/LoginPage.dart';
import 'package:learning_a_to_z/widgets/custom_rounded_button.dart';
import 'package:learning_a_to_z/widgets/custom_text_form_field.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import 'register_page.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final RegisterController controller = Get.put(RegisterController());
  final RoundedLoadingButtonController _loginController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    _loginController.stateStream.listen((state) {
      debugPrint("Login Button State: $state");
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final width = media.width;
    final height = media.height;

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035),
          child: Column(
            children: [
              SizedBox(height: height * 0.08),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.065),
                child: SizedBox(
                  height: height * 0.44,
                  width: width,
                  child: Image.asset(
                    "assets/images/Reset Password Image.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: height * 0.045),

              Obx(
                () => Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.06,
                        width: width,
                        child: CustomTextFormField(
                          controller: controller.passwordController,
                          hintText: "Eibz ID/Number",
                          obscureText: controller.isPasswordHidden.value,
                          toggleVisibility: controller.togglePasswordVisibility,
                          showSuffixIcon: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Eibz ID/Number cannot be empty';
                            } else if (value.length < 6) {
                              return 'Eibz ID/Number must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.03),

                      SizedBox(
                        height: height * 0.06,
                        width: width,
                        child: CustomTextFormField(
                          controller: controller.passwordController,
                          hintText: "New Password",
                          obscureText: controller.isPasswordHidden.value,
                          toggleVisibility: controller.togglePasswordVisibility,
                          showSuffixIcon: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'New Password cannot be empty';
                            } else if (value.length < 6) {
                              return 'New Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.03),

                      SizedBox(
                        height: height * 0.06,
                        width: width,
                        child: CustomTextFormField(
                          controller: controller.passwordController,
                          hintText: "Confirm Password",
                          obscureText: controller.isPasswordHidden.value,
                          toggleVisibility: controller.togglePasswordVisibility,
                          showSuffixIcon: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm Password cannot be empty';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: 40),
                      SizedBox(
                        height: height * 0.055,
                        width: width / 2.3,
                        child: CustomLoadingButton(
                          controller: _loginController,

                          text: "Submit",
                          backgroundColor: ConstColors.appBarBackgroundcolor,
                          textStyle: ConstStyle.smallText3,
                          borderRadius: BorderRadius.circular(6),
                          asyncTask: () async {
                            await Future.delayed(const Duration(seconds: 2));
                          },
                          onPressed: () {
                            // if (_formKey.currentState!.validate()) {
                            _loginController.success();
                            Get.offAll(() => LoginPage());
                            // }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
