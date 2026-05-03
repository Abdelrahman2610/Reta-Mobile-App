import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/components/drop_down_icon.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';

class AppDropdownField<T> extends StatelessWidget {
  final String labelText;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String? displayText;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool labelRequired;
  final bool enabled;
  final Widget? prefixWidget;
  final Color? filledColor;
  final String? infoText;
  final double? labelFontSize;
  final Color? labelColor;

  const AppDropdownField({
    super.key,
    required this.labelText,
    required this.items,
    this.hintText = '',
    this.value,
    this.displayText,
    this.onChanged,
    this.validator,
    this.labelRequired = false,
    this.enabled = true,
    this.prefixWidget,
    this.filledColor,
    this.infoText,
    this.labelFontSize,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: RichText(
            softWrap: true,
            overflow: TextOverflow.visible,
            text: TextSpan(
              children: [
                TextSpan(
                  text: labelText,
                  style: TextStyle(
                    fontSize: labelFontSize ?? 14.sp,
                    fontFamily: 'NotoSansArabic',
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
        ),
        8.hs,

        Directionality(
          textDirection: TextDirection.rtl,
          child: DropdownButtonFormField2<T>(
            value: value,
            items: items,
            onChanged: enabled ? onChanged : null,
            validator: validator,
            isExpanded: true,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.neutralDarkLightest,
              fontWeight: FontWeight.w400,
            ),
            hint: Row(
              children: [
                Expanded(
                  child: Text(
                    hintText,
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    style: TextStyle(
                      color: AppColors.neutralDarkDarkest,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            buttonStyleData: ButtonStyleData(
              height: 48.h,
              padding: EdgeInsets.only(left: 2.w),
              decoration: BoxDecoration(color: Colors.transparent),
            ),
            iconStyleData: IconStyleData(
              icon: DropDownIcon(),
              openMenuIcon: DropDownIcon(isOpened: true),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 300.h,
              offset: Offset(0, -4.h),
              isOverButton: false,
              useSafeArea: true,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              scrollbarTheme: ScrollbarThemeData(
                radius: Radius.circular(40.r),
                thickness: WidgetStateProperty.all(6),
                thumbVisibility: WidgetStateProperty.all(true),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              selectedMenuItemBuilder: (context, child) => Container(
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: AppColors.highlightLightest,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: child,
              ),
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
              hintMaxLines: 2,
              helperMaxLines: 2,
              prefixIcon: prefixWidget,
              prefixIconConstraints: BoxConstraints(
                maxHeight: 48.h,
                minWidth: 48.w,
              ),
              filled: filledColor != null,
              fillColor: filledColor,
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
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.errorDark),
              ),
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
