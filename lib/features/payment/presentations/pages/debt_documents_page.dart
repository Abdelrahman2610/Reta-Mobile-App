import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/components/app_container.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/app_text_form_field.dart';
import 'package:reta/features/payment/data/models/debt_document_item.dart';
import 'package:reta/features/payment/data/models/debt_unit_item.dart';
import 'package:reta/features/payment/presentations/cubit/debt_documents/debt_documents_cubit.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../declarations/presentations/pages/units/units_data_pages/components/file_upload_field.dart';

class DebtDocumentsPage extends StatelessWidget {
  final DebtUnitItemModel unit;
  final String declarationId;
  final VoidCallback onSaved;

  const DebtDocumentsPage({
    super.key,
    required this.unit,
    required this.declarationId,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DebtDocumentsCubit(unit: unit, declarationId: declarationId),
      child: _DebtDocumentsView(onSaved: onSaved),
    );
  }
}

class _DebtDocumentsView extends StatelessWidget {
  final VoidCallback onSaved;
  const _DebtDocumentsView({required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightMedium,
      body: BlocBuilder<DebtDocumentsCubit, DebtDocumentsState>(
        builder: (context, state) {
          if (state is! DebtDocumentsUpdated) return const SizedBox();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppContainer(
                borderRadius: 0,
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocConsumer<DebtDocumentsCubit, DebtDocumentsState>(
                        listener: (context, state) {
                          if (state is DebtDocumentsSaved) {
                            onSaved();
                            Navigator.pop(context);
                          }
                          if (state is DebtDocumentsError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },
                        builder: (context, state) {
                          final canSave =
                              state is DebtDocumentsUpdated && state.canSave;
                          final isSaving =
                              state is DebtDocumentsUpdated && state.isSaving;
                          return isSaving
                              ? SizedBox(
                                  width: 18.w,
                                  height: 18.w,
                                  child:
                                      const CircularProgressIndicator.adaptive(
                                        strokeWidth: 2,
                                      ),
                                )
                              : AppButton(
                                  width: 100.sp,
                                  label: 'حفظ',
                                  backgroundColor: canSave && !isSaving
                                      ? AppColors.highlightDarkest
                                      : AppColors.neutralLightDarkest,
                                  textColor: canSave && !isSaving
                                      ? AppColors.white
                                      : AppColors.neutralDarkLight,
                                  onTap: canSave && !isSaving
                                      ? () => context
                                            .read<DebtDocumentsCubit>()
                                            .saveDocuments()
                                      : null,
                                );
                        },
                      ),
                      AppText(
                        text: 'المرفقات',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelsVibrantPrimary,
                      ),
                      BlocBuilder<DebtDocumentsCubit, DebtDocumentsState>(
                        builder: (context, state) {
                          final isSaving =
                              state is DebtDocumentsUpdated && state.isSaving;
                          return AppButton(
                            width: 100.sp,
                            label: 'لاغي',
                            backgroundColor: AppColors.white,
                            textColor: AppColors.highlightDarkest,
                            borderColor: AppColors.highlightDarkest,
                            onTap: isSaving
                                ? null
                                : () => Navigator.pop(context),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        35.hs,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: AppText(
                            text: 'المستندات الدالة على المديونية',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.highlightDarkest,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        16.hs,
                        ...state.documents.map(
                          (doc) => _DocumentItem(document: doc),
                        ),
                        10.hs,
                        if (state.documents.length < 5)
                          Container(
                            margin: EdgeInsets.only(bottom: 26.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 20.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => context
                                      .read<DebtDocumentsCubit>()
                                      .addDocument(),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: AppColors.highlightDarkest,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 14.h,
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.add,
                                    color: AppColors.highlightDarkest,
                                    size: 18.sp,
                                  ),
                                  label: AppText(
                                    text: 'إضافة مستند آخر',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.highlightDarkest,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DocumentItem extends StatelessWidget {
  final DebtDocumentItem document;
  const _DocumentItem({required this.document});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DebtDocumentsCubit>();

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: AppColors.neutralLightLight,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppTextFormField(
              controller: document.nameController,
              hintText: 'ادخل اسم المستند',
              labelText: 'اسم المستند',
              labelRequired: true,
              onChanged: (_) => cubit.onNameChanged(),
            ),
            16.hs,

            FileUploadField(
              labelText: 'تحميل المستند',
              text: 'حمل ملف',
              labelRequired: true,
              backgroundColor: AppColors.highlightDarkest,
              textColor: AppColors.white,
              filePath: document.filePath,
              deleteFileText: 'حذف الملف',
              loadingWidget: document.isUploading
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_file,
                            color: AppColors.neutralDarkMedium,
                            size: 18.sp,
                          ),
                          6.ws,
                          SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: Center(
                              child: const CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
              onFilePicked: document.isUploading
                  ? () {}
                  : () => cubit.pickAndUploadFile(document.id),
              onFileRemoved: () => cubit.removeFile(document.id),
            ),

            16.hs,
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppButton(
                width: 144.w,
                label: 'حذف المستند',
                backgroundColor: AppColors.errorDark,
                onTap: () => cubit.removeDocument(document.id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
