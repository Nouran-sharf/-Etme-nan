/// Medical Center model representing clinics and specialized hospitals in Egypt.
class MedicalCenter {
  final String id;
  final String nameAr;
  final String nameEn;
  final String imageAsset;
  final String cityAr;
  final String cityEn;
  final String addressAr;
  final String addressEn;
  final String phoneDemo;
  final String emailDemo;
  final String hotline;
  final String website;
  final String photoAuthor;
  final String photoLicense;
  final String photoSourceUrl;
  final String openingHoursAr;
  final String openingHoursEn;
  final String descriptionAr;
  final String descriptionEn;
  final List<String> servicesOffered; // e.g. ['breast_health', 'routine_followup']
  final List<String> associatedDoctorIds;
  final double initialRatingSum;
  final int initialRatingCount;

  const MedicalCenter({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.imageAsset,
    required this.cityAr,
    required this.cityEn,
    required this.addressAr,
    required this.addressEn,
    required this.phoneDemo,
    required this.emailDemo,
    this.hotline = '',
    this.website = '',
    this.photoAuthor = '',
    this.photoLicense = '',
    this.photoSourceUrl = '',
    required this.openingHoursAr,
    required this.openingHoursEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.servicesOffered,
    required this.associatedDoctorIds,
    required this.initialRatingSum,
    required this.initialRatingCount,
  });

  String getName(bool isArabic) => isArabic ? nameAr : nameEn;
  String getCity(bool isArabic) => isArabic ? cityAr : cityEn;
  String getAddress(bool isArabic) => isArabic ? addressAr : addressEn;
  String getOpeningHours(bool isArabic) =>
      isArabic ? openingHoursAr : openingHoursEn;
  String getDescription(bool isArabic) =>
      isArabic ? descriptionAr : descriptionEn;

  /// Calculate composite rating including any user submitted reviews
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
