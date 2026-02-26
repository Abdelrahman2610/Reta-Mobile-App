import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? backButtonAction;
  final String title;
  final Color backgroundColor;
  final Color? backButtonIconColor;
  final TextStyle titleTextStyle;
  final bool? isTitleCenter;
  final List<Widget>? actions;

  const MainAppBar({
    super.key,
    this.backButtonAction,
    this.actions,
    this.isTitleCenter = true,
    required this.title,
    required this.backgroundColor,
    this.backButtonIconColor,
    required this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: isTitleCenter,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: backButtonIconColor),
          onPressed: backButtonAction ?? () => Navigator.maybePop(context),
        ),
        title: Text(title, style: titleTextStyle),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
