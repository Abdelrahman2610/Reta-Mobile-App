import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../components/app_check_box.dart';
import '../../../../../../components/app_text.dart';

class PrivateResidence extends StatelessWidget {
  const PrivateResidence({super.key, required this.isSelected, this.onTap});

  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          AppCheckBox(isSelected: isSelected),
          12.ws,
          AppText(
            text: 'معفاة كسكن خاص',
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
            color: AppColors.neutralDarkDark,
          ),
        ],
      ),
    );
  }
}
