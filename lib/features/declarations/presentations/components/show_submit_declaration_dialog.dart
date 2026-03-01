import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/show_confirmation_dialog.dart';

Future<void> showSubmitDeclarationDialog(
  BuildContext context,
  Function onSubmit,
) async {
  final confirmed = await showConfirmationDialog(
    context,
    title: 'تأكيد تقديم الإقرار',
    message:
        "يرجى التأكد من صحة جميع البيانات المدخلة في هذا الإقرار. بإتمام عملية التقديم، فإنك تُقر بصحة البيانات.",
    confirmText: 'نعم، تأكيد التقديم',
    cancelText: "لا، مراجعة البيانات",
    cancelTextColors: Colors.white,
    confirmTextColors: Colors.white,
    cancelBackgroundColors: AppColors.errorDark,
    confirmBackgroundColors: AppColors.successMedium,
    cancelBorderColors: AppColors.errorDark,
  );

  if (confirmed == true) {
    onSubmit(); // Call cancel declaration API
    debugPrint('Declaration cancelled');
  }
}
