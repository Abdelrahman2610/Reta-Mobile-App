import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_check_box.dart';
import '../../../components/app_text.dart';

class CheckBoxWithTitle extends StatelessWidget {
  const CheckBoxWithTitle({
    super.key,
    required this.isSelected,
    required this.label,
    this.onSelectTapped,
  });

  final bool isSelected;
  final String label;
  final VoidCallback? onSelectTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppCheckBox(isSelected: isSelected, onTap: onSelectTapped),
        12.ws,
        Expanded(
          child: AppText(
            text: label,
            maxLines: 2,
            color: AppColors.neutralDarkDark,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
