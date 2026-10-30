import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../models/medical_center.dart';
import '../models/review.dart';
import '../models/app_notification.dart';
import '../localization/app_translations.dart';
import '../data/mock_data.dart';

/// Central state management for the Etmaenan application.
/// Manages language, local persistence, appointments with 6 statuses,
/// medical center linkages, dynamic rating calculation, reviews,
/// live session notifications, and demo user authentication for Sara (ساره).
class AppState extends ChangeNotifier {
  static const String _prefKeyAppointments = 'etmaenan_demo_sara_appointments_v2';
  static const String _prefKeyReviews = 'etmaenan_demo_sara_reviews_v2';
  static const String _prefKeyNotifications = 'etmaenan_demo_sara_notifications_v2';
  static const String _prefKeyLocale = 'etmaenan_locale_v1';
  static const String _prefKeyIsLoggedIn = 'etmaenan_demo_sara_logged_in_v2';

  // Localization state (Default is Arabic)
  Locale _locale = const Locale('ar');
  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  // Demo user authentication state
  bool _isLoggedIn;
  bool get isLoggedIn => _isLoggedIn;
  bool get isDemoMode => true;

  // Demo persona identifiers
  String get currentUserName => isArabic ? 'ساره' : 'Sara';
  String get currentUserFullName => isArabic ? 'ساره خالد' : 'Sara Khaled';
  String get currentUserEmail => 'sara.demo@etmaenan.app';

  // Appointments, Reviews, and Session Notifications
  List<Appointment> _appointments = [];
  List<Review> _reviews = [];
  List<AppNotification> _notifications = [];
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<Appointment> get appointments => List.unmodifiable(_appointments);
  List<Review> get reviews => List.unmodifiable(_reviews);
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  List<MedicalCenter> get medicalCenters => mockMedicalCenters;
  List<Doctor> get doctors => mockDoctors;

  int get unreadNotificationsCount =>
      _notifications.where((n) => !n.isRead).length;

  AppState({bool initialLoggedIn = false}) : _isLoggedIn = initialLoggedIn {
    _initializeData();
  }

  /// Initialize state from SharedPreferences
  Future<void> _initializeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load locale
      final savedLocale = prefs.getString(_prefKeyLocale);
      if (savedLocale != null && savedLocale.isNotEmpty) {
        _locale = Locale(savedLocale);
      }

      // Load login state if not explicitly specified at construction
      if (prefs.containsKey(_prefKeyIsLoggedIn)) {
        _isLoggedIn = prefs.getBool(_prefKeyIsLoggedIn) ?? _isLoggedIn;
      }

      // Load appointments for Sara (starts empty on fresh demo sessions)
      final savedAptsJson = prefs.getString(_prefKeyAppointments);
      if (savedAptsJson != null && savedAptsJson.isNotEmpty) {
        final List decoded = jsonDecode(savedAptsJson) as List;
        _appointments = decoded
            .map((item) => Appointment.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        _appointments = [];
      }

      // Load reviews for Sara (starts empty on fresh demo sessions)
      final savedReviewsJson = prefs.getString(_prefKeyReviews);
      if (savedReviewsJson != null && savedReviewsJson.isNotEmpty) {
        final List decoded = jsonDecode(savedReviewsJson) as List;
        _reviews = decoded
            .map((item) => Review.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        _reviews = [];
      }

      // Load notifications for Sara (starts empty on fresh demo sessions)
      final savedNotifsJson = prefs.getString(_prefKeyNotifications);
      if (savedNotifsJson != null && savedNotifsJson.isNotEmpty) {
        final List decoded = jsonDecode(savedNotifsJson) as List;
        _notifications = decoded
            .map((item) =>
                AppNotification.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        _notifications = [];
      }
    } catch (e) {
      debugPrint('Error initializing local preferences: $e');
      _appointments = [];
      _reviews = [];
      _notifications = [];
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

  Future<void> _saveNotificationsToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr =
          jsonEncode(_notifications.map((n) => n.toJson()).toList());
      await prefs.setString(_prefKeyNotifications, jsonStr);
    } catch (e) {
      debugPrint('Error saving notifications to disk: $e');
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

  Future<void> _saveLoginStateToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKeyIsLoggedIn, _isLoggedIn);
    } catch (e) {
      debugPrint('Error saving login state to disk: $e');
    }
  }

  // ==================== AUTHENTICATION (DEMO) ====================

  /// Enter application as demo user Sara without credentials or backend check
  void loginAsDemoUser({bool persist = true}) {
    _isLoggedIn = true;
    if (persist) {
      _saveLoginStateToDisk();
    }
    notifyListeners();
  }

