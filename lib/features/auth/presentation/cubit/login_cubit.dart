import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/login_response.dart';
import '../../../../core/network/api_result.dart';

enum LoginTab { mobile, nationalId }

class LoginState {
  final LoginTab selectedTab;

  final String phone;

  final String name;

  final String password;

  final bool isPasswordVisible;
  final bool isLoading;
  final bool isSuccess;

  final LoginResponse? loginResponse;

  final String? phoneError;
  final String? passwordError;
  final String? nationalIdError;
  final String? passportError;

  final String? credentialError;

  final String? localError;

  const LoginState({
    this.selectedTab = LoginTab.mobile,
    this.phone = '',
    this.password = '',
    this.name = '',
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.loginResponse,
    this.phoneError,
    this.passwordError,
    this.nationalIdError,
    this.passportError,
    this.credentialError,
    this.localError,
  });

  bool get isFormValid {
    final bool noPhoneErr = phoneError == null;
    final bool noPasswordErr = passwordError == null;
    final bool noNationalIdErr = nationalIdError == null;
    final bool noPassportErr = passportError == null;

    if (selectedTab == LoginTab.mobile) {
      return phone.isNotEmpty &&
          password.isNotEmpty &&
          noPhoneErr &&
          noPasswordErr;
    } else {
      return name.isNotEmpty &&
          password.isNotEmpty &&
          noNationalIdErr &&
          noPassportErr &&
          noPasswordErr;
    }
  }

  LoginState copyWith({
    LoginTab? selectedTab,
    String? phone,
    String? password,
    String? nationalId,
    String? passportNumber,
    bool? isPasswordVisible,
    bool? isLoading,
    bool? isSuccess,
    LoginResponse? loginResponse,
    String? Function()? phoneError,
    String? Function()? passwordError,
    String? Function()? nationalIdError,
    String? Function()? passportError,
    String? Function()? credentialError,
    String? Function()? localError,
  }) {
    return LoginState(
      selectedTab: selectedTab ?? this.selectedTab,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      name: nationalId ?? this.name,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      loginResponse: loginResponse ?? this.loginResponse,
      phoneError: phoneError != null ? phoneError() : this.phoneError,
      passwordError: passwordError != null
          ? passwordError()
          : this.passwordError,
      nationalIdError: nationalIdError != null
          ? nationalIdError()
          : this.nationalIdError,
      passportError: passportError != null
          ? passportError()
          : this.passportError,
      credentialError: credentialError != null
          ? credentialError()
          : this.credentialError,
      localError: localError != null ? localError() : this.localError,
    );
  }
}

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository(),
      super(const LoginState());

  void selectTab(LoginTab tab) {
    emit(
      state.copyWith(
        selectedTab: tab,
        phone: '',
        password: '',
        nationalId: '',
        passportNumber: '',
        phoneError: () => null,
        passwordError: () => null,
        nationalIdError: () => null,
        passportError: () => null,
        credentialError: () => null,
        localError: () => null,
        isSuccess: false,
      ),
    );
  }

  void onPhoneChanged(String value) => emit(
    state.copyWith(
      phone: value.trim(),
      phoneError: () => null,
      credentialError: () => null,
      localError: () => null,
    ),
  );

  void onPasswordChanged(String value) => emit(
    state.copyWith(
      password: value,
      passwordError: () => null,
      credentialError: () => null,
      localError: () => null,
    ),
  );

  void onNationalIdChanged(String value) => emit(
    state.copyWith(
      nationalId: value.trim(),
      nationalIdError: () => null,
      credentialError: () => null,
      localError: () => null,
    ),
  );

  void onPassportChanged(String value) => emit(
    state.copyWith(
      passportNumber: value.trim(),
      passportError: () => null,
      credentialError: () => null,
      localError: () => null,
    ),
  );

  void togglePasswordVisibility() =>
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));

  Future<void> login() async {
    if (!_validate()) return;

    emit(
      state.copyWith(
        isLoading: true,
        credentialError: () => null,
        localError: () => null,
      ),
    );

    final ApiResult<LoginResponse> result;

    if (state.selectedTab == LoginTab.mobile) {
      result = await _authRepository.loginWithMobile(
        mobile: state.phone,
        password: state.password,
      );
    } else {
      result = await _authRepository.loginWithNationalId(
        nationalId: state.name,
        password: state.password,
      );
    }

    switch (result) {
      case ApiSuccess(:final data):
        // if (!data.phoneVerified) {
        //   emit(
        //     state.copyWith(
        //       isLoading: false,
        //       credentialError: () =>
        //           'رقم الموبايل غير مفعل، يرجى التحقق من رقمك أولاً',
        //     ),
        //   );
        //   return;
        // }
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            loginResponse: data,
          ),
        );

      case ApiError(:final message, :final statusCode):
        _handleApiError(statusCode: statusCode, message: message);
    }
  }

  void _handleApiError({required int? statusCode, required String message}) {
    if (statusCode == 401 || statusCode == 422) {
      if (state.selectedTab == LoginTab.mobile) {
        emit(
          state.copyWith(
            isLoading: false,
            credentialError: () => 'رقم الموبايل أو كلمة المرور غير صحيحة',
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            credentialError: () => 'البيانات المدخلة غير صحيحة',
          ),
        );
      }
    } else {
      emit(state.copyWith(isLoading: false, credentialError: () => message));
    }
  }

  bool _validate() {
    return state.selectedTab == LoginTab.mobile
        ? _validateMobile()
        : _validateNationalId();
  }

  bool _validateMobile() {
    String? phoneError;
    String? passwordError;

    final phone = state.phone.trim();

    if (phone.isEmpty) {
      phoneError = 'هذا الحقل مطلوب';
    } else if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(phone)) {
      phoneError = 'رقم الموبايل غير صحيح';
    }

    if (state.password.isEmpty) {
      passwordError = 'هذا الحقل مطلوب';
    } else if (state.password.length < 6) {
      passwordError = 'كلمة المرور قصيرة جداً';
    }

    if (phoneError != null || passwordError != null) {
      final bannerMsg = [
        if (phoneError != null) phoneError,
        if (passwordError != null) passwordError,
      ].join(' • ');

      emit(
        state.copyWith(
          phoneError: () => phoneError,
          passwordError: () => passwordError,
          localError: () => bannerMsg,
        ),
      );
      return false;
    }
    return true;
  }

  bool _validateNationalId() {
    String? nationalIdError;
    String? passportError;
    String? passwordError;

    final nationalId = state.name.trim();

    // if (nationalId.isEmpty) {
    //   nationalIdError = 'هذا الحقل مطلوب';
    // } else if (!RegExp(r'^\d{14}$').hasMatch(nationalId) &&
    //     !RegExp(r'^[A-Za-z0-9]{6,20}$').hasMatch(nationalId)) {
    //   nationalIdError = 'الرقم القومي أو جواز السفر غير صحيح';
    // }

    if (nationalId.isEmpty) {
      nationalIdError = 'هذا الحقل مطلوب';
    }

    if (state.password.isEmpty) {
      passwordError = 'هذا الحقل مطلوب';
    } else if (state.password.length < 6) {
      passwordError = 'كلمة المرور قصيرة جداً';
    }

    if (nationalIdError != null || passwordError != null) {
      final bannerMsg = [
        if (nationalIdError != null) nationalIdError,
        if (passwordError != null) passwordError,
      ].join(' • ');

      emit(
        state.copyWith(
          nationalIdError: () => nationalIdError,
          passportError: () => passportError,
          passwordError: () => passwordError,
          localError: () => bannerMsg,
        ),
      );
      return false;
    }
    return true;
  }
}
