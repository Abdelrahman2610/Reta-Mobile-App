import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/components/app_button.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/helpers/fixed_assets.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../components/app_container.dart';
import '../../../../../components/app_text.dart';
import '../../../../../components/app_text_form_field.dart';
import '../../../../../components/image_svg_custom_widget.dart';
import '../../../../data/models/hotel_sub_unit.dart';
import '../../../components/app_drop_down.dart';
import '../../../components/app_drop_down_option.dart';
import '../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../cubit/units/unit_data/unit_data_state.dart';
import 'components/additional_documents_section.dart';
import 'components/app_counter.dart';
import 'components/calendar_icon.dart';
import 'components/file_upload_field.dart';
import 'components/tax_contact_section.dart';
import 'components/title_with_divider.dart';

class HotelFacilityPage extends StatelessWidget {
  const HotelFacilityPage({super.key, required this.unitCubit});
  final UnitDataCubit unitCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: unitCubit,
      child: const _HotelFacilityView(),
    );
  }
}

class _HotelFacilityView extends StatelessWidget {
  const _HotelFacilityView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();

    return Form(
      key: cubit.formKey,
      child: AppContainer(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText(
              text: 'بيانات المنشأة الفندقية',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.mainBlueIndigoDye,
            ),
            24.hs,

            // ── الاسم التجاري (trade_name) ─────────
            AppTextFormField(
              labelText: 'الأسم التجاري للمنشأة الفندقية',
              labelRequired: true,
              controller: cubit.facilityNameController,
              hintText: 'ادخل الأسم التجاري للمنشأة الفندقية',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,

            // ── الإطلالة (view_type_id) ────────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.selectedHotelView != curr.selectedHotelView,
              builder: (context, state) => AppDropdownField<String>(
                labelText: 'الإطلالة',
                labelRequired: true,
                hintText: 'اختر الإطلالة',
                value: state.selectedHotelView,
                items: cubit.lookups.hotelViewTypes
                    .map((v) => appDropDownOption(label: v.name))
                    .toList(),
                onChanged: cubit.selectHotelView,
                validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
              ),
            ),
            16.hs,

            // ── تاريخ تراخيص التشغيل (license_date) ─
            AppTextFormField(
              labelText: 'تاريخ تراخيص التشغيل',
              labelRequired: true,
              controller: cubit.operatingLicenseDateController,
              hintText: 'ادخل تاريخ تراخيص التشغيل',
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1990),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  cubit.operatingLicenseDateController.text =
                      '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                }
              },
              suffixWidget: CalendarIcon(color: AppColors.neutralDarkLightest),
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,

            // ── عدد المباني (buildings_count) ──────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.buildingsCount != curr.buildingsCount,
              builder: (context, state) => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppText(
                    text: 'عدد المباني',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutralDarkDark,
                  ),
                  AppText(
                    text: ' *',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.errorDark,
                  ),
                  const Spacer(),
                  AppCounter(
                    count: state.buildingsCount,
                    onDecrement: () {
                      if (cubit.state.buildingsCount > 1) {
                        cubit.emit(
                          cubit.state.copyWith(
                            buildingsCount: cubit.state.buildingsCount - 1,
                          ),
                        );
                      }
                    },
                    onIncrement: () => cubit.emit(
                      cubit.state.copyWith(
                        buildingsCount: cubit.state.buildingsCount + 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            16.hs,

            // ── عدد الغرف (rooms_count) ────────────
            AppTextFormField(
              labelText: 'عدد الغرف',
              labelRequired: true,
              controller: cubit.facilityRoomCountController,
              hintText: 'ادخل عدد الغرف',
              keyboardType: TextInputType.number,
              validator: (v) {
                return v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null;
              },
            ),
            16.hs,

            // ── مستوى النجومية (star_rating_id) ────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.selectedStarRating != curr.selectedStarRating,
              builder: (context, state) => AppDropdownField<String>(
                labelText: 'مستوى النجومية',
                labelRequired: true,
                hintText: 'اختر مستوى النجومية',
                value: state.selectedStarRating,
                items: cubit.lookups.starRatings
                    .map((s) => appDropDownOption(label: s.name))
                    .toList(),
                onChanged: cubit.selectStarRating,
                validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
              ),
            ),
            16.hs,

            // ── هل تم التواصل مع الضرائب؟ (reta_contact_about_unit) ─
            const TaxContactSection(
              customLabel:
                  'هل تم التواصل مع الضرائب العقارية بخصوص المنشأة محل الإقرار سابقاً؟',
            ),
            16.hs,

            // ── كود حساب الوحدة (account_code) ────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.contactedTaxAuthority != curr.contactedTaxAuthority,
              builder: (context, state) {
                return (state.contactedTaxAuthority ?? false)
                    ? Column(
                        children: [
                          AppTextFormField(
                            labelText: 'كود حساب الوحدة',
                            controller: cubit.unitCodeController,
                            hintText: 'ادخل كود حساب الوحدة',
                            keyboardType: TextInputType.number,
                          ),
                          16.hs,
                        ],
                      )
                    : const SizedBox.shrink();
              },
            ),

            // ── صورة من التراخيص الإنشائية (copy_of_the_construction_permits) ─
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.constructionLicenseFilePath !=
                  curr.constructionLicenseFilePath,
              builder: (context, state) => FileUploadField(
                labelText: 'صورة من التراخيص الإنشائية',
                text: 'حمل ملف',
                backgroundColor: AppColors.highlightDarkest,
                textColor: AppColors.white,
                filePath: state.constructionLicenseFullUrl,
                onFilePicked: () async {
                  final path = await cubit.pickFile();
                  if (path != null) cubit.setConstructionLicenseFile(path);
                },
                onFileRemoved: () => cubit.removeConstructionLicenseFile(),
              ),
            ),
            16.hs,

            // ── صورة من ترخيص التشغيل (copy_of_the_operating_licenses) ─
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.operatingLicenseFilePath !=
                  curr.operatingLicenseFilePath,
              builder: (context, state) => FileUploadField(
                labelText: 'صورة من ترخيص التشغيل',
                text: 'حمل ملف',
                backgroundColor: AppColors.highlightDarkest,
                textColor: AppColors.white,
                filePath: state.operatingLicenseFullUrl,
                onFilePicked: () async {
                  final path = await cubit.pickFile();
                  if (path != null) cubit.setOperatingLicenseFile(path);
                },
                onFileRemoved: () => cubit.removeOperatingLicenseFile(),
              ),
            ),
            16.hs,

