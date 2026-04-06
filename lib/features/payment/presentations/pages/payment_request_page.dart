import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/runtime_data.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/payment/presentations/components/available_banks_bottom_sheet.dart';
import 'package:reta/features/payment/presentations/components/filter_chip.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/app_text.dart';
import '../../../components/circular_progress_indicator_platform_widget.dart';
import '../../../components/image_svg_custom_widget.dart';
import '../../../declarations/presentations/components/empty_data_widget.dart';
import '../../data/models/payment_filter.dart';
import '../../data/models/payment_lookups.dart';
import '../components/claim_receipt_bottom_sheet.dart';
import '../components/payment_filter_bottom_sheet.dart';
import '../components/payment_request_card.dart';
import '../components/step_indicator.dart';
import '../cubit/claim_status_lookup/claim_status_lookup_cubit.dart';
import '../cubit/claim_status_lookup/claim_status_lookup_state.dart';
import '../cubit/payment_claims/payment_claims_cubit.dart';
import 'electronic_payment_page.dart';

class PaymentRequestsPage extends StatelessWidget {
  const PaymentRequestsPage({
    super.key,
    this.declarationId,
    required this.claimsSource,
    this.onClaimDeleted,
    required this.fromDebts,
  });
  final String? declarationId;
  final ClaimsSource claimsSource;
  final VoidCallback? onClaimDeleted;
  final bool fromDebts;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PaymentClaimsCubit()
            ..fetchClaims(declarationId: declarationId, source: claimsSource),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => ClaimStatusLookupCubit()..fetchClaimStatuses(),
        ),
      ],
      child: _PaymentRequestsView(
        declarationId: declarationId,
        source: claimsSource,
        onClaimDeleted: onClaimDeleted,
        fromDebts: fromDebts,
      ),
    );
  }
}

class _PaymentRequestsView extends StatefulWidget {
  const _PaymentRequestsView({
    this.declarationId,
    required this.source,
    this.onClaimDeleted,
    required this.fromDebts,
  });
  final String? declarationId;
  final ClaimsSource source;
  final VoidCallback? onClaimDeleted;
  final bool fromDebts;

  @override
  State<_PaymentRequestsView> createState() => _PaymentRequestsViewState();
}

class _PaymentRequestsViewState extends State<_PaymentRequestsView> {
  late PaymentFilterData _filterData;

  @override
  void initState() {
    super.initState();
    initFilter();
  }

