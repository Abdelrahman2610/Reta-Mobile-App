import 'package:equatable/equatable.dart';
import 'package:reta/features/auth/data/repositories/profile_verification_repository.dart';

abstract class ProfileVerificationState extends Equatable {
  const ProfileVerificationState();
  @override
  List<Object?> get props => [];
}

/// Initial / idle
class ProfileVerificationInitial extends ProfileVerificationState {
  const ProfileVerificationInitial();
}

/// Waiting for API
class ProfileVerificationLoading extends ProfileVerificationState {
  const ProfileVerificationLoading();
}

// ── Phone flow ────────────────────────────────────────────────────────────────

class PhoneOtpSent extends ProfileVerificationState {
  final SendPhoneOtpResponse otpData;
  const PhoneOtpSent(this.otpData);

  @override
  List<Object?> get props => [otpData];
}

class PhoneOtpError extends ProfileVerificationState {
  final String message;
  final SendPhoneOtpResponse otpData;
  const PhoneOtpError({required this.message, required this.otpData});

  @override
  List<Object?> get props => [message, otpData];
}

/// Phone confirmed successfully
class PhoneVerificationSuccess extends ProfileVerificationState {
  const PhoneVerificationSuccess();
}

// ── Email flow ────────────────────────────────────────────────────────────────

class EmailVerificationSent extends ProfileVerificationState {
  final String message;
  const EmailVerificationSent(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Identity / OCR flow ───────────────────────────────────────────────────────

class IdentityVerificationSuccess extends ProfileVerificationState {
  final String message;
  const IdentityVerificationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Shared error ──────────────────────────────────────────────────────────────

class ProfileVerificationError extends ProfileVerificationState {
  final String message;
  const ProfileVerificationError(this.message);

  @override
  List<Object?> get props => [message];
}
