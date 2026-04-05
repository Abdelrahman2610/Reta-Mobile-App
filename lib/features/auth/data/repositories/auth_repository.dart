import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';
import 'package:reta/features/auth/data/models/edit_password_response.dart';
import 'package:reta/features/auth/data/models/edit_profile_response.dart';
import 'package:reta/features/auth/data/models/login_response.dart';
import 'package:reta/features/auth/data/models/otp_response.dart';
import 'package:reta/features/auth/data/models/register_request.dart';
import 'package:reta/features/auth/data/models/user_models.dart';

class AuthRepository {
  final Dio _dio = DioClient.instance.dio;

  Future<ApiResult<LoginResponse>> loginWithMobile({
    required String mobile,
    required String password,
  }) async {
    return _login(
      body: {'login_type': 'mobile', 'mobile': mobile, 'password': password},
    );
  }

  Future<ApiResult<LoginResponse>> loginWithNationalId({
    required String nationalId,
    required String password,
  }) async {
    return _login(
      body: {
        'login_type': 'national_id',
        'mobile': '',
        'name': nationalId,
        'password': password,
      },
    );
  }

  Future<ApiResult<LoginResponse>> _login({
    required Map<String, dynamic> body,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.post(ApiConstants.login, data: body);
      final loginResponse = LoginResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (loginResponse.accessToken != null) {
        await DioClient.saveToken(loginResponse.accessToken!);
      }

      return loginResponse;
    });
  }

  Future<ApiResult<RegisterOtpResponse>> sendRegisterOtp({
    required RegisterRequest request,
    File? nationalIdFile,
    bool isForeign = false,
  }) async {
    return safeApiCall(() async {
      final fields = request.toFormFields();
      final formMap = <String, dynamic>{...fields};

      if (nationalIdFile != null) {
        final fileKey = isForeign ? 'passport_num_file' : 'national_id_file';
        formMap[fileKey] = await MultipartFile.fromFile(
          nationalIdFile.path,
          filename: nationalIdFile.path.split('/').last,
        );
      }

      log('=== REGISTER REQUEST DEBUG ===');
      log('isForeign: $isForeign');
      log('Form fields sent:');
      formMap.forEach((key, value) {
        if (value is MultipartFile) {
          log('  $key: [FILE] ${value.filename}');
        } else {
          log('  $key: $value');
        }
      });
      log('==============================');

      final response = await _dio.post(
        ApiConstants.registerSendOtp,
        data: FormData.fromMap(formMap),
      );

      log('=== REGISTER RESPONSE ===');
      log('Status: ${response.statusCode}');
      log('Body: ${response.data}');
      log('=========================');

      return RegisterOtpResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    });
  }

  Future<ApiResult<ConfirmOtpResponse>> confirmRegisterOtp({
    required ConfirmOtpRequest request,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.post(
        ApiConstants.registerConfirmOtp,
        data: request.toJson(),
      );
      return ConfirmOtpResponse.fromJson(response.data as Map<String, dynamic>);
    });
  }

  Future<ApiResult<Map<String, dynamic>>> forgotPasswordByPhone({
    required String mobile,
  }) async {
    return safeApiCall(() async {
      log('[Repo] forgotPasswordByPhone REQUEST → mobile: $mobile');

      final response = await _dio.post(
        ApiConstants.forgotPasswordPhone,
        data: {'mobile': mobile},
      );

      final rawData = response.data;
      log('[Repo] forgotPasswordByPhone RAW response: $rawData');

      if (rawData == null || rawData is! Map<String, dynamic>) {
        return {'ok': false, 'message': 'حدث خطأ غير متوقع، حاول مرة أخرى'};
      }

      final inner = rawData['data'];
      log('[Repo] forgotPasswordByPhone inner data: $inner');

      if (inner == null || inner is! Map<String, dynamic>) {
        return {
          'ok': rawData['ok'] ?? false,
          'message': rawData['message']?.toString() ?? 'حدث خطأ غير متوقع',
          'error': rawData['error'],
        };
      }

      log('[Repo] forgotPasswordByPhone returning inner: $inner');
      return inner;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> confirmForgotPasswordOtp({
    required String userId,
    required String mobile,
    required String token,
    required String otp,
  }) async {
    return safeApiCall(() async {
      log('[Repo] confirmForgotPasswordOtp REQUEST →');
      log('   user_id: $userId');
      log('   mobile: $mobile');
      log('   token: $token');
      log('   otp: $otp');
      log('   context: forgot_password');

      final response = await _dio.post(
        ApiConstants.resetPasswordOtp,
        data: {
          'token': token,
          'otp': otp,
          'mobile': mobile,
          'user_id': userId,
          'context': 'forgot_password',
        },
      );

      log('[Repo] confirmForgotPasswordOtp RAW response: ${response.data}');
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> generateResetToken({
    required String mobile,
  }) async {
    return safeApiCall(() async {
      log('[Repo] generateResetToken REQUEST → mobile: $mobile');

      final response = await _dio.post(
        ApiConstants.generateTokenForOtp,
        data: {'mobile': mobile},
      );

      log('[Repo] generateResetToken RAW response: ${response.data}');
      log(
        '[Repo] generateResetToken ALL keys: ${(response.data as Map?)?.keys.toList()}',
      );
      log(
        '[Repo] generateResetToken reset_token value: ${response.data?['reset_token']}',
      );
      log('[Repo] generateResetToken token value: ${response.data?['token']}');
      log('[Repo] generateResetToken data[data]: ${response.data?['data']}');

      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> checkResetPasswordValidity({
    required String token,
    required String mobile,
  }) async {
    return safeApiCall(() async {
      log('[Repo] checkResetPasswordValidity REQUEST → mobile: $mobile');
      final response = await _dio.post(
        ApiConstants.checkResetPasswordValidity,
        data: {'token': token, 'mobile': mobile},
      );
      log('[Repo] checkResetPasswordValidity RAW response: ${response.data}');
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> resetPassword({
    required String token,
    required String password,
    required String passwordConfirmation,
    required String mobile,
  }) async {
    try {
      log('[Repo] resetPassword REQUEST →');
      log('   token: $token');
      log('   mobile: "$mobile"');
      log('   password length: ${password.length}');

      final response = await _dio.post(
        ApiConstants.resetPassword,
        data: {
          'token': token,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'mobile': mobile,
        },
      );

      log('[Repo] resetPassword RAW response: ${response.data}');
      return ApiSuccess(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        log(
          '[Repo] resetPassword → 401 received, treating as success (backend known issue)',
        );
        return const ApiSuccess({'ok': true});
      }
      log(
        '[Repo] resetPassword error → ${e.response?.statusCode}: ${e.response?.data}',
      );
      return ApiError(
        e.response?.data?['message']?.toString() ?? 'حدث خطأ غير متوقع',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<ApiResult<Map<String, dynamic>>> forgotPasswordByEmail({
    required String email,
  }) async {
    return safeApiCall(() async {
      log('[Repo] forgotPasswordByEmail REQUEST → email: $email');

      final response = await _dio.post(
        ApiConstants.forgotPasswordEmail,
        data: {'email': email},
      );

      log('[Repo] forgotPasswordByEmail RAW response: ${response.data}');
      return response.data as Map<String, dynamic>;
    });
  }

  Future<void> logout() async {
    await DioClient.clearToken();
  }

  Future<bool> isLoggedIn() => DioClient.isLoggedIn();

  Future<ApiResult<UserModel>> getUserProfile() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.userProfile);
      try {
        return UserModel.fromProfileResponse(
          response.data as Map<String, dynamic>,
        );
      } catch (e) {
        log('UserModel.fromProfileResponse crashed: $e');
        rethrow;
      }
    });
  }

  Future<ApiResult<Map<String, dynamic>>> deleteAccount() async {
    return safeApiCall(() async {
      final response = await _dio.post('/delete-account');
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<EditProfileResponse>> editProfile({
    String? mobile,
    String? email,
    String? nationalId,
    String? passportNum,
    required String nationalityCode,
    File? idFile,
    bool isEgyptian = true,
    bool docUploaded = false,
    bool docDeleted = false,
  }) async {
    return safeApiCall(() async {
      final body = <String, dynamic>{
        'nationality_code': nationalityCode,
        'doc_uploaded': docUploaded.toString(),
        'doc_deleted': docDeleted.toString(),
        if (mobile != null) 'mobile': mobile,
        if (email != null) 'email': email,
        if (nationalId != null) 'national_id': nationalId,
        if (passportNum != null) 'passport_num': passportNum,
      };

      if (idFile != null) {
        final fileKey = isEgyptian ? 'national_id_file' : 'passport_num_file';
        body[fileKey] = await MultipartFile.fromFile(
          idFile.path,
          filename: idFile.path.split('/').last,
        );
        body['doc_uploaded'] = 'true';
      }

      log('FORM FIELDS: ${body.keys.toList()}');
      log('FILE PATH: ${idFile?.path}');
      log('FILE EXISTS: ${await idFile?.exists()}');

      final response = await _dio.post(
        ApiConstants.editProfile,
        data: FormData.fromMap(body),
      );

      log('EDIT PROFILE RESPONSE: ${response.data}');
      return EditProfileResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    });
  }

  Future<ApiResult<Map<String, dynamic>>> confirmPhoneUpdate({
    required String token,
    required String otp,
    required String mobile,
    required String userId,
    String context = 'update_user_data',
  }) async {
    return safeApiCall(() async {
      final response = await _dio.post(
        ApiConstants.validatePhoneConfirmOtp,
        data: FormData.fromMap({
          'token': token,
          'otp': otp,
          'mobile': mobile,
          'user_id': userId,
          'context': context,
        }),
      );
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<EditPasswordResponse>> editPassword({
    required String currentPassword,
    required String password,
    required String passwordConfirm,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.post(
        ApiConstants.editpassword,
        data: {
          'current_password': currentPassword,
          'password': password,
          'password_confirm': passwordConfirm,
        },
      );
      return EditPasswordResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    });
  }

  Future<ApiResult<RegisterOtpResponse>> resendOtpForUnverifiedUser({
    required String mobile,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.post(
        ApiConstants.validatePhoneSendOtp,
        data: {'mobile': mobile},
      );
      log('[Repo] resendOtpForUnverifiedUser response: ${response.data}');
      return RegisterOtpResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    });
  }
}
