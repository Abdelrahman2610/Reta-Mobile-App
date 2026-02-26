import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/helpers/fixed_assets.dart';
import '../../../../../../components/image_svg_custom_widget.dart';

class CalendarIcon extends StatelessWidget {
  const CalendarIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageSvgCustomWidget(
      imgPath: FixedAssets.instance.calendarIC,
      width: 20.w,
      height: 20.h,
    );
  }
}
