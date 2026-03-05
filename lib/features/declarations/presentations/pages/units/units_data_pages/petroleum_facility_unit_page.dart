import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../components/app_container.dart';
import '../../../../../components/app_text.dart';
import '../../../../../components/app_text_form_field.dart';
import '../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../cubit/units/unit_data/unit_data_state.dart';
import 'components/additional_documents_section.dart';
import 'components/app_counter.dart';
import 'components/tax_contact_section.dart';
import 'components/title_with_divider.dart';

class PetroleumFacilityUnitPage extends StatelessWidget {
  const PetroleumFacilityUnitPage({super.key, required this.unitCubit});

  final UnitDataCubit unitCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: unitCubit,
      child: const _PetroleumFacilityUnitView(),
    );
  }
}

class _PetroleumFacilityUnitView extends StatelessWidget {
  const _PetroleumFacilityUnitView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();

    return Form(
      key: cubit.formKey,
      child: AppContainer(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText(
              text: 'بيانات المنشأة البترولية',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.mainBlueIndigoDye,
            ),
            24.hs,

            AppTextFormField(
              labelText: 'أسم المنشأة',
              labelRequired: true,
              controller: cubit.petroleumFacilityNameController,
              hintText: 'ادخل أسم المنشأة',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,
            AppTextFormField(
              labelText: 'نوع الإستخدام',
              labelRequired: true,
              controller: cubit.usageTypeController,
              hintText: 'ادخل نوع الإستخدام',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,
            AppTextFormField(
              labelText: 'مساحة الأرض الكلية',
              labelRequired: true,
              controller: cubit.totalLandArea,
              keyboardType: TextInputType.number,
              hintText: 'المساحة الإجمالية بالمتر المربع',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,
            AppTextFormField(
              labelText: 'مساحة الأرض المستغلة',
              labelRequired: true,
              controller: cubit.totalLandUtilized,
              keyboardType: TextInputType.number,
              hintText: 'المساحة الإجمالية بالمتر المربع',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,
            AppTextFormField(
              labelText: 'التكلفة الدفترية للأرض',
              labelRequired: false,
              controller: cubit.bookValueController,
              keyboardType: TextInputType.number,
              hintText: 'إدخل التكلفة الدفترية للأرض',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,
            TitleWithDivider(
              // title: 'ملحقات الفندق - وحدة (${widget.index + 1})',
              title: 'وصف المباني',
              fontSize: 16.sp,
            ),
            16.hs,

            // ── عدد المباني (buildings_count) ──────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.buildingsCount != curr.buildingsCount,
              builder: (context, state) => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppText(
                    text: 'عدد المباني',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutralDarkDark,
                  ),
                  AppText(
                    text: ' *',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.errorDark,
                  ),
                  const Spacer(),
                  AppCounter(
                    count: state.buildingsCount,
                    onDecrement: () {
                      if (cubit.state.buildingsCount > 1) {
                        cubit.emit(
                          cubit.state.copyWith(
                            buildingsCount: cubit.state.buildingsCount - 1,
                          ),
                        );
                      }
                    },
                    onIncrement: () => cubit.emit(
                      cubit.state.copyWith(
                        buildingsCount: cubit.state.buildingsCount + 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            16.hs,

            // ── هل تم التواصل مع الضرائب؟ (reta_contact_about_unit) ─
            const TaxContactSection(
              customLabel:
                  'هل تم التواصل مع الضرائب العقارية بخصوص المنشأة محل الإقرار سابقاً؟',
            ),
            16.hs,

            // ── كود حساب المنشأة (account_code) ────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.contactedTaxAuthority != curr.contactedTaxAuthority,
              builder: (context, state) {
                return (state.contactedTaxAuthority ?? false)
                    ? Column(
                        children: [
                          AppTextFormField(
                            labelText: 'كود حساب المنشأة',
                            controller: cubit.unitCodeController,
                            hintText: 'ادخل كود حساب المنشأة',
                            keyboardType: TextInputType.number,
                          ),
                          16.hs,
                        ],
                      )
                    : const SizedBox.shrink();
              },
            ),

            // ── مستندات داعمة أخرى (supporting_documents) ──────────
            const AdditionalDocumentsSection(title: 'مستندات داعمة أخرى'),
            16.hs,
          ],
        ),
      ),
    );
  }
}
