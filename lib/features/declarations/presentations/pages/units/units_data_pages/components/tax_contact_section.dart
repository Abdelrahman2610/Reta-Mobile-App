import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../components/app_drop_down.dart';
import '../../../../components/app_drop_down_option.dart';
import '../../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../../cubit/units/unit_data/unit_data_state.dart';

class TaxContactSection extends StatelessWidget {
  const TaxContactSection({super.key, this.customLabel});
  final String? customLabel;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();
    return BlocBuilder<UnitDataCubit, UnitDataState>(
      buildWhen: (prev, curr) =>
          prev.contactedTaxAuthority != curr.contactedTaxAuthority,
      builder: (context, state) {
        return AppDropdownField<String>(
          labelText:
              customLabel ??
              'هل تم التواصل مع الضرائب العقارية بخصوص الوحدة محل الإقرار سابقاً؟',
          labelFontSize: 16.sp,
          labelRequired: true,
          hintText: 'اختر',
          value: state.contactedTaxAuthority == null
              ? null
              : state.contactedTaxAuthority!
              ? kYes
              : kNo,
          items: cubit.yesNoOptions
              .map((o) => appDropDownOption(label: o))
              .toList(),
          onChanged: (v) =>
              cubit.setContactedTaxAuthority(v == kYes ? true : false),
          validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
        );
      },
    );
  }
}
