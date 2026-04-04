import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/payment/data/models/available_banks.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import 'bank_item.dart';

class AvailableBanksBottomSheet extends StatelessWidget {
  AvailableBanksBottomSheet({super.key});

  final List<AvailableBanks> availableBanks = [
    AvailableBanks(
      index: 0,
      title: 'بنك مصر',
      imagePath: FixedAssets.instance.misrBank,
    ),
    AvailableBanks(
      index: 1,
      title: 'البنك الأهلي المصري',
      imagePath: FixedAssets.instance.nationalBank,
    ),
    AvailableBanks(
      index: 2,
      title: 'بنك الإسكندرية',
      imagePath: FixedAssets.instance.alexandriaBank,
    ),
    AvailableBanks(
      index: 3,
      title: 'بنك القاهرة',
      imagePath: FixedAssets.instance.cairoBank,
    ),
    AvailableBanks(
      index: 4,
      title: 'Bank ABC',
      imagePath: FixedAssets.instance.aBCBank,
    ),
    AvailableBanks(
      index: 5,
      title: 'بنك التعمير والإسكان',
      imagePath: FixedAssets.instance.housingBank,
    ),
    AvailableBanks(
      index: 6,
      title: 'البريد المصري',
      imagePath: FixedAssets.instance.egyptPostBank,
    ),
    AvailableBanks(
      index: 7,
      title: 'البنك العقاري المصري العربي ELAB',
      imagePath: FixedAssets.instance.egyptianArabLandBank,
    ),
    AvailableBanks(
      index: 8,
      title: 'Saib',
      imagePath: FixedAssets.instance.saibBank,
    ),
    AvailableBanks(
      index: 9,
      title: 'بنك الإمارات دبي الوطني Emirates NBD',
      imagePath: FixedAssets.instance.dubaiBank,
    ),
    AvailableBanks(
      index: 10,
      title: 'National Investment Bank (NIB) بنك الاستثمار الدولي',
      imagePath: FixedAssets.instance.nationalInvestmentBank,
    ),
    AvailableBanks(
      index: 11,
      title: 'البنك العربي ARAB BANK',
      imagePath: FixedAssets.instance.arabBank,
    ),
    AvailableBanks(
      index: 12,
      title: 'Al Baraka البركة',
      imagePath: FixedAssets.instance.alBarakaBank,
    ),
    AvailableBanks(
      index: 13,
      title: 'NBG Bank البنك الأهلي اليوناني',
      imagePath: FixedAssets.instance.nationalGreeceBank,
    ),
    AvailableBanks(
      index: 14,
      title: 'بنك فيصل الإسلامي',
      imagePath: FixedAssets.instance.faisalBank,
    ),
    AvailableBanks(
      index: 15,
      title: 'بنك أبوظبي الأول مصر FAB MISR',
      imagePath: FixedAssets.instance.fabBank,
    ),
    AvailableBanks(
      index: 16,
      title: 'EG Bank البنك المصري الخليجي',
      imagePath: FixedAssets.instance.eGBank,
    ),
    AvailableBanks(
      index: 17,
      title: 'ABK الأهلي',
      imagePath: FixedAssets.instance.abkBank,
    ),
    AvailableBanks(
      index: 18,
      title: 'ahli united bank البنك الأهلي المتحد',
      imagePath: FixedAssets.instance.ahliUnitedBank,
    ),
    AvailableBanks(
      index: 19,
      title: 'ai Bank ARAB Investment Bank  بنك الاستثمار العربي',
      imagePath: FixedAssets.instance.arabInvestmentBank,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    log('MSG: ${availableBanks.first.imagePath}');
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox.shrink(),
                  AppText(
                    text: 'البنوك المتاحة للإيداع البنكي',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelsVibrantPrimary,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 46.w),
              child: Column(
                children: [
                  40.hs,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: AppText(
                      text:
                          'يمكن استخدام رقم طلب السداد عند الإيداع في أي من البنوك التالية.',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutralDarkMedium,
                      maxLines: 2,
                      alignment: AlignmentDirectional.center,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  25.hs,
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        BankItem(availableBank: availableBanks[index]),
                    separatorBuilder: (_, __) => 6.hs,
                    itemCount: availableBanks.length,
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
