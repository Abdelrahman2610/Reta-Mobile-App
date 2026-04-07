class RegisterRequest {
  final String firstName;
  final String lastName; // ← back to single lastName
  final String? email;
  final String mobile;
  final String password;
  final String passwordConfirm;
  final String nationalId;
  final String nationalityCode;
  final String gender;
  final String birthPlace;
  final String birthDate;
  final String? passportNumber;

  const RegisterRequest({
    required this.firstName,
    required this.lastName,
    this.email,
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
      'last_name': lastName, // ← send as-is, backend handles splitting
      'mobile': mobile,
      'password': password,
      'password_confirmation': passwordConfirm,
      'national_id': nationalId,
      'nationality_code': nationalityCode,
      'gender': gender,
      'birth_place': birthPlace,
      'birth_date': birthDate,
    };

    if (email != null && email!.trim().isNotEmpty) {
      fields['email'] = email!.trim();
    }
    if (passportNumber != null && passportNumber!.isNotEmpty) {
      fields['passport_num'] = passportNumber!;
    }

    return fields;
  }
}
