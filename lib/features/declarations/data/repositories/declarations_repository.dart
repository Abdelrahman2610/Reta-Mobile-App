import 'package:dio/dio.dart';
import '/core/network/api_constants.dart';
import '/core/network/api_result.dart';
import '/core/network/dio_client.dart';

class DeclarationsRepository {
  final Dio _dio = DioClient.instance.dio;

  // ── List / Fetch ──────────────────────────────────────────

  /// Get all declarations for the logged-in user.
  /// Optional filters: [status], [declarationNumber], [declarationTypeId],
  /// [fromDate], [toDate] (format: 'YYYY-MM-DD').
  Future<ApiResult<Map<String, dynamic>>> getDeclarations({
    int? status,
    String? declarationNumber,
    int? declarationTypeId,
    String? fromDate,
    String? toDate,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.get(
        ApiConstants.declarations,
        queryParameters: {
          if (status != null) 'status': status,
          if (declarationNumber != null)
            'declaration_number': declarationNumber,
          if (declarationTypeId != null)
            'declaration_type_id': declarationTypeId,
          if (fromDate != null) 'from_date': fromDate,
          if (toDate != null) 'to_date': toDate,
        },
      );
      return response.data as Map<String, dynamic>;
    });
  }

  /// Get a single declaration with full details.
  Future<ApiResult<Map<String, dynamic>>> getDeclarationById(
    int id, {
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

  // ── Create ────────────────────────────────────────────────

  /// Creates a new declaration with one property unit.
  ///
  /// [body] — the complete JSON map (taxpayer + unit data).
  /// Build this map from your form state before calling this method.
  ///
  /// Returns the created declaration data including [declaration_id]
  /// and the unit ID which you must save for subsequent updates.
  Future<ApiResult<Map<String, dynamic>>> createDeclaration(
    Map<String, dynamic> body,
  ) async {
    return safeApiCall(() async {
      final response = await _dio.post(ApiConstants.declarations, data: body);
      return response.data as Map<String, dynamic>;
    });
  }

  // ── Update ────────────────────────────────────────────────

  /// Updates an existing declaration.
  ///
  /// To update an existing unit, include `"id": unitId` in the unit object.
  /// To add a new unit to the declaration, omit the `"id"` field.
  Future<ApiResult<Map<String, dynamic>>> updateDeclaration(
    int declarationId,
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

  // ── Submit ────────────────────────────────────────────────

  /// Submits a completed declaration for review.
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

  // ── Delete Units ──────────────────────────────────────────

  /// Removes a specific property unit from a declaration.
  ///
  /// [unitType] values:
  ///   'residential' | 'commercial' | 'administrative' | 'service' |
  ///   'serviceFacility' | 'industrial' | 'production' | 'petroleum' |
  ///   'mine' | 'fixedinstallation' | 'vacant' | 'hotel'
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

  // ── Wallet ────────────────────────────────────────────────

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

  // ── Under Declaration Properties ──────────────────────────

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

  // ── Settlement ────────────────────────────────────────────

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
