import 'package:auth_firebase/data/models/notifications.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}


class LoadNotifications extends NotificationEvent {
  final String userRole;

  const LoadNotifications([this.userRole = 'all']);

  @override
  List<Object?> get props => [userRole];
}

class AddNotification extends NotificationEvent {
  final AppNotification notification;

  const AddNotification(this.notification);

  @override
  List<Object?> get props => [notification];
}

class MarkNotificationRead extends NotificationEvent {
  final String notificationId;

  const MarkNotificationRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class DeleteNotification extends NotificationEvent {
  final String notificationId;

  const DeleteNotification(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}
