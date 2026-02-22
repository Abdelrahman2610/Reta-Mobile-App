class RegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String password;
  final String passwordConfirm;
  final String nationalId;
  final String nationalityCode;
  final String gender; // '1' = male, '2' = female
  final String birthPlace; // governorate id as string
  final String birthDate; // 'YYYY-MM-DD'

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
  });
}
