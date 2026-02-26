import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ════════════════════════════════════════════════════════════════════════════
//  Base URL — change this if the server changes
// ════════════════════════════════════════════════════════════════════════════
const String kBaseUrl =
    'http://dev-rta-services.etax.com.eg/reta-services/public';

// ════════════════════════════════════════════════════════════════════════════
//  Token storage helpers
// ════════════════════════════════════════════════════════════════════════════
class TokenStorage {
  static const _key = 'auth_token';

  static Future<void> save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  static Future<String?> get() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  A simple wrapper around http.Response so every API call returns the same
//  shape: either ApiSuccess(data) or ApiError(message).
// ════════════════════════════════════════════════════════════════════════════
sealed class ApiResult<T> {}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  ApiSuccess(this.data);
}

class ApiError<T> extends ApiResult<T> {
  final String message;
  ApiError(this.message);
}

// ════════════════════════════════════════════════════════════════════════════
//  Low-level HTTP helpers
// ════════════════════════════════════════════════════════════════════════════
class ApiClient {
  // ── JSON POST ─────────────────────────────────────────────────────────────
  static Future<ApiResult<Map<String, dynamic>>> postJson({
    required String path,
    required Map<String, dynamic> body,
    bool requiresAuth = false,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (requiresAuth) {
        final token = await TokenStorage.get();
        if (token != null) headers['Authorization'] = 'Bearer $token';
      }

      final response = await http
          .post(
            Uri.parse('$kBaseUrl$path'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      return ApiError(_networkErrorMessage(e));
    }
  }

  // ── Multipart POST (for forms with file uploads) ──────────────────────────
  static Future<ApiResult<Map<String, dynamic>>> postMultipart({
    required String path,
    required Map<String, String> fields,
    Map<String, File>? files, // key = field name, value = file
    bool requiresAuth = false,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$kBaseUrl$path'),
      );

      request.headers['Accept'] = 'application/json';

      if (requiresAuth) {
        final token = await TokenStorage.get();
        if (token != null) {
          request.headers['Authorization'] = 'Bearer $token';
        }
      }

      request.fields.addAll(fields);

      if (files != null) {
        for (final entry in files.entries) {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value.path),
          );
        }
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      return ApiError(_networkErrorMessage(e));
    }
  }

  // ── GET ───────────────────────────────────────────────────────────────────
  static Future<ApiResult<dynamic>> get({
    required String path,
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      final headers = {'Accept': 'application/json'};

      if (requiresAuth) {
        final token = await TokenStorage.get();
        if (token != null) headers['Authorization'] = 'Bearer $token';
      }

      final uri = Uri.parse(
        '$kBaseUrl$path',
      ).replace(queryParameters: queryParams);

      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      return ApiError(_networkErrorMessage(e));
    }
  }

  // ── Internal helpers ──────────────────────────────────────────────────────
  static ApiResult<Map<String, dynamic>> _handleResponse(
    http.Response response,
  ) {
    try {
      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiSuccess(decoded as Map<String, dynamic>);
      }

      // Try to extract a readable error message from the response body
      String message = 'حدث خطأ غير متوقع (${response.statusCode})';
      if (decoded is Map) {
        message =
            decoded['message']?.toString() ??
            decoded['error']?.toString() ??
            message;
      }
      return ApiError(message);
    } catch (_) {
      return ApiError('فشل في قراءة استجابة الخادم (${response.statusCode})');
    }
  }

  static String _networkErrorMessage(Object e) {
    if (e is SocketException) return 'لا يوجد اتصال بالإنترنت';
    if (e.toString().contains('TimeoutException')) return 'انتهت مهلة الاتصال';
    return 'خطأ في الشبكة: $e';
  }
}
