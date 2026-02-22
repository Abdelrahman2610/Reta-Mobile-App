import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio dio;

  DioClient._() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
    ]);
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }
}

/// Automatically attaches the Bearer token to every request.
class _AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 401 → token expired → clear stored token
    if (err.response?.statusCode == 401) {
      SharedPreferences.getInstance().then((p) => p.remove('access_token'));
    }
    handler.next(err);
  }
}

/// Logs every request & response in debug mode.
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    print('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print('← ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('✗ ${err.response?.statusCode} ${err.requestOptions.uri}');
    handler.next(err);
  }
}
