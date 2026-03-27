part of 'payment_info_under_debts_cubit.dart';

sealed class PaymentInfoUnderDebtsState {}

final class PaymentInfoUnderDebtsInitial extends PaymentInfoUnderDebtsState {}

final class PaymentInfoUnderDebtsLoading extends PaymentInfoUnderDebtsState {}

final class PaymentInfoUnderDebtsSuccess extends PaymentInfoUnderDebtsState {
  final DebtUnitsResponse data;
  PaymentInfoUnderDebtsSuccess(this.data);
}

final class PaymentInfoUnderDebtsError extends PaymentInfoUnderDebtsState {
  final String message;
  PaymentInfoUnderDebtsError(this.message);
}

final class PaymentInfoUnderDebtsClaimSuccess
    extends PaymentInfoUnderDebtsState {}
