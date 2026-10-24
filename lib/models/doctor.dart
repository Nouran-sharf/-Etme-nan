import 'package:flutter/material.dart';

/// Doctor model with bilingual attributes, center affiliation, and live rating calculation.
class Doctor {
  final String id;
  final String nameAr;
  final String nameEn;
  final String serviceId; // breast_health, routine_followup, psychological_support, womens_health
  final String specialtyAr;
  final String specialtyEn;
  final int experienceYears;
  final String centerId;
  final String clinicAr;
  final String clinicEn;
  final String biographyAr;
  final String biographyEn;
  final String appointmentExplanationAr;
  final String appointmentExplanationEn;
  final List<String> availableTimeSlots;
  final String imageAsset;
  final bool isMale;
  final double initialRatingSum;
  final int initialRatingCount;
  final IconData avatarIcon;

  const Doctor({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.serviceId,
    required this.specialtyAr,
    required this.specialtyEn,
    required this.experienceYears,
    required this.centerId,
    required this.clinicAr,
    required this.clinicEn,
    required this.biographyAr,
    required this.biographyEn,
    required this.appointmentExplanationAr,
    required this.appointmentExplanationEn,
    required this.availableTimeSlots,
    required this.imageAsset,
    this.isMale = false,
    this.initialRatingSum = 45.0,
    this.initialRatingCount = 10,
    this.avatarIcon = Icons.medical_services_rounded,
  });

  /// Helper to get localized name based on language code
  String getName(bool isArabic) => isArabic ? nameAr : nameEn;

  /// Helper to get localized specialty
  String getSpecialty(bool isArabic) => isArabic ? specialtyAr : specialtyEn;

  /// Helper to get localized clinic location
  String getClinic(bool isArabic) => isArabic ? clinicAr : clinicEn;

  /// Helper to get localized biography
  String getBiography(bool isArabic) => isArabic ? biographyAr : biographyEn;

  /// Helper to get localized appointment explanation
  String getAppointmentExplanation(bool isArabic) =>
      isArabic ? appointmentExplanationAr : appointmentExplanationEn;

  /// Compute composite rating including user reviews
  double getAverageRating({double userReviewsSum = 0, int userReviewsCount = 0}) {
    final totalCount = initialRatingCount + userReviewsCount;
    if (totalCount == 0) return 0.0;
    final totalSum = initialRatingSum + userReviewsSum;
    return totalSum / totalCount;
  }

  int getTotalReviewsCount({int userReviewsCount = 0}) {
    return initialRatingCount + userReviewsCount;
  }
}
