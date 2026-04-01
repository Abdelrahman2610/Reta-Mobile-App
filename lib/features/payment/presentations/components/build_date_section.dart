import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';
import '../../data/models/payment_filter.dart';
import 'filter_app_container.dart';

class BuildDateSection extends StatelessWidget {
  const BuildDateSection({
    super.key,
    required this.onResetTapped,
    required this.durations,
    required this.filter,
    required this.applyDuration,
    required this.pickDate,
  });

  final VoidCallback onResetTapped;
  final List durations;
  final PaymentFilterData filter;
  final Function(int) applyDuration;
  final Function(bool) pickDate;

  @override
  Widget build(BuildContext context) {
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
                onTap: onResetTapped,
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
            children: durations.map((d) {
              final isSelected =
                  filter.dateFrom != null &&
                      filter.dateTo != null &&
                      (filter.dateTo
                                      ?.difference(filter.dateFrom!)
                                      .inDays
                                      .abs() ??
                                  0) ~/
                              30 ==
                          d.months ||
                  (filter.dateTo?.difference(filter.dateFrom!).inDays.abs() ??
                              0) ~/
                          28 ==
                      d.months ||
                  (filter.dateTo?.difference(filter.dateFrom!).inDays.abs() ??
                              0) ~/
                          31 ==
                      d.months;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: GestureDetector(
                    onTap: () => applyDuration(d.months),
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
    final date = isFrom ? filter.dateFrom : filter.dateTo;
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
          onTap: () => pickDate(isFrom),
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

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
  }
}
