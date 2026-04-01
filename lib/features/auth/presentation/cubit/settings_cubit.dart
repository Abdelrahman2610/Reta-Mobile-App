import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/user_models.dart';
import '../../data/repositories/auth_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final UserModel _initialUser;
  final AuthRepository _repository;

  UserModel get userModel => _initialUser;

  SettingsCubit({required UserModel initialUser, AuthRepository? repository})
    : _initialUser = initialUser,
      _repository = repository ?? AuthRepository(),
      super(const SettingsLoading());

  Future<void> loadSettings() async {
    emit(SettingsLoaded(user: _initialUser));

    // if (_initialUser.isGuest) return;

    final result = await _repository.getUserProfile();

    switch (result) {
      case ApiSuccess(:final data):
        final current = state;
        if (current is SettingsLoaded) {
          emit(current.copyWith(user: data));
        }
      case ApiError(:final message):
        break;
    }
  }

  void changeLanguage(String languageCode) {
    final current = state;
    if (current is SettingsLoaded) {
      emit(current.copyWith(currentLanguage: languageCode));
    }
  }

  Future<void> logout() async {
    try {
      await DioClient.clearToken();
      emit(const SettingsLoggedOut());
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    try {
      final result = await _repository.deleteAccount();
      switch (result) {
        case ApiSuccess():
          await DioClient.clearToken();
          emit(const SettingsAccountDeleted());
        case ApiError(:final message):
          emit(SettingsError(message));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  UserModel? get currentUser =>
      state is SettingsLoaded ? (state as SettingsLoaded).user : null;

  bool get isGuest => currentUser?.isGuest ?? true;

  bool get isAuthenticated => currentUser?.isAuthenticated ?? false;
}

// extension SettingsCubitX on SettingsCubit {
//   void mockUserType(UserType type) {
//     final mockUser = UserModel(
//       id: 'mock-id',
//       name: 'أحمد الدسوقي',
//       email: 'name@email.com',
//       phone: '+20 100 077 1670',
//       nationalId: '12345678901234',
//       dateOfBirth: '1973/11/02',
//       gender: 'ذكر',
//       userType: type,
//     );
//     emit(SettingsLoaded(user: mockUser));
//   }
// }
