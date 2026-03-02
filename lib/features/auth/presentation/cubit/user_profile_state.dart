import 'package:equatable/equatable.dart';
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

  UserProfileLoaded copyWith({UserModel? userModel}) {
    return UserProfileLoaded(userModel: userModel ?? this.userModel);
  }
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
