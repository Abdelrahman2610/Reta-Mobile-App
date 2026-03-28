part of 'payment_under_account_cubit.dart';

sealed class PaymentUnderAccountState {}

final class PaymentUnderAccountInitial extends PaymentUnderAccountState {}

final class PaymentUnderAccountLoading extends PaymentUnderAccountState {}

final class PaymentUnderAccountSuccess extends PaymentUnderAccountState {
  final List<PaymentUnderAccountModel> declarations;
  PaymentUnderAccountSuccess(this.declarations);
}

final class PaymentUnderAccountError extends PaymentUnderAccountState {
  final String message;
  PaymentUnderAccountError(this.message);
}
