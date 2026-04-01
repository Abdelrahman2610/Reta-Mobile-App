import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/circular_progress_indicator_platform_widget.dart';
import 'package:reta/features/components/image_svg_custom_widget.dart';
import 'package:reta/features/declarations/presentations/components/empty_data_widget.dart';
import 'package:reta/features/payment/presentations/components/app_status_badge.dart';
import 'package:reta/features/payment/presentations/pages/payment_info_under_debt_page.dart';

import '../../../../core/helpers/extensions/date_time.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/extensions/my_debts_status.dart';
import '../../../auth/presentation/cubit/home_cubit.dart';
import '../../../components/app_bar.dart';
import '../../data/models/debts_filter.dart';
import '../../data/models/my_debts_declaration_model.dart';
import '../components/debts_filter_bottom_sheet.dart';
import '../components/filter_chip.dart';
import '../components/payment_text_form_field.dart';
import '../cubit/settlement/my_debts_cubit.dart';

class MyDebtsPage extends StatelessWidget {
  const MyDebtsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyDebtsCubit()..fetchDeclarations(),
      child: const _MyDebtsView(),
    );
  }
}

class _MyDebtsView extends StatefulWidget {
  const _MyDebtsView();

  @override
  State<_MyDebtsView> createState() => _MyDebtsViewState();
}

