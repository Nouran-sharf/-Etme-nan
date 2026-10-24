import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../models/medical_center.dart';
import '../models/review.dart';

/// Available service category definitions with local photographic assets
class ServiceCategory {
  final String id;
  final String titleKey;
  final String descKey;
  final String imageAsset;
  final IconData icon;

  const ServiceCategory({
    required this.id,
    required this.titleKey,
    required this.descKey,
    required this.imageAsset,
    required this.icon,
  });
}

/// The four core services required by the project specifications
final List<ServiceCategory> mockServices = [
  const ServiceCategory(
    id: 'breast_health',
    titleKey: 'service_breast_health',
    descKey: 'service_breast_health_desc',
    imageAsset: 'assets/images/services/service_breast_health.jpg',
    icon: Icons.favorite_rounded,
  ),
  const ServiceCategory(
    id: 'routine_followup',
    titleKey: 'service_routine_followup',
    descKey: 'service_routine_followup_desc',
    imageAsset: 'assets/images/services/service_routine_followup.jpg',
    icon: Icons.fact_check_rounded,
  ),
  const ServiceCategory(
    id: 'psychological_support',
    titleKey: 'service_psychological_support',
    descKey: 'service_psychological_support_desc',
    imageAsset: 'assets/images/services/service_psychological.jpg',
    icon: Icons.psychology_rounded,
  ),
  const ServiceCategory(
    id: 'womens_health',
    titleKey: 'service_womens_health',
    descKey: 'service_womens_health_desc',
    imageAsset: 'assets/images/services/service_womens_health.jpg',
    icon: Icons.health_and_safety_rounded,
  ),
];

