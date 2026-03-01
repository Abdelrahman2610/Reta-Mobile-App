import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../pages/notifications_page.dart';

// ── State ─────────────────────────────────────────────────────────────────────

class NotificationsState extends Equatable {
  final List<NotificationItem> notifications;

  const NotificationsState({this.notifications = const []});

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationsState copyWith({List<NotificationItem>? notifications}) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [notifications];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit()
    : super(
        const NotificationsState(
          notifications: [
            NotificationItem(
              id: '1',
              title: 'تأكيد استلام الإقرار',
              body:
                  'تم استلام إقرارك الضريبي بنجاح، وجار مراجعته من قبل المختصين بمصلحة الضرائب العقارية.',
              dateTime: '١٢ مارس ٢٠٢٦ - ١٠:٣٠ صباحاً',
            ),
            NotificationItem(
              id: '2',
              title: 'إتاحة سداد مبلغ تحت الحساب',
              body:
                  'يمكنك الآن سداد مبلغ تحت الحساب الضريبي رقم (123456) من خلال وسائل الدفع المتاحة.',
              dateTime: '١٢ مارس ٢٠٢٦ - ١٠:٣٠ صباحاً',
            ),
            NotificationItem(
              id: '3',
              title: 'مطلوب استيفاء بيانات',
              body:
                  'يرجى استكمال بعض البيانات أو المرفقات الخاصة بإقراراتك لضمان استكمال إجراءات المراجعة.',
              dateTime: '١٢ مارس ٢٠٢٦ - ١٠:٣٠ صباحاً',
              isRead: true,
            ),
            NotificationItem(
              id: '4',
              title: 'انتهاء فترة تقديم الإقرار',
              body:
                  'يوم واحد فقط على انتهاء فترة تقديم الإقرار الضريبي لهذا العام.',
              dateTime: '١٢ مارس ٢٠٢٦ - ١٠:٣٠ صباحاً',
              isRead: true,
            ),
            NotificationItem(
              id: '5',
              title: 'تحديث حالة الإقرار',
              body:
                  'تم تحديث حالة الإقرار الضريبي الخاص بك إلى "قيد المراجعة".',
              dateTime: '١٢ مارس ٢٠٢٦ - ١٠:٣٠ صباحاً',
              isRead: true,
            ),
          ],
        ),
      );

  void markAsRead(String id) {
    final updated = state.notifications.map((n) {
      return n.id == id
          ? NotificationItem(
              id: n.id,
              title: n.title,
              body: n.body,
              dateTime: n.dateTime,
              isRead: true,
            )
          : n;
    }).toList();
    emit(state.copyWith(notifications: updated));
  }

  void markAllAsRead() {
    final updated = state.notifications
        .map(
          (n) => NotificationItem(
            id: n.id,
            title: n.title,
            body: n.body,
            dateTime: n.dateTime,
            isRead: true,
          ),
        )
        .toList();
    emit(state.copyWith(notifications: updated));
  }

  // TODO: replace with real API call
  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // emit new notifications from API here
  }
}
