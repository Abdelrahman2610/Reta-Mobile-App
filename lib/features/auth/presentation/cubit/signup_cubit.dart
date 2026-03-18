import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/dio_client.dart';
import 'package:reta/features/auth/data/models/otp_response.dart';
import 'package:reta/features/auth/data/models/user_models.dart';

import '../../../../core/network/api_result.dart';
import '../../data/models/register_request.dart';
import '../../data/repositories/auth_repository.dart';

class DropdownItem {
  final String id;
  final String label;
  const DropdownItem({required this.id, required this.label});
}

enum NationalityType { egyptian, foreign }

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

  final List<DropdownItem> genderOptions;
  final DropdownItem? selectedGender;
  final bool isGenderLoading;
  final bool isGenderExpanded;

  final String nationalId;
  final bool hasNationalIdImage;
  final File? nationalIdFile;
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
    this.genderOptions = const [],
    this.selectedGender,
    this.isGenderLoading = false,
    this.isGenderExpanded = false,
    this.nationalId = '',
    this.hasNationalIdImage = false,
    this.nationalIdFile,
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
    List<DropdownItem>? genderOptions,
    DropdownItem? Function()? selectedGender,
    bool? isGenderLoading,
    bool? isGenderExpanded,
    String? nationalId,
    bool? hasNationalIdImage,
    File? Function()? nationalIdFile,
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
      genderOptions: genderOptions ?? this.genderOptions,
      selectedGender: selectedGender != null
          ? selectedGender()
          : this.selectedGender,
      isGenderLoading: isGenderLoading ?? this.isGenderLoading,
      isGenderExpanded: isGenderExpanded ?? this.isGenderExpanded,
      nationalId: nationalId ?? this.nationalId,
      hasNationalIdImage: hasNationalIdImage ?? this.hasNationalIdImage,
      nationalIdFile: nationalIdFile != null
          ? nationalIdFile()
          : this.nationalIdFile,
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

