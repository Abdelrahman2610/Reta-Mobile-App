part of 'payment_transactions_cubit.dart';

sealed class PaymentTransactionsState {}

final class PaymentTransactionsInitial extends PaymentTransactionsState {}

final class PaymentTransactionsLoading extends PaymentTransactionsState {}

final class PaymentTransactionsSuccess extends PaymentTransactionsState {
  final List<PaymentTransactionModel> transactions;
  PaymentTransactionsSuccess(this.transactions);
}

final class PaymentTransactionsError extends PaymentTransactionsState {
  final String message;
  PaymentTransactionsError(this.message);
}
