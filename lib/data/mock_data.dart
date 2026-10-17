import '../models/doctor.dart';

final List<Doctor> mockDoctors = [
  const Doctor(
    id: 'doc_1',
    name: 'Dr. Sarah Lee',
    specialty: 'Cardiology',
    experienceYears: 10,
    consultationFee: 95.0,
    rating: 4.9,
    biography:
        'Board-certified cardiologist specializing in preventive heart care, arrhythmia diagnostics, and holistic cardiovascular wellness.',
    availableDays: ['Mon', 'Wed', 'Fri'],
    availableTimeSlots: ['09:00 AM', '11:30 AM', '02:00 PM', '04:30 PM'],
  ),
  const Doctor(
    id: 'doc_2',
    name: 'Dr. Jonathan Miller',
    specialty: 'Dermatology',
    experienceYears: 10,
    consultationFee: 110.0,
    rating: 4.7,
    biography:
        'Senior clinical dermatologist focusing on skin regeneration, acne therapy, and non-invasive dermatological procedures.',
    availableDays: ['Tue', 'Wed', 'Thu'],
    availableTimeSlots: ['10:00 AM', '01:00 PM', '03:30 PM', '05:00 PM'],
  ),
  const Doctor(
    id: 'doc_3',
    name: 'Dr. Emily Watson',
    specialty: 'Pediatrics',
    experienceYears: 8,
    consultationFee: 75.0,
    rating: 4.9,
    biography:
        'Compassionate pediatric specialist dedicated to early childhood development, immunizations, and family nutrition.',
    availableDays: ['Mon', 'Tue', 'Thu'],
    availableTimeSlots: ['08:30 AM', '10:30 AM', '02:30 PM'],
  ),
  const Doctor(
    id: 'doc_4',
    name: 'Dr. David Kim',
    specialty: 'Neurology',
    experienceYears: 14,
    consultationFee: 130.0,
    rating: 4.8,
    biography:
        'Specialist in neurological disorders, sleep medicine, migraine relief, and cognitive health.',
    availableDays: ['Wed', 'Fri', 'Sat'],
    availableTimeSlots: ['11:00 AM', '01:30 PM', '04:00 PM'],
  ),
];