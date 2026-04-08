import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/presentation/pages/help_support_page.dart';
import '../../features/auth/presentation/pages/main_page.dart';
import '../helpers/runtime_data.dart';
import 'api_constants.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio dio;

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'access_token';

  DioClient._() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );

    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //       client.badCertificateCallback =
    //           (X509Certificate cert, String host, int port) => true;
    //       return client;
    //     };

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestUrl: true,
        requestHeader: true,
        requestBody: false,
        responseUrl: true,
        responseHeader: true,
        responseBody: false,
      ),
    );

    dio.interceptors.addAll([
      _AuthInterceptor(_storage, _tokenKey),
      _LoggingInterceptor(),
    ]);
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }
}

// ─── Auth Interceptor ─────────────────────────────────────────────────────────
class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final String _tokenKey;

  _AuthInterceptor(this._storage, this._tokenKey);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: _tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      log("token: $token");
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // _storage.delete(key: _tokenKey);
    }
    handler.next(err);
  }
}

// ─── Logging Interceptor ──────────────────────────────────────────────────────
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('→ [${options.method}] ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('← [${response.statusCode}] ${response.requestOptions.uri}');
    log('← Body: [${jsonEncode(response.data)}]');
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    log('✗ [${err.response?.statusCode}] ${err.requestOptions.uri}');
    log('Error body: ${err.response?.data}');

    if (err.response?.statusCode == 401) {
      if (await DioClient.isLoggedIn()) {
        await DioClient.clearToken();
        Navigator.of(
          RuntimeData.getCurrentContext()!,
          rootNavigator: true,
        ).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainPage(isLoggedIn: false)),
          (route) => false,
        );
        showError(
          RuntimeData.getCurrentContext()!,
          "قم بتسجيل الدخول لحسابك وحاول مرة أخرى",
        );
      } else {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}

// ─── Public Dio Client (no auth token) ───────────────────────────────────────
class PublicDioClient {
  static final Dio dio = _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(_LoggingInterceptor());

    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //       client.badCertificateCallback =
    //           (X509Certificate cert, String host, int port) => true;
    //       return client;
    //     };

    return dio;
  }
}