/// 4 Verified Real Healthcare Centers in Egypt with authentic Creative Commons photographs
final List<MedicalCenter> mockMedicalCenters = [
  const MedicalCenter(
    id: 'center_1',
    nameAr: 'المعهد القومي للأورام - جامعة القاهرة (المقر الرئيسي)',
    nameEn: 'National Cancer Institute - Cairo University (Main Campus)',
    imageAsset: 'assets/images/centers/center_1.jpg',
    cityAr: 'القاهرة',
    cityEn: 'Cairo',
    addressAr: '1 شارع قصر العيني، ميدان فم الخليج، السيدة زينب، القاهرة',
    addressEn: '1 Kasr Al-Aini St., Fom El Khalig, Sayeda Zeinab, Cairo',
    hotline: '19914',
    phoneDemo: '19914 / +20 2 23664666',
    emailDemo: 'contact@nci.cu.edu.eg',
    website: 'https://nci.cu.edu.eg/',
    photoAuthor: 'Ashashyou',
    photoLicense: 'CC BY-SA 3.0',
    photoSourceUrl:
        'https://commons.wikimedia.org/wiki/File:Cairo_Univ_-_National_Cancer_Institute.jpg',
    openingHoursAr:
        'العيادات الخارجية: الأحد - الخميس 8:00 ص - 2:00 م (الاستقبال والطوارئ: 24 ساعة)',
    openingHoursEn:
        'Outpatient: Sun - Thu 8:00 AM - 2:00 PM (Emergency: 24/7)',
    descriptionAr:
        'المؤسسة الطبية الأكاديمية الأولى في مصر والشرق الأوسط لعلاج الأورام وأبحاثها، يضم أحدث أجهزة التشخيص المبكر وعيادات جراحة أورام الثدي المتخصصة.',
    descriptionEn:
        'The premier comprehensive oncology and academic research institution in Egypt, providing state-of-the-art breast oncology diagnostics, surgery, and multidisciplinary care.',
    servicesOffered: ['breast_health', 'routine_followup'],
    associatedDoctorIds: ['doc_1', 'doc_2', 'doc_7'],
    initialRatingSum: 118.0,
    initialRatingCount: 25,
  ),
  const MedicalCenter(
    id: 'center_2',
    nameAr: 'مركز أورام الثدي، المعهد القومي للأورام (فرع التجمع الأول)',
    nameEn: 'Breast Cancer Center, National Cancer Institute (First Settlement)',
    imageAsset: 'assets/images/centers/center_2.jpg',
    cityAr: 'القاهرة الجديدة',
    cityEn: 'New Cairo',
    addressAr: 'امتداد محور السادات، التجمع الأول، القاهرة الجديدة، محافظة القاهرة',
    addressEn: 'Sadat Axis Ext., First Settlement, New Cairo, Cairo',
    hotline: '19914',
    phoneDemo: '19914 / +20 2 23664600',
    emailDemo: 'breastcenter@nci.cu.edu.eg',
    website: 'https://nci.cu.edu.eg/',
    photoAuthor: 'ديفيد عادل وهبة خليل 2 (David Adel Wahba Khalil)',
    photoLicense: 'CC0 1.0 (Public Domain)',
    photoSourceUrl:
        'https://commons.wikimedia.org/wiki/File:%D9%85%D8%B3%D8%AA%D8%B4%D9%81%D9%89_%D9%88%D9%85%D8%B9%D9%87%D8%AF_%D8%A3%D9%88%D8%B1%D8%A7%D9%85_%D8%A7%D9%84%D8%AA%D8%AC%D9%85%D8%B9_%D8%A7%D9%84%D8%A3%D9%88%D9%84.jpg',
    openingHoursAr:
        'العيادات الخارجية والماموجرام: الأحد - الخميس 9:00 ص - 2:00 م',
    openingHoursEn:
        'Outpatient & Mammography: Sun - Thu 9:00 AM - 2:00 PM',
    descriptionAr:
        'صرح طبي متخصص تابع للمعهد القومي للأورام مكرس لتشخيص وعلاج أورام وجراحة الثدي والماموجرام الرقمي والمتابعة الوقائية في بيئة استشارية متطورة.',
    descriptionEn:
        'Specialized affiliate of the National Cancer Institute focused on digital mammography, high-resolution ultrasound, and dedicated breast care clinics.',
    servicesOffered: ['breast_health', 'routine_followup', 'womens_health'],
    associatedDoctorIds: ['doc_3', 'doc_4', 'doc_5', 'doc_15'],
    initialRatingSum: 142.0,
    initialRatingCount: 30,
  ),
  const MedicalCenter(
    id: 'center_3',
    nameAr: 'مستشفى سرطان الأطفال 57357 والأورام (قسم الدعم النفسي)',
    nameEn: 'Children\'s Cancer Hospital 57357 & Oncology Center',
    imageAsset: 'assets/images/centers/center_3.jpg',
    cityAr: 'القاهرة',
    cityEn: 'Cairo',
    addressAr: '1 شارع سكة الإمام، مجرى العيون، السيدة زينب، القاهرة',
    addressEn: '1 Sekat Al-Imam St., Magra El-Oyoun, Sayeda Zeinab, Cairo',
    hotline: '19057',
    phoneDemo: '19057 / +20 2 25351500',
    emailDemo: 'info@57357.org',
    website: 'https://www.57357.org/',
    photoAuthor: 'MONTASR',
    photoLicense: 'CC BY-SA 3.0',
    photoSourceUrl:
        'https://commons.wikimedia.org/wiki/File:%D9%85%D8%B3%D8%AA%D8%B4%D9%81%D9%89_%D8%B3%D8%B1%D8%B7%D8%A7%D9%86_%D8%A7%D9%84%D8%A7%D8%B7%D9%81%D8%A7%D9%84_57357.jpg',
    openingHoursAr:
        'العيادات والاستشارات النفسية: السبت - الخميس 8:00 ص - 3:00 م (الرعاية الطارئة: 24 ساعة)',
    openingHoursEn:
        'Clinics & Psychological Support: Sat - Thu 8:00 AM - 3:00 PM (Emergency: 24/7)',
    descriptionAr:
        'مركز طبي وعلاجي رائد عالمياً يضم قسماً متكاملاً للدعم النفسي الإكلينيكي والإرشاد الأسري المصاحب للرعاية الطبية لتعزيز السلامة النفسية والصمود.',
    descriptionEn:
        'World-class healthcare facility featuring specialized psycho-oncology, cognitive counseling, and emotional resilience programs for patients and their families.',
    servicesOffered: ['psychological_support'],
    associatedDoctorIds: ['doc_9', 'doc_10', 'doc_11', 'doc_12'],
    initialRatingSum: 96.0,
    initialRatingCount: 20,
  ),
  const MedicalCenter(
    id: 'center_4',
    nameAr: 'مستشفى قصر العيني التعليمي الجديد - جامعة القاهرة',
    nameEn: 'New Kasr Al-Aini Teaching Hospital - Cairo University',
    imageAsset: 'assets/images/centers/center_4.jpg',
    cityAr: 'القاهرة',
    cityEn: 'Cairo',
    addressAr: 'شارع عبد العزيز آل سعود، المنيل، محافظة القاهرة',
    addressEn: 'Abdel Aziz Al Saud St., El Manial, Cairo Governorate',
    hotline: '+20 2 23654060',
    phoneDemo: '+20 2 23654060 / +20 2 23654061',
    emailDemo: 'inquiry@kasralainy.edu.eg',
    website: 'https://kasralainy.edu.eg/',
    photoAuthor: 'Ashashyou',
    photoLicense: 'CC BY-SA 3.0',
    photoSourceUrl:
        'https://commons.wikimedia.org/wiki/File:Cairo_Univ_-_New_Kasr_al-Aini_Hospital.jpg',
    openingHoursAr:
        'العيادات التخصصية: الأحد - الخميس 8:30 ص - 2:30 م (الطوارئ: 24 ساعة)',
    openingHoursEn:
        'Specialty Clinics: Sun - Thu 8:30 AM - 2:30 PM (Emergency: 24/7)',
    descriptionAr:
        'المستشفى التعليمي والفرنساوي بجامعة القاهرة، يضم نخبة من أساتذة كلية الطب في تخصصات صحة المرأة، وأمراض النساء، والمتابعة الدورية الشاملة.',
    descriptionEn:
        'Premier university hospital offering multidisciplinary clinical departments, faculty specialists in women\'s preventative health, gynecology, and comprehensive screenings.',
    servicesOffered: ['routine_followup', 'womens_health'],
    associatedDoctorIds: ['doc_6', 'doc_8', 'doc_13', 'doc_14', 'doc_16'],
    initialRatingSum: 125.0,
    initialRatingCount: 26,
  ),
];