            // ── شهادة بمستوى النجومية (certificate_of_stardom_level) ─
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.starCertificateFilePath != curr.starCertificateFilePath,
              builder: (context, state) => FileUploadField(
                labelText: 'شهادة بمستوى النجومية',
                text: 'حمل ملف',
                backgroundColor: AppColors.highlightDarkest,
                textColor: AppColors.white,
                filePath: state.starCertificateFullUrl,
                onFilePicked: () async {
                  final path = await cubit.pickFile();
                  if (path != null) cubit.setStarCertificateFile(path);
                },
                onFileRemoved: () => cubit.removeStarCertificateFile(),
              ),
            ),
            16.hs,

            // ── مستندات داعمة أخرى (supporting_documents) ──────────
            const AdditionalDocumentsSection(),
            16.hs,

            // ── هل توجد وحدات تابعة؟ (has_sub_units) ───────────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) => prev.hasSubUnits != curr.hasSubUnits,
              builder: (context, state) => AppDropdownField<String>(
                labelText: 'هل توجد وحدات تابعة للمنشأة الفندقية؟',
                labelRequired: true,
                hintText: 'اختر',
                value: state.hasSubUnits == null
                    ? null
                    : (state.hasSubUnits! ? 'نعم' : 'لا'),
                items: cubit.yesNoOptions
                    .map((o) => appDropDownOption(label: o))
                    .toList(),
                onChanged: (v) {
                  final isYes = v == 'نعم';
                  if (isYes && cubit.state.hotelSubUnits.isEmpty) {
                    cubit.addHotelSubUnit();
                  } else if (!isYes) {
                    for (final u in cubit.state.hotelSubUnits) u.dispose();
                    cubit.emit(
                      cubit.state.copyWith(
                        hasSubUnits: false,
                        hotelSubUnits: [],
                        hotelSubUnitsUpdateCount:
                            cubit.state.hotelSubUnitsUpdateCount + 1,
                      ),
                    );
                    return;
                  }
                  cubit.setHasSubUnits(isYes);
                },
                validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
              ),
            ),
            16.hs,

            // ── وحدات المنشأة الفندقية (hotelUnits) ─────────────────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.hasSubUnits != curr.hasSubUnits ||
                  prev.hotelSubUnitsUpdateCount !=
                      curr.hotelSubUnitsUpdateCount,
              builder: (context, state) {
                if (state.hasSubUnits != true || state.hotelSubUnits.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neutralLightLight,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: state.hotelSubUnits.asMap().entries.map((e) {
                      return _HotelSubUnitCard(
                        index: e.key,
                        unit: e.value,
                        cubit: cubit,
                        isLast: e.key == state.hotelSubUnits.length - 1,
                        canDelete: state.hotelSubUnits.length > 1,
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Hotel Sub-Unit Card
// ─────────────────────────────────────────

class _HotelSubUnitCard extends StatefulWidget {
  const _HotelSubUnitCard({
    required this.index,
    required this.unit,
    required this.cubit,
    required this.isLast,
    required this.canDelete,
  });

  final int index;
  final HotelSubUnit unit;
  final UnitDataCubit cubit;
  final bool isLast;
  final bool canDelete;

  @override
  State<_HotelSubUnitCard> createState() => _HotelSubUnitCardState();
}

class _HotelSubUnitCardState extends State<_HotelSubUnitCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TitleWithDivider(
          title: 'ملحقات الفندق - وحدة (${widget.index + 1})',
          fontSize: 14.sp,
        ),
        16.hs,

        // ── رقم المبنى (building_number) ──────
        AppTextFormField(
          labelText: 'رقم المبنى',
          labelRequired: true,
          controller: widget.unit.buildingNumber,
          hintText: 'ادخل رقم المبنى',
          keyboardType: TextInputType.number,
          validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
        ),
        16.hs,

        // ── رقم الدور (floor_number_id) ───────
        AppDropdownField<String>(
          labelText: 'رقم الدور',
          labelRequired: true,
          hintText: 'اختر رقم الدور',
          value: widget.unit.floorNumber,
          items: widget.cubit.floorNumbers
              .map((f) => appDropDownOption(label: f))
              .toList(),
          onChanged: (v) => setState(() => widget.unit.floorNumber = v),
          validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
        ),
        16.hs,

        // ── رقم الوحدة (unit_number) ──────────
        AppTextFormField(
          labelText: 'رقم الوحدة',
          labelRequired: true,
          controller: widget.unit.unitNumber,
          hintText: 'ادخل رقم الوحدة',
          keyboardType: TextInputType.number,
          validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
        ),
        16.hs,

        // ── نوع النشاط (activity_type) ────────
        AppTextFormField(
          labelText: 'نوع النشاط',
          labelRequired: true,
          controller: widget.unit.activityType,
          hintText: 'حدد نوع النشاط',
          validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
        ),
        16.hs,

        // ── المساحة (area) ────────────────────
        AppTextFormField(
          labelText: 'المساحة',
          labelRequired: true,
          controller: widget.unit.area,
          hintText: 'المساحة بالمتر المربع',
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';
            if (double.tryParse(v) == null) return 'يجب إدخال رقم صحيح';
            return null;
          },
        ),
        16.hs,

        // ── داخل رخصة التشغيل؟ (inside_operation_license) ──
        AppDropdownField<String>(
          labelText: 'داخل رخصة التشغيل؟',
          labelRequired: true,
          hintText: 'اختر',
          value: widget.unit.insideOperationLicense,
          items: widget.cubit.yesNoOptions
              .map((o) => appDropDownOption(label: o))
              .toList(),
          onChanged: (v) =>
              setState(() => widget.unit.insideOperationLicense = v),
          validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
        ),
        16.hs,

        // ── هل تم التواصل مع الضرائب؟ (reta_contact_about_unit) ──
        if (widget.unit.insideOperationLicense == kYes)
          Column(
            children: [
              AppDropdownField<String>(
                labelText:
                    'هل تم التواصل مع الضرائب العقارية بخصوص المنشأة محل الإقرار سابقاً؟',
                labelRequired: true,
                hintText: 'اختر',
                value: widget.unit.retaContactAboutUnit,
                items: widget.cubit.yesNoOptions
                    .map((o) => appDropDownOption(label: o))
                    .toList(),
                onChanged: (v) =>
                    setState(() => widget.unit.retaContactAboutUnit = v),
                validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
              ),
              16.hs,
              // ── كود حساب الوحدة (account_code) ───
              if (widget.unit.retaContactAboutUnit == kYes)
                AppTextFormField(
                  labelText: 'كود حساب الوحدة',
                  controller: widget.unit.accountCode,
                  hintText: 'ادخل كود حساب الوحدة',
                  keyboardType: TextInputType.number,
                ),
              16.hs,

              // ── القيمة السوقية (market_price) ─────
              AppTextFormField(
                labelText: 'القيمة السوقية',
                controller: widget.unit.marketPrice,
                hintText: 'ادخل القيمة السوقية للمنشأة',
                keyboardType: TextInputType.number,
              ),
              16.hs,

              // ── القيمة الإيجارية السنوية (annual_rent) ──
              AppTextFormField(
                labelText: 'القيمة الإيجارية السنوية',
                controller: widget.unit.annualRent,
                hintText: 'ادخل القيمة الإيجارية السنوية',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        16.hs,

        // ── زرار إضافة + حذف ──────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.isLast)
              Expanded(
                child: AppButton(
                  label: 'إضافة وحدة',
                  backgroundColor: AppColors.highlightDarkest,
                  icon: Icon(Icons.add, color: AppColors.white),
                  iconLeft: false,
                  onTap: widget.cubit.addHotelSubUnit,
                  fontWeight: FontWeight.w600,
                ),
              )
            else
              const SizedBox.shrink(),
            if (widget.isLast && widget.canDelete) 15.ws,
            if (widget.canDelete)
              GestureDetector(
                onTap: () => widget.cubit.removeHotelSubUnit(widget.unit.id),
                child: ImageSvgCustomWidget(
                  imgPath: FixedAssets.instance.deleteIC,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
