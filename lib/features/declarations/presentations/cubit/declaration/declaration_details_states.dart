import '../../../data/models/declaration_details_model.dart';

abstract class DeclarationDetailsStates {}

class DeclarationDetailsInitial extends DeclarationDetailsStates {}

class DeclarationDetailsLoading extends DeclarationDetailsStates {}

class DeclarationStatusToOnEditLoading extends DeclarationDetailsStates {}

class DeclarationStatusToOnEditLoaded extends DeclarationDetailsStates {
  final String statusId;
  final String statusText;

  DeclarationStatusToOnEditLoaded(this.statusId, this.statusText);
}

class DeclarationDetailsLoaded extends DeclarationDetailsStates {
  final DeclarationDetailsModel? detailsModel;

  final int selectedCategoryIndex;
  final List<CategoryConfig> activeCategories;
  final units;

  DeclarationDetailsLoaded(
    this.detailsModel,
    this.selectedCategoryIndex,
    this.activeCategories,
    this.units,
  );
}

class DeclarationDetailsError extends DeclarationDetailsStates {
  final String message;

  DeclarationDetailsError(this.message);
}

class DeclarationStatusToOnEditError extends DeclarationDetailsStates {
  final String message;

  DeclarationStatusToOnEditError(this.message);
}

class DeclarationDeleteLoading extends DeclarationDetailsStates {}

class DeclarationDeleteSuccess extends DeclarationDetailsStates {}

class DeclarationDeleteError extends DeclarationDetailsStates {
  final String message;

  DeclarationDeleteError(this.message);
}

class DeclarationSubmitLoading extends DeclarationDetailsStates {}

class DeclarationSubmitSuccess extends DeclarationDetailsStates {
  final String statusId;
  final String declarationId;
  final String statusText;

  DeclarationSubmitSuccess(this.statusText, this.statusId, this.declarationId);
}

class DeclarationDeleteUnitSuccess extends DeclarationDetailsStates {}

class DeclarationSubmitError extends DeclarationDetailsStates {
  final String message;

  DeclarationSubmitError(this.message);
}
