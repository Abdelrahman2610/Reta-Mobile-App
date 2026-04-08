import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/profile_verification_cubit.dart';
import '../cubit/profile_verification_state.dart';

class EmailVerificationPage extends StatelessWidget {
  final String email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProfileVerificationCubit()..sendEmailVerification(email: email),
      child: _EmailVerificationView(email: email),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _EmailVerificationView extends StatelessWidget {
  final String email;
  const _EmailVerificationView({required this.email});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutralLightLight,
        appBar: AppBar(
          backgroundColor: AppColors.neutralLightLight,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: AppColors.mainBlueSecondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'التحقق من البريد الإلكتروني',
            style: AppTextStyles.actionXL.copyWith(
              color: AppColors.mainBlueSecondary,
            ),
          ),
        ),
        body: BlocConsumer<ProfileVerificationCubit, ProfileVerificationState>(
          listener: (context, state) {
            if (state is ProfileVerificationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    textDirection: TextDirection.rtl,
                  ),
                  backgroundColor: AppColors.errorDark,
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'حسناً',
                    textColor: AppColors.white,
                    onPressed: () =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileVerificationLoading ||
                state is ProfileVerificationInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EmailVerificationSent) {
              return _CheckInboxBody(
                email: email,
                serverMessage: state.message,
                onResend: () => context
                    .read<ProfileVerificationCubit>()
                    .sendEmailVerification(email: email),
              );
            }

            if (state is ProfileVerificationError) {
              return _ErrorRetryBody(
                message: state.message,
                onRetry: () => context
                    .read<ProfileVerificationCubit>()
                    .sendEmailVerification(email: email),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ─── Check inbox body ─────────────────────────────────────────────────────────

class _CheckInboxBody extends StatelessWidget {
  final String email;
  final String serverMessage;
  final VoidCallback onResend;

  const _CheckInboxBody({
    required this.email,
    required this.serverMessage,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        children: [
          // ── Illustration ──────────────────────────────────────────────
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.mainBlueIndigoDye.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              size: 48,
              color: AppColors.mainBlueIndigoDye,
            ),
          ),
          const SizedBox(height: 32),

          // ── Title ─────────────────────────────────────────────────────
          Text(
            'تحقق من بريدك الإلكتروني',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.mainBlueIndigoDye,
            ),
          ),
          const SizedBox(height: 12),

          // ── Body ──────────────────────────────────────────────────────
          Text(
            'تم إرسال رابط التحقق إلى',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyM.copyWith(
              color: AppColors.neutralDarkLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            email,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: AppTextStyles.h5.copyWith(
              color: AppColors.neutralDarkDarkest,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'يرجى فتح البريد الإلكتروني والضغط على الرابط لإتمام التحقق.',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyM.copyWith(
              color: AppColors.neutralDarkLight,
            ),
          ),

          const SizedBox(height: 40),

          // ── Info card ─────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.highlightDarkest.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.highlightDarkest.withOpacity(0.2),
              ),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: AppColors.highlightDarkest,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'إذا لم تجد الرسالة في صندوق الوارد، تفقد مجلد البريد العشوائي (Spam).',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.neutralDarkMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // ── Resend ────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'لم تستلم الرسالة؟',
                textDirection: TextDirection.rtl,
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.neutralDarkLight,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onResend,
                child: Text(
                  'أعد الإرسال',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.actionM.copyWith(
                    color: AppColors.highlightDarkest,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Done button ───────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlightDarkest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                'حسناً',
                style: AppTextStyles.actionL.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Error + retry ────────────────────────────────────────────────────────────

class _ErrorRetryBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorRetryBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.errorDark,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.neutralDarkLight,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlightDarkest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'إعادة المحاولة',
                style: AppTextStyles.actionL.copyWith(color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
