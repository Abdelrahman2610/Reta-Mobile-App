import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reta/features/auth/presentation/pages/terms_privacy_page.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/signup_cubit.dart';
import 'otp_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _firstNameController = TextEditingController();
  final _restOfNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _passportNumController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _manualBirthPlaceController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _restOfNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _passportNumController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    _manualBirthPlaceController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(
    BuildContext context, {
    required String title,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    required void Function(DateTime) onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime(1990),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
      helpText: title,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.mainBlueIndigoDye,
            onPrimary: AppColors.white,
            onSurface: AppColors.neutralDarkDarkest,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return BlocProvider(
      create: (_) => SignupCubit(),
      child: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.isSubmitSuccess) {
            context.read<SignupCubit>().resetSubmitSuccess();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<SignupCubit>(),
                  child: OtpPage(phoneNumber: state.phone, email: state.email),
                ),
              ),
            );
          }
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
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.mainBlueIndigoDye,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.neutralLightLightest,
              ),
              onPressed: () => Navigator.pop(context),
            ),

            title: Text(
              'إنشاء حساب جديد',
              style: AppTextStyles.actionXL.copyWith(
                color: AppColors.neutralLightLightest,
              ),
            ),
          ),
          body: BlocBuilder<SignupCubit, SignupState>(
            builder: (context, state) {
              final cubit = context.read<SignupCubit>();
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Field(
                      label: 'الاسم الأول',
                      isRequired: true,
                      hint: 'أحمد',
                      controller: _firstNameController,
                      errorText: state.firstNameError,
                      onChanged: cubit.onFirstNameChanged,
                    ),
                    _Field(
                      label: 'باقي الاسم',
                      isRequired: true,
                      hint: 'عادل ابراهيم الدسوقي',
                      controller: _restOfNameController,
                      errorText: state.restOfNameError,
                      onChanged: cubit.onRestOfNameChanged,
                    ),
                    _Field(
                      label: 'البريد الإلكتروني',
                      isRequired: false,
                      hint: 'name@email.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      errorText: state.emailError,
                      onChanged: cubit.onEmailChanged,
                    ),
                    _Field(
                      label: 'رقم الهاتف المحمول',
                      isRequired: true,
                      hint: '+20 100 077 16',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      errorText: state.phoneError,
                      onChanged: cubit.onPhoneChanged,
                      hintTextDirection: TextDirection.ltr,
                    ),
                    _InlineExpandField(
                      label: 'الجنسية',
                      isRequired: true,
                      value: state.selectedNationality?.label,
                      hint: 'اختر الجنسية',
                      isExpanded: state.isNationalityExpanded,
                      options: state.nationalityOptions,
                      isLoading: state.isNationalityLoading,
                      errorText: state.nationalityError,
                      onToggle: cubit.toggleNationalityExpand,
                      onSelected: cubit.onNationalitySelected,
                    ),

                    // ── Egyptian fields ──────────────────────────────────────
                    if (state.nationalityType == NationalityType.egyptian) ...[
                      _SectionTitle(title: 'بيانات الهوية'),
                      _Field(
                        label: 'الرقم القومي',
                        isRequired: true,
                        hint: '12345678901234',
                        controller: _nationalIdController,
                        keyboardType: TextInputType.number,
                        maxLength: 14,
                        errorText: state.nationalIdError,
                        onChanged: cubit.onNationalIdChanged,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      _ImageUploadField(
                        label: 'مرفق الرقم القومي',
                        isRequired: true,
                        hasImage: state.hasNationalIdImage,
                        errorText: state.nationalIdImageError,
                        onPickImage: cubit.onNationalIdImagePicked,
                        onRemoveImage: cubit.onNationalIdImageRemoved,
                      ),
                      _DateField(
                        label: 'تاريخ الميلاد',
                        isRequired: true,
                        hint: 'يوم/شهر/سنة',
                        value: state.birthDate,
                        errorText: state.birthDateError,
                        onTap: () => _pickDate(
                          context,
                          title: 'تاريخ الميلاد',
                          initialDate: state.birthDate,
                          lastDate: DateTime.now(),
                          onPicked: cubit.onBirthDateSelected,
                        ),
                      ),
                      _InlineExpandField(
                        label: 'محل الميلاد',
                        isRequired: true,
                        value: state.selectedBirthPlace?.label,
                        hint: 'اختر محل الميلاد',
                        isExpanded: state.isBirthPlaceExpanded,
                        options: state.residenceOptions,
                        isLoading: state.isResidenceLoading,
                        errorText: state.birthPlaceError,
                        onToggle: cubit.toggleBirthPlaceExpand,
                        onSelected: cubit.onBirthPlaceSelected,
                      ),
                      if (state.showManualBirthPlace)
                        _Field(
                          label: 'إدخل محل الميلاد',
                          isRequired: true,
                          hint: 'الرياض',
                          controller: _manualBirthPlaceController,
                          errorText: state.manualBirthPlaceError,
                          onChanged: cubit.onManualBirthPlaceChanged,
                        ),
                      _InlineExpandGenderField(
                        label: 'النوع',
                        isRequired: true,
                        selectedGender: state.selectedGender,
                        options: state.genderOptions,
                        isLoading: state.isGenderLoading,
                        isExpanded: state.isGenderExpanded,
                        errorText: state.genderError,
                        onToggle: cubit.toggleGenderExpand,
                        onSelected: cubit.onGenderSelected,
                      ),
                    ],

                    // ── Foreign fields ───────────────────────────────────────
                    if (state.nationalityType == NationalityType.foreign) ...[
                      _SectionTitle(title: 'بيانات جواز السفر'),
                      _Field(
                        label: 'رقم جواز السفر',
                        isRequired: true,
                        hint: 'رقم جواز السفر',
                        controller: _passportNumController,
                        errorText: state.passportNumberError,
                        onChanged: cubit.onPassportNumberChanged,
                      ),
                      _DateField(
                        label: 'تاريخ الميلاد',
                        isRequired: true,
                        hint: 'يوم/شهر/سنة',
                        value: state.birthDate,
                        errorText: state.birthDateError,
                        onTap: () => _pickDate(
                          context,
                          title: 'تاريخ الميلاد',
                          initialDate: state.birthDate,
                          lastDate: DateTime.now(),
                          onPicked: cubit.onBirthDateSelected,
                        ),
                      ),
                      _ImageUploadField(
                        label: 'مرفق صورة جواز السفر',
                        isRequired: true,
                        hasImage: state.hasNationalIdImage,
                        errorText: state.nationalIdImageError,
                        onPickImage: cubit.onNationalIdImagePicked,
                        onRemoveImage: cubit.onNationalIdImageRemoved,
                      ),
                      _InlineExpandField(
                        label: 'محل الميلاد',
                        isRequired: true,
                        value: state.selectedBirthPlace?.label,
                        hint: 'اختر محل الميلاد',
                        isExpanded: state.isBirthPlaceExpanded,
                        options: state.residenceOptions,
                        isLoading: state.isResidenceLoading,
                        errorText: state.birthPlaceError,
                        onToggle: cubit.toggleBirthPlaceExpand,
                        onSelected: cubit.onBirthPlaceSelected,
                      ),
                      if (state.showManualBirthPlace)
                        _Field(
                          label: 'إدخل محل الميلاد',
                          isRequired: true,
                          hint: 'الرياض',
                          controller: _manualBirthPlaceController,
                          errorText: state.manualBirthPlaceError,
                          onChanged: cubit.onManualBirthPlaceChanged,
                        ),
                      _InlineExpandGenderField(
                        label: 'النوع',
                        isRequired: true,
                        selectedGender: state.selectedGender,
                        options: state.genderOptions,
                        isLoading: state.isGenderLoading,
                        isExpanded: state.isGenderExpanded,
                        errorText: state.genderError,
                        onToggle: cubit.toggleGenderExpand,
                        onSelected: cubit.onGenderSelected,
                      ),
                    ],

                    _Field(
                      label: 'كلمة السر',
                      isRequired: true,
                      hint: '••••••••',
                      controller: _passwordController,
                      obscureText: !state.isPasswordVisible,
                      errorText: state.passwordError,
                      onChanged: cubit.onPasswordChanged,
                      suffix: IconButton(
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
                    _Field(
                      label: 'تأكيد كلمة السر',
                      isRequired: true,
                      hint: '••••••••',
                      controller: _confirmPassController,
                      obscureText: !state.isConfirmPasswordVisible,
                      errorText: state.confirmPasswordError,
                      onChanged: cubit.onConfirmPasswordChanged,
                      suffix: IconButton(
                        icon: Icon(
                          state.isConfirmPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.neutralDarkLightest,
                          size: 20,
                        ),
                        onPressed: cubit.toggleConfirmPasswordVisibility,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: state.agreedToTerms,
                          onChanged: cubit.toggleTerms,
                          activeColor: AppColors.highlightDarkest,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Wrap(
                              children: [
                                Text(
                                  'أقر بأنني قرأت ووافقت على ',
                                  style: AppTextStyles.bodyM.copyWith(
                                    color: AppColors.neutralDarkLight,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const TermsPrivacyPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'الشروط والأحكام وسياسة الخصوصية',
                                    style: AppTextStyles.bodyM.copyWith(
                                      color: AppColors.highlightDarkest,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (state.termsError != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        state.termsError!,
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.captionM.copyWith(
                          color: AppColors.errorDark,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: !state.isLoading ? cubit.submit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.highlightDarkest,
                          disabledBackgroundColor:
                              AppColors.neutralLightDarkest,
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
                                'إنشاء حساب',
                                style: AppTextStyles.actionM.copyWith(
                                  color: AppColors.neutralLightLightest,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        title,
        textDirection: TextDirection.rtl,
        style: AppTextStyles.h5.copyWith(color: AppColors.neutralDarkDark),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final bool isRequired;
  final String hint;
  final TextEditingController controller;
  final String? errorText;
  final void Function(String) onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection hintTextDirection;

  const _Field({
    required this.label,
    required this.isRequired,
    required this.hint,
    required this.controller,
    required this.errorText,
    required this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.maxLength,
    this.inputFormatters,
    this.hintTextDirection = TextDirection.rtl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
              style: AppTextStyles.h5.copyWith(
                color: AppColors.neutralDarkDark,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(text: label),
                if (isRequired)
                  TextSpan(
                    text: '* ',
                    style: AppTextStyles.h5.copyWith(
                      color: AppColors.errorDark,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: keyboardType,
              obscureText: obscureText,
              maxLength: maxLength,
              inputFormatters: inputFormatters,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.neutralDarkDark,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.bodyM.copyWith(
                  color: AppColors.neutralDarkLightest,
                ),
                hintTextDirection: hintTextDirection,
                suffixIcon: suffix,
                counterText: '',
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.neutralLightDarkest,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.neutralLightDarkest,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.highlightDarkest,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.errorDark),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.errorDark,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              errorText!,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.captionM.copyWith(
                color: AppColors.errorDark,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final DateTime? value;
  final String? errorText;
  final VoidCallback onTap;
  final String hint;

  const _DateField({
    required this.label,
    required this.isRequired,
    required this.hint,
    required this.value,
    required this.errorText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = value != null
        ? '${value!.year}/${value!.month.toString().padLeft(2, '0')}/${value!.day.toString().padLeft(2, '0')}'
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
              style: AppTextStyles.h5.copyWith(
                color: AppColors.neutralDarkDark,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(text: label),
                if (isRequired)
                  TextSpan(
                    text: '* ',
                    style: AppTextStyles.h5.copyWith(
                      color: AppColors.errorDark,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: errorText != null
                      ? AppColors.errorDark
                      : AppColors.neutralDarkLightest,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatted ?? hint,
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.bodyM.copyWith(
                      color: formatted != null
                          ? AppColors.neutralDarkDarkest
                          : AppColors.neutralDarkLightest,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: AppColors.neutralDarkLightest,
                  ),
                ],
              ),
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              errorText!,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.captionM.copyWith(
                color: AppColors.errorDark,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InlineExpandField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final String? value;
  final String hint;
  final bool isExpanded;
  final List<DropdownItem> options;
  final bool isLoading;
  final String? errorText;
  final VoidCallback onToggle;
  final void Function(DropdownItem) onSelected;

  const _InlineExpandField({
    required this.label,
    required this.isRequired,
    required this.value,
    required this.hint,
    required this.isExpanded,
    required this.options,
    required this.isLoading,
    required this.errorText,
    required this.onToggle,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
              style: AppTextStyles.h5.copyWith(
                color: AppColors.neutralDarkDark,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(text: label),
                if (isRequired)
                  TextSpan(
                    text: '* ',
                    style: AppTextStyles.h5.copyWith(
                      color: AppColors.errorDark,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: errorText != null
                      ? AppColors.errorDark
                      : AppColors.neutralLightDark,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      value ?? hint,
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.bodyM.copyWith(
                        color: value != null
                            ? AppColors.neutralDarkDarkest
                            : AppColors.neutralDarkLightest,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.neutralDarkLightest,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: AppColors.neutralLightLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.neutralLightDark),
              ),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainBlueIndigoDye,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Column(
                      children: List.generate(options.length, (i) {
                        final item = options[i];
                        final isSelected = value == item.label;
                        final isLast = i == options.length - 1;
                        return InkWell(
                          onTap: () => onSelected(item),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.highlightLightest
                                  : Colors.transparent,
                              border: isLast
                                  ? null
                                  : const Border(
                                      bottom: BorderSide(
                                        color: AppColors.neutralLightDark,
                                      ),
                                    ),
                            ),
                            child: Text(
                              item.label,
                              textDirection: TextDirection.rtl,
                              style: AppTextStyles.bodyM.copyWith(
                                color: isSelected
                                    ? AppColors.mainBlueIndigoDye
                                    : AppColors.neutralDarkDarkest,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
            ),
          if (errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              errorText!,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.captionM.copyWith(
                color: AppColors.errorDark,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InlineExpandGenderField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final DropdownItem? selectedGender;
  final List<DropdownItem> options;
  final bool isLoading;
  final bool isExpanded;
  final String? errorText;
  final VoidCallback onToggle;
  final void Function(DropdownItem) onSelected;

  const _InlineExpandGenderField({
    required this.label,
    required this.isRequired,
    required this.selectedGender,
    required this.options,
    required this.isLoading,
    required this.isExpanded,
    required this.errorText,
    required this.onToggle,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = selectedGender?.label;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
              style: AppTextStyles.h5.copyWith(
                color: AppColors.neutralDarkDark,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(text: label),
                if (isRequired)
                  TextSpan(
                    text: '* ',
                    style: AppTextStyles.h5.copyWith(
                      color: AppColors.errorDark,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: errorText != null
                      ? AppColors.errorDark
                      : AppColors.neutralLightDark,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    displayValue ?? 'اختر النوع',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.bodyM.copyWith(
                      color: displayValue != null
                          ? AppColors.neutralDarkDarkest
                          : AppColors.neutralDarkLightest,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.neutralDarkLightest,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: AppColors.neutralLightLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.neutralLightDark),
              ),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainBlueIndigoDye,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Column(
                      children: List.generate(options.length, (i) {
                        final item = options[i];
                        final isSelected = selectedGender?.id == item.id;
                        final isLast = i == options.length - 1;
                        return InkWell(
                          onTap: () => onSelected(item),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.highlightLightest
                                  : Colors.transparent,
                              border: isLast
                                  ? null
                                  : const Border(
                                      bottom: BorderSide(
                                        color: AppColors.neutralLightDark,
                                      ),
                                    ),
                            ),
                            child: Text(
                              item.label,
                              textDirection: TextDirection.rtl,
                              style: AppTextStyles.bodyM.copyWith(
                                color: isSelected
                                    ? AppColors.mainBlueIndigoDye
                                    : AppColors.neutralDarkDarkest,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
            ),
          if (errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              errorText!,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.captionM.copyWith(
                color: AppColors.errorDark,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ImageUploadField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final bool hasImage;
  final String? errorText;
  final void Function(File) onPickImage;
  final VoidCallback onRemoveImage;

  const _ImageUploadField({
    required this.label,
    required this.isRequired,
    required this.hasImage,
    required this.errorText,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (picked != null) {
      onPickImage(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.neutralDarkDark,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(text: label),
                if (isRequired)
                  TextSpan(
                    text: '* ',
                    style: AppTextStyles.h5.copyWith(
                      color: AppColors.errorDark,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: errorText != null
                    ? AppColors.errorDark
                    : AppColors.neutralLightDark,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: hasImage ? onRemoveImage : _pickImageFromGallery,
                  icon: Icon(
                    hasImage
                        ? Icons.delete_outline_rounded
                        : Icons.upload_file_outlined,
                    size: 16,
                  ),
                  label: Text(
                    hasImage ? 'حذف الصورة' : 'رفع الصورة',
                    style: AppTextStyles.actionM,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasImage
                        ? AppColors.errorDark
                        : AppColors.mainBlueIndigoDye,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Icon(
                  hasImage ? Icons.image_rounded : Icons.image_outlined,
                  color: hasImage
                      ? AppColors.highlightDarkest
                      : AppColors.neutralDarkLightest,
                  size: 32,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ملف بصيغة Jpg أو pdf لا يتجاوز حجمه 5 ميجا بايت',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.captionM.copyWith(
              color: AppColors.neutralDarkLightest,
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 2),
            Text(
              errorText!,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.captionM.copyWith(
                color: AppColors.errorDark,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
