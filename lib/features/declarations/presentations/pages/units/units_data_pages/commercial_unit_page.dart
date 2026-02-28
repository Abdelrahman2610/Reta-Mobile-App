import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/app_enum.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../components/app_container.dart';
import '../../../../../components/app_text.dart';
import '../../../../../components/app_text_form_field.dart';
import '../../../components/declaration_data_tab.dart';
import '../../../components/units/unit_title.dart';
import '../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../cubit/units/unit_data/unit_data_state.dart';
import 'components/additional_documents_section.dart';
import 'components/file_upload_field.dart';
import 'components/floor_unit_section.dart';
import 'components/private_residence.dart';
import 'components/tax_contact_section.dart';
import 'components/unit_buttons.dart';

class CommercialUnitPage extends StatelessWidget {
  const CommercialUnitPage({
    super.key,
    required this.applicantType,
    required this.unitCubit,
  });

  final ApplicantType applicantType;
  final UnitDataCubit unitCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: unitCubit,
      child: _ResidentialUnitView(applicantType: applicantType),
    );
  }
}

class _ResidentialUnitView extends StatelessWidget {
  const _ResidentialUnitView({required this.applicantType});
  final ApplicantType applicantType;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();
    return Form(
      key: cubit.formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            31.hs,
            UnitTitle(title: 'وحدة تجارية'),
            10.hs,
            AppContainer(
              height: 93,
              child: Row(
                children: [
                  DeclarationDataTab(
                    declarationsType: DeclarationsDataType.locationData,
                    isSelected: false,
                    isFinished: true,
                  ),
                  DeclarationDataTab(
                    declarationsType: DeclarationsDataType.unitData,
                    isSelected: true,
                    isFinished: false,
                  ),
                ],
              ),
            ),
            10.hs,
            AppContainer(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                children: [
                  AppText(
                    text: 'بيانات الوحدة السكنية',
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainBlueIndigoDye,
                  ),
                  24.hs,
                  if (applicantType == ApplicantType.owner)
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

                  const TaxContactSection(),
                  16.hs,

                  AppTextFormField(
                    labelText: 'كود حساب الوحدة',
                    controller: cubit.unitCodeController,
                    hintText: 'ادخل كود حساب الوحدة',
                  ),
                  16.hs,

                  AppTextFormField(
                    labelText: 'نوع الإستخدام',
                    controller: TextEditingController(text: 'غير سكني'),
                    enabled: false,
                    filledColor: AppColors.neutralLightLight,
                  ),
                  16.hs,

                  AppTextFormField(
                    labelText: 'نوع الوحدة',
                    controller: TextEditingController(text: 'تجاري'),
                    enabled: false,
                    filledColor: AppColors.neutralLightLight,
                  ),
                  16.hs,

                  AppTextFormField(
                    labelText: 'المساحة',
                    labelRequired: true,
                    controller: cubit.areaController,
                    hintText: 'ادخل المساحة بالمتر المربع',
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                  16.hs,

                  AppTextFormField(
                    labelText: 'نوع النشاط',
                    labelRequired: true,
                    controller: cubit.activityTypeController,
                    hintText: 'ادخل نوع النشاط',
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                  16.hs,

                  AppTextFormField(
                    labelText: 'القيمة السوقية للوحدة',
                    controller: cubit.marketValueController,
                    hintText: 'ادخل	القيمة السوقية للوحدة التجارية',
                    keyboardType: TextInputType.number,
                  ),
                  16.hs,

                  BlocBuilder<UnitDataCubit, UnitDataState>(
                    buildWhen: (prev, curr) =>
                        prev.ownershipDeedFilePath !=
                        curr.ownershipDeedFilePath,
                    builder: (context, state) {
                      return FileUploadField(
                        labelText: 'سند تمليك الوحدة',
                        labelRequired: true,
                        text: 'حمل ملف',
                        description: 'عقد مسجل/عقد ابتدائي/حكم قضائي',
                        backgroundColor: AppColors.highlightDarkest,
                        textColor: AppColors.white,
                        filePath: state.ownershipDeedFilePath,
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
                        prev.leaseContractFilePath !=
                        curr.leaseContractFilePath,
                    builder: (context, state) {
                      return FileUploadField(
                        labelText: 'عقد الإيجار (إن وجد)',
                        filePath: state.leaseContractFilePath,
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

                  BlocBuilder<UnitDataCubit, UnitDataState>(
                    buildWhen: (prev, curr) =>
                        prev.permitPhotoFilePath != curr.permitPhotoFilePath,
                    builder: (context, state) {
                      return FileUploadField(
                        labelText: 'صورة الرخصة',
                        filePath: state.permitPhotoFilePath,
                        text: 'حمل ملف',
                        backgroundColor: AppColors.highlightDarkest,
                        textColor: AppColors.white,
                        onFilePicked: () async {
                          final path = await cubit.pickFile();
                          if (path != null) cubit.setPermitPhotoFile(path);
                        },
                        onFileRemoved: () => cubit.removePermitPhotoFile(),
                      );
                    },
                  ),
                  16.hs,

                  const AdditionalDocumentsSection(),
                ],
              ),
            ),
            16.hs,

            UnitButtons(
              cubit: cubit,
              onSaveData: () {
                if (cubit.validate()) {
                  cubit.onSaveDataTapped(context, UnitType.commercial);
                }
              },
              onCancel: () => cubit.onCancelButtonTapped(context),
              onSaveAndAddOther: () {
                if (cubit.validate()) {
                  cubit.onSaveAndAddOther(context, UnitType.commercial);
                }
              },
            ),
            26.hs,
          ],
        ),
      ),
    );
  }
}
