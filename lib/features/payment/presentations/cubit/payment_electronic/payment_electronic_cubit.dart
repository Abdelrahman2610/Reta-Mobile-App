import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';

import '../../../data/models/payment_electronic_data.dart';

part 'payment_electronic_state.dart';

class PaymentElectronicCubit extends Cubit<PaymentElectronicState> {
  PaymentElectronicCubit() : super(PaymentElectronicInitial());

  Future<void> initiatePayment(int claimId) async {
    emit(PaymentElectronicLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.post(
        ApiConstants.initialPayment(claimId),
      );
      return PaymentElectronicData.fromJson(response.data['data']);
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(PaymentElectronicSuccess(data));
      case ApiError(:final message):
        emit(PaymentElectronicError(message));
    }
  }
}
