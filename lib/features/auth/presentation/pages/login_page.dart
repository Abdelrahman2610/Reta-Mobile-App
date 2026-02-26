import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/login_cubit.dart';
import 'forgot_password_page.dart'; // ← NEW
import 'main_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final _nationalIdController = TextEditingController();
  final _passportController = TextEditingController();
  final _nationalIdFocus = FocusNode();
  final _passportFocus = FocusNode();
  final _idPasswordFocus = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _nationalIdController.dispose();
    _passportController.dispose();
    _nationalIdFocus.dispose();
    _passportFocus.dispose();
    _idPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const MainPage()),
              (route) => false,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.neutralLightLight,
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
                  child: BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      final cubit = context.read<LoginCubit>();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'تسجيل الدخول',
                            textAlign: TextAlign.right,
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.mainBlueIndigoDye,
                            ),
                          ),
                          const SizedBox(height: 20),
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
                                _buildTabs(
                                  state,
                                  cubit,
                                  onTabSwitch: () {
                                    _phoneController.clear();
                                    _passwordController.clear();
                                    _nationalIdController.clear();
                                    _passportController.clear();
                                  },
                                ),
                                const SizedBox(height: 16),
                                if (state.selectedTab == LoginTab.mobile) ...[
                                  _buildTextField(
                                    context: context,
                                    controller: _phoneController,
                                    focusNode: _phoneFocus,
                                    nextFocus: _passwordFocus,
                                    hint: 'رقم الموبايل',
                                    keyboardType: TextInputType.phone,
                                    errorText: state.phoneError,
                                    onChanged: cubit.onPhoneChanged,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                    context: context,
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    hint: 'كلمة المرور',
                                    obscureText: !state.isPasswordVisible,
                                    errorText: state.passwordError,
                                    onChanged: cubit.onPasswordChanged,
                                    eyeToggle: IconButton(
                                      icon: Icon(
                                        state.isPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: AppColors.neutralDarkLightest,
                                        size: 20,
                                      ),
                                      onPressed: cubit.togglePasswordVisibility,
                                    ),
                                  ),
                                ] else ...[
                                  _buildTextField(
                                    context: context,
                                    controller: _nationalIdController,
                                    focusNode: _nationalIdFocus,
                                    nextFocus: _passportFocus,
                                    hint: 'الرقم القومي',
                                    keyboardType: TextInputType.number,
                                    errorText: state.nationalIdError,
                                    onChanged: cubit.onNationalIdChanged,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                    context: context,
                                    controller: _passportController,
                                    focusNode: _passportFocus,
                                    nextFocus: _idPasswordFocus,
                                    hint: 'رقم جواز السفر',
                                    keyboardType: TextInputType.text,
                                    errorText: state.passportError,
                                    onChanged: cubit.onPassportChanged,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                    context: context,
                                    controller: _passwordController,
                                    focusNode: _idPasswordFocus,
                                    hint: 'كلمة المرور',
                                    obscureText: !state.isPasswordVisible,
                                    errorText: state.passwordError,
                                    onChanged: cubit.onPasswordChanged,
                                    eyeToggle: IconButton(
                                      icon: Icon(
                                        state.isPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: AppColors.neutralDarkLightest,
                                        size: 20,
                                      ),
                                      onPressed: cubit.togglePasswordVisibility,
                                    ),
                                  ),
                                ],

                                // ── Error banner ──
                                if (state.credentialError != null ||
                                    state.localError != null) ...[
                                  const SizedBox(height: 12),
                                  _buildErrorBanner(
                                    state.credentialError ?? state.localError!,
                                  ),
                                ],

                                const SizedBox(height: 10),

                                // ── Forgot password link — UPDATED ──
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ForgotPasswordPage(),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Text(
                                      'هل نسيت كلمة المرور؟',
                                      style: AppTextStyles.actionM.copyWith(
                                        color: AppColors.highlightDarkest,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed:
                                        state.isFormValid && !state.isLoading
                                        ? cubit.login
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: state.isFormValid
                                          ? AppColors.highlightDarkest
                                          : AppColors.neutralLightDark,
                                      disabledBackgroundColor:
                                          AppColors.neutralLightDark,
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
                                            'تسجيل الدخول',
                                            style: AppTextStyles.actionM
                                                .copyWith(
                                                  color: AppColors.white,
                                                ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            height: 52,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const MainPage(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.highlightDarkest,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'التصفح كزائر',
                                style: AppTextStyles.actionM.copyWith(
                                  color: AppColors.highlightDarkest,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const SignupPage(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  'أنشئ حسابًا جديدًا',
                                  style: AppTextStyles.actionM.copyWith(
                                    color: AppColors.highlightDarkest,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Text(
                                ' ليس لديك حساب؟',
                                style: AppTextStyles.actionM.copyWith(
                                  color: AppColors.neutralDarkLightest,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 32, left: 24, right: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.mainBlueIndigoDye, AppColors.mainDarkBlue],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.white.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 8,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: AppColors.white.withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 12,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),
          const SizedBox(height: 16),
          Text(
            'مرحبا بك في خدمات مصلحة الضرائب العقارية',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppTextStyles.h4.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(
    LoginState state,
    LoginCubit cubit, {
    required VoidCallback onTabSwitch,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildSingleTab(
            label: 'برقم جواز السفر',
            isSelected: state.selectedTab == LoginTab.nationalId,
            onTap: () {
              onTabSwitch();
              cubit.selectTab(LoginTab.nationalId);
            },
          ),
        ),
        Container(width: 1, height: 40, color: AppColors.neutralLightDark),
        Expanded(
          child: _buildSingleTab(
            label: 'برقم الموبايل',
            isSelected: state.selectedTab == LoginTab.mobile,
            onTap: () {
              onTabSwitch();
              cubit.selectTab(LoginTab.mobile);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSingleTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
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

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required ValueChanged<String> onChanged,
    FocusNode? nextFocus,
    bool obscureText = false,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    Widget? eyeToggle,
  }) {
    final hasError = errorText != null;
    final Widget? leftIcon = hasError
        ? const Icon(Icons.error_outline, color: AppColors.errorDark, size: 20)
        : eyeToggle;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      onChanged: onChanged,
      onSubmitted: nextFocus != null
          ? (_) => FocusScope.of(context).requestFocus(nextFocus)
          : null,
      style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyM.copyWith(
          color: AppColors.neutralDarkLightest,
        ),
        prefixIcon: leftIcon,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: hasError ? AppColors.errorDark : AppColors.neutralLightDark,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: hasError ? AppColors.errorDark : AppColors.highlightDarkest,
            width: 1.5,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          const Icon(Icons.error, color: AppColors.warningMedium, size: 18),
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
