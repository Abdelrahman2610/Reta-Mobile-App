import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';

part 'payment_electronic_state.dart';

class PaymentElectronicCubit extends Cubit<PaymentElectronicState> {
  PaymentElectronicCubit() : super(PaymentElectronicInitial());

  Future<void> initiatePayment(int claimId) async {
    emit(PaymentElectronicLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.post(
        ApiConstants.initialPayment(claimId),
      );
      return response.data['data']['payment_gateway_url'] as String;
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(PaymentElectronicSuccess(data));
      case ApiError(:final message):
        emit(PaymentElectronicError(message));
    }
  }
}
