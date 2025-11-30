import 'package:flutter/material.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';

/// Controller to manually control the loading button
class CustomLoadingButtonController {
  VoidCallback? _startLoading;
  VoidCallback? _stopLoading;

  void _bind(VoidCallback start, VoidCallback stop) {
    _startLoading = start;
    _stopLoading = stop;
  }

  /// Call this to show loader
  void startLoading() {
    _startLoading?.call();
  }

  /// Call this to hide loader
  void stopLoading() {
    _stopLoading?.call();
  }
}

class CustomLoadingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color bordercolor;
  final Color loaderColor;
  final TextStyle? textStyle;
  final BorderRadiusGeometry borderRadius;
  final Future<void> Function()? asyncTask;
  final CustomLoadingButtonController? controller;

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

  @override
  void initState() {
    super.initState();

    /// Bind controller if provided
    widget.controller?._bind(
      () => setState(() => _isLoading = true),
      () => setState(() => _isLoading = false),
    );
  }

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
