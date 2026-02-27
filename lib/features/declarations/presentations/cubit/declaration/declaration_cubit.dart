import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/api_result.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../data/models/declaration_model.dart';
import 'declaration_states.dart';

class DeclarationCubit extends Cubit<DeclarationState> {
  DeclarationCubit() : super(DeclarationListInitial());

  List<DeclarationModel>? _declarationList;

  List<DeclarationModel>? get declarationList => _declarationList;

  Future<void> fetchList() async {
    emit(DeclarationListLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.declarations,
      );
      return declarationListFromJson(response.data['data']);
    });

    switch (result) {
      case ApiSuccess(:final data):
        _declarationList = data;
        emit(DeclarationListLoaded(data));
      case ApiError(:final message):
        emit(DeclarationListError(message));
    }
  }
}
