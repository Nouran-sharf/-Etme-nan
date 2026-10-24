import 'package:flutter/material.dart';
import '../models/awareness_article.dart';

/// Pre-bundled, verified educational articles for the "وعي وصحة / Health & Awareness" screen.
/// All claims and recommendations are verified against official healthcare authorities
/// (WHO, NHS, and NCI) and contextualized respectfully for Egypt.
const List<AwarenessArticle> mockAwarenessArticles = [
  AwarenessArticle(
    id: 'art-01',
    titleAr: 'الوعي بصحة الثدي: معرفة طبيعة جسمكِ',
    titleEn: 'Breast Awareness: Knowing What Is Normal for You',
    categoryTagAr: 'الوعي الذاتي',
    categoryTagEn: 'Self-Awareness',
    icon: Icons.favorite_outline,
    summaryAr:
        'الوعي بصحة الثدي يعني التعرف على المظهر والملمس الطبيعي لثدييكِ في مختلف أوقات الشهر، حتى تلاحظي أي تغيير غير معتاد بسهولة.',
    summaryEn:
        'Breast awareness means getting to know how your breasts normally look and feel at different times of the month, so you can easily spot any unusual change.',
    bulletPointsAr: [
      'لا توجد طريقة واحدة معقدة للفحص الذاتي؛ الأهم هو التعرف المنتظم على جسمكِ وملاحظة أي تبدلات أثناء الاستحمام أو تبديل الملابس.',
      'تغيرات الثدي الدورية شائعة وطبيعية وغالباً ما ترتبط بالدورة الشهرية والتغيرات الهرمونية الطبيعية.',
      'معظم كتل وتغيرات الثدي تكون حميدة وغير سرطانية (مثل الأكياس المائية والتكيسات الليفية الحميدة).',
      'معرفة طبيعة جسمكِ تمنحكِ الطمأنينة وتساعدكِ على استشارة الطبيب في الوقت المناسب دون تردد أو قلق.',
    ],
    bulletPointsEn: [
      'There is no single complicated way to check; what matters most is knowing what is normal for you during your daily routine.',
      'Monthly breast changes are common, normal, and often linked to the menstrual cycle and natural hormone fluctuations.',
      'The vast majority of breast changes and lumps turn out to be benign (non-cancerous, such as cysts or fibroadenomas).',
      'Familiarity with your body brings confidence and helps you consult a physician early without hesitation or undue alarm.',
    ],
    adviceAr:
        'اجعلي ملاحظة جسمكِ عادة طبيعية ومريحة، وتذكري أن ملاحظة أي تغير لا يعني بالضرورة وجود مشكلة خطيرة.',
    adviceEn:
        'Make checking a relaxed, natural habit. Remember that noticing a change rarely means something serious.',
    sourceName: 'منظمة الصحة العالمية (WHO)',
    sourceUrl: 'https://www.who.int/news-room/fact-sheets/detail/breast-cancer',
    dateCheckedAr: 'أكتوبر 2024',
    dateCheckedEn: 'October 2024',
  ),
  AwarenessArticle(
    id: 'art-02',
    titleAr: 'تغيرات تستدعي استشارة الطبيب المتخصص',
    titleEn: 'Changes That Warrant Medical Consultation',
    categoryTagAr: 'العلامات والتغيرات',
    categoryTagEn: 'Signs & Changes',
    icon: Icons.medical_services_outlined,
    summaryAr:
        'ملاحظة أي تغير مستمر وغير معتاد هي دعوة مطمئنة للاطمئنان عبر فحص سريري لدى طبيب متخصص دون تأخير.',
    summaryEn:
        'Noticing any persistent or unusual change is a reassuring reason to seek a clinical evaluation from a doctor without delay.',
    bulletPointsAr: [
      'ظهور كتلة جديدة أو سماكة في نسيج الثدي أو تحت الإبط تبدو مختلفة عن بقية الأنسجة.',
      'تغير ملحوظ في حجم الثدي أو شكله أو مظهره الخارجي.',
      'تغيرات في جلد الثدي مثل التنقير أو الانكماش (يشبه ملمس قشر البرتقال) أو احمرار غير مفسر.',
      'تغير في حلمة الثدي، مثل انغمارها للداخل، أو إفرازات غير معتادة وخاصة إذا كانت دموية.',
      'ألم مستمر في الثدي أو الإبط لا يرتبط بالدورة الشهرية ولا يزول بمرور الوقت.',
    ],
    bulletPointsEn: [
      'A new lump or thickening in the breast or armpit that feels distinct from surrounding tissue.',
      'A noticeable change in the size, shape, or contour of either breast.',
      'Skin changes such as dimpling, puckering (resembling an orange peel), or unexplained redness.',
      'Changes to the nipple, such as sudden inversion, rash, or unusual discharge (especially if bloody).',
      'Persistent pain in one breast or armpit that is unrelated to the menstrual cycle and does not resolve.',
    ],
    adviceAr:
        'تذكري دائماً أن 9 من كل 10 كتل تكون حميدة تماماً، ولكن الفحص الطبي المتخصص هو السبيل المعتمد لتأكيد الاطمئنان والسلامة.',
    adviceEn:
        'Remember that about 9 out of 10 breast lumps are completely benign; however, a doctor’s check is the definitive step to ensure peace of mind.',
    sourceName: 'هيئة الخدمات الصحية الوطنية البريطانية (NHS)',
    sourceUrl: 'https://www.nhs.uk/conditions/breast-cancer/symptoms/',
    dateCheckedAr: 'أكتوبر 2024',
    dateCheckedEn: 'October 2024',
  ),
  AwarenessArticle(
    id: 'art-03',
    titleAr: 'أساسيات الفحص المبكر: الماموجرام والموجات الصوتية',
    titleEn: 'Screening Basics: Mammography & Ultrasound',
    categoryTagAr: 'الفحوصات والكشف',
    categoryTagEn: 'Screening Basics',
    icon: Icons.health_and_safety_outlined,
    summaryAr:
        'الفحص المبكر يكشف التغيرات الدقيقة في أنسجة الثدي قبل أن تصبح محسوسة سريرياً بفترة طويلة، مما يجعل العلاج بسيطاً وفعالاً.',
    summaryEn:
        'Early screening identifies subtle changes in breast tissue long before they can be felt physically, making treatment simpler and highly effective.',
    bulletPointsAr: [
      'فحص الماموجرام (Mammography): أشعة سينية منخفضة الجرعة وآمنة ومصممة لتصوير نسيج الثدي بدقة عالية.',
      'في مصر، توصي المبادرة الرئاسية لدعم صحة المرأة بإجراء فحص الماموجرام الدوري للسيدات بدءاً من عمر 40 عاماً (أو في سن مبكرة بحسب إرشادات الطبيب في حال وجود تاريخ عائلي).',
      'الموجات فوق الصوتية (Ultrasound): فحص إضافي غير مؤلم يُستخدم بشكل شائع للسيدات الأصغر سناً أو لفحص الأنسجة ذات الكثافة العالية.',
      'الفحص السريري للثدي: تقييم بسيط يقوم به الطبيب المتخصص أثناء الزيارة الروتينية للتأكد من السلامة.',
    ],
    bulletPointsEn: [
      'Mammogram: A safe, low-dose X-ray examination designed to visualize breast tissue with high precision.',
      'In Egypt, the Presidential Women’s Health Initiative recommends routine mammography for women starting at age 40 (or earlier if advised by a specialist due to family history).',
      'Ultrasound: A painless, radiation-free supplementary test commonly used for younger women or denser breast tissue.',
      'Clinical Breast Exam: A physical check carried out respectfully by a trained healthcare professional during routine visits.',
    ],
    adviceAr:
        'الفحص الدوري المنتظم خطوة وقائية استباقية تحميكِ وتبث الطمأنينة في حياتكِ وحياة أسرتكِ.',
    adviceEn:
        'Regular screening is a proactive wellness step that protects you and provides lasting peace of mind for you and your family.',
    sourceName: 'المعهد القومي الأمريكي للأورام (NCI)',
    sourceUrl: 'https://www.cancer.gov/types/breast/patient/breast-screening-pdq',
    dateCheckedAr: 'أكتوبر 2024',
    dateCheckedEn: 'October 2024',
  ),
  AwarenessArticle(
    id: 'art-04',
    titleAr: 'عادات يومية صحية لصحة مستدامة وتوازن عام',
    titleEn: 'Healthy Daily Habits for Long-term Wellbeing',
    categoryTagAr: 'نمط الحياة والوقاية',
    categoryTagEn: 'Healthy Living',
    icon: Icons.spa_outlined,
    summaryAr:
        'اتباع نمط حياة متوازن ونشط يعزز مناعة الجسم العامة ويسهم في خفض مخاطر العديد من المشكلات الصحية طويلة الأمد.',
    summaryEn:
        'Adopting a balanced, active lifestyle supports your immune system and lowers the risk of many chronic health conditions.',
    bulletPointsAr: [
      'النشاط البدني المنتظم: ممارسة المشي المعتدل لمدة 30 دقيقة معظم أيام الأسبوع تدعم التوازن الهرموني والصحي.',
      'التغذية الطبيعية المتوازنة: الإكثار من الخضروات الورقية، الفواكه الطازجة، الحبوب الكاملة، والبروتينات الصحية.',
      'الحفاظ على وزن صحي ومعتدل ومستقر، خاصة بعد مرحلة انقطاع الطمث.',
      'الرضاعة الطبيعية: تشير الأدلة العلمية المعتمدة إلى أن الرضاعة الطبيعية توفر حماية وقائية صحية إضافية للأم والطفل.',
      'الابتعاد عن التدخين والتدخين السلبي لتعزيز الصحة التنفسية والوعائية العامة.',
    ],
    bulletPointsEn: [
      'Regular physical activity: 30 minutes of brisk walking most days of the week helps balance hormone levels and overall vitality.',
      'Nutritious diet: Enjoy plenty of colorful vegetables, fresh fruits, whole grains, and lean proteins.',
      'Maintaining a healthy, stable weight, particularly after menopause.',
      'Breastfeeding: Evidence shows that breastfeeding confers positive protective health benefits for both mother and baby.',
      'Avoiding smoking and second-hand smoke exposure to support cardiovascular and cellular wellness.',
    ],
    adviceAr:
        'الخطوات البسيطة المستمرة في روتينكِ اليومي تشكل درعاً واقياً يعزز طاقتكِ وحيويتكِ المستمرة.',
    adviceEn:
        'Consistent, positive daily lifestyle habits create a foundation for long-term health and vitality.',
    sourceName: 'منظمة الصحة العالمية والمعهد القومي للأورام (WHO / NCI)',
    sourceUrl: 'https://www.cancer.gov/types/breast/patient/breast-prevention-pdq',
    dateCheckedAr: 'أكتوبر 2024',
    dateCheckedEn: 'October 2024',
  ),
  AwarenessArticle(
    id: 'art-05',
    titleAr: 'الراحة النفسية وإدارة القلق قبل الفحوصات',
    titleEn: 'Emotional Wellbeing & Managing Screening Anxiety',
    categoryTagAr: 'الدعم النفسي',
    categoryTagEn: 'Emotional Wellbeing',
    icon: Icons.self_improvement_outlined,
    summaryAr:
        'الشعور بالتوتر قبل الفحوصات الطبية أو انتظار النتائج أمر شائع وطبيعي، والاعتراف بهذه المشاعر خطوة مهمة للتعامل معها بهدوء.',
    summaryEn:
        'Feeling anxious before medical checkups or while awaiting results is completely natural; acknowledging these feelings is the first step to calm reassurance.',
    bulletPointsAr: [
      'تذكري أن الفحص إجراء استباقي للاطمئنان والسلامة وليس دليلاً على وجود مرض.',
      'اطلبي من شخص تثقين به (أخت، صديقة، أو قريبة) مرافقتكِ إلى المركز الطبي لتقديم الدعم والراحة النفسية.',
      'تجنبي البحث العشوائي في شبكة الإنترنت أو تصديق الشائعات المغلوطة؛ اعتمدي فقط على المصادر الطبية الرسمية الموثوقة.',
      'مارسي تمارين التنفس العميق والاسترخاء أثناء الانتظار لتخفيف التوتر العضلي.',
      'تحدثي بانفتاح مع فريق التمريض والطبيب عن مشاعركِ؛ فهم متمرسون على توفير بيئة هادئة ومطمئنة.',
    ],
    bulletPointsEn: [
      'Remind yourself that screening is a proactive health check for reassurance, not a confirmation of illness.',
      'Invite a trusted friend or family member to accompany you to your appointment for comfort and emotional support.',
      'Avoid unvetted internet searches or worrying rumors; rely solely on qualified healthcare professionals and verified sources.',
      'Practice slow, deep breathing exercises while waiting to gently ease physical tension.',
      'Share your concerns openly with doctors and nursing staff; they are trained to offer reassurance and compassionate care.',
    ],
    adviceAr:
        'صحتكِ النفسية جزء لا يتجزأ من صحتكِ الجسدية؛ امنحي نفسكِ الوقت والرحمة دائماً.',
    adviceEn:
        'Your emotional wellbeing is just as important as physical health; treat yourself with patience and kindness.',
    sourceName: 'المعهد القومي الأمريكي للأورام (NCI)',
    sourceUrl: 'https://www.cancer.gov/about-cancer/coping/feelings',
    dateCheckedAr: 'أكتوبر 2024',
    dateCheckedEn: 'October 2024',
  ),
  AwarenessArticle(
    id: 'art-06',
    titleAr: 'كيف تستعدين لزيارة الفحص والاستشارة الطبية',
    titleEn: 'Preparing for Your Medical Appointment',
    categoryTagAr: 'التحضير للزيارة',
    categoryTagEn: 'Appointment Prep',
    icon: Icons.event_note_outlined,
    summaryAr:
        'التحضير المسبق لزيارتكِ الطبية يضمن لكِ الاستفادة القصوى من وقت المقابلة ويساعدكِ على طرح كل تساؤلاتكِ بوضوح.',
    summaryEn:
        'Preparing in advance for your appointment ensures you get the most out of your discussion and feel comfortable asking all your questions.',
    bulletPointsAr: [
      'ارتدي ملابس مريحة مكونة من قطعتين (بلوزة وتنورة أو بنطال) لتسهيل الفحص السريري دون عناء.',
      'في يوم فحص الماموجرام، تجنبي استخدام مزيلات العرق أو البودرة أو المستحضرات تحت الإبط أو على الصدر، لأنها قد تظهر كنقاط بيضاء في صور الأشعة.',
      'أحضري معكِ نتائج أي فحوصات أو صور أشعة سابقة إن وجدت لمقارنتها ومتابعة تطور الأنسجة.',
      'اختاري موعد الفحص في الأسبوع الذي يلي انتهاء الدورة الشهرية إذا أمكن، حيث يكون نسيج الثدي أقل حساسية واحتقاناً.',
      'اكتبي قائمة بأسئلتكِ واستفساراتكِ على هاتفكِ أو ورقة حتى لا تنسي أياً منها أثناء لقاء الطبيب.',
    ],
    bulletPointsEn: [
      'Wear a comfortable two-piece outfit (a top and skirt/trousers) so undressing for the exam is easy and stress-free.',
      'On mammogram day, avoid antiperspirants, powders, or lotions under the arms or on the chest, as they can mimic calcium spots on X-rays.',
      'Bring any prior mammograms, ultrasounds, or medical reports with you for clinical comparison over time.',
      'Schedule your appointment for the week following your period if possible, when breast tissue is least tender.',
      'Jot down a brief checklist of questions on your phone or notepad so you remember to ask everything on your mind.',
    ],
    adviceAr:
        'لا تترددي في طرح أي سؤال يدور في ذهنكِ على طبيبكِ؛ لا يوجد سؤال بسيط أو غير مهم في رحلة الاطمئنان على صحتكِ.',
    adviceEn:
        'Never hesitate to ask any question; every concern you have is valid and deserves a respectful, clear answer.',
    sourceName: 'هيئة الخدمات الصحية الوطنية البريطانية (NHS)',
    sourceUrl: 'https://www.nhs.uk/conditions/breast-cancer/getting-diagnosed/',
    dateCheckedAr: 'أكتوبر 2024',
    dateCheckedEn: 'October 2024',
  ),
  AwarenessArticle(
    id: 'art-07',
    titleAr: 'فهم التاريخ الصحي العائلي والتواصل مع طبيبكِ',
    titleEn: 'Understanding Family Health History & Risk Factors',
    categoryTagAr: 'التاريخ العائلي',
    categoryTagEn: 'Family History',
    icon: Icons.family_restroom_outlined,
    summaryAr:
        'معرفة التاريخ الصحي لأفراد الأسرة تساعد طبيبكِ على تحديد خطة الفحص الأنسب والتوقيت الأمثل لبدء المتابعة الدورية.',
    summaryEn:
        'Understanding your family medical history helps your healthcare provider personalize your screening plan and schedule.',
    bulletPointsAr: [
      'معظم حالات سرطان الثدي لا ترتبط بتاريخ عائلي وراثي، ولكن وجود تاريخ طبي في العائلة يستحق المناقشة مع طبيبكِ.',
      'استفسري عن التاريخ الصحي للأقارب من الدرجة الأولى (الأم، الأخت، الابنة) والدرجة الثانية من كلا جانبي العائلة (الأب والأم).',
      'العمر عند التشخيص مهم: إصابة أحد الأقارب في سن مبكرة (قبل سن الخمسين) قد تستدعي بدء الفحوصات في سن أبكر.',
      'ناقشي هذه المعلومات بهدوء مع طبيبكِ في المركز المتخصص ليضع لكِ خطة فحص ومتابعة شخصية تلائمكِ.',
    ],
    bulletPointsEn: [
      'Most breast cancer occurrences are not hereditary, but sharing your family background helps tailor your personalized care.',
      'Inquire gently about first-degree relatives (mother, sister, daughter) and second-degree relatives on both maternal and paternal sides.',
      'Age at diagnosis matters: a close relative diagnosed before age 50 may prompt earlier, more specialized surveillance.',
      'Discuss your family history calmly with your doctor to establish a personalized, proactive screening schedule.',
    ],
    adviceAr:
        'معرفة تاريخكِ العائلي هي وسيلة للتمكين والرعاية الوقائية الذكية، وليست مدعاة للقلق أو التخوف.',
    adviceEn:
        'Knowing your family history is a tool of empowerment and proactive care, not a reason for worry.',
    sourceName: 'المعهد القومي الأمريكي للأورام (NCI)',
    sourceUrl: 'https://www.cancer.gov/types/breast/risk-fact-sheet',
    dateCheckedAr: 'أكتوبر 2024',
    dateCheckedEn: 'October 2024',
  ),
];
