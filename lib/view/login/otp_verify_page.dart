import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view%20model/login%20controller/otp_controller.dart';
import 'package:learning_a_to_z/view/login/otp_success_page.dart';
import 'package:learning_a_to_z/widgets/custom_otp_box.dart';
import 'package:learning_a_to_z/widgets/custom_rounded_button.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class OTPVerifyPage extends StatefulWidget {
  @override
  State<OTPVerifyPage> createState() => _OTPVerifyPageState();
}

class _OTPVerifyPageState extends State<OTPVerifyPage> {
  final controller = Get.put(OTPController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final RoundedLoadingButtonController _OTPController =
      RoundedLoadingButtonController();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

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
    _OTPController.stateStream.listen((state) {
      debugPrint("OTP Button State: $state");
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _submitOtp() {
    final otp = _controllers.map((e) => e.text).join();
    print("Entered OTP: $otp");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(13)),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.getProportionateScreenHeight(45)),

            Image.asset(
              'assets/images/Otp Image.png',
              height: SizeConfig.getProportionateScreenHeight(354),
              width: SizeConfig.getProportionateScreenWidth(394),
              fit: BoxFit.cover,
            ),

            SizedBox(height: SizeConfig.getProportionateScreenHeight(10)),

            Text(
              "We will send you OTP via email to continue.",
              textAlign: TextAlign.center,
              style: ConstStyle.otpPageText,
            ),

            SizedBox(height: SizeConfig.getProportionateScreenHeight(36)),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionateScreenWidth(15),
                  ),
                  child: CustomOtpBox(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    nextFocus: index < 3 ? _focusNodes[index + 1] : null,
                    onChanged: (val) {
                      if (index == 5 && val.isNotEmpty) {
                        _submitOtp();
                      }
                    },
                  ),
                );
              }),
            ),

            SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionateScreenWidth(13),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Don't Get it ? ",
                      style: ConstStyle.smallText1,
                      children: [
                        TextSpan(
                          text: "Resend code",
                          style: ConstStyle.smallText2,
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                  Text("60 sec", style: ConstStyle.smallText1),
                ],
              ),
            ),

            SizedBox(height: SizeConfig.getProportionateScreenHeight(92)),

            SizedBox(
              height: SizeConfig.getProportionateScreenHeight(47),
              width: SizeConfig.screenWidth / 2.3,
              child: CustomLoadingButton(
                controller: _OTPController,

                text: "Verify OTP",
                backgroundColor: ConstColors.appBarBackgroundcolor,
                textStyle: ConstStyle.smallText3,
                borderRadius: BorderRadius.circular(6),
                asyncTask: () async {
                  await Future.delayed(const Duration(seconds: 2));
                },
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                  Get.to(() => OTPSuccessPage());
                  print("OTP submitted");
                  // }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
