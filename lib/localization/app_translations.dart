/// Centralized localization dictionary for the Etmaenan application.
/// Provides immediate bilingual lookup for Arabic and English with complete Egyptian context.
class AppTranslations {
  /// Arabic translations
  static final Map<String, String> _ar = {
    // App Branding
    'appName': 'اطمئنان',
    'appSubtitle': 'رعاية متخصصة لصحة المرأة وسرطان الثدي - مصر',
    'demoBadge': 'نموذج تجريبي',
    'demoNotice':
        'هذا التطبيق نموذج تعليمي وتجريبي. المواعيد والأطباء والتقييمات هي بيانات تجريبية افتراضية، والتطبيق غير تابع للجهات والمؤسسات الطبية المذكورة.',

    // Navigation (4 Bottom Navigation Tabs)
    'navHome': 'الرئيسية',
    'navServices': 'الخدمات والأطباء',
    'navCenters': 'المراكز الطبية',
    'navAppointments': 'مواعيدي',

    // Language switch
    'switchToEnglish': 'English',
    'switchToArabic': 'العربية',
    'currentLanguage': 'العربية',

    // Currency
    'currency': 'ج.م',
    'demoRatingLabel': 'تقييم تجريبي',

    // Home Screen
    'homeWelcomeTitle': 'صحتكِ واطمئنانكِ أولاً',
    'homeWelcomeSubtitle':
        'خطوتكِ الأولى نحو الفحص المبكر والرعاية الشاملة في بيئة هادئة وآمنة.',
    'bookAppointmentCta': 'احجزي موعداً الآن',
    'pinkOctoberTag': 'مبادرة أكتوبر الوردي',
    'pinkOctoberTitle': 'الكشف المبكر أمان واطمئنان',
    'pinkOctoberDesc':
        'نقدّم لكِ استشارات متخصصة ومتابعة دورية ودعماً نفسياً بكل خصوصية واحترام في كبرى المراكز المصرية. خطوة بسيطة اليوم تصنع فارقاً كبيراً.',
    'nextAppointmentTitle': 'موعدكِ القادم',
    'noUpcomingAppointments': 'لا توجد مواعيد قادمة مجدولة',
    'noUpcomingAppointmentsDesc':
        'احجزي استشارتكِ التخصصية أو متابعتكِ الدورية بخطوات سهلة وسريعة.',
    'viewInAppointments': 'إدارة الموعد في مواعيدي',
    'quickServicesTitle': 'خدماتنا التخصصية',
    'quickServicesSubtitle': 'اختاري التخصص لبدء حجز الموعد واستعراض الأطباء',
    'partnerCentersTitle': 'المراكز الطبية في مصر',
    'partnerCentersSubtitle': 'مؤسسات طبية وأكاديمية متخصصة مجهزة بأحدث التقنيات وأعلى معايير الرعاية',
    'viewAllCenters': 'عرض كافة المراكز',

    // Service Categories
    'service_breast_health': 'استشارة صحة الثدي',
    'service_breast_health_desc':
        'فحص سريري استباقي، تقييم مبكر، وإرشادات الفحص الذاتي.',
    'service_routine_followup': 'متابعة دورية',
    'service_routine_followup_desc':
        'متابعة الفحوصات والنتائج الدورية لضمان استقرار صحتكِ.',
    'service_psychological_support': 'دعم نفسي',
    'service_psychological_support_desc':
        'جلسات استشارية هادئة ومساندة وجدانية خلال رحلة الرعاية.',
    'service_womens_health': 'استشارة صحة المرأة',
    'service_womens_health_desc':
        'رعاية شاملة واستشارات وقائية لصحة المرأة العامة والتوازن الهرموني.',
    'service_all': 'الكل',

    // Services & Doctors Screen
    'servicesScreenTitle': 'الخدمات والأطباء',
    'searchHint': 'ابحثي باسم الطبيب أو التخصص أو العيادة...',
    'filterAll': 'كافة الخدمات',
    'filterByCenter': 'تصفية حسب المركز:',
    'allCenters': 'كافة المراكز',
    'experienceYears': 'سنوات خبرة',
    'viewDetailsButton': 'عرض الملف والحجز',
    'noDoctorsFoundTitle': 'لم نعثر على طبيب مطابق',
    'noDoctorsFoundDesc': 'يرجى مراجعة نص البحث أو تغيير التصفية المحددة.',
    'clearFiltersButton': 'إعادة ضبط التصفية والبحث',
    'genderFemale': 'طبيبة',
    'genderMale': 'طبيب',

    // Medical Centers Screen
    'centersScreenTitle': 'المراكز والمستشفيات في مصر',
    'searchCentersHint': 'ابحثي باسم المركز أو المدينة أو الحي...',
    'centerServicesOffered': 'الخدمات الطبية المتاحة:',
    'centerDoctors': 'الأطباء المتواجدون بالمركز',
    'viewDoctorsAtCenter': 'عرض أطباء هذا المركز',
    'centerContactDemo': 'بيانات الاتصال والتواصل',
    'centerPhone': 'هاتف الاستعلام:',
    'centerHotline': 'الخط الساخن:',
    'centerWebsite': 'الموقع الرسمي:',
    'centerEmail': 'البريد الإلكتروني:',
    'centerHours': 'أوقات العمل والعيادات:',
    'centerAddress': 'الموقع والعنوان في مصر:',
    'noCentersFoundTitle': 'لم نعثر على مراكز مطابقة',
    'noCentersFoundDesc': 'يرجى مراجعة نص البحث وتجربة اسم مدينة أو تخصص آخر.',
    'centerDetailsTitle': 'تفاصيل المركز الطبي',
    'centerPhotoLicenseInfo': 'ترخيص الصورة ومصدرها',

    // Photo Credits Dialog
    'photoCreditsTitle': 'تراخيص ومصادر الصور',
    'photoCreditsSubtitle': 'توثيق المشاع الإبداعي لصروح الرعاية الصحية بمصر',
    'photoCreditsDesc':
        'جميع صور المراكز الطبية في التطبيق هي صور فوتوغرافية حقيقية للمنشآت والمستشفيات المحددة في جمهورية مصر العربية، وموثقة برخص المشاع الإبداعي (Creative Commons) المعتمدة:',
    'photoAuthor': 'المصوّر / الناشر:',
    'photoLicense': 'نوع الترخيص:',
    'photoSource': 'صفحة التوثيق:',
    'photoNoticeResearch': 'توثيق بحث مؤسسات الأورام:',
    'photoNoticeResearchDesc':
        'تمت مراجعة مقرات مستشفيات بهية بالهرم والشيخ زايد ومستشفى شفاء الأورمان بالأقصر. ونظراً لعدم توفر صور خارجية مرخصة بالمشاع الإبداعي لمبانيهما، تم اعتماد صروح المعهد القومي للأورام ومستشفى 57357 وقصر العيني التعليمي بصور مرخصة رسمياً بـ CC0 وCC BY-SA التزاماً تاماً بحقوق الملكية.',
    'closeDialog': 'إغلاق',
    'viewPhotoCredits': 'مصادر وتراخيص الصور',

    // Doctor Details Screen
    'doctorDetailsTitle': 'الملف الطبي',
    'clinicLocation': 'مقر العيادة والمركز الطبي',
    'experience': 'الخبرة السريرية',
    'aboutDoctor': 'نبذة عن الطبيب',
    'aboutAppointmentType': 'عن نوع الموعد والاستشارة',
    'chooseAppointmentButton': 'حجز موعد مع الطبيب',
    'confidentialityNotice':
        'استشارة تخصصية آمنة ومريحة مع الحفاظ التام على الخصوصية والسرية.',
    'ratingScore': 'التقييم:',
    'reviewsCount': 'تقييماً',

    // Book / Reschedule Screen
    'bookTitle': 'حجز موعد',
    'rescheduleTitle': 'تعديل الموعد',
    'doctorAndServiceSummary': 'بيانات الطبيب والمركز والخدمة',
    'patientNameLabel': 'اسم المراجعة',
    'patientNameHint': 'أدخلي الاسم الكامل للمراجعة',
    'patientNameRequired': 'يرجى كتابة اسم المراجعة للمتابعة.',
    'appointmentDateLabel': 'تاريخ الموعد',
    'tapToSelectDate': 'اضغطي لاختيار التاريخ المناسب',
    'datePickerNotice': 'المواعيد المتاحة تبدأ من اليوم وحتى 14 يوماً قادمة (بتوقيت القاهرة).',
    'availableSlotsLabel': 'الأوقات المتاحة للحجز',
    'noSlotsAvailable': 'لا توجد أوقات شاغرة في هذا اليوم، يرجى اختيار تاريخ آخر.',
    'slotUnavailableNotice': 'هذا الوقت غير متاح أو محجوز مسبقاً لمراجعة أخرى.',
    'timeSlotRequired': 'يرجى اختيار وقت محدد من قائمة الأوقات المتاحة.',
    'duplicateBookingError':
        'عذراً، هذا الموعد محجوز بالفعل مع نفس الطبيب. يرجى اختيار وقت آخر.',
    'bookingSummary': 'ملخص تفاصيل الموعد',
    'summaryDoctor': 'الطبيب:',
    'summaryService': 'الخدمة:',
    'summaryCenter': 'المركز الطبي:',
    'summaryClinic': 'العيادة:',
    'summaryDate': 'التاريخ:',
    'summaryTime': 'الوقت:',
    'notesLabel': 'ملاحظات أو استفسارات إضافية (اختياري)',
    'notesHint': 'اكتبي أية أعراض تودين لفت انتباه الطبيب إليها...',
    'confirmBookingButton': 'تأكيد الحجز',
    'saveChangesButton': 'حفظ التعديلات',
    'bookingSuccess': 'تم تأكيد حجزكِ بنجاح! ننتظر زيارتكِ ونتمنى لكِ دوام العافية.',
    'rescheduleSuccess': 'تم تحديث الموعد بنجاح.',
    'slotLabel': 'الوقت المحدد:',

    // My Appointments Screen & Statuses
    'myAppointmentsTitle': 'مواعيدي',
    'tabAll': 'الكل',
    'tabUpcoming': 'القادمة',
    'tabCompleted': 'المكتملة',
    'tabCancelled': 'الملغاة والفائتة',
    'statusConfirmed': 'مؤكد',
    'statusCompleted': 'مكتمل',
    'statusCancelled': 'ملغي',
    'statusPending': 'قيد التأكيد',
    'statusPostponed': 'مؤجل',
    'statusNoShow': 'فائت / لم تحضر',
    'postponedNotice': 'تم تأجيل هذا الموعد من تاريخ سابق:',
    'rescheduleAction': 'تعديل الموعد',
    'cancelAction': 'إلغاء الموعد',
    'reviewAction': 'تقييم الزيارة',
    'editReviewAction': 'تعديل التقييم',
    'reviewedBadge': 'تم التقييم ★',
    'cancelDialogTitle': 'تأكيد إلغاء الموعد',
    'cancelDialogMessage':
        'هل تودين بالتأكيد إلغاء هذا الموعد؟ سيتم تحرير هذا الوقت فوراً ليكون متاحاً لمراجعة أخرى.',
    'keepAppointment': 'الاحتفاظ بالموعد',
    'confirmCancel': 'نعم، تأكيد الإلغاء',
    'cancelSuccess': 'تم إلغاء الموعد بنجاح وإتاحة الوقت.',
    'emptyUpcomingTitle': 'لا توجد مواعيد قادمة لديكِ',
    'emptyUpcomingDesc':
        'احرصي دائماً على الفحص والمتابعة الدورية. يمكنكِ حجز موعد جديد الآن.',
    'emptyCompletedTitle': 'لا توجد مواعيد مكتملة بعد',
    'emptyCompletedDesc': 'ستظهر المواعيد المكتملة هنا لتتمكني من تقييم التجربة ومتابعة السجل.',
    'emptyHistoryTitle': 'سجل المواعيد فارغ',
    'emptyHistoryDesc': 'ستظهر هنا المواعيد السابقة والملغاة والفائتة لاحقاً.',

    // Review Modal Bottom Sheet
    'reviewModalTitle': 'تقييم زيارة الموعد',
    'reviewModalSubtitle': 'رأيكِ الصادق يساعدنا في تحسين وتطوير تجربة الرعاية الصحية.',
    'reviewDoctorRatingLabel': 'تقييم الاستشارة مع الطبيب:',
    'reviewCenterRatingLabel': 'تقييم المركز والخدمة الطبية:',
    'reviewOverallRatingLabel': 'التقييم العام للتجربة:',
    'reviewCommentLabel': 'ملاحظاتكِ أو تعليقكِ (اختياري)',
    'reviewCommentHint': 'شاركينا انطباعكِ حول الزيارة ومستوى الرعاية...',
    'submitReview': 'إرسال التقييم',
    'updateReview': 'تحديث التقييم',
    'reviewSuccess': 'شكراً جزيلاً! تم حفظ تقييمكِ بنجاح.',
    'reviewRequiredError': 'يرجى تحديد جميع التقييمات بالنجوم (1-5 نجوم) للمتابعة.',

    // Reset Demo Data
    'resetDemoDataTitle': 'إعادة ضبط البيانات التجريبية',
    'resetDemoDataMessage':
        'سيؤدي هذا الإجراء إلى حذف جميع الحجوزات والتقييمات المضافة محلياً وإعادة التطبيق إلى البيانات التجريبية الافتراضية. هل ترغبين بالاستمرار؟',
    'resetConfirmButton': 'نعم، إعادة ضبط',
    'resetCancelButton': 'إلغاء',
    'resetSuccess': 'تمت إعادة ضبط البيانات التجريبية بنجاح.',
    'resetDemoTooltip': 'إعادة ضبط البيانات التجريبية',

    // Health & Awareness Screen
    'awarenessScreenTitle': 'وعي وصحة',
    'awarenessScreenSubtitle': 'دليلكِ التوعوي المبسط والمبني على أدلة علمية موثوقة',
    'awarenessCardTitle': 'دليل وعي وصحة',
    'awarenessCardSubtitle': 'مقالات توعوية مبسطة وموثوقة للاطمئنان على صحتكِ وإرشادات الفحص المبكر.',
    'awarenessCardBadge': 'مقالات موثوقة',
    'awarenessDisclaimer': 'معلومات توعوية وتثقيفية، ولا تُعد بديلاً عن الاستشارة الطبية المتخصصة.',
    'searchArticlesHint': 'ابحثي في مقالات الوعي الصحي...',
    'allArticlesFilter': 'الكل',
    'keyTakeawayTitle': 'إرشاد مهم للاطمئنان',
    'keyPointsTitle': 'النقاط الأساسية:',
    'sourceVerifiedLabel': 'المصدر المعتمد:',
    'dateCheckedLabel': 'تاريخ التحقق:',
    'visitSourceLink': 'الاطلاع على المصدر المعتمد',
    'linkCopiedMessage': 'تم نسخ رابط المصدر إلى الحافظة',
    'couldNotOpenLinkMessage': 'تعذر فتح الرابط تلقائياً، تم نسخه إلى الحافظة.',
    'noArticlesFound': 'لم نجد مقالات تطابق بحثكِ',
    'noArticlesFoundDesc': 'جربي استخدام كلمات بحث أخرى أو إزالة عامل التصفية.',
    'articlesCount': 'مقالات توعوية',
    'exploreAwarenessCta': 'تصفحي دليل الوعي والصحة',
  };

