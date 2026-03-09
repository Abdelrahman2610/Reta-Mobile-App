import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/extensions/payment_status.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_arrow_icon.dart';
import '../../../components/app_scaffold.dart';
import '../../data/models/online_payment.dart';
import '../components/app_status_badge.dart';
import '../components/payment_text_form_field.dart';

class PaymentsTransactionsPage extends StatelessWidget {
  const PaymentsTransactionsPage({super.key});

  static final _mockData = [
    OnlinePaymentModel(
      status: PaymentStatus.success,
      amount: '2,700.00',
      operationNumber: '2165484948',
    ),
    OnlinePaymentModel(
      status: PaymentStatus.success,
      amount: '1,400.00',
      operationNumber: '2165484948',
    ),
    OnlinePaymentModel(
      status: PaymentStatus.pendingFailure,
      amount: '500.00',
      operationNumber: '4849482165',
    ),
    OnlinePaymentModel(
      status: PaymentStatus.failed,
      amount: '500.00',
      operationNumber: '4849482165',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'معاملات الدفع الإلكتروني',
      child: ListView.separated(
        itemBuilder: (context, index) =>
            _PaymentCard(payment: _mockData[index]),
        separatorBuilder: (context, index) => 16.hs,
        itemCount: _mockData.length,
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment});

  final OnlinePaymentModel payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppStatusBadge(
                label: payment.status.displayText,
                bgColor: payment.status.statusColor,
              ),
              AppArrowIcon(),
            ],
          ),
          12.hs,

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: AppColors.neutralLightDark),
            ),
            child: Row(
              children: [
                Expanded(
                  child: PaymentInfoBox(
                    label: 'رقم العملية',
                    value: payment.operationNumber,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    alignment: AlignmentDirectional.centerStart,
                    padding: EdgeInsets.zero,
                    borderColor: AppColors.transparent,
                  ),
                ),
                8.ws,
                Expanded(
                  child: PaymentInfoBox(
                    label: 'المبلغ',
                    value: payment.amount,
                    suffix: '  ج.م',
                    valueFontSize: 16.sp,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    alignment: AlignmentDirectional.centerEnd,
                    padding: EdgeInsets.zero,
                    borderColor: AppColors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
