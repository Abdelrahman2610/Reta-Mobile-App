import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';
import 'package:reta/features/declarations/data/models/declaration_model.dart';

part 'payment_under_account_state.dart';

class PaymentUnderAccountCubit extends Cubit<PaymentUnderAccountState> {
  PaymentUnderAccountCubit() : super(PaymentUnderAccountInitial());

  Future<void> fetchDeclarations() async {
    emit(PaymentUnderAccountLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.declarations,
      );
      return declarationListFromJson(response.data['data']);
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(PaymentUnderAccountSuccess(data));
      case ApiError(:final message):
        emit(PaymentUnderAccountError(message));
    }
  }
}
