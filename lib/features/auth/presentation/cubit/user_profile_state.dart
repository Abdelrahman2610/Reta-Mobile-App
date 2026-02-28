import 'package:equatable/equatable.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {
  const UserProfileInitial();
}

class UserProfileLoaded extends UserProfileState {
  final String fullName;
  final String email;
  final bool emailVerified;
  final String phone;
  final bool phoneVerified;
  final String nationality;
  final String nationalId;
  final bool nationalIdVerified;
  final String dateOfBirth;
  final String placeOfBirth;
  final String gender;

  const UserProfileLoaded({
    required this.fullName,
    required this.email,
    required this.emailVerified,
    required this.phone,
    required this.phoneVerified,
    required this.nationality,
    required this.nationalId,
    required this.nationalIdVerified,
    required this.dateOfBirth,
    required this.placeOfBirth,
    required this.gender,
  });

  @override
  List<Object?> get props => [
        fullName,
        email,
        emailVerified,
        phone,
        phoneVerified,
        nationality,
        nationalId,
        nationalIdVerified,
        dateOfBirth,
        placeOfBirth,
        gender,
      ];

  UserProfileLoaded copyWith({
    String? fullName,
    String? email,
    bool? emailVerified,
    String? phone,
    bool? phoneVerified,
    String? nationality,
    String? nationalId,
    bool? nationalIdVerified,
    String? dateOfBirth,
    String? placeOfBirth,
    String? gender,
  }) {
    return UserProfileLoaded(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      phone: phone ?? this.phone,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      nationality: nationality ?? this.nationality,
      nationalId: nationalId ?? this.nationalId,
      nationalIdVerified: nationalIdVerified ?? this.nationalIdVerified,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      gender: gender ?? this.gender,
    );
  }
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
