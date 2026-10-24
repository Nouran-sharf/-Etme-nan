import 'package:flutter/material.dart';

/// Model representing a verified educational awareness article
class AwarenessArticle {
  final String id;
  final String titleAr;
  final String titleEn;
  final String summaryAr;
  final String summaryEn;
  final List<String> bulletPointsAr;
  final List<String> bulletPointsEn;
  final String adviceAr;
  final String adviceEn;
  final String sourceName;
  final String sourceUrl;
  final String dateCheckedAr;
  final String dateCheckedEn;
  final String categoryTagAr;
  final String categoryTagEn;
  final IconData icon;

  const AwarenessArticle({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.summaryAr,
    required this.summaryEn,
    required this.bulletPointsAr,
    required this.bulletPointsEn,
    required this.adviceAr,
    required this.adviceEn,
    required this.sourceName,
    required this.sourceUrl,
    required this.dateCheckedAr,
    required this.dateCheckedEn,
    required this.categoryTagAr,
    required this.categoryTagEn,
    required this.icon,
  });

  String getTitle(bool isArabic) => isArabic ? titleAr : titleEn;
  String getSummary(bool isArabic) => isArabic ? summaryAr : summaryEn;
  List<String> getBulletPoints(bool isArabic) =>
      isArabic ? bulletPointsAr : bulletPointsEn;
  String getAdvice(bool isArabic) => isArabic ? adviceAr : adviceEn;
  String getDateChecked(bool isArabic) =>
      isArabic ? dateCheckedAr : dateCheckedEn;
  String getCategoryTag(bool isArabic) =>
      isArabic ? categoryTagAr : categoryTagEn;
}
