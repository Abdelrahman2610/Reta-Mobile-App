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
import 'file_upload_field.dart';

class AdditionalDocumentsSection extends StatelessWidget {
  const AdditionalDocumentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();
    return BlocBuilder<UnitDataCubit, UnitDataState>(
      buildWhen: (prev, curr) =>
          prev.hasAdditionalDocuments != curr.hasAdditionalDocuments ||
          prev.additionalUpdateCount != curr.additionalUpdateCount ||
          prev.additionalDocuments != curr.additionalDocuments,
      builder: (context, state) {
        return Column(
          children: [
            AppDropdownField<String>(
              labelText: 'هل تريد تقديم مستندات أخرى داعمة للطلب؟',
              labelRequired: true,
              hintText: 'اختر',
              value: state.hasAdditionalDocuments ? kYes : kNo,
              items: cubit.yesNoOptions
                  .map((o) => appDropDownOption(label: o))
                  .toList(),
              onChanged: (v) => cubit.toggleHasAdditionalDocuments(v == kYes),
              validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
            ),

            if (state.hasAdditionalDocuments) ...[
              16.hs,
              ...cubit.additionalDocuments.map(
                (doc) => Column(
                  key: ValueKey(doc.id),
                  children: [
                    AppTextFormField(
                      labelText: 'اسم المستند',
                      labelRequired: true,
                      controller: doc.nameController,
                      hintText: 'ادخل اسم المستند',
                      validator: (v) =>
                          v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                    ),
                    16.hs,
                    FileUploadField(
                      labelText: 'تحميل المستند',
                      labelRequired: true,
                      filePath: doc.filePath,
                      text: 'حمل ملف',
                      backgroundColor: AppColors.highlightDarkest,
                      textColor: AppColors.white,
                      onFilePicked: () async {
                        final path = await cubit.pickFile();
                        if (path != null) {
                          cubit.setAdditionalDocumentFile(doc.id, path);
                        }
                      },
                      onFileRemoved: () =>
                          cubit.setAdditionalDocumentFile(doc.id, ''),
                    ),
                    16.hs,
                  ],
                ),
              ),

              if (cubit.additionalDocuments.length < 5)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: cubit.addAdditionalDocument,
                      icon: const Icon(Icons.add),
                      label: AppText(
                        text: 'إضافة مستند آخر',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.highlightDarkest,
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.highlightDarkest),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ],
        );
      },
    );
  }
}
