/// Status of an appointment
enum AppointmentStatus {
  confirmed,
  completed,
  cancelled,
  pending,
  postponed,
  noShow,
}

/// Appointment model for in-memory and persisted prototype bookings.
class Appointment {
  final String id;
  final String doctorId;
  final String serviceId;
  final String centerId;
  final String patientName;
  final DateTime date;
  final String timeSlot;
  final AppointmentStatus status;
  final DateTime createdAt;
  final DateTime? originalDate;
  final String? originalTimeSlot;
  final String? notes;

  const Appointment({
    required this.id,
    required this.doctorId,
    required this.serviceId,
    this.centerId = 'center_1',
    required this.patientName,
    required this.date,
    required this.timeSlot,
    this.status = AppointmentStatus.confirmed,
    required this.createdAt,
    this.originalDate,
    this.originalTimeSlot,
    this.notes,
  });

  /// Check if the appointment is active and upcoming (confirmed, pending, or postponed)
  bool get isActiveUpcoming =>
      status == AppointmentStatus.confirmed ||
      status == AppointmentStatus.pending ||
      status == AppointmentStatus.postponed;

  bool get canBeRescheduled => isActiveUpcoming;
  bool get canBeCancelled => isActiveUpcoming;

  bool get isConfirmed => status == AppointmentStatus.confirmed;
  bool get isCompleted => status == AppointmentStatus.completed;
  bool get isCancelled => status == AppointmentStatus.cancelled;
  bool get isPending => status == AppointmentStatus.pending;
  bool get isPostponed => status == AppointmentStatus.postponed;
  bool get isNoShow => status == AppointmentStatus.noShow;

  /// Create a copy with modified fields
  Appointment copyWith({
    String? id,
    String? doctorId,
    String? serviceId,
    String? centerId,
    String? patientName,
    DateTime? date,
    String? timeSlot,
    AppointmentStatus? status,
    DateTime? createdAt,
    DateTime? originalDate,
    String? originalTimeSlot,
    String? notes,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      serviceId: serviceId ?? this.serviceId,
      centerId: centerId ?? this.centerId,
      patientName: patientName ?? this.patientName,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      originalDate: originalDate ?? this.originalDate,
      originalTimeSlot: originalTimeSlot ?? this.originalTimeSlot,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctorId': doctorId,
        'serviceId': serviceId,
        'centerId': centerId,
        'patientName': patientName,
        'date': date.toIso8601String(),
        'timeSlot': timeSlot,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'originalDate': originalDate?.toIso8601String(),
        'originalTimeSlot': originalTimeSlot,
        'notes': notes,
      };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json['id'] as String,
        doctorId: json['doctorId'] as String,
        serviceId: json['serviceId'] as String,
        centerId: (json['centerId'] as String?) ?? 'center_1',
        patientName: json['patientName'] as String,
        date: DateTime.parse(json['date'] as String),
        timeSlot: json['timeSlot'] as String,
        status: AppointmentStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => AppointmentStatus.confirmed,
        ),
        createdAt: DateTime.parse(json['createdAt'] as String),
        originalDate: json['originalDate'] != null
            ? DateTime.parse(json['originalDate'] as String)
            : null,
        originalTimeSlot: json['originalTimeSlot'] as String?,
        notes: json['notes'] as String?,
      );
}
