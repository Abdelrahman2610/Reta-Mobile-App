import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/app_text_form_field.dart';
import 'package:reta/features/payment/presentations/components/build_date_section.dart';
import 'package:reta/features/payment/presentations/components/filter_actions.dart';
import 'package:reta/features/payment/presentations/components/filter_app_container.dart';
import 'package:reta/features/payment/presentations/components/filtration_title.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../data/models/payment_filter.dart';
import '../../data/models/payment_lookups.dart';
import 'expand_toggle.dart';

enum PaymentFilterStatus { all, paid, unpaid, inProgress, suspended, cancelled }

void showPaymentFilterSheet(
  BuildContext context, {
  PaymentFilterData? initialFilter,
  required ValueChanged<PaymentFilterData> onApply,
  required VoidCallback onReset,
  required List<PaymentStatusLookup> statuses,
  required bool fromDebts,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PaymentFilterSheet(
      initialFilter: initialFilter ?? const PaymentFilterData(),
      onApply: onApply,
      onReset: onReset,
      statuses: statuses,
      fromDebts: fromDebts,
    ),
  );
}

class _PaymentFilterSheet extends StatefulWidget {
  final PaymentFilterData initialFilter;
  final ValueChanged<PaymentFilterData> onApply;
  final VoidCallback onReset;
  final List<PaymentStatusLookup> statuses;
  final bool fromDebts;

  const _PaymentFilterSheet({
    required this.initialFilter,
    required this.onApply,
    required this.onReset,
    required this.statuses,
    required this.fromDebts,
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
      _filter = widget.initialFilter;
      _procCtrl.clear();
      _claimCtrl.clear();
      widget.onReset();
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
                    FiltrationTitle(
                      title: 'تصفية طلبات السداد',
                      onResetTapped: _reset,
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
                    FilterActions(
                      count: count,
                      onApplyTapped: _apply,
                      onCancelTapped: _reset,
                    ),

                    10.hs,
                    // Scrollable content
                    Expanded(
                      child: ListView(
                        controller: scrollCtrl,
                        children: [
                          if (!widget.fromDebts) ...[
                            FilterAppContainer(
                              child: _buildTextSection(
                                title: 'رقم الإجراء',
                                controller: _procCtrl,
                                hint: 'أدخل رقم الإجراء',
                                onClear: () =>
                                    setState(() => _procCtrl.clear()),
                              ),
                            ),
                            10.hs,
                          ],
                          FilterAppContainer(
                            child: _buildTextSection(
                              title: 'رقم طلب السداد',
                              controller: _claimCtrl,
                              hint: 'أدخل رقم طلب السداد',
                              onClear: () => setState(() => _claimCtrl.clear()),
                            ),
                          ),
                          10.hs,

                          BuildDateSection(
                            onResetTapped: () => setState(
                              () =>
                                  _filter = _filter.copyWith(clearDates: true),
                            ),
                            durations: _durations,
                            filter: _filter,
                            applyDuration: _applyDuration,
                            pickDate: (bool p1) => _pickDate(isFrom: p1),
                          ),
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
