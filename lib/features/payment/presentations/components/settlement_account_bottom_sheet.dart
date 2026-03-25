import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_text.dart';

import '../../../../core/helpers/extensions/dimensions.dart';

Future<bool?> showSettlementAccountBottomSheet({
  required BuildContext context,
  required double settlementBalance,
  required double requiredAmount,
}) {
  final hasSufficientBalance = settlementBalance >= requiredAmount;

  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SettlementAccountBottomSheet(
      settlementBalance: settlementBalance,
      requiredAmount: requiredAmount,
      hasSufficientBalance: hasSufficientBalance,
    ),
  );
}

class SettlementAccountBottomSheet extends StatelessWidget {
  const SettlementAccountBottomSheet({
    super.key,
    required this.settlementBalance,
    required this.requiredAmount,
    required this.hasSufficientBalance,
  });

  final double settlementBalance;
  final double requiredAmount;
  final bool hasSufficientBalance;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24.r),
            topLeft: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            8.hs,
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.bottomSheetDragger,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            16.hs,

            // ── Header ──────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Row(
                children: [
                  SizedBox(width: 36.w), // balance for close button
                  Expanded(
                    child: Column(
                      children: [
                        AppText(
                          text: 'حساب التسويات',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.bottomSheetTitle,
                          alignment: AlignmentDirectional.center,
                        ),
                        4.hs,
                        AppText(
                          text: 'استخدام الرصيد المتاح لسداد طلب السداد',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.bottomSheetContent,
                          alignment: AlignmentDirectional.center,
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () => Navigator.pop(context, false),
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: const Color(0x78DAD8D8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18.sp,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            45.hs,

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  // ── Balance Card ───────────────────
                  _BalanceCard(balance: settlementBalance),
                  30.hs,

                  // ── Required Amount ────────────────
                  Column(
                    children: [
                      AppText(
                        text: 'المبلغ المطلوب سداده',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                        alignment: AlignmentDirectional.center,
                      ),
                      15.hs,
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: _formatAmount(requiredAmount),
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.highlightDarkest,
                              ),
                            ),
                            TextSpan(
                              text: '  ج.م',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.highlightDarkest,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  20.hs,

                  // ── Sufficient / Insufficient ──────
                  hasSufficientBalance
                      ? _SufficientContent(
                          onConfirm: () => Navigator.pop(context, true),
                          onDecline: () => Navigator.pop(context, false),
                        )
                      : _InsufficientContent(
                          onDismiss: () => Navigator.pop(context, false),
                        ),
                ],
              ),
            ),
            32.hs,
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$intPart.${parts[1]}';
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});
  final double balance;

  String _formatAmount(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$intPart.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A56DB).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'رصيد حساب التسويات',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.neutralDarkMedium,
          ),
          12.hs,
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              children: [
                TextSpan(
                  text: _formatAmount(balance).split('.')[0],
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.neutralDarkMedium,
                  ),
                ),
                TextSpan(
                  text: '.${_formatAmount(balance).split('.')[1]}',
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
          50.hs,

          AppText(
            text: 'الرصيد المتاح للاستخدام في سداد طلبات السداد',
            textAlign: TextAlign.center,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.neutralDarkMedium,
          ),
        ],
      ),
    );
  }
}

class _SufficientContent extends StatelessWidget {
  const _SufficientContent({required this.onConfirm, required this.onDecline});

  final VoidCallback onConfirm;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          text:
              'هل توافق على سداد هذا المبلغ من الرصيد المتاح في حساب التسويات؟',
          textAlign: TextAlign.center,
          fontSize: 14.sp,
          color: const Color(0xFF374151),
          maxLines: 2,
        ),
        24.hs,
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onDecline,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  side: const BorderSide(color: Color(0xFF1A56DB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: AppText(
                  text: 'غير موافق',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.highlightDarkest,
                  alignment: AlignmentDirectional.center,
                ),
              ),
            ),
            12.ws,
            // موافق
            Expanded(
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A56DB),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                  alignment: AlignmentDirectional.center,
                ),
                child: AppText(
                  text: 'موافق',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  alignment: AlignmentDirectional.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// Insufficient Balance Content
// ─────────────────────────────────────────

class _InsufficientContent extends StatelessWidget {
  const _InsufficientContent({required this.onDismiss});
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'الرصيد المتاح غير كافي لتغطية هذا المبلغ.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFEF4444),
          ),
        ),
        12.hs,
        Text(
          'يمكنك سداد هذا الطلب لاحقًا\nعبر الدفع الإلكتروني أو الإيداع البنكي.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF374151),
            height: 1.6,
          ),
        ),
        24.hs,
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onDismiss,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A56DB),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'حسنًا',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
