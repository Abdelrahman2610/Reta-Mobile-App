import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/image_svg_custom_widget.dart';
import 'package:reta/features/payment/data/models/payment_unit_item.dart';
import 'package:reta/features/payment/presentations/components/payment_button.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../components/app_container.dart';
import '../../../components/app_scaffold.dart';
import '../../../declarations/presentations/components/declaration_data_tab.dart';
import '../components/settlement_account_bottom_sheet.dart';

class PaymentInfoPage extends StatefulWidget {
  const PaymentInfoPage({super.key});

  @override
  State<PaymentInfoPage> createState() => _PaymentInfoPageState();
}

class _PaymentInfoPageState extends State<PaymentInfoPage> {
  final List<PaymentUnitItemModel> _units = [
    PaymentUnitItemModel(
      unitType: 'وحدة سكنية',
      location: 'القاهرة - وحدة 8',
      amount: 200.00,
      useSettlementAccount: true,
      isSelected: true,
    ),
    PaymentUnitItemModel(
      unitType: 'وحدة تجارية',
      location: 'القاهرة - وحدة 12 - عطارة الأمل - محل عطارة',
      amount: 1500.00,
      useSettlementAccount: false,
      isSelected: true,
    ),
  ];

  double get _total => _units
      .where((u) => u.isSelected)
      .fold(0, (sum, u) => sum + (u.amount ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'طلبات السداد',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _StepIndicator(),
                  20.hs,
                  _SuccessBanner(),
                  20.hs,
                  _PaymentCard(
                    units: _units,
                    total: _total,
                    onSelectionChanged: (index, value) =>
                        setState(() => _units[index].isSelected = value),
                    onSettlementToggled: (index, value) => setState(
                      () => _units[index].useSettlementAccount = value,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            color: Colors.transparent,
            child: PaymentButton(
              label: 'إصدار طلب السداد',
              onTap: () async {
                final confirmed = await showSettlementAccountBottomSheet(
                  context: context,
                  settlementBalance: 500.00,
                  requiredAmount: 900.00,
                );

                if (confirmed == true) {
                  // The user agreed, start the settlement process
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      height: 93,
      boxShadow: [],
      child: Column(
        children: [
          Row(
            children: [
              DeclarationDataTab(
                declarationsType: DeclarationsDataType.payInfo,
                isSelected: true,
                isFinished: false,
              ),
              DeclarationDataTab(
                declarationsType: DeclarationsDataType.paymentRequests,
                isSelected: false,
                isFinished: false,
              ),
            ],
          ),
          8.hs,
          Container(
            height: 8.h,
            decoration: BoxDecoration(
              color: AppColors.highlightDarkest,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          ImageSvgCustomWidget(imgPath: FixedAssets.instance.successIC),
          16.ws,
          AppText(
            text: 'تم تقديم الإقرار بنجاح',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.neutralDarkDarkest,
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.units,
    required this.total,
    required this.onSelectionChanged,
    required this.onSettlementToggled,
  });

  final List<PaymentUnitItemModel> units;
  final double total;
  final void Function(int, bool) onSelectionChanged;
  final void Function(int, bool) onSettlementToggled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 26.h),
            child: Column(
              children: [
                AppText(
                  text: 'طلب سداد',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutralDarkDarkest,
                  alignment: AlignmentDirectional.center,
                ),
                11.hs,
                AppText(
                  text: 'مراجعة البيانات قبل الإصدار',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neutralDarkMedium,
                  alignment: AlignmentDirectional.center,
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppText(
                  text: 'الوحدات التي سيتم إصدار طلب/طلبات السداد عنها',
                  alignment: AlignmentDirectional.center,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutralDarkDarkest,
                ),
                12.hs,

                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(2),
                    },
                    border: TableBorder.all(
                      color: AppColors.neutralLightDarkest,
                      width: 1,
                    ),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: AppColors.neutralLightDarkest,
                        ),
                        children: [
                          _tableHeader('نوع العقار'),
                          _tableHeader('مبلغ تحت الحساب'),
                        ],
                      ),

                      ...units.asMap().entries.map(
                        (e) => _buildUnitRow(
                          e.key,
                          e.value,
                          onSelectionChanged,
                          onSettlementToggled,
                        ),
                      ),

                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 14.h,
                            ),
                            child: AppText(
                              text: 'الإجمالي',
                              alignment: AlignmentDirectional.centerEnd,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.neutralDarkLight,
                            ),
                          ),
                          Container(
                            color: AppColors.neutralDarkLight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 14.h,
                              ),
                              child: AppText(
                                text: total.toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                24.hs,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(String text) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    child: Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF374151),
      ),
    ),
  );

  TableRow _buildUnitRow(
    int index,
    PaymentUnitItemModel item,
    void Function(int, bool) onSelect,
    void Function(int, bool) onToggle,
  ) {
    return TableRow(
      decoration: BoxDecoration(color: AppColors.highlightLightest),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => onSelect(index, !item.isSelected),
                    child: Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        color: item.isSelected
                            ? const Color(0xFF1A56DB)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: item.isSelected
                              ? AppColors.highlightDarkest
                              : AppColors.mainNeutral,
                        ),
                      ),
                      child: item.isSelected
                          ? Icon(Icons.check, color: Colors.white, size: 14.sp)
                          : null,
                    ),
                  ),
                  14.ws,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppText(
                          text: item.unitType ?? '',
                          textAlign: TextAlign.right,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neutralDarkMedium,
                        ),
                        5.hs,
                        AppText(
                          text: item.location ?? '',
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutralDarkMedium,
                        ),
                        8.hs,
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.transparent,
                            border: Border.all(
                              color: item.useSettlementAccount
                                  ? AppColors.successMedium
                                  : AppColors.neutralLightDarkest,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Transform.scale(
                                scale: 0.85,
                                child: Switch(
                                  value: item.useSettlementAccount,
                                  onChanged: (v) => onToggle(index, v),
                                  activeColor: Colors.white,
                                  activeTrackColor: AppColors.successMedium,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor:
                                      AppColors.neutralLightDark,
                                  trackOutlineColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              4.ws,
                              AppText(
                                text: 'السداد من حساب\nالتسويات',
                                textAlign: TextAlign.right,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.neutralDarkMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: AppText(
            text: item.amount?.toStringAsFixed(2) ?? '-',
            textAlign: TextAlign.center,

            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.neutralDarkMedium,
          ),
        ),
      ],
    );
  }
}
