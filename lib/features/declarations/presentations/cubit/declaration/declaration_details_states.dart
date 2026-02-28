import '../../../data/models/declaration_details_model.dart';

abstract class DeclarationDetailsStates {}

class DeclarationDetailsInitial extends DeclarationDetailsStates {}

class DeclarationDetailsLoading extends DeclarationDetailsStates {}

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
