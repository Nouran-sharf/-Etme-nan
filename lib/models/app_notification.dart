/// Types of booking-related notifications generated during demo interactions
enum NotificationType {
  bookingConfirmed,
  bookingRescheduled,
  bookingCancelled,
  statusSimulated,
  reviewSubmitted,
}

/// Notification model representing booking-related events in Sara's demo session.
/// Generated strictly from user actions taken during the active demo session.
class AppNotification {
  final String id;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final DateTime timestamp;
  final String? appointmentId;
  final NotificationType type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    required this.timestamp,
    this.appointmentId,
    required this.type,
    this.isRead = false,
  });

  String getTitle(bool isArabic) => isArabic ? titleAr : titleEn;
  String getBody(bool isArabic) => isArabic ? bodyAr : bodyEn;

  Map<String, dynamic> toJson() => {
        'id': id,
        'titleAr': titleAr,
        'titleEn': titleEn,
        'bodyAr': bodyAr,
        'bodyEn': bodyEn,
        'timestamp': timestamp.toIso8601String(),
        'appointmentId': appointmentId,
        'type': type.name,
        'isRead': isRead,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      titleAr: json['titleAr'] as String,
      titleEn: json['titleEn'] as String,
      bodyAr: json['bodyAr'] as String,
      bodyEn: json['bodyEn'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      appointmentId: json['appointmentId'] as String?,
      type: NotificationType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => NotificationType.bookingConfirmed,
      ),
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}
