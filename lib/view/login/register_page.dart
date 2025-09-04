import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/login%20controller/register_controller.dart';
import 'package:learning_a_to_z/view/login/LoginPage.dart';
import 'package:learning_a_to_z/view/login/otp_verify_page.dart';
import 'package:learning_a_to_z/widgets/custom_rounded_button.dart';
import 'package:learning_a_to_z/widgets/custom_text_form_field.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedValue;
  final RegisterController controller = Get.put(RegisterController());
  final RoundedLoadingButtonController _loginController =
      RoundedLoadingButtonController();

  void _onButtonPressed(
    RoundedLoadingButtonController controller, {
    bool shouldFail = false,
  }) {
    Timer(const Duration(seconds: 2), () {
      if (shouldFail) {
        controller.error();
      } else {
        controller.success();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loginController.stateStream.listen((state) {
      debugPrint("Login Button State: $state");
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(13)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.getProportionateScreenHeight(8)),
              SizedBox(
                height: SizeConfig.getProportionateScreenHeight(334),
                width: double.infinity,
                child: Image.asset(
                  "assets/images/Register Image.png",
                  fit: BoxFit.cover,
                ),
              ),
              Obx(
                () => Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name Field
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(47),
                        width: double.infinity,
                        child: CustomTextFormField(
                          controller: controller.passwordController,
                          hintText: "Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name cannot be empty';
                            } else if (value.length < 6) {
                              return 'Name must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(22),
                      ),
                      // Email Field
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(47),
                        width: double.infinity,
                        child: CustomTextFormField(
                          controller: controller.passwordController,
                          hintText: "Email",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email cannot be empty';
                            } else if (value.length < 6) {
                              return 'Email must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(22),
                      ),

                      // Password Field
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(47),
                        width: double.infinity,
                        child: CustomTextFormField(
                          controller: controller.passwordController,
                          hintText: "Password",
                          obscureText: controller.isPasswordHidden.value,
                          toggleVisibility: controller.togglePasswordVisibility,
                          showSuffixIcon: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be empty';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(22),
                      ),

                      // Confirm Password Field
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(47),
                        width: double.infinity,
                        child: CustomTextFormField(
                          controller: controller.passwordController,
                          hintText: "Confirm Password",
                          obscureText: controller.isPasswordHidden.value,
                          toggleVisibility: controller.togglePasswordVisibility,
                          showSuffixIcon: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be empty';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(22),
                      ),

                      // Submit Button
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(47),
                        width: SizeConfig.getProportionateScreenWidth(160),
                        child: CustomLoadingButton(
                          controller: _loginController,

                          text: "SignUp",
                          backgroundColor: ConstColors.appBarBackgroundcolor,
                          textStyle: ConstStyle.smallText3,
                          borderRadius: BorderRadius.circular(6),
                          asyncTask: () async {
                            await Future.delayed(const Duration(seconds: 2));
                          },
                          onPressed: () {
                            // if (_formKey.currentState!.validate()) {
                            _onButtonPressed(_loginController);
                            print("Form valid, submitting...");
                            Get.to(() => OTPVerifyPage());
                            // }
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(20),
                      ),

                      RichText(
                        text: TextSpan(
                          text: "Already have an account ?  ",
                          style: ConstStyle.smallText,
                          children: [
                            TextSpan(
                              text: "Login",
                              style: ConstStyle.smallText2,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => LoginPage());
                                },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
