import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.label,
    this.icon,
    this.iconLeft = true,
    this.onTap,
    this.backgroundColor,
    this.width = double.infinity,
    this.height = 40,
    this.fontSize = 14,
    this.textColor = Colors.white,
    this.withBorder = true,
    this.borderRadius,
    this.fontWeight,
    this.borderColor,
    this.maxLines,
  });

  final String? label;
  final Color? backgroundColor;
  final Widget? icon;
  final bool iconLeft;

  final VoidCallback? onTap;
  final double width;
  final double height;
  final double fontSize;
  final Color textColor;
  final bool withBorder;
  final double? borderRadius;
  final FontWeight? fontWeight;

  final Color? borderColor;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? 10.r);

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(
          color: borderColor ?? Colors.white,
          width: withBorder ? 1.w : 0,
        ),
        color: backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: radius.r,
        child: InkWell(
          onTap: onTap,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (icon == null) {
      return _labelWidget();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconLeft
          ? [_labelWidget(), SizedBox(width: 6.w), icon!]
          : [icon!, SizedBox(width: 6.w), _labelWidget()],
    );
  }

  Widget _labelWidget() {
    return Text(
      label ?? '',
      maxLines: maxLines ?? 1,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize.sp,
        decoration: TextDecoration.none,
        fontWeight: fontWeight,
      ),
    );
  }
}