class _MyDebtsViewState extends State<_MyDebtsView> {
  late DebtsFilterData _filter;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _filter = DebtsFilterData(
      dateFrom: DateTime(now.year, now.month - 1, now.day),
      dateTo: now,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightMedium,
      appBar: MainAppBar(
        title: 'مديونياتي',
        backButtonAction: () => context.read<HomeCubit>().selectTab(0),
        backgroundColor: AppColors.mainBlueIndigoDye,
        backButtonIconColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: BlocBuilder<MyDebtsCubit, MyDebtsState>(
        builder: (context, state) {
          if (state is MyDebtsLoading) {
            return const CircularProgressIndicatorPlatformWidget();
          }
          if (state is MyDebtsError) {
            return Center(child: AppText(text: state.message));
          }
          if (state is MyDebtsSuccess) {
            if (state.declarations.isEmpty) {
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    36.hs,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          AppText(
                            text: 'لا توجد مديونيات حالياً',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.mainBlueIndigoDye,
                            textAlign: TextAlign.center,
                          ),
                          12.hs,
                          Row(
                            children: [
                              Expanded(
                                child: AppText(
                                  text:
                                      'في حال تقديم إقرار ، سيظهر هنا لتمكينك من إصدار طلب سداد واستكمال إجراءات الدفع.',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.neutralDarkDark,
                                  alignment: AlignmentDirectional.centerStart,
                                  maxLines: 4,
                                ),
                              ),
                              PaymentFilterChip(
                                onTap: () => showDebtsFilterSheet(
                                  context,
                                  initialFilter: _filter,
                                  onApply: (filter) {
                                    setState(() => _filter = filter);
                                    context
                                        .read<MyDebtsCubit>()
                                        .fetchDeclarations(filter: filter);
                                  },
                                ),
                                count: _filter.activeCount,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: const EmptyDataWidget(
                        title: 'لا توجد مديونيات مستحقة حاليًا',
                      ),
                    ),
                  ],
                ),
              );
            }
            return _SettlementList(
              declarations: state.declarations,
              onFilterTap: () => showDebtsFilterSheet(
                context,
                initialFilter: _filter,
                onApply: (filter) {
                  setState(() => _filter = filter);
                  context.read<MyDebtsCubit>().fetchDeclarations(
                    filter: filter,
                  );
                },
              ),
              filterCount: _filter.activeCount,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _SettlementList extends StatelessWidget {
  const _SettlementList({
    required this.declarations,
    required this.onFilterTap,
    required this.filterCount,
  });

  final List<MyDebtsDeclarationModel> declarations;
  final VoidCallback onFilterTap;
  final int filterCount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Header
          AppText(
            text: 'المديونيات المستحقة',
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.mainBlueIndigoDye,
            textAlign: TextAlign.right,
          ),
          8.hs,
          AppText(
            text:
                'يتم عرض جميع طلبات الإقرار التابعة للمستخدم سواء قدمها بنفسه أو قدمت عنه بواسطة وكيل أو ممثل قانوني.',
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.neutralDarkDark,
            textAlign: TextAlign.right,
            maxLines: 5,
          ),
          16.hs,
          // Filter chip
          PaymentFilterChip(count: filterCount, onTap: onFilterTap),
          24.hs,
          // List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: declarations.length,
            separatorBuilder: (_, __) => 16.hs,
            itemBuilder: (_, index) =>
                _DeclarationCard(item: declarations[index]),
          ),
        ],
      ),
    );
  }
}

class _DeclarationCard extends StatelessWidget {
  const _DeclarationCard({required this.item});
  final MyDebtsDeclarationModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.7, 0),
          radius: 0.6,
          colors: [
            Color(0xFFC2C2C3),
            Color(0xFFD8D8D8),
            Color(0xFFE4E3E3),
            Color(0xFFFFFFFF),
          ],
          stops: [0.0, 0.025, 0.55, 1.0],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ImageSvgCustomWidget(imgPath: FixedAssets.instance.dateIC),
                  5.ws,
                  AppText(
                    text: 'تاريخ تحديث الإقرار',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.neutralDarkMedium,
                  ),
                  8.ws,
                  AppText(
                    text: item.updateDate ?? '',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutralDarkDarkest,
                  ),
                ],
              ),
              // Status badge
              AppStatusBadge(
                label: item.statusText,
                bgColor: myDebtsStatusColor(item.statusId),
              ),
            ],
          ),
          20.hs,
          _InfoGrid(item: item),
          16.hs,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: PaymentInfoUnderDebtsPage(
                    declarationId: item.id.toString(),
                  ),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.slideUp,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlightDarkest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: AppText(
                text: 'المدفوعات تحت حساب المديونية',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                alignment: AlignmentDirectional.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.item});
  final MyDebtsDeclarationModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PaymentInfoBox(
                label: 'رقم الإقرار',
                value: item.declarationNumber,
                valueColor: AppColors.neutralDarkMedium,
                crossAxisAlignment: CrossAxisAlignment.start,
                alignment: AlignmentDirectional.centerStart,
                textDirection: TextDirection.ltr,
              ),
            ),
            12.ws,
            Expanded(
              child: PaymentInfoBox(
                label: 'نوع الإقرار',
                value: item.declarationTypeText,
                crossAxisAlignment: CrossAxisAlignment.start,
                alignment: AlignmentDirectional.centerStart,
              ),
            ),
          ],
        ),
        8.hs,
        Row(
          children: [
            Expanded(
              child: PaymentInfoBox(
                label: 'صفة مقدم الطلب',
                value: item.submitterType,
                crossAxisAlignment: CrossAxisAlignment.start,
                alignment: AlignmentDirectional.centerStart,
              ),
            ),
            12.ws,
            Expanded(
              child: PaymentInfoBox(
                label: 'عدد العقارات',
                value: item.totalUnits.toString(),
                crossAxisAlignment: CrossAxisAlignment.start,
                alignment: AlignmentDirectional.centerStart,
              ),
            ),
          ],
        ),
        8.hs,
        Row(
          children: [
            Expanded(
              child: PaymentInfoBox(
                label: 'تاريخ إنشاء الإقرار',
                value: item.creationDate.toArabicDate(),
                crossAxisAlignment: CrossAxisAlignment.start,
                alignment: AlignmentDirectional.centerStart,
              ),
            ),
            12.ws,
            Expanded(
              child: PaymentInfoBox(
                label: 'تاريخ تقديم الإقرار',
                value: item.submittionDate.toArabicDate(),
                crossAxisAlignment: CrossAxisAlignment.start,
                alignment: AlignmentDirectional.centerStart,
              ),
            ),
          ],
        ),
        8.hs,
        PaymentInfoBox(
          label: 'المكلف بأداء الضريبة',
          value: item.taxpayer,
          crossAxisAlignment: CrossAxisAlignment.start,
          alignment: AlignmentDirectional.centerStart,
        ),
      ],
    );
  }
}
