import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';
import 'package:reta/features/payment/data/models/payment_unit_item.dart';

part 'payment_info_state.dart';

class PaymentInfoCubit extends Cubit<PaymentInfoState> {
  PaymentInfoCubit() : super(PaymentInfoInitial());

  PaymentInfoResponse? _data;

  double totalRequired = 0;

  void toggleUnit(int index) {
    if (_data == null) return;
    _data!.units[index].isSelected = !_data!.units[index].isSelected;
    calculateTotalAmount();
    emit(PaymentInfoSuccess(_data!));
  }

  void toggleWallet(int index, bool value) {
    if (_data == null) return;
    _data!.units[index].isPaidByWallet = value;
    emit(PaymentInfoSuccess(_data!));
  }

  void calculateTotalAmount() {
    totalRequired =
        _data?.units
            .where((u) => u.isSelected)
            .fold(0.0, (sum, u) => (sum ?? 0) + (u.amountUnderPayment)) ??
        0;
  }

  Future<void> fetchUnits(String declarationId) async {
    emit(PaymentInfoLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.underDeclarationProperties(int.parse(declarationId)),
      );
      return PaymentInfoResponse.fromJson(response.data);
    });

    switch (result) {
      case ApiSuccess(:final data):
        _data = data;
        emit(PaymentInfoSuccess(data));
      case ApiError(:final message):
        emit(PaymentInfoError(message));
    }
  }

  Future<void> createClaim(String declarationId) async {
    if (_data == null) return;
    if (totalRequired == 0) return;

    emit(PaymentInfoLoading());

    final selectedUnits = _data!.units.where((u) => u.isSelected).toList();
    log('selectedUnits: $selectedUnits');

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.post(
        ApiConstants.storeClaim,
        data: {
          'declaration_id': int.parse(declarationId),
          'property_data': selectedUnits
              .map(
                (u) => {
                  'id': u.id,
                  'property_type_id': int.parse(u.propertyTypeId),
                  'paid_by_wallet': u.isPaidByWallet,
                },
              )
              .toList(),
        },
      );
      return response.data['message'] as String;
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(PaymentInfoClaimSuccess());
      case ApiError(:final message):
        emit(PaymentInfoError(message));
    }
  }
}
