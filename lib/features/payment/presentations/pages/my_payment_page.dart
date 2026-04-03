import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/features/components/app_scaffold.dart';
import 'package:reta/features/payment/presentations/pages/payment_request_page.dart';
import 'package:reta/features/payment/presentations/pages/payment_under_account_page.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../auth/presentation/cubit/home_cubit.dart';
import '../components/my_payment_card.dart';
import '../cubit/claim_status_lookup/claim_status_lookup_cubit.dart';

class MyPaymentPage extends StatelessWidget {
  const MyPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => ClaimStatusLookupCubit()..fetchClaimStatuses(),
      child: _MyPaymentPage(),
    );
  }
}

class _MyPaymentPage extends StatelessWidget {
  const _MyPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'مدفوعاتي',
      onBackTapped: () => context.read<HomeCubit>().selectTab(0),
      child: ListView(
        padding: EdgeInsets.only(top: 35.h),
        children: [
          MyPaymentCard(
            iconPath: FixedAssets.instance.paymentRequestsIC,
            title: 'طلبات السداد',
            content:
                'جميع طلبات السداد التي تم إصدارها عند تقديم الإقرار، ويمكن سدادها لاحقًا عبر الدفع الإلكتروني أو الإيداع البنكي.',
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: PaymentRequestsPage(
                  claimsSource: ClaimsSource.declaration,
                  fromDebts: false,
                ),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
              );
            },
          ),
          10.hs,
          MyPaymentCard(
            iconPath: FixedAssets.instance.paymentUnderAccountIC,
            title: 'المدفوعات تحت الحساب',
            content:
                'الإقرارات المقدَّمة التي لم يتم إصدار طلب سداد لها بعد أو تم سدادها جزئيًا.',
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: PaymentUnderAccountPage(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
              );
            },
          ),
        ],
      ),
    );
  }
}
