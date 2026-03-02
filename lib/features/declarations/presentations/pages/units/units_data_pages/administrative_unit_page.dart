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
import 'components/file_upload_field.dart';
import 'components/floor_unit_section.dart';
import 'components/tax_contact_section.dart';

class AdministrativeUnitPage extends StatelessWidget {
  const AdministrativeUnitPage({super.key, required this.unitCubit});

  final UnitDataCubit unitCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: unitCubit,
      child: _AdministrativeUnitView(),
    );
  }
}

class _AdministrativeUnitView extends StatelessWidget {
  const _AdministrativeUnitView();

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
              text: 'بيانات الوحدة الإدارية',
              fontWeight: FontWeight.w700,
              color: AppColors.mainBlueIndigoDye,
            ),
            24.hs,

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
              controller: TextEditingController(text: 'إداري'),
              enabled: false,
              filledColor: AppColors.neutralLightLight,
            ),
            16.hs,

            AppTextFormField(
              labelText: 'المساحة',
              labelRequired: true,
              controller: cubit.areaController,
              hintText: 'المساحة بالمتر المربع',
              keyboardType: TextInputType.number,
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,

            // ── نوع النشاط ───────────────────
            AppTextFormField(
              labelText: 'نوع النشاط',
              labelRequired: true,
              controller: cubit.activityTypeController,
              hintText: 'ادخل نوع النشاط',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,

            AppTextFormField(
              labelText: 'القيمة السوقية للوحدة',
              controller: cubit.marketValueController,
              hintText: 'ادخل القيمة السوقية للوحدة',
              keyboardType: TextInputType.number,
            ),
            16.hs,

            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.ownershipDeedFilePath != curr.ownershipDeedFilePath,
              builder: (context, state) {
                return FileUploadField(
                  labelText: 'سند تمليك الوحدة',
                  labelRequired: true,
                  description: 'عقد مسجل/عقد ابتدائي/حكم قضائي',
                  text: 'حمل ملف',
                  backgroundColor: AppColors.highlightDarkest,
                  textColor: AppColors.white,
                  infoText: 'عقد مسجل/عقد ابتدائي/حكم قضائي',
                  filePath: state.ownershipDeedFilePath,
                  onFilePicked: () async {
                    final path = await cubit.pickFile();
                    if (path != null) cubit.setOwnershipDeedFile(path);
                  },
                  onFileRemoved: () => cubit.removeOwnershipDeedFile(),
                );
              },
            ),
            16.hs,

            // ── عقد الإيجار (إن وجد) ─────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.leaseContractFilePath != curr.leaseContractFilePath,
              builder: (context, state) {
                return FileUploadField(
                  labelText: 'عقد الإيجار (إن وجد)',
                  text: 'حمل ملف',
                  backgroundColor: AppColors.highlightDarkest,
                  textColor: AppColors.white,
                  filePath: state.leaseContractFilePath,
                  onFilePicked: () async {
                    final path = await cubit.pickFile();
                    if (path != null) cubit.setLeaseContractFile(path);
                  },
                  onFileRemoved: () => cubit.removeLeaseContractFile(),
                );
              },
            ),
            16.hs,

            // ── صورة الرخصة ───────────────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.permitPhotoFilePath != curr.permitPhotoFilePath,
              builder: (context, state) {
                return FileUploadField(
                  labelText: 'صورة الرخصة',
                  text: 'حمل ملف',
                  backgroundColor: AppColors.highlightDarkest,
                  textColor: AppColors.white,
                  filePath: state.permitPhotoFilePath,
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
    );
  }
}
