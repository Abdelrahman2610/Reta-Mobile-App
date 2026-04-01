part of 'debt_documents_cubit.dart';

sealed class DebtDocumentsState {}

final class DebtDocumentsInitial extends DebtDocumentsState {}

final class DebtDocumentsUpdated extends DebtDocumentsState {
  final List<DebtDocumentItem> documents;
  final bool isSaving;
  final bool canSave;
  DebtDocumentsUpdated({
    required this.documents,
    this.isSaving = false,
    this.canSave = false,
  });
}

final class DebtDocumentsSaved extends DebtDocumentsState {}

final class DebtDocumentsError extends DebtDocumentsState {
  final String message;
  DebtDocumentsError(this.message);
}
