part of 'payment_claims_cubit.dart';

sealed class PaymentClaimsState {}

final class PaymentClaimsInitial extends PaymentClaimsState {}

final class PaymentClaimsLoading extends PaymentClaimsState {}

final class PaymentClaimsSuccess extends PaymentClaimsState {
  final List<PaymentClaimModel> claims;
  final int total;
  PaymentClaimsSuccess({required this.claims, required this.total});
}

final class PaymentClaimsError extends PaymentClaimsState {
  final String message;
  PaymentClaimsError(this.message);
}

final class PaymentClaimsDeleteSuccess extends PaymentClaimsState {}
