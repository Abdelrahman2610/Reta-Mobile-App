import 'package:dio/dio.dart';
import '/core/network/api_constants.dart';
import '/core/network/api_result.dart';
import '/core/network/dio_client.dart';

class ClaimsRepository {
  final Dio _dio = DioClient.instance.dio;

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

  Future<ApiResult<Map<String, dynamic>>> getClaimDetail(int claimId) async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.claimDetail(claimId));
      return response.data as Map<String, dynamic>;
    });
  }

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

  Future<ApiResult<Map<String, dynamic>>> cancelClaim(int claimId) async {
    return safeApiCall(() async {
      final response = await _dio.delete(ApiConstants.cancelClaim(claimId));
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> initiatePayment(int claimId) async {
    return safeApiCall(() async {
      final response = await _dio.post(ApiConstants.initialPayment(claimId));
      return response.data as Map<String, dynamic>;
    });
  }
}