// ─────────────────────────────────────────────────────────────────────────────
// Cubit
// ─────────────────────────────────────────────────────────────────────────────

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  String? _pendingOtpToken;
  String? _pendingUserId;
  String? _pendingMobile;

  SignupCubit({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository(),
      super(const SignupState()) {
    _loadNationalities();
    _loadResidences();
    _loadGenders();
  }

  // ── Governorates API ────────────────────────────────────────────────────────

  Future<List<DropdownItem>> _fetchGovernorates() async {
    final response = await PublicDioClient.dio.get(
      ApiConstants.governoratesPublic,
    );
    final raw = response.data as Map<String, dynamic>;
    final list = raw['data'] as List<dynamic>;
    return list.map((e) {
      final rawId = e['id'];
      final isOther = rawId == -1 || rawId.toString() == '-1';
      return DropdownItem(
        id: isOther ? '-1' : (e['code']?.toString() ?? rawId.toString()),
        label: e['name']?.toString() ?? '',
      );
    }).toList();
  }

  static const _fallbackGovernorates = [
    DropdownItem(id: '01', label: 'القاهرة'),
    DropdownItem(id: '02', label: 'الإسكندرية'),
    DropdownItem(id: '21', label: 'الجيزة'),
    DropdownItem(id: '-1', label: 'أخرى'),
  ];

  static const _fallbackGenders = [
    DropdownItem(id: '1', label: 'ذكر'),
    DropdownItem(id: '2', label: 'أنثى'),
  ];

  // ── Gender API ──────────────────────────────────────────────────────────────

  Future<void> _loadGenders() async {
    emit(state.copyWith(isGenderLoading: true));
    try {
      final response = await PublicDioClient.dio.get(ApiConstants.genderPublic);
      final raw = response.data as Map<String, dynamic>;
      final list = raw['data'] as List<dynamic>;
      final options = list
          .map(
            (e) => DropdownItem(
              id: e['id'].toString(),
              label: e['name']?.toString() ?? '',
            ),
          )
          .toList();

      debugPrint(
        '[SignupCubit] Genders loaded: ${options.map((e) => '${e.id}:${e.label}').toList()}',
      );

      emit(state.copyWith(isGenderLoading: false, genderOptions: options));
    } catch (e) {
      debugPrint('[SignupCubit] _loadGenders error: $e');
      emit(
        state.copyWith(isGenderLoading: false, genderOptions: _fallbackGenders),
      );
    }
  }

  // ── Nationalities API ───────────────────────────────────────────────────────

  Future<void> _loadNationalities() async {
    emit(state.copyWith(isNationalityLoading: true));
    try {
      final response = await PublicDioClient.dio.get(
        ApiConstants.nationalitiesPublic,
      );
      final raw = response.data as Map<String, dynamic>;
      final nationalities = raw['data'] as List<dynamic>;

      debugPrint(
        '[SignupCubit] Total nationalities loaded: ${nationalities.length}',
      );

      final options = nationalities.map((n) {
        return DropdownItem(
          id: n['code']?.toString() ?? '',
          label: n['name']?.toString() ?? '',
        );
      }).toList();

      final egyptIndex = options.indexWhere((n) => n.id == 'EG');
      if (egyptIndex != -1) {
        final egypt = options.removeAt(egyptIndex);
        options.insert(0, egypt);
      }

      debugPrint(
        '[SignupCubit] Nationalities list head: ${options.take(3).map((e) => e.id).toList()}',
      );

      emit(
        state.copyWith(
          isNationalityLoading: false,
          nationalityOptions: options,
          selectedNationality: () => options.firstWhere(
            (n) => n.id == 'EG',
            orElse: () => options.first,
          ),
        ),
      );
    } catch (e) {
      debugPrint('[SignupCubit] _loadNationalities error: $e');
      emit(
        state.copyWith(
          isNationalityLoading: false,
          nationalityOptions: const [DropdownItem(id: 'EG', label: 'مصر')],
          selectedNationality: () => const DropdownItem(id: 'EG', label: 'مصر'),
        ),
      );
    }
  }

  Future<void> _loadResidences() async {
    emit(state.copyWith(isResidenceLoading: true));
    final result = await safeApiCall(() => _fetchGovernorates());
    switch (result) {
      case ApiSuccess(:final data):
        emit(state.copyWith(isResidenceLoading: false, residenceOptions: data));
      case ApiError(:final message):
        debugPrint('_loadResidences error: $message');
        emit(
          state.copyWith(
            isResidenceLoading: false,
            residenceOptions: _fallbackGovernorates,
          ),
        );
    }
  }

  Future<void> _loadPassportIssuePlaces() async {
    emit(state.copyWith(isPassportIssuePlaceLoading: true));
    final result = await safeApiCall(() => _fetchGovernorates());
    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(
            isPassportIssuePlaceLoading: false,
            passportIssuePlaceOptions: data,
          ),
        );
      case ApiError(:final message):
        debugPrint('_loadPassportIssuePlaces error: $message');
        emit(
          state.copyWith(
            isPassportIssuePlaceLoading: false,
            passportIssuePlaceOptions: _fallbackGovernorates,
          ),
        );
    }
  }

  // ── Field handlers ──────────────────────────────────────────────────────────

  void onFirstNameChanged(String v) => emit(
    state.copyWith(
      firstName: v,
      firstNameError: () => v.trim().isEmpty ? 'الاسم الأول مطلوب' : null,
    ),
  );

  void onRestOfNameChanged(String v) => emit(
    state.copyWith(
      restOfName: v,
      restOfNameError: () => v.trim().isEmpty ? 'باقي الاسم مطلوب' : null,
    ),
  );

  void onEmailChanged(String v) {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    emit(
      state.copyWith(
        email: v,
        emailError: () {
          if (v.trim().isEmpty) return null;
          if (!emailRegex.hasMatch(v.trim())) {
            return 'صيغة البريد الإلكتروني غير صحيحة';
          }
          return null;
        },
      ),
    );
  }

  void onPhoneChanged(String v) => emit(
    state.copyWith(
      phone: v,
      phoneError: () {
        if (v.trim().isEmpty) return 'رقم الهاتف مطلوب';
        if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(v.trim())) {
          return 'رقم الهاتف غير صحيح';
        }
        return null;
      },
    ),
  );

  void toggleNationalityExpand() =>
      emit(state.copyWith(isNationalityExpanded: !state.isNationalityExpanded));

  void onNationalitySelected(DropdownItem item) {
    debugPrint(
      '[SignupCubit] Nationality selected: id=${item.id}, label=${item.label}',
    );
    emit(
      state.copyWith(
        selectedNationality: () => item,
        isNationalityExpanded: false,
        nationalityType: item.id == 'EG'
            ? NationalityType.egyptian
            : NationalityType.foreign,
        nationalityError: () => null,
      ),
    );
  }

  void toggleGenderExpand() =>
      emit(state.copyWith(isGenderExpanded: !state.isGenderExpanded));

  void onGenderSelected(DropdownItem item) => emit(
    state.copyWith(
      selectedGender: () => item,
      isGenderExpanded: false,
      genderError: () => null,
    ),
  );

  void onNationalIdChanged(String v) => emit(
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

  void onNationalIdImagePicked(File file) => emit(
    state.copyWith(
      hasNationalIdImage: true,
      nationalIdFile: () => file,
      nationalIdImageError: () => null,
    ),
  );

  void onNationalIdImageRemoved() => emit(
    state.copyWith(
      hasNationalIdImage: false,
      nationalIdFile: () => null,
      nationalIdImageError: () => null,
    ),
  );

  void onBirthDateSelected(DateTime date) {
    final isValid = date.isBefore(DateTime.now());
    emit(
      state.copyWith(
        birthDate: () => date,
        birthDateError: () => isValid ? null : 'تاريخ الميلاد غير صحيح',
      ),
    );
  }

  void toggleBirthPlaceExpand() =>
      emit(state.copyWith(isBirthPlaceExpanded: !state.isBirthPlaceExpanded));

  void onBirthPlaceSelected(DropdownItem item) {
    final isOther = item.id == '-1';
    emit(
      state.copyWith(
        selectedBirthPlace: () => item,
        isBirthPlaceExpanded: false,
        showManualBirthPlace: isOther,
        manualBirthPlace: isOther ? state.manualBirthPlace : '',
        birthPlaceError: () => null,
        manualBirthPlaceError: () => null,
      ),
    );
  }

  void onManualBirthPlaceChanged(String v) => emit(
    state.copyWith(
      manualBirthPlace: v,
      manualBirthPlaceError: () =>
          v.trim().isEmpty ? 'محل الميلاد مطلوب' : null,
    ),
  );

  void toggleResidenceExpand() =>
      emit(state.copyWith(isResidenceExpanded: !state.isResidenceExpanded));

  void onResidenceSelected(DropdownItem item) => emit(
    state.copyWith(
      selectedResidence: () => item,
      isResidenceExpanded: false,
      residenceError: () => null,
    ),
  );

  void onPassportNumberChanged(String v) => emit(
    state.copyWith(
      passportNumber: v,
      passportNumberError: () {
        if (v.trim().isEmpty) return 'رقم جواز السفر مطلوب';
        if (v.trim().length < 6) return 'رقم جواز السفر غير صحيح';
        return null;
      },
    ),
  );

  void onPassportExpirySelected(DateTime date) {
    final isValid = date.isAfter(DateTime.now());
    emit(
      state.copyWith(
        passportExpiry: () => date,
        passportExpiryError: () => isValid ? null : 'جواز السفر منتهي الصلاحية',
      ),
    );
  }

  void togglePassportIssuePlaceExpand() => emit(
    state.copyWith(
      isPassportIssuePlaceExpanded: !state.isPassportIssuePlaceExpanded,
    ),
  );

  void onPassportIssuePlaceSelected(DropdownItem item) => emit(
    state.copyWith(
      selectedPassportIssuePlace: () => item,
      isPassportIssuePlaceExpanded: false,
      passportIssuePlaceError: () => null,
    ),
  );

  void onPasswordChanged(String v) => emit(
    state.copyWith(
      password: v,
      passwordError: () {
        if (v.isEmpty) return 'كلمة السر مطلوبة';
        if (v.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
        if (!v.contains(RegExp(r'[A-Z]'))) return 'يجب أن تحتوي على حرف كبير';
        if (!v.contains(RegExp(r'[0-9]'))) return 'يجب أن تحتوي على رقم';
        if (!v.contains(RegExp(r'[!@#\$%^&*]')))
          return 'يجب أن تحتوي على رمز خاص';
        return null;
      },
      confirmPasswordError: () {
        if (state.confirmPassword.isEmpty) return null;
        return state.confirmPassword != v ? 'كلمتا السر غير متطابقتين' : null;
      },
    ),
  );

  void onConfirmPasswordChanged(String v) => emit(
    state.copyWith(
      confirmPassword: v,
      confirmPasswordError: () {
        if (v.isEmpty) return 'تأكيد كلمة السر مطلوب';
        return v != state.password ? 'كلمتا السر غير متطابقتين' : null;
      },
    ),
  );

  void togglePasswordVisibility() =>
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));

  void toggleConfirmPasswordVisibility() => emit(
    state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
  );

  void toggleTerms(bool? v) =>
      emit(state.copyWith(agreedToTerms: v ?? false, termsError: () => null));

  void resetSubmitSuccess() =>
      emit(state.copyWith(isSubmitSuccess: false, submitError: () => null));

  void clearOtpError() => emit(state.copyWith(submitError: () => null));

  // ── Submit ──────────────────────────────────────────────────────────────────

  Future<void> submit() async {
    if (!_validateAll()) return;

    emit(state.copyWith(isLoading: true, submitError: () => null));

    final nameParts = state.restOfName.trim().split(' ');
    final lastName = nameParts.isNotEmpty
        ? nameParts.last
        : state.restOfName.trim();

    final gender = state.selectedGender?.id ?? '1';

    final isForeign = state.nationalityType == NationalityType.foreign;

    final birthPlace = state.showManualBirthPlace
        ? state.manualBirthPlace.trim()
        : (state.selectedBirthPlace?.id ?? '');

    final bd = state.birthDate!;
    final birthDateStr =
        '${bd.year}-${bd.month.toString().padLeft(2, '0')}-${bd.day.toString().padLeft(2, '0')}';

    final resolvedNationalityCode = state.selectedNationality?.id ?? 'EG';
    debugPrint(
      '[SignupCubit] nationality_code=$resolvedNationalityCode  gender=$gender',
    );

    final request = RegisterRequest(
      firstName: state.firstName.trim(),
      lastName: lastName,
      email: state.email.trim(),
      mobile: state.phone.trim(),
      password: state.password,
      passwordConfirm: state.confirmPassword,
      nationalId: state.nationalId.trim(),
      nationalityCode: resolvedNationalityCode,
      gender: gender,
      birthPlace: birthPlace,
      birthDate: birthDateStr,
      passportNumber: isForeign ? state.passportNumber.trim() : null,
    );

    final result = await _authRepository.sendRegisterOtp(
      request: request,
      nationalIdFile: state.nationalIdFile,
      isForeign: isForeign,
    );

    switch (result) {
      case ApiSuccess(:final data):
        _pendingOtpToken = data.token;
        _pendingUserId = data.userId;
        _pendingMobile = state.phone.trim();
        emit(
          state.copyWith(
            isLoading: false,
            submitError: () => null,
            isSubmitSuccess: true,
          ),
        );

      case ApiError(:final message):
        emit(state.copyWith(isLoading: false, submitError: () => message));
    }
  }

  // ── Confirm OTP ─────────────────────────────────────────────────────────────

  Future<UserModel?> confirmOtp(String otp) async {
    if (_pendingOtpToken == null || _pendingUserId == null) return null;

    emit(state.copyWith(isLoading: true, submitError: () => null));

    final result = await _authRepository.confirmRegisterOtp(
      request: ConfirmOtpRequest(
        userId: _pendingUserId!,
        mobile: _pendingMobile ?? state.phone.trim(),
        token: _pendingOtpToken!,
        otp: otp,
        context: 'register',
      ),
    );

    switch (result) {
      case ApiSuccess(:final data):
        emit(state.copyWith(isLoading: false));
        final user = (data.userData != null)
            ? UserModel.fromLoginResponse(data.userData!)
            : UserModel(
                firstname: state.firstName.trim(),
                lastname: state.restOfName.trim(),
                email: state.email.trim(),
                phone: state.phone.trim(),
                nationalId: state.nationalId.trim(),
              );
        return user;

      case ApiError(:final message):
        emit(state.copyWith(isLoading: false, submitError: () => message));
        return null;
    }
  }

  // ── Resend OTP ──────────────────────────────────────────────────────────────

  Future<void> resendOtp() async {
    emit(state.copyWith(isLoading: true, submitError: () => null));

    final isForeign = state.nationalityType == NationalityType.foreign;

    final request = RegisterRequest(
      firstName: state.firstName.trim(),
      lastName: state.restOfName.trim().split(' ').last,
      email: state.email.trim(),
      mobile: state.phone.trim(),
      password: state.password,
      passwordConfirm: state.confirmPassword,
      nationalId: state.nationalId.trim(),
      nationalityCode: state.selectedNationality?.id ?? '',
      gender: state.selectedGender?.id ?? '1',
      birthPlace: state.showManualBirthPlace
          ? state.manualBirthPlace.trim()
          : (state.selectedBirthPlace?.id ?? ''),
      birthDate: _formatDate(state.birthDate!),
      passportNumber: isForeign ? state.passportNumber.trim() : null,
    );

    final result = await _authRepository.sendRegisterOtp(
      request: request,
      nationalIdFile: state.nationalIdFile,
      isForeign: isForeign,
    );

    switch (result) {
      case ApiSuccess(:final data):
        _pendingOtpToken = data.token;
        _pendingUserId = data.userId;
        _pendingMobile = state.phone.trim();
        emit(state.copyWith(isLoading: false));
      case ApiError(:final message):
        emit(state.copyWith(isLoading: false, submitError: () => message));
    }
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // ── Validation ──────────────────────────────────────────────────────────────

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

    String? passwordError;
    final pw = state.password;
    if (pw.isEmpty) {
      passwordError = 'كلمة السر مطلوبة';
    } else if (pw.length < 8) {
      passwordError = 'يجب أن تكون 8 أحرف على الأقل';
    } else if (!pw.contains(RegExp(r'[A-Z]'))) {
      passwordError = 'يجب أن تحتوي على حرف كبير';
    } else if (!pw.contains(RegExp(r'[0-9]'))) {
      passwordError = 'يجب أن تحتوي على رقم';
    } else if (!pw.contains(RegExp(r'[!@#\$%^&*]'))) {
      passwordError = 'يجب أن تحتوي على رمز خاص';
    }

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
    String? passportNumberError;

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
    } else {
      if (state.passportNumber.trim().isEmpty) {
        passportNumberError = 'رقم جواز السفر مطلوب';
      }
      if (state.selectedBirthPlace == null) {
        birthPlaceError = 'محل الميلاد مطلوب';
      }
      if (state.showManualBirthPlace && state.manualBirthPlace.trim().isEmpty) {
        manualBirthPlaceError = 'محل الميلاد مطلوب';
      }
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
      passportNumberError,
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
          passportNumberError: () => passportNumberError,
        ),
      );
      return false;
    }

    return true;
  }
}
