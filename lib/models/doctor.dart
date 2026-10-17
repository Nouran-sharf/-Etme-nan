class Doctor {
  final String id;
  final String name;
  final String specialty;
  final int experienceYears;
  final double consultationFee;
  final double rating;
  final String biography;
  final List<String> availableDays;
  final List<String> availableTimeSlots;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experienceYears,
    required this.consultationFee,
    required this.rating,
    required this.biography,
    required this.availableDays,
    required this.availableTimeSlots,
  });
}