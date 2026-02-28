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
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiMGU2N2I0NjE0NmNiYWUzYzE1M2UzNTFiMjQ4YWUwYzM2MTcwZDQ3OTJkYWNiMjI1NDZiY2UxNGJhZTQ2ZTIzZDk5NjYxMjg1MmVkNTRlNzgiLCJpYXQiOjE3NzIzMDYxMjIuMDc3NzEsIm5iZiI6MTc3MjMwNjEyMi4wNzc3MTMsImV4cCI6MTc3MjQ3ODkyMi4wNTYyNjIsInN1YiI6IjEiLCJzY29wZXMiOltdfQ.Zm8y9iuuJc6WHGlFcNI30w8sCS4k6720iNRFw6oBa19jV8CqgcGLsyAs-BEHWDHwRyQlbCM6xcx6LRaHkcw8jPEKIPVpwhKk_8S1Tjw3hHv5mWrcRrcQwmEVxGu0T2r02AV3TIAmEHST6TIUnTYcnZPEosmfUgDyL8fn0xm9q0ErL810o9fXXfy-qn6eKAeRCNZbTfkgzkSTDhQziOp636Atm--XNHLcLLEsiC_1NJn134yAWZKQBc0fO8AlmoYvL7a19bwzYZ_F81gE5Sfzc9BsZbyR-F3-_HJTjWgc27f2wbvjc0bEQGppL3xwBYb_UF9E2rvylxs1t4801ZIuOlQamMUQp2twGUl2rbEBQ0kzGzxW29KFv8ORRKVHwVGQyRNjWBZh65c7KLHxULgcjBI7U8WYtemoxV4FwmkJ9TygKubyBVMNxxm14HfI2b8YNbReCH0WKBUOsOVHPzQ68NkOycW7ctJMVPQFQC9BAbe8CbtC9xvMjTQuPMuoLgydpSWLyVsVZtsA1BJGENmQsoDP_7XCJifP-08SdSBWeTeSEW9mpgP1_8AOrZDtL9w3m8zlFABts52ZEQW4XatXx2EjS2z3NJ9u3R6lmFpQXdRP-NdfVlSlycDuR_-fM9oDOloBk3a_NXsy--7mDjZxIkV3B5UMBR2fMnHIkgNXuyw";
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
    print('✗ ${err.toString()} ${err.requestOptions.uri}');
    handler.next(err);
  }
}
