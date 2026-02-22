import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/signup_cubit.dart';

/// OTP Verification Page — shown after successful signup form submission.
/// Handles 3 sub-steps internally:
///   1. Intro  — "we sent a code to your number"
///   2. Input  — 6-box OTP entry
///   3. Success — checkmark + navigate to login
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

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
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

  Future<void> _confirmOtp(BuildContext context) async {
    if (_otpValue.length < 6) return;
    final success = await context.read<SignupCubit>().confirmOtp(_otpValue);
    if (success && mounted) {
      setState(() => _step = _OtpStep.success);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightLight,
      appBar: AppBar(
        backgroundColor: AppColors.mainBlueIndigoDye,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.neutralLightLightest,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        title: Text(
          'تأكيد رقم الهاتف',
          style: AppTextStyles.actionXL.copyWith(
            color: AppColors.neutralLightLightest,
          ),
        ),
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
          child: _step == _OtpStep.intro
              ? _IntroScreen(
                  key: const ValueKey('intro'),
                  phoneNumber: widget.phoneNumber,
                  onContinue: () => setState(() => _step = _OtpStep.input),
                )
              : _step == _OtpStep.input
              ? _InputScreen(
                  key: const ValueKey('input'),
                  phoneNumber: widget.phoneNumber,
                  controllers: _controllers,
                  focusNodes: _focusNodes,
                  otpValue: _otpValue,
                  onDigitEntered: _onDigitEntered,
                  onKeyBack: _onKeyBack,
                  onConfirm: () => _confirmOtp(context),
                  onResend: () async {
                    for (final c in _controllers) {
                      c.clear();
                    }
                    _focusNodes[0].requestFocus();
                    setState(() {});
                    await context.read<SignupCubit>().resendOtp();
                  },
                )
              : const _SuccessScreen(key: ValueKey('success')),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Screen 1 — Intro
// ─────────────────────────────────────────
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

          // ── Icon ──
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

          const SizedBox(height: 28),

          // ── Card ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
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
                const SizedBox(height: 8),
                Text(
                  phoneNumber,
                  textDirection: TextDirection.ltr,
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.neutralDarkDarkest,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // ── Button ──
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

// ─────────────────────────────────────────
// Screen 2 — OTP Input
// ─────────────────────────────────────────
class _InputScreen extends StatelessWidget {
  final String phoneNumber;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final String otpValue;
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
    required this.onDigitEntered,
    required this.onKeyBack,
    required this.onConfirm,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ── Card ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'أدخل رمز التحقق',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.mainBlueIndigoDye,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTextStyles.bodyM.copyWith(
                          color: AppColors.neutralDarkLightest,
                        ),
                        children: [
                          const TextSpan(text: 'تم إرسال الرمز إلى '),
                          TextSpan(
                            text: phoneNumber,
                            style: AppTextStyles.bodyM.copyWith(
                              color: AppColors.neutralDarkDarkest,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── 6-box OTP input ──
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  fillColor: AppColors.neutralLightLight,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColors.neutralLightDark,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColors.neutralLightDark,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColors.mainBlueIndigoDye,
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

                    if (state.submitError != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        state.submitError!,
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.captionM.copyWith(
                          color: AppColors.errorDark,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // ── Resend ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: state.isLoading ? null : onResend,
                          child: Text(
                            'إعادة إرسال الرمز',
                            style: AppTextStyles.actionS.copyWith(
                              color: AppColors.highlightDarkest,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text(
                          'لم تستلم الرمز؟ ',
                          style: AppTextStyles.bodyS.copyWith(
                            color: AppColors.neutralDarkLightest,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ── Confirm Button ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (otpValue.length == 6 && !state.isLoading)
                      ? onConfirm
                      : null,
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
                          style: AppTextStyles.actionL.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────
// Screen 3 — Success
// ─────────────────────────────────────────
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
