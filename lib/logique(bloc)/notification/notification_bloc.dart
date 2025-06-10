// logique/bloc/notification/notification_bloc.dart
import 'package:auth_firebase/data/models/notifications.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';


class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final List<AppNotification> _notifications = [];

  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotifications>((event, emit) {
      emit(NotificationLoading());

      try {
        // Filtrer par role
        final filtered = _notifications.where((notif) =>
          notif.targetRole == 'all' || notif.targetRole == event.userRole).toList();
        
        emit(NotificationLoaded(filtered));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<AddNotification>((event, emit) {
      _notifications.add(event.notification);
      // Recharger la liste après ajout
      add(LoadNotifications(event.notification.targetRole));
    });

    on<MarkNotificationRead>((event, emit) {
      final index = _notifications.indexWhere((n) => n.id == event.notificationId);
      if (index != -1) {
        _notifications[index] = AppNotification(
          id: _notifications[index].id,
          title: _notifications[index].title,
          message: _notifications[index].message,
          targetRole: _notifications[index].targetRole,
          createdAt: _notifications[index].createdAt,
          isRead: true,
        );
        add(LoadNotifications(_notifications[index].targetRole));
      }
    });

    on<DeleteNotification>((event, emit) {
      _notifications.removeWhere((n) => n.id == event.notificationId);
      add(LoadNotifications('all')); // Reload global or adapt
    });
  }
}
