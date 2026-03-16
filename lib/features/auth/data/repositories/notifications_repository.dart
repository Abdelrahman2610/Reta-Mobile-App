import 'package:dio/dio.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';
import 'package:reta/features/auth/data/models/notification_model.dart';

class NotificationsRepository {
  final Dio _dio = DioClient.instance.dio;

  Future<ApiResult<List<NotificationModel>>> getNotifications() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.notifications);
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  Future<ApiResult<void>> markAsRead(String id) async {
    return safeApiCall(() async {
      await _dio.patch('${ApiConstants.notificationById(int.parse(id))}/read');
    });
  }

  Future<ApiResult<void>> markAllAsRead() async {
    return safeApiCall(() async {
      await _dio.patch(ApiConstants.notificationsReadAll);
    });
  }
}
