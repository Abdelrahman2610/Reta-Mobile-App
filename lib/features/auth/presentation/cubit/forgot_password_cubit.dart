import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/network/api_result.dart';

enum ForgotTab { mobile, email }

enum ForgotStep { input, otp, otpSuccess, newPassword, done, emailSent }

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
  final String? _userId;
  final String? _otpToken;
  final String? _resetToken;

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
    String? userId,
    String? otpToken,
    String? resetToken,
  }) : _userId = userId,
       _otpToken = otpToken,
       _resetToken = resetToken;

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
    String? Function()? userId,
    String? Function()? otpToken,
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
      userId: userId != null ? userId() : _userId,
      otpToken: otpToken != null ? otpToken() : _otpToken,
      resetToken: resetToken != null ? resetToken() : _resetToken,
    );
  }
}

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository(),
      super(const ForgotPasswordState());

  Timer? _resendTimer;

  void selectTab(ForgotTab tab) => emit(
    state.copyWith(
      selectedTab: tab,
      mobile: '',
      email: '',
      mobileError: () => null,
      emailError: () => null,
      requestError: () => null,
    ),
  );

  void onMobileChanged(String v) => emit(
    state.copyWith(
      mobile: v,
      mobileError: () => null,
      requestError: () => null,
    ),
  );

  void onEmailChanged(String v) => emit(
    state.copyWith(email: v, emailError: () => null, requestError: () => null),
  );

  Future<void> requestReset() async {
    if (!_validateStep1()) return;
    log(
      '[Cubit] requestReset → tab: ${state.selectedTab}, mobile: "${state.mobile}", email: "${state.email}"',
    );
    emit(state.copyWith(isLoading: true, requestError: () => null));

    if (state.selectedTab == ForgotTab.mobile) {
      await _requestByPhone();
    } else {
      await _requestByEmail();
    }
  }

  Future<void> _requestByPhone() async {
    log('[Cubit] _requestByPhone → mobile: "${state.mobile.trim()}"');

    final result = await _authRepository.forgotPasswordByPhone(
      mobile: state.mobile.trim(),
    );

    switch (result) {
      case ApiSuccess(:final data):
        log('[Cubit] _requestByPhone success');
        log('   data: $data');
        log('   ok: ${data['ok']}');
        log('   user_id: ${data['user_id']}');
        log('   request_code: ${data['request_code']}');
        log('   wait_seconds: ${data['wait_seconds']}');

        if (data == null || data is! Map<String, dynamic>) {
          emit(
            state.copyWith(
              isLoading: false,
              requestError: () => 'حدث خطأ غير متوقع، حاول مرة أخرى',
            ),
          );
          return;
        }

        final ok = data['ok'];
        if (ok == false) {
          final errorMap = data['error'];
          String message = data['message']?.toString() ?? 'حدث خطأ غير متوقع';
          if (errorMap is Map)
            message = errorMap['message']?.toString() ?? message;
          log('[Cubit] _requestByPhone ok=false → $message');
          emit(state.copyWith(isLoading: false, requestError: () => message));
          return;
        }

        emit(
          state.copyWith(
            isLoading: false,
            step: ForgotStep.otp,
            otpValue: '',
            otpError: () => null,
            userId: () => data['user_id']?.toString(),
            otpToken: () => data['request_code']?.toString(),
            resendCooldown: data['wait_seconds'] as int? ?? 60,
          ),
        );
        log(
          '[Cubit] Moved to OTP step. userId=${state._userId}, otpToken=${state._otpToken}',
        );
        _startResendCooldown(data['wait_seconds'] as int? ?? 60);

      case ApiError(:final message):
        log('[Cubit] _requestByPhone error → $message');
        emit(state.copyWith(isLoading: false, requestError: () => message));
    }
  }

  Future<void> _requestByEmail() async {
    log('[Cubit] _requestByEmail → email: "${state.email.trim()}"');

    final result = await _authRepository.forgotPasswordByEmail(
      email: state.email.trim(),
    );

    switch (result) {
      case ApiSuccess(:final data):
        log('[Cubit] _requestByEmail success → data: $data');

        if (data == null || data is! Map<String, dynamic>) {
          emit(
            state.copyWith(
              isLoading: false,
              requestError: () => 'حدث خطأ غير متوقع، حاول مرة أخرى',
            ),
          );
          return;
        }

        final ok = data['ok'];
        if (ok == false) {
          final errorMap = data['error'];
          String message = data['message']?.toString() ?? 'حدث خطأ غير متوقع';
          if (errorMap is Map)
            message = errorMap['message']?.toString() ?? message;
          log('[Cubit] _requestByEmail ok=false → $message');
          emit(state.copyWith(isLoading: false, requestError: () => message));
          return;
        }

        emit(state.copyWith(isLoading: false, step: ForgotStep.emailSent));

      case ApiError(:final message):
        log('[Cubit] _requestByEmail error → $message');
        emit(state.copyWith(isLoading: false, requestError: () => message));
    }
  }

  void onOtpChanged(String v) =>
      emit(state.copyWith(otpValue: v, otpError: () => null));

  Future<void> confirmOtp() async {
    log('[Cubit] confirmOtp →');
    log('   otpValue: "${state.otpValue}"');
    log('   _userId: "${state._userId}"');
    log('   _otpToken: "${state._otpToken}"');
    log('   mobile: "${state.mobile}"');

    if (state.otpValue.length < 6) {
      emit(state.copyWith(otpError: () => 'أدخل رمز التحقق كاملاً'));
      return;
    }
    if (state._otpToken == null) {
      log('[Cubit] confirmOtp → missing otpToken!');
      emit(state.copyWith(otpError: () => 'بيانات غير مكتملة، أعد المحاولة'));
      return;
    }

    emit(state.copyWith(isLoading: true, otpError: () => null));

    final result = await _authRepository.confirmForgotPasswordOtp(
      userId: state._userId ?? '',
      mobile: state.mobile.trim(),
      token: state._otpToken!,
      otp: state.otpValue,
    );

    switch (result) {
      case ApiSuccess():
        log('[Cubit] confirmOtp success → proceeding to generateResetToken');
        await _generateResetToken();

      case ApiError(:final message):
        log('[Cubit] confirmOtp error → $message');
        emit(state.copyWith(isLoading: false, otpError: () => message));
    }
  }

  Future<void> _generateResetToken() async {
    log('[Cubit] _generateResetToken → mobile: "${state.mobile.trim()}"');

    final result = await _authRepository.generateResetToken(
      mobile: state.mobile.trim(),
    );

    switch (result) {
      case ApiSuccess(:final data):
        log('[Cubit] _generateResetToken success');
        log('   ALL keys: ${data.keys.toList()}');
        log('   reset_token: ${data['reset_token']}');

        if (data == null || data is! Map<String, dynamic>) {
          emit(
            state.copyWith(
              isLoading: false,
              otpError: () => 'حدث خطأ غير متوقع، حاول مرة أخرى',
            ),
          );
          return;
        }

        final resetToken = data['reset_token']?.toString();
        if (resetToken == null || resetToken.isEmpty) {
          log('[Cubit] _generateResetToken → reset_token is null or empty!');
          emit(
            state.copyWith(
              isLoading: false,
              otpError: () => 'حدث خطأ غير متوقع، حاول مرة أخرى',
            ),
          );
          return;
        }

        log('   → resolved resetToken: "$resetToken"');

        await _checkResetPasswordValidity(resetToken);

      case ApiError(:final message):
        log('[Cubit] _generateResetToken error → $message');
        emit(state.copyWith(isLoading: false, otpError: () => message));
    }
  }

  Future<void> _checkResetPasswordValidity(String resetToken) async {
    log(
      '[Cubit] _checkResetPasswordValidity → mobile: "${state.mobile.trim()}", token: "$resetToken"',
    );

    final result = await _authRepository.checkResetPasswordValidity(
      token: resetToken,
      mobile: state.mobile.trim(),
    );

    switch (result) {
      case ApiSuccess(:final data):
        log('[Cubit] _checkResetPasswordValidity success → data: $data');
        emit(
          state.copyWith(
            isLoading: false,
            step: ForgotStep.otpSuccess,
            resetToken: () => resetToken,
          ),
        );
        log('[Cubit] _resetToken saved, moved to otpSuccess');

      case ApiError(:final message):
        log('[Cubit] _checkResetPasswordValidity error → $message');
        emit(state.copyWith(isLoading: false, otpError: () => message));
    }
  }

  void proceedToNewPassword() async {
    log('[Cubit] proceedToNewPassword → _resetToken: "${state._resetToken}"');

    emit(state.copyWith(isLoading: true));

    final result = await _authRepository.checkResetPasswordValidity(
      token: state._resetToken!,
      mobile: state.mobile.trim(),
    );

    switch (result) {
      case ApiSuccess():
        log('[Cubit] proceedToNewPassword validity check passed');
        emit(state.copyWith(isLoading: false, step: ForgotStep.newPassword));

      case ApiError(:final message):
        log('[Cubit] proceedToNewPassword validity check failed → $message');
        emit(state.copyWith(isLoading: false, resetError: () => message));
    }
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

  void toggleNewPasswordVisibility() =>
      emit(state.copyWith(isNewPasswordVisible: !state.isNewPasswordVisible));

  void toggleConfirmPasswordVisibility() => emit(
    state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
  );

  bool get isNewPasswordValid =>
      state.newPassword.isNotEmpty &&
      state.confirmPassword.isNotEmpty &&
      state.newPassword == state.confirmPassword &&
      state.newPassword.length >= 8 &&
      state.newPassword.length <= 10 &&
      !state.newPassword.contains(' ') &&
      _validatePassword(state.newPassword) == null;

  Future<void> submitNewPassword() async {
    log('[Cubit] submitNewPassword →');
    log('   _resetToken: "${state._resetToken}"');
    log('   mobile: "${state.mobile}"');
    log('   newPassword length: ${state.newPassword.length}');
    log('   passwords match: ${state.newPassword == state.confirmPassword}');

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
    if (state._resetToken == null || state._resetToken!.isEmpty) {
      log('[Cubit] submitNewPassword → _resetToken is null or empty!');
      emit(
        state.copyWith(
          resetError: () =>
              'رمز إعادة التعيين غير صالح، أعد المحاولة من البداية',
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, resetError: () => null));

    log('[Cubit] Calling resetPassword with mobile: "${state.mobile.trim()}"');

    final result = await _authRepository.resetPassword(
      token: state._resetToken!,
      password: state.newPassword,
      passwordConfirmation: state.confirmPassword,
      mobile: state.mobile.trim(),
    );

    switch (result) {
      case ApiSuccess():
        log('[Cubit] submitNewPassword success → moving to done');
        emit(state.copyWith(isLoading: false, step: ForgotStep.done));

      case ApiError(:final message):
        log('[Cubit] submitNewPassword error → $message');
        emit(state.copyWith(isLoading: false, resetError: () => message));
    }
  }

  Future<void> resendOtp() async {
    if (state.resendCooldown > 0) return;
    log('[Cubit] resendOtp');
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

  String? _validatePassword(String v) {
    if (v.isEmpty) return null;
    if (v.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
    if (v.length > 10) return 'يجب ألا تتجاوز 10 أحرف';
    if (!v.contains(RegExp(r'[A-Z]'))) return 'يجب أن تحتوي على حرف كبير';
    if (!v.contains(RegExp(r'[0-9]'))) return 'يجب أن تحتوي على رقم';
    if (v.contains(' ')) return 'لا يُسمح باستخدام المسافات';
    return null;
  }

  void _startResendCooldown([int seconds = 60]) {
    emit(state.copyWith(resendCooldown: seconds));
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
