import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/api_result.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../data/models/declaration_details_model.dart';
import 'declaration_details_states.dart';

class DeclarationDetailsCubit extends Cubit<DeclarationDetailsStates> {
  final int declarationId;
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
  ];
  final List<CategoryConfig> allCategories = [
    CategoryConfig(
      key: 'residential_units',
      label: 'الوحدات السكنية',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      key: 'service_units',
      label: 'الوحدات الخدمية',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      key: 'service_facilities',
      label: 'service_facilities',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      key: 'industrial_facility',
      label: 'المنشآت الصناعية',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      key: 'hotel_facility',
      label: 'المنشآت الفندقية',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      key: 'vacant_land',
      label: 'الأراضي الفضاء',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      key: 'fixed_installation',
      label: 'تركيبات ثابتة',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      key: 'mine_quarry',
      label: 'mine_quarry',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      key: 'petroleum_facility',
      label: 'petroleum_facility',
      summaryFields: baseCategoryInfo,
    ),
    CategoryConfig(
      key: 'production_facility',
      label: 'production_facility',
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

  updateUnit() {
    final selected = activeCategories[selectedCategoryIndex];

    units = (detailsModel?.data?[selected.key]['data'] as List)
        .cast<Map<String, dynamic>>();
  }
}
