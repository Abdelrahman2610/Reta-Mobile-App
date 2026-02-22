import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '/features/declarations/data/repositories/lookups_repository.dart';
import '../../data/models/register_request.dart';
import '../../../../core/network/api_result.dart';

class DropdownItem {
  final String id;
  final String label;
  const DropdownItem({required this.id, required this.label});
}

enum NationalityType { egyptian, foreign }

enum GenderType { male, female }

class SignupState {
  final NationalityType nationalityType;
  final String firstName;
  final String restOfName;
  final String email;
  final String phone;
  final List<DropdownItem> nationalityOptions;
  final DropdownItem? selectedNationality;
  final bool isNationalityLoading;
  final bool isNationalityExpanded;
  final GenderType? selectedGender;
  final bool isGenderExpanded;
  final String nationalId;
  final bool hasNationalIdImage;
  final DateTime? birthDate;
  final DropdownItem? selectedBirthPlace;
  final bool isBirthPlaceExpanded;
  final bool showManualBirthPlace;
  final String manualBirthPlace;
  final List<DropdownItem> residenceOptions;
  final DropdownItem? selectedResidence;
  final bool isResidenceLoading;
  final bool isResidenceExpanded;
  final String passportNumber;
  final DateTime? passportExpiry;
  final DropdownItem? selectedPassportIssuePlace;
  final List<DropdownItem> passportIssuePlaceOptions;
  final bool isPassportIssuePlaceLoading;
  final bool isPassportIssuePlaceExpanded;
  final String password;
  final String confirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool agreedToTerms;
  final bool isLoading;
  final bool isSubmitSuccess;
  final String? submitError;
  final String? firstNameError;
  final String? restOfNameError;
  final String? emailError;
  final String? phoneError;
  final String? nationalityError;
  final String? genderError;
  final String? nationalIdError;
  final String? nationalIdImageError;
  final String? birthDateError;
  final String? birthPlaceError;
  final String? manualBirthPlaceError;
  final String? residenceError;
  final String? passportNumberError;
  final String? passportExpiryError;
  final String? passportIssuePlaceError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? termsError;
  final File? nationalIdFile;

  const SignupState({
    this.nationalityType = NationalityType.egyptian,
    this.firstName = '',
    this.restOfName = '',
    this.email = '',
    this.phone = '',
    this.nationalityOptions = const [],
    this.selectedNationality,
    this.isNationalityLoading = false,
    this.isNationalityExpanded = false,
    this.selectedGender,
    this.isGenderExpanded = false,
    this.nationalId = '',
    this.hasNationalIdImage = false,
    this.birthDate,
    this.selectedBirthPlace,
    this.isBirthPlaceExpanded = false,
    this.showManualBirthPlace = false,
    this.manualBirthPlace = '',
    this.residenceOptions = const [],
    this.selectedResidence,
    this.isResidenceLoading = false,
    this.isResidenceExpanded = false,
    this.passportNumber = '',
    this.passportExpiry,
    this.selectedPassportIssuePlace,
    this.passportIssuePlaceOptions = const [],
    this.isPassportIssuePlaceLoading = false,
    this.isPassportIssuePlaceExpanded = false,
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.agreedToTerms = false,
    this.isLoading = false,
    this.isSubmitSuccess = false,
    this.submitError,
    this.nationalIdFile,
    this.firstNameError,
    this.restOfNameError,
    this.emailError,
    this.phoneError,
    this.nationalityError,
    this.genderError,
    this.nationalIdError,
    this.nationalIdImageError,
    this.birthDateError,
    this.birthPlaceError,
    this.manualBirthPlaceError,
    this.residenceError,
    this.passportNumberError,
    this.passportExpiryError,
    this.passportIssuePlaceError,
    this.passwordError,
    this.confirmPasswordError,
    this.termsError,
  });

