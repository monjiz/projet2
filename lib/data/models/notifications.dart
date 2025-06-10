class AppNotification {
  final String id;
  final String title;
  final String message;
  final String targetRole; // 'client', 'worker', 'all'
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.targetRole,
    required this.createdAt,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'targetRole': targetRole,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      targetRole: map['targetRole'],
      createdAt: DateTime.parse(map['createdAt']),
      isRead: map['isRead'],
    );
  }
}
