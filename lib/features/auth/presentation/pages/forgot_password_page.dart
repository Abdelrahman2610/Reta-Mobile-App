import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/forgot_password_cubit.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
      child: const _ForgotPasswordShell(),
    );
  }
}

class _ForgotPasswordShell extends StatelessWidget {
  const _ForgotPasswordShell();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.neutralLightLight,
          appBar: _buildAppBar(context, state),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: _buildStep(context, state),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, ForgotPasswordState state) {
    final canGoBack =
        state.step == ForgotStep.input ||
        state.step == ForgotStep.otp ||
        state.step == ForgotStep.otpSuccess ||
        state.step == ForgotStep.newPassword;

    return AppBar(
      backgroundColor: AppColors.neutralLightDarkest,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        if (canGoBack)
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.mainBlueSecondary,
              size: 20,
            ),
            onPressed: () => _handleBack(context, state),
          ),
      ],
      title: Text(
        'إعادة تعيين كلمة المرور',
        style: AppTextStyles.actionXL.copyWith(
          color: AppColors.mainBlueSecondary,
        ),
      ),
    );
  }

  void _handleBack(BuildContext context, ForgotPasswordState state) {
    final cubit = context.read<ForgotPasswordCubit>();
    switch (state.step) {
      case ForgotStep.input:
        Navigator.pop(context);
      case ForgotStep.otp:
        cubit.goBackToInput();
      case ForgotStep.newPassword:
        cubit.goBackToInput();
      default:
        break;
    }
  }

  Widget _buildStep(BuildContext context, ForgotPasswordState state) {
    switch (state.step) {
      case ForgotStep.input:
        return const _StepInput(key: ValueKey('input'));
      case ForgotStep.otp:
        return const _StepOtp(key: ValueKey('otp'));
      case ForgotStep.otpSuccess:
        return const _StepOtpSuccess(key: ValueKey('otpSuccess'));
      case ForgotStep.newPassword:
        return const _StepNewPassword(key: ValueKey('newPassword'));
      case ForgotStep.emailSent: // ✅ add this
        return const _StepEmailSent(key: ValueKey('emailSent'));
      case ForgotStep.done:
        return const _StepDone(key: ValueKey('done'));
    }
  }
}

