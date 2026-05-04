import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../../core/helpers/fixed_assets.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../components/app_button.dart';
import '../../../../../../components/app_text.dart';
import '../../../../../../components/image_svg_custom_widget.dart';
import '../../../../../data/models/map_location_result.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    this.mapLocationResult,
    this.title,
    this.buttonLabel,
    this.onBtnTapped,
    this.onDeleteTapped,
    this.onAddLocationTapped,
    this.hideEditButton = false,
  });

  final MapLocationResult? mapLocationResult;
  final String? title;
  final String? buttonLabel;
  final VoidCallback? onBtnTapped;
  final VoidCallback? onDeleteTapped;
  final VoidCallback? onAddLocationTapped;
  final bool hideEditButton;

  @override
  Widget build(BuildContext context) {
    return mapLocationResult != null
        ? ExistLocation(
            mapLocationResult: mapLocationResult,
            title: title,
            buttonLabel: buttonLabel,
            onBtnTapped: onBtnTapped,
            onDeleteTapped: onDeleteTapped,
            hideEditButton: hideEditButton,
          )
        : EmptyLocation(
            onAddLocationTapped: onAddLocationTapped ?? onBtnTapped,
          );
  }
}

class EmptyLocation extends StatelessWidget {
  const EmptyLocation({super.key, this.onAddLocationTapped});

  final VoidCallback? onAddLocationTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          text: 'يرجى تحديد موقع العقار من الخريطة لاستكمال إدخال البيانات.',
          fontSize: 20.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.mainBlueIndigoDye,
          alignment: AlignmentDirectional.center,
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
        20.hs,
        AppButton(
          label: 'تحديد العقار من الخريطة',
          fontSize: 14,
          height: 50.h,
          fontWeight: FontWeight.w600,
          backgroundColor: AppColors.mainOrange,
          icon: ImageSvgCustomWidget(imgPath: FixedAssets.instance.mapIC),
          iconLeft: false,
          onTap: onAddLocationTapped,
        ),
        10.hs,
        AppText(
          text:
              'سيتم فتح الخريطة لتحديد موقع العقار، ثم العودة لاستكمال البيانات.',
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          color: AppColors.neutralDarkLight,
          maxLines: 3,
          alignment: Alignment.center,
          textAlign: TextAlign.center,
        ),
        40.hs,
        DottedLine(),
      ],
    );
  }
}

class ExistLocation extends StatelessWidget {
  const ExistLocation({
    super.key,
    this.mapLocationResult,
    this.title,
    this.buttonLabel,
    this.onBtnTapped,
    this.onDeleteTapped,
    required this.hideEditButton,
  });

  final MapLocationResult? mapLocationResult;
  final String? title;
  final String? buttonLabel;
  final VoidCallback? onBtnTapped;
  final VoidCallback? onDeleteTapped;
  final bool hideEditButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: RadialGradient(
          center: Alignment(-1.0, 0),
          radius: 4.0,
          colors: [
            Color(0xFFC8DFF5),
            Color(0xFFDDEAF8),
            Color(0xFFEDF4FB),
            Colors.white,
          ],
          stops: const [0.0, 0.03, 0.25, 1.0],
        ),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppText(
            text: title ?? 'بيانات الموقع',
            fontSize: title != null ? 16.sp : 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.neutralDarkDark,
            alignment: title != null ? Alignment.center : null,
          ),
          10.hs,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Column(
              children: [
                AppText(
                  text: 'العنوان',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutralDarkMedium,
                ),
                4.hs,
                AppText(
                  text: buildAddress(mapLocationResult),
                  textAlign: TextAlign.right,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  maxLines: 3,
                  color: AppColors.neutralDarkDarkest,
                ),
              ],
            ),
          ),
          20.hs,
          Row(
            children: [
              if (!hideEditButton)
                Expanded(
                  child: AppButton(
                    label: buttonLabel ?? 'تعديل',
                    backgroundColor: AppColors.highlightDarkest,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.neutralLightLightest,
                    height: 50.h,
                    onTap: onBtnTapped ?? () => Navigator.pop(context),
                  ),
                ),

              if (onDeleteTapped != null)
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 15.w),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: GestureDetector(
                      onTap: onDeleteTapped,
                      child: ImageSvgCustomWidget(
                        imgPath: FixedAssets.instance.deleteIC,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String buildAddress(MapLocationResult? mapLocation) {
    if (mapLocation == null) return '';
    final parts = <String>[];

    if (mapLocation.governorate != null) parts.add(mapLocation.governorate!);
    if (mapLocation.neighborhood != null) parts.add(mapLocation.neighborhood!);
    if (mapLocation.policeStation != null) {
      parts.add(mapLocation.policeStation!);
    }
    if (mapLocation.street != null) parts.add(mapLocation.street!);
    if (mapLocation.streetNumber != null) {
      parts.add(mapLocation.streetNumber.toString());
    }

    return parts.join('، ');
  }
}
