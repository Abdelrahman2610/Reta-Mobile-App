import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/runtime_data.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/api_result.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../data/models/declaration_details_model.dart';
import '../declaration_lookups_cubit.dart';
import 'declaration_cubit.dart';
import 'declaration_details_states.dart';

class DeclarationDetailsCubit extends Cubit<DeclarationDetailsStates> {
  final String declarationId;
  int selectedCategoryIndex = 0;
  List<CategoryConfig> activeCategories = [];
  var units;
  static List<String> baseCategoryInfo = [
    "property_type_text",
    'governorate_text',
    'district_text',
    'village_text',
    'village_other',
    'region_text',
    'region_other',
    'real_estate_code',
    'real_estate_other',
    'real_estate_floor_text',
    'real_estate_floor_other_text',
    "unit_unit_num",
    "unit_other",
    'unit_type_text',
    'unit_id',
    'unit_type_text',
    'usage_type',
    'installation_type_text',
    'installation_type_other',
  ];
  final List<CategoryConfig> allCategories = [
    CategoryConfig(
      key: 'residential_units',
      deleteLabel: 'residential',
      label: 'الوحدات السكنية',
      deleteID: "residential_units",
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      key: 'service_units',
      deleteLabel: "service",
      deleteID: "service_units",
      label: 'الوحدات الخدمية',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      key: 'service_facilities',
      deleteLabel: "serviceFacility",
      deleteID: "service_facilities",
      label: 'المنشآت الخدمية',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      deleteLabel: "industrial",
      deleteID: "industrial_facility",
      key: 'industrial_facility',
      label: 'المنشآت الصناعية',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      deleteID: "hotel_facility",
      deleteLabel: "hotel",
      key: 'hotel_facility',
      label: 'المنشآت الفندقية',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      deleteID: "vacant_land",
      deleteLabel: "vacant",
      key: 'vacant_land',
      label: 'الأراضي الفضاء',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      deleteID: "fixed_installation",
      deleteLabel: "fixedinstallation",
      key: 'fixed_installation',
      label: 'تركيبات ثابتة',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      deleteLabel: "mine",
      deleteID: "mine_quarry",
      key: 'mine_quarry',
      label: 'مناجم ومحاجر',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      key: 'petroleum_facility',
      deleteLabel: "petroleum",
      deleteID: "petroleum_facility",
      label: 'منشآت بترولية',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      key: 'production_facility',
      deleteLabel: "production",
      deleteID: "production_facility",
      label: 'المنشآت الإنتاجية',
      summaryFields: baseCategoryInfo,
    ),
  ];

  DeclarationDetailsCubit(this.declarationId)
    : super(DeclarationDetailsInitial());

  DeclarationDetailsModel? get detailsModel => _detailsModel;
  DeclarationDetailsModel? _detailsModel;

  Future<void> fetchDeclarationModel() async {
    emit(DeclarationDetailsLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.declarationById(declarationId),
      );

      activeCategories = getNonEmptyCategories(response.data['data']);
      return DeclarationDetailsModel.fromJson(response.data['data']);
    });

    switch (result) {
      case ApiSuccess(:final data):
        _detailsModel = data;
        updateUnit();
        emit(
          DeclarationDetailsLoaded(
            data,
            selectedCategoryIndex,
            activeCategories,
            units,
          ),
        );
      case ApiError(:final message):
        emit(DeclarationDetailsError(message));
    }
  }

  Future<void> deleteDeclarationModel() async {
    emit(DeclarationDeleteLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.post(
        ApiConstants.cancelDeclarationById(declarationId),
      );
      RuntimeData.getCurrentContext()!.read<DeclarationCubit>().fetchList();
      return true;
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(DeclarationDeleteSuccess());
      case ApiError(:final message):
        emit(DeclarationDeleteError(message));
    }
  }

  Future<void> changeDeclarationStatusToOnEdit() async {
    emit(DeclarationStatusToOnEditLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.post(
        ApiConstants.changeDeclarationStatusToOnEdit(declarationId),
      );
      return response.data['data'];
    });

    switch (result) {
      case ApiSuccess(:final data):
        _detailsModel?.statusId = data['status_id'].toString();
        _detailsModel?.statusText = data['status_text'].toString();
        emit(
          DeclarationDetailsLoaded(
            detailsModel,
            selectedCategoryIndex,
            activeCategories,
            units,
          ),
        );
        emit(
          DeclarationStatusToOnEditLoaded(
            data['status_id'].toString(),
            data['status_text'],
          ),
        );
      case ApiError(:final message):
        emit(DeclarationStatusToOnEditError(message));
    }
  }

  Future<void> deleteDeclarationUnit(String unitType, String unitId) async {
    emit(DeclarationDeleteLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.delete(
        ApiConstants.deleteUnit(declarationId, unitType, unitId),
      );
      return true;
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(DeclarationDeleteUnitSuccess());
      case ApiError(:final message):
        emit(DeclarationDeleteError(message));
    }
  }

  Future<void> submitDeclaration() async {
    emit(DeclarationSubmitLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.post(
        '${ApiConstants.submitDeclaration(declarationId)}?data_accuracy_declaration=true',
        data: detailsModel!.toJson(),
      );
      return response.data['data'];
    });

    switch (result) {
      case ApiSuccess(:final data):
        _detailsModel?.statusId = data['status_id'].toString();
        _detailsModel?.statusText = data['status_text'].toString();
        emit(
          DeclarationDetailsLoaded(
            detailsModel,
            selectedCategoryIndex,
            activeCategories,
            units,
          ),
        );
        emit(
          DeclarationSubmitSuccess(
            data['status_id'].toString(),
            data['status_text'],
            declarationId,
          ),
        );
      case ApiError(:final message):
        emit(DeclarationSubmitError(message));
    }
  }

  void updatedSelectedCategoryIndex(int updatedSelectedCategoryIndex) {
    selectedCategoryIndex = updatedSelectedCategoryIndex;
    updateUnit();
    emit(
      DeclarationDetailsLoaded(
        _detailsModel,
        selectedCategoryIndex,
        activeCategories,
        units,
      ),
    );
  }

  List<CategoryConfig> getNonEmptyCategories(Map<String, dynamic> data) {
    return allCategories.where((cat) {
      final section = data[cat.key];
      if (section == null) return false;
      final items = section['data'] as List?;
      return items != null && items.isNotEmpty;
    }).toList();
  }

  void updateUnit() {
    if (activeCategories.isNotEmpty) {
      final selected = activeCategories[selectedCategoryIndex];
      units = (detailsModel?.data?[selected.key]['data'] as List)
          .cast<Map<String, dynamic>>();
    }
  }

  Future<void> fetchLookups(BuildContext context) async {
    final lookupsCubit = context.read<DeclarationLookupsCubit>();

    if (lookupsCubit.lookups == null) {
      await lookupsCubit.fetchLookups();
    }

    if (!context.mounted) return;
  }
}
