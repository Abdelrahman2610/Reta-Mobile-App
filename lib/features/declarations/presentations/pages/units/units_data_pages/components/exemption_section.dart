import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../components/app_text.dart';
import '../../../../../../components/app_text_form_field.dart';
import '../../../../components/app_drop_down.dart';
import '../../../../components/app_drop_down_option.dart';
import '../../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../../cubit/units/unit_data/unit_data_state.dart';

class ExemptionSection extends StatelessWidget {
  const ExemptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();
    return BlocBuilder<UnitDataCubit, UnitDataState>(
      buildWhen: (prev, curr) =>
          prev.isExempt != curr.isExempt ||
          prev.selectedExemptionReason != curr.selectedExemptionReason,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: state.isExempt,
                  onChanged: (v) => cubit.toggleExempt(v ?? false),
                  activeColor: AppColors.highlightDarkest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(4.r),
                  ),
                ),
                AppText(
                  text: 'هل الوحدة معفاة؟',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutralDarkDark,
                ),
              ],
            ),

            if (state.isExempt) ...[
              16.hs,
              AppDropdownField<String>(
                labelText: 'سبب الإعفاء',
                labelRequired: true,
                hintText: 'اختر سبب الإعفاء',
                value: state.selectedExemptionReason,
                items: cubit.exemptionReasons
                    .map((r) => appDropDownOption(label: r))
                    .toList(),
                onChanged: cubit.selectExemptionReason,
                validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
              ),

              if (state.selectedExemptionReason == 'إعفاء بقانون خاص') ...[
                16.hs,
                AppTextFormField(
                  labelText: 'رقم القانون',
                  labelRequired: true,
                  controller: cubit.lawNumberController,
                  hintText: 'إدخل رقم القانون',
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                16.hs,
                AppTextFormField(
                  labelText: 'سنة القانون',
                  labelRequired: true,
                  controller: cubit.lawYearController,
                  hintText: 'إدخل سنة القانون',
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
              ],
            ],
          ],
        );
      },
    );
  }
}
