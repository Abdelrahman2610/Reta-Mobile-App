import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/app_text_form_field.dart';
import 'package:reta/features/payment/presentations/components/filter_app_container.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../data/models/payment_filter.dart';
import '../../data/models/payment_lookups.dart';
import 'expand_toggle.dart';

enum PaymentFilterStatus { all, paid, unpaid, inProgress, suspended, cancelled }

void showPaymentFilterSheet(
  BuildContext context, {
  PaymentFilterData? initialFilter,
  required ValueChanged<PaymentFilterData> onApply,
  required List<PaymentStatusLookup> statuses,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PaymentFilterSheet(
      initialFilter: initialFilter ?? const PaymentFilterData(),
      onApply: onApply,
      statuses: statuses,
    ),
  );
}

class _PaymentFilterSheet extends StatefulWidget {
  final PaymentFilterData initialFilter;
  final ValueChanged<PaymentFilterData> onApply;
  final List<PaymentStatusLookup> statuses;

  const _PaymentFilterSheet({
    required this.initialFilter,
    required this.onApply,
    required this.statuses,
  });

  @override
  State<_PaymentFilterSheet> createState() => _PaymentFilterSheetState();
}

class _PaymentFilterSheetState extends State<_PaymentFilterSheet> {
  late PaymentFilterData _filter;
  late TextEditingController _procCtrl;
  late TextEditingController _claimCtrl;
  bool _statusExpanded = true;

