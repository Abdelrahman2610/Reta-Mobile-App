import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';
import '../../data/models/available_banks.dart';

class BankItem extends StatelessWidget {
  const BankItem({super.key, required this.availableBank});

  final AvailableBanks availableBank;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.neutralLightDark),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.neutralLightDark),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Image.asset(availableBank.imagePath ?? ''),
          ),
          10.ws,
          Expanded(
            child: AppText(
              text: availableBank.title,
              color: AppColors.neutralDarkLight,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
