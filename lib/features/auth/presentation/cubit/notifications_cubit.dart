import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/widgets/notification_preferences_service.dart';
import 'package:reta/features/auth/data/models/notification_model.dart';
import 'package:reta/features/auth/data/repositories/notifications_repository.dart';

// ── State ─────────────────────────────────────────────────────────────────────

enum NotificationsStatus { initial, loading, loaded, error }

class NotificationsState extends Equatable {
  final List<NotificationModel> notifications;
  final NotificationsStatus status;
  final String? errorMessage;
  final bool notificationsEnabled;

  const NotificationsState({
    this.notifications = const [],
    this.status = NotificationsStatus.initial,
    this.errorMessage,
    this.notificationsEnabled = true,
  });

  /// Badge count is 0 when notifications are disabled
  int get unreadCount =>
      notificationsEnabled ? notifications.where((n) => !n.isRead).length : 0;

  NotificationsState copyWith({
    List<NotificationModel>? notifications,
    NotificationsStatus? status,
    String? errorMessage,
    bool? notificationsEnabled,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [
    notifications,
    status,
    errorMessage,
    notificationsEnabled,
  ];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;
  final NotificationPreferencesService _prefsService;

  NotificationsCubit({
    NotificationsRepository? repository,
    NotificationPreferencesService? prefsService,
  }) : _repository = repository ?? NotificationsRepository(),
       _prefsService = prefsService ?? NotificationPreferencesService(),
       super(const NotificationsState());

  /// Called on app start — loads saved preference, then fetches if enabled
  Future<void> fetchNotifications() async {
    final enabled = await _prefsService.isEnabled();
    emit(state.copyWith(notificationsEnabled: enabled));

    if (!enabled) return;

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

  /// Toggle from Settings — persists preference and refreshes if re-enabled
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefsService.setEnabled(enabled);
    emit(state.copyWith(notificationsEnabled: enabled));

    if (enabled) {
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
  }

  Future<void> markAsRead(String id) async {
    final updated = state.notifications
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList();
    emit(state.copyWith(notifications: updated));
    await _repository.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    final updated = state.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    emit(state.copyWith(notifications: updated));
    await _repository.markAllAsRead();
  }

  Future<void> refresh() => fetchNotifications();
}