/// 16 Fictional Doctors in Egyptian Context: 4 per service (mix of female & male doctors)
final List<Doctor> mockDoctors = [
  // ==================== 1. BREAST HEALTH (4 Doctors) ====================
  const Doctor(
    id: 'doc_1',
    nameAr: 'د. منى حسن',
    nameEn: 'Dr. Mona Hassan',
    serviceId: 'breast_health',
    specialtyAr: 'استشارية أورام الثدي والفحص التشخيصي المبكر',
    specialtyEn: 'Consultant Breast Oncologist & Early Detection',
    experienceYears: 16,
    centerId: 'center_1',
    clinicAr: 'المعهد القومي للأورام - عيادة أورام الثدي 101',
    clinicEn: 'National Cancer Institute - Breast Clinic 101',
    biographyAr:
        'استشارية متخصصة في الكشف المبكر والتشخيص الدقيق لصحة الثدي بالمعهد القومي للأورام، مع خبرة واسعة في مراجعة الفحوصات وتوجيه المراجعات بكل طمأنينة ومهنية.',
    biographyEn:
        'Senior consultant specializing in early detection, diagnostic review, and compassionate clinical care at the National Cancer Institute.',
    appointmentExplanationAr:
        'تشمل الاستشارة فحصاً سريرياً دقيقاً، ومراجعة أية فحوصات وتصوير سابقة، مع تقديم إرشادات الفحص الذاتي ووضع خطة متابعة دورية مطمئنة.',
    appointmentExplanationEn:
        'Includes a thorough clinical examination, previous imaging review, guidance on regular self-exams, and personalized follow-up.',
    availableTimeSlots: ['09:00 AM', '10:30 AM', '01:00 PM', '03:30 PM'],
    imageAsset: 'assets/images/doctors/doc_1.jpg',
    isMale: false,
    initialRatingSum: 98.0,
    initialRatingCount: 20,
    avatarIcon: Icons.local_hospital_rounded,
  ),
  const Doctor(
    id: 'doc_2',
    nameAr: 'د. أحمد فتحي',
    nameEn: 'Dr. Ahmed Fathy',
    serviceId: 'breast_health',
    specialtyAr: 'استشاري جراحة أورام الثدي والجراحة الترميمية',
    specialtyEn: 'Consultant Oncoplastic Breast Surgeon',
    experienceYears: 18,
    centerId: 'center_1',
    clinicAr: 'المعهد القومي للأورام - قسم الجراحة عيادة 104',
    clinicEn: 'National Cancer Institute - Surgery Clinic 104',
    biographyAr:
        'استشاري جراحة أورام الثدي بخبرة ممتدة في الجراحات الدقيقة والترميمية، يركز على تقديم أفضل الخيارات العلاجية الجراحية بأعلى معايير الأمان.',
    biographyEn:
        'Consultant breast surgeon specializing in oncoplastic and reconstructive care, dedicated to patient safety and reassurance.',
    appointmentExplanationAr:
        'جلسة استشارية شاملة لمناقشة الخيارات العلاجية والجراحية بدقة ووضوح وتقديم الرأي الطبي المتخصص.',
    appointmentExplanationEn:
        'A comprehensive consultation reviewing diagnostic results, surgical options, and offering expert medical guidance.',
    availableTimeSlots: ['09:30 AM', '11:30 AM', '02:00 PM', '04:30 PM'],
    imageAsset: 'assets/images/doctors/doc_2.jpg',
    isMale: true,
    initialRatingSum: 74.0,
    initialRatingCount: 15,
    avatarIcon: Icons.medical_services_rounded,
  ),
  const Doctor(
    id: 'doc_3',
    nameAr: 'د. مريم إبراهيم',
    nameEn: 'Dr. Mariam Ibrahim',
    serviceId: 'breast_health',
    specialtyAr: 'أخصائية الأشعة التشخيصية والماموجرام الرقمي',
    specialtyEn: 'Diagnostic Breast Radiologist & Mammography Specialist',
    experienceYears: 11,
    centerId: 'center_2',
    clinicAr: 'مركز أورام التجمع الأول - وحدة تصوير الثدي 2',
    clinicEn: 'First Settlement Breast Center - Imaging Unit 2',
    biographyAr:
        'متخصصة في قراءة وتفسير صور الماموجرام والموجات فوق الصوتية المتقدمة، وتوضيح النتائج للمراجعات بكل وضوح وهدوء.',
    biographyEn:
        'Expert radiologist skilled in interpreting digital mammograms and high-resolution breast ultrasound.',
    appointmentExplanationAr:
        'مراجعة فورية ومباشرة لنتائج التصوير الشعاعي والموجات فوق الصوتية والإجابة عن جميع الاستفسارات بدقة.',
    appointmentExplanationEn:
        'Immediate review of mammography and ultrasound results with clear, reassuring medical explanations.',
    availableTimeSlots: ['08:30 AM', '10:00 AM', '12:30 PM', '02:30 PM'],
    imageAsset: 'assets/images/doctors/doc_3.jpg',
    isMale: false,
    initialRatingSum: 86.0,
    initialRatingCount: 18,
    avatarIcon: Icons.camera_indoor_rounded,
  ),
  const Doctor(
    id: 'doc_4',
    nameAr: 'د. كريم حسام',
    nameEn: 'Dr. Karim Hossam',
    serviceId: 'breast_health',
    specialtyAr: 'استشاري فحص وأمراض الثدي السريرية',
    specialtyEn: 'Consultant Clinical Breast Specialist',
    experienceYears: 14,
    centerId: 'center_2',
    clinicAr: 'مركز أورام التجمع الأول - جناح 201',
    clinicEn: 'First Settlement Breast Center - Suite 201',
    biographyAr:
        'طبيب استشاري متخصص في تقييم الأعراض والتغيرات النسيجية، وتحديد برامج المراقبة الدورية المخصصة لكل مراجعة.',
    biographyEn:
        'Clinical consultant focusing on symptomatic evaluation, tissue assessment, and personalized monitoring regimens.',
    appointmentExplanationAr:
        'فحص سريري كامل وتقييم عوامل الخطورة الوراثية وتحديد الفحوصات الدورية المناسبة.',
    appointmentExplanationEn:
        'Complete clinical examination, risk assessment, and customized recommendation for screening intervals.',
    availableTimeSlots: ['10:00 AM', '11:45 AM', '01:15 PM', '03:45 PM'],
    imageAsset: 'assets/images/doctors/doc_4.jpg',
    isMale: true,
    initialRatingSum: 58.0,
    initialRatingCount: 12,
    avatarIcon: Icons.medical_services_rounded,
  ),

  // ==================== 2. ROUTINE FOLLOW-UP (4 Doctors) ====================
  const Doctor(
    id: 'doc_5',
    nameAr: 'د. هبة محمود',
    nameEn: 'Dr. Heba Mahmoud',
    serviceId: 'routine_followup',
    specialtyAr: 'استشارية الطب الوقائي والمتابعة السريرية',
    specialtyEn: 'Consultant Preventive Medicine & Clinical Follow-up',
    experienceYears: 12,
    centerId: 'center_2',
    clinicAr: 'مركز أورام التجمع الأول - جناح المتابعة 204',
    clinicEn: 'First Settlement Center - Follow-up Suite 204',
    biographyAr:
        'طبيبة متخصصة في متابعة النتائج الدورية والفحوصات المستمرة، تهدف للحفاظ على استقرار صحة المرأة وطمأنينتها الدائمة.',
    biographyEn:
        'Specialist focusing on routine checkup monitoring, post-screening evaluations, and long-term women\'s health maintenance.',
    appointmentExplanationAr:
        'جلسة مخصصة لمراجعة التطورات الصحية الدورية، والتأكد من ملاءمة خطط المتابعة في جو هادئ وخاص.',
    appointmentExplanationEn:
        'A dedicated session to review periodic test results, confirm routine health status, and plan upcoming maintenance checkups.',
    availableTimeSlots: ['09:30 AM', '11:00 AM', '02:00 PM', '04:00 PM'],
    imageAsset: 'assets/images/doctors/doc_5.jpg',
    isMale: false,
    initialRatingSum: 69.0,
    initialRatingCount: 14,
    avatarIcon: Icons.fact_check_rounded,
  ),
  const Doctor(
    id: 'doc_6',
    nameAr: 'د. محمد عادل',
    nameEn: 'Dr. Mohamed Adel',
    serviceId: 'routine_followup',
    specialtyAr: 'أخصائي الطب الباطني والمتابعة الدورية',
    specialtyEn: 'Internal Medicine & Routine Checkup Specialist',
    experienceYears: 13,
    centerId: 'center_4',
    clinicAr: 'مستشفى قصر العيني الجديد - عيادة 108',
    clinicEn: 'New Kasr Al-Aini Hospital - Clinic 108',
    biographyAr:
        'خبير في المتابعة الدورية الشاملة للمؤشرات الحيوية والتحاليل المخبرية لضمان استقرار الصحة العامة للسيدات.',
    biographyEn:
        'Expert in comprehensive longitudinal tracking of vital parameters and laboratory results at Kasr Al-Aini.',
    appointmentExplanationAr:
        'مراجعة شاملة لنتائج التحاليل المخبرية والفحوصات السنوية مع تحديث التوصيات الصحية.',
    appointmentExplanationEn:
        'Comprehensive review of annual laboratory tests and vital signs with updated recommendations.',
    availableTimeSlots: ['08:00 AM', '10:15 AM', '01:30 PM', '04:00 PM'],
    imageAsset: 'assets/images/doctors/doc_6.jpg',
    isMale: true,
    initialRatingSum: 48.0,
    initialRatingCount: 10,
    avatarIcon: Icons.verified_user_rounded,
  ),
  const Doctor(
    id: 'doc_7',
    nameAr: 'د. نادية الشافعي',
    nameEn: 'Dr. Nadia El-Shafei',
    serviceId: 'routine_followup',
    specialtyAr: 'طبيبة الرعاية الأولية ومتابعة الفحوصات',
    specialtyEn: 'Primary Care Physician & Screening Coordinator',
    experienceYears: 9,
    centerId: 'center_1',
    clinicAr: 'المعهد القومي للأورام - جناح المتابعة 105',
    clinicEn: 'National Cancer Institute - Follow-up Suite 105',
    biographyAr:
        'تركز على توفير بيئة استشارية مريحة للإجابة عن أسئلة المراجعات وتنسيق الفحوصات الروتينية الدورية بانتظام.',
    biographyEn:
        'Focuses on patient guidance, comfortable communication, and coordinated routine health monitoring.',
    appointmentExplanationAr:
        'متابعة هادئة ومريحة للتأكد من سلامة الفحوصات ومناقشة أية استفسارات بخصوص الصحة العامة.',
    appointmentExplanationEn:
        'A calm follow-up meeting reviewing recent tests and addressing daily wellness concerns.',
    availableTimeSlots: ['09:00 AM', '11:15 AM', '02:30 PM', '04:15 PM'],
    imageAsset: 'assets/images/doctors/doc_7.jpg',
    isMale: false,
    initialRatingSum: 53.0,
    initialRatingCount: 11,
    avatarIcon: Icons.fact_check_rounded,
  ),
  const Doctor(
    id: 'doc_8',
    nameAr: 'د. طارق عبد الرحمن',
    nameEn: 'Dr. Tarek Abdel Rahman',
    serviceId: 'routine_followup',
    specialtyAr: 'استشاري الفحص الدوري وصحة المجتمع',
    specialtyEn: 'Consultant Periodic Screening & Community Health',
    experienceYears: 16,
    centerId: 'center_4',
    clinicAr: 'مستشفى قصر العيني الجديد - جناح 202',
    clinicEn: 'New Kasr Al-Aini Hospital - Suite 202',
    biographyAr:
        'مستشار صحي يتمتع بخبرة رائدة في تصميم برامج المتابعة الوقائية لكافة الفئات العمرية للمرأة.',
    biographyEn:
        'Health consultant with deep experience designing periodic preventative programs for women of all ages.',
    appointmentExplanationAr:
        'تقييم شامل للنتائج الدورية ووضع جدول زمني سنوي للفحوصات الاستباقية.',
    appointmentExplanationEn:
        'Thorough evaluation of periodic screenings with a scheduled annual roadmap for proactive checkups.',
    availableTimeSlots: ['10:30 AM', '12:00 PM', '02:00 PM', '03:45 PM'],
    imageAsset: 'assets/images/doctors/doc_8.jpg',
    isMale: true,
    initialRatingSum: 62.0,
    initialRatingCount: 13,
    avatarIcon: Icons.fact_check_rounded,
  ),

  // ==================== 3. PSYCHOLOGICAL SUPPORT (4 Doctors) ====================
  const Doctor(
    id: 'doc_9',
    nameAr: 'د. ياسمين الصاوي',
    nameEn: 'Dr. Yasmine El-Sawy',
    serviceId: 'psychological_support',
    specialtyAr: 'استشارية علم النفس الإكلينيكي والدعم الوجداني',
    specialtyEn: 'Consultant Clinical Psychologist & Emotional Counselor',
    experienceYears: 14,
    centerId: 'center_3',
    clinicAr: 'مستشفى 57357 - مركز الدعم النفسي صالة 3',
    clinicEn: 'Hospital 57357 - Psychological Center Lounge 3',
    biographyAr:
        'أخصائية نفسية متمرسة في مساندة السيدات وأسرهن أثناء فترات الفحص والانتظار والعلاج لتعزيز الطمأنينة والتوازن النفسي الداخلي.',
    biographyEn:
        'Licensed clinical psychologist helping women and families navigate health-related stress and emotional wellbeing at 57357.',
    appointmentExplanationAr:
        'جلسة حوارية خاصة وسرية تركز على الاستماع الصادق وتقديم أدوات مهدئة للتعامل مع مشاعر القلق والتوتر.',
    appointmentExplanationEn:
        'A confidential dialogue providing calming coping strategies, emotional processing, and mindful resilience.',
    availableTimeSlots: ['10:00 AM', '11:30 AM', '01:00 PM', '04:30 PM'],
    imageAsset: 'assets/images/doctors/doc_9.jpg',
    isMale: false,
    initialRatingSum: 110.0,
    initialRatingCount: 22,
    avatarIcon: Icons.psychology_rounded,
  ),
  const Doctor(
    id: 'doc_10',
    nameAr: 'د. محمود توفيق',
    nameEn: 'Dr. Mahmoud Tawfik',
    serviceId: 'psychological_support',
    specialtyAr: 'أخصائي الدعم النفسي الصحي ومساندة المرضى',
    specialtyEn: 'Psycho-Oncology & Health Psychology Specialist',
    experienceYears: 12,
    centerId: 'center_3',
    clinicAr: 'مستشفى 57357 - عيادة الدعم 102',
    clinicEn: 'Hospital 57357 - Support Clinic 102',
    biographyAr:
        'خبير في الدعم النفسي المصاحب للرعاية الصحية، يساعد في تعزيز الصمود النفسي والتغلب على مخاوف الإجراءات الطبية.',
    biographyEn:
        'Expert in healthcare psychology, helping patients build mental resilience and overcome clinical anxiety.',
    appointmentExplanationAr:
        'مساحة آمنة للتعبير عن المشاعر وتلقي استراتيجيات مثبتة لتخفيف القلق وتعزيز التفكير الإيجابي.',
    appointmentExplanationEn:
        'A safe haven to explore thoughts, manage fears, and develop evidence-based tools for mental peace.',
    availableTimeSlots: ['09:00 AM', '11:00 AM', '02:00 PM', '03:30 PM'],
    imageAsset: 'assets/images/doctors/doc_10.jpg',
    isMale: true,
    initialRatingSum: 78.0,
    initialRatingCount: 16,
    avatarIcon: Icons.psychology_rounded,
  ),
  const Doctor(
    id: 'doc_11',
    nameAr: 'د. سلمى الشريف',
    nameEn: 'Dr. Salma El-Sherif',
    serviceId: 'psychological_support',
    specialtyAr: 'أخصائية الإرشاد الأسري والتعافي النفسي',
    specialtyEn: 'Family Guidance & Psychosocial Wellness Specialist',
    experienceYears: 9,
    centerId: 'center_3',
    clinicAr: 'مستشفى 57357 - قاعة الاسترخاء 1',
    clinicEn: 'Hospital 57357 - Relaxation Hall 1',
    biographyAr:
        'تكرس جهودها لمساعدة المراجعات على استعادة الهدوء الداخلي والتواصل الأسري الفعال خلال مراحل الرعاية الصحية.',
    biographyEn:
        'Dedicated to assisting women regain inner peace, self-care routines, and supportive family communication.',
    appointmentExplanationAr:
        'جلسة مريحة للتركيز على العناية الذاتية وتقنيات الاسترخاء والتفريغ الانفعالي الصحي.',
    appointmentExplanationEn:
        'A relaxed session emphasizing self-care routines, guided relaxation, and healthy emotional release.',
    availableTimeSlots: ['08:30 AM', '10:30 AM', '01:30 PM', '03:00 PM'],
    imageAsset: 'assets/images/doctors/doc_11.jpg',
    isMale: false,
    initialRatingSum: 89.0,
    initialRatingCount: 18,
    avatarIcon: Icons.volunteer_activism_rounded,
  ),
  const Doctor(
    id: 'doc_12',
    nameAr: 'د. هاني يوسف',
    nameEn: 'Dr. Hany Youssef',
    serviceId: 'psychological_support',
    specialtyAr: 'مستشار العلاج المعرفي السلوكي وإدارة التوتر',
    specialtyEn: 'Cognitive Behavioral Therapy (CBT) & Stress Consultant',
    experienceYears: 11,
    centerId: 'center_3',
    clinicAr: 'مستشفى 57357 - غرفة الاستشارات 204',
    clinicEn: 'Hospital 57357 - Consultation Room 204',
    biographyAr:
        'متخصص في تدريب المراجعات على آليات التحكم في الضغوط ومحاصرة الأفكار المقلقة المتعلقة بالصحة.',
    biographyEn:
        'Specializes in evidence-based cognitive therapy to help clients reframe anxious thoughts around medical visits.',
    appointmentExplanationAr:
        'تطبيق تمارين سلوكية وعقلية لإعادة ضبط التوتر وتعزيز راحة البال والنوم الهادئ.',
    appointmentExplanationEn:
        'Practical behavioral and relaxation techniques to reduce somatic stress and encourage restful sleep.',
    availableTimeSlots: ['10:00 AM', '12:00 PM', '02:30 PM', '04:00 PM'],
    imageAsset: 'assets/images/doctors/doc_12.jpg',
    isMale: true,
    initialRatingSum: 48.0,
    initialRatingCount: 10,
    avatarIcon: Icons.psychology_rounded,
  ),

  // ==================== 4. WOMEN\'S HEALTH (4 Doctors) ====================
  const Doctor(
    id: 'doc_13',
    nameAr: 'د. رانيا عبد العزيز',
    nameEn: 'Dr. Rania Abdel Aziz',
    serviceId: 'womens_health',
    specialtyAr: 'استشارية صحة المرأة العامة والطب التكاملي',
    specialtyEn: 'Consultant Women\'s General Health & Integrative Medicine',
    experienceYears: 17,
    centerId: 'center_4',
    clinicAr: 'مستشفى قصر العيني الجديد - جناح صحة المرأة (الدور الأول)',
    clinicEn: 'New Kasr Al-Aini Hospital - Women\'s Wing (1st Floor)',
    biographyAr:
        'استشارية متمرسة تقدم رعاية شاملة تعنى بصحة المرأة عبر مراحل العمر، والتوازن الهرموني، والتغذية الوقائية.',
    biographyEn:
        'Experienced consultant providing holistic care across all life stages, hormonal harmony, and preventive wellness.',
    appointmentExplanationAr:
        'تقييم شامل للنمط الصحي، مراجعة التاريخ الطبي الشخصي والأسري، وبناء خطة عناية متوازنة تناسب احتياجاتك.',
    appointmentExplanationEn:
        'Full lifestyle assessment, medical history review, and creation of a tailored wellness roadmap.',
    availableTimeSlots: ['09:00 AM', '10:30 AM', '01:00 PM', '03:00 PM'],
    imageAsset: 'assets/images/doctors/doc_13.jpg',
    isMale: false,
    initialRatingSum: 124.0,
    initialRatingCount: 25,
    avatarIcon: Icons.health_and_safety_rounded,
  ),
  const Doctor(
    id: 'doc_14',
    nameAr: 'د. شريف الجوهري',
    nameEn: 'Dr. Sherif El-Gohary',
    serviceId: 'womens_health',
    specialtyAr: 'استشاري الرعاية النسائية والطب الوقائي',
    specialtyEn: 'Consultant Gynecological Care & Preventative Health',
    experienceYears: 13,
    centerId: 'center_4',
    clinicAr: 'مستشفى قصر العيني الجديد - جناح 303',
    clinicEn: 'New Kasr Al-Aini Hospital - Suite 303',
    biographyAr:
        'يقدم استشارات طبية متخصصة ومبنية على أحدث الإرشادات العالمية لضمان صحة المرأة واستقرارها البدني.',
    biographyEn:
        'Provides clinical care guided by the latest global medical standards to promote female lifelong wellbeing.',
    appointmentExplanationAr:
        'فحص طبي شامل ومناقشة الأعراض الهرمونية وأفضل السبل الوقائية لحياة نشطة وصحية.',
    appointmentExplanationEn:
        'Comprehensive clinical review, hormone balance consultation, and personalized preventative counseling.',
    availableTimeSlots: ['08:30 AM', '11:00 AM', '01:30 PM', '04:15 PM'],
    imageAsset: 'assets/images/doctors/doc_14.jpg',
    isMale: true,
    initialRatingSum: 67.0,
    initialRatingCount: 14,
    avatarIcon: Icons.health_and_safety_rounded,
  ),
  const Doctor(
    id: 'doc_15',
    nameAr: 'د. نهى بدر',
    nameEn: 'Dr. Noha Badr',
    serviceId: 'womens_health',
    specialtyAr: 'أخصائية صحة المرأة والغدد والتوازن الهرموني',
    specialtyEn: 'Reproductive Endocrinology & Women\'s Wellness Specialist',
    experienceYears: 15,
    centerId: 'center_2',
    clinicAr: 'مركز أورام التجمع الأول - جناح الرعاية النسائية 104',
    clinicEn: 'First Settlement Center - Women\'s Care Suite 104',
    biographyAr:
        'طبيبة متميزة في معالجة الاضطرابات الهرمونية وتغذية المرأة، وتقديم برامج عافية مخصصة لكل مرحلة عمرية.',
    biographyEn:
        'Distinguished specialist in endocrine wellness, nutritional guidance, and age-specific health balance.',
    appointmentExplanationAr:
        'مراجعة دقيقة لمستويات الهرمونات والأعراض الجسدية مع تقديم نصائح نمط الحياة المجدية.',
    appointmentExplanationEn:
        'Precise review of hormonal markers and physical symptoms with practical daily lifestyle guidance.',
    availableTimeSlots: ['09:30 AM', '11:30 AM', '02:00 PM', '03:45 PM'],
    imageAsset: 'assets/images/doctors/doc_15.jpg',
    isMale: false,
    initialRatingSum: 83.0,
    initialRatingCount: 17,
    avatarIcon: Icons.health_and_safety_rounded,
  ),
  const Doctor(
    id: 'doc_16',
    nameAr: 'د. أيمن منصور',
    nameEn: 'Dr. Ayman Mansour',
    serviceId: 'womens_health',
    specialtyAr: 'استشاري التغذية العلاجية والصحة الحيوية للمرأة',
    specialtyEn: 'Consultant Clinical Nutrition & Women\'s Vitality',
    experienceYears: 11,
    centerId: 'center_4',
    clinicAr: 'مستشفى قصر العيني الجديد - عيادة التغذية 205',
    clinicEn: 'New Kasr Al-Aini Hospital - Nutrition Clinic 205',
    biographyAr:
        'يركز على التغذية الداعمة للجهاز المناعي والهرموني لتعزيز حيوية المرأة والوقاية من الأمراض المزمنة.',
    biographyEn:
        'Focuses on clinical nutrition optimizing immunity and endocrine vitality for chronic disease prevention.',
    appointmentExplanationAr:
        'تقييم العادات الغذائية ونمط النشاط وبناء برنامج صحي متكامل يدعم مناعة الجسم وعافيته.',
    appointmentExplanationEn:
        'Assessment of nutritional habits and activity levels to develop an immune-boosting vitality plan.',
    availableTimeSlots: ['10:00 AM', '12:00 PM', '01:45 PM', '04:00 PM'],
    imageAsset: 'assets/images/doctors/doc_16.jpg',
    isMale: true,
    initialRatingSum: 42.0,
    initialRatingCount: 9,
    avatarIcon: Icons.health_and_safety_rounded,
  ),
];

