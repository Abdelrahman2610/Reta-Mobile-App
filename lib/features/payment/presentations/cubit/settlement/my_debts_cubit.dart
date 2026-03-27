import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';
import 'package:reta/features/payment/data/models/my_debts_declaration_model.dart';

import '../../../data/models/debts_filter.dart';

part 'my_debts_cubit_state.dart';

class MyDebtsCubit extends Cubit<MyDebtsState> {
  MyDebtsCubit() : super(MyDebtsInitial());

  Future<void> fetchDeclarations({DebtsFilterData? filter}) async {
    emit(MyDebtsLoading());

    final result = await safeApiCall(() async {
      final queryParams = <String, dynamic>{};

      if (filter?.declarationNumber?.isNotEmpty == true) {
        queryParams['declaration_number'] = filter!.declarationNumber;
      }

      if (filter?.declarationType != null && filter!.declarationType != 'all') {
        queryParams['declaration_type_id'] = filter.declarationType;
      }

      if (filter?.dateFrom != null) {
        queryParams['from_date'] = _formatDate(filter!.dateFrom!);
      }

      if (filter?.dateTo != null) {
        queryParams['to_date'] = _formatDate(filter!.dateTo!);
      }

      if (filter?.statusId != null && filter!.statusId.toString() != 'all') {
        queryParams['status'] = filter.statusId;
      }

      final response = await DioClient.instance.dio.get(
        ApiConstants.settlementOfDebts,
        queryParameters: queryParams,
      );

      final list = response.data['data'] as List;
      final total = response.data['meta']['total'] as int;
      return (
        declarations: list
            .map((e) => MyDebtsDeclarationModel.fromJson(e))
            .toList(),
        total: total,
      );
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          MyDebtsSuccess(declarations: data.declarations, total: data.total),
        );
      case ApiError(:final message):
        emit(MyDebtsError(message));
    }
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
