import '../../../data/models/payment_lookups.dart';

sealed class ClaimStatusLookupState {}

final class ClaimStatusLookupInitial extends ClaimStatusLookupState {}

final class ClaimStatusLookupLoading extends ClaimStatusLookupState {}

final class ClaimStatusLookupSuccess extends ClaimStatusLookupState {
  final List<PaymentStatusLookup> statuses;
  ClaimStatusLookupSuccess(this.statuses);
}

final class ClaimStatusLookupError extends ClaimStatusLookupState {
  final String message;
  ClaimStatusLookupError(this.message);
}
