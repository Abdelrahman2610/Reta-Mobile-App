import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text_form_field.dart';
import 'nationality_form.dart';

class SharedNaturalForm extends StatelessWidget {
  const SharedNaturalForm({
    super.key,
    required this.nationality,
    required this.onNationalityChanged,
  });

  final Nationality nationality;
  final Function(String?) onNationalityChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextFormField(
          labelText: 'الإسم الأول للمكلف بأداء الضريبة',
          labelRequired: true,
          labelColor: AppColors.neutralDarkDark,
          validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
          labelFontSize: 14.sp,
        ),
        16.hs,
        AppTextFormField(
          labelText: 'باقي الإسم للمكلف بأداء الضريبة',
          labelRequired: true,
          labelColor: AppColors.neutralDarkDark,
          validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
          labelFontSize: 14.sp,
        ),
        16.hs,
        NationalityForm(
          nationality: nationality,
          onNationalityChanged: onNationalityChanged,
        ),
      ],
    );
  }
}
