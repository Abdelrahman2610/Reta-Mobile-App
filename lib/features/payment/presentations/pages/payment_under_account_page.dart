import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_scaffold.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/circular_progress_indicator_platform_widget.dart';
import 'package:reta/features/declarations/presentations/components/empty_data_widget.dart';
import 'package:reta/features/payment/presentations/components/app_status_badge.dart';
import 'package:reta/features/payment/presentations/components/payment_text_form_field.dart';
import 'package:reta/features/payment/presentations/cubit/payment_under_account/payment_under_account_cubit.dart';
import 'package:reta/features/payment/presentations/pages/payment_info_page.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/extensions/my_debts_status.dart';
import '../../data/models/payment_under_account_model.dart';

class PaymentUnderAccountPage extends StatelessWidget {
  const PaymentUnderAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentUnderAccountCubit()..fetchDeclarations(),
      child: const _PaymentUnderAccountView(),
    );
  }
}

class _PaymentUnderAccountView extends StatelessWidget {
  const _PaymentUnderAccountView();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      title: 'المدفوعات تحت الحساب',
      child: BlocBuilder<PaymentUnderAccountCubit, PaymentUnderAccountState>(
        builder: (context, state) {
          if (state is PaymentUnderAccountLoading) {
            return const CircularProgressIndicatorPlatformWidget();
          }
          if (state is PaymentUnderAccountError) {
            return Center(child: Text(state.message));
          }
          if (state is PaymentUnderAccountSuccess) {
            if (state.declarations.isEmpty) {
              return const EmptyDataWidget(
                title: 'لا توجد مدفوعات تحت الحساب حالياً',
              );
            }
            return _PaymentUnderAccountList(declarations: state.declarations);
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _PaymentUnderAccountList extends StatelessWidget {
  const _PaymentUnderAccountList({required this.declarations});
  final List<PaymentUnderAccountModel> declarations;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppText(
            text:
                'استعرض جميع الإقرارات المقدمة وحالة سداد المبالغ المستحقة تحت الحساب لكل منها.',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.mainBlueIndigoDye,
            textAlign: TextAlign.right,
            maxLines: 3,
          ),
          24.hs,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: declarations.length,
            separatorBuilder: (_, __) => 16.hs,
            itemBuilder: (_, index) =>
                _PaymentUnderAccountCard(item: declarations[index]),
          ),
        ],
      ),
    );
  }
}

class _PaymentUnderAccountCard extends StatelessWidget {
  const _PaymentUnderAccountCard({required this.item});
  final PaymentUnderAccountModel item;

  bool get isDraft => item.statusId == '1';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.7, 0),
          radius: 0.6,
          colors: [
            Color(0xFFD1D1D1),
            Color(0xFFE3E2E2),
            Color(0xFFEDEDED),
            Color(0xFFFFFFFF),
          ],
          stops: [0.0, 0.025, 0.55, 1.0],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.neutralLightDark, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'إقرار ${item.declarationTypeText ?? ''}',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.mainBlueIndigoDye,
              ),
              AppStatusBadge(
                label: item.statusText ?? '',
                bgColor: myDebtsStatusColor(item.statusId ?? ''),
              ),
            ],
          ),
          16.hs,

          Row(
            children: [
              Expanded(
                child: PaymentInfoBox(
                  label: 'رقم الإقرار',
                  value: item.declarationNumber ?? '',
                  crossAxisAlignment: CrossAxisAlignment.start,
                  alignment: AlignmentDirectional.centerStart,
                ),
              ),
              12.ws,
              Expanded(
                child: PaymentInfoBox(
                  label: 'صفة مقدم الطلب',
                  value: item.submitterType ?? '',
                  crossAxisAlignment: CrossAxisAlignment.start,
                  alignment: AlignmentDirectional.centerStart,
                ),
              ),
            ],
          ),
          8.hs,
          Row(
            children: [
              Expanded(
                child: PaymentInfoBox(
                  label: 'عدد العقارات داخل الإقرار',
                  value: item.unitsCount.toString(),
                  valueColor: AppColors.mainOrange,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  alignment: AlignmentDirectional.centerStart,
                ),
              ),
              12.ws,
              Expanded(
                child: PaymentInfoBox(
                  label: 'عدد العقارات غير المسددة',
                  value: item.unpaidPropertyCount.toString(),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  alignment: AlignmentDirectional.centerStart,
                ),
              ),
            ],
          ),
          8.hs,

          Row(
            children: [
              Expanded(
                child: PaymentInfoBox(
                  label: 'إجمالي المبلغ تحت الحساب',
                  value:
                      '${item.totalAmountUnderAccount.toStringAsFixed(2)} ج.م ',
                  valueColor: AppColors.errorDark,
                ),
              ),
              12.ws,
              Expanded(
                child: PaymentInfoBox(
                  label: 'إجمالي المبلغ المسدد',
                  value: '${item.totalPaidAmount.toStringAsFixed(2)} ج.م ',
                  valueColor: AppColors.successDark,
                ),
              ),
            ],
          ),
          8.hs,
          PaymentInfoBox(
            label: 'إجمالي المبلغ المستحق سداده',
            value: '${item.totalAmountDue.toStringAsFixed(2)} ج.م ',
            valueColor: AppColors.highlightDarkest,
          ),
          // زرار الدفع — بس لو مش مسودة
          if (!isDraft) ...[
            16.hs,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: PaymentInfoPage(
                      declarationId: item.id.toString(),
                      fromDeclarationConfirmation: false,
                      claimsSource: ClaimsSource.declaration,
                    ),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.highlightDarkest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: AppText(
                  text: 'الدفع تحت الحساب',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  alignment: AlignmentDirectional.center,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
