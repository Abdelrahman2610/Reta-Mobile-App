part of 'payment_electronic_cubit.dart';

sealed class PaymentElectronicState {}

final class PaymentElectronicInitial extends PaymentElectronicState {}

final class PaymentElectronicLoading extends PaymentElectronicState {}

final class PaymentElectronicSuccess extends PaymentElectronicState {
  final PaymentElectronicData data;
  PaymentElectronicSuccess(this.data);
}

final class PaymentElectronicError extends PaymentElectronicState {
  final String message;
  PaymentElectronicError(this.message);
}
