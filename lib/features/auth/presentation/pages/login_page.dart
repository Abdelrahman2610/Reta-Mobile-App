import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/features/auth/data/models/user_models.dart';
import 'package:reta/features/auth/presentation/pages/main_page.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/login_cubit.dart';
import 'forgot_password_page.dart';
import 'guest_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Mobile tab controllers
  final _phoneController = TextEditingController();
  final _phoneFocus = FocusNode();

  // National-ID tab controllers
  final _nationalIdController = TextEditingController();
  final _passportController = TextEditingController();
  final _nationalIdFocus = FocusNode();
  final _passportFocus = FocusNode();

  final _mobilePasswordController = TextEditingController();
  final _idPasswordController = TextEditingController();
  final _mobilePasswordFocus = FocusNode();
  final _idPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    _nationalIdController.dispose();
    _passportController.dispose();
    _nationalIdFocus.dispose();
    _passportFocus.dispose();
    _mobilePasswordController.dispose();
    _idPasswordController.dispose();
    _mobilePasswordFocus.dispose();
    _idPasswordFocus.dispose();
    super.dispose();
  }

  void _clearAllControllers() {
    _phoneController.clear();
    _nationalIdController.clear();
    _passportController.clear();
    _mobilePasswordController.clear();
    _idPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.isSuccess && state.loginResponse != null) {
            final response = state.loginResponse!;
            final user = UserModel(
              firstname: response.firstName,
              lastname: response.lastName,
              email: response.email,
              phone: response.mobile,
              emailVerified: response.emailVerified,
              phoneVerified: response.phoneVerified,
              nationalIdVerified: response.ocrVerified,
              userType: UserType.authenticated,
            );

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => MainPage(isLoggedIn: true, user: user),
              ),
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
                          const SizedBox(height: 16),
                          _buildFormCard(state, cubit),
                          const SizedBox(height: 16),
                          _buildBrowseAsGuestButton(context),
                          const SizedBox(height: 8),
                          _buildSignupRow(context),
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

  Widget _buildFormCard(LoginState state, LoginCubit cubit) {
    return Container(
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTabs(state, cubit),
          const SizedBox(height: 16),
          if (state.selectedTab == LoginTab.mobile)
            _buildMobileFields(state, cubit)
          else
            _buildNationalIdFields(state, cubit),
          _buildErrorBannerSection(state),
          const SizedBox(height: 10),
          _buildForgotPasswordButton(),
          const SizedBox(height: 10),
          _buildLoginButton(state, cubit),
        ],
      ),
    );
  }

  Widget _buildMobileFields(LoginState state, LoginCubit cubit) {
    return Column(
      children: [
        _buildTextField(
          context: context,
          controller: _phoneController,
          focusNode: _phoneFocus,
          nextFocus: _mobilePasswordFocus,
          hint: 'رقم الموبايل',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.telephoneNumber],
          errorText: state.phoneError,
          onChanged: cubit.onPhoneChanged,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          context: context,
          controller: _mobilePasswordController,
          focusNode: _mobilePasswordFocus,
          hint: 'كلمة المرور',
          obscureText: !state.isPasswordVisible,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          errorText: state.passwordError,
          onChanged: cubit.onPasswordChanged,
          onSubmitted: (_) => _submitIfValid(state, cubit),
          eyeToggle: _buildEyeToggle(state, cubit),
        ),
      ],
    );
  }

  Widget _buildNationalIdFields(LoginState state, LoginCubit cubit) {
    return Column(
      children: [
        _buildTextField(
          context: context,
          controller: _nationalIdController,
          focusNode: _nationalIdFocus,
          nextFocus: _idPasswordFocus,
          hint: 'الرقم القومي/جواز السفر',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          errorText: state.nationalIdError,
          onChanged: cubit.onNationalIdChanged,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            LengthLimitingTextInputFormatter(24),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          context: context,
          controller: _idPasswordController,
          focusNode: _idPasswordFocus,
          hint: 'كلمة المرور',
          obscureText: !state.isPasswordVisible,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          errorText: state.passwordError,
          onChanged: cubit.onPasswordChanged,
          onSubmitted: (_) => _submitIfValid(state, cubit),
          eyeToggle: _buildEyeToggle(state, cubit),
        ),
      ],
    );
  }

  void _submitIfValid(LoginState state, LoginCubit cubit) {
    if (state.isFormValid && !state.isLoading) cubit.login();
  }

  Widget _buildEyeToggle(LoginState state, LoginCubit cubit) {
    return IconButton(
      icon: Icon(
        state.isPasswordVisible
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        color: AppColors.neutralDarkLightest,
        size: 20,
      ),
      onPressed: cubit.togglePasswordVisibility,
    );
  }

  Widget _buildErrorBannerSection(LoginState state) {
    final errorMessage = state.credentialError ?? state.localError;
    if (errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: _buildErrorBanner(errorMessage),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          minimumSize: const Size(48, 48),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'هل نسيت كلمة المرور؟',
          style: AppTextStyles.actionM.copyWith(
            color: AppColors.highlightDarkest,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(LoginState state, LoginCubit cubit) {
    final bool enabled = state.isFormValid && !state.isLoading;
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: enabled ? cubit.login : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled
              ? AppColors.highlightDarkest
              : AppColors.neutralLightDark,
          disabledBackgroundColor: AppColors.neutralLightDark,
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
                style: AppTextStyles.actionM.copyWith(color: AppColors.white),
              ),
      ),
    );
  }

  Widget _buildBrowseAsGuestButton(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const GuestPage()),
            (route) => false,
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.highlightDarkest, width: 1.5),
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
    );
  }

  Widget _buildSignupRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SignupPage()));
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            minimumSize: const Size(48, 48),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
            width: 170,
            height: 170,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),
          const SizedBox(height: 10),
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

  Widget _buildTabs(LoginState state, LoginCubit cubit) {
    return Row(
      children: [
        Expanded(
          child: _buildSingleTab(
            label: 'بالرقم القومي/جواز السفر',
            isSelected: state.selectedTab == LoginTab.nationalId,
            onTap: () {
              _clearAllControllers();
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
              _clearAllControllers();
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
    TextInputAction textInputAction = TextInputAction.next,
    Iterable<String>? autofillHints,
    Widget? eyeToggle,
    ValueChanged<String>? onSubmitted,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final bool hasError = errorText != null;

    final Widget? prefixIcon = hasError
        ? const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(
              Icons.error_outline,
              color: AppColors.errorDark,
              size: 20,
            ),
          )
        : eyeToggle;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onSubmitted:
          onSubmitted ??
          (nextFocus != null
              ? (_) => FocusScope.of(context).requestFocus(nextFocus)
              : null),
      style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyM.copyWith(
          color: AppColors.neutralDarkLightest,
        ),
        prefixIcon: prefixIcon,
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
