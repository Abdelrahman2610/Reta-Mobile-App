import 'package:equatable/equatable.dart';
import 'package:reta/features/auth/data/models/edit_profile_response.dart';
import 'package:reta/features/auth/data/models/user_models.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();
  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {
  const UserProfileInitial();
}

class UserProfileLoaded extends UserProfileState {
  final UserModel userModel;
  const UserProfileLoaded({required this.userModel});

  @override
  List<Object?> get props => [userModel];

  UserProfileLoaded copyWith({UserModel? userModel}) =>
      UserProfileLoaded(userModel: userModel ?? this.userModel);
}

class UserProfileUpdating extends UserProfileState {
  const UserProfileUpdating();
}

class UserProfileError extends UserProfileState {
  final String message;
  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserProfileUpdateSuccess extends UserProfileState {
  final String message;
  final OtpResponseData? otpData;
  final ProfileEditField? editedField;
  final bool emailVerificationSent;

  const UserProfileUpdateSuccess({
    required this.message,
    this.otpData,
    this.editedField,
    this.emailVerificationSent = false,
  });

  @override
  List<Object?> get props => [
    message,
    otpData,
    editedField,
    emailVerificationSent,
  ];
}

class UserProfilePhoneConfirmed extends UserProfileState {
  const UserProfilePhoneConfirmed();
}

class UserProfilePasswordChanged extends UserProfileState {
  final String message;
  const UserProfilePasswordChanged({required this.message});

  @override
  List<Object?> get props => [message];
}

enum ProfileEditField { phone, email, nationalId, passport }
