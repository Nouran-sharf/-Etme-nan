import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../models/medical_center.dart';
import '../models/review.dart';
import '../data/mock_data.dart';

/// Central state management for the Etmaenan application.
/// Manages language, local persistence, appointments with 6 statuses,
/// medical center linkages, dynamic rating calculation, and reviews.
class AppState extends ChangeNotifier {
  static const String _prefKeyAppointments = 'etmaenan_appointments_v1';
  static const String _prefKeyReviews = 'etmaenan_reviews_v1';
  static const String _prefKeyLocale = 'etmaenan_locale_v1';

  // Localization state (Default is Arabic)
  Locale _locale = const Locale('ar');
  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  // Appointments and Reviews state
  List<Appointment> _appointments = [];
  List<Review> _reviews = [];
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<Appointment> get appointments => List.unmodifiable(_appointments);
  List<Review> get reviews => List.unmodifiable(_reviews);
  List<MedicalCenter> get medicalCenters => mockMedicalCenters;
  List<Doctor> get doctors => mockDoctors;

  AppState() {
    _initializeData();
  }

  /// Initialize state from SharedPreferences or seed defaults
  Future<void> _initializeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load locale
      final savedLocale = prefs.getString(_prefKeyLocale);
      if (savedLocale != null && savedLocale.isNotEmpty) {
        _locale = Locale(savedLocale);
      }

      // Load appointments
      final savedAptsJson = prefs.getString(_prefKeyAppointments);
      if (savedAptsJson != null && savedAptsJson.isNotEmpty) {
        final List decoded = jsonDecode(savedAptsJson) as List;
        _appointments = decoded
            .map((item) => Appointment.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        _appointments = generateInitialAppointments();
        await _saveAppointmentsToDisk();
      }

      // Load reviews
      final savedReviewsJson = prefs.getString(_prefKeyReviews);
      if (savedReviewsJson != null && savedReviewsJson.isNotEmpty) {
        final List decoded = jsonDecode(savedReviewsJson) as List;
        _reviews = decoded
            .map((item) => Review.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        _reviews = generateInitialReviews();
        await _saveReviewsToDisk();
      }
    } catch (e) {
      debugPrint('Error initializing local preferences: $e');
      _appointments = generateInitialAppointments();
      _reviews = generateInitialReviews();
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _saveAppointmentsToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr =
          jsonEncode(_appointments.map((a) => a.toJson()).toList());
      await prefs.setString(_prefKeyAppointments, jsonStr);
    } catch (e) {
      debugPrint('Error saving appointments to disk: $e');
    }
  }

