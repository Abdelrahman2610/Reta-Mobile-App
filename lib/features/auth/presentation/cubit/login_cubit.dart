import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/network/api_result.dart';

enum LoginTab { mobile, nationalId }

class LoginState {
  final LoginTab selectedTab;
  final String phone;
  final String password;
  final String nationalId;
  final String passportNumber;
  final bool isPasswordVisible;
  final bool isLoading;
  final bool isSuccess;
  final String? phoneError;
  final String? passwordError;
  final String? nationalIdError;
  final String? passportError;
  final String? generalError;

  final String? credentialError;

  final String? localError;

  const LoginState({
    this.selectedTab = LoginTab.mobile,
    this.phone = '',
    this.password = '',
    this.nationalId = '',
    this.passportNumber = '',
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.phoneError,
    this.passwordError,
    this.nationalIdError,
    this.passportError,
    this.generalError,
    this.credentialError,
    this.localError,
  });

  bool get isFormValid {
    final noPhoneError = phoneError == null || phoneError!.isEmpty;
    final noPasswordError = passwordError == null || passwordError!.isEmpty;
    final noNationalIdError =
        nationalIdError == null || nationalIdError!.isEmpty;
    final noPassportError = passportError == null || passportError!.isEmpty;

    if (selectedTab == LoginTab.mobile) {
      return phone.isNotEmpty &&
          password.isNotEmpty &&
          noPhoneError &&
          noPasswordError;
    } else {
      return nationalId.isNotEmpty &&
          passportNumber.isNotEmpty &&
          password.isNotEmpty &&
          noNationalIdError &&
          noPassportError &&
          noPasswordError;
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
    String? Function()? phoneError,
    String? Function()? passwordError,
    String? Function()? nationalIdError,
    String? Function()? passportError,
    String? Function()? generalError,
    String? Function()? credentialError,
    String? Function()? localError,
  }) {
    return LoginState(
      selectedTab: selectedTab ?? this.selectedTab,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      nationalId: nationalId ?? this.nationalId,
      passportNumber: passportNumber ?? this.passportNumber,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
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
      generalError: generalError != null ? generalError() : this.generalError,
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
        password: '',
        phone: '',
        nationalId: '',
        passportNumber: '',
        phoneError: () => null,
        passwordError: () => null,
        nationalIdError: () => null,
        passportError: () => null,
        generalError: () => null,
        credentialError: () => null,
        localError: () => null,
      ),
    );
  }

  void onPhoneChanged(String value) => emit(
    state.copyWith(
      phone: value,
      phoneError: () => null,
      credentialError: () => null,
      localError: () => null,
      generalError: () => null,
    ),
  );

  void onPasswordChanged(String value) => emit(
    state.copyWith(
      password: value,
      passwordError: () => null,
      credentialError: () => null,
      localError: () => null,
      generalError: () => null,
    ),
  );

  void onNationalIdChanged(String value) => emit(
    state.copyWith(
      nationalId: value,
      nationalIdError: () => null,
      credentialError: () => null,
      localError: () => null,
      generalError: () => null,
    ),
  );

  void onPassportChanged(String value) => emit(
    state.copyWith(
      passportNumber: value,
      passportError: () => null,
      credentialError: () => null,
      localError: () => null,
      generalError: () => null,
    ),
  );

  void togglePasswordVisibility() =>
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));

  Future<void> login() async {
    if (!_validate()) return;

    emit(
      state.copyWith(
        isLoading: true,
        generalError: () => null,
        credentialError: () => null,
      ),
    );

    final String loginType;
    final String loginValue;

    if (state.selectedTab == LoginTab.mobile) {
      loginType = 'mobile';
      loginValue = state.phone;
    } else {
      if (state.nationalId.isNotEmpty) {
        loginType = 'national_id';
        loginValue = state.nationalId;
      } else {
        loginType = 'passport';
        loginValue = state.passportNumber;
      }
    }

    final result = await _authRepository.login(
      loginValue: loginValue,
      password: state.password,
      loginType: loginType,
    );

    switch (result) {
      case ApiSuccess():
        emit(state.copyWith(isLoading: false, isSuccess: true));

      case ApiError(:final message, :final statusCode):
        if (statusCode == 401 || statusCode == 422) {
          if (state.selectedTab == LoginTab.mobile) {
            emit(
              state.copyWith(
                isLoading: false,
                phoneError: () => '',
                passwordError: () => '',
                credentialError: () => 'رقم الموبايل أو كلمة المرور غير صحيحة',
              ),
            );
          } else {
            emit(
              state.copyWith(
                isLoading: false,
                nationalIdError: () => '',
                passportError: () => '',
                passwordError: () => '',
                credentialError: () => 'البيانات المدخلة غير صحيحة',
              ),
            );
          }
        } else {
          emit(
            state.copyWith(isLoading: false, credentialError: () => message),
          );
        }
    }
  }

  bool _validate() {
    if (state.selectedTab == LoginTab.mobile) {
      return _validateMobile();
    } else {
      return _validateNationalId();
    }
  }

  bool _validateMobile() {
    String? phoneError;
    String? passwordError;

    if (state.phone.isEmpty) {
      phoneError = 'هذا الحقل مطلوب';
    } else if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(state.phone)) {
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
          phoneError: () => phoneError ?? '',
          passwordError: () => passwordError ?? '',
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

    if (state.nationalId.isEmpty) {
      nationalIdError = 'هذا الحقل مطلوب';
    } else if (!RegExp(r'^\d{14}$').hasMatch(state.nationalId)) {
      nationalIdError = 'الرقم القومي يجب أن يكون 14 رقماً';
    }

    if (state.passportNumber.isEmpty) {
      passportError = 'هذا الحقل مطلوب';
    } else if (state.passportNumber.length < 6 ||
        !RegExp(r'^[A-Za-z0-9]+$').hasMatch(state.passportNumber)) {
      passportError = 'رقم جواز السفر غير صحيح';
    }

    if (state.password.isEmpty) {
      passwordError = 'هذا الحقل مطلوب';
    } else if (state.password.length < 6) {
      passwordError = 'كلمة المرور قصيرة جداً';
    }

    if (nationalIdError != null ||
        passportError != null ||
        passwordError != null) {
      final bannerMsg = [
        if (nationalIdError != null) nationalIdError,
        if (passportError != null) passportError,
        if (passwordError != null) passwordError,
      ].join(' • ');
      emit(
        state.copyWith(
          nationalIdError: () => nationalIdError ?? '',
          passportError: () => passportError ?? '',
          passwordError: () => passwordError ?? '',
          localError: () => bannerMsg,
        ),
      );
      return false;
    }
    return true;
  }
}
