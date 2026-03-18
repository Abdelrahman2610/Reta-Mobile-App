import 'package:dio/dio.dart';
import 'package:reta/core/network/api_constants.dart';

import '../network/api_result.dart';
import '../network/dio_client.dart';

class UploadedFileModel {
  final String originalFileName;
  final String path;
  final String fullUrl;

  UploadedFileModel({
    required this.originalFileName,
    required this.path,
    required this.fullUrl,
  });

  factory UploadedFileModel.fromJson(Map<String, dynamic> json) {
    return UploadedFileModel(
      originalFileName: json['original_file_name'],
      path: json['file_id'],
      fullUrl: json['full_url'],
    );
  }
}

class UploadService {
  UploadService._();
  static final instance = UploadService._();

  Future<ApiResult<UploadedFileModel>> uploadFile({
    required String filePath,
    required String label,
  }) async {
    return safeApiCall(() async {
      final fileName = filePath.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'label': label,
      });

      final response = await DioClient.instance.dio.post(
        ApiConstants.uploadAttachment,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return UploadedFileModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    });
  }
}
