import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/core/helpers/extensions/date_time.dart';
import 'package:reta/core/helpers/extensions/transaction_status.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/image_svg_custom_widget.dart';
import 'package:reta/features/payment/data/models/transaction.dart';
import 'package:reta/features/payment/presentations/pages/payment_transaction_page.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../components/app_info_dialog.dart';
import '../../../components/app_scaffold.dart';
import '../components/app_status_badge.dart';
import '../components/payment_text_form_field.dart';

class SettlementAccountPage extends StatelessWidget {
  const SettlementAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "حساب التسويات",
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //TODO: Remove on tap
            GestureDetector(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: PaymentTransactionsPage(claimId: 1),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.slideUp,
                );
              },
              child: _BalanceCard(),
            ),
            35.hs,

            AppText(
              text: 'سجل بجميع العمليات المرتبطة بحساب التسويات',
              alignment: AlignmentDirectional.center,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.mainBlueIndigoDye,
            ),
            25.hs,

            _TransactionCard(
              transaction: TransactionModel(
                transactionStatus: TransactionStatus.withdraw,
                transactionDateTime: DateTime(2026, 4, 10, 10, 15),
                operationNumber: '2165484948',
                transactionNumber: '84948-S',
                amount: '2,700.00',
              ),
            ),
            SizedBox(height: 12.h),
            _TransactionCard(
              transaction: TransactionModel(
                transactionStatus: TransactionStatus.deposit,
                transactionDateTime: DateTime(2026, 4, 10, 10, 15),
                operationNumber: '2165484948',
                transactionNumber: '84948-S',
                amount: '2,700.00',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Balance Card
// ─────────────────────────────────────────
class _BalanceCard extends StatefulWidget {
  @override
  State<_BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<_BalanceCard> {
  bool _hidden = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A56DB).withOpacity(0.08),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 30.w,
              right: 30.w,
              top: 30.h,
              bottom: 10.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(
                  text: 'رصيد حساب التسويات',
                  fontSize: 14.sp,
                  color: AppColors.neutralDarkDarkest,
                ),
                12.hs,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _hidden
                        ? AppText(
                            text: '••••••',
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutralDarkMedium,
                            letterSpacing: 4,
                          )
                        : RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '2,700',
                                  style: TextStyle(
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.neutralDarkMedium,
                                  ),
                                ),
                                TextSpan(
                                  text: '.00',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.neutralDarkMedium,
                                  ),
                                ),
                                TextSpan(
                                  text: '  ج.م',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.neutralDarkMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    10.ws,
                    GestureDetector(
                      onTap: () => setState(() => _hidden = !_hidden),
                      child: Icon(
                        _hidden ? Icons.visibility_off : Icons.visibility_off,
                        color: AppColors.neutralDarkLightest,
                        size: 26.sp,
                      ),
                    ),
                  ],
                ),
                50.hs,
                AppText(
                  text: 'الرصيد المتاح للاستخدام في سداد طلبات السداد',
                  textAlign: TextAlign.center,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neutralDarkMedium,
                ),
                8.hs,
              ],
            ),
          ),
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (dialogContext) => AppInfoDialog(
                title: 'كيف يتم استخدام رصيد حساب التسويات؟',
                content:
                    'يتم استخدام رصيد حساب التسويات أثناء سداد طلبات السداد من خلال خطوات الدفع.',
                context: dialogContext,
              ),
            ),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: ImageSvgCustomWidget(imgPath: FixedAssets.instance.infoIC),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Transaction Card
// ─────────────────────────────────────────
class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.transaction});

  final TransactionModel transaction;

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
            children: [
              AppStatusBadge(
                label: transaction.transactionStatus.displayText,
                bgColor: transaction.transactionStatus.statusColor,
              ),
              12.ws,
              Expanded(
                child: PaymentInfoBox(
                  label: 'المبلغ',
                  value: transaction.amount,
                  suffix: '  ج.م',
                  valueColor: AppColors.warningDark,
                  valueFontSize: 16.sp,
                ),
              ),
            ],
          ),
          12.hs,

          Row(
            children: [
              Expanded(
                child: PaymentInfoBox(
                  label: 'رقم العملية/طلب السداد',
                  value: transaction.transactionNumber,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  alignment: AlignmentDirectional.centerStart,
                ),
              ),
              8.ws,
              Expanded(
                child: PaymentInfoBox(
                  label: 'رقم الإجراء',
                  value: transaction.operationNumber,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  alignment: AlignmentDirectional.centerStart,
                ),
              ),
            ],
          ),
          12.hs,

          PaymentInfoBox(
            label: 'تاريخ ووقت العملية',
            value: transaction.transactionDateTime?.toArabicTransactionFormat,
            crossAxisAlignment: CrossAxisAlignment.start,
            alignment: AlignmentDirectional.centerStart,
          ),
        ],
      ),
    );
  }
}
