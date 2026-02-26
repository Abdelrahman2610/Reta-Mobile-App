import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/core/network/api_constants.dart';
import '/core/network/api_result.dart';
import '/core/network/dio_client.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';

class AuthRepository {
  final Dio _dio = DioClient.instance.dio;

  Future<ApiResult<LoginResponse>> login({
    required String loginValue,
    required String password,
    String loginType = 'national_id',
  }) async {
    return safeApiCall(() async {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'login_value': loginValue,
          'password': password,
          'login_type': loginType,
        },
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      if (loginResponse.accessToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', loginResponse.accessToken!);
      }

      return loginResponse;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> sendRegisterOtp({
    required RegisterRequest request,
    File? nationalIdFile,
  }) async {
    return safeApiCall(() async {
      final formData = FormData.fromMap({
        'first_name': request.firstName,
        'last_name': request.lastName,
        'email': request.email,
        'mobile': request.mobile,
        'password': request.password,
        'password_confirm': request.passwordConfirm,
        'national_id': request.nationalId,
        'nationality_code': request.nationalityCode,
        'gender': request.gender,
        'birth_place': request.birthPlace,
        'birth_date': request.birthDate,
        if (nationalIdFile != null)
          'national_id_file': await MultipartFile.fromFile(
            nationalIdFile.path,
            filename: 'national_id.jpg',
          ),
      });

      final response = await _dio.post(
        ApiConstants.registerSendOtp,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> confirmOtp({
    required String token,
    required String otp,
  }) async {
    return safeApiCall(() async {
      final formData = FormData.fromMap({'token': token, 'otp': otp});

      final response = await _dio.post(
        ApiConstants.registerConfirmOtp,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response.data as Map<String, dynamic>;
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return token != null && token.isNotEmpty;
  }

  Future<ApiResult<LoginResponse>> loginWithNationalId({
    required String nationalId,
    required String passportNumber,
    required String password,
  }) async {
    return await login(
      loginValue: nationalId,

      password: password,
      loginType: 'national_id',
    );
  }
}
