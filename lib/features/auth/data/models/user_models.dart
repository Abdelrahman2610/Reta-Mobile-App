import 'package:reta/core/helpers/app_enum.dart';

class UserModel {
  final String? id;
  final String? firstname;
  final String? secondName;
  final String? thirdName;
  final String? fourthName;
  final String? lastname;
  final String? fullName;
  final String? restOfName;
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
  final String? nationalityCode;
  final String? placeOfBirth;

  final String? passportNumber;
  final String? factoryNum;
  final List<Map<String, dynamic>>? nationalIdFiles;
  final List<Map<String, dynamic>>? passportFiles;

  // Address fields
  final String? governorateId;
  final String? governorateName;
  final String? districtId;
  final String? villageId;
  final String? streetId;
  final String? streetOther;
  final String? realEstateNum;

  // Account meta
  final bool? newUser;
  final String? lastSeen;

  const UserModel({
    this.id,
    this.firstname,
    this.secondName,
    this.thirdName,
    this.fourthName,
    this.lastname,
    this.fullName,
    this.restOfName,
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
    this.nationalityCode,
    this.placeOfBirth,
    this.passportNumber,
    this.factoryNum,
    this.nationalIdFiles,
    this.passportFiles,
    this.governorateId,
    this.governorateName,
    this.districtId,
    this.villageId,
    this.streetId,
    this.streetOther,
    this.realEstateNum,
    this.newUser,
    this.lastSeen,
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
    final governorate = profile['governorate'] as Map<String, dynamic>?;

    List<Map<String, dynamic>>? parseFiles(dynamic raw) {
      if (raw == null) return null;
      if (raw is List) {
        return raw.whereType<Map<String, dynamic>>().toList();
      }
      return null;
    }

    return UserModel(
      id: profile['id']?.toString(),
      firstname: profile['first_name']?.toString(),
      secondName: profile['second_name']?.toString(),
      thirdName: profile['third_name']?.toString(),
      fourthName: profile['fourth_name']?.toString(),
      lastname: profile['last_name']?.toString(),
      fullName: profile['full_name']?.toString(),
      restOfName: profile['restOfName']?.toString(),
      email: data['email']?.toString(),
      phone: profile['mobile']?.toString(),
      nationalId: profile['national_id']?.toString(),
      passportNumber: profile['passport_num']?.toString(),
      factoryNum: profile['factory_num']?.toString(),
      nationalityCode: nationality?['code']?.toString(),
      dateOfBirth: profile['birth_date']?.toString(),
      gender: profile['gender']?.toString(),
      nationality: nationality?['name']?.toString(),
      placeOfBirth: profile['birth_place']?.toString(),
      governorateId: profile['governorate_id']?.toString(),
      governorateName: governorate?['name']?.toString(),
      districtId: profile['district_id']?.toString(),
      villageId: profile['village_id']?.toString(),
      streetId: profile['street_id']?.toString(),
      streetOther: profile['street_other']?.toString(),
      realEstateNum: profile['real_estate_num']?.toString(),
      emailVerified: data['email_verified_at'] != null,
      phoneVerified: profile['mobile_verified_at'] != null,
      nationalIdVerified: profile['ocr_verified'] == 1,
      nationalIdFiles: parseFiles(profile['national_id_file']),
      passportFiles: parseFiles(profile['passport_num_file']),
      newUser: data['new_user'] == 1,
      lastSeen: data['last_seen']?.toString(),
      userType: UserType.authenticated,
    );
  }

  bool get isGuest => userType == UserType.guest;

  bool get isEgyptian => nationalityCode == 'EG';

  bool get isAuthenticated => userType == UserType.authenticated;

  bool get isFullyVerified =>
      (phoneVerified ?? false) && (nationalIdVerified ?? false);

  UserModel copyWith({
    String? id,
    String? firstName,
    String? secondName,
    String? thirdName,
    String? fourthName,
    String? lastName,
    String? fullName,
    String? restOfName,
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
    String? nationalityCode,
    String? passportNumber,
    String? factoryNum,
    String? governorateId,
    String? governorateName,
    String? districtId,
    String? villageId,
    String? streetId,
    String? streetOther,
    String? realEstateNum,
    bool? newUser,
    String? lastSeen,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstname: firstName ?? this.firstname,
      secondName: secondName ?? this.secondName,
      thirdName: thirdName ?? this.thirdName,
      fourthName: fourthName ?? this.fourthName,
      lastname: lastName ?? this.lastname,
      fullName: fullName ?? this.fullName,
      restOfName: restOfName ?? this.restOfName,
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
      nationalityCode: nationalityCode ?? this.nationalityCode,
      passportNumber: passportNumber ?? this.passportNumber,
      factoryNum: factoryNum ?? this.factoryNum,
      governorateId: governorateId ?? this.governorateId,
      governorateName: governorateName ?? this.governorateName,
      districtId: districtId ?? this.districtId,
      villageId: villageId ?? this.villageId,
      streetId: streetId ?? this.streetId,
      streetOther: streetOther ?? this.streetOther,
      realEstateNum: realEstateNum ?? this.realEstateNum,
      newUser: newUser ?? this.newUser,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
