import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';
import '../../../components/app_text_form_field.dart';
import 'filter_app_container.dart';

class BuildTextSection extends StatelessWidget {
  const BuildTextSection({
    super.key,
    required this.label,
    required this.hintLabel,
    required this.onClearTapped,
    required this.controller,
  });

  final String label;
  final String hintLabel;
  final VoidCallback onClearTapped;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return FilterAppContainer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: label,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.neutralDarkDark,
              ),
              GestureDetector(
                onTap: onClearTapped,
                child: AppText(
                  text: 'مسح',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.highlightDarkest,
                ),
              ),
            ],
          ),
          5.hs,
          AppTextFormField(
            controller: controller,
            hintText: hintLabel,
            labelText: '',
            hideLabel: true,
          ),
        ],
      ),
    );
  }
}
