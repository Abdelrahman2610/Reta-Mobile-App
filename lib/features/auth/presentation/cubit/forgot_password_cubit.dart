import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ForgotTab { mobile, email }

enum ForgotStep { input, otp, otpSuccess, newPassword, done }

class ForgotPasswordState {
  final ForgotTab selectedTab;
  final ForgotStep step;

  final String mobile;
  final String email;
  final String? mobileError;
  final String? emailError;
  final bool isLoading;
  final String? requestError;

  final String otpValue;
  final String? otpError;

  final int resendCooldown;

  final String newPassword;
  final String confirmPassword;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;
  final String? newPasswordError;
  final String? confirmPasswordError;
  final String? resetError;

  final String? resetToken;

  const ForgotPasswordState({
    this.selectedTab = ForgotTab.mobile,
    this.step = ForgotStep.input,
    this.mobile = '',
    this.email = '',
    this.mobileError,
    this.emailError,
    this.isLoading = false,
    this.requestError,
    this.otpValue = '',
    this.otpError,
    this.resendCooldown = 0,
    this.newPassword = '',
    this.confirmPassword = '',
    this.isNewPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.newPasswordError,
    this.confirmPasswordError,
    this.resetError,
    this.resetToken,
  });

  ForgotPasswordState copyWith({
    ForgotTab? selectedTab,
    ForgotStep? step,
    String? mobile,
    String? email,
    String? Function()? mobileError,
    String? Function()? emailError,
    bool? isLoading,
    String? Function()? requestError,
    String? otpValue,
    String? Function()? otpError,
    int? resendCooldown,
    String? newPassword,
    String? confirmPassword,
    bool? isNewPasswordVisible,
    bool? isConfirmPasswordVisible,
    String? Function()? newPasswordError,
    String? Function()? confirmPasswordError,
    String? Function()? resetError,
    String? Function()? resetToken,
  }) {
    return ForgotPasswordState(
      selectedTab: selectedTab ?? this.selectedTab,
      step: step ?? this.step,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      mobileError: mobileError != null ? mobileError() : this.mobileError,
      emailError: emailError != null ? emailError() : this.emailError,
      isLoading: isLoading ?? this.isLoading,
      requestError: requestError != null ? requestError() : this.requestError,
      otpValue: otpValue ?? this.otpValue,
      otpError: otpError != null ? otpError() : this.otpError,
      resendCooldown: resendCooldown ?? this.resendCooldown,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isNewPasswordVisible: isNewPasswordVisible ?? this.isNewPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      newPasswordError: newPasswordError != null
          ? newPasswordError()
          : this.newPasswordError,
      confirmPasswordError: confirmPasswordError != null
          ? confirmPasswordError()
          : this.confirmPasswordError,
      resetError: resetError != null ? resetError() : this.resetError,
      resetToken: resetToken != null ? resetToken() : this.resetToken,
    );
  }
}

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  Timer? _resendTimer;

  void selectTab(ForgotTab tab) {
    emit(
      state.copyWith(
        selectedTab: tab,
        mobile: '',
        email: '',
        mobileError: () => null,
        emailError: () => null,
        requestError: () => null,
      ),
    );
  }

  void onMobileChanged(String v) {
    emit(
      state.copyWith(
        mobile: v,
        mobileError: () => null,
        requestError: () => null,
      ),
    );
  }

  void onEmailChanged(String v) {
    emit(
      state.copyWith(
        email: v,
        emailError: () => null,
        requestError: () => null,
      ),
    );
  }

  Future<void> requestReset() async {
    if (!_validateStep1()) return;

    emit(state.copyWith(isLoading: true, requestError: () => null));

    try {
      // TODO: Replace with real API call
      await Future.delayed(const Duration(milliseconds: 800));

      emit(
        state.copyWith(
          isLoading: false,
          step: ForgotStep.otp,
          otpValue: '',
          otpError: () => null,
        ),
      );

      _startResendCooldown();
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          requestError: () => 'حدث خطأ، يرجى المحاولة مرة أخرى',
        ),
      );
    }
  }

  bool _validateStep1() {
    if (state.selectedTab == ForgotTab.mobile) {
      if (state.mobile.trim().isEmpty) {
        emit(state.copyWith(mobileError: () => 'رقم الموبايل مطلوب'));
        return false;
      }
      if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(state.mobile.trim())) {
        emit(state.copyWith(mobileError: () => 'رقم الموبايل غير صحيح'));
        return false;
      }
    } else {
      if (state.email.trim().isEmpty) {
        emit(state.copyWith(emailError: () => 'البريد الإلكتروني مطلوب'));
        return false;
      }
      if (!RegExp(
        r'^[\w\-.]+@[\w\-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(state.email.trim())) {
        emit(state.copyWith(emailError: () => 'البريد الإلكتروني غير صحيح'));
        return false;
      }
    }
    return true;
  }

  void onOtpChanged(String v) {
    emit(state.copyWith(otpValue: v, otpError: () => null));
  }

  Future<void> confirmOtp() async {
    if (state.otpValue.length < 6) {
      emit(state.copyWith(otpError: () => 'أدخل رمز التحقق كاملاً'));
      return;
    }

    emit(state.copyWith(isLoading: true, otpError: () => null));

    try {
      // TODO: Replace with real API call
      await Future.delayed(const Duration(milliseconds: 800));

      emit(state.copyWith(isLoading: false, step: ForgotStep.otpSuccess));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          otpError: () => 'رمز التحقق غير صحيح، يرجى المحاولة مرة أخرى',
        ),
      );
    }
  }

  Future<void> resendOtp() async {
    if (state.resendCooldown > 0) return;
    emit(state.copyWith(otpValue: '', otpError: () => null));
    await requestReset();
  }

  void goBackToInput() {
    _resendTimer?.cancel();
    emit(
      state.copyWith(
        step: ForgotStep.input,
        otpValue: '',
        otpError: () => null,
        resendCooldown: 0,
      ),
    );
  }

  void proceedToNewPassword() {
    emit(state.copyWith(step: ForgotStep.newPassword));
  }

  void onNewPasswordChanged(String v) {
    emit(
      state.copyWith(
        newPassword: v,
        newPasswordError: () => _validatePassword(v),
        confirmPasswordError: () {
          if (state.confirmPassword.isEmpty) return null;
          return state.confirmPassword != v
              ? 'كلمتا المرور غير متطابقتين'
              : null;
        },
        resetError: () => null,
      ),
    );
  }

  void onConfirmPasswordChanged(String v) {
    emit(
      state.copyWith(
        confirmPassword: v,
        confirmPasswordError: () =>
            v != state.newPassword ? 'كلمتا المرور غير متطابقتين' : null,
        resetError: () => null,
      ),
    );
  }

  void toggleNewPasswordVisibility() {
    emit(state.copyWith(isNewPasswordVisible: !state.isNewPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }

  String? _validatePassword(String v) {
    if (v.isEmpty) return null;
    if (v.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
    if (!v.contains(RegExp(r'[A-Z]'))) return 'يجب أن تحتوي على حرف كبير';
    if (!v.contains(RegExp(r'[0-9]'))) return 'يجب أن تحتوي على رقم';
    if (!v.contains(RegExp(r'[!@#\$%^&*]'))) return 'يجب أن تحتوي على رمز خاص';
    return null;
  }

  bool get isNewPasswordValid =>
      state.newPassword.isNotEmpty &&
      state.confirmPassword.isNotEmpty &&
      state.newPassword == state.confirmPassword &&
      _validatePassword(state.newPassword) == null;

  Future<void> submitNewPassword() async {
    final pwErr = _validatePassword(state.newPassword);
    if (pwErr != null) {
      emit(state.copyWith(newPasswordError: () => pwErr));
      return;
    }
    if (state.newPassword != state.confirmPassword) {
      emit(
        state.copyWith(
          confirmPasswordError: () => 'كلمتا المرور غير متطابقتين',
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, resetError: () => null));

    try {
      // TODO: Replace with real API call
      await Future.delayed(const Duration(milliseconds: 800));

      emit(state.copyWith(isLoading: false, step: ForgotStep.done));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          resetError: () =>
              'حدث خطأ أثناء تحديث كلمة المرور، يرجى المحاولة مرة أخرى',
        ),
      );
    }
  }

  void _startResendCooldown() {
    const cooldownSeconds = 60;
    emit(state.copyWith(resendCooldown: cooldownSeconds));

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      final remaining = state.resendCooldown - 1;
      if (remaining <= 0) {
        timer.cancel();
        emit(state.copyWith(resendCooldown: 0));
      } else {
        emit(state.copyWith(resendCooldown: remaining));
      }
    });
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }
}
