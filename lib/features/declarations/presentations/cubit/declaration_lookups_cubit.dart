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
    ]);

    final mainResult = results[0] as ApiResult<DeclarationLookupsModel>;
    final starResult = results[1] as ApiResult<List<DeclarationLookup>>;
    final viewResult = results[2] as ApiResult<List<DeclarationLookup>>;
    final exploitationResult = results[3] as ApiResult<List<DeclarationLookup>>;

    if (mainResult is ApiError<DeclarationLookupsModel>) {
      emit(DeclarationLookupsError(mainResult.message));
      return;
    }

    var model = (mainResult as ApiSuccess<DeclarationLookupsModel>).data;

    if (starResult is ApiSuccess<List<DeclarationLookup>>) {
      model = model.copyWith(starRatings: starResult.data);
    }

    if (viewResult is ApiSuccess<List<DeclarationLookup>>) {
      model = model.copyWith(viewTypes: viewResult.data);
    }

    if (exploitationResult is ApiSuccess<List<DeclarationLookup>>) {
      model = model.copyWith(exploitationTypes: exploitationResult.data);
    }

    _lookups = model;
    emit(DeclarationLookupsLoaded(model));
  }
}
