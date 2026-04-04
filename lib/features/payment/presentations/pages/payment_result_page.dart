import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/image_svg_custom_widget.dart';
import 'package:reta/features/payment/presentations/components/payment_button.dart';
import 'package:reta/features/payment/presentations/pages/payment_request_page.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../auth/presentation/cubit/home_cubit.dart';
import '../../../components/app_scaffold.dart';
import '../../../declarations/data/models/declaration_model.dart';
import '../../../declarations/presentations/cubit/declaration/declaration_cubit.dart';
import '../../../declarations/presentations/pages/properties_list_in_declaration_page.dart';
import 'electronic_payment_page.dart';

class PaymentResultPage extends StatelessWidget {
  const PaymentResultPage({
    super.key,
    required this.isSuccess,
    this.declarationId,
    required this.source,
    required this.claimId,
    required this.fromDebts,
  });

  final bool isSuccess;

  final String? declarationId;
  final ClaimsSource source;
  final int claimId;
  final bool fromDebts;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'السداد',
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        alignment: AlignmentDirectional.center,
        padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 48.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: isSuccess
            ? _SuccessContent(
                source: source,
                declarationId: declarationId,
                fromDebts: fromDebts,
              )
            : _FailureContent(
                declarationId: declarationId,
                source: source,
                claimId: claimId,
                fromDebts: fromDebts,
              ),
      ),
    );
  }
}

class _SuccessContent extends StatelessWidget {
  const _SuccessContent({
    this.declarationId,
    required this.source,
    required this.fromDebts,
  });

  final String? declarationId;
  final ClaimsSource source;
  final bool fromDebts;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageSvgCustomWidget(imgPath: FixedAssets.instance.paymentSuccessIC),
        20.hs,

        AppText(
          text: 'نجاح عملية الدفع',
          fontSize: 20.sp,
          fontWeight: FontWeight.w800,
          alignment: AlignmentDirectional.center,
          color: AppColors.successMedium,
        ),
        20.hs,

        AppText(
          text: 'تمت عملية الدفع لطلب السداد بنجاح',
          textAlign: TextAlign.center,
          fontSize: 16.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.neutralDarkDark,
          alignment: AlignmentDirectional.center,
        ),
        40.hs,

        PaymentButton(
          label: 'العودة إلى قائمة طلبات السداد',
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: PaymentRequestsPage(
                declarationId: declarationId ?? '',
                claimsSource: source,
                fromDebts: fromDebts,
              ),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.slideUp,
            );
          },
        ),
        10.hs,

        Row(
          children: [
            Expanded(
              child: _OutlinedButton(
                label: 'إستعراض تفاصيل الإقرار',
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  if (declarationId != null) {
                    final declarationCubit = context.read<DeclarationCubit>();
                    final declaration = declarationCubit.declarationList
                        ?.firstWhere(
                          (d) => d.id.toString() == declarationId,
                          orElse: () => DeclarationModel(),
                        );
                    if (declaration != null && declaration.id != null) {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: PropertiesListInDeclarationPage(
                          declaration,
                          () => declarationCubit.fetchList(),
                        ),
                        withNavBar: true,
                        pageTransitionAnimation:
                            PageTransitionAnimation.slideUp,
                      );
                    }
                  }
                },
              ),
            ),
            12.ws,
            Expanded(
              child: _OutlinedButton(
                label: 'العودة إلى إقراراتي',
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  context.read<HomeCubit>().selectTab(2, isVerified: true);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FailureContent extends StatelessWidget {
  const _FailureContent({
    this.declarationId,
    required this.source,
    required this.claimId,
    required this.fromDebts,
  });

  final String? declarationId;
  final ClaimsSource source;
  final int claimId;
  final bool fromDebts;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageSvgCustomWidget(imgPath: FixedAssets.instance.paymentFailIC),
        24.hs,

        AppText(
          text: 'فشل عملية الدفع',
          fontSize: 20.sp,
          fontWeight: FontWeight.w800,
          alignment: AlignmentDirectional.center,
          color: AppColors.errorMedium,
        ),

        12.hs,

        AppText(
          text: 'تعذرت عملية الدفع لطلب السداد',
          textAlign: TextAlign.center,
          fontSize: 16.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.neutralDarkDark,
          alignment: AlignmentDirectional.center,
        ),
        8.hs,

        AppText(
          text:
              'لم يتم خصم أي مبالغ. يمكنك إعادة المحاولة أو اختيار وسيلة دفع أخرى.',
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w400,
          fontSize: 13.sp,
          color: AppColors.neutralDarkLight,
          maxLines: 2,
        ),
        40.hs,

        PaymentButton(
          label: 'إعادة محاولة سداد المبلغ',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ElectronicPaymentPage(
                  claimId: claimId,
                  declarationId: declarationId,
                  source: source,
                  fromDebts: fromDebts,
                ),
              ),
            );
          },
        ),
        20.hs,

        GestureDetector(
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: PaymentRequestsPage(
                declarationId: declarationId ?? '',
                claimsSource: source,
                fromDebts: fromDebts,
              ),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.slideUp,
            );
          },
          child: AppText(
            text: 'العودة إلى قائمة طلب السداد',
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.highlightDarkest,
            alignment: AlignmentDirectional.center,
          ),
        ),
      ],
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  const _OutlinedButton({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        side: BorderSide(color: AppColors.highlightDarkest),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.highlightDarkest,
        ),
      ),
    );
  }
}
