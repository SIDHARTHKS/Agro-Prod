class NotificationModel {
  final String title;
  final String token;
  final String message;
  final String status;
  final String date;
  final String category;
  final String priority;
  final bool isApproved;

  NotificationModel({
    required this.title,
    required this.token,
    required this.message,
    required this.status,
    required this.date,
    required this.category,
    required this.priority,
    required this.isApproved,
  });
}
