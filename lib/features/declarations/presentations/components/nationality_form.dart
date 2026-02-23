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
  });

  final Nationality nationality;
  final Function(String?) onNationalityChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDropdownField<String>(
          labelText: 'الجنسية',
          labelRequired: true,
          hintText: 'اختر الجنسية',
          value: nationality.displayText,
          items: List.generate(
            Nationality.values.length,
            (index) =>
                appDropDownOption(label: Nationality.values[index].displayText),
          ),
          onChanged: onNationalityChanged,
          validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
        ),

        16.hs,

        if (nationality == Nationality.egyptian) NationalIDForm(),
        if (nationality == Nationality.foreign) PassportForm(),
      ],
    );
  }
}
