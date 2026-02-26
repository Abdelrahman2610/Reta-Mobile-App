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
        request: false,
        requestBody: false,
        responseBody: false,
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
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiZmU2YTgzMDEwYmRjNzBkMzdjMTY3NWYxNTMzNmYyY2Q3YjFmOWYzOWUzMGFhYTUxODQyMDdjMTllMTQ1ZGIyNGZmYmUyZTdmMTJiNTY3NmIiLCJpYXQiOjE3NzIxMzc1MjkuMTUwMzEzLCJuYmYiOjE3NzIxMzc1MjkuMTUwMzE2LCJleHAiOjE3NzIzMTAzMjkuMTI5ODIyLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.DVkQQ37hwDbzAg6BiPWF4D7lcujP0QH4eLwH1fZol8csFDVTPKCi_NicqPt_epkIv2NnXoitTSMEtHFBVq8wj8ceYAVAzXm6aNPRWpyVdNEJT0ehBKQGUXSGgwvC6AsJXVJ5yneu1FAdcIWafDm0fHSyOz2gwKgvWky0PCBj3fcxzF2JaUOxeg3Qj1eNr202CsXgM4Plkf2Ka8IN2YGllfwgsUgcdDiynV21umxhczQoAXQzFfgcws_Zh0Ck4X2Sj6aV1TGTZ5oic592UtspR4r2qz67BYlPI8yWGPaZd2KrPTzE74k-N5AyfGWE1UIvafkWvxna7KUjI8oP26oaT1RMMpRyWhS-tuvUUHbeSMvriElwezJQqEX_bpF24bm7u7Obb_ChTKexGEatBLlAqT1C8zwfK33fi95dfRtFn7kjdS3nn6kXsg1NGZVXHI-3fJ93iYWyOdrmtmJ2wYcpElgLfl0SDOHbKN36udcJtfu0MhbyTE-XanQIwK2cyLfThB4NDf_DU3nJtxqDT75uszc7-U5mH7SmubXXyh_HUYghN7PZ4-maNyvPpeG7DV7R7acQsFqM4PGnF-q37bJA2pujhGwuvBQCnhKlc3Adh45Cc-gY3Ndnm_bHuXpZ2ibgVhyJKidYt0p-yKXaUrNMeVFp_50nwnNJDrKp9vaEicY";
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
