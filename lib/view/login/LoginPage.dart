import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/login%20controller/login_controller.dart';
import 'package:learning_a_to_z/view/bottom%20bar/bottom_navigate_bar.dart';
import 'package:learning_a_to_z/view/login/otp_verify_page.dart';
import 'package:learning_a_to_z/view/login/register_page.dart';
import 'package:learning_a_to_z/view/login/reset_password_page.dart';
import 'package:learning_a_to_z/widgets/custom_rounded_button.dart';
import 'package:learning_a_to_z/widgets/custom_text_form_field.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController controller = Get.put(LoginController());
  final RoundedLoadingButtonController _loginController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _registerController =
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

  void _resetAllButtons() {
    _loginController.reset();
    _registerController.reset();
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
              SizedBox(height: SizeConfig.getProportionateScreenHeight(27)),
              Image.asset(
                "assets/images/Login Image.png",
                height: SizeConfig.getProportionateScreenHeight(419),
                width: SizeConfig.screenWidth,
              ),
              Obx(
                () => Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(47),
                        width: SizeConfig.screenWidth,
                        child: CustomTextFormField(
                          controller: controller.emailController,
                          hintText: "Email",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email cannot be empty';
                            } else if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(35),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(47),
                        width: SizeConfig.screenWidth,
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
                        height: SizeConfig.getProportionateScreenHeight(5),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Get.offAll(() => ResetPasswordPage());
                          },
                          child: Text(
                            "Forgot Password",
                            style: ConstStyle.smallText,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(27),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(47),
                        width: SizeConfig.screenWidth / 2.5,
                        child: CustomLoadingButton(
                          controller: _loginController,

                          text: "Login",
                          backgroundColor: ConstColors.appBarBackgroundcolor,
                          textStyle: ConstStyle.smallText3,
                          borderRadius: BorderRadius.circular(6),
                          asyncTask: () async {
                            await Future.delayed(const Duration(seconds: 2));
                          },
                          onPressed: () {
                            // if (_formKey.currentState!.validate()) {
                            Get.to(() => BottomNavigatBarScreen());
                            print("Form valid, submitting...");
                            // }
                          },
                        ),
                      ),

                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(30),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Don't have an account ? ",
                          style: ConstStyle.smallText,
                          children: [
                            TextSpan(
                              text: "Register",
                              style: ConstStyle.smallText2,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => RegisterPage());
                                },
                            ),
                          ],
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
    );
  }
}
