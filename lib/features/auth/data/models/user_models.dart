import 'package:reta/core/helpers/app_enum.dart';

class UserModel {
  final String? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phone;
  final String? nationalId;
  final String? dateOfBirth;
  final String? gender;
  final UserType userType;

  final bool? emailVerified;
  final bool? phoneVerified;
  final bool? nationalIdVerified;
  final String? nationality;
  final String? placeOfBirth;

  //TODO: Add from json to these vars
  final String? passportNumber;
  final List<Map<String, dynamic>>? nationalIdFiles;
  final List<Map<String, dynamic>>? passportFiles;

  const UserModel({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.nationalId,
    this.dateOfBirth,
    this.gender,
    this.userType = UserType.authenticated,
    this.emailVerified,
    this.phoneVerified,
    this.nationalIdVerified,
    this.nationality,
    this.placeOfBirth,
    this.passportNumber,
    this.nationalIdFiles,
    this.passportFiles,
  });

  factory UserModel.guest() {
    return const UserModel(userType: UserType.guest);
  }

  factory UserModel.fromLoginResponse(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      firstname: json['first_name'],
      lastname: json['last_name'],
      email: json['email']?.toString(),
      phone: json['mobile']?.toString(),
      nationalId: json['national_id']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      gender: json['gender']?.toString(),
      nationality: json['nationality']['name']?.toString(),
      placeOfBirth: json['place_of_birth']?.toString(),
      emailVerified: json['email_verified'] == true,
      phoneVerified: json['phone_verified'] == true,
      nationalIdVerified: json['ocr_verified'] == true,
      userType: UserType.authenticated,
    );
  }

  factory UserModel.fromProfileResponse(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final profile = data['profile'] as Map<String, dynamic>? ?? {};
    final nationality = profile['nationality'] as Map<String, dynamic>?;
    return UserModel(
      id: data['id']?.toString(),
      firstname: profile['first_name']?.toString(),
      lastname: profile['last_name']?.toString(),
      email: data['email']?.toString(),
      phone: profile['mobile']?.toString(),
      nationalId: profile['national_id']?.toString(),
      dateOfBirth: profile['birth_date']?.toString(),
      gender: profile['gender']?.toString(),
      nationality: nationality?['name']?.toString(),
      placeOfBirth: profile['birth_place']?.toString(),
      emailVerified: data['email_verified_at'] != null,
      phoneVerified: profile['mobile_verified_at'] != null,
      nationalIdVerified: profile['ocr_verified'] == 1,
      userType: UserType.authenticated,
    );
  }

  bool get isGuest => userType == UserType.guest;

  bool get isAuthenticated => userType == UserType.authenticated;

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? nationalId,
    String? dateOfBirth,
    String? gender,
    UserType? userType,
    bool? emailVerified,
    bool? phoneVerified,
    bool? nationalIdVerified,
    String? nationality,
    String? placeOfBirth,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      nationalId: nationalId ?? this.nationalId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      userType: userType ?? this.userType,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      nationalIdVerified: nationalIdVerified ?? this.nationalIdVerified,
      nationality: nationality ?? this.nationality,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
    );
  }
}