/// Helper to generate 20 seed appointments with realistic dynamic dates relative to DateTime.now()
/// Covering all 6 statuses: confirmed, pending, postponed, completed, cancelled, noShow
/// All with natural Egyptian patient names and Egyptian healthcare locations.
List<Appointment> generateInitialAppointments() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return [
    // 1. Confirmed (Upcoming)
    Appointment(
      id: 'apt_101',
      doctorId: 'doc_1',
      serviceId: 'breast_health',
      centerId: 'center_1',
      patientName: 'سارة خالد',
      date: today.add(const Duration(days: 2)),
      timeSlot: '10:30 AM',
      status: AppointmentStatus.confirmed,
      createdAt: today.subtract(const Duration(days: 3)),
      notes: 'فحص سريري واستشارة سنوية روتينية للكشف المبكر',
    ),
    Appointment(
      id: 'apt_102',
      doctorId: 'doc_5',
      serviceId: 'routine_followup',
      centerId: 'center_2',
      patientName: 'مريم إبراهيم',
      date: today.add(const Duration(days: 4)),
      timeSlot: '02:00 PM',
      status: AppointmentStatus.confirmed,
      createdAt: today.subtract(const Duration(days: 2)),
      notes: 'متابعة نتائج التحاليل الدورية والفحوصات',
    ),
    Appointment(
      id: 'apt_103',
      doctorId: 'doc_9',
      serviceId: 'psychological_support',
      centerId: 'center_3',
      patientName: 'نورهان مصطفى',
      date: today.add(const Duration(days: 6)),
      timeSlot: '11:30 AM',
      status: AppointmentStatus.confirmed,
      createdAt: today.subtract(const Duration(days: 1)),
      notes: 'جلسة دعم نفسي وإرشاد وجداني',
    ),
    Appointment(
      id: 'apt_104',
      doctorId: 'doc_13',
      serviceId: 'womens_health',
      centerId: 'center_4',
      patientName: 'فريدة محمود',
      date: today.add(const Duration(days: 9)),
      timeSlot: '01:00 PM',
      status: AppointmentStatus.confirmed,
      createdAt: today.subtract(const Duration(days: 4)),
      notes: 'استشارة صحة عامة وتوازن هرموني وتغذية',
    ),

    // 2. Pending Confirmation (Upcoming - Waiting center confirmation)
    Appointment(
      id: 'apt_105',
      doctorId: 'doc_3',
      serviceId: 'breast_health',
      centerId: 'center_2',
      patientName: 'رضوى الشريف',
      date: today.add(const Duration(days: 3)),
      timeSlot: '12:30 PM',
      status: AppointmentStatus.pending,
      createdAt: today.subtract(const Duration(hours: 12)),
      notes: 'مراجعة تصوير الماموجرام الرقمي الجديد',
    ),
    Appointment(
      id: 'apt_106',
      doctorId: 'doc_10',
      serviceId: 'psychological_support',
      centerId: 'center_3',
      patientName: 'آية عبد الرحمن',
      date: today.add(const Duration(days: 5)),
      timeSlot: '09:00 AM',
      status: AppointmentStatus.pending,
      createdAt: today.subtract(const Duration(hours: 6)),
      notes: 'طلب جلسة استماع واستشارة نفسية أولى',
    ),
    Appointment(
      id: 'apt_107',
      doctorId: 'doc_15',
      serviceId: 'womens_health',
      centerId: 'center_2',
      patientName: 'مروة كامل',
      date: today.add(const Duration(days: 8)),
      timeSlot: '02:00 PM',
      status: AppointmentStatus.pending,
      createdAt: today.subtract(const Duration(hours: 20)),
      notes: 'استشارة فحص سنوي شامل وتوازن هرموني',
    ),

    // 3. Postponed (Upcoming - Was rescheduled with original date displayed)
    Appointment(
      id: 'apt_108',
      doctorId: 'doc_2',
      serviceId: 'breast_health',
      centerId: 'center_1',
      patientName: 'منة الله إبراهيم',
      date: today.add(const Duration(days: 5)),
      timeSlot: '02:00 PM',
      status: AppointmentStatus.postponed,
      createdAt: today.subtract(const Duration(days: 7)),
      originalDate: today.subtract(const Duration(days: 1)),
      originalTimeSlot: '11:30 AM',
      notes: 'تم تأجيل الموعد بناءً على طلب المراجعة لظروف طارئة',
    ),
    Appointment(
      id: 'apt_109',
      doctorId: 'doc_7',
      serviceId: 'routine_followup',
      centerId: 'center_1',
      patientName: 'هبة السيد',
      date: today.add(const Duration(days: 7)),
      timeSlot: '04:15 PM',
      status: AppointmentStatus.postponed,
      createdAt: today.subtract(const Duration(days: 8)),
      originalDate: today.add(const Duration(days: 1)),
      originalTimeSlot: '09:00 AM',
      notes: 'تأجيل الموعد بسبب تحديث جدول عيادات المركز',
    ),
    Appointment(
      id: 'apt_110',
      doctorId: 'doc_11',
      serviceId: 'psychological_support',
      centerId: 'center_3',
      patientName: 'إسراء حسني',
      date: today.add(const Duration(days: 10)),
      timeSlot: '10:30 AM',
      status: AppointmentStatus.postponed,
      createdAt: today.subtract(const Duration(days: 5)),
      originalDate: today.subtract(const Duration(days: 2)),
      originalTimeSlot: '01:30 PM',
      notes: 'تم التأجيل إلى موعد الصباح الأنسب للمراجعة',
    ),

    // 4. Completed (Past - eligible for Review!)
    Appointment(
      id: 'apt_111',
      doctorId: 'doc_1',
      serviceId: 'breast_health',
      centerId: 'center_1',
      patientName: 'هاجر الشاذلي',
      date: today.subtract(const Duration(days: 3)),
      timeSlot: '09:00 AM',
      status: AppointmentStatus.completed,
      createdAt: today.subtract(const Duration(days: 10)),
      notes: 'فحص سريري كامل ومطمئن ولله الحمد بالمعهد',
    ),
    Appointment(
      id: 'apt_112',
      doctorId: 'doc_9',
      serviceId: 'psychological_support',
      centerId: 'center_3',
      patientName: 'شيماء فوزي',
      date: today.subtract(const Duration(days: 6)),
      timeSlot: '10:00 AM',
      status: AppointmentStatus.completed,
      createdAt: today.subtract(const Duration(days: 14)),
      notes: 'جلسة دعم نفسي وتخفيف التوتر والقلق',
    ),
    Appointment(
      id: 'apt_113',
      doctorId: 'doc_5',
      serviceId: 'routine_followup',
      centerId: 'center_2',
      patientName: 'ياسمين فاروق',
      date: today.subtract(const Duration(days: 11)),
      timeSlot: '11:00 AM',
      status: AppointmentStatus.completed,
      createdAt: today.subtract(const Duration(days: 18)),
      notes: 'متابعة دورية نصف سنوية لنتائج الفحص',
    ),
    Appointment(
      id: 'apt_114',
      doctorId: 'doc_13',
      serviceId: 'womens_health',
      centerId: 'center_4',
      patientName: 'ندى السعيد',
      date: today.subtract(const Duration(days: 16)),
      timeSlot: '10:30 AM',
      status: AppointmentStatus.completed,
      createdAt: today.subtract(const Duration(days: 22)),
      notes: 'فحص وقائي متكامل بصحة المرأة',
    ),
    Appointment(
      id: 'apt_115',
      doctorId: 'doc_6',
      serviceId: 'routine_followup',
      centerId: 'center_4',
      patientName: 'دعاء عبد الغني',
      date: today.subtract(const Duration(days: 21)),
      timeSlot: '08:00 AM',
      status: AppointmentStatus.completed,
      createdAt: today.subtract(const Duration(days: 28)),
      notes: 'متابعة سنوية شاملة للوظائف الحيوية',
    ),

    // 5. Cancelled (History - slot was freed)
    Appointment(
      id: 'apt_116',
      doctorId: 'doc_4',
      serviceId: 'breast_health',
      centerId: 'center_2',
      patientName: 'أمنية زهران',
      date: today.subtract(const Duration(days: 2)),
      timeSlot: '11:45 AM',
      status: AppointmentStatus.cancelled,
      createdAt: today.subtract(const Duration(days: 9)),
      notes: 'تم الإلغاء لتعارض الموعد مع ارتباط شخصي',
    ),
    Appointment(
      id: 'apt_117',
      doctorId: 'doc_12',
      serviceId: 'psychological_support',
      centerId: 'center_3',
      patientName: 'ريهام صبري',
      date: today.add(const Duration(days: 1)),
      timeSlot: '02:30 PM',
      status: AppointmentStatus.cancelled,
      createdAt: today.subtract(const Duration(days: 3)),
      notes: 'إلغاء الموعد المسبق لإعادة الحجز لاحقاً',
    ),
    Appointment(
      id: 'apt_118',
      doctorId: 'doc_16',
      serviceId: 'womens_health',
      centerId: 'center_4',
      patientName: 'نهال الجمال',
      date: today.subtract(const Duration(days: 15)),
      timeSlot: '04:00 PM',
      status: AppointmentStatus.cancelled,
      createdAt: today.subtract(const Duration(days: 20)),
      notes: 'اعتذار عن الحضور وإلغاء الحجز',
    ),

    // 6. No-Show (Past history)
    Appointment(
      id: 'apt_119',
      doctorId: 'doc_8',
      serviceId: 'routine_followup',
      centerId: 'center_4',
      patientName: 'مي مدحت',
      date: today.subtract(const Duration(days: 5)),
      timeSlot: '02:00 PM',
      status: AppointmentStatus.noShow,
      createdAt: today.subtract(const Duration(days: 12)),
      notes: 'لم تتمكن المراجعة من الحضور ولم يتم تأكيد الموعد',
    ),
    Appointment(
      id: 'apt_120',
      doctorId: 'doc_14',
      serviceId: 'womens_health',
      centerId: 'center_4',
      patientName: 'دينا الجوهري',
      date: today.subtract(const Duration(days: 13)),
      timeSlot: '01:30 PM',
      status: AppointmentStatus.noShow,
      createdAt: today.subtract(const Duration(days: 19)),
      notes: 'فائت - عدم الحضور في الموعد المحدد',
    ),
  ];
}

/// Helper to seed initial sample user reviews for 2 completed appointments
List<Review> generateInitialReviews() {
  final now = DateTime.now();
  return [
    Review(
      id: 'rev_101',
      appointmentId: 'apt_111',
      doctorId: 'doc_1',
      centerId: 'center_1',
      doctorRating: 5,
      centerRating: 5,
      overallRating: 5,
      comment:
          'تجربة ممتازة ومطمئنة للغاية، د. منى حسن طبيبة متميزة وصبورة، والرعاية بمعهد الأورام منظمة وراقية.',
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    Review(
      id: 'rev_102',
      appointmentId: 'apt_112',
      doctorId: 'doc_9',
      centerId: 'center_3',
      doctorRating: 5,
      centerRating: 4,
      overallRating: 5,
      comment:
          'جلسة دعم نفسي مريحة جداً مع د. ياسمين الصاوي ساعدتني على تجاوز مشاعر التوتر والقلق قبل الفحوصات.',
      createdAt: now.subtract(const Duration(days: 5)),
    ),
  ];
}