  /// English translations
  static final Map<String, String> _en = {
    // App Branding
    'appName': 'Etme\'nan',
    'appSubtitle': 'Specialized Breast Health & Women\'s Wellbeing Care - Egypt',
    'demoBadge': 'Demo Prototype',
    'demoNotice':
        'This is an educational prototype. Bookings, doctors, and ratings are demo data. The app is not affiliated with the listed institutions.',

    // Navigation (4 Bottom Navigation Tabs)
    'navHome': 'Home',
    'navServices': 'Services & Doctors',
    'navCenters': 'Medical Centers',
    'navAppointments': 'My Appointments',

    // Language switch
    'switchToEnglish': 'English',
    'switchToArabic': 'العربية',
    'currentLanguage': 'English',

    // Currency
    'currency': 'EGP',
    'demoRatingLabel': 'Demo rating',

    // Home Screen
    'homeWelcomeTitle': 'Your Health & Peace of Mind First',
    'homeWelcomeSubtitle':
        'Your first step towards early detection and compassionate care in a calm, supportive environment.',
    'bookAppointmentCta': 'Book an Appointment',
    'pinkOctoberTag': 'Pink October Initiative',
    'pinkOctoberTitle': 'Early Detection Brings Reassurance',
    'pinkOctoberDesc':
        'We provide breast-health consultations, routine follow-ups, and psychological support with total privacy across leading Egyptian healthcare centers.',
    'nextAppointmentTitle': 'Your Next Appointment',
    'noUpcomingAppointments': 'No upcoming appointments scheduled',
    'noUpcomingAppointmentsDesc':
        'Easily book a specialized consultation or routine checkup in a few simple steps.',
    'viewInAppointments': 'Manage in My Appointments',
    'quickServicesTitle': 'Specialized Services',
    'quickServicesSubtitle': 'Choose a service to explore doctors and schedule a visit',
    'partnerCentersTitle': 'Medical Centers in Egypt',
    'partnerCentersSubtitle': 'Specialized Egyptian university and oncology healthcare institutions',
    'viewAllCenters': 'View All Centers',

    // Service Categories
    'service_breast_health': 'Breast Health Consultation',
    'service_breast_health_desc':
        'Clinical examination, early assessment, and guidance on regular self-examination.',
    'service_routine_followup': 'Routine Follow-up',
    'service_routine_followup_desc':
        'Periodic review of test results and ongoing health monitoring with specialists.',
    'service_psychological_support': 'Psychological Support',
    'service_psychological_support_desc':
        'Quiet, supportive counseling sessions throughout your care and screening journey.',
    'service_womens_health': 'Women’s Health Consultation',
    'service_womens_health_desc':
        'Comprehensive preventative care, hormonal balance, and female wellbeing.',
    'service_all': 'All',

    // Services & Doctors Screen
    'servicesScreenTitle': 'Services & Doctors',
    'searchHint': 'Search by doctor name, specialty, or clinic...',
    'filterAll': 'All Services',
    'filterByCenter': 'Filter by Center:',
    'allCenters': 'All Centers',
    'experienceYears': 'years exp',
    'viewDetailsButton': 'View Profile & Book',
    'noDoctorsFoundTitle': 'No matching doctors found',
    'noDoctorsFoundDesc': 'Try different search keywords or reset active filters.',
    'clearFiltersButton': 'Clear Filters & Search',
    'genderFemale': 'Female Doctor',
    'genderMale': 'Male Doctor',

    // Medical Centers Screen
    'centersScreenTitle': 'Healthcare Centers in Egypt',
    'searchCentersHint': 'Search by center name, city, or area...',
    'centerServicesOffered': 'Available Medical Services:',
    'centerDoctors': 'Doctors at this Center',
    'viewDoctorsAtCenter': 'View Doctors at this Center',
    'centerContactDemo': 'Contact Information & Hotline',
    'centerPhone': 'Inquiry Phone:',
    'centerHotline': 'Hotline:',
    'centerWebsite': 'Official Website:',
    'centerEmail': 'Email Address:',
    'centerHours': 'Operating & Clinic Hours:',
    'centerAddress': 'Location & Address in Egypt:',
    'noCentersFoundTitle': 'No matching centers found',
    'noCentersFoundDesc': 'Please check search query or try searching for another city.',
    'centerDetailsTitle': 'Medical Center Details',
    'centerPhotoLicenseInfo': 'Photo License & Attribution',

    // Photo Credits Dialog
    'photoCreditsTitle': 'Photo Credits & Licenses',
    'photoCreditsSubtitle': 'Creative Commons Documentation for Egyptian Centers',
    'photoCreditsDesc':
        'All medical center photographs in this app depict the actual healthcare facilities in Egypt and are licensed under documented Creative Commons licenses:',
    'photoAuthor': 'Photographer / Author:',
    'photoLicense': 'License Type:',
    'photoSource': 'Source Documentation:',
    'photoNoticeResearch': 'Oncology Research & Verification Note:',
    'photoNoticeResearchDesc':
        'Official pages for Baheya (Haram & Sheikh Zayed) and Shefaa Al Orman (Luxor) were researched. Because no Creative Commons exterior photos of their buildings are published, verified Egyptian institutions (National Cancer Institute, 57357, Kasr Al-Aini) with CC0/CC BY-SA photos were selected to maintain strict copyright compliance.',
    'closeDialog': 'Close',
    'viewPhotoCredits': 'Photo Credits',

    // Doctor Details Screen
    'doctorDetailsTitle': 'Doctor Profile',
    'clinicLocation': 'Clinic & Center Location',
    'experience': 'Clinical Experience',
    'aboutDoctor': 'About the Doctor',
    'aboutAppointmentType': 'About this Appointment',
    'chooseAppointmentButton': 'Book with this Doctor',
    'confidentialityNotice':
        'A safe, reassuring, and completely confidential medical consultation.',
    'ratingScore': 'Rating:',
    'reviewsCount': 'reviews',

    // Book / Reschedule Screen
    'bookTitle': 'Book Appointment',
    'rescheduleTitle': 'Reschedule Appointment',
    'doctorAndServiceSummary': 'Doctor, Center & Service Information',
    'patientNameLabel': 'Patient Name',
    'patientNameHint': 'Enter full patient name',
    'patientNameRequired': 'Please enter patient name to proceed.',
    'appointmentDateLabel': 'Appointment Date',
    'tapToSelectDate': 'Tap to choose a preferred date',
    'datePickerNotice': 'Appointments are available today and within the next 14 days (Cairo Time).',
    'availableSlotsLabel': 'Available Time Slots',
    'noSlotsAvailable': 'No open slots on this date. Please select another day.',
    'slotUnavailableNotice': 'This time slot is unavailable or already booked.',
    'timeSlotRequired': 'Please select an available time slot.',
    'duplicateBookingError':
        'This slot is already booked with this doctor. Please choose another time.',
    'bookingSummary': 'Booking Summary',
    'summaryDoctor': 'Doctor:',
    'summaryService': 'Service:',
    'summaryCenter': 'Medical Center:',
    'summaryClinic': 'Clinic:',
    'summaryDate': 'Date:',
    'summaryTime': 'Time:',
    'notesLabel': 'Additional Notes or Inquiries (Optional)',
    'notesHint': 'Mention any symptoms or inquiries you wish to share with the doctor...',
    'confirmBookingButton': 'Confirm Booking',
    'saveChangesButton': 'Save Changes',
    'bookingSuccess':
        'Your appointment has been confirmed! We look forward to welcoming you.',
    'rescheduleSuccess': 'Your appointment has been successfully updated.',
    'slotLabel': 'Selected Slot:',

    // My Appointments Screen & Statuses
    'myAppointmentsTitle': 'My Appointments',
    'tabAll': 'All',
    'tabUpcoming': 'Upcoming',
    'tabCompleted': 'Completed',
    'tabCancelled': 'Cancelled / History',
    'statusConfirmed': 'Confirmed',
    'statusCompleted': 'Completed',
    'statusCancelled': 'Cancelled',
    'statusPending': 'Pending Confirmation',
    'statusPostponed': 'Postponed',
    'statusNoShow': 'No Show',
    'postponedNotice': 'Postponed from earlier date:',
    'rescheduleAction': 'Reschedule',
    'cancelAction': 'Cancel',
    'reviewAction': 'Review Visit',
    'editReviewAction': 'Edit Review',
    'reviewedBadge': 'Reviewed ★',
    'cancelDialogTitle': 'Confirm Cancellation',
    'cancelDialogMessage':
        'Are you sure you want to cancel this appointment? The slot will immediately become available for other patients.',
    'keepAppointment': 'Keep Appointment',
    'confirmCancel': 'Yes, Cancel',
    'cancelSuccess': 'Appointment cancelled and time slot released.',
    'emptyUpcomingTitle': 'No upcoming appointments',
    'emptyUpcomingDesc':
        'Prioritize your wellbeing with routine checkups. Book a consultation now.',
    'emptyCompletedTitle': 'No completed visits yet',
    'emptyCompletedDesc':
        'Completed visits will appear here so you can leave a review and manage your care history.',
    'emptyHistoryTitle': 'No appointment history',
    'emptyHistoryDesc': 'Your past, cancelled, and no-show appointments will appear here.',

    // Review Modal Bottom Sheet
    'reviewModalTitle': 'Rate Appointment Visit',
    'reviewModalSubtitle':
        'Your honest feedback helps us enhance the quality of patient care.',
    'reviewDoctorRatingLabel': 'Doctor / Consultant Rating:',
    'reviewCenterRatingLabel': 'Medical Center & Facility Rating:',
    'reviewOverallRatingLabel': 'Overall Experience Rating:',
    'reviewCommentLabel': 'Your Feedback & Comments (Optional)',
    'reviewCommentHint': 'Share your experience regarding clinical care and comfort...',
    'submitReview': 'Submit Review',
    'updateReview': 'Update Review',
    'reviewSuccess': 'Thank you! Your review has been submitted successfully.',
    'reviewRequiredError':
        'Please provide star ratings (1 to 5 stars) for all categories.',

    // Reset Demo Data
    'resetDemoDataTitle': 'Reset Demo Data',
    'resetDemoDataMessage':
        'This will clear all locally saved appointments, reschedules, and reviews, restoring the default demonstration data. Do you wish to continue?',
    'resetConfirmButton': 'Yes, Reset',
    'resetCancelButton': 'Cancel',
    'resetSuccess': 'Demo data has been successfully reset.',
    'resetDemoTooltip': 'Reset Demo Data',

    // Health & Awareness Screen
    'awarenessScreenTitle': 'Health & Awareness',
    'awarenessScreenSubtitle': 'Your simplified, evidence-based breast health guide',
    'awarenessCardTitle': 'Health & Awareness Guide',
    'awarenessCardSubtitle': 'Simplified, evidence-based articles for peace of mind and early screening guidance.',
    'awarenessCardBadge': 'Verified Articles',
    'awarenessDisclaimer': 'Educational information, not a substitute for medical consultation.',
    'searchArticlesHint': 'Search health awareness articles...',
    'allArticlesFilter': 'All',
    'keyTakeawayTitle': 'Key Reassurance Note',
    'keyPointsTitle': 'Key Points:',
    'sourceVerifiedLabel': 'Verified Source:',
    'dateCheckedLabel': 'Date Checked:',
    'visitSourceLink': 'Visit Official Reference',
    'linkCopiedMessage': 'Source link copied to clipboard',
    'couldNotOpenLinkMessage': 'Could not open link in browser; copied to clipboard.',
    'noArticlesFound': 'No articles match your search',
    'noArticlesFoundDesc': 'Try searching with different keywords or clearing filters.',
    'articlesCount': 'educational articles',
    'exploreAwarenessCta': 'Explore Awareness Guide',
  };

  /// Translate a key given the language context
  static String tr(String key, bool isArabic) {
    if (isArabic) {
      return _ar[key] ?? _en[key] ?? key;
    } else {
      return _en[key] ?? _ar[key] ?? key;
    }
  }

  /// Format date nicely in Arabic or English with Egyptian conventions
  static String formatDate(DateTime date, bool isArabic) {
    const arabicMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    const englishMonths = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    const arabicDays = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد'
    ];
    const englishDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    final dayName =
        isArabic ? arabicDays[date.weekday - 1] : englishDays[date.weekday - 1];
    final monthName =
        isArabic ? arabicMonths[date.month - 1] : englishMonths[date.month - 1];

    if (isArabic) {
      return '$dayName، ${date.day} $monthName ${date.year}';
    } else {
      return '$dayName, ${date.day} $monthName ${date.year}';
    }
  }
}
