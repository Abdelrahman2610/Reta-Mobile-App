import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';
import 'package:reta/core/services/upload_service.dart';
import 'package:reta/features/payment/data/models/debt_document_item.dart';
import 'package:reta/features/payment/data/models/debt_unit_item.dart';
import 'package:uuid/uuid.dart';

part 'debt_documents_state.dart';

class DebtDocumentsCubit extends Cubit<DebtDocumentsState> {
  DebtDocumentsCubit({required this.unit, required this.declarationId})
    : super(DebtDocumentsInitial()) {
    _initDocuments();
  }

  final DebtUnitItemModel unit;
  final String declarationId;
  final _uuid = const Uuid();
  bool _hasChanges = false;

  final List<DebtDocumentItem> _documents = [];

  void _initDocuments() {
    _documents.addAll(
      unit.debtSupportingDocuments.map((d) => DebtDocumentItem.fromExisting(d)),
    );

    if (_documents.isEmpty) {
      _documents.add(DebtDocumentItem(id: _uuid.v4()));
    }
    _emitUpdated();
  }

  void _emitUpdated({bool isSaving = false}) {
    emit(
      DebtDocumentsUpdated(
        documents: List.from(_documents),
        isSaving: isSaving,
        canSave: _hasChanges && _documents.any((d) => d.isValid),
      ),
    );
  }

  void addDocument() {
    if (_documents.length >= 5) return;
    _hasChanges = true;
    _documents.add(DebtDocumentItem(id: _uuid.v4()));
    _emitUpdated();
  }

  void removeDocument(String id) {
    _hasChanges = true;
    _documents.removeWhere((d) => d.id == id);
    if (_documents.isEmpty) {
      _documents.add(DebtDocumentItem(id: _uuid.v4()));
    }
    _emitUpdated();
  }

  void onNameChanged() {
    _hasChanges = true;
    _emitUpdated();
  }

  // في DebtDocumentsCubit

  // Method 1: Upload file only (called on "حمل ملف" tap)
  Future<void> pickAndUploadFile(String documentId) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf', 'png'],
    );
    if (result == null || result.files.isEmpty) return;

    final index = _documents.indexWhere((d) => d.id == documentId);
    if (index == -1) return;

    final filePath = result.files.single.path!;
    final fileName = result.files.single.name;

    // Show loading on this specific document
    _documents[index].isUploading = true;
    _emitUpdated();

    final uploadResult = await UploadService.instance.uploadFile(
      filePath: filePath,
      label: 'supporting_documents',
    );

    switch (uploadResult) {
      case ApiSuccess(:final data):
        _hasChanges = true;
        _documents[index].filePath = filePath;
        _documents[index].originalFileName = fileName;
        _documents[index].path = data.path;
        _documents[index].fullUrl = data.fullUrl;
        _documents[index].isUploading = false;
        _emitUpdated();
      case ApiError(:final message):
        _documents[index].isUploading = false;
        _emitUpdated();
        emit(DebtDocumentsError(message));
    }
  }

  Future<void> saveDocuments() async {
    final validDocs = _documents.where((d) => d.isValid).toList();
    if (validDocs.isEmpty) return;

    _emitUpdated(isSaving: true);

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.post(
        ApiConstants.uploadDebtSupportingDocument,
        data: {
          'declaration_id': int.parse(declarationId),
          'property_type_id': int.parse(unit.propertyTypeId),
          'id': unit.id,
          'debt_supporting_documents': validDocs
              .map(
                (doc) => {
                  'name': doc.nameController.text.trim(),
                  'path': doc.path,
                  'original_file_name': doc.originalFileName ?? '',
                },
              )
              .toList(),
        },
      );
      return response.data;
    });

    switch (result) {
      case ApiSuccess():
        emit(DebtDocumentsSaved());
      case ApiError(:final message):
        emit(DebtDocumentsError(message));
    }
  }

  Future<void> removeFile(String documentId) async {
    final index = _documents.indexWhere((d) => d.id == documentId);
    if (index == -1) return;

    final path = _documents[index].path;

    if (path != null) {
      await safeApiCall(() async {
        final formData = FormData.fromMap({'paths[0]': path});
        await DioClient.instance.dio.post(
          ApiConstants.deleteTempFiles,
          data: formData,
        );
        return true;
      });
    }

    _hasChanges = true;
    _documents[index].filePath = null;
    _documents[index].originalFileName = null;
    _documents[index].path = null;
    _documents[index].fullUrl = null;
    _emitUpdated();
  }

  @override
  Future<void> close() {
    for (final doc in _documents) {
      doc.dispose();
    }
    return super.close();
  }
}
