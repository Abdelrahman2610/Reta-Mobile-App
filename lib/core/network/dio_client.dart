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

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
    dio.interceptors.addAll([_AuthInterceptor(), _LoggingInterceptor()]);
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('access_token');
    final token =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiMDExYzAzNDEwZGMzMGEwOTk3NzE2M2M0ZTA5Y2UxYzdjODUyNjYxNTJhYzFlYzg0YzVlODdlZWY0NzY0OTEzNjc3MDg1Y2M2MGQ0Yjg2NTYiLCJpYXQiOjE3NzIyMTA3NjUuMDY1NTUzLCJuYmYiOjE3NzIyMTA3NjUuMDY1NTY2LCJleHAiOjE3NzIzODM1NjUuMDUxMjA3LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.VvUoxAkcZhZ97XEKJkf2nJOk3hqMYxi5Hbjs1_1B3tKHrgq10aD_TLY54GOSckR7w4Tn7WK6ax4zOg8XdJmesSaXx8t2vrHff22LsRp5wcVOd0pgwWNO_IrJVSHymCSpWF5Hb6aZvS8ritcyV_UxXPTc13XVaG7bzTujsj9KWm3iHYMygOw0iFWW3vs-FW9hoWKJKGzBMaY9H-twKcxhSRSXnObUOJk-Wxzipfk4KbVzAUY-BgMQM2Obc0JFfsd9RrOsz9aFJZzhn94IYUngrH6-2iTtyUDjDuPXpZcvT_arAvApfN6rQtCXKLQhnqAICiw6-N7D-OKDNHDd8dc_UsZ_5L3ITV0t_KdE6PHyFN9s2jZELpik8bu4x4g2QwJanWj6rVxy13OFxwFaZm7AWuKWiGLHmzSMPdqWazTvuSnNesYHXmLzeW4kElFzEeQ_2l3ye_4aRroe-9AhHTlBUJniFyKCjMjqWQqSLSn9KLEJ7OE_S8KP2msFk0ZDARYhKX02XVCbOqPST4eUCQE2Q_hnCi-BnagmqvvwI-_aq2KB2TM3qo0KMkAQJglE0SJV7qku2FMxpzXEXzb5wZYZ1g44f2wP0rQCtvteD3Xje8oxCniTj8OdmN1y_7T9R8s49bA-1OMEZX228erpEE2QR2vwp5iIEyzPHGVHYpA7zNU";
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      SharedPreferences.getInstance().then((p) => p.remove('access_token'));
    }
    handler.next(err);
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('← ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('✗ ${err.response?.statusCode} ${err.requestOptions.uri}');
    handler.next(err);
  }
}
