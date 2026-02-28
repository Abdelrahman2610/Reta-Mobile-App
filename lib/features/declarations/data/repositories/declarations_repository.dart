import 'package:dio/dio.dart';

import '/core/network/api_constants.dart';
import '/core/network/api_result.dart';
import '/core/network/dio_client.dart';

class DeclarationsRepository {
  final Dio _dio = DioClient.instance.dio;

  Future<ApiResult<Map<String, dynamic>>> getDeclarations() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.declarations);
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> getDeclarationById(
    String id, {
    bool forEdit = false,
    int residentialPage = 1,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.get(
        ApiConstants.declarationById(id),
        queryParameters: {
          if (forEdit) 'for_edit': 'true',
          'residential_page': residentialPage,
        },
      );
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> createDeclaration(
    Map<String, dynamic> body,
  ) async {
    return safeApiCall(() async {
      final response = await _dio.post(ApiConstants.declarations, data: body);
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> updateDeclaration(
    String declarationId,
    Map<String, dynamic> body,
  ) async {
    return safeApiCall(() async {
      final response = await _dio.put(
        ApiConstants.declarationById(declarationId),
        data: body,
      );
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> submitDeclaration(
    int declarationId,
  ) async {
    return safeApiCall(() async {
      final response = await _dio.post(
        ApiConstants.submitDeclaration(declarationId),
      );
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> deleteUnit({
    required int declarationId,
    required String unitType,
    required int unitId,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.delete(
        ApiConstants.deleteUnit(declarationId, unitType, unitId),
      );
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> getWalletDetails(
    int declarationId,
  ) async {
    return safeApiCall(() async {
      final response = await _dio.get(
        ApiConstants.walletDetails(declarationId),
      );
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> getUnderDeclarationProperties(
    int declarationId,
  ) async {
    return safeApiCall(() async {
      final response = await _dio.get(
        ApiConstants.underDeclarationProperties(declarationId),
      );
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> getSettlementOfDebts({
    String? declarationNumber,
    int? status,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.get(
        ApiConstants.settlementOfDebts,
        queryParameters: {
          if (declarationNumber != null)
            'declaration_number': declarationNumber,
          if (status != null) 'status': status,
        },
      );
      return response.data as Map<String, dynamic>;
    });
  }
}
