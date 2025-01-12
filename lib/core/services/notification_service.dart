enum NotificationType {
  eventReminder,
  responseReminder,
  eventUpdate,
  waitlistUpdate,
  adminNotification
}

class Notification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final Map<String, dynamic>? data;
  final bool isRead;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.data,
    this.isRead = false,
  });
}

abstract class NotificationService {
  Future<void> sendNotification(Notification notification);
  Future<void> sendEventReminder(String eventId, List<String> userIds);
  Future<void> sendResponseReminder(String eventId, List<String> userIds);
  Future<void> markAsRead(String notificationId);
  Future<List<Notification>> getUserNotifications(String userId);
  Stream<List<Notification>> userNotificationsStream(String userId);
}
