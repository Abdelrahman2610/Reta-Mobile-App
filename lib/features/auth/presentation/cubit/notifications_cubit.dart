import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/features/auth/data/models/notification_model.dart';
import 'package:reta/features/auth/data/repositories/notifications_repository.dart';

// ── State ─────────────────────────────────────────────────────────────────────

enum NotificationsStatus { initial, loading, loaded, error }

class NotificationsState extends Equatable {
  final List<NotificationModel> notifications;
  final NotificationsStatus status;
  final String? errorMessage;

  const NotificationsState({
    this.notifications = const [],
    this.status = NotificationsStatus.initial,
    this.errorMessage,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationsState copyWith({
    List<NotificationModel>? notifications,
    NotificationsStatus? status,
    String? errorMessage,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [notifications, status, errorMessage];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsCubit({NotificationsRepository? repository})
    : _repository = repository ?? NotificationsRepository(),
      super(const NotificationsState());

  Future<void> fetchNotifications() async {
    emit(state.copyWith(status: NotificationsStatus.loading));

    final result = await _repository.getNotifications();

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(
            notifications: data,
            status: NotificationsStatus.loaded,
          ),
        );
      case ApiError(:final message):
        emit(
          state.copyWith(
            status: NotificationsStatus.error,
            errorMessage: message,
          ),
        );
    }
  }

  Future<void> markAsRead(String id) async {
    // Optimistic update first
    final updated = state.notifications.map((n) {
      return n.id == id ? n.copyWith(isRead: true) : n;
    }).toList();
    emit(state.copyWith(notifications: updated));

    // Fire and forget — if it fails, we don't roll back (UX stays clean)
    await _repository.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    // Optimistic update first
    final updated = state.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    emit(state.copyWith(notifications: updated));

    await _repository.markAllAsRead();
  }

  Future<void> refresh() => fetchNotifications();
}
