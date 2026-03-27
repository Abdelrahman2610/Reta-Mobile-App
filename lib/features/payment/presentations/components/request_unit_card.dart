import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/payment/presentations/components/unit_header.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/payment_unit_item.dart';
import 'amount_row.dart';

class RequestUnitCard extends StatelessWidget {
  final PaymentUnitItemModel unit;
  final VoidCallback onToggleSelect;
  final ValueChanged<bool> onToggleWallet;

  const RequestUnitCard({
    super.key,
    required this.unit,
    required this.onToggleSelect,
    required this.onToggleWallet,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unit.isChecked ? 0.7 : 1,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: unit.isChecked
              ? AppColors.neutralLightLightest
              : unit.isSelected
              ? AppColors.highlightLightest
              : AppColors.neutralLightLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.neutralLightDarkest, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Unit header row
            UnitHeader(
              unit: unit,
              onToggleSelect: onToggleSelect,
              isChecked: unit.isChecked,
            ),
            12.hs,
            Divider(color: AppColors.neutralLightDarkest),
            6.hs,
            AmountRow(
              label: 'المبلغ المطلوب سداده',
              amount: unit.amountUnderPayment.toStringAsFixed(2),
            ),
            15.hs,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.neutralLightDarkest),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AmountRow(
                      label: 'المبلغ الجاري سداده',
                      amount: unit.requiredAmount?.toStringAsFixed(2),
                      backgroundColor: AppColors.neutralLightMedium,
                    ),
                  ),
                  12.ws,
                  Expanded(
                    child: AmountRow(
                      label: 'المبلغ المسدد',
                      amount: unit.paidAmount?.toStringAsFixed(2),
                      backgroundColor: AppColors.neutralLightMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
