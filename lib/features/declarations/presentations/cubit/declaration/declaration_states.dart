import '../../../data/models/declaration_model.dart';

abstract class DeclarationState {}

class DeclarationListInitial extends DeclarationState {}

class DeclarationListLoading extends DeclarationState {}

class DeclarationListLoaded extends DeclarationState {
  final List<DeclarationModel>? declarationList;

  DeclarationListLoaded(this.declarationList);
}

class DeclarationListError extends DeclarationState {
  final String message;

  DeclarationListError(this.message);
}
