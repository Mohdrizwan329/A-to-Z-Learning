import 'package:flutter/material.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CustomLoadingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color bordercolor;
  final Color loaderColor;
  final TextStyle? textStyle;
  final BorderRadiusGeometry borderRadius;
  final Future<void> Function()? asyncTask;

  final RoundedLoadingButtonController? controller;

  const CustomLoadingButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = ConstColors.appBarBackgroundcolor,
    this.textStyle,
    this.bordercolor = ConstColors.textColorWhit,
    this.borderRadius = const BorderRadius.all(Radius.circular(50)),
    this.asyncTask,
    this.loaderColor = Colors.white,
    this.controller,
  }) : super(key: key);

  @override
  State<CustomLoadingButton> createState() => _CustomLoadingButtonState();
}

class _CustomLoadingButtonState extends State<CustomLoadingButton> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    if (widget.asyncTask != null) {
      await widget.asyncTask!();
    } else {
      await Future.delayed(const Duration(seconds: 3));
    }

    setState(() => _isLoading = false);

    widget.onPressed();

    widget.controller?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: widget.bordercolor),
        backgroundColor: widget.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: widget.borderRadius),
      ),
      onPressed: _handleTap,
      child: _isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(widget.loaderColor),
              ),
            )
          : Text(widget.text, style: widget.textStyle),
    );
  }
}
