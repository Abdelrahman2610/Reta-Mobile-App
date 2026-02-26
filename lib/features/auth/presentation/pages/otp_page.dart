import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/signup_cubit.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;

  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

enum _OtpStep { intro, input, success }

class _OtpPageState extends State<OtpPage> {
  _OtpStep _step = _OtpStep.intro;

  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  static const _timerDuration = Duration(minutes: 5);
  Timer? _timer;
  Duration _remaining = _timerDuration;
  bool _canResend = false;
  int remainingAttempts = 2;

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String get _otpValue => _controllers.map((c) => c.text).join();

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

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remaining = _timerDuration;
      _canResend = false;
    });
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

  void _goToInput() {
    context.read<SignupCubit>().resendOtp();
    setState(() => _step = _OtpStep.input);
    _startTimer();
  }

  Future<void> _confirmOtp(BuildContext context) async {
    if (_otpValue.length < 6) return;
    final success = await context.read<SignupCubit>().confirmOtp(_otpValue);
    if (!mounted) return;

    if (success) {
      setState(() => _step = _OtpStep.success);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    } else {
      setState(() {
        remainingAttempts = (remainingAttempts - 1).clamp(0, 2);
      });
    }
  }

  Future<void> _resend() async {
    if (!_canResend) return;
    _clearOtp();
    await context.read<SignupCubit>().resendOtp();
    _startTimer();
  }

  void _clearOtp() {
    for (final c in _controllers) c.clear();
    _focusNodes[0].requestFocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightLight,
      appBar: AppBar(
        backgroundColor: AppColors.neutralLightLight,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.submitError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.submitError!,
                  textDirection: TextDirection.rtl,
                ),
                backgroundColor: AppColors.errorDark,
              ),
            );
          }
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (_step) {
            _OtpStep.intro => _IntroScreen(
              key: const ValueKey('intro'),
              phoneNumber: widget.phoneNumber,
              onContinue: _goToInput,
            ),
            _OtpStep.input => _InputScreen(
              key: const ValueKey('input'),
              phoneNumber: widget.phoneNumber,
              controllers: _controllers,
              focusNodes: _focusNodes,
              otpValue: _otpValue,
              timerLabel: _timerLabel,
              canResend: _canResend,
              remainingAttempts: 2,
              onDigitEntered: _onDigitEntered,
              onKeyBack: _onKeyBack,
              onConfirm: () => _confirmOtp(context),
              onResend: _resend,
            ),
            _OtpStep.success => const _SuccessScreen(key: ValueKey('success')),
          },
        ),
      ),
    );
  }
}

class _IntroScreen extends StatelessWidget {
  final String phoneNumber;
  final VoidCallback onContinue;

