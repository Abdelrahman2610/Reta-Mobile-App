part of 'my_debts_cubit.dart';

sealed class MyDebtsState {}

final class MyDebtsInitial extends MyDebtsState {}

final class MyDebtsLoading extends MyDebtsState {}

final class MyDebtsSuccess extends MyDebtsState {
  final List<MyDebtsDeclarationModel> declarations;
  final int total;
  MyDebtsSuccess({required this.declarations, required this.total});
}

final class MyDebtsError extends MyDebtsState {
  final String message;
  MyDebtsError(this.message);
}
