import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helpers/extensions/dimensions.dart';
import '../../core/theme/app_colors.dart';
import 'app_text.dart';

class AppTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final bool labelRequired;
  final int? maxLines;
  final bool? readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final Color? filledColor;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final TextDirection? textDirection;
  final bool enabled;
  final String? infoText;
  final double? labelFontSize;
  final Color? labelColor;
  final String? description;

  const AppTextFormField({
    super.key,
    required this.labelText,
    this.hintText = '',
    this.suffixWidget,
    this.prefixWidget,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.labelRequired = false,
    this.maxLines,
    this.readOnly,
    this.onTap,
    this.inputFormatters,
    this.textInputAction,
    this.filledColor,
    this.onEditingComplete,
    this.focusNode,
    this.textDirection,
    this.enabled = true,
    this.infoText,
    this.labelFontSize,
    this.labelColor,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          softWrap: true,
          overflow: TextOverflow.visible,
          text: TextSpan(
            children: [
              TextSpan(
                text: labelText,
                style: TextStyle(
                  fontSize: labelFontSize ?? 14.sp,
                  fontWeight: FontWeight.w700,
                  color: labelColor ?? AppColors.neutralDarkDark,
                ),
              ),
              if (labelRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: labelFontSize ?? 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.errorDark,
                  ),
                ),
            ],
          ),
        ),
        if (description != null)
          AppText(
            text: description,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.neutralDarkLight,
            maxLines: 2,
          ),
        8.hs,
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          minLines: maxLines != null && maxLines! > 1 ? 1 : null,
          readOnly: readOnly ?? false,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          onTap: onTap,
          enabled: enabled,
          validator: validator,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          textDirection: textDirection,
          style: TextStyle(
            fontSize: 14.0.sp,
            color: enabled
                ? AppColors.neutralDarkDarkest
                : AppColors.neutralDarkLightest,
            fontWeight: FontWeight.w400,
          ),
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          cursorColor: AppColors.black,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),

            prefixIcon: prefixWidget,
            suffixIcon: suffixWidget,
            prefixIconConstraints: BoxConstraints(
              maxHeight: 48.h,
              minWidth: 48.w,
            ),
            filled: filledColor != null,
            fillColor: filledColor,
            suffixIconConstraints: BoxConstraints(
              maxHeight: 48.h,
              minWidth: 48.w,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.neutralDarkLightest,
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.neutralLightDarkest),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.neutralLightDarkest),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.neutralLightDarkest),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.highlightDarkest),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.errorDark),
            ),
          ),
        ),
        if (infoText != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: AppText(
              text: infoText,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.neutralDarkLightest,
            ),
          ),
      ],
    );
  }
}
