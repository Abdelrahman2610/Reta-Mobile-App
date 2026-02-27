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

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.allLookups,
      );
      return DeclarationLookupsModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    });

    switch (result) {
      case ApiSuccess(:final data):
        _lookups = data;
        emit(DeclarationLookupsLoaded(data));
      case ApiError(:final message):
        emit(DeclarationLookupsError(message));
    }
  }
}
