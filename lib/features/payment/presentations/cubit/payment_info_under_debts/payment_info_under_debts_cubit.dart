import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';
import 'package:reta/features/payment/data/models/debt_unit_item.dart';

part 'payment_info_under_debts_state.dart';

class PaymentInfoUnderDebtsCubit extends Cubit<PaymentInfoUnderDebtsState> {
  PaymentInfoUnderDebtsCubit() : super(PaymentInfoUnderDebtsInitial());

  DebtUnitsResponse? _data;
  double totalRequired = 0;

  void toggleUnit(int index) {
    if (_data == null) return;
    _data!.units[index].isSelected = !_data!.units[index].isSelected;
    _calculateTotal();
    emit(PaymentInfoUnderDebtsSuccess(_data!));
  }

  void _calculateTotal() {
    totalRequired =
        _data?.units
            .where((u) => u.isSelected)
            .fold(
              0.0,
              (sum, u) =>
                  (sum ?? 0) + (double.tryParse(u.amountController.text) ?? 0),
            ) ??
        0;
  }

  void recalculate() {
    if (_data == null) return;
    _calculateTotal();
    emit(PaymentInfoUnderDebtsSuccess(_data!));
  }

  Future<void> fetchUnits(String declarationId) async {
    emit(PaymentInfoUnderDebtsLoading());

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.underDebtProperties(int.parse(declarationId)),
      );
      return DebtUnitsResponse.fromJson(response.data);
    });

    switch (result) {
      case ApiSuccess(:final data):
        _data = data;
        emit(PaymentInfoUnderDebtsSuccess(data));
      case ApiError(:final message):
        emit(PaymentInfoUnderDebtsError(message));
    }
  }

  Future<void> createClaim(String declarationId) async {
    if (_data == null || totalRequired == 0) return;

    emit(PaymentInfoUnderDebtsLoading());

    final selectedUnits = _data!.units.where((u) => u.isSelected).toList();

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.post(
        ApiConstants.taxpayersKnowledgeClaim,
        data: {
          'declaration_id': int.parse(declarationId),
          'property_data': selectedUnits
              .map(
                (u) => {
                  'id': u.id,
                  'property_type_id': int.parse(u.propertyTypeId),
                  'amount': double.tryParse(u.amountController.text) ?? 0,
                  'paid_by_wallet': false,
                },
              )
              .toList(),
        },
      );
      return response.data['message'] as String;
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(PaymentInfoUnderDebtsSuccess(_data!));
        await Future.delayed(const Duration(milliseconds: 300));
        emit(PaymentInfoUnderDebtsClaimSuccess());
      case ApiError(:final message):
        emit(PaymentInfoUnderDebtsSuccess(_data!));
        emit(PaymentInfoUnderDebtsError(message));
    }
  }

  @override
  Future<void> close() {
    _data?.units.forEach((u) => u.dispose());
    return super.close();
  }
}
