import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
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
import '../../data/models/payment_unit_item.dart';
import '../components/amount_row.dart';
import '../components/payment_button.dart';
import '../components/request_unit_card.dart';
import '../components/step_indicator.dart';
import '../components/success_banner.dart';
import '../cubit/payment_info/payment_info_cubit.dart';

class PaymentInfoPage extends StatelessWidget {
  final String declarationId;
  final bool fromDeclarationConfirmation;
  final ClaimsSource claimsSource;

  const PaymentInfoPage({
    super.key,
    required this.declarationId,
    required this.fromDeclarationConfirmation,
    required this.claimsSource,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentInfoCubit()..fetchUnits(declarationId),
      child: _PaymentInfoView(
        declarationId: declarationId,
        fromDeclarationConfirmation: fromDeclarationConfirmation,
        claimsSource: claimsSource,
      ),
    );
  }
}

class _PaymentInfoView extends StatelessWidget {
  final String declarationId;
  final bool fromDeclarationConfirmation;
  final ClaimsSource claimsSource;

  const _PaymentInfoView({
    required this.declarationId,
    required this.fromDeclarationConfirmation,
    required this.claimsSource,
  });
  @override
  Widget build(BuildContext context) {
    PaymentRequestInfoStatus checkInfoStatus(List<PaymentUnitItemModel> units) {
      final total = units.length;
      final checked = units.where((u) => u.isChecked).length;

      if (checked == total) return PaymentRequestInfoStatus.completed;
      if (checked == 0) return PaymentRequestInfoStatus.allAvailable;
      return PaymentRequestInfoStatus.partiallyCompleted;
    }

    return AppScaffold(
      padding: EdgeInsets.zero,
      title: 'طلبات السداد',
      child: BlocListener<PaymentInfoCubit, PaymentInfoState>(
        listener: (context, state) {
          if (state is PaymentInfoClaimSuccess) {
            context.read<PaymentInfoCubit>().fetchUnits(declarationId);
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: PaymentRequestsPage(
                declarationId: declarationId,
                claimsSource: claimsSource,
              ),
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
              final PaymentRequestInfoStatus infoStatus = checkInfoStatus(
                state.data.units,
              );
              return _PaymentInfoContent(
                data: state.data,
                declarationId: declarationId,
                fromDeclarationConfirmation: fromDeclarationConfirmation,
                infoStatus: infoStatus,
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
  final bool fromDeclarationConfirmation;
  final PaymentRequestInfoStatus infoStatus;

  const _PaymentInfoContent({
    required this.data,
    required this.declarationId,
    required this.fromDeclarationConfirmation,
    required this.infoStatus,
  });

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
                      StepIndicator(
                        onSecondStepTapped: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: PaymentRequestsPage(
                              declarationId: declarationId,
                              claimsSource: ClaimsSource.declaration,
                            ),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.slideUp,
                          );
                        },
                      ),
                      20.hs,
                      if (fromDeclarationConfirmation) ...[
                        SuccessBanner(),
                        20.hs,
                      ],
                      AppContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
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
                            _InfoBanner(infoStatus: infoStatus),
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
                                return RequestUnitCard(
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
              ],
            ),
          ),
        ),
        // Total
        AppContainer(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
          child: Column(
            children: [
              if (infoStatus != PaymentRequestInfoStatus.completed)
                AmountRow(
                  label: 'المبلغ المطلوب سداده',
                  amount: cubit.totalRequired.toStringAsFixed(2),
                ),
              10.hs,
              PaymentButton(
                label: 'إصدار طلب السداد',
                textColor: infoStatus == PaymentRequestInfoStatus.completed
                    ? AppColors.neutralDarkLight
                    : null,
                onTap: infoStatus == PaymentRequestInfoStatus.completed
                    ? null
                    : () {
                        context.read<PaymentInfoCubit>().createClaim(
                          declarationId,
                        );
                      },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.infoStatus});

  final PaymentRequestInfoStatus infoStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: infoStatus == PaymentRequestInfoStatus.completed
            ? AppColors.successLight
            : AppColors.highlightLightest,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          ImageSvgCustomWidget(
            imgPath: infoStatus == PaymentRequestInfoStatus.completed
                ? FixedAssets.instance.successIC
                : FixedAssets.instance.infoIC,
          ),
          16.ws,
          Expanded(
            child: AppText(
              text: infoStatus == PaymentRequestInfoStatus.allAvailable
                  ? 'يمكنك اختيار جميع الوحدات أو بعضها لإصدار طلب السداد.'
                  : infoStatus == PaymentRequestInfoStatus.partiallyCompleted
                  ? 'اختر الوحدات المتاحة لإصدار طلب سداد. الوحدات غير القابلة للاختيار تم إصدار طلبات سداد لها مسبقًا.'
                  : infoStatus == PaymentRequestInfoStatus.completed
                  ? 'تم إصدار جميع طلبات السداد لهذا الإقرار. يمكنك متابعة حالة السداد من خلال “طلبات السداد”.'
                  : '',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.neutralDarkDarkest,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
