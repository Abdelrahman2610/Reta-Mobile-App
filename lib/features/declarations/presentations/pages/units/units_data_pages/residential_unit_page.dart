import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/features/components/app_check_box.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../components/app_container.dart';
import '../../../../../components/app_text.dart';
import '../../../../../components/app_text_form_field.dart';
import '../../../components/app_drop_down.dart';
import '../../../components/app_drop_down_option.dart';
import '../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../cubit/units/unit_data/unit_data_state.dart';
import 'components/additional_documents_section.dart';
import 'components/file_upload_field.dart';
import 'components/floor_unit_section.dart';
import 'components/private_residence.dart';
import 'components/tax_contact_section.dart';

class ResidentialUnitPage extends StatelessWidget {
  const ResidentialUnitPage({
    super.key,
    required this.unitCubit,
    required this.applicantType,
  });

  final ApplicantType applicantType;
  final UnitDataCubit unitCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: unitCubit,
      child: _ResidentialUnitView(applicantType),
    );
  }
}

class _ResidentialUnitView extends StatelessWidget {
  const _ResidentialUnitView(this.applicantType);

  final ApplicantType applicantType;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();
    return Form(
      key: cubit.formKey,
      child: AppContainer(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          children: [
            AppText(
              text: 'بيانات الوحدة السكنية',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.mainBlueIndigoDye,
            ),
            24.hs,
            if (applicantType != ApplicantType.sharedOwnership)
              BlocBuilder<UnitDataCubit, UnitDataState>(
                buildWhen: (prev, curr) => prev.isExempt != curr.isExempt,
                builder: (context, state) {
                  return Column(
                    children: [
                      PrivateResidence(
                        isSelected: state.isExempt,
                        onTap: cubit.changePrivateResidence,
                      ),
                      16.hs,
                    ],
                  );
                },
              ),

            const FloorUnitSection(),
            16.hs,

            AppTextFormField(
              labelText: 'نوع الإستخدام',
              controller: TextEditingController(text: 'سكني'),
              enabled: false,
              filledColor: AppColors.neutralLightLight,
            ),
            16.hs,

            const TaxContactSection(),
            16.hs,

            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.contactedTaxAuthority != curr.contactedTaxAuthority,
              builder: (context, state) {
                return (state.contactedTaxAuthority ?? false)
                    ? Column(
                        children: [
                          AppTextFormField(
                            labelText: 'كود حساب الوحدة',
                            controller: cubit.unitCodeController,
                            hintText: 'ادخل كود حساب الوحدة',
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v == null || v.isEmpty) return null;
                              if (v.length != 14) return 'يجب أن يكون 14 رقماً';
                              if (!RegExp(r'^\d+$').hasMatch(v)) {
                                return 'يجب أن يحتوي على أرقام فقط';
                              }
                              return null;
                            },
                          ),
                          16.hs,
                        ],
                      )
                    : SizedBox.shrink();
              },
            ),

            AppTextFormField(
              labelText: 'المساحة',
              labelRequired: true,
              controller: cubit.areaController,
              hintText: 'المساحة بالمتر المربع',
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';
                if (double.tryParse(v) == null) {
                  return 'يجب إدخال رقم صحيح';
                }
                if (double.parse(v) <= 0) {
                  return 'يجب أن تكون المساحة أكبر من صفر';
                }
                return null;
              },
            ),
            16.hs,

            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.selectedUnitSubType != curr.selectedUnitSubType,
              builder: (context, state) {
                return AppDropdownField<String>(
                  labelText: 'نوع الوحدة',
                  labelRequired: true,
                  hintText: 'اختر نوع الوحدة',
                  value: state.selectedUnitSubType,
                  items: cubit.residentialUnitTypes
                      .map((t) => appDropDownOption(label: t))
                      .toList(),
                  onChanged: cubit.selectUnitSubType,
                  validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
                );
              },
            ),
            16.hs,

            AppText(
              text: 'ملحق بالوحدة',
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.neutralDarkDark,
            ),
            8.hs,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.transparent,
                border: Border.all(color: AppColors.neutralLightDarkest),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: BlocBuilder<UnitDataCubit, UnitDataState>(
                buildWhen: (prev, curr) =>
                    prev.selectedAmenities != curr.selectedAmenities,
                builder: (context, state) {
                  return GridView.count(
                    padding: EdgeInsets.zero,
                    crossAxisCount: 3,
                    mainAxisSpacing: 12.h,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 3,
                    children: cubit.amenities.map((amenity) {
                      final isSelected =
                          state.selectedAmenities?.contains(amenity) ?? false;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppCheckBox(
                            isSelected: isSelected,
                            onTap: () => cubit.toggleAmenity(amenity),
                          ),
                          6.ws,
                          AppText(
                            text: amenity,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.neutralDarkLightest,
                          ),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            16.hs,

            AppTextFormField(
              labelText: 'القيمة السوقية للوحدة',
              controller: cubit.marketValueController,
              hintText: 'ادخل القيمة السوقية للوحدة',
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return null;
                if (double.tryParse(v) == null) {
                  return 'يجب إدخال رقم صحيح';
                }
                return null;
              },
            ),
            16.hs,

            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.ownershipDeedFullUrl != curr.ownershipDeedFullUrl,
              builder: (context, state) {
                return FileUploadField(
                  labelText: 'سند تمليك الوحدة',
                  text: 'حمل ملف',
                  backgroundColor: AppColors.highlightDarkest,
                  textColor: AppColors.white,
                  filePath: state.ownershipDeedFullUrl,
                  onFilePicked: () async {
                    final path = await cubit.pickFile();
                    if (path != null) {
                      cubit.setOwnershipDeedFile(path);
                    }
                  },
                  onFileRemoved: () => cubit.removeOwnershipDeedFile(),
                );
              },
            ),
            16.hs,

            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.leaseContractFullUrl != curr.leaseContractFullUrl,
              builder: (context, state) {
                return FileUploadField(
                  labelText: 'عقد الإيجار (إن وجد)',
                  filePath: state.leaseContractFullUrl,
                  text: 'حمل ملف',
                  backgroundColor: AppColors.highlightDarkest,
                  textColor: AppColors.white,
                  onFilePicked: () async {
                    final path = await cubit.pickFile();
                    if (path != null) cubit.setLeaseContractFile(path);
                  },
                  onFileRemoved: () => cubit.removeLeaseContractFile(),
                );
              },
            ),
            16.hs,

            const AdditionalDocumentsSection(),
          ],
        ),
      ),
    );
  }
}
