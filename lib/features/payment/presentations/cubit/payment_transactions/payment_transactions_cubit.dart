import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';
import 'package:reta/features/payment/data/models/payment_transaction_model.dart';

part 'payment_transactions_state.dart';

class PaymentTransactionsCubit extends Cubit<PaymentTransactionsState> {
  PaymentTransactionsCubit() : super(PaymentTransactionsInitial());

  Future<void> fetchTransactions(int claimId) async {
    emit(PaymentTransactionsLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.claimTransactionDetails(claimId),
      );
      final list = response.data['data'] as List;
      return list.map((e) => PaymentTransactionModel.fromJson(e)).toList();
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(PaymentTransactionsSuccess(data));
      case ApiError(:final message):
        emit(PaymentTransactionsError(message));
    }
  }
}
