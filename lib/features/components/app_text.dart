import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.maxLines,
    this.alignment,
    this.textAlign,
    this.textDecoration,
    this.textDirection,
    this.textOverflow,
  });

  final String? text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLines;
  final dynamic alignment;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  final TextDirection? textDirection;
  final TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? AlignmentDirectional.centerStart,
      child: Text(
        text ?? '',
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign ?? TextAlign.start,
        textDirection: textDirection ?? TextDirection.rtl,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color ?? AppColors.neutralDarkLightest,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'NotoSansArabic',
          overflow: textOverflow,
        ),
      ),
    );
  }
}