  void initFilter() {
    final now = DateTime.now();
    _filterData = PaymentFilterData(
      dateFrom: DateTime(now.year, now.month - 1, now.day),
      dateTo: now,
      statusId: 'all',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      title: 'طلبات السداد',
      child: BlocConsumer<PaymentClaimsCubit, PaymentClaimsState>(
        listener: (context, state) {
          if (state is PaymentClaimsDeleteSuccess) {
            widget.onClaimDeleted?.call();
          }
        },
        builder: (context, state) {
          if (state is PaymentClaimsLoading) {
            return const CircularProgressIndicatorPlatformWidget();
          }

          if (state is PaymentClaimsError) {
            return Center(child: Text(state.message));
          }

          if (state is PaymentClaimsSuccess) {
            if (state.claims.isEmpty) {
              return Column(
                children: [
                  26.hs,
                  if (widget.declarationId != null) ...[
                    StepIndicator(
                      currentStep: 2,
                      onFirstStepTapped: () => Navigator.pop(context),
                    ),
                    24.hs,
                  ],
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: FilterHeader(
                      context,
                      widget.fromDebts,
                      widget.source,
                    ),
                  ),
                  Expanded(
                    child: const EmptyDataWidget(
                      title: 'لا توجد طلبات سداد مُصدرة حاليًا',
                    ),
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    45.hs,
                    if (widget.declarationId != null) ...[
                      StepIndicator(
                        currentStep: 2,
                        onFirstStepTapped: () {
                          Navigator.pop(context);
                        },
                      ),
                      24.hs,
                    ] else ...[
                      AppText(
                        text:
                            ' عرض جميع طلبات السداد الصادرة من مختلف الخدمات (المدفوعات تحت الحساب و تحت حساب المديونية).',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mainBlueIndigoDye,
                        maxLines: 3,
                        alignment: Alignment.center,
                        textAlign: TextAlign.center,
                      ),
                      20.hs,
                    ],

                    _BankDepositBanner(),
                    15.hs,
                    const Divider(),
                    20.hs,
                    FilterHeader(context, widget.fromDebts, widget.source),
                    20.hs,
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.claims.length,
                      itemBuilder: (context, index) {
                        final claim = state.claims[index];
                        return PaymentClaimCard(
                          claim: claim,
                          onPayElectronically: claim.canPayElectronically
                              ? () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: ElectronicPaymentPage(
                                      claimId: claim.id,
                                      declarationId: widget.declarationId,
                                      source: widget.source,
                                      fromDebts: widget.fromDebts,
                                    ),
                                    withNavBar: true,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.slideUp,
                                  );
                                }
                              : null,
                          onShare: claim.claimDetails != null
                              ? () => showClaimReceiptSheet(
                                  context,
                                  title: 'تفاصيل طلب السداد',
                                  pdfUrl: claim.claimDetails!,
                                )
                              : null,
                          onDelete: claim.canDelete
                              ? () async {
                                  final confirmed = await showDialog<bool>(
                                    context: RuntimeData.getCurrentContext()!,
                                    builder: (_) => AlertDialog(
                                      content: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 15.w,
                                          vertical: 15.h,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ImageSvgCustomWidget(
                                              imgPath: FixedAssets
                                                  .instance
                                                  .warningIC,
                                            ),
                                            20.hs,
                                            AppText(
                                              text: 'تأكيد حذف طلب السداد',
                                              fontWeight: FontWeight.w800,
                                              fontSize: 20.sp,
                                              color:
                                                  AppColors.neutralDarkDarkest,
                                              alignment: Alignment.center,
                                            ),
                                            8.hs,
                                            AppText(
                                              text:
                                                  'هل أنت متأكد من رغبتك في حذف طلب السداد من حسابك نهائياً؟',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                              maxLines: 3,
                                              color: AppColors.neutralDarkLight,
                                              alignment: Alignment.center,
                                              textAlign: TextAlign.center,
                                            ),
                                            20.hs,
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: AppButton(
                                                    label: 'إلغاء',
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                    backgroundColor: AppColors
                                                        .neutralLightLightest,
                                                    textColor: AppColors
                                                        .highlightDarkest,
                                                    borderColor: AppColors
                                                        .highlightDarkest,
                                                    onTap: () => Navigator.pop(
                                                      RuntimeData.getCurrentContext()!,
                                                      false,
                                                    ),
                                                  ),
                                                ),
                                                8.ws,
                                                Expanded(
                                                  child: AppButton(
                                                    label: 'حذف طلب السداد',
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                    backgroundColor:
                                                        AppColors.errorDark,
                                                    textColor: AppColors
                                                        .neutralLightLightest,
                                                    onTap: () => Navigator.pop(
                                                      RuntimeData.getCurrentContext()!,
                                                      true,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                  if (confirmed == true) {
                                    context
                                        .read<PaymentClaimsCubit>()
                                        .deleteClaim(
                                          claim.id,
                                          widget.declarationId,
                                          context,
                                        );
                                    widget.onClaimDeleted?.call();
                                  }
                                }
                              : null,
                          onPrint: claim.claimReceipt != null
                              ? () => showClaimReceiptSheet(
                                  context,
                                  title: 'إيصال سداد مبلغ تحت الحساب',
                                  pdfUrl: claim.claimReceipt!,
                                )
                              : null,
                          onViewReceipt: claim.claimDetails != null
                              ? () => showClaimReceiptSheet(
                                  context,
                                  title: 'تفاصيل طلب السداد',
                                  pdfUrl: claim.claimDetails!,
                                )
                              : null,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Row FilterHeader(BuildContext context, bool fromDebts, ClaimsSource source) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: AppText(
            text: widget.declarationId == null
                ? 'طلبات السداد الخاصة بجميع إقراراتك'
                : 'طلبات السداد الصادرة عن الإقرار محل التقديم',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.mainBlueIndigoDye,
            textAlign: TextAlign.right,
            maxLines: 2,
          ),
        ),
        PaymentFilterChip(
          count: _filterData.activeCount,
          onTap: () {
            final lookupState = context.read<ClaimStatusLookupCubit>().state;
            final statuses = lookupState is ClaimStatusLookupSuccess
                ? lookupState.statuses
                : <PaymentStatusLookup>[];

            showPaymentFilterSheet(
              context,
              initialFilter: _filterData,
              statuses: statuses,
              fromDebts: fromDebts,
              onApply: (filter) {
                setState(() => _filterData = filter);
                context.read<PaymentClaimsCubit>().fetchClaims(
                  declarationId: widget.declarationId,
                  filter: filter,
                  source: source,
                );
              },
              onReset: () {
                initFilter();
                setState(() {});
                context.read<PaymentClaimsCubit>().fetchClaims(
                  declarationId: widget.declarationId,
                  filter: _filterData,
                  source: source,
                );
              },
            );
          },
        ),
      ],
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
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => AvailableBanksBottomSheet(),
                    );
                  },
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
