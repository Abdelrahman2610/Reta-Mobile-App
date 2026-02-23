import 'dart:io';
import 'package:dio/dio.dart';
import '/core/network/api_constants.dart';
import '/core/network/api_result.dart';
import '/core/network/dio_client.dart';
import '../models/uploaded_file.dart';

class FileUploadRepository {
  final Dio _dio = DioClient.instance.dio;

  Future<ApiResult<UploadedFile>> uploadFile({
    required File file,
    required String label,
    void Function(int sent, int total)? onProgress,
  }) async {
    return safeApiCall(() async {
      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
        'label': label,
      });

      final response = await _dio.post(
        ApiConstants.uploadAttachment,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
        onSendProgress: onProgress,
      );

      return UploadedFile.fromJson(response.data);
    });
  }
}