class _StepEmailSent extends StatelessWidget {
  const _StepEmailSent({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.read<ForgotPasswordCubit>().state.email;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read_rounded,
                size: 52,
                color: AppColors.successDark,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'تحقق من بريدك الإلكتروني',
              textAlign: TextAlign.center,
              style: AppTextStyles.h3.copyWith(
                color: AppColors.neutralDarkDarkest,
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              text: TextSpan(
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.neutralDarkLightest,
                ),
                children: [
                  const TextSpan(
                    text: 'تم إرسال تفاصيل استعادة كلمة المرور إلى ',
                  ),
                  TextSpan(
                    text: email,
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.neutralDarkDarkest,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.highlightDarkest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'العودة لتسجيل الدخول',
                  style: AppTextStyles.actionL.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepInput extends StatefulWidget {
  const _StepInput({super.key});

  @override
  State<_StepInput> createState() => _StepInputState();
}

class _StepInputState extends State<_StepInput> {
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileFocus = FocusNode();
  final _emailFocus = FocusNode();

  @override
  void dispose() {
    _mobileController.dispose();
    _emailController.dispose();
    _mobileFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        final cubit = context.read<ForgotPasswordCubit>();
        final isMobile = state.selectedTab == ForgotTab.mobile;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'اختار الطريقة المناسبة إلى إعادة تعيين كلمة المرور',
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.mainBlueIndigoDye,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTabs(state, cubit),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isMobile
                          ? _buildTextField(
                              key: const ValueKey('mobile'),
                              controller: _mobileController,
                              focusNode: _mobileFocus,
                              hint: 'أدخل رقم الموبايل',
                              keyboardType: TextInputType.phone,
                              errorText: state.mobileError,
                              onChanged: cubit.onMobileChanged,
                            )
                          : _buildTextField(
                              key: const ValueKey('email'),
                              controller: _emailController,
                              focusNode: _emailFocus,
                              hint: 'أدخل البريد الإلكتروني',
                              keyboardType: TextInputType.emailAddress,
                              errorText: state.emailError,
                              onChanged: cubit.onEmailChanged,
                            ),
                    ),
                    if (state.requestError != null) ...[
                      const SizedBox(height: 12),
                      _ErrorBanner(message: state.requestError!),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: state.isLoading ? null : cubit.requestReset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.highlightDarkest,
                          disabledBackgroundColor: AppColors.neutralLightDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: state.isLoading
                            ? const _LoadingIndicator()
                            : Text(
                                'إعادة تعيين كلمة المرور',
                                style: AppTextStyles.actionL.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabs(ForgotPasswordState state, ForgotPasswordCubit cubit) {
    return Row(
      children: [
        Expanded(
          child: _TabItem(
            label: 'البريد الإلكتروني',
            isSelected: state.selectedTab == ForgotTab.email,
            onTap: () {
              _mobileController.clear();
              _emailController.clear();
              cubit.selectTab(ForgotTab.email);
            },
          ),
        ),
        Container(width: 1, height: 40, color: AppColors.neutralLightDark),
        Expanded(
          child: _TabItem(
            label: 'برقم الموبايل',
            isSelected: state.selectedTab == ForgotTab.mobile,
            onTap: () {
              _mobileController.clear();
              _emailController.clear();
              cubit.selectTab(ForgotTab.mobile);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required Key key,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required ValueChanged<String> onChanged,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
  }) {
    final hasError = errorText != null;
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          onChanged: onChanged,
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.neutralDarkDarkest,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyM.copyWith(
              color: AppColors.neutralDarkLightest,
            ),
            fillColor: hasError ? AppColors.white : AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.errorMedium
                    : AppColors.neutralLightDark,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.errorDark
                    : AppColors.highlightDarkest,
                width: 1.5,
              ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 10),
          _ErrorBanner(message: errorText),
        ],
      ],
    );
  }
}

class _StepOtp extends StatefulWidget {
  const _StepOtp({super.key});

  @override
  State<_StepOtp> createState() => _StepOtpState();
}

class _StepOtpState extends State<_StepOtp> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<FocusNode> _listenerNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    for (final f in _listenerNodes) f.dispose();
    super.dispose();
  }

  String get _otpValue => _controllers.map((c) => c.text).join();

  void _onDigitEntered(int index, String value) {
    if (!mounted) return;
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    context.read<ForgotPasswordCubit>().onOtpChanged(_otpValue);
  }

  void _onKeyBack(int index) {
    if (!mounted) return;
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      context.read<ForgotPasswordCubit>().onOtpChanged(_otpValue);
    }
  }

  void _clearBoxes() {
    for (final c in _controllers) {
      c.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listenWhen: (prev, curr) =>
          prev.otpValue.isNotEmpty && curr.otpValue.isEmpty,
      listener: (_, __) => _clearBoxes(),
      builder: (context, state) {
        final cubit = context.read<ForgotPasswordCubit>();
        final identifier = state.selectedTab == ForgotTab.mobile
            ? state.mobile
            : state.email;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 28),
          child: Column(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.neutralDarkLightest.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  state.selectedTab == ForgotTab.mobile
                      ? Icons.phone_android_rounded
                      : Icons.mark_email_read_rounded,
                  size: 44,
                  color: AppColors.mainBlueIndigoDye,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'رمز التحقق',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.mainBlueSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTextStyles.bodyM.copyWith(
                          color: AppColors.neutralDarkLightest,
                        ),
                        children: [
                          const TextSpan(text: 'تم إرسال رمز التحقق إلى '),
                          TextSpan(
                            text: identifier,
                            style: AppTextStyles.bodyM.copyWith(
                              color: AppColors.neutralDarkDarkest,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final boxSize = (constraints.maxWidth - 50) / 6;
                        return Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (i) {
                              return SizedBox(
                                width: boxSize,
                                height: boxSize * 1.15,
                                child: KeyboardListener(
                                  focusNode: _listenerNodes[i],
                                  onKeyEvent: (e) {
                                    if (e is KeyDownEvent &&
                                        e.logicalKey ==
                                            LogicalKeyboardKey.backspace) {
                                      _onKeyBack(i);
                                    }
                                  },
                                  child: TextField(
                                    controller: _controllers[i],
                                    focusNode: _focusNodes[i],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onChanged: (v) => _onDigitEntered(i, v),
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
                        );
                      },
                    ),

                    if (state.otpError != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        state.otpError!,
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.bodyS.copyWith(
                          color: AppColors.errorDark,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.resendCooldown > 0)
                          Text(
                            '(${state.resendCooldown}ث)',
                            style: AppTextStyles.bodyS.copyWith(
                              color: AppColors.neutralDarkLightest,
                            ),
                          )
                        else
                          TextButton(
                            onPressed: state.isLoading ? null : cubit.resendOtp,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'إعادة إرسال الرمز',
                              style: AppTextStyles.actionS.copyWith(
                                color: AppColors.highlightDarkest,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        const SizedBox(width: 4),
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

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (_otpValue.length == 6 && !state.isLoading)
                      ? cubit.confirmOtp
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
                      ? const _LoadingIndicator()
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
        );
      },
    );
  }
}

class _StepOtpSuccess extends StatelessWidget {
  const _StepOtpSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'تسجيل الدخول',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppTextStyles.h2.copyWith(
              color: AppColors.mainBlueIndigoDye,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'تمت إعادة تعيين كلمة مرورك بنجاح. انقر على "تأكيد" لتعيين كلمة مرور جديدة.',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppTextStyles.h4.copyWith(
              color: AppColors.mainBlueIndigoDye,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: context
                        .read<ForgotPasswordCubit>()
                        .proceedToNewPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.highlightDarkest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
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
        ],
      ),
    );
  }
}

class _StepNewPassword extends StatefulWidget {
  const _StepNewPassword({super.key});

  @override
  State<_StepNewPassword> createState() => _StepNewPasswordState();
}

class _StepNewPasswordState extends State<_StepNewPassword> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _newPasswordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        final cubit = context.read<ForgotPasswordCubit>();

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'عيّن كلمة مرور جديدة',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.mainBlueIndigoDye,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'أنشئ كلمة مرور جديدة. تأكد من أنها مختلفة عن كلمات المرور السابقة لأسباب أمنية',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.mainBlueIndigoDye,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLabel('كلمة المرور'),
                    const SizedBox(height: 8),
                    _buildPasswordField(
                      controller: _newPasswordController,
                      focusNode: _newPasswordFocus,
                      nextFocus: _confirmPasswordFocus,
                      hint: 'أدخل كلمة مرورك الجديدة',
                      obscureText: !state.isNewPasswordVisible,
                      errorText: state.newPasswordError,
                      onChanged: cubit.onNewPasswordChanged,
                      onToggleVisibility: cubit.toggleNewPasswordVisibility,
                      isVisible: state.isNewPasswordVisible,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('تأكيد كلمة المرور'),
                    const SizedBox(height: 8),
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      hint: 'أعد إدخال كلمة المرور',
                      obscureText: !state.isConfirmPasswordVisible,
                      errorText: state.confirmPasswordError,
                      onChanged: cubit.onConfirmPasswordChanged,
                      onToggleVisibility: cubit.toggleConfirmPasswordVisibility,
                      isVisible: state.isConfirmPasswordVisible,
                    ),
                    if (state.resetError != null) ...[
                      const SizedBox(height: 12),
                      _ErrorBanner(message: state.resetError!),
                    ],
                  ],
                ),
                SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: (cubit.isNewPasswordValid && !state.isLoading)
                          ? cubit.submitNewPassword
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cubit.isNewPasswordValid
                            ? AppColors.highlightDarkest
                            : AppColors.neutralLightDark,
                        disabledBackgroundColor: AppColors.neutralLightDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: state.isLoading
                          ? const _LoadingIndicator()
                          : Text(
                              'تحديث كلمة المرور',
                              style: AppTextStyles.actionL.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildPasswordRequirements(state.newPassword),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          textDirection: TextDirection.rtl,
          style: AppTextStyles.h5.copyWith(
            color: AppColors.neutralDarkLightest,
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          '*',
          style: TextStyle(
            color: AppColors.errorDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    required String hint,
    required bool obscureText,
    required String? errorText,
    required ValueChanged<String> onChanged,
    required VoidCallback onToggleVisibility,
    required bool isVisible,
  }) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          onChanged: onChanged,
          onSubmitted: nextFocus != null
              ? (_) => FocusScope.of(context).requestFocus(nextFocus)
              : null,
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.neutralDarkDarkest,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyM.copyWith(
              color: AppColors.neutralDarkLightest,
            ),
            prefixIcon: hasError
                ? const Icon(
                    Icons.error_outline,
                    color: AppColors.errorDark,
                    size: 20,
                  )
                : IconButton(
                    icon: Icon(
                      isVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.neutralDarkLightest,
                      size: 20,
                    ),
                    onPressed: onToggleVisibility,
                  ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.errorDark
                    : AppColors.neutralLightDark,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.errorDark
                    : AppColors.highlightDarkest,
                width: 1.5,
              ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            errorText,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyS.copyWith(color: AppColors.errorDark),
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordRequirements(String password) {
    final rules = [
      _PasswordRule(
        label: 'يجب أن تحتوي على حرف كبير (A-Z).',
        met: password.contains(RegExp(r'[A-Z]')),
      ),
      _PasswordRule(
        label: 'يجب أن تحتوي على حرف صغير (a-z).',
        met: password.contains(RegExp(r'[a-z]')),
      ),
      _PasswordRule(
        label: 'يجب أن تحتوي على رقم واحد على الأقل.',
        met: password.contains(RegExp(r'[0-9]')),
      ),
      _PasswordRule(
        label: r'يمكن إضافة رموز خاصة مثل (! @ # $ % ( )) وهي اختيارية.',
        met: password.contains(RegExp(r'[!@#\$%^&*()\[\]{}|\<>,.?/~`\-_=+]')),
        optional: true,
      ),
      _PasswordRule(
        label: 'الحد الأدنى 8 أحرف والحد الأقصى 10 أحرف.',
        met: password.length >= 8 && password.length <= 10,
      ),
      _PasswordRule(
        label: 'لا يُسمح باستخدام المسافات.',
        met: password.isNotEmpty && !password.contains(' '),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'متطلبات كلمة المرور:',
          textDirection: TextDirection.rtl,
          style: AppTextStyles.h5.copyWith(
            color: AppColors.neutralDarkLightest,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...rules.map((r) => _buildRequirementRow(r)),
      ],
    );
  }

  Widget _buildRequirementRow(_PasswordRule rule) {
    final Color textColor = rule.met
        ? AppColors.successDark
        : rule.optional
        ? const Color(0xFF9AA5B4)
        : AppColors.neutralDarkLightest;

    final Color bulletColor = rule.met
        ? AppColors.successDark
        : rule.optional
        ? const Color(0xFF9AA5B4)
        : AppColors.neutralDarkLightest;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyle(color: bulletColor, fontSize: 14, height: 1.4),
          ),
          Expanded(
            child: Text(
              rule.label,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyS.copyWith(
                color: textColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordRule {
  final String label;
  final bool met;
  final bool optional;
  const _PasswordRule({
    required this.label,
    required this.met,
    this.optional = false,
  });
}

class _StepDone extends StatefulWidget {
  const _StepDone({super.key});

  @override
  State<_StepDone> createState() => _StepDoneState();
}

class _StepDoneState extends State<_StepDone> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_reset,
                size: 52,
                color: AppColors.successDark,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'تم تغيير كلمة المرور بنجاح!',
              textAlign: TextAlign.center,
              style: AppTextStyles.h3.copyWith(
                color: AppColors.neutralDarkDarkest,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'جاري تحويلك لتسجيل الدخول...',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.neutralDarkLightest,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: AppColors.highlightDarkest,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isSelected ? Colors.transparent : AppColors.neutralLightMedium,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.h5.copyWith(
                  color: isSelected
                      ? AppColors.neutralDarkDarkest
                      : AppColors.neutralDarkLightest,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 3,
                width: isSelected ? 50 : 0,
                decoration: BoxDecoration(
                  color: AppColors.highlightDarkest,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          const Icon(Icons.error, color: AppColors.errorMedium, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.neutralDarkMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(
        color: AppColors.white,
        strokeWidth: 2.5,
      ),
    );
  }
}
