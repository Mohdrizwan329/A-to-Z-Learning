import 'package:flutter/material.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final showBackButton;
  final List<Widget>? actions;
  final Color backgroundColor;
  final TextStyle? titleStyle;

  const CustomAppBar({
    Key? key,
    this.title,
    this.titleWidget,
    this.showBackButton,
    this.actions,
    this.backgroundColor = ConstColors.appBarBackgroundcolor,
    this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: showBackButton,
      automaticallyImplyLeading: false,
      title: titleWidget ?? Text(title ?? "", style: ConstStyle.heading2),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
