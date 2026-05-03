import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';

import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/declarations_lookups.dart';
import 'declarations_lookups_states.dart';

class DeclarationLookupsCubit extends Cubit<DeclarationLookupsState> {
  DeclarationLookupsCubit() : super(DeclarationLookupsInitial());

  DeclarationLookupsModel? _lookups;

  DeclarationLookupsModel? get lookups => _lookups;

  Future<void> fetchLookups() async {
    if (_lookups != null) {
      emit(DeclarationLookupsLoaded(_lookups!));
      return;
    }

    emit(DeclarationLookupsLoading());

    final results = await Future.wait([
      safeApiCall(() async {
        final response = await DioClient.instance.dio.get(
          ApiConstants.allLookups,
        );
        return DeclarationLookupsModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }),
      safeApiCall(() async {
        final response = await DioClient.instance.dio.get(
          ApiConstants.starRatings,
        );
        final list = (response.data['data'] as List? ?? [])
            .map((e) => DeclarationLookup.fromJson(e as Map<String, dynamic>))
            .toList();
        return list;
      }),
      safeApiCall(() async {
        final response = await DioClient.instance.dio.get(
          ApiConstants.viewTypes,
        );
        final list = (response.data['data'] as List? ?? [])
            .map((e) => DeclarationLookup.fromJson(e as Map<String, dynamic>))
            .toList();
        return list;
      }),
      safeApiCall(() async {
        final response = await DioClient.instance.dio.get(
          ApiConstants.exploitationTypes,
        );
        final list = (response.data['data'] as List? ?? [])
            .map((e) => DeclarationLookup.fromJson(e as Map<String, dynamic>))
            .toList();
        return list;
      }),

      safeApiCall(() async {
        final res = await DioClient.instance.dio.get(
          ApiConstants.industrialFacilityLookups,
        );
        return res.data['data'] as Map<String, dynamic>;
      }),
      safeApiCall(() async {
        final res = await DioClient.instance.dio.get(
          ApiConstants.productionFacilityLookups,
        );
        return res.data['data'] as Map<String, dynamic>;
      }),
      safeApiCall(() async {
        final res = await DioClient.instance.dio.get(
          ApiConstants.mineQuarryFacilityLookups,
        );
        return res.data['data'] as Map<String, dynamic>;
      }),
      safeApiCall(() async {
        final res = await DioClient.instance.dio.get(
          ApiConstants.serviceFacilityLookups,
        );
        final list = (res.data['data'] as List? ?? [])
            .map((e) => DeclarationLookup.fromJson(e as Map<String, dynamic>))
            .toList();
        return list;
      }),
    ]);

    final mainResult = results[0] as ApiResult<DeclarationLookupsModel>;
    final starResult = results[1] as ApiResult<List<DeclarationLookup>>;
    final viewResult = results[2] as ApiResult<List<DeclarationLookup>>;
    final exploitationResult = results[3] as ApiResult<List<DeclarationLookup>>;
    final industrialResult = results[4];
    final productionResult = results[5];
    final mineQuarryFacilityTypes = results[6];
    final serviceFacilityResult = results[7];

    if (mainResult is ApiError<DeclarationLookupsModel>) {
      emit(DeclarationLookupsError(mainResult.message));
      return;
    }

    var model = (mainResult as ApiSuccess<DeclarationLookupsModel>).data;

    if (starResult is ApiSuccess<List<DeclarationLookup>>) {
      model = model.copyWith(starRatings: starResult.data);
    }

    if (viewResult is ApiSuccess<List<DeclarationLookup>>) {
      model = model.copyWith(hotelViewTypes: viewResult.data);
    }

    if (exploitationResult is ApiSuccess<List<DeclarationLookup>>) {
      model = model.copyWith(exploitationTypes: exploitationResult.data);
    }

    if (industrialResult is ApiSuccess) {
      final data =
          (industrialResult as ApiSuccess).data as Map<String, dynamic>;

      final burdenList = (data['burden_activity_types'] as List? ?? [])
          .map((e) => DeclarationLookup.fromJson(e as Map<String, dynamic>))
          .toList();

      final buildingList = (data['building_types'] as List? ?? [])
          .map((e) => DeclarationLookup.fromJson(e as Map<String, dynamic>))
          .toList();

      model = model.copyWith(
        burdenActivityTypes: burdenList,
        buildingTypes: buildingList,
      );
    }

    if (productionResult is ApiSuccess) {
      final data =
          (productionResult as ApiSuccess).data as Map<String, dynamic>;

      final burdenList = (data['burden_activity_types'] as List? ?? [])
          .map((e) => DeclarationLookup.fromJson(e as Map<String, dynamic>))
          .toList();

      model = model.copyWith(productionBurdenActivityTypes: burdenList);
    }

    if (serviceFacilityResult is ApiSuccess<List<DeclarationLookup>>) {
      model = model.copyWith(
        serviceFacilityTypes: serviceFacilityResult.data,
      );
    }

    if (mineQuarryFacilityTypes is ApiSuccess) {
      final data =
          (mineQuarryFacilityTypes as ApiSuccess).data as Map<String, dynamic>;

      final mineQuarryMaterialsValue =
          (data['mine_quarry_materials'] as List? ?? [])
              .map((e) => DeclarationLookup.fromJson(e as Map<String, dynamic>))
              .toList();

      final mineQuarryFacilityTypesValue =
          (data['mine_quarry_facility_types'] as List? ?? [])
              .map((e) => DeclarationLookup.fromJson(e as Map<String, dynamic>))
              .toList();

      model = model.copyWith(
        mineQuarryMaterialsValue: mineQuarryMaterialsValue,
        mineQuarryFacilityTypesValue: mineQuarryFacilityTypesValue,
      );
    }

    _lookups = model;
    emit(DeclarationLookupsLoaded(model));
  }
}
