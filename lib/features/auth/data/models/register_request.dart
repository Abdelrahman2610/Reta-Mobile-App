class RegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String password;
  final String passwordConfirm;
  final String nationalId;
  final String nationalityCode;

  /// "1" = male, "2" = female
  final String gender;

  /// Governorate name (string) or free-text if "other"
  final String birthPlace;

  /// Format: "YYYY-MM-DD"
  final String birthDate;

  /// Passport number for foreign nationals
  final String? passportNumber;

  const RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.password,
    required this.passwordConfirm,
    required this.nationalId,
    required this.nationalityCode,
    required this.gender,
    required this.birthPlace,
    required this.birthDate,
    required this.passportNumber,
  });

  Map<String, String> toFormFields() {
    final fields = <String, String>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'mobile': mobile,
      'password': password,
      'password_confirmation': passwordConfirm,
      'national_id': nationalId,
      'nationality_code': nationalityCode,
      'gender': gender,
      'birth_place': birthPlace,
      'birth_date': birthDate,
    };

    if (passportNumber != null && passportNumber!.isNotEmpty) {
      fields['passport_num'] = passportNumber!;
    }

    return fields;
  }
}
