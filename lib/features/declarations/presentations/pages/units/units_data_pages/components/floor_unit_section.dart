import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/theme/app_colors.dart';

import '../../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../components/app_text_form_field.dart';
import '../../../../components/app_drop_down.dart';
import '../../../../components/app_drop_down_option.dart';
import '../../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../../cubit/units/unit_data/unit_data_state.dart';

class FloorUnitSection extends StatelessWidget {
  const FloorUnitSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();
    return BlocBuilder<UnitDataCubit, UnitDataState>(
      buildWhen: (prev, curr) =>
          prev.selectedFloorNumber != curr.selectedFloorNumber ||
          prev.isFloorNumberOther != curr.isFloorNumberOther ||
          prev.selectedUnitNumber != curr.selectedUnitNumber ||
          prev.isUnitNumberOther != curr.isUnitNumberOther ||
          prev.buildingFloorList != curr.buildingFloorList ||
          prev.buildingUnitList != curr.buildingUnitList,
      builder: (context, state) {
        return Column(
          children: [
            AppDropdownField<String>(
              labelText: 'رقم الدور',
              labelRequired: true,
              labelColor: AppColors.neutralDarkDark,
              hintText: 'اختر رقم الدور',
              value: state.selectedFloorNumber,
              items: (cubit.lookups.realEstateFloors)
                  .map((f) => appDropDownOption(label: f.name))
                  .toList(),
              onChanged: cubit.selectFloorNumberOther,
              validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
            ),
            if (state.isFloorNumberOther) ...[
              16.hs,
              AppTextFormField(
                labelText: 'رقم الدور الآخر',
                labelRequired: true,
                labelColor: AppColors.neutralDarkDark,
                controller: cubit.floorNumberOtherController,
                hintText: 'ادخل رقم الدور',
                validator: (v) =>
                    v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
              ),
            ],
            16.hs,
            AppTextFormField(
              labelText: 'رقم الوحدة',
              labelRequired: true,
              labelColor: AppColors.neutralDarkDark,
              controller: cubit.unitNumberOtherController,
              hintText: 'ادخل رقم الوحدة',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
          ],
        );
      },
    );
  }
}
