import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/features/components/app_scaffold.dart';
import 'package:reta/features/payment/presentations/pages/payment_info_page.dart';
import 'package:reta/features/payment/presentations/pages/settlement_account_page.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../components/my_payment_card.dart';

class MyPaymentPage extends StatelessWidget {
  const MyPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'مدفوعاتي',
      child: ListView(
        padding: EdgeInsets.only(top: 35.h),
        children: [
          MyPaymentCard(
            iconPath: FixedAssets.instance.settlementIC,
            title: 'حساب التسويات',
            content:
                'رصيد متاح ناتج عن مدفوعات سابقة، يمكن استخدامه لسداد طلبات سداد جديدة، ويُستخدم فقط في سداد الطلبات.',
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: SettlementAccountPage(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
              );
            },
          ),
          10.hs,
          MyPaymentCard(
            iconPath: FixedAssets.instance.paymentRequestsIC,
            title: 'طلبات السداد',
            content:
                'جميع طلبات السداد التي تم إصدارها عند تقديم الإقرار، ويمكن سدادها لاحقًا عبر الدفع الإلكتروني أو الإيداع البنكي.',
            counter: '1',
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: PaymentInfoPage(),
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
            counter: '2',
          ),
        ],
      ),
    );
  }
}
