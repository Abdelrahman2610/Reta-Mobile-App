import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/payment/presentations/components/payment_selected_box.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';

class UnitHeader extends StatelessWidget {
  const UnitHeader({
    super.key,
    required this.unit,
    required this.onToggleSelect,
    required this.isChecked,
  });

  final dynamic unit;
  final VoidCallback onToggleSelect;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PaymentSelectedBox(
          isSelected: unit.isSelected,
          onTap: isChecked ? () {} : onToggleSelect,
        ),
        10.ws,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  AppText(
                    text: unit.propertyType,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainBlueIndigoDye,
                    textAlign: TextAlign.right,
                  ),
                  6.ws,
                  AppText(
                    text: '— ${unit.propertyName}',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutralDarkDark,
                    textAlign: TextAlign.right,
                  ),
                  6.ws,
                ],
              ),
              6.hs,
              AppText(
                text: '${unit.governorate} - ${unit.propertyNumber}',
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.neutralDarkMedium,
                textAlign: TextAlign.right,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
