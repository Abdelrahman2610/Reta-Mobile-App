import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/features/auth/data/models/user_models.dart';
import 'package:reta/features/auth/data/repositories/auth_repository.dart';

import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final AuthRepository _repository;

  UserProfileCubit({AuthRepository? repository})
    : _repository = repository ?? AuthRepository(),
      super(const UserProfileInitial());

  Future<void> loadFromUser(UserModel user) async {
    _emitFromModel(user);

    final result = await _repository.getUserProfile();

    switch (result) {
      case ApiSuccess(:final data):
        _emitFromModel(data);
      case ApiError(:final message):
        emit(UserProfileError(message));
    }
  }

  void _emitFromModel(UserModel user) {
    emit(
      UserProfileLoaded(
        fullName: '${user.firstname ?? ''} ${user.lastname ?? ''}'.trim(),
        email: user.email ?? '',
        emailVerified: user.emailVerified ?? false,
        phone: user.phone ?? '',
        phoneVerified: user.phoneVerified ?? false,
        nationality: user.nationality ?? 'مصري',
        nationalId: user.nationalId ?? '',
        nationalIdVerified: user.nationalIdVerified ?? false,
        dateOfBirth: user.dateOfBirth ?? '',
        placeOfBirth: user.placeOfBirth ?? '',
        gender: user.gender ?? '',
      ),
    );
  }
}
