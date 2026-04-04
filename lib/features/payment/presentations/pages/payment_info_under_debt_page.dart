import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/features/components/app_container.dart';
import 'package:reta/features/components/app_loading.dart';
import 'package:reta/features/payment/presentations/pages/payment_request_page.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/app_text.dart';
import '../../../components/circular_progress_indicator_platform_widget.dart';
import '../../data/models/debt_unit_item.dart';
import '../components/amount_row.dart';
import '../components/editable_amount_row.dart';
import '../components/payment_button.dart';
import '../components/step_indicator.dart';
import '../components/unit_header.dart';
import '../cubit/payment_info_under_debts/payment_info_under_debts_cubit.dart';
import 'debt_documents_page.dart';

class PaymentInfoUnderDebtsPage extends StatelessWidget {
  final String declarationId;
  const PaymentInfoUnderDebtsPage({super.key, required this.declarationId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentInfoUnderDebtsCubit()..fetchUnits(declarationId),
      child: _PaymentInfoUnderDebtsView(declarationId: declarationId),
    );
  }
}

class _PaymentInfoUnderDebtsView extends StatelessWidget {
  final String declarationId;
  const _PaymentInfoUnderDebtsView({required this.declarationId});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      title: 'المدفوعات تحت حساب المديونية',
      child:
          BlocConsumer<PaymentInfoUnderDebtsCubit, PaymentInfoUnderDebtsState>(
            listener: (context, state) {
              if (state is PaymentInfoUnderDebtsClaimSuccess) {
                context.read<PaymentInfoUnderDebtsCubit>().fetchUnits(
                  declarationId,
                );
                final paymentInfoCubit = context
                    .read<PaymentInfoUnderDebtsCubit>();
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: PaymentRequestsPage(
                    declarationId: declarationId,
                    claimsSource: ClaimsSource.underDebt,
                    fromDebts: true,
                    onClaimDeleted: () {
                      paymentInfoCubit.fetchUnits(declarationId);
                    },
                  ),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.slideUp,
                );
              }
              if (state is PaymentInfoUnderDebtsError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is PaymentInfoUnderDebtsLoading) {
                return const CircularProgressIndicatorPlatformWidget();
              }
              if (state is PaymentInfoUnderDebtsError) {
                return Center(child: Text(state.message));
              }
              if (state is PaymentInfoUnderDebtsSuccess) {
                return AppLoadingOverlay(
                  isLoading: state is PaymentInfoUnderDebtsLoading,
                  child: _DebtContent(
                    data: state.data,
                    declarationId: declarationId,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
    );
  }
}

class _DebtContent extends StatelessWidget {
  final DebtUnitsResponse data;
  final String declarationId;
  const _DebtContent({required this.data, required this.declarationId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PaymentInfoUnderDebtsCubit>();
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 20.w,
                    end: 20.w,
                    top: 31.h,
                  ),
                  child: Column(
                    children: [
                      StepIndicator(
                        onSecondStepTapped: () {
                          final paymentInfoCubit = context
                              .read<PaymentInfoUnderDebtsCubit>();
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: PaymentRequestsPage(
                              declarationId: declarationId,
                              claimsSource: ClaimsSource.underDebt,
                              fromDebts: true,
                              onClaimDeleted: () {
                                paymentInfoCubit.fetchUnits(declarationId);
                              },
                            ),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.slideUp,
                          );
                        },
                      ),
                      20.hs,
                      AppContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        child: Column(
                          children: [
                            AppText(
                              text: 'طلب سداد',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.neutralDarkDarkest,
                              alignment: AlignmentDirectional.center,
                            ),
                            6.hs,
                            AppText(
                              text: 'مراجعة البيانات قبل الإصدار',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.neutralDarkMedium,
                              alignment: AlignmentDirectional.center,
                            ),
                            24.hs,
                            AppText(
                              text:
                                  'الوحدات التي سيتم إصدار طلب/طلبات السداد عنها',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.neutralDarkDarkest,
                              alignment: AlignmentDirectional.center,
                            ),
                            24.hs,
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.units.length,
                              separatorBuilder: (_, __) => 16.hs,
                              itemBuilder: (context, index) {
                                return _DebtUnitCard(
                                  unit: data.units[index],
                                  onToggleSelect: () => cubit.toggleUnit(index),
                                  declarationId: declarationId,
                                );
                              },
                            ),
                            24.hs,
                            // Total
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.neutralLightDarkest,
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AmountRow(
                label: 'إجمالي المبلغ المطلوب سداده',
                amount: cubit.totalRequired.toStringAsFixed(2),
              ),
              10.hs,
              PaymentButton(
                label: 'إصدار طلب السداد',
                onTap: cubit.totalRequired > 0 && checkForButton(data.units)
                    ? () => cubit.createClaim(declarationId)
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

bool checkForButton(List<DebtUnitItemModel> units) {
  final selectedUnits = units.where((unit) => unit.isSelected).toList();
  if (selectedUnits.isEmpty) return false;
  return selectedUnits.every(
    (unit) => unit.amountController.text.trim().isNotEmpty,
  );
}

class _DebtUnitCard extends StatelessWidget {
  final DebtUnitItemModel unit;
  final VoidCallback onToggleSelect;
  final String declarationId;

  const _DebtUnitCard({
    required this.unit,
    required this.onToggleSelect,
    required this.declarationId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: unit.isSelected
            ? AppColors.highlightLightest
            : AppColors.neutralLightLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.neutralLightDarkest, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          UnitHeader(
            unit: unit,
            onToggleSelect: onToggleSelect,
            isChecked: false,
          ),
          16.hs,

          EditableAmountField(
            label: 'المبلغ المطلوب سداده',
            controller: unit.amountController,
            enabled: unit.isSelected,
            onChanged: (_) =>
                context.read<PaymentInfoUnderDebtsCubit>().recalculate(),
          ),
          12.hs,
          Row(
            children: [
              Expanded(
                child: AmountRow(
                  label: 'المبلغ الجاري سداده',
                  amount: unit.requiredAmount,
                ),
              ),
              12.ws,
              Expanded(
                child: AmountRow(
                  label: 'المبلغ المسدد',
                  amount: unit.paidAmount,
                ),
              ),
            ],
          ),
          12.hs,

          _AttachmentRow(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DebtDocumentsPage(
                    unit: unit,
                    declarationId: declarationId,
                    onSaved: () {
                      context.read<PaymentInfoUnderDebtsCubit>().fetchUnits(
                        declarationId,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AttachmentRow extends StatelessWidget {
  final VoidCallback onTap;

  const _AttachmentRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppText(
            text: 'إرفاق المستندات الدالة على المديونية',
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.neutralDarkMedium,
          ),
          12.ws,

          Container(
            width: 70.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.highlightDarkest),
            ),
            child: Icon(
              Icons.add,
              color: AppColors.highlightDarkest,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
