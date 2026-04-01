import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/profile_verification_cubit.dart';
import '../cubit/profile_verification_state.dart';
import 'package:reta/features/auth/data/repositories/profile_verification_repository.dart';

class PhoneVerificationPage extends StatelessWidget {
  final String phone;

  const PhoneVerificationPage({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileVerificationCubit()..sendPhoneOtp(),
      child: _PhoneVerificationView(phone: phone),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PhoneVerificationView extends StatelessWidget {
  final String phone;
  const _PhoneVerificationView({required this.phone});

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
            'التحقق من رقم الهاتف',
            style: AppTextStyles.actionXL.copyWith(
              color: AppColors.mainBlueSecondary,
            ),
          ),
        ),
        body: BlocConsumer<ProfileVerificationCubit, ProfileVerificationState>(
          listener: (context, state) {
            if (state is PhoneVerificationSuccess) {
              Navigator.of(context).pop(true);
            }
            if (state is ProfileVerificationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    textDirection: TextDirection.rtl,
                  ),
                  backgroundColor: AppColors.errorDark,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileVerificationLoading ||
                state is ProfileVerificationInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PhoneOtpSent || state is PhoneOtpError) {
              final otpData = state is PhoneOtpSent
                  ? state.otpData
                  : (state as PhoneOtpError).otpData;
              final errorMsg = state is PhoneOtpError ? state.message : null;

              return _OtpInputBody(
                phone: phone,
                otpData: otpData,
                serverError: errorMsg,
              );
            }

            if (state is ProfileVerificationError) {
              return _ErrorRetryBody(
                message: state.message,
                onRetry: () =>
                    context.read<ProfileVerificationCubit>().sendPhoneOtp(),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ─── OTP input body ───────────────────────────────────────────────────────────

class _OtpInputBody extends StatefulWidget {
  final String phone;
  final SendPhoneOtpResponse otpData;
  final String? serverError;

  const _OtpInputBody({
    required this.phone,
    required this.otpData,
    this.serverError,
  });

  @override
  State<_OtpInputBody> createState() => _OtpInputBodyState();
}

class _OtpInputBodyState extends State<_OtpInputBody> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  late Duration _remaining;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.otpData.otpDuration;
    _startTimer();
  }

  @override
  void didUpdateWidget(_OtpInputBody old) {
    super.didUpdateWidget(old);
    if (old.otpData.requestCode != widget.otpData.requestCode) {
      _remaining = widget.otpData.otpDuration;
      _canResend = false;
      _startTimer();
      _clearFields();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining -= const Duration(seconds: 1);
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  void _clearFields() {
    for (final c in _controllers) c.clear();
    if (_focusNodes.isNotEmpty) _focusNodes[0].requestFocus();
    setState(() {});
  }

  String get _otpValue => _controllers.map((c) => c.text).join();

  String get _timerLabel {
    final m = _remaining.inMinutes.toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Color get _timerColor {
    final secs = _remaining.inSeconds;
    if (secs == 0) return AppColors.errorDark;
    if (secs <= 60) return AppColors.mainOrange;
    return AppColors.highlightDarkest;
  }

  bool get _isExpired => _remaining.inSeconds == 0;

  void _onDigitEntered(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  void _onKeyBack(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  void _submit(BuildContext context) {
    if (_otpValue.length < 6 || _isExpired) return;
    context.read<ProfileVerificationCubit>().confirmPhoneOtp(
      token: widget.otpData.requestCode,
      otp: _otpValue,
      mobile: widget.otpData.mobile,
      userId: widget.otpData.userId,
    );
  }

  void _resend(BuildContext context) {
    if (!_canResend) return;
    context.read<ProfileVerificationCubit>().resendPhoneOtp();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.serverError != null;
    final isLoading =
        context.watch<ProfileVerificationCubit>().state
            is ProfileVerificationLoading;
    final bool buttonActive =
        _otpValue.length == 6 && !isLoading && !_isExpired;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.mainBlueIndigoDye.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.phone_android_rounded,
              size: 40,
              color: AppColors.mainBlueIndigoDye,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'أدخل رمز التأكيد',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.mainBlueIndigoDye,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تم إرسال رمز مكوّن من 6 أرقام إلى',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyM.copyWith(
              color: AppColors.neutralDarkLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.phone,
            textDirection: TextDirection.ltr,
            style: AppTextStyles.h5.copyWith(
              color: AppColors.neutralDarkDarkest,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 32),

          // ── OTP boxes ────────────────────────────────────────────────
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (i) {
                return SizedBox(
                  width: 44,
                  height: 52,
                  child: KeyboardListener(
                    focusNode: FocusNode(),
                    onKeyEvent: (e) {
                      if (e.logicalKey.keyLabel == 'Backspace') {
                        _onKeyBack(i);
                      }
                    },
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      onChanged: (v) => _onDigitEntered(i, v),
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.neutralDarkDarkest,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: hasError
                            ? AppColors.errorLight
                            : AppColors.neutralLightLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: hasError
                                ? AppColors.errorDark
                                : AppColors.neutralLightDark,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: hasError
                                ? AppColors.errorDark
                                : AppColors.neutralLightDark,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: hasError
                                ? AppColors.errorDark
                                : AppColors.highlightDark,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // ── Error banner ─────────────────────────────────────────────
          if (hasError) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.errorDark.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.errorDark.withOpacity(0.3)),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.errorDark,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.serverError!,
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.bodyM.copyWith(
                        color: AppColors.neutralDarkMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // ── Timer ────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time_rounded, size: 16, color: _timerColor),
              const SizedBox(width: 4),
              Text(
                'صالح لمدة',
                style: AppTextStyles.actionM.copyWith(color: _timerColor),
              ),
              const SizedBox(width: 4),
              Text(
                _timerLabel,
                textDirection: TextDirection.ltr,
                style: AppTextStyles.actionM.copyWith(
                  color: _timerColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'دقيقة',
                style: AppTextStyles.actionM.copyWith(color: _timerColor),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Remaining attempts ───────────────────────────────────────
          RichText(
            textDirection: TextDirection.ltr,
            text: TextSpan(
              style: AppTextStyles.actionM.copyWith(
                color: AppColors.neutralDarkLightest,
              ),
              children: [
                TextSpan(
                  text: '${widget.otpData.remainingAttempts}',
                  style: AppTextStyles.actionM.copyWith(
                    color: AppColors.highlightDarkest,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' :عدد المحاولات المتبقية'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Resend ───────────────────────────────────────────────────
          TextButton(
            onPressed: _canResend ? () => _resend(context) : null,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'أعد إرسال الرمز',
              textDirection: TextDirection.rtl,
              style: AppTextStyles.actionM.copyWith(
                color: _canResend
                    ? AppColors.highlightDarkest
                    : AppColors.neutralDarkLightest,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ── Confirm button ───────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: buttonActive ? () => _submit(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlightDarkest,
                disabledBackgroundColor: AppColors.neutralLightDarkest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      'تأكيد',
                      style: AppTextStyles.actionL.copyWith(
                        color: buttonActive
                            ? AppColors.white
                            : AppColors.neutralDarkLight,
                      ),
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
