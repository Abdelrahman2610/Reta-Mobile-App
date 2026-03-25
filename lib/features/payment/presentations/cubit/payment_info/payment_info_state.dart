part of 'payment_info_cubit.dart';

sealed class PaymentInfoState {}

final class PaymentInfoInitial extends PaymentInfoState {}

final class PaymentInfoLoading extends PaymentInfoState {}

final class PaymentInfoSuccess extends PaymentInfoState {
  final PaymentInfoResponse data;
  PaymentInfoSuccess(this.data);
}

final class PaymentInfoError extends PaymentInfoState {
  final String message;
  PaymentInfoError(this.message);
}

final class PaymentInfoClaimSuccess extends PaymentInfoState {}
