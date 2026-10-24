/// Review model for completed appointments.
class Review {
  final String id;
  final String appointmentId;
  final String doctorId;
  final String centerId;
  final int doctorRating; // 1 to 5
  final int centerRating; // 1 to 5
  final int overallRating; // 1 to 5
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.appointmentId,
    required this.doctorId,
    required this.centerId,
    required this.doctorRating,
    required this.centerRating,
    required this.overallRating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'appointmentId': appointmentId,
        'doctorId': doctorId,
        'centerId': centerId,
        'doctorRating': doctorRating,
        'centerRating': centerRating,
        'overallRating': overallRating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'] as String,
        appointmentId: json['appointmentId'] as String,
        doctorId: json['doctorId'] as String,
        centerId: json['centerId'] as String,
        doctorRating: json['doctorRating'] as int,
        centerRating: json['centerRating'] as int,
        overallRating: json['overallRating'] as int,
        comment: (json['comment'] as String?) ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