  static const _durations = [
    (label: 'شهر', months: 1),
    (label: '3 أشهر', months: 3),
    (label: '6 أشهر', months: 6),
  ];

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
    _procCtrl = TextEditingController(text: _filter.procedureNumber ?? '');
    _claimCtrl = TextEditingController(text: _filter.claimNumber ?? '');
  }

  @override
  void dispose() {
    _procCtrl.dispose();
    _claimCtrl.dispose();
    super.dispose();
  }

  void _applyDuration(int months) {
    final now = DateTime.now();
    setState(() {
      _filter = _filter.copyWith(
        dateFrom: DateTime(now.year, now.month - months, now.day),
        dateTo: now,
      );
    });
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          (isFrom ? _filter.dateFrom : _filter.dateTo) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    setState(() {
      _filter = isFrom
          ? _filter.copyWith(dateFrom: picked)
          : _filter.copyWith(dateTo: picked);
    });
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
  }

  String get _selectedStatusLabel {
    if (_filter.statusId == null) return 'الكل';
    return widget.statuses
        .firstWhere(
          (s) => s.id.toString() == _filter.statusId.toString(),
          orElse: () => PaymentStatusLookup(id: 'all', name: 'الكل'),
        )
        .name;
  }

  Color get _selectedStatusColor => statusColor(_filter.statusId ?? 'all');

  void _reset() {
    setState(() {
      _filter = const PaymentFilterData();
      _procCtrl.clear();
      _claimCtrl.clear();
    });
    Navigator.pop(context);
  }

  void _apply() {
    final updated = _filter.copyWith(
      procedureNumber: _procCtrl.text.trim().isEmpty
          ? null
          : _procCtrl.text.trim(),
      claimNumber: _claimCtrl.text.trim().isEmpty
          ? null
          : _claimCtrl.text.trim(),
    );
    widget.onApply(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final count = _filter
        .copyWith(
          procedureNumber: _procCtrl.text.trim().isEmpty
              ? null
              : _procCtrl.text,
          claimNumber: _claimCtrl.text.trim().isEmpty ? null : _claimCtrl.text,
        )
        .activeCount;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: AppColors.neutralLightLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    // Handle
                    Container(
                      width: 40.w,
                      height: 4.h,
                      margin: EdgeInsets.only(top: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    6.hs,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 36),
                        AppText(
                          text: 'تصفية طلبات السداد',
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.bottomSheetTitle,
                        ),
                        GestureDetector(
                          onTap: _reset,
                          child: Container(
                            width: 40.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: AppColors.bottomSheetContent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    10.hs,
                  ],
                ),
              ),
            ),

            30.hs,
            // Action row
            Expanded(
              child: Container(
                color: AppColors.neutralLightLight,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    FilterAppContainer(
                      paddingVertical: 24.h,
                      child: Row(
                        children: [
                          12.ws,
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: _apply,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.highlightDarkest,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    text: 'تطبيق',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  8.ws,
                                  if (count > 0)
                                    Container(
                                      width: 22.w,
                                      height: 22.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.25),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: AppText(
                                        text: '$count',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        alignment: AlignmentDirectional.center,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          12.ws,
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _reset,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: AppColors.mainBlueIndigoDye,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                              child: AppText(
                                text: 'إلغاء',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.mainBlueIndigoDye,
                                alignment: AlignmentDirectional.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.hs,
                    // Scrollable content
                    Expanded(
                      child: ListView(
                        controller: scrollCtrl,
                        children: [
                          FilterAppContainer(
                            child: _buildTextSection(
                              title: 'رقم الإجراء',
                              controller: _procCtrl,
                              hint: 'أدخل رقم الإجراء',
                              onClear: () => setState(() => _procCtrl.clear()),
                            ),
                          ),
                          10.hs,
                          FilterAppContainer(
                            child: _buildTextSection(
                              title: 'رقم طلب السداد',
                              controller: _claimCtrl,
                              hint: 'أدخل رقم طلب السداد',
                              onClear: () => setState(() => _claimCtrl.clear()),
                            ),
                          ),
                          10.hs,
                          _buildDateSection(),
                          10.hs,
                          _buildStatusSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSection({
    required String title,
    required TextEditingController controller,
    required String hint,
    required VoidCallback onClear,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: title,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.neutralDarkDark,
            ),
            GestureDetector(
              onTap: onClear,
              child: AppText(
                text: 'مسح',
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.highlightDarkest,
              ),
            ),
          ],
        ),
        5.hs,
        AppTextFormField(
          controller: controller,
          hintText: hint,
          labelText: '',
          hideLabel: true,
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return FilterAppContainer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'فترة زمنية',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.neutralDarkDark,
              ),
              GestureDetector(
                onTap: () => setState(
                  () => _filter = _filter.copyWith(clearDates: true),
                ),
                child: AppText(
                  text: 'إعادة تعيين',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.highlightDarkest,
                ),
              ),
            ],
          ),
          12.hs,
          // Date pickers row
          Row(
            children: [
              Expanded(child: _buildDatePicker(isFrom: true, label: 'من')),
              12.ws,
              Expanded(child: _buildDatePicker(isFrom: false, label: 'إلى')),
            ],
          ),
          10.hs,
          // Duration chips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _durations.map((d) {
              final isSelected =
                  _filter.dateFrom != null &&
                      _filter.dateTo != null &&
                      (_filter.dateTo
                                      ?.difference(_filter.dateFrom!)
                                      .inDays
                                      .abs() ??
                                  0) ~/
                              30 ==
                          d.months ||
                  (_filter.dateTo?.difference(_filter.dateFrom!).inDays.abs() ??
                              0) ~/
                          28 ==
                      d.months ||
                  (_filter.dateTo?.difference(_filter.dateFrom!).inDays.abs() ??
                              0) ~/
                          31 ==
                      d.months;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: GestureDetector(
                    onTap: () => _applyDuration(d.months),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.highlightDarkest
                              : AppColors.neutralDarkLightest,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: d.label,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.highlightDarkest
                                : AppColors.neutralDarkLightest,
                            alignment: AlignmentDirectional.center,
                          ),
                          if (isSelected) ...[
                            4.ws,
                            Icon(
                              Icons.check,
                              size: 14.sp,
                              color: AppColors.highlightDarkest,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker({required bool isFrom, required String label}) {
    final date = isFrom ? _filter.dateFrom : _filter.dateTo;
    final hasValue = date != null;
    return Column(
      children: [
        AppText(
          text: label,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.lighterText,
        ),
        10.hs,
        GestureDetector(
          onTap: () => _pickDate(isFrom: isFrom),
          child: Container(
            padding: EdgeInsetsDirectional.only(
              end: 5.w,
              start: 13.w,
              top: 5.h,
              bottom: 5.h,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor, width: 1.5),
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.bgColor,
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    text: hasValue ? _formatDate(date) : label,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: hasValue
                        ? AppColors.highlightDarkest
                        : Colors.grey[500]!,
                    textAlign: TextAlign.right,
                  ),
                ),
                8.ws,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.iconBgColor,
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 16.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return FilterAppContainer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'حالة طلب السداد',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.neutralDarkDark,
              ),
              GestureDetector(
                onTap: () =>
                    setState(() => _filter = _filter.copyWith(statusId: 'all')),
                child: AppText(
                  text: 'إعادة تعيين',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.highlightDarkest,
                ),
              ),
            ],
          ),
          12.hs,
          // Selected status row (toggle)
          GestureDetector(
            onTap: () => setState(() => _statusExpanded = !_statusExpanded),
            child: Container(
              padding: EdgeInsetsDirectional.only(
                end: 6.w,
                start: 16.w,
                top: 10.h,
                bottom: 10.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(
                  color: AppColors.highlightDarkest,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: _selectedStatusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  8.ws,
                  AppText(
                    text: _selectedStatusLabel,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.neutralDarkDarkest,
                  ),
                  const Spacer(),
                  ExpandToggle(onTap: () {}, isExpanded: _statusExpanded),
                ],
              ),
            ),
          ),
          if (_statusExpanded) ...[
            8.hs,
            ...widget.statuses.map((s) {
              final isSelected = _filter.statusId == s.id;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _filter = _filter.copyWith(statusId: s.id);
                    _statusExpanded = false;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.highlightLightest
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: statusColor(s.id),
                          shape: BoxShape.circle,
                        ),
                      ),
                      8.ws,
                      AppText(
                        text: s.name,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.neutralDarkDarkest,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Color statusColor(dynamic id) {
    switch (id.toString()) {
      case 'all':
        return const Color(0xFFAAAAAA);
      case '1':
        return const Color(0xFF2563EB);
      case '2':
        return const Color(0xFF22C55E);
      case '3':
        return const Color(0xFFF97316);
      case '4':
        return const Color(0xFFEF4444);
      case '5':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFFAAAAAA);
    }
  }
}
