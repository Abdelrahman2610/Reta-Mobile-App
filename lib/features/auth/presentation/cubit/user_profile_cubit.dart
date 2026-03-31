import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/features/auth/data/models/user_models.dart';
import 'package:reta/features/auth/data/repositories/auth_repository.dart';

import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final AuthRepository _repository;
  UserModel? userModel;

  UserProfileCubit({AuthRepository? repository, this.userModel})
    : _repository = repository ?? AuthRepository(),
      super(UserProfileInitial());

  Future<void> loadFromUser(UserModel? user) async {
    if (user != null) {
      _emitFromModel(user);
    }

    final result = await _repository.getUserProfile();

    switch (result) {
      case ApiSuccess(:final data):
        userModel = data;
        _emitFromModel(data);
      case ApiError(:final message):
        emit(UserProfileError(message));
    }
  }

  void _emitFromModel(UserModel user) {
    UserModel userModel = UserModel(
      id: user.id,
      firstname: (user.firstname ?? '').trim(),
      lastname: (user.lastname ?? '').trim(),
      email: user.email ?? '',
      emailVerified: user.emailVerified ?? false,
      phone: user.phone ?? '',
      phoneVerified: user.phoneVerified ?? false,
      nationality: user.nationality ?? 'مصري',
      nationalityCode: user.nationalityCode, // ← add
      nationalId: user.nationalId ?? '',
      nationalIdVerified: user.nationalIdVerified ?? false,
      passportNumber: user.passportNumber, // ← add
      dateOfBirth: user.dateOfBirth ?? '',
      placeOfBirth: user.placeOfBirth ?? '',
      gender: user.gender ?? '',
      nationalIdFiles: user.nationalIdFiles ?? [],
      passportFiles: user.passportFiles ?? [],
    );
    emit(UserProfileLoaded(userModel: userModel));
  }
}
