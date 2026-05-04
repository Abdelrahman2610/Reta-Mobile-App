import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/components/app_container.dart';
import 'package:reta/features/components/app_scaffold.dart';
import 'package:reta/features/declarations/data/models/hotel_sub_unit.dart';
import 'package:reta/features/declarations/presentations/cubit/units/unit_data/unit_data_cubit.dart';

import '../../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../components/app_text.dart';
import '../../../../../../components/app_text_form_field.dart';
import '../../../../components/app_drop_down.dart';
import '../../../../components/app_drop_down_option.dart';
import '../../../../components/cancel_declaration_button.dart';
import '../../../../components/submit_declaration_button.dart';

class HotelSubUnitDetailPage extends StatefulWidget {
  const HotelSubUnitDetailPage({
    super.key,
    required this.unit,
    required this.index,
  });

  final HotelSubUnit unit;
  final int index;

  @override
  State<HotelSubUnitDetailPage> createState() => _HotelSubUnitDetailPageState();
}

class _HotelSubUnitDetailPageState extends State<HotelSubUnitDetailPage> {
  String? _selectedBuildingNumber;

  @override
  void initState() {
    super.initState();
    final text = widget.unit.buildingNumber.text;
    if (text.isNotEmpty) _selectedBuildingNumber = text;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();

    final buildingItems = cubit.hotelBuildings.asMap().entries.map((e) {
      final i = e.key;
      final known = e.value.mapLocationResult?.streetNumber;
      final label = known.isNotEmpty ? '$known' : 'مبنى ${i + 1}';
      return DropdownMenuItem<String>(
        value: '$known',
        child: Align(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AppText(
              alignment: AlignmentDirectional.centerEnd,
              text: label,
              maxLines: 2,
              fontSize: 14.sp,
              textAlign: TextAlign.right,
              fontWeight: FontWeight.w400,
              color: AppColors.neutralDarkDarkest,
            ),
          ),
        ),
      );
    }).toList();

    return Material(
      child: AppScaffold(
        title: 'الوحدات التابعة للمنشأة الفندقية',
        appBarBGColor: AppColors.mainBlueSecondary,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: AppContainer(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText(
                        text: 'بيانات الوحدة',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.highlightDarkest,
                      ),
                      16.hs,

                      // ── رقم المبنى (dropdown) ─────────
                      AppDropdownField<String>(
                        labelText: 'رقم المبنى',
                        labelRequired: true,
                        hintText: 'اختر رقم المبنى',
                        value: _selectedBuildingNumber,
                        items: buildingItems,
                        onChanged: (v) => setState(() {
                          _selectedBuildingNumber = v;
                          widget.unit.buildingNumber.text = v ?? '';
                        }),
                        validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
                      ),
                      16.hs,

                      // ── رقم العقار/المبنى المتعارف عليه ─
                      AppTextFormField(
                        labelText: 'رقم العقار/المبنى المتعارف عليه',
                        hintText: 'رقم العقار/المبنى المتعارف عليه',
                        controller: widget.unit.knownPropertyNumber,
                      ),
                      16.hs,

                      // ── رقم الدور ────────────────────
                      AppDropdownField<String>(
                        labelText: 'رقم الدور',
                        labelRequired: true,
                        hintText: 'اختر رقم الدور',
                        value: widget.unit.floorNumber,
                        items: cubit.floorNumbers
                            .map((f) => appDropDownOption(label: f))
                            .toList(),
                        onChanged: (v) => setState(() {
                          widget.unit.floorNumber = v;
                          if (v != kOtherFloor) {
                            widget.unit.lastFloorNumber.clear();
                          }
                        }),
                        validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
                      ),
                      if (widget.unit.floorNumber == kOtherFloor) ...[
                        16.hs,
                        AppTextFormField(
                          labelText: 'رقم الدور الاخر',
                          labelRequired: true,
                          hintText: 'ادخل رقم الدور الاخر',
                          controller: widget.unit.lastFloorNumber,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                      16.hs,

                      // ── رقم الوحدة ───────────────────
                      AppTextFormField(
                        labelText: 'رقم الوحدة',
                        labelRequired: true,
                        controller: widget.unit.unitNumber,
                        hintText: 'ادخل رقم الوحدة',
                        keyboardType: TextInputType.number,
                      ),
                      16.hs,

                      // ── نوع النشاط ───────────────────
                      AppTextFormField(
                        labelText: 'نوع النشاط',
                        labelRequired: true,
                        controller: widget.unit.activityType,
                        hintText: 'حدد نوع النشاط',
                      ),
                      16.hs,

                      // ── المساحة ──────────────────────
                      AppTextFormField(
                        labelText: 'المساحة',
                        labelRequired: true,
                        controller: widget.unit.area,
                        hintText: 'المساحة بالمتر المربع',
                        keyboardType: TextInputType.number,
                      ),
                      16.hs,

                      // ── داخل رخصة التشغيل؟ ───────────
                      AppDropdownField<String>(
                        labelText: 'داخل رخصة التشغيل؟',
                        labelRequired: true,
                        hintText: 'اختر',
                        value: widget.unit.insideOperationLicense,
                        items: cubit.yesNoOptions
                            .map((o) => appDropDownOption(label: o))
                            .toList(),
                        onChanged: (v) => setState(
                          () => widget.unit.insideOperationLicense = v,
                        ),
                        validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
                      ),
                      if (widget.unit.insideOperationLicense == kNo) ...[
                        16.hs,
                        AppDropdownField<String>(
                          labelText:
                              'هل تم التواصل مع الضرائب العقارية بخصوص المنشأة محل الإقرار سابقاً؟',
                          labelRequired: true,
                          hintText: 'اختر',
                          value: widget.unit.retaContactAboutUnit,
                          items: cubit.yesNoOptions
                              .map((o) => appDropDownOption(label: o))
                              .toList(),
                          onChanged: (v) => setState(
                            () => widget.unit.retaContactAboutUnit = v,
                          ),
                          validator: (v) =>
                              v == null ? 'هذا الحقل مطلوب' : null,
                        ),
                        if (widget.unit.retaContactAboutUnit == kYes) ...[
                          16.hs,
                          AppTextFormField(
                            labelText: 'كود حساب الوحدة',
                            controller: widget.unit.accountCode,
                            hintText: 'ادخل كود حساب الوحدة',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                        16.hs,
                        AppTextFormField(
                          labelText: 'القيمة السوقية',
                          controller: widget.unit.marketPrice,
                          hintText: 'ادخل القيمة السوقية للمنشأة',
                          keyboardType: TextInputType.number,
                        ),
                        16.hs,
                        AppTextFormField(
                          labelText: 'القيمة الإيجارية السنوية',
                          controller: widget.unit.annualRent,
                          hintText: 'ادخل القيمة الإيجارية السنوية',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // ── أزرار الحفظ والإلغاء ──────────────
            AppContainer(
              borderRadius: 0,
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    flex: 5,
                    child: SubmitDeclarationButton(
                      label: 'حفظ البيانات',
                      borderColor: AppColors.successDark,
                      withIcon: false,
                      onSubmit: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 3,
                    child: CancelDeclarationButton(
                      label: 'إلغاء',
                      withIcon: true,
                      onCancel: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
