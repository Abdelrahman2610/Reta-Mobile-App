import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';

import '../../../data/models/payment_under_account_model.dart';

part 'payment_under_account_state.dart';

class PaymentUnderAccountCubit extends Cubit<PaymentUnderAccountState> {
  PaymentUnderAccountCubit() : super(PaymentUnderAccountInitial());

  Future<void> fetchDeclarations() async {
    emit(PaymentUnderAccountLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.paymentUnderAccountList,
      );
      final list = response.data as List;
      return list.map((e) => PaymentUnderAccountModel.fromJson(e)).toList();
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(PaymentUnderAccountSuccess(data));
      case ApiError(:final message):
        emit(PaymentUnderAccountError(message));
    }
  }
}
