import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/features/auth/data/models/user_models.dart';
import 'package:reta/features/auth/data/repositories/auth_repository.dart';

import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final AuthRepository _repository;
  UserModel? userModelData;

  UserProfileCubit({AuthRepository? repository, UserModel? userModel})
    : _repository = repository ?? AuthRepository(),
      super(const UserProfileInitial()) {
    if (userModel != null) _emitFromModel(userModel);
  }

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadFromUser(UserModel? user) async {
    if (user != null) _emitFromModel(user);

    try {
      final result = await _repository.getUserProfile();
      switch (result) {
        case ApiSuccess(:final data):
          _emitFromModel(data);
        case ApiError(:final message):
          emit(UserProfileError(message));
      }
    } catch (e) {
      emit(UserProfileError('حدث خطأ أثناء تحميل البيانات'));
    }
  }

  // ── Edit profile ──────────────────────────────────────────────────────────

  Future<void> editProfile({
    String? phone,
    String? email,
    String? nationalId,
    String? passportNumber,
  }) async {
    final current = state;
    if (current is! UserProfileLoaded) return;

    emit(const UserProfileUpdating());

    final ProfileEditField editedField;
    if (phone != null) {
      editedField = ProfileEditField.phone;
    } else if (email != null) {
      editedField = ProfileEditField.email;
    } else if (nationalId != null) {
      editedField = ProfileEditField.nationalId;
    } else {
      editedField = ProfileEditField.passport;
    }

    final isEgyptian = current.userModel.isEgyptian;

    final result = await _repository.editProfile(
      mobile: phone ?? current.userModel.phone,
      email: email ?? current.userModel.email,
      nationalId: isEgyptian
          ? (nationalId ?? current.userModel.nationalId)
          : null,
      passportNum: !isEgyptian
          ? (passportNumber ?? current.userModel.passportNumber)
          : null,
      nationalityCode: current.userModel.nationalityCode ?? 'EG',
      isEgyptian: isEgyptian,
    );

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          UserProfileUpdateSuccess(
            message: data.message,
            otpData: data.otpResponse,
            editedField: editedField,
            emailVerificationSent: data.sendNewMailVerification,
          ),
        );
        if (data.otpResponse == null || !data.otpResponse!.ok) {
          await loadFromUser(null);
        }

      case ApiError(:final message):
        emit(UserProfileError(message));
        _emitFromModel(current.userModel);
    }
  }

  Future<void> editProfileWithFile({
    required File file,
    required bool isEgyptian,
  }) async {
    final current = state;
    if (current is! UserProfileLoaded) return;

    emit(const UserProfileUpdating());

    final result = await _repository.editProfile(
      nationalityCode: current.userModel.nationalityCode ?? 'EG',
      mobile: current.userModel.phone,
      email: current.userModel.email,
      nationalId: isEgyptian ? current.userModel.nationalId : null,
      passportNum: !isEgyptian ? current.userModel.passportNumber : null,
      idFile: file,
      isEgyptian: isEgyptian,
      docUploaded: true,
    );

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          UserProfileUpdateSuccess(
            message: data.message,
            otpData: null,
            editedField: null,
            emailVerificationSent: false,
          ),
        );
        await loadFromUser(null);

      case ApiError(:final message):
        emit(UserProfileError(message));
        _emitFromModel(current.userModel);
    }
  }

  // ── Confirm phone OTP ─────────────────────────────────────────────────────

  Future<void> confirmPhoneUpdate({
    required String token,
    required String otp,
    required String mobile,
    required String userId,
  }) async {
    final current = state;
    emit(const UserProfileUpdating());

    final result = await _repository.confirmPhoneUpdate(
      token: token,
      otp: otp,
      mobile: mobile,
      userId: userId,
      context: 'update_user_data',
    );

    switch (result) {
      case ApiSuccess():
        emit(const UserProfilePhoneConfirmed());
        await loadFromUser(null);

      case ApiError(:final message):
        emit(UserProfileError(message));
        if (current is UserProfileLoaded) _emitFromModel(current.userModel);
    }
  }

  Future<void> editPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(const UserProfileUpdating());

    final result = await _repository.editPassword(
      currentPassword: currentPassword,
      password: newPassword,
      passwordConfirm: confirmPassword,
    );

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          UserProfilePasswordChanged(
            message: data.message ?? 'تم تغيير كلمة المرور بنجاح',
          ),
        );
        await loadFromUser(null);

      case ApiError(:final message):
        emit(UserProfileError(message));
        await loadFromUser(null);
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _emitFromModel(UserModel user) {
    userModelData = UserModel(
      id: user.id,
      firstname: (user.firstname ?? '').trim(),
      secondName: user.secondName,
      thirdName: user.thirdName,
      fourthName: user.fourthName,
      lastname: (user.lastname ?? '').trim(),
      email: user.email ?? '',
      emailVerified: user.emailVerified ?? false,
      phone: user.phone ?? '',
      phoneVerified: user.phoneVerified ?? false,
      nationality: user.nationality ?? 'مصري',
      nationalityCode: user.nationalityCode,
      nationalId: user.nationalId ?? '',
      nationalIdVerified: user.nationalIdVerified ?? false,
      passportNumber: user.passportNumber,
      dateOfBirth: user.dateOfBirth ?? '',
      placeOfBirth: user.placeOfBirth ?? '',
      gender: user.gender ?? '',
      nationalIdFiles: user.nationalIdFiles ?? [],
      passportFiles: user.passportFiles ?? [],
    );
    emit(UserProfileLoaded(userModel: userModelData!));
  }
}
