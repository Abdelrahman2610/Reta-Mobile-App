import 'package:flutter/material.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/features/declarations/presentations/components/passport_form.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/extensions/nationality.dart';
import 'app_drop_down.dart';
import 'app_drop_down_option.dart';
import 'national_id_form.dart';

class NationalityForm extends StatelessWidget {
  const NationalityForm({
    super.key,
    required this.nationality,
    required this.onNationalityChanged,
    this.filledColor,
    this.enabled = true,
    this.fontSize,
    this.textColor,
    this.labelRequired = true,
    this.attachmentIconColor,
    this.nationalIdController,
    this.onNationalIdFilePicked,
    this.nationalIdFilePath,
    this.passportController,
    this.onPassportFilePicked,
    this.passportFilePath,
    this.displayFile = true,
  });

  final Nationality nationality;
  final Function(String?) onNationalityChanged;
  final Color? filledColor;
  final bool enabled;
  final double? fontSize;
  final Color? textColor;
  final bool labelRequired;
  final Color? attachmentIconColor;
  final TextEditingController? nationalIdController;
  final VoidCallback? onNationalIdFilePicked;
  final String? nationalIdFilePath;
  final TextEditingController? passportController;
  final VoidCallback? onPassportFilePicked;
  final String? passportFilePath;
  final bool displayFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDropdownField<String>(
          labelText: 'الجنسية',
          enabled: enabled,
          filledColor: filledColor,
          labelRequired: labelRequired,
          hintText: 'اختر الجنسية',
          labelFontSize: fontSize,
          labelColor: textColor,
          value: nationality.displayText,
          items: List.generate(
            Nationality.values.length,
            (index) => appDropDownOption(
              label: Nationality.values[index].displayText,
              fontSize: fontSize,
              textColor: textColor,
            ),
          ),
          onChanged: onNationalityChanged,
          validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
        ),

        16.hs,

        if (nationality == Nationality.egyptian)
          NationalIDForm(
            enabled: enabled,
            filledColor: filledColor,
            fontSize: fontSize,
            textColor: textColor,
            labelRequired: labelRequired,
            attachmentIconColor: attachmentIconColor,
            controller: nationalIdController,
            onFilePicked: onNationalIdFilePicked,
            filePath: nationalIdFilePath,
            displayFile: displayFile,
          ),
        if (nationality == Nationality.foreign)
          PassportForm(
            enabled: enabled,
            filledColor: filledColor,
            fontSize: fontSize,
            textColor: textColor,
            labelRequired: labelRequired,
            attachmentIconColor: attachmentIconColor,
            controller: passportController,
            onFilePicked: onPassportFilePicked,
            filePath: passportFilePath,
            displayFile: displayFile,
          ),
      ],
    );
  }
}
