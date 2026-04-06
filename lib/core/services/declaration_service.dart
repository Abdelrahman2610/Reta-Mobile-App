import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';

class DeclarationService {
  DeclarationService._();
  static final instance = DeclarationService._();

  Future<ApiResult<Map<String, dynamic>>> createDeclaration(
    Map<dynamic, dynamic> payload, {
    required int declarationId,
  }) async {
    String _endPoint = ApiConstants.declarations;
    if (declarationId != -1) {
      _endPoint = '${ApiConstants.declarations}/$declarationId';
      return safeApiCall(() async {
        final response = await DioClient.instance.dio.put(
          _endPoint,
          data: payload,
        );
        return response.data as Map<String, dynamic>;
      });
    }
    return safeApiCall(() async {
      final response = await DioClient.instance.dio.post(
        _endPoint,
        data: payload,
      );
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> updateDeclaration(
    Map<dynamic, dynamic> payload, {
    required int declarationId,
    required int unitId,
  }) async {
    payload['unit']['id'] = unitId;
    return safeApiCall(() async {
      final response = await DioClient.instance.dio.put(
        '${ApiConstants.declarations}/$declarationId',
        data: payload,
      );
      return response.data as Map<String, dynamic>;
    });
  }
}
