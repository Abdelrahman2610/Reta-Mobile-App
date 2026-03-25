import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_bar.dart';
import '../../../components/app_text.dart';
import '../../../components/circular_progress_indicator_platform_widget.dart';
import '../../../components/image_svg_custom_widget.dart';
import '../../../declarations/presentations/components/empty_data_widget.dart';
import '../../data/models/payment_filter.dart';
import '../../data/models/payment_lookups.dart';
import '../components/payment_filter_bottom_sheet.dart';
import '../components/payment_request_card.dart';
import '../cubit/claim_status_lookup/claim_status_lookup_cubit.dart';
import '../cubit/claim_status_lookup/claim_status_lookup_state.dart';
import '../cubit/payment_claims/payment_claims_cubit.dart';

class PaymentRequestsPage extends StatelessWidget {
  const PaymentRequestsPage({super.key, required this.declarationId});
  final String declarationId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PaymentClaimsCubit()..fetchClaims(declarationId),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => ClaimStatusLookupCubit()..fetchClaimStatuses(),
        ),
      ],
      child: _PaymentRequestsView(declarationId: declarationId),
    );
  }
}

class _PaymentRequestsView extends StatefulWidget {
  const _PaymentRequestsView({required this.declarationId});
  final String declarationId;

  @override
  State<_PaymentRequestsView> createState() => _PaymentRequestsViewState();
}

class _PaymentRequestsViewState extends State<_PaymentRequestsView> {
  late PaymentFilterData _filterData;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _filterData = PaymentFilterData(
      dateFrom: DateTime(now.year, now.month - 1, now.day),
      dateTo: now,
      statusId: 'all',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightMedium,
      appBar: MainAppBar(
        title: 'طلبات السداد',
        backgroundColor: AppColors.mainBlueIndigoDye,
        backButtonIconColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: BlocBuilder<PaymentClaimsCubit, PaymentClaimsState>(
        builder: (context, state) {
          if (state is PaymentClaimsLoading) {
            return const CircularProgressIndicatorPlatformWidget();
          }

          if (state is PaymentClaimsError) {
            return Center(child: Text(state.message));
          }

          if (state is PaymentClaimsSuccess) {
            if (state.claims.isEmpty) {
              return const EmptyDataWidget(
                title: 'لا توجد طلبات سداد مُصدرة حاليًا',
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  45.hs,
                  _BankDepositBanner(),
                  15.hs,
                  const Divider(),
                  20.hs,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: AppText(
                          text: 'طلبات السداد الخاصة بجميع إقراراتك',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainBlueIndigoDye,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      _FilterChip(
                        count: state.total,
                        onTap: () {
                          final lookupState = context
                              .read<ClaimStatusLookupCubit>()
                              .state;
                          final statuses =
                              lookupState is ClaimStatusLookupSuccess
                              ? lookupState.statuses
                              : <PaymentStatusLookup>[];

                          showPaymentFilterSheet(
                            context,
                            initialFilter: _filterData,
                            statuses: statuses,
                            onApply: (filter) {
                              setState(() => _filterData = filter);
                              context.read<PaymentClaimsCubit>().fetchClaims(
                                widget.declarationId,
                                filter,
                              ); // ← طبّق الفلتر
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  20.hs,
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.claims.length,
                      itemBuilder: (context, index) {
                        final claim = state.claims[index];
                        return PaymentClaimCard(
                          claim: claim,
                          onPayElectronically: claim.canPayElectronically
                              ? () {}
                              : null,
                          onShare: () {},
                          onDelete: claim.canDelete ? () {} : null,
                          onPrint: claim.canPrint ? () {} : null,
                          onViewReceipt: claim.isPaid ? () {} : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _BankDepositBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.highlightLightest,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageSvgCustomWidget(imgPath: FixedAssets.instance.infoIC),
          12.ws,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  text: 'للإيداع البنكي',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutralDarkDarkest,
                ),
                4.hs,
                AppText(
                  text: 'استخدم رقم طلب السداد للدفع عبر البنوك المتاحة.',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neutralDarkMedium,
                ),
                4.hs,
                GestureDetector(
                  onTap: () {},
                  child: AppText(
                    text: 'عرض البنوك المتاحة',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.highlightDarkest,
                    textDecoration: TextDecoration.underline,
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.count, required this.onTap});
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.highlightLightest,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.highlightDarkest),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageSvgCustomWidget(
              imgPath: FixedAssets.instance.filterIC,
              width: 12.w,
              height: 12.h,
            ),
            6.ws,
            AppText(
              text: 'تصفية',
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.neutralDarkDarkest,
            ),
            6.ws,
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppColors.highlightDarkest,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: AppText(
                text: count.toString(),
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
                alignment: AlignmentDirectional.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
