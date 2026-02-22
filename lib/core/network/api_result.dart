import 'package:dio/dio.dart';

/// Every repository method returns ApiResult.
/// Use pattern matching or [when] to handle success/failure.
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
  const ApiError(this.message, {this.statusCode});
}

/// Wraps a Dio call and converts [DioException] into [ApiError].
Future<ApiResult<T>> safeApiCall<T>(Future<T> Function() call) async {
  try {
    final result = await call();
    return ApiSuccess(result);
  } on DioException catch (e) {
    return ApiError(_extractMessage(e), statusCode: e.response?.statusCode);
  } catch (e) {
    return ApiError(e.toString());
  }
}

String _extractMessage(DioException e) {
  // Try to read the API's error message
  try {
    final data = e.response?.data;
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          e.message ??
          'حدث خطأ غير متوقع';
    }
  } catch (_) {}

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return 'انتهت مهلة الاتصال، تحقق من الشبكة';
    case DioExceptionType.connectionError:
      return 'تعذر الاتصال بالخادم';
    default:
      return e.message ?? 'حدث خطأ غير متوقع';
  }
}
