import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/extensions/taxpayer_types.dart';
import 'package:reta/features/declarations/presentations/components/shared_conventional_form.dart';
import 'package:reta/features/declarations/presentations/components/shared_natural_form.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/extensions/nationality.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_container.dart';
import '../../../components/app_text.dart';
import '../../../components/app_text_form_field.dart';
import '../../../components/image_svg_custom_widget.dart';
import 'app_attachment_item.dart';
import 'app_drop_down.dart';
import 'app_drop_down_option.dart';

class SharedForm extends StatelessWidget {
  SharedForm({
    super.key,
    required this.uploadDocumentTitle,
    required this.uploadDocumentDescription,
  });

  Nationality nationality = Nationality.egyptian;
  TaxpayerTypes taxpayerTypes = TaxpayerTypes.conventional;
  final String uploadDocumentTitle;
  final String uploadDocumentDescription;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        children: [
          AppText(
            text: 'بيانات المكلف بأداء الضريبة',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.mainBlueIndigoDye,
          ),
          24.hs,
          AppDropdownField<String>(
            labelText: 'نوع المكلف بأداء الضريبة',
            labelRequired: true,
            hintText: 'اختر نوع المكلف',
            value: taxpayerTypes.displayText,
            items: List.generate(
              TaxpayerTypes.values.length,
              (index) => appDropDownOption(
                label: TaxpayerTypes.values[index].displayText,
              ),
            ),
            onChanged: onTaxPayerTypeChanged,
            validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
          ),
          16.hs,
          if (taxpayerTypes == TaxpayerTypes.natural)
            SharedNaturalForm(
              nationality: nationality,
              onNationalityChanged: onNationalityChanged,
            ),
          if (taxpayerTypes == TaxpayerTypes.conventional)
            SharedConventionalForm(),

          16.hs,
          AppTextFormField(
            labelText: 'رقم الهاتف المحمول',
            labelRequired: true,
            labelColor: AppColors.neutralDarkDark,
            validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
            labelFontSize: 14.sp,
          ),
          16.hs,
          AppTextFormField(
            labelText: 'البريد الإلكتروني',
            labelColor: AppColors.neutralDarkDark,
            labelFontSize: 14.sp,
          ),
          16.hs,
          AppTextFormField(
            labelText: uploadDocumentTitle,
            labelRequired: true,
            description: uploadDocumentDescription,
            labelColor: AppColors.neutralDarkDark,
            labelFontSize: 14.sp,
            suffixWidget: ImageSvgCustomWidget(
              imgPath: FixedAssets.instance.attachmentWhiteIC,
              width: 16.w,
              height: 16.h,
              color: AppColors.neutralDarkLightest,
            ),
            prefixWidget: AppAttachmentItem(onTap: () {}, containFile: true),
            infoText: 'ملف بصيغة Jpg أو pdf لا يتجاوز حجمه 5 ميجا بايت',
          ),
        ],
      ),
    );
  }

  void onNationalityChanged(String? value) {
    nationality = value?.getNationality ?? Nationality.egyptian;
  }

  void onTaxPayerTypeChanged(String? value) {
    taxpayerTypes = value?.getTaxpayerType ?? TaxpayerTypes.natural;
  }
}
