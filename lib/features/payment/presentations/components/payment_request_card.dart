import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/extensions/payment_request_status.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/components/image_svg_custom_widget.dart';
import 'package:reta/features/payment/presentations/components/app_status_badge.dart';
import 'package:reta/features/payment/presentations/components/expand_toggle.dart';
import 'package:reta/features/payment/presentations/components/payment_text_form_field.dart';
import 'package:reta/features/payment/presentations/pages/payment_transaction_page.dart';

import '../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';
import '../../data/models/payment_claim.dart';
import '../pages/multi_payment_box.dart';

class PaymentClaimCard extends StatefulWidget {
  const PaymentClaimCard({
    super.key,
    required this.claim,
    this.onPayElectronically,
    this.onShare,
    this.onDelete,
    this.onPrint,
    this.onViewReceipt,
  });

  final PaymentClaimModel claim;
  final VoidCallback? onPayElectronically;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;
  final VoidCallback? onPrint;
  final VoidCallback? onViewReceipt;

  @override
  State<PaymentClaimCard> createState() => _PaymentClaimCardState();
}

class _PaymentClaimCardState extends State<PaymentClaimCard>
    with SingleTickerProviderStateMixin {
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
    final claim = widget.claim;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        gradient: claim.status.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: claim.status.badgeColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ─────────────────────────
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    // Status badge
                    AppStatusBadge(
                      label: claim.statusName,
                      bgColor: claim.status.badgeColor,
                    ),

                    const Spacer(),
                    // Expand toggle
                    ExpandToggle(onTap: _toggleExpand, isExpanded: _isExpanded),
                  ],
                ),
                10.hs,

                MultiPaymentBox(
                  firstTitle: 'رقم طلب السداد',
                  firstValue: claim.claimNumber,
                  secondTitle: 'إجمالي المطلوب سداده',
                  secondValue: claim.amount.toStringAsFixed(2),
                ),
              ],
            ),
          ),

          // ── Expandable Details ──────────────
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
              child: Column(
                children: [
                  const Divider(),
                  12.hs,

                  Row(
                    children: [
                      Expanded(
                        child: PaymentInfoBox(
                          label: 'إسم الاجراء',
                          value: claim.procedureType,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          alignment: AlignmentDirectional.centerStart,
                        ),
                      ),
                      12.ws,
                      Expanded(
                        child: PaymentInfoBox(
                          label: 'رقم الاجراء',
                          value: claim.declarationNumber,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          alignment: AlignmentDirectional.centerStart,
                        ),
                      ),
                    ],
                  ),
                  12.hs,
                  if (claim.statusId == 2) ...[
                    _DetailCell(
                      label: 'وسيلة الدفع',
                      value: claim.paymentMethod ?? '',
                      onButtonTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: PaymentTransactionsPage(claimId: claim.id),
                          withNavBar: true,
                          pageTransitionAnimation:
                              PageTransitionAnimation.slideUp,
                        );
                      },
                    ),
                    12.hs,
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: PaymentInfoBox(
                          label: 'عدد العقارات',
                          value: claim.unitCount.toString(),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          alignment: AlignmentDirectional.centerStart,
                        ),
                      ),
                      12.ws,
                      Expanded(
                        child: PaymentInfoBox(
                          label: 'تاريخ طلب السداد',
                          value: claim.claimDate,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          alignment: AlignmentDirectional.centerStart,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Action Buttons ──────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Row(
              children: [
                // Main CTA
                Expanded(
                  child: _MainBtn(
                    claim: claim,
                    onTap: widget.onPayElectronically,
                    onShareTapped: widget.onShare,
                  ),
                ),
                // Share
                if (widget.claim.canShare) ...[
                  8.ws,
                  GestureDetector(
                    onTap: widget.onShare,
                    child: ImageSvgCustomWidget(
                      imgPath: FixedAssets.instance.shareIC,
                    ),
                  ),
                ],

                // Delete
                if (widget.onDelete != null) ...[
                  8.ws,
                  GestureDetector(
                    onTap: widget.onDelete,
                    child: ImageSvgCustomWidget(
                      imgPath: FixedAssets.instance.deleteICGrey,
                    ),
                  ),
                ],

                // Print
                if (claim.canPrint && widget.onPrint != null) ...[
                  8.ws,
                  GestureDetector(
                    onTap: widget.onPrint,
                    child: ImageSvgCustomWidget(
                      imgPath: FixedAssets.instance.printIC,
                    ),
                  ),
                ],

                // View receipt
                if (claim.isPaid && widget.onViewReceipt != null) ...[
                  8.ws,
                  GestureDetector(
                    onTap: widget.onViewReceipt,
                    child: ImageSvgCustomWidget(
                      imgPath: FixedAssets.instance.previewIC,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Detail Cell
// ─────────────────────────────────────────

class _DetailCell extends StatelessWidget {
  const _DetailCell({
    required this.label,
    required this.value,
    this.onButtonTap,
  });
  final String label;
  final String value;
  final VoidCallback? onButtonTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  text: label,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neutralDarkLightest,
                ),
                4.hs,
                AppText(
                  text: value,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutralDarkDark,
                ),
              ],
            ),
          ),
          if (onButtonTap != null)
            Expanded(
              flex: 2,
              child: AppButton(
                label: 'تفاصيل المعاملة',
                borderColor: AppColors.highlightDarkest,
                textColor: AppColors.highlightDarkest,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                borderWidth: 1.5.w,
                onTap: onButtonTap,
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Main CTA Button
// ─────────────────────────────────────────

class _MainBtn extends StatelessWidget {
  const _MainBtn({required this.claim, this.onTap, this.onShareTapped});
  final PaymentClaimModel claim;
  final VoidCallback? onTap;
  final VoidCallback? onShareTapped;

  @override
  Widget build(BuildContext context) {
    final bool isActive = claim.canPayElectronically;
    final bool isShare = claim.isShareButton;
    final bool isEnabled = isActive;

    log('isShare: $isShare, ${claim.statusId}');
    log(
      'onTap: =${isEnabled
          ? 'onTap'
          : isShare
          ? '$onShareTapped'
          : 'null'}',
    );
    return GestureDetector(
      onTap: isEnabled
          ? onTap
          : isShare
          ? onShareTapped
          : null,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: isEnabled || isShare
              ? AppColors.highlightDarkest
              : AppColors.neutralLightDarkest,
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        child: AppText(
          text: isShare ? 'شارك طلب السداد' : 'الدفع الإلكتروني',
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: isEnabled || isShare
              ? Colors.white
              : AppColors.neutralDarkLightest,
          alignment: AlignmentDirectional.center,
        ),
      ),
    );
  }
}
