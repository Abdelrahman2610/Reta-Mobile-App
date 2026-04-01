import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/features/auth/data/repositories/profile_verification_repository.dart';

import 'profile_verification_state.dart';

class ProfileVerificationCubit extends Cubit<ProfileVerificationState> {
  final ProfileVerificationRepository _repo;

  ProfileVerificationCubit({ProfileVerificationRepository? repo})
    : _repo = repo ?? ProfileVerificationRepository(),
      super(const ProfileVerificationInitial());

  Future<void> sendPhoneOtp() async {
    emit(const ProfileVerificationLoading());

    final result = await _repo.sendPhoneVerificationOtp();

    switch (result) {
      case ApiSuccess(:final data):
        emit(PhoneOtpSent(data));
      case ApiError(:final message):
        emit(ProfileVerificationError(message));
    }
  }

  Future<void> confirmPhoneOtp({
    required String token,
    required String otp,
    required String mobile,
    required String userId,
  }) async {
    final current = state;
    final otpData = current is PhoneOtpSent
        ? current.otpData
        : (current is PhoneOtpError ? current.otpData : null);

    emit(const ProfileVerificationLoading());

    final result = await _repo.confirmPhoneVerificationOtp(
      token: token,
      otp: otp,
      mobile: mobile,
      userId: userId,
    );

    switch (result) {
      case ApiSuccess(:final data):
        if (data.phoneVerified) {
          emit(const PhoneVerificationSuccess());
        } else {
          emit(ProfileVerificationError('فشل التحقق من الهاتف'));
        }
      case ApiError(:final message):
        if (otpData != null) {
          emit(PhoneOtpError(message: message, otpData: otpData));
        } else {
          emit(ProfileVerificationError(message));
        }
    }
  }

  Future<void> resendPhoneOtp() async => sendPhoneOtp();

  Future<void> sendEmailVerification({required String email}) async {
    emit(const ProfileVerificationLoading());

    final result = await _repo.sendEmailVerification(email: email);

    switch (result) {
      case ApiSuccess(:final data):
        emit(EmailVerificationSent(data));
      case ApiError(:final message):
        emit(ProfileVerificationError(message));
    }
  }

  Future<void> validateIdentity() async {
    emit(const ProfileVerificationLoading());

    final result = await _repo.validateIdentity();

    switch (result) {
      case ApiSuccess(:final data):
        emit(IdentityVerificationSuccess(data));
      case ApiError(:final message):
        emit(ProfileVerificationError(message));
    }
  }
}
