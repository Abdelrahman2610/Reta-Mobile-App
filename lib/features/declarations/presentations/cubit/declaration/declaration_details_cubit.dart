import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/api_result.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../data/models/declaration_details_model.dart';
import 'declaration_details_states.dart';

class DeclarationDetailsCubit extends Cubit<DeclarationDetailsStates> {
  final String declarationId;

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
      return DeclarationDetailsModel.fromJson(response.data['data']);
    });

    switch (result) {
      case ApiSuccess(:final data):
        _detailsModel = data;
        emit(DeclarationDetailsLoaded(data));
      case ApiError(:final message):
        emit(DeclarationDetailsError(message));
    }
  }
}
