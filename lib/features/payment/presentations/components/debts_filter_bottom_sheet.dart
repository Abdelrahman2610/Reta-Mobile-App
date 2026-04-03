import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/payment/presentations/components/build_text_section.dart';
import 'package:reta/features/payment/presentations/components/filter_app_container.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../data/models/debts_filter.dart';
import 'expand_toggle.dart';
import 'filter_actions.dart';
import 'filtration_title.dart';

void showDebtsFilterSheet(
  BuildContext context, {
  DebtsFilterData? initialFilter,
  required ValueChanged<DebtsFilterData> onApply,
  required VoidCallback onReset,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _DebtsFilterSheet(
      initialFilter: initialFilter ?? const DebtsFilterData(),
      onApply: onApply,
      onReset: onReset,
    ),
  );
}

class _DebtsFilterSheet extends StatefulWidget {
  final DebtsFilterData initialFilter;
  final ValueChanged<DebtsFilterData> onApply;
  final VoidCallback onReset;

  const _DebtsFilterSheet({
    required this.initialFilter,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<_DebtsFilterSheet> createState() => _DebtsFilterSheetState();
}

class _DebtsFilterSheetState extends State<_DebtsFilterSheet> {
  late DebtsFilterData _filter;
  late TextEditingController _numberCtrl;
  bool _typeExpanded = false;
  bool _statusExpanded = false;

  static const _durations = [
    (label: 'شهر', months: 1),
    (label: '3 أشهر', months: 3),
    (label: '6 أشهر', months: 6),
  ];

  static const _declarationTypes = [
    (id: 'all', label: 'الكل'),
    (id: '1', label: 'عام'),
    (id: '2', label: 'سنوى'),
  ];

  static final _statuses = [
    (id: 'all', label: 'الكل', color: AppColors.neutralDarkLightest),
    (id: '2', label: 'تم التقديم', color: AppColors.successMedium),
    (id: '3', label: 'قيد التعديل', color: AppColors.highlightDarkest),
    (id: '4', label: 'قيد المراجعة', color: AppColors.mainOrange),
    (id: '5', label: 'ملغي لغلق باب التقديم', color: AppColors.errorDark),
    (id: '6', label: 'ملغي', color: AppColors.errorDark),
  ];

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
    _numberCtrl = TextEditingController(text: _filter.declarationNumber ?? '');
  }

  @override
  void dispose() {
    _numberCtrl.dispose();
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

  String get _selectedTypeLabel => _declarationTypes
      .firstWhere(
        (t) => t.id == (_filter.declarationType ?? 'all'),
        orElse: () => _declarationTypes.first,
      )
      .label;

  String get _selectedStatusLabel => _statuses
      .firstWhere(
        (s) => s.id == _filter.statusId.toString(),
        orElse: () => _statuses.first,
      )
      .label;

  Color get _selectedStatusColor => _statuses
      .firstWhere(
        (s) => s.id == _filter.statusId.toString(),
        orElse: () => _statuses.first,
      )
      .color;

  void _reset() {
    setState(() {
      _filter = widget.initialFilter;
      _numberCtrl.clear();
      widget.onReset();
    });
    Navigator.pop(context);
  }

  void _apply() {
    final updated = _filter.copyWith(
      declarationNumber: _numberCtrl.text.trim().isEmpty
          ? null
          : _numberCtrl.text.trim(),
    );
    widget.onApply(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final count = _filter
        .copyWith(
          declarationNumber: _numberCtrl.text.trim().isEmpty
              ? null
              : _numberCtrl.text,
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
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
                      title: 'تصفية المديونيات المستحقة',
                      onResetTapped: _reset,
                    ),
                    10.hs,
                  ],
                ),
              ),
            ),
            30.hs,
            Expanded(
              child: Container(
                color: AppColors.neutralLightLight,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    // Action buttons
                    FilterActions(
                      count: count,
                      onApplyTapped: _apply,
                      onCancelTapped: _reset,
                    ),

                    10.hs,
                    Expanded(
                      child: ListView(
                        controller: scrollCtrl,
                        children: [
                          // رقم الإقرار
                          BuildTextSection(
                            label: 'رقم الإقرار',
                            hintLabel: 'إدخل رقم الإقرار',
                            onClearTapped: () =>
                                setState(() => _numberCtrl.clear()),
                            controller: _numberCtrl,
                          ),
                          10.hs,
                          // نوع الإقرار
                          FilterAppContainer(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      text: 'نوع الإقرار',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.neutralDarkDark,
                                    ),
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        _filter = _filter.copyWith(
                                          clearType: true,
                                        );
                                      }),
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
                                GestureDetector(
                                  onTap: () => setState(
                                    () => _typeExpanded = !_typeExpanded,
                                  ),
                                  child: Container(
                                    padding: EdgeInsetsDirectional.only(
                                      end: 6.w,
                                      start: 16.w,
                                      top: 10.h,
                                      bottom: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: AppColors.highlightDarkest,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Row(
                                      children: [
                                        AppText(
                                          text: _selectedTypeLabel,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.neutralDarkDarkest,
                                        ),
                                        const Spacer(),
                                        ExpandToggle(
                                          onTap: () {},
                                          isExpanded: _typeExpanded,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_typeExpanded) ...[
                                  8.hs,
                                  ..._declarationTypes.map((t) {
                                    final isSelected =
                                        (_filter.declarationType ?? 'all') ==
                                        t.id;
                                    return GestureDetector(
                                      onTap: () => setState(() {
                                        _filter = _filter.copyWith(
                                          declarationType: t.id,
                                        );
                                        _typeExpanded = false;
                                      }),
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
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text: t.label,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.neutralDarkDarkest,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ],
                            ),
                          ),
                          10.hs,
                          // فترة زمنية
                          _buildDateSection(),
                          10.hs,
                          // حالة الإقرار
                          FilterAppContainer(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      text: 'حالة الإقرار',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.neutralDarkDark,
                                    ),
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        _filter = _filter.copyWith(
                                          statusId: 'all',
                                        );
                                      }),
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
                                GestureDetector(
                                  onTap: () => setState(
                                    () => _statusExpanded = !_statusExpanded,
                                  ),
                                  child: Container(
                                    padding: EdgeInsetsDirectional.only(
                                      end: 6.w,
                                      start: 16.w,
                                      top: 10.h,
                                      bottom: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
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
                                        ExpandToggle(
                                          onTap: () {},
                                          isExpanded: _statusExpanded,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_statusExpanded) ...[
                                  8.hs,
                                  ..._statuses.map((s) {
                                    final isSelected =
                                        _filter.statusId.toString() == s.id;
                                    return GestureDetector(
                                      onTap: () => setState(() {
                                        _filter = _filter.copyWith(
                                          statusId: s.id,
                                        );
                                        _statusExpanded = false;
                                      }),
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
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text: s.label,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.neutralDarkDarkest,
                                            ),
                                            8.ws,
                                            Container(
                                              width: 10.w,
                                              height: 10.w,
                                              decoration: BoxDecoration(
                                                color: s.color,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ],
                            ),
                          ),
                          24.hs,
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
          Row(
            children: [
              Expanded(child: _buildDatePicker(isFrom: true, label: 'من')),
              12.ws,
              Expanded(child: _buildDatePicker(isFrom: false, label: 'إلى')),
            ],
          ),
          10.hs,
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
                  padding: EdgeInsets.only(right: 8.w),
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
}
