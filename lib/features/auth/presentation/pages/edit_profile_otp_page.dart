import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/core/theme/app_text_styles.dart';
import 'package:reta/features/auth/data/models/edit_profile_response.dart';
import 'package:reta/features/auth/presentation/cubit/user_profile_cubit.dart';
import 'package:reta/features/auth/presentation/cubit/user_profile_state.dart';

class EditProfileOtpPage extends StatefulWidget {
  final OtpResponseData otpData;

  const EditProfileOtpPage({super.key, required this.otpData});

  @override
  State<EditProfileOtpPage> createState() => _EditProfileOtpPageState();
}

class _EditProfileOtpPageState extends State<EditProfileOtpPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  late Duration _remaining;
  bool _canResend = false;
  bool _isLoading = false;
  String? _error;

  late OtpResponseData _currentOtpData;

  @override
  void initState() {
    super.initState();
    _currentOtpData = widget.otpData;
    _resetTimer(_currentOtpData);
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // ── Timer ─────────────────────────────────────────────────────────────────

  void _resetTimer(OtpResponseData otpData) {
    _timer?.cancel();
    final expireSeconds = int.tryParse(otpData.smsOtpExpire ?? '300') ?? 300;
    _remaining = Duration(seconds: expireSeconds);
    setState(() => _canResend = false);
    _startTimer();
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

  String get _timerLabel {
    final m = _remaining.inMinutes.toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  int get _secondsRemaining => _remaining.inSeconds;

  Color get _timerColor {
    if (_secondsRemaining == 0) return AppColors.errorDark;
    if (_secondsRemaining <= 60) return AppColors.mainOrange;
    return AppColors.highlightDarkest;
  }

  // ── OTP helpers ───────────────────────────────────────────────────────────

  String get _otpValue => _controllers.map((c) => c.text).join();

  void _onDigitEntered(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() => _error = null);
  }

  void _onKeyBack(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  void _clearOtp() {
    for (final c in _controllers) c.clear();
    if (_focusNodes.isNotEmpty) _focusNodes[0].requestFocus();
    setState(() {});
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _confirm() async {
    if (_otpValue.length < 6 || _isLoading) return;

    final token = _currentOtpData.requestCode;
    final mobile = _currentOtpData.mobile;
    final userId = _currentOtpData.userId?.toString();

    if (token == null || mobile == null || userId == null) {
      setState(() => _error = 'بيانات التحقق غير مكتملة');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    await context.read<UserProfileCubit>().confirmPhoneUpdate(
      token: token,
      otp: _otpValue,
      mobile: mobile,
      userId: userId,
    );
  }

  Future<void> _handleResend() async {
    if (!_canResend || _isLoading) return;

    _clearOtp();
    setState(() {
      _error = null;
      _isLoading = true;
    });

    await context.read<UserProfileCubit>().editProfile(
      phone: _currentOtpData.mobile,
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfilePhoneConfirmed) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'تم تحديث رقم الهاتف بنجاح',
                textDirection: TextDirection.rtl,
              ),
              backgroundColor: AppColors.successMedium,
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'حسناً',
                textColor: AppColors.white,
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              ),
            ),
          );
          Navigator.of(context).pop(true);
        } else if (state is UserProfileUpdateSuccess) {
          if (state.otpData != null && state.otpData!.ok) {
            setState(() {
              _currentOtpData = state.otpData!;
              _isLoading = false;
            });
            _resetTimer(state.otpData!);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'تم إرسال رمز جديد',
                  textDirection: TextDirection.rtl,
                ),
                backgroundColor: AppColors.successMedium,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else if (state is UserProfileError) {
          setState(() {
            _isLoading = false;
            _error = state.message;
          });
          _clearOtp();
        } else if (state is UserProfileUpdating) {
          setState(() => _isLoading = true);
        }
      },
      child: Directionality(
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
              onPressed: () => Navigator.of(context).pop(false),
            ),
            title: Text(
              'تأكيد رقم الهاتف',
              style: AppTextStyles.actionXL.copyWith(
                color: AppColors.mainBlueIndigoDye,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.mainBlueIndigoDye.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.phone_android_rounded,
                    size: 42,
                    color: AppColors.mainBlueIndigoDye,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'أدخل رمز التأكيد',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.h2.copyWith(
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
                  _currentOtpData.mobile ?? '',
                  textDirection: TextDirection.ltr,
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.neutralDarkDarkest,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 32),

                // ── OTP Fields ────────────────────────────────────────────
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (i) {
                      return SizedBox(
                        width: 44,
                        height: 54,
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
                              fillColor: _error != null
                                  ? AppColors.errorLight
                                  : AppColors.neutralLightLightest,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: _error != null
                                      ? AppColors.errorDark
                                      : AppColors.neutralLightDark,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: _error != null
                                      ? AppColors.errorDark
                                      : AppColors.neutralLightDark,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: _error != null
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

                // ── Error Message ─────────────────────────────────────────
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.errorDark.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.errorDark.withOpacity(0.3),
                      ),
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
                            _error!,
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

                const SizedBox(height: 28),

                // ── Timer ────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'دقيقة',
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
                      'صالح لمدة',
                      style: AppTextStyles.actionM.copyWith(color: _timerColor),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: _timerColor,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Resend ────────────────────────────────────────────────
                TextButton(
                  onPressed: (_canResend && !_isLoading) ? _handleResend : null,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: _isLoading && _canResend
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'أعد إرسال الرمز',
                          textDirection: TextDirection.rtl,
                          style: AppTextStyles.actionM.copyWith(
                            color: (_canResend && !_isLoading)
                                ? AppColors.highlightDarkest
                                : AppColors.neutralDarkLightest,
                          ),
                        ),
                ),

                const SizedBox(height: 32),

                // ── Confirm Button ────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed:
                        (_otpValue.length == 6 &&
                            !_isLoading &&
                            _secondsRemaining > 0)
                        ? _confirm
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.highlightDarkest,
                      disabledBackgroundColor: AppColors.neutralLightDarkest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading && !_canResend
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
                              color: AppColors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
