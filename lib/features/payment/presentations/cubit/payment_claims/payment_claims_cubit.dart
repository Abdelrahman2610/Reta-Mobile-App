import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';
import 'package:reta/features/payment/data/models/payment_claim.dart';

import '../../../data/models/payment_filter.dart';

part 'payment_claims_state.dart';

class PaymentClaimsCubit extends Cubit<PaymentClaimsState> {
  PaymentClaimsCubit() : super(PaymentClaimsInitial());

  Future<void> fetchClaims(
    String declarationId, [
    PaymentFilterData? filter,
  ]) async {
    emit(PaymentClaimsLoading());

    final result = await safeApiCall(() async {
      final queryParams = <String, dynamic>{};

      if (filter?.procedureNumber?.isNotEmpty == true) {
        queryParams['procedure_number'] = filter!.procedureNumber;
      }

      if (filter?.claimNumber?.isNotEmpty == true) {
        queryParams['claim_number'] = filter!.claimNumber;
      }

      if (filter?.dateFrom != null) {
        queryParams['date_from'] = _formatDate(filter!.dateFrom!);
      }

      if (filter?.dateTo != null) {
        queryParams['date_to'] = _formatDate(filter!.dateTo!);
      }

      if (filter?.statusId != null && filter!.statusId.toString() != 'all') {
        queryParams['status'] = filter.statusId;
      }

      final response = await DioClient.instance.dio.get(
        ApiConstants.claimsList(int.parse(declarationId)),
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      final claimsData = response.data['data']['claims'];
      final list = claimsData['data'] as List;
      final total = claimsData['meta']['total'] as int;
      return (
        claims: list.map((e) => PaymentClaimModel.fromJson(e)).toList(),
        total: total,
      );
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(PaymentClaimsSuccess(claims: data.claims, total: data.total));
      case ApiError(:final message):
        emit(PaymentClaimsError(message));
    }
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
