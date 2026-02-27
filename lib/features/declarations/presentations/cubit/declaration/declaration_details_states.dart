import '../../../data/models/declaration_details_model.dart';

abstract class DeclarationDetailsStates {}

class DeclarationDetailsInitial extends DeclarationDetailsStates {}

class DeclarationDetailsLoading extends DeclarationDetailsStates {}

class DeclarationDetailsLoaded extends DeclarationDetailsStates {
  final DeclarationDetailsModel? detailsModel;

  DeclarationDetailsLoaded(this.detailsModel);
}

class DeclarationDetailsError extends DeclarationDetailsStates {
  final String message;

  DeclarationDetailsError(this.message);
}
