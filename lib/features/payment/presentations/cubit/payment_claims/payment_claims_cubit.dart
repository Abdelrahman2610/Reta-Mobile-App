import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';
import 'package:reta/features/payment/data/models/payment_claim.dart';

import '../../../../../core/helpers/app_enum.dart';
import '../../../data/models/payment_filter.dart';

part 'payment_claims_state.dart';

class PaymentClaimsCubit extends Cubit<PaymentClaimsState> {
  PaymentClaimsCubit() : super(PaymentClaimsInitial());

  String? _declarationId;
  ClaimsSource _source = ClaimsSource.declaration;

  Future<void> fetchClaims({
    String? declarationId,
    PaymentFilterData? filter,
    ClaimsSource source = ClaimsSource.declaration,
  }) async {
    _declarationId = declarationId;
    _source = source;

    if (declarationId != null) {
      await fetchDeclarationClaims(
        declarationId: declarationId,
        filter: filter,
        source: source,
      );
    } else {
      await _fetchAllClaims(filter: filter);
    }
  }

  Future<void> fetchDeclarationClaims({
    String? declarationId,
    PaymentFilterData? filter,
    ClaimsSource source = ClaimsSource.declaration,
  }) async {
    _declarationId = declarationId;
    _source = source;

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

      final endpoint = source == ClaimsSource.underDebt
          ? ApiConstants.underDebtClaimsList(int.parse(declarationId!))
          : ApiConstants.claimsList(int.parse(declarationId!));

      final response = await DioClient.instance.dio.get(
        endpoint,
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

  Future<void> _fetchAllClaims({PaymentFilterData? filter}) async {
    emit(PaymentClaimsLoading());

    final result = await safeApiCall(() async {
      final queryParams = <String, dynamic>{};

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
        ApiConstants.allClaimsList,
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

  Future<void> deleteClaim(int claimId) async {
    final result = await safeApiCall(() async {
      await DioClient.instance.dio.delete(
        '${ApiConstants.storeClaim}/$claimId',
      );
      return true;
    });

    switch (result) {
      case ApiSuccess():
        emit(PaymentClaimsDeleteSuccess());
        // refresh الـ list
        await fetchClaims(declarationId: _declarationId!, source: _source);
      case ApiError(:final message):
        emit(PaymentClaimsError(message));
    }
  }
}