  Future<void> _saveReviewsToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(_reviews.map((r) => r.toJson()).toList());
      await prefs.setString(_prefKeyReviews, jsonStr);
    } catch (e) {
      debugPrint('Error saving reviews to disk: $e');
    }
  }

  Future<void> _saveLocaleToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKeyLocale, _locale.languageCode);
    } catch (e) {
      debugPrint('Error saving locale to disk: $e');
    }
  }

  /// Reset all stored demo data back to factory mock state
  Future<void> resetDemoData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefKeyAppointments);
      await prefs.remove(_prefKeyReviews);
    } catch (e) {
      debugPrint('Error clearing preferences: $e');
    }

    _appointments = generateInitialAppointments();
    _reviews = generateInitialReviews();
    await _saveAppointmentsToDisk();
    await _saveReviewsToDisk();
    notifyListeners();
  }

  // ==================== LOCALIZATION ====================

  /// Toggle language between Arabic ('ar') and English ('en')
  void toggleLocale() {
    _locale =
        _locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    _saveLocaleToDisk();
    notifyListeners();
  }

  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      _saveLocaleToDisk();
      notifyListeners();
    }
  }

  // ==================== LOOKUPS & CENTERS ====================

  Doctor? getDoctorById(String id) {
    try {
      return mockDoctors.firstWhere((doc) => doc.id == id);
    } catch (_) {
      return null;
    }
  }

  MedicalCenter? getCenterById(String id) {
    try {
      return mockMedicalCenters.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Doctor> getDoctorsByCenterId(String centerId) {
    return mockDoctors.where((d) => d.centerId == centerId).toList();
  }

  // ==================== DYNAMIC RATINGS ====================

  /// Compute live doctor average rating combining initial seed and user reviews
  double getDoctorAverageRating(String doctorId) {
    final doctor = getDoctorById(doctorId);
    if (doctor == null) return 5.0;

    final docReviews = _reviews.where((r) => r.doctorId == doctorId).toList();
    final double userSum = docReviews.fold(0.0, (prev, r) => prev + r.doctorRating);
    return doctor.getAverageRating(
      userReviewsSum: userSum,
      userReviewsCount: docReviews.length,
    );
  }

  int getDoctorReviewCount(String doctorId) {
    final doctor = getDoctorById(doctorId);
    if (doctor == null) return 0;
    final docReviews = _reviews.where((r) => r.doctorId == doctorId);
    return doctor.getTotalReviewsCount(userReviewsCount: docReviews.length);
  }

  /// Compute live medical center average rating combining initial seed and user reviews
  double getCenterAverageRating(String centerId) {
    final center = getCenterById(centerId);
    if (center == null) return 5.0;

    final centerReviews = _reviews.where((r) => r.centerId == centerId).toList();
    final double userSum = centerReviews.fold(0.0, (prev, r) => prev + r.centerRating);
    return center.getAverageRating(
      userReviewsSum: userSum,
      userReviewsCount: centerReviews.length,
    );
  }

  int getCenterReviewCount(String centerId) {
    final center = getCenterById(centerId);
    if (center == null) return 0;
    final centerReviews = _reviews.where((r) => r.centerId == centerId);
    return center.getTotalReviewsCount(userReviewsCount: centerReviews.length);
  }

  // ==================== REVIEWS ====================

  Review? getReviewForAppointment(String appointmentId) {
    try {
      return _reviews.firstWhere((r) => r.appointmentId == appointmentId);
    } catch (_) {
      return null;
    }
  }

  bool isAppointmentReviewed(String appointmentId) {
    return _reviews.any((r) => r.appointmentId == appointmentId);
  }

  /// Add or update a review (no double counting on edit)
  Future<void> submitOrUpdateReview(Review review) async {
    final existingIndex =
        _reviews.indexWhere((r) => r.appointmentId == review.appointmentId);
    if (existingIndex >= 0) {
      _reviews[existingIndex] = review;
    } else {
      _reviews.add(review);
    }
    await _saveReviewsToDisk();
    notifyListeners();
  }

  // ==================== SLOT AVAILABILITY ====================

  /// Check if a specific time slot is already booked by another active appointment.
  /// (Only confirmed, pending, and postponed occupy time slots!)
  bool isSlotBooked(String doctorId, DateTime date, String slot,
      {String? excludeAppointmentId}) {
    return _appointments.any((apt) {
      if (apt.id == excludeAppointmentId) return false;
      if (!apt.isActiveUpcoming) return false;
      if (apt.doctorId != doctorId) return false;
      return apt.date.year == date.year &&
          apt.date.month == date.month &&
          apt.date.day == date.day &&
          apt.timeSlot == slot;
    });
  }

  /// Check if a time slot has already passed for the current date
  bool isSlotPast(DateTime date, String slot) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate.isBefore(today)) return true;
    if (targetDate.isAfter(today)) return false;

    try {
      final parts = slot.trim().split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);
      final isPM = parts.length > 1 && parts[1].toUpperCase() == 'PM';

      if (isPM && hour < 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;

      final slotDateTime =
          DateTime(today.year, today.month, today.day, hour, minute);
      return slotDateTime.isBefore(now);
    } catch (_) {
      return false;
    }
  }

  bool isSlotAvailable(String doctorId, DateTime date, String slot,
      {String? excludeAppointmentId}) {
    if (isSlotPast(date, slot)) return false;
    if (isSlotBooked(doctorId, date, slot,
        excludeAppointmentId: excludeAppointmentId)) {
      return false;
    }
    return true;
  }

  // ==================== APPOINTMENT MUTATIONS ====================

  /// Book a new appointment
  Future<bool> bookAppointment(Appointment appointment) async {
    if (!isSlotAvailable(
        appointment.doctorId, appointment.date, appointment.timeSlot)) {
      return false;
    }

    _appointments.insert(0, appointment);
    await _saveAppointmentsToDisk();
    notifyListeners();
    return true;
  }

  /// Reschedule an existing appointment (marked as postponed with original date noted)
  Future<bool> rescheduleAppointment(
      String appointmentId, DateTime newDate, String newTimeSlot) async {
    final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
    if (index == -1) return false;

    final existing = _appointments[index];

    if (!isSlotAvailable(existing.doctorId, newDate, newTimeSlot,
        excludeAppointmentId: appointmentId)) {
      return false;
    }

    _appointments[index] = existing.copyWith(
      date: newDate,
      timeSlot: newTimeSlot,
      status: AppointmentStatus.postponed,
      originalDate: existing.date,
      originalTimeSlot: existing.timeSlot,
    );

    await _saveAppointmentsToDisk();
    notifyListeners();
    return true;
  }

  /// Cancel an appointment (releasing its slot immediately for future bookings)
  Future<void> cancelAppointment(String appointmentId) async {
    final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        status: AppointmentStatus.cancelled,
      );
      await _saveAppointmentsToDisk();
      notifyListeners();
    }
  }

  // ==================== APPOINTMENT QUERIES ====================

  /// Retrieve the single next upcoming appointment (for Home screen)
  Appointment? getNextUpcomingAppointment() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final upcoming = _appointments.where((apt) {
      if (!apt.isActiveUpcoming) return false;
      final aptDate = DateTime(apt.date.year, apt.date.month, apt.date.day);
      if (aptDate.isBefore(today)) return false;
      if (aptDate.isAtSameMomentAs(today) && isSlotPast(apt.date, apt.timeSlot)) {
        return false;
      }
      return true;
    }).toList();

    if (upcoming.isEmpty) return null;

    upcoming.sort((a, b) => a.date.compareTo(b.date));
    return upcoming.first;
  }

  /// Retrieve all upcoming active appointments (confirmed, pending, postponed)
  List<Appointment> getUpcomingAppointments() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final upcoming = _appointments.where((apt) {
      if (!apt.isActiveUpcoming) return false;
      final aptDate = DateTime(apt.date.year, apt.date.month, apt.date.day);
      if (aptDate.isBefore(today)) return false;
      if (aptDate.isAtSameMomentAs(today) && isSlotPast(apt.date, apt.timeSlot)) {
        return false;
      }
      return true;
    }).toList();

    upcoming.sort((a, b) => a.date.compareTo(b.date));
    return upcoming;
  }

  /// Retrieve completed appointments (eligible for reviews)
  List<Appointment> getCompletedAppointments() {
    final completed =
        _appointments.where((apt) => apt.isCompleted).toList();
    completed.sort((a, b) => b.date.compareTo(a.date));
    return completed;
  }

  /// Retrieve history appointments (cancelled, no-show, or past unconfirmed)
  List<Appointment> getCancelledAndOtherAppointments() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final history = _appointments.where((apt) {
      if (apt.isCancelled || apt.isNoShow) return true;
      if (apt.isCompleted) return false;
      final aptDate = DateTime(apt.date.year, apt.date.month, apt.date.day);
      if (aptDate.isBefore(today)) return true;
      if (aptDate.isAtSameMomentAs(today) && isSlotPast(apt.date, apt.timeSlot)) {
        return true;
      }
      return false;
    }).toList();

    history.sort((a, b) => b.date.compareTo(a.date));
    return history;
  }

  static AppState of(BuildContext context) => AppStateProvider.of(context);
}

/// InheritedNotifier wrapper for AppState
class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState appState,
    required super.child,
  }) : super(notifier: appState);

  static AppState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'No AppStateProvider found in context');
    return provider!.notifier!;
  }
}