  /// Log out from demo session back to the Welcome/Auth screen
  void logout({bool persist = true}) {
    _isLoggedIn = false;
    if (persist) {
      _saveLoginStateToDisk();
    }
    notifyListeners();
  }

  /// Reset all stored demo data back to clean starting state:
  /// Clears Sara's appointments, reviews, and notifications.
  Future<void> resetDemoData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefKeyAppointments);
      await prefs.remove(_prefKeyReviews);
      await prefs.remove(_prefKeyNotifications);
    } catch (e) {
      debugPrint('Error clearing preferences: $e');
    }

    _appointments = [];
    _reviews = [];
    _notifications = [];
    await _saveAppointmentsToDisk();
    await _saveReviewsToDisk();
    await _saveNotificationsToDisk();
    notifyListeners();
  }

  // ==================== NOTIFICATIONS ====================

  /// Generate a booking-related notification during demo interactions
  void addNotification({
    required String titleAr,
    required String titleEn,
    required String bodyAr,
    required String bodyEn,
    required NotificationType type,
    String? appointmentId,
  }) {
    final notif = AppNotification(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      titleAr: titleAr,
      titleEn: titleEn,
      bodyAr: bodyAr,
      bodyEn: bodyEn,
      timestamp: DateTime.now(),
      appointmentId: appointmentId,
      type: type,
      isRead: false,
    );

    _notifications.insert(0, notif);
    _saveNotificationsToDisk();
    notifyListeners();
  }

  /// Mark all notifications as read
  void markAllNotificationsAsRead() {
    for (final notif in _notifications) {
      notif.isRead = true;
    }
    _saveNotificationsToDisk();
    notifyListeners();
  }

  /// Clear all notifications
  void clearNotifications() {
    _notifications.clear();
    _saveNotificationsToDisk();
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

  /// Compute live doctor average rating combining baseline seed and user reviews
  double getDoctorAverageRating(String doctorId) {
    final doctor = getDoctorById(doctorId);
    if (doctor == null) return 5.0;

    final docReviews = _reviews.where((r) => r.doctorId == doctorId).toList();
    final double userSum =
        docReviews.fold(0.0, (prev, r) => prev + r.doctorRating);
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

  /// Compute live medical center average rating combining baseline seed and user reviews
  double getCenterAverageRating(String centerId) {
    final center = getCenterById(centerId);
    if (center == null) return 5.0;

    final centerReviews =
        _reviews.where((r) => r.centerId == centerId).toList();
    final double userSum =
        centerReviews.fold(0.0, (prev, r) => prev + r.centerRating);
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
    final isNew = existingIndex < 0;

    if (!isNew) {
      _reviews[existingIndex] = review;
    } else {
      _reviews.add(review);
    }

    final doctor = getDoctorById(review.doctorId);
    final doctorName =
        doctor != null ? doctor.getName(isArabic) : review.doctorId;

    addNotification(
      titleAr: isNew ? 'شكراً لتقييمكِ' : 'تم تحديث التقييم',
      titleEn: isNew ? 'Thank You for Your Review' : 'Review Updated',
      bodyAr:
          'تم حفظ تقييمكِ لزيارة $doctorName (${review.doctorRating}/5 نجوم) بنجاح والمساهمة في مساعدة الأخريات.',
      bodyEn:
          'Your rating for Dr. $doctorName (${review.doctorRating}/5 stars) has been saved.',
      type: NotificationType.reviewSubmitted,
      appointmentId: review.appointmentId,
    );

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

    final doctor = getDoctorById(appointment.doctorId);
    final center = getCenterById(appointment.centerId);
    final doctorName =
        doctor != null ? doctor.getName(isArabic) : appointment.doctorId;
    final centerName = center != null ? center.getName(isArabic) : '';
    final formattedDate =
        AppTranslations.formatDate(appointment.date, isArabic);

    addNotification(
      titleAr: 'تأكيد حجز موعد جديد',
      titleEn: 'New Appointment Confirmed',
      bodyAr:
          'تم حجز وتأكيد موعدكِ بنجاح مع $doctorName${centerName.isNotEmpty ? ' في $centerName' : ''} يوم $formattedDate الساعة ${appointment.timeSlot}.',
      bodyEn:
          'Your appointment with $doctorName${centerName.isNotEmpty ? ' at $centerName' : ''} on $formattedDate at ${appointment.timeSlot} is confirmed.',
      type: NotificationType.bookingConfirmed,
      appointmentId: appointment.id,
    );

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

    final doctor = getDoctorById(existing.doctorId);
    final doctorName =
        doctor != null ? doctor.getName(isArabic) : existing.doctorId;
    final formattedDate = AppTranslations.formatDate(newDate, isArabic);

    addNotification(
      titleAr: 'تم تعديل موعد الحجز',
      titleEn: 'Appointment Rescheduled',
      bodyAr:
          'تم تعديل موعدكِ مع $doctorName إلى يوم $formattedDate الساعة $newTimeSlot.',
      bodyEn:
          'Your appointment with $doctorName was rescheduled to $formattedDate at $newTimeSlot.',
      type: NotificationType.bookingRescheduled,
      appointmentId: appointmentId,
    );

    await _saveAppointmentsToDisk();
    notifyListeners();
    return true;
  }

  /// Cancel an appointment (releasing its slot immediately for future bookings)
  Future<void> cancelAppointment(String appointmentId) async {
    final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
    if (index != -1) {
      final existing = _appointments[index];
      _appointments[index] = existing.copyWith(
        status: AppointmentStatus.cancelled,
      );

      final doctor = getDoctorById(existing.doctorId);
      final doctorName =
          doctor != null ? doctor.getName(isArabic) : existing.doctorId;

      addNotification(
        titleAr: 'تم إلغاء الموعد',
        titleEn: 'Appointment Cancelled',
        bodyAr:
            'تم إلغاء حجز موعدكِ مع $doctorName وتحرير وقت الموعد بنجاح.',
        bodyEn:
            'Your appointment with $doctorName has been cancelled and the slot was released.',
        type: NotificationType.bookingCancelled,
        appointmentId: appointmentId,
      );

      await _saveAppointmentsToDisk();
      notifyListeners();
    }
  }

  /// Simulate any appointment status transition (for interactive demo exploration)
  Future<void> simulateAppointmentStatus(
      String appointmentId, AppointmentStatus newStatus) async {
    final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
    if (index == -1) return;

    final existing = _appointments[index];
    final doctor = getDoctorById(existing.doctorId);
    final doctorName =
        doctor != null ? doctor.getName(isArabic) : existing.doctorId;

    _appointments[index] = existing.copyWith(status: newStatus);

    String titleAr;
    String titleEn;
    String bodyAr;
    String bodyEn;

    switch (newStatus) {
      case AppointmentStatus.confirmed:
        titleAr = 'تأكيد الموعد';
        titleEn = 'Appointment Confirmed';
        bodyAr = 'تم تأكيد موعدكِ مع $doctorName بنجاح.';
        bodyEn = 'Your appointment with $doctorName is confirmed.';
        break;
      case AppointmentStatus.pending:
        titleAr = 'الموعد قيد الانتظار';
        titleEn = 'Appointment Pending';
        bodyAr = 'موعدكِ مع $doctorName بانتظار موافقة وتأكيد العيادة.';
        bodyEn =
            'Your appointment with $doctorName is pending clinic confirmation.';
        break;
      case AppointmentStatus.postponed:
        titleAr = 'تم تأجيل الموعد';
        titleEn = 'Appointment Postponed';
        bodyAr = 'تم تسجيل موعدكِ مع $doctorName كـ مؤجل/معاد جدولته.';
        bodyEn = 'Your appointment with $doctorName is marked as postponed.';
        break;
      case AppointmentStatus.completed:
        titleAr = 'اكتملت الزيارة الطبية';
        titleEn = 'Appointment Completed';
        bodyAr =
            'اكتملت زيارتكِ الطبية مع $doctorName. يسعدنا مشاركة تقييمكِ الآن.';
        bodyEn =
            'Your visit with $doctorName has completed. You can now leave a review.';
        break;
      case AppointmentStatus.cancelled:
        titleAr = 'إلغاء الموعد';
        titleEn = 'Appointment Cancelled';
        bodyAr = 'تم إلغاء موعدكِ مع $doctorName وإتاحة وقت الحجز.';
        bodyEn =
            'Your appointment with $doctorName was cancelled and the slot released.';
        break;
      case AppointmentStatus.noShow:
        titleAr = 'تسجيل عدم الحضور';
        titleEn = 'Appointment No-Show';
        bodyAr = 'تم تسجيل عدم الحضور لموعدكِ مع $doctorName.';
        bodyEn = 'Your appointment with $doctorName was marked as no-show.';
        break;
    }

    addNotification(
      titleAr: titleAr,
      titleEn: titleEn,
      bodyAr: bodyAr,
      bodyEn: bodyEn,
      type: NotificationType.statusSimulated,
      appointmentId: appointmentId,
    );

    await _saveAppointmentsToDisk();
    notifyListeners();
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
      if (aptDate.isAtSameMomentAs(today) &&
          isSlotPast(apt.date, apt.timeSlot)) {
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
      if (aptDate.isAtSameMomentAs(today) &&
          isSlotPast(apt.date, apt.timeSlot)) {
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
      if (aptDate.isAtSameMomentAs(today) &&
          isSlotPast(apt.date, apt.timeSlot)) {
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
