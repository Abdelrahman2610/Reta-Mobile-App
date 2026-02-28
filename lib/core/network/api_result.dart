import 'package:dio/dio.dart';

sealed class ApiResult<T> {
  const ApiResult();
}

final class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

final class ApiError<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;

  final Map<String, List<String>>? validationErrors;

  const ApiError(this.message, {this.statusCode, this.validationErrors});

  bool get isValidationError => statusCode == 422;

  bool get isUnauthorized => statusCode == 401;

  String? fieldError(String field) => validationErrors?[field]?.firstOrNull;
}

Future<ApiResult<T>> safeApiCall<T>(Future<T> Function() call) async {
  try {
    final result = await call();
    return ApiSuccess(result);
  } on DioException catch (e) {
    return ApiError(
      _extractMessage(e),
      statusCode: e.response?.statusCode,
      validationErrors: _extractValidationErrors(e),
    );
  } catch (e) {
    return ApiError(e.toString());
  }
}

String _extractMessage(DioException e) {
  try {
    final data = e.response?.data;
    if (data is Map) {
      final msg = data['message']?.toString();
      if (msg != null && msg.isNotEmpty) return msg;

      final error = data['error']?.toString();
      if (error != null && error.isNotEmpty) return error;
      final errors = data['errors'];
      if (errors is Map) {
        final firstField = errors.values.firstOrNull;
        if (firstField is List && firstField.isNotEmpty) {
          return firstField.first.toString();
        }
      }
    }
  } catch (_) {}

  return switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout => 'انتهت مهلة الاتصال، تحقق من الشبكة',
    DioExceptionType.connectionError => 'تعذر الاتصال بالخادم',
    _ => e.message ?? 'حدث خطأ غير متوقع',
  };
}

Map<String, List<String>>? _extractValidationErrors(DioException e) {
  try {
    final data = e.response?.data;
    if (data is Map && data['errors'] is Map) {
      final raw = data['errors'] as Map;
      return raw.map(
        (key, value) => MapEntry(
          key.toString(),
          (value is List) ? value.map((v) => v.toString()).toList() : [],
        ),
      );
    }
  } catch (_) {}
  return null;
}
