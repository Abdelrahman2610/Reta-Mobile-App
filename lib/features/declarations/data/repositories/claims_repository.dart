import 'package:dio/dio.dart';
import '/core/network/api_constants.dart';
import '/core/network/api_result.dart';
import '/core/network/dio_client.dart';

class ClaimsRepository {
  final Dio _dio = DioClient.instance.dio;

  /// List claims for a declaration with optional filters.
  Future<ApiResult<Map<String, dynamic>>> getClaimsList(
    int declarationId, {
    String? claimNumber,
    String? dateFrom,
    String? dateTo,
    int? status,
    int? perPage,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.get(
        ApiConstants.claimsList(declarationId),
        queryParameters: {
          if (claimNumber != null) 'claim_number': claimNumber,
          if (dateFrom != null) 'date_from': dateFrom,
          if (dateTo != null) 'date_to': dateTo,
          if (status != null) 'status': status,
          if (perPage != null) 'per_page': perPage,
        },
      );
      return response.data as Map<String, dynamic>;
    });
  }

  /// Get detail of a single claim.
  Future<ApiResult<Map<String, dynamic>>> getClaimDetail(int claimId) async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.claimDetail(claimId));
      return response.data as Map<String, dynamic>;
    });
  }

  /// Get payment transaction details for a claim.
  Future<ApiResult<Map<String, dynamic>>> getClaimTransactionDetails(
    int claimId,
  ) async {
    return safeApiCall(() async {
      final response = await _dio.get(
        ApiConstants.claimTransactionDetails(claimId),
      );
      return response.data as Map<String, dynamic>;
    });
  }

  /// Creates a new claim for the given properties.
  ///
  /// [propertyData] — list of maps, each with:
  ///   { 'id': int, 'property_type_id': int, 'paid_by_wallet': bool }
  Future<ApiResult<Map<String, dynamic>>> storeClaim({
    required int declarationId,
    required List<Map<String, dynamic>> propertyData,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.post(
        ApiConstants.storeClaim,
        data: {'declaration_id': declarationId, 'property_data': propertyData},
      );
      return response.data as Map<String, dynamic>;
    });
  }

  /// Creates a claim for "taxpayer's knowledge" settlement-of-debts flow.
  /// Each property item can include [amount] and [debtSupportingDocuments].
  Future<ApiResult<Map<String, dynamic>>> storeTaxpayerKnowledgeClaim({
    required int declarationId,
    required List<Map<String, dynamic>> propertyData,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.post(
        '/declaration-system/declarations/taxpayers-knowledge/claim',
        data: {'declaration_id': declarationId, 'property_data': propertyData},
      );
      return response.data as Map<String, dynamic>;
    });
  }

  /// Cancels (deletes) a claim.
  Future<ApiResult<Map<String, dynamic>>> cancelClaim(int claimId) async {
    return safeApiCall(() async {
      final response = await _dio.delete(ApiConstants.cancelClaim(claimId));
      return response.data as Map<String, dynamic>;
    });
  }

  /// Initiates an online payment for a claim.
  Future<ApiResult<Map<String, dynamic>>> initiatePayment(int claimId) async {
    return safeApiCall(() async {
      final response = await _dio.post(ApiConstants.initialPayment(claimId));
      return response.data as Map<String, dynamic>;
    });
  }
}
