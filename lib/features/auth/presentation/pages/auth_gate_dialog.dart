import 'package:flutter/material.dart';
import 'package:reta/features/auth/presentation/pages/guest_page.dart';

import '../../../../core/helpers/runtime_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'login_page.dart';
import 'signup_page.dart';

Future<void> showAuthGateDialog(
  BuildContext context, {
  String title = 'يتطلب تسجيل الدخول',
  String message =
      'يرجى تسجيل الدخول أو إنشاء حساب جديد لتتمكن من تقديم الإقرار الضريبي والاستفادة من خدمات مصلحة الضرائب العقارية.',
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AuthGateSheet(title: title, message: message),
  );
}

class AuthGateSheet extends StatelessWidget {
  final String title;
  final String message;

  const AuthGateSheet({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.neutralLightDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Icon(
            Icons.lock_outline_rounded,
            color: AppColors.mainBlueIndigoDye,
            size: 32,
          ),

          const SizedBox(height: 16),

          Text(
            title,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.neutralDarkDarkest,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            message,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyS.copyWith(
              color: AppColors.neutralDarkLight,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(
                  RuntimeData.getCurrentContext()!,
                ).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlightDarkest,
                foregroundColor: AppColors.neutralLightLightest,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تسجيل الدخول',
                style: AppTextStyles.actionM.copyWith(
                  color: AppColors.neutralLightLightest,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const SignupPage()));
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.highlightDarkest,
                side: const BorderSide(
                  color: AppColors.highlightDarkest,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'إنشاء حساب جديد',
                style: AppTextStyles.actionM.copyWith(
                  color: AppColors.highlightDarkest,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const GuestPage()));
            },
            child: Text(
              'العودة إلى الصفحة الرئيسية',
              style: AppTextStyles.actionM.copyWith(
                color: AppColors.highlightDarkest,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
