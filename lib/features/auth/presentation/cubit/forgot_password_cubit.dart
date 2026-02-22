import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/network/api_result.dart';
// import '/features/auth/data/repositories/auth_repository.dart';

// ─────────────────────────────────────────
// ENUMS
// ─────────────────────────────────────────

enum ForgotTab { mobile, email }

enum ForgotStep {
  /// Step 1 — choose method & enter identifier
  input,

  /// Step 2 — enter the 6-digit OTP
  otp,

  /// Step 3 — OTP verified, show "login" success screen
  otpSuccess,

  /// Step 4 — set new password
  newPassword,

  /// Step 5 — all done
  done,
}

// ─────────────────────────────────────────
// STATE
// ─────────────────────────────────────────

class ForgotPasswordState {
  final ForgotTab selectedTab;
  final ForgotStep step;

  // Step 1 fields
  final String mobile;
  final String email;
  final String? mobileError;
  final String? emailError;
  final bool isLoading;
  final String? requestError;

  // Step 2 — OTP
  final String otpValue;
  final String? otpError;

  // Step 4 — new password
  final String newPassword;
  final String confirmPassword;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;
  final String? newPasswordError;
  final String? confirmPasswordError;
  final String? resetError;

  // Internal token returned by the API after step-1 request
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

// ─────────────────────────────────────────
// CUBIT
// ─────────────────────────────────────────

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  // ── Tab ─────────────────────────────────

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

  // ── Step 1 field changes ─────────────────

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

  // ── Step 1 submit — request OTP ──────────

  Future<void> requestReset() async {
    if (!_validateStep1()) return;

    emit(state.copyWith(isLoading: true, requestError: () => null));

    // TODO: wire to real API endpoint. Replace this placeholder with:
    // final result = await _authRepository.forgotPassword(
    //   type: state.selectedTab == ForgotTab.mobile ? 'mobile' : 'email',
    //   value: state.selectedTab == ForgotTab.mobile ? state.mobile : state.email,
    // );
    //
    // switch (result) {
    //   case ApiSuccess(:final data):
    //     emit(state.copyWith(
    //       isLoading: false,
    //       resetToken: () => data['token']?.toString(),
    //       step: ForgotStep.otp,
    //     ));
    //   case ApiError(:final message):
    //     emit(state.copyWith(isLoading: false, requestError: () => message));
    // }

    // ── Simulated success (remove when API is ready) ──
    await Future.delayed(const Duration(milliseconds: 800));
    emit(state.copyWith(isLoading: false, step: ForgotStep.otp));
  }

  bool _validateStep1() {
    if (state.selectedTab == ForgotTab.mobile) {
      if (state.mobile.isEmpty) {
        emit(state.copyWith(mobileError: () => 'رقم الموبايل مطلوب'));
        return false;
      }
      if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(state.mobile)) {
        emit(state.copyWith(mobileError: () => 'رقم الموبايل غير صحيح'));
        return false;
      }
    } else {
      if (state.email.isEmpty) {
        emit(state.copyWith(emailError: () => 'البريد الإلكتروني مطلوب'));
        return false;
      }
      if (!RegExp(r'^[\w\-.]+@[\w\-]+\.[a-zA-Z]{2,}$').hasMatch(state.email)) {
        emit(state.copyWith(emailError: () => 'البريد الإلكتروني غير صحيح'));
        return false;
      }
    }
    return true;
  }

  // ── Step 2 OTP ───────────────────────────

  void onOtpChanged(String v) {
    emit(state.copyWith(otpValue: v, otpError: () => null));
  }

  Future<void> confirmOtp() async {
    if (state.otpValue.length < 6) {
      emit(state.copyWith(otpError: () => 'أدخل رمز التحقق كاملاً'));
      return;
    }

    emit(state.copyWith(isLoading: true, otpError: () => null));

    // TODO: wire to real API endpoint. Replace this placeholder with:
    // final result = await _authRepository.verifyOtp(
    //   token: state.resetToken!,
    //   otp: state.otpValue,
    // );
    //
    // switch (result) {
    //   case ApiSuccess():
    //     emit(state.copyWith(isLoading: false, step: ForgotStep.otpSuccess));
    //   case ApiError(:final message):
    //     emit(state.copyWith(isLoading: false, otpError: () => message));
    // }

    // ── Simulated success ──
    await Future.delayed(const Duration(milliseconds: 800));
    emit(state.copyWith(isLoading: false, step: ForgotStep.otpSuccess));
  }

  void resendOtp() async {
    emit(state.copyWith(otpValue: '', otpError: () => null));
    await requestReset();
  }

  // ── Navigation helpers (called from UI) ──

  /// Go back from OTP step to the input step.
  void goBackToInput() {
    emit(state.copyWith(step: ForgotStep.input));
  }

  // ── From otpSuccess → newPassword ────────

  void proceedToNewPassword() {
    emit(state.copyWith(step: ForgotStep.newPassword));
  }

  // ── Step 4 new password ──────────────────

  void onNewPasswordChanged(String v) {
    emit(
      state.copyWith(
        newPassword: v,
        newPasswordError: () => _validatePassword(v),
        confirmPasswordError: () => state.confirmPassword.isEmpty
            ? null
            : state.confirmPassword != v
            ? 'كلمتا المرور غير متطابقتين'
            : null,
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

  bool get isNewPasswordValid {
    return state.newPassword.isNotEmpty &&
        state.confirmPassword.isNotEmpty &&
        state.newPassword == state.confirmPassword &&
        _validatePassword(state.newPassword) == null;
  }

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

    // TODO: wire to real API endpoint. Replace this placeholder with:
    // final result = await _authRepository.resetPassword(
    //   token: state.resetToken!,
    //   password: state.newPassword,
    //   passwordConfirm: state.confirmPassword,
    // );
    //
    // switch (result) {
    //   case ApiSuccess():
    //     emit(state.copyWith(isLoading: false, step: ForgotStep.done));
    //   case ApiError(:final message):
    //     emit(state.copyWith(isLoading: false, resetError: () => message));
    // }

    // ── Simulated success ──
    await Future.delayed(const Duration(milliseconds: 800));
    emit(state.copyWith(isLoading: false, step: ForgotStep.done));
  }
}
