import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/features/payment/presentations/components/payment_selected_box.dart';
import 'package:reta/features/payment/presentations/pages/payment_request_page.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_container.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/app_text.dart';
import '../../../components/circular_progress_indicator_platform_widget.dart';
import '../../../components/image_svg_custom_widget.dart';
import '../../../declarations/presentations/components/declaration_data_tab.dart';
import '../../data/models/payment_unit_item.dart';
import '../components/payment_button.dart';
import '../cubit/payment_info/payment_info_cubit.dart';

class PaymentInfoPage extends StatelessWidget {
  final String declarationId;

  const PaymentInfoPage({super.key, required this.declarationId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentInfoCubit()..fetchUnits(declarationId),
      child: _PaymentInfoView(declarationId: declarationId),
    );
  }
}

class _PaymentInfoView extends StatelessWidget {
  final String declarationId;

  const _PaymentInfoView({super.key, required this.declarationId});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      title: 'طلبات السداد',
      child: BlocListener<PaymentInfoCubit, PaymentInfoState>(
        listener: (context, state) {
          if (state is PaymentInfoClaimSuccess) {
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: PaymentRequestsPage(declarationId: declarationId),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.slideUp,
            );
          }
          if (state is PaymentInfoError) {}
        },
        child: BlocBuilder<PaymentInfoCubit, PaymentInfoState>(
          builder: (context, state) {
            if (state is PaymentInfoLoading) {
              return const CircularProgressIndicatorPlatformWidget();
            }
            if (state is PaymentInfoError) {
              return Center(child: AppText(text: state.message));
            }
            if (state is PaymentInfoSuccess) {
              return _PaymentInfoContent(
                data: state.data,
                declarationId: declarationId,
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _PaymentInfoContent extends StatelessWidget {
  final PaymentInfoResponse data;
  final String declarationId;

  const _PaymentInfoContent({required this.data, required this.declarationId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PaymentInfoCubit>();

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
                      _StepIndicator(),
                      20.hs,
                      _SuccessBanner(),
                      20.hs,
                      AppContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 20.h,
                        ),
                        child: Column(
                          children: [
                            // Header
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
                            // Info banner
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.highlightLightest,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                children: [
                                  ImageSvgCustomWidget(
                                    imgPath: FixedAssets.instance.infoIC,
                                  ),
                                  16.ws,
                                  Expanded(
                                    child: AppText(
                                      text:
                                          'يمكنك اختيار جميع الوحدات أو بعضها لإصدار طلب السداد.',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.neutralDarkDarkest,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            24.hs,
                            // Units list
                            ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.units.length,
                              separatorBuilder: (_, __) => 16.hs,
                              itemBuilder: (context, index) {
                                final unit = data.units[index];
                                return _UnitCard(
                                  unit: unit,
                                  onToggleSelect: () => cubit.toggleUnit(index),
                                  onToggleWallet: (v) =>
                                      cubit.toggleWallet(index, v),
                                );
                              },
                            ),
                            12.hs,
                          ],
                        ),
                      ),
                      44.hs,
                    ],
                  ),
                ),
                // Total
                AppContainer(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    children: [
                      _AmountRow(
                        label: 'المبلغ المطلوب سداده',
                        amount: cubit.totalRequired.toStringAsFixed(2),
                      ),
                      10.hs,
                      PaymentButton(
                        label: 'إصدار طلب السداد',
                        onTap: () => context
                            .read<PaymentInfoCubit>()
                            .createClaim(declarationId),
                      ),
                    ],
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

class _UnitCard extends StatelessWidget {
  final PaymentUnitItemModel unit;
  final VoidCallback onToggleSelect;
  final ValueChanged<bool> onToggleWallet;

  const _UnitCard({
    required this.unit,
    required this.onToggleSelect,
    required this.onToggleWallet,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unit.isChecked ? 0.7 : 1,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: unit.isChecked
              ? AppColors.neutralLightLightest
              : unit.isSelected
              ? AppColors.highlightLightest
              : AppColors.neutralLightLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.neutralLightDarkest, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Unit header row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PaymentSelectedBox(
                  isSelected: unit.isSelected,
                  onTap: unit.isChecked ? () {} : onToggleSelect,
                  isChecked: unit.isChecked,
                ),
                10.ws,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          AppText(
                            text: unit.propertyType,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.mainBlueIndigoDye,
                            textAlign: TextAlign.right,
                          ),
                          6.ws,
                          AppText(
                            text: '— ${unit.propertyName}',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutralDarkDark,
                            textAlign: TextAlign.right,
                          ),
                          6.ws,
                        ],
                      ),
                      6.hs,
                      AppText(
                        text: '${unit.governorate} - ${unit.propertyNumber}',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutralDarkMedium,
                        textAlign: TextAlign.right,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            12.hs,
            Divider(color: AppColors.neutralLightDarkest),
            6.hs,
            _AmountRow(
              label: 'المبلغ المطلوب سداده',
              amount: unit.amountUnderPayment.toStringAsFixed(2),
            ),
            15.hs,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.neutralLightDarkest),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _AmountRow(
                      label: 'المبلغ الجاري سداده',
                      amount: unit.requiredAmount?.toStringAsFixed(2),
                      backgroundColor: AppColors.neutralLightMedium,
                    ),
                  ),
                  12.ws,
                  Expanded(
                    child: _AmountRow(
                      label: 'المبلغ المسدد',
                      amount: unit.paidAmount?.toStringAsFixed(2),
                      backgroundColor: AppColors.neutralLightMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final String? amount;
  final Color? backgroundColor;

  const _AmountRow({required this.label, this.amount, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          text: label,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.mainBlueIndigoDye,
          textAlign: TextAlign.center,
          alignment: AlignmentDirectional.center,
        ),
        6.hs,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: AppColors.neutralLightDarkest,
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: AppText(
                      text: amount ?? '00.00',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutralDarkMedium,
                      alignment: AlignmentDirectional.center,
                    ),
                  ),
                  10.ws,
                  Container(
                    width: 0.5.w,
                    height: 25.h,
                    color: AppColors.neutralLightDarkest,
                  ),
                  10.ws,
                  AppText(
                    text: 'ج.م',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.neutralDarkMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      boxShadow: [],
      child: Column(
        children: [
          Row(
            children: [
              DeclarationDataTab(
                declarationsType: DeclarationsDataType.payInfo,
                isSelected: true,
                isFinished: false,
              ),
              DeclarationDataTab(
                declarationsType: DeclarationsDataType.paymentRequests,
                isSelected: false,
                isFinished: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          ImageSvgCustomWidget(imgPath: FixedAssets.instance.successIC),
          16.ws,
          AppText(
            text: 'تم تقديم الإقرار بنجاح',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.neutralDarkDarkest,
          ),
        ],
      ),
    );
  }
}
