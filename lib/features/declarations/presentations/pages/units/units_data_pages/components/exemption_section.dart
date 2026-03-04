import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/features/components/image_svg_custom_widget.dart';

import '../../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../components/app_text.dart';
import '../../../../../../components/app_text_form_field.dart';
import '../../../../components/app_drop_down.dart';
import '../../../../components/app_drop_down_option.dart';
import '../../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../../cubit/units/unit_data/unit_data_state.dart';

class ExemptionSection extends StatelessWidget {
  const ExemptionSection({super.key, this.isWithInfo = false});

  final bool isWithInfo;

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
                GestureDetector(
                  onTap: () => cubit.toggleExempt(!state.isExempt),
                  child: Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: state.isExempt
                            ? AppColors.highlightDarkest
                            : AppColors.neutralLightDarkest,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                      color: state.isExempt
                          ? AppColors.highlightDarkest
                          : Colors.transparent,
                    ),
                    child: state.isExempt
                        ? Icon(Icons.check, color: Colors.white, size: 14.sp)
                        : null,
                  ),
                ),
                12.ws,
                Expanded(
                  child: AppText(
                    text: 'هل الوحدة معفاة؟',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutralDarkDark,
                  ),
                ),
                if (isWithInfo)
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (dialogContext) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ImageSvgCustomWidget(
                                  imgPath: FixedAssets.instance.infoIC,
                                ),
                                12.ws,
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppText(
                                        text: 'قواعد إعفاء الوحدة الخدمية',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.neutralDarkDark,
                                        textAlign: TextAlign.center,
                                      ),

                                      AppText(
                                        text:
                                            'الدليل الإرشادي يوضح قواعد إعفاء الوحدة الخدمية',
                                        fontSize: 14.sp,
                                        color: AppColors.neutralDarkDark,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                12.ws,
                                GestureDetector(
                                  onTap: () => Navigator.pop(dialogContext),
                                  child: Icon(
                                    Icons.close,
                                    color: AppColors.neutralDarkDark,
                                    size: 20.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: ImageSvgCustomWidget(
                      imgPath: FixedAssets.instance.infoIC,
                    ),
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
