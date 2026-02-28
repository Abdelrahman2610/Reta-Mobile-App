import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../components/app_container.dart';
import '../../../../components/add_new_property_button.dart';
import '../../../../components/cancel_declaration_button.dart';
import '../../../../components/submit_declaration_button.dart';
import '../../../../cubit/units/unit_data/unit_data_cubit.dart';

class UnitButtons extends StatelessWidget {
  const UnitButtons({
    super.key,
    required this.cubit,
    required this.onSaveData,
    required this.onCancel,
    required this.onSaveAndAddOther,
  });

  final UnitDataCubit cubit;
  final VoidCallback onSaveData;
  final VoidCallback onCancel;
  final VoidCallback onSaveAndAddOther;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        children: [
          AddNewPropertyButton(
            label: 'حفظ وإضافة وحدة أخرى في ذات العقار',
            padding: EdgeInsets.zero,
            onAdd: onSaveAndAddOther,
          ),
          16.hs,
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                flex: 5,
                child: SubmitDeclarationButton(
                  label: 'حفظ البيانات',
                  borderColor: AppColors.successDark,
                  withIcon: false,
                  onSubmit: onSaveData,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 3,
                child: CancelDeclarationButton(
                  label: 'إلغاء',
                  onCancel: onCancel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