  bool get isFormValid {
    final base =
        firstName.isNotEmpty &&
        restOfName.isNotEmpty &&
        phone.isNotEmpty &&
        selectedNationality != null &&
        selectedGender != null &&
        birthDate != null &&
        password.isNotEmpty &&
        confirmPassword == password &&
        agreedToTerms &&
        firstNameError == null &&
        restOfNameError == null &&
        phoneError == null &&
        passwordError == null &&
        confirmPasswordError == null;

    if (nationalityType == NationalityType.egyptian) {
      final birthPlaceValid =
          selectedBirthPlace != null &&
          (!showManualBirthPlace || manualBirthPlace.trim().isNotEmpty);
      return base &&
          nationalId.length == 14 &&
          nationalIdError == null &&
          hasNationalIdImage &&
          birthPlaceValid &&
          selectedResidence != null;
    } else {
      return base &&
          passportNumber.isNotEmpty &&
          passportExpiry != null &&
          selectedPassportIssuePlace != null &&
          selectedResidence != null;
    }
  }

  SignupState copyWith({
    NationalityType? nationalityType,
    String? firstName,
    String? restOfName,
    String? email,
    String? phone,
    List<DropdownItem>? nationalityOptions,
    DropdownItem? Function()? selectedNationality,
    bool? isNationalityLoading,
    bool? isNationalityExpanded,
    GenderType? Function()? selectedGender,
    bool? isGenderExpanded,
    String? nationalId,
    bool? hasNationalIdImage,
    DateTime? Function()? birthDate,
    DropdownItem? Function()? selectedBirthPlace,
    bool? isBirthPlaceExpanded,
    bool? showManualBirthPlace,
    String? manualBirthPlace,
    List<DropdownItem>? residenceOptions,
    DropdownItem? Function()? selectedResidence,
    bool? isResidenceLoading,
    bool? isResidenceExpanded,
    String? passportNumber,
    DateTime? Function()? passportExpiry,
    DropdownItem? Function()? selectedPassportIssuePlace,
    List<DropdownItem>? passportIssuePlaceOptions,
    bool? isPassportIssuePlaceLoading,
    bool? isPassportIssuePlaceExpanded,
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? agreedToTerms,
    bool? isLoading,
    bool? isSubmitSuccess,
    String? Function()? submitError,
    File? Function()? nationalIdFile,
    String? Function()? firstNameError,
    String? Function()? restOfNameError,
    String? Function()? emailError,
    String? Function()? phoneError,
    String? Function()? nationalityError,
    String? Function()? genderError,
    String? Function()? nationalIdError,
    String? Function()? nationalIdImageError,
    String? Function()? birthDateError,
    String? Function()? birthPlaceError,
    String? Function()? manualBirthPlaceError,
    String? Function()? residenceError,
    String? Function()? passportNumberError,
    String? Function()? passportExpiryError,
    String? Function()? passportIssuePlaceError,
    String? Function()? passwordError,
    String? Function()? confirmPasswordError,
    String? Function()? termsError,
  }) {
    return SignupState(
      nationalityType: nationalityType ?? this.nationalityType,
      firstName: firstName ?? this.firstName,
      restOfName: restOfName ?? this.restOfName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      nationalityOptions: nationalityOptions ?? this.nationalityOptions,
      selectedNationality: selectedNationality != null
          ? selectedNationality()
          : this.selectedNationality,
      isNationalityLoading: isNationalityLoading ?? this.isNationalityLoading,
      isNationalityExpanded:
          isNationalityExpanded ?? this.isNationalityExpanded,
      selectedGender: selectedGender != null
          ? selectedGender()
          : this.selectedGender,
      isGenderExpanded: isGenderExpanded ?? this.isGenderExpanded,
      nationalId: nationalId ?? this.nationalId,
      hasNationalIdImage: hasNationalIdImage ?? this.hasNationalIdImage,
      birthDate: birthDate != null ? birthDate() : this.birthDate,
      selectedBirthPlace: selectedBirthPlace != null
          ? selectedBirthPlace()
          : this.selectedBirthPlace,
      isBirthPlaceExpanded: isBirthPlaceExpanded ?? this.isBirthPlaceExpanded,
      showManualBirthPlace: showManualBirthPlace ?? this.showManualBirthPlace,
      manualBirthPlace: manualBirthPlace ?? this.manualBirthPlace,
      residenceOptions: residenceOptions ?? this.residenceOptions,
      selectedResidence: selectedResidence != null
          ? selectedResidence()
          : this.selectedResidence,
      isResidenceLoading: isResidenceLoading ?? this.isResidenceLoading,
      isResidenceExpanded: isResidenceExpanded ?? this.isResidenceExpanded,
      passportNumber: passportNumber ?? this.passportNumber,
      passportExpiry: passportExpiry != null
          ? passportExpiry()
          : this.passportExpiry,
      selectedPassportIssuePlace: selectedPassportIssuePlace != null
          ? selectedPassportIssuePlace()
          : this.selectedPassportIssuePlace,
      passportIssuePlaceOptions:
          passportIssuePlaceOptions ?? this.passportIssuePlaceOptions,
      isPassportIssuePlaceLoading:
          isPassportIssuePlaceLoading ?? this.isPassportIssuePlaceLoading,
      isPassportIssuePlaceExpanded:
          isPassportIssuePlaceExpanded ?? this.isPassportIssuePlaceExpanded,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      isLoading: isLoading ?? this.isLoading,
      isSubmitSuccess: isSubmitSuccess ?? this.isSubmitSuccess,
      submitError: submitError != null ? submitError() : this.submitError,
      nationalIdFile: nationalIdFile != null
          ? nationalIdFile()
          : this.nationalIdFile,
      firstNameError: firstNameError != null
          ? firstNameError()
          : this.firstNameError,
      restOfNameError: restOfNameError != null
          ? restOfNameError()
          : this.restOfNameError,
      emailError: emailError != null ? emailError() : this.emailError,
      phoneError: phoneError != null ? phoneError() : this.phoneError,
      nationalityError: nationalityError != null
          ? nationalityError()
          : this.nationalityError,
      genderError: genderError != null ? genderError() : this.genderError,
      nationalIdError: nationalIdError != null
          ? nationalIdError()
          : this.nationalIdError,
      nationalIdImageError: nationalIdImageError != null
          ? nationalIdImageError()
          : this.nationalIdImageError,
      birthDateError: birthDateError != null
          ? birthDateError()
          : this.birthDateError,
      birthPlaceError: birthPlaceError != null
          ? birthPlaceError()
          : this.birthPlaceError,
      manualBirthPlaceError: manualBirthPlaceError != null
          ? manualBirthPlaceError()
          : this.manualBirthPlaceError,
      residenceError: residenceError != null
          ? residenceError()
          : this.residenceError,
      passportNumberError: passportNumberError != null
          ? passportNumberError()
          : this.passportNumberError,
      passportExpiryError: passportExpiryError != null
          ? passportExpiryError()
          : this.passportExpiryError,
      passportIssuePlaceError: passportIssuePlaceError != null
          ? passportIssuePlaceError()
          : this.passportIssuePlaceError,
      passwordError: passwordError != null
          ? passwordError()
          : this.passwordError,
      confirmPasswordError: confirmPasswordError != null
          ? confirmPasswordError()
          : this.confirmPasswordError,
      termsError: termsError != null ? termsError() : this.termsError,
    );
  }
}

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  final LookupsRepository _lookupsRepository;

  SignupCubit({
    AuthRepository? authRepository,
    LookupsRepository? lookupsRepository,
  }) : _authRepository = authRepository ?? AuthRepository(),
       _lookupsRepository = lookupsRepository ?? LookupsRepository(),
       super(const SignupState()) {
    _loadNationalities();
    _loadResidences();
  }

  Future<void> _loadNationalities() async {
    emit(state.copyWith(isNationalityLoading: true));
    final result = await _lookupsRepository.getTaxpayerTypes();
    switch (result) {
      case ApiSuccess(:final data):
        final options = (data as Iterable<dynamic>)
            .map(
              (e) => DropdownItem(
                id: e['id'].toString(),
                label: e['name']?.toString() ?? '',
              ),
            )
            .toList();
        emit(
          state.copyWith(
            isNationalityLoading: false,
            nationalityOptions: options,
          ),
        );
      case ApiError():
        emit(
          state.copyWith(
            isNationalityLoading: false,
            nationalityOptions: const [
              DropdownItem(id: '1', label: 'مصري'),
              DropdownItem(id: '2', label: 'أجنبي'),
            ],
          ),
        );
    }
  }

  Future<void> _loadResidences() async {
    emit(state.copyWith(isResidenceLoading: true));
    final result = await _lookupsRepository.getGovernorates();
    switch (result) {
      case ApiSuccess(:final data):
        final options = (data as Iterable<dynamic>)
            .map(
              (e) => DropdownItem(
                id: e['id'].toString(),
                label: e['name']?.toString() ?? '',
              ),
            )
            .toList();
        emit(
          state.copyWith(isResidenceLoading: false, residenceOptions: options),
        );
      case ApiError():
        emit(
          state.copyWith(
            isResidenceLoading: false,
            residenceOptions: const [
              DropdownItem(id: '1', label: 'القاهرة'),
              DropdownItem(id: '2', label: 'الإسكندرية'),
              DropdownItem(id: '3', label: 'الجيزة'),
              DropdownItem(id: '4', label: 'الشرقية'),
              DropdownItem(id: '5', label: 'الدقهلية'),
              DropdownItem(id: '6', label: 'البحيرة'),
              DropdownItem(id: '7', label: 'المنيا'),
              DropdownItem(id: '8', label: 'أسيوط'),
              DropdownItem(id: '9', label: 'سوهاج'),
              DropdownItem(id: '10', label: 'أخرى'),
            ],
          ),
        );
    }
  }

  Future<void> _loadPassportIssuePlaces() async {
    emit(state.copyWith(isPassportIssuePlaceLoading: true));
    final result = await _lookupsRepository.getGovernorates();
    switch (result) {
      case ApiSuccess(:final data):
        final options = (data as Iterable<dynamic>)
            .map(
              (e) => DropdownItem(
                id: e['id'].toString(),
                label: e['name']?.toString() ?? '',
              ),
            )
            .toList();
        emit(
          state.copyWith(
            isPassportIssuePlaceLoading: false,
            passportIssuePlaceOptions: options,
          ),
        );
      case ApiError():
        emit(
          state.copyWith(
            isPassportIssuePlaceLoading: false,
            passportIssuePlaceOptions: const [
              DropdownItem(id: '1', label: 'القاهرة'),
              DropdownItem(id: '2', label: 'الإسكندرية'),
              DropdownItem(id: '3', label: 'الجيزة'),
              DropdownItem(id: '4', label: 'أخرى'),
            ],
          ),
        );
    }
  }

  void onFirstNameChanged(String v) {
    emit(
      state.copyWith(
        firstName: v,
        firstNameError: () => v.trim().isEmpty ? 'الاسم الأول مطلوب' : null,
      ),
    );
  }

  void onRestOfNameChanged(String v) {
    emit(
      state.copyWith(
        restOfName: v,
        restOfNameError: () => v.trim().isEmpty ? 'باقي الاسم مطلوب' : null,
      ),
    );
  }

  void onEmailChanged(String v) {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    emit(
      state.copyWith(
        email: v,
        emailError: () {
          if (v.trim().isEmpty) return null;
          if (!emailRegex.hasMatch(v)) {
            return 'صيغة البريد الإلكتروني غير صحيحة';
          }
          return null;
        },
      ),
    );
  }

  void onPhoneChanged(String v) {
    emit(
      state.copyWith(
        phone: v,
        phoneError: () {
          if (v.trim().isEmpty) return 'رقم الهاتف مطلوب';
          if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(v)) {
            return 'رقم الهاتف غير صحيح';
          }
          return null;
        },
      ),
    );
  }

  void toggleNationalityExpand() {
    emit(state.copyWith(isNationalityExpanded: !state.isNationalityExpanded));
  }

  void onNationalitySelected(DropdownItem item) {
    final isEgyptian = item.id == '1';
    emit(
      state.copyWith(
        selectedNationality: () => item,
        isNationalityExpanded: false,
        nationalityType: isEgyptian
            ? NationalityType.egyptian
            : NationalityType.foreign,
        nationalityError: () => null,
      ),
    );
    if (!isEgyptian && state.passportIssuePlaceOptions.isEmpty) {
      _loadPassportIssuePlaces();
    }
  }

  void toggleGenderExpand() {
    emit(state.copyWith(isGenderExpanded: !state.isGenderExpanded));
  }

  void onGenderSelected(GenderType gender) {
    emit(
      state.copyWith(
        selectedGender: () => gender,
        isGenderExpanded: false,
        genderError: () => null,
      ),
    );
  }

  void onNationalIdChanged(String v) {
    emit(
      state.copyWith(
        nationalId: v,
        nationalIdError: () {
          if (v.trim().isEmpty) return 'الرقم القومي مطلوب';
          if (!RegExp(r'^[0-9]+$').hasMatch(v)) return 'أرقام فقط';
          if (v.length != 14) return 'الرقم القومي يجب أن يكون 14 رقماً';
          return null;
        },
      ),
    );
  }

  void onNationalIdImagePicked(File file) {
    emit(
      state.copyWith(
        hasNationalIdImage: true,
        nationalIdFile: () => file,
        nationalIdImageError: () => null,
      ),
    );
  }

  void onNationalIdImageRemoved() {
    emit(
      state.copyWith(
        hasNationalIdImage: false,
        nationalIdFile: () => null,
        nationalIdImageError: () => null,
      ),
    );
  }

  void onBirthDateSelected(DateTime date) {
    emit(state.copyWith(birthDate: () => date, birthDateError: () => null));
  }

  void toggleBirthPlaceExpand() {
    emit(state.copyWith(isBirthPlaceExpanded: !state.isBirthPlaceExpanded));
  }

  void onBirthPlaceSelected(DropdownItem item) {
    final isOther = item.id == '10';
    emit(
      state.copyWith(
        selectedBirthPlace: () => item,
        isBirthPlaceExpanded: false,
        showManualBirthPlace: isOther,
        manualBirthPlace: isOther ? state.manualBirthPlace : '',
        birthPlaceError: () => null,
      ),
    );
  }

  void onManualBirthPlaceChanged(String v) {
    emit(
      state.copyWith(
        manualBirthPlace: v,
        manualBirthPlaceError: () =>
            v.trim().isEmpty ? 'محل الميلاد مطلوب' : null,
      ),
    );
  }

  void toggleResidenceExpand() {
    emit(state.copyWith(isResidenceExpanded: !state.isResidenceExpanded));
  }

  void onResidenceSelected(DropdownItem item) {
    emit(
      state.copyWith(
        selectedResidence: () => item,
        isResidenceExpanded: false,
        residenceError: () => null,
      ),
    );
  }

  void onPassportNumberChanged(String v) {
    emit(
      state.copyWith(
        passportNumber: v,
        passportNumberError: () {
          if (v.trim().isEmpty) return 'رقم جواز السفر مطلوب';
          if (v.length < 6) return 'رقم جواز السفر غير صحيح';
          return null;
        },
      ),
    );
  }

  void onPassportExpirySelected(DateTime date) {
    emit(
      state.copyWith(
        passportExpiry: () => date,
        passportExpiryError: () => null,
      ),
    );
  }

  void togglePassportIssuePlaceExpand() {
    emit(
      state.copyWith(
        isPassportIssuePlaceExpanded: !state.isPassportIssuePlaceExpanded,
      ),
    );
  }

  void onPassportIssuePlaceSelected(DropdownItem item) {
    emit(
      state.copyWith(
        selectedPassportIssuePlace: () => item,
        isPassportIssuePlaceExpanded: false,
        passportIssuePlaceError: () => null,
      ),
    );
  }

  void onPasswordChanged(String v) {
    emit(
      state.copyWith(
        password: v,
        passwordError: () {
          if (v.isEmpty) return 'كلمة السر مطلوبة';
          if (v.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
          if (!v.contains(RegExp(r'[A-Z]'))) return 'يجب أن تحتوي على حرف كبير';
          if (!v.contains(RegExp(r'[0-9]'))) return 'يجب أن تحتوي على رقم';
          if (!v.contains(RegExp(r'[!@#\$%^&*]'))) {
            return 'يجب أن تحتوي على رمز خاص';
          }
          return null;
        },
        confirmPasswordError: () {
          if (state.confirmPassword.isEmpty) return null;
          return state.confirmPassword != v ? 'كلمتا السر غير متطابقتين' : null;
        },
      ),
    );
  }

  void onConfirmPasswordChanged(String v) {
    emit(
      state.copyWith(
        confirmPassword: v,
        confirmPasswordError: () {
          if (v.isEmpty) return 'تأكيد كلمة السر مطلوب';
          return v != state.password ? 'كلمتا السر غير متطابقتين' : null;
        },
      ),
    );
  }

  void togglePasswordVisibility() =>
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));

  void toggleConfirmPasswordVisibility() => emit(
    state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
  );

  void toggleTerms(bool? v) {
    emit(state.copyWith(agreedToTerms: v ?? false, termsError: () => null));
  }

  String? _pendingOtpToken;

  Future<void> submit() async {
    if (!_validateAll()) return;
    emit(state.copyWith(isLoading: true, submitError: () => null));

    final nameParts = state.restOfName.trim().split(' ');
    final lastName = nameParts.isNotEmpty ? nameParts.last : state.restOfName;
    final nationalityCode = state.selectedNationality?.id ?? '1';
    final gender = state.selectedGender == GenderType.male ? '1' : '2';
    final birthPlace = state.showManualBirthPlace
        ? state.manualBirthPlace.trim()
        : (state.selectedBirthPlace?.id ?? '');
    final bd = state.birthDate!;
    final birthDate =
        '${bd.year}-${bd.month.toString().padLeft(2, '0')}-${bd.day.toString().padLeft(2, '0')}';

    final request = RegisterRequest(
      firstName: state.firstName.trim(),
      lastName: lastName,
      email: state.email.trim(),
      mobile: state.phone.trim(),
      password: state.password,
      passwordConfirm: state.confirmPassword,
      nationalId: state.nationalId.trim(),
      nationalityCode: nationalityCode,
      gender: gender,
      birthPlace: birthPlace,
      birthDate: birthDate,
    );

    final result = await _authRepository.sendRegisterOtp(
      request: request,
      nationalIdFile: state.nationalIdFile,
    );

    switch (result) {
      case ApiSuccess(:final data):
        _pendingOtpToken = data['token']?.toString();
        emit(state.copyWith(isLoading: false, isSubmitSuccess: true));
      case ApiError(:final message):
        emit(state.copyWith(isLoading: false, submitError: () => message));
    }
  }

  Future<bool> confirmOtp(String otp) async {
    if (_pendingOtpToken == null) return false;
    emit(state.copyWith(isLoading: true, submitError: () => null));
    final result = await _authRepository.confirmOtp(
      token: _pendingOtpToken!,
      otp: otp,
    );
    switch (result) {
      case ApiSuccess():
        emit(state.copyWith(isLoading: false));
        return true;
      case ApiError(:final message):
        emit(state.copyWith(isLoading: false, submitError: () => message));
        return false;
    }
  }

  Future<void> resendOtp() async {
    emit(state.copyWith(isSubmitSuccess: false, submitError: () => null));
    await submit();
  }

  bool _validateAll() {
    final firstNameError = state.firstName.trim().isEmpty
        ? 'الاسم الأول مطلوب'
        : null;
    final restOfNameError = state.restOfName.trim().isEmpty
        ? 'باقي الاسم مطلوب'
        : null;
    final phoneError = state.phone.trim().isEmpty ? 'رقم الهاتف مطلوب' : null;
    final nationalityError = state.selectedNationality == null
        ? 'الجنسية مطلوبة'
        : null;
    final genderError = state.selectedGender == null ? 'النوع مطلوب' : null;
    final birthDateError = state.birthDate == null
        ? 'تاريخ الميلاد مطلوب'
        : null;
    final passwordError = state.password.isEmpty ? 'كلمة السر مطلوبة' : null;
    final confirmPasswordError = state.confirmPassword != state.password
        ? 'كلمتا السر غير متطابقتين'
        : null;
    final termsError = !state.agreedToTerms
        ? 'يجب الموافقة على الشروط والأحكام'
        : null;

    String? nationalIdError;
    String? nationalIdImageError;
    String? birthPlaceError;
    String? manualBirthPlaceError;
    String? residenceError;
    String? passportNumberError;
    String? passportExpiryError;
    String? passportIssuePlaceError;

    if (state.nationalityType == NationalityType.egyptian) {
      if (state.nationalId.length != 14) {
        nationalIdError = 'الرقم القومي يجب أن يكون 14 رقماً';
      }
      if (!state.hasNationalIdImage) {
        nationalIdImageError = 'يرجى رفع صورة الرقم القومي';
      }
      if (state.selectedBirthPlace == null) {
        birthPlaceError = 'محل الميلاد مطلوب';
      }
      if (state.showManualBirthPlace && state.manualBirthPlace.trim().isEmpty) {
        manualBirthPlaceError = 'محل الميلاد مطلوب';
      }
      if (state.selectedResidence == null) residenceError = 'محل الإقامة مطلوب';
    } else {
      if (state.passportNumber.trim().isEmpty) {
        passportNumberError = 'رقم جواز السفر مطلوب';
      }
      if (state.passportExpiry == null) {
        passportExpiryError = 'تاريخ الانتهاء مطلوب';
      }
      if (state.selectedPassportIssuePlace == null) {
        passportIssuePlaceError = 'محل الإصدار مطلوب';
      }
      if (state.selectedResidence == null) residenceError = 'محل الإقامة مطلوب';
    }

    final hasError = [
      firstNameError,
      restOfNameError,
      phoneError,
      nationalityError,
      genderError,
      birthDateError,
      passwordError,
      confirmPasswordError,
      termsError,
      nationalIdError,
      nationalIdImageError,
      birthPlaceError,
      manualBirthPlaceError,
      residenceError,
      passportNumberError,
      passportExpiryError,
      passportIssuePlaceError,
    ].any((e) => e != null);

    if (hasError) {
      emit(
        state.copyWith(
          firstNameError: () => firstNameError,
          restOfNameError: () => restOfNameError,
          phoneError: () => phoneError,
          nationalityError: () => nationalityError,
          genderError: () => genderError,
          birthDateError: () => birthDateError,
          passwordError: () => passwordError,
          confirmPasswordError: () => confirmPasswordError,
          termsError: () => termsError,
          nationalIdError: () => nationalIdError,
          nationalIdImageError: () => nationalIdImageError,
          birthPlaceError: () => birthPlaceError,
          manualBirthPlaceError: () => manualBirthPlaceError,
          residenceError: () => residenceError,
          passportNumberError: () => passportNumberError,
          passportExpiryError: () => passportExpiryError,
          passportIssuePlaceError: () => passportIssuePlaceError,
        ),
      );
      return false;
    }

    return true;
  }
}
