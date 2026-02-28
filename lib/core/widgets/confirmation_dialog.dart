import 'package:flutter/material.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/core/theme/app_text_styles.dart';

Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String cancelLabel = 'إلغاء',
  bool isDestructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (ctx) => Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isDestructive) ...[
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.highlightDarkest,
                  size: 50,
                ),
                const SizedBox(height: 20),
              ],

              Text(
                title,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.neutralDarkDarkest,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                message,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: AppTextStyles.bodyS.copyWith(
                  color: AppColors.neutralDarkLight,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorDark,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        confirmLabel,
                        style: AppTextStyles.actionM.copyWith(
                          color: AppColors.neutralLightLightest,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.highlightDarkest,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        cancelLabel,
                        style: AppTextStyles.actionM.copyWith(
                          color: AppColors.highlightDarkest,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  return result ?? false;
}
