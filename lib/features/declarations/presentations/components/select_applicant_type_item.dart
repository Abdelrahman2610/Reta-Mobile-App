import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';
import '../../../components/inkwell_transparent.dart';

class SelectApplicantTypeItem extends StatefulWidget {
  final String title;
  final String subTitle;
  final bool isOther;
  final Function onPress;

  const SelectApplicantTypeItem({
    super.key,
    required this.onPress,
    required this.title,
    required this.subTitle,
    this.isOther = false,
  });

  @override
  State<SelectApplicantTypeItem> createState() =>
      _SelectApplicantTypeItemState();
}

class _SelectApplicantTypeItemState extends State<SelectApplicantTypeItem> {
  bool isOtherEditable = false;

  @override
  Widget build(BuildContext context) {
    return InkwellTransparent(
      onTap: () {
        if (!widget.isOther) {
          widget.onPress();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.neutralLightLight,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: widget.title,
                          color: AppColors.mainBlueIndigoDye,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        if (widget.isOther)
                          Row(
                            children: [
                              InkwellTransparent(
                                onTap: () {
                                  isOtherEditable = !isOtherEditable;
                                  setState(() {});
                                },
                                child: AppText(
                                  text: isOtherEditable ? "يلغي" : "تعديل",
                                  color: AppColors.highlightDarkest,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  textDecoration: TextDecoration.underline,
                                  decorationColor: AppColors.highlightDarkest,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    AppText(
                      text: widget.subTitle,
                      maxLines: 4,
                      color: AppColors.neutralDarkLight,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5.w),
              if (!widget.isOther)
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: AppColors.neutralDarkLightest,
                  size: 15,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