  const _IntroScreen({
    super.key,
    required this.phoneNumber,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.mainBlueIndigoDye.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.phone_android_rounded,
              size: 44,
              color: AppColors.mainBlueIndigoDye,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'تأكيد رقم الهاتف',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.h4.copyWith(
              color: AppColors.mainBlueIndigoDye,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'سيتم إرسال رمز تحقق إلى رقم هاتفك',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyM.copyWith(
              color: AppColors.neutralDarkLightest,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            phoneNumber,
            textDirection: TextDirection.ltr,
            style: AppTextStyles.h5.copyWith(
              color: AppColors.neutralDarkDarkest,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlightDarkest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                'إرسال رمز التحقق',
                style: AppTextStyles.actionL.copyWith(color: AppColors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _InputScreen extends StatelessWidget {
  final String phoneNumber;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final String otpValue;
  final String timerLabel;
  final bool canResend;
  final int remainingAttempts;
  final void Function(int, String) onDigitEntered;
  final void Function(int) onKeyBack;
  final VoidCallback onConfirm;
  final VoidCallback onResend;

  const _InputScreen({
    super.key,
    required this.phoneNumber,
    required this.controllers,
    required this.focusNodes,
    required this.otpValue,
    required this.timerLabel,
    required this.canResend,
    required this.remainingAttempts,
    required this.onDigitEntered,
    required this.onKeyBack,
    required this.onConfirm,
    required this.onResend,
  });

  int get _secondsRemaining {
    final parts = timerLabel.split(':');
    if (parts.length != 2) return 0;
    final m = int.tryParse(parts[0]) ?? 0;
    final s = int.tryParse(parts[1]) ?? 0;
    return m * 60 + s;
  }

  Color get _timerColor {
    final secs = _secondsRemaining;
    if (secs == 0) return AppColors.errorDark;
    if (secs <= 60) return AppColors.mainOrange;
    return AppColors.highlightDarkest;
  }

  bool get _attemptsExhausted => remainingAttempts <= 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        final hasError = state.submitError != null && !_attemptsExhausted;
        final bool buttonActive =
            otpValue.length == 6 &&
            !state.isLoading &&
            !_attemptsExhausted &&
            _secondsRemaining > 0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'أدخل رمز التأكيد',
                textDirection: TextDirection.rtl,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.mainBlueIndigoDye,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'تم إرسال رمز تأكيد مكوّن من 6 أرقام\n إلى رقم الهاتف المسجل',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.neutralDarkLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'يرجى إدخال الرمز لإتمام تسجيل الدخول.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyXL.copyWith(
                  color: AppColors.neutralDarkDark,
                ),
              ),
              const SizedBox(height: 28),

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
                            onKeyBack(i);
                          }
                        },
                        child: TextField(
                          controller: controllers[i],
                          focusNode: focusNodes[i],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          onChanged: (v) => onDigitEntered(i, v),
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
                            suffixIcon: hasError
                                ? Container(
                                    width: 28,
                                    height: 28,
                                    margin: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppColors.errorMedium,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.priority_high_rounded,
                                      color: AppColors.white,
                                      size: 14,
                                    ),
                                  )
                                : null,
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

              if (hasError) ...[
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
                          'رمز التحقق الذي تم إدخاله غير صحيح',
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

              const SizedBox(height: 32),

              if (_attemptsExhausted) ...[
                Text(
                  'تم استنفاذ عدد المحاولات المسموح بها',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.actionL.copyWith(
                    color: AppColors.errorDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'يرجى المحاولة مرة أخرى بعد مرور ٢٤ ساعة لطلب رمز تأكيد جديد',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.actionM.copyWith(
                    color: AppColors.neutralDarkDark,
                  ),
                ),
              ] else ...[
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    textDirection: TextDirection.ltr,
                    text: TextSpan(
                      style: AppTextStyles.actionM.copyWith(
                        color: AppColors.neutralDarkLightest,
                      ),
                      children: [
                        TextSpan(
                          text: '$remainingAttempts',
                          style: AppTextStyles.actionM.copyWith(
                            color: AppColors.highlightDarkest,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const TextSpan(text: ' :عدد المحاولات المتبقية'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'دقيقة',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.actionM.copyWith(color: _timerColor),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timerLabel,
                      textDirection: TextDirection.ltr,
                      style: AppTextStyles.actionM.copyWith(
                        color: _timerColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'صالح لمدة',
                      textDirection: TextDirection.rtl,
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

                const SizedBox(height: 24),

                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: (canResend && !state.isLoading)
                        ? onResend
                        : null,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'أعد إرسال الرمز',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.actionM.copyWith(
                        color: canResend
                            ? AppColors.highlightDarkest
                            : AppColors.neutralDarkLightest,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: buttonActive ? onConfirm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.highlightDarkest,
                    disabledBackgroundColor: AppColors.neutralLightDarkest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: state.isLoading
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
                          style: AppTextStyles.actionM.copyWith(
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
      },
    );
  }
}

class _SuccessScreen extends StatelessWidget {
  const _SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 56,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'تم التسجيل بنجاح!',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.neutralDarkDarkest,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جاري تحويلك لتسجيل الدخول...',
            style: AppTextStyles.bodyM.copyWith(
              color: AppColors.neutralDarkLightest,
            ),
          ),
        ],
      ),
    );
  }
}
