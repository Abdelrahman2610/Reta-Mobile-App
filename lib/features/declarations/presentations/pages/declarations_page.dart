import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/components/app_text.dart';

class DeclarationsPage extends StatelessWidget {
  const DeclarationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppText(
          text: 'إقراراتي',
          alignment: AlignmentDirectional.center,
          fontSize: 18.sp,
        ),
      ],
    );
  }
}
