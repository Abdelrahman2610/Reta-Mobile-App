import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/show_confirmation_dialog.dart';

Future<void> showCancelDeclarationDialog(
  BuildContext context,
  Function onCancel,
) async {
  final confirmed = await showConfirmationDialog(
    context,
    title: 'تأكيد إلغاء الإقرار',
    message:
        'هل أنت متأكد من رغبتك في إلغاء هذا الإقرار؟\n'
        'لا يؤثر إلغاء الإقرار على أي إقرارات سابقة تم إرسالها أو التزامات ضريبية قائمة.',
    confirmText: 'إلغاء الإقرار',
    icon: Icon(
      Icons.warning_amber_rounded,
      size: 48,
      color: AppColors.highlightDarkest,
    ),
  );

  if (confirmed == true) {
    // Call cancel declaration API
    debugPrint('Declaration cancelled');
    onCancel();
  }
}
