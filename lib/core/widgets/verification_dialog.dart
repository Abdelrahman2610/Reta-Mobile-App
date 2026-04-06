import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/auth/data/models/user_models.dart';
import 'package:reta/features/auth/presentation/cubit/home_cubit.dart';
import 'package:reta/core/widgets/verification_action.dart';

void showVerificationDialog(
  BuildContext contextWidget,
  UserModel user,
  Function? extraNavigation1,
  Function? extraNavigation2,
) {
  final missing = <String>[
    if (!(user.emailVerified ?? false)) 'البريد الإلكتروني',
    if (!(user.phoneVerified ?? false)) 'رقم الموبايل',
    if (!(user.nationalIdVerified ?? false)) 'الهوية الوطنية',
  ];

  final missingText = missing.isNotEmpty
      ? 'يجب التحقق من: ${missing.join(' • ')} للوصول إلى هذه الخدمة.\nيرجى الانتقال إلى صفحة الإعدادات لإتمام التحقق.'
      : 'يجب التحقق من هويتك أولاً للوصول إلى هذه الخدمة.';

  final action = VerificationAction.resolve(user, contextWidget);

  showDialog(
    context: contextWidget,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3CD),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  color: Color(0xFFF5A623),
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'التحقق مطلوب',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2340),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                missingText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xFF6B7280),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        contextWidget
                            .read<HomeCubit>()
                            .dismissVerificationPrompt();
                        final onLater = extraNavigation1 ?? action.onLater;
                        onLater?.call();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF005FAD)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'لاحقاً',
                        style: TextStyle(color: Color(0xFF005FAD)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        contextWidget
                            .read<HomeCubit>()
                            .dismissVerificationPrompt();
                        final onVerifyNow =
                            extraNavigation2 ?? action.onVerifyNow;
                        onVerifyNow?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005FAD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: const Text(
                        'التحقق الآن',
                        style: TextStyle(color: Colors.white),
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
}
