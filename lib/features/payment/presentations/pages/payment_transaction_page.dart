import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/circular_progress_indicator_platform_widget.dart';
import 'package:reta/features/payment/presentations/components/app_status_badge.dart';
import 'package:reta/features/payment/presentations/cubit/payment_transactions/payment_transactions_cubit.dart';
import 'package:reta/features/payment/presentations/pages/multi_payment_box.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../components/app_arrow_icon.dart';
import '../../../components/app_bar.dart';
import '../../data/models/payment_transaction_model.dart';
import '../components/expand_toggle.dart';
import '../components/payment_text_form_field.dart';

class PaymentTransactionsPage extends StatelessWidget {
  final int claimId;
  const PaymentTransactionsPage({super.key, required this.claimId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentTransactionsCubit()..fetchTransactions(claimId),
      child: const _TransactionsView(),
    );
  }
}

class _TransactionsView extends StatelessWidget {
  const _TransactionsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightMedium,
      appBar: MainAppBar(
        title: 'معاملات الدفع الإلكتروني',
        backgroundColor: AppColors.mainBlueIndigoDye,
        backButtonIconColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: BlocBuilder<PaymentTransactionsCubit, PaymentTransactionsState>(
        builder: (context, state) {
          if (state is PaymentTransactionsLoading) {
            return const CircularProgressIndicatorPlatformWidget();
          }
          if (state is PaymentTransactionsError) {
            return Center(child: Text(state.message));
          }
          if (state is PaymentTransactionsSuccess) {
            return ListView.separated(
              padding: EdgeInsets.all(20.w),
              itemCount: state.transactions.length,
              separatorBuilder: (_, __) => 16.hs,
              itemBuilder: (_, index) =>
                  _TransactionCard(item: state.transactions[index]),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _TransactionCard extends StatefulWidget {
  final PaymentTransactionModel item;
  const _TransactionCard({required this.item});

  @override
  State<_TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<_TransactionCard>
    with SingleTickerProviderStateMixin {
  Color get _statusColor => widget.item.paymentStatusId == 1
      ? AppColors.successMedium
      : AppColors.errorMedium;

  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() => _isExpanded = !_isExpanded);
    _isExpanded ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppStatusBadge(
                  label: widget.item.paymentStatus,
                  bgColor: _statusColor,
                ),
                ExpandToggle(onTap: _toggleExpand, isExpanded: _isExpanded),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                MultiPaymentBox(
                  firstTitle: 'رقم المدفوعة',
                  firstValue: widget.item.paymentNumber,
                  secondTitle: 'المبلغ المسدد',
                  secondValue: widget.item.amount.toStringAsFixed(2),
                ),

                SizeTransition(
                  sizeFactor: _expandAnimation,
                  child: Column(
                    children: [
                      8.hs,
                      const Divider(),
                      8.hs,
                      Row(
                        children: [
                          Expanded(
                            child: PaymentInfoBox(
                              label: 'تاريخ ووقت العملية',
                              value: widget.item.date,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              alignment: AlignmentDirectional.centerStart,
                            ),
                          ),
                          12.ws,
                          Expanded(
                            child: PaymentInfoBox(
                              label: 'وسيلة الدفع',
                              value: widget.item.paymentMethod,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              alignment: AlignmentDirectional.centerStart,
                            ),
                          ),
                        ],
                      ),
                      8.hs,
                      PaymentInfoBox(
                        label: 'إسم المسدد',
                        value: widget.item.payerName,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        alignment: AlignmentDirectional.centerStart,
                      ),
                    ],
                  ),
                ),

                16.hs,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment});

  final PaymentTransactionModel payment;

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
              // AppStatusBadge(
              //   label: payment.status.displayText,
              //   bgColor: payment.status.statusColor,
              // ),
              AppArrowIcon(),
            ],
          ),
          12.hs,

          // MultiPaymentBox(
          //   firstTitle: 'رقم العملية',
          //   firstValue: payment.operationNumber,
          //   secondTitle: 'المبلغ',
          //   secondValue: payment.amount,
          // ),
        ],
      ),
    );
  }
}
