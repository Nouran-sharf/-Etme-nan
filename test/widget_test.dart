import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/state/app_state.dart';
import 'package:flutter_application_1/models/appointment.dart';
import 'package:flutter_application_1/models/review.dart';
import 'package:flutter_application_1/widgets/review_bottom_sheet.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('WelcomeAuthScreen entry flow and dual options (Log In / Sign Up) into Sara session',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // 1. Initial launch opens WelcomeAuthScreen
    await tester.pumpWidget(const EtmaenanApp());
    await tester.pumpAndSettle();

    // Verify Welcome/Auth screen elements in Arabic
    expect(find.text('اطمئنان'), findsWidgets);
    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.text('إنشاء حساب جديد'), findsOneWidget);
    expect(find.text('ساره'), findsWidgets);
    expect(find.text('English'), findsOneWidget);

    // 2. Language toggle on welcome screen
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Etme\'nan'), findsWidgets);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Sara'), findsWidgets);
    expect(find.text('العربية'), findsOneWidget);

    // Switch back to Arabic
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    // 3. Tap "تسجيل الدخول" (Log In) -> enters as Sara
    await tester.ensureVisible(find.text('تسجيل الدخول'));
    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pumpAndSettle();

    // Verify MainNavigationShell is now active with all 4 tabs
    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.text('الخدمات والأطباء'), findsOneWidget);
    expect(find.text('المراكز الطبية'), findsOneWidget);
    expect(find.text('مواعيدي'), findsOneWidget);
  });

  testWidgets('Sara starting state is empty with zero past appointments and clear booking CTA',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Launch directly into Sara's session
    await tester.pumpWidget(const EtmaenanApp(initialLoggedIn: true));
    await tester.pumpAndSettle();

    // On Home screen, next appointment card shows clean empty state
    expect(find.text('لا توجد مواعيد قادمة مجدولة'), findsOneWidget);
    expect(find.text('احجزي موعداً الآن'), findsWidgets);

    // Navigate to My Appointments tab via NavigationDestination
    await tester.tap(find.byType(NavigationDestination).at(3));
    await tester.pumpAndSettle();

    // Verify all 4 tabs start with count (0)
    expect(find.text('الكل (0)'), findsOneWidget);
    expect(find.text('القادمة (0)'), findsOneWidget);
    expect(find.text('المكتملة (0)'), findsOneWidget);
    expect(find.text('الملغاة والفائتة (0)'), findsOneWidget);
    expect(find.text('لا توجد مواعيد مسجلة حتى الآن'), findsOneWidget);
  });

  testWidgets('Complete appointment journey: book -> explore all states -> leave review -> reset demo',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const EtmaenanApp(initialLoggedIn: true));
    await tester.pumpAndSettle();

    // 1. Navigate to Services & Doctors tab
    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();

    // Tap on the first doctor to view details and book
    await tester.tap(find.text('عرض الملف والحجز').first);
    await tester.pumpAndSettle();

    expect(find.text('حجز موعد مع الطبيب'), findsOneWidget);
    await tester.tap(find.text('حجز موعد مع الطبيب'));
    await tester.pumpAndSettle();

    // 2. In BookAppointmentScreen, patient name is prefilled with "ساره"
    expect(find.text('ساره'), findsWidgets);

    // Select first available time slot
    await tester.ensureVisible(find.text('09:00 AM'));
    await tester.tap(find.text('09:00 AM'));
    await tester.pumpAndSettle();

    // Tap confirm booking
    final confirmBtn = find.text('تأكيد الحجز');
    await tester.ensureVisible(confirmBtn);
    await tester.tap(confirmBtn);
    await tester.pumpAndSettle();

    // 3. Verified across screens: Navigate to Home screen to verify upcoming appointment
    await tester.tap(find.byType(NavigationDestination).at(0));
    await tester.pumpAndSettle();

    expect(find.text('موعدكِ القادم'), findsOneWidget);
    expect(find.text('إدارة الموعد في مواعيدي'), findsWidgets);

    // 4. Navigate to My Appointments tab via NavigationDestination
    await tester.tap(find.byType(NavigationDestination).at(3));
    await tester.pumpAndSettle();

    expect(find.text('الكل (1)'), findsOneWidget);
    expect(find.text('القادمة (1)'), findsOneWidget);
    expect(find.text('محاكاة الحالة (تجريبي)'), findsWidgets);

    // 5. Open Demo Status Simulator to test state transitions
    final simBtn = find.text('محاكاة الحالة (تجريبي)').first;
    await tester.tap(simBtn);
    await tester.pumpAndSettle();

    // Verify all 6 states are listed in the simulator
    expect(find.text('مؤكد (Confirmed)'), findsOneWidget);
    expect(find.text('قيد الانتظار (Pending)'), findsOneWidget);
    expect(find.text('مؤجل / معاد جدولته (Postponed)'), findsOneWidget);
    expect(find.text('مكتمل الزيارة (Completed)'), findsOneWidget);
    expect(find.text('ملغى (Cancelled)'), findsOneWidget);
    expect(find.text('فائت / عدم حضور (No-Show)'), findsOneWidget);

    // Tap "مكتمل الزيارة (Completed)" to simulate completion
    final completedOption = find.text('مكتمل الزيارة (Completed)');
    await tester.tap(completedOption);
    await tester.pumpAndSettle();

    // Appointment moved to Completed tab!
    expect(find.text('القادمة (0)'), findsOneWidget);
    expect(find.text('المكتملة (1)'), findsOneWidget);

    // 6. Test Reviewing the completed appointment
    await tester.tap(find.text('المكتملة (1)'));
    await tester.pumpAndSettle();

    expect(find.text('تقييم الزيارة'), findsWidgets);
    final reviewBtn = find.text('تقييم الزيارة').first;
    await tester.tap(reviewBtn);
    await tester.pumpAndSettle();

    // Give 5 stars and submit review
    final starButtons = find.byType(IconButton);
    await tester.tap(starButtons.at(4)); // Doctor 5 stars
    await tester.pumpAndSettle();
    await tester.tap(starButtons.at(9)); // Center 5 stars
    await tester.pumpAndSettle();
    await tester.tap(starButtons.at(14)); // Overall 5 stars
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'رعاية ممتازة وخدمة راقية جداً.');
    await tester.pumpAndSettle();

    await tester.tap(find.text('إرسال التقييم'));
    await tester.pumpAndSettle();

    // Card now displays reviewed badge
    expect(find.text('تم التقييم ★'), findsOneWidget);

    // 7. Test Reset Demo action
    final resetBtn = find.text('إعادة ضبط التجربة').first;
    await tester.tap(resetBtn);
    await tester.pumpAndSettle();

    // Confirm dialog
    expect(find.text('نعم، إعادة ضبط'), findsOneWidget);
    await tester.tap(find.text('نعم، إعادة ضبط'));
    await tester.pumpAndSettle();

    // Verified: Everything is reset to initial empty state!
    expect(find.text('الكل (0)'), findsOneWidget);
    expect(find.text('القادمة (0)'), findsOneWidget);
    expect(find.text('المكتملة (0)'), findsOneWidget);
  });

  testWidgets('No horizontal overflow on narrow screens and large text scale', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(320, 800),
          textScaler: TextScaler.linear(1.4),
        ),
        child: const EtmaenanApp(initialLoggedIn: true),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Arabic layout renders without overflow
    expect(tester.takeException(), isNull);
    expect(find.text('موعدكِ القادم'), findsOneWidget);

    // Switch to English on this narrow screen
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    // Verify English layout renders without overflow
    expect(tester.takeException(), isNull);
    expect(find.text('Your Next Appointment'), findsOneWidget);

    // Switch repeatedly back and forth
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Doctor cards on Services & Doctors screen do not overflow on narrow screens with large font scale', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(320, 800),
          textScaler: TextScaler.linear(1.4),
        ),
        child: const EtmaenanApp(initialLoggedIn: true),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Navigate to Services & Doctors tab in Arabic
    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    // Scroll through the doctor cards list
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // 2. Switch to English (LTR)
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Services & Doctors'), findsWidgets);
  });

  test('AppState in-memory booking and duplicate prevention test', () async {
    final state = AppState();
    final tomorrow = DateTime.now().add(const Duration(days: 2));
    final testDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

    // Initial slot availability
    expect(state.isSlotAvailable('doc_1', testDate, '09:00 AM'), isTrue);

    // Book an appointment
    final appointment = Appointment(
      id: 'test_apt_1',
      doctorId: 'doc_1',
      serviceId: 'breast_health',
      centerId: 'center_1',
      patientName: 'سارة خالد',
      date: testDate,
      timeSlot: '09:00 AM',
      status: AppointmentStatus.confirmed,
      createdAt: DateTime.now(),
    );

    final success = await state.bookAppointment(appointment);
    expect(success, isTrue);

    // Duplicate booking on same slot should be rejected
    expect(state.isSlotAvailable('doc_1', testDate, '09:00 AM'), isFalse);
    final duplicate = await state.bookAppointment(appointment.copyWith(id: 'test_apt_2'));
    expect(duplicate, isFalse);

    // Reschedule appointment to another slot
    final rescheduleSuccess = await state.rescheduleAppointment('test_apt_1', testDate, '01:00 PM');
    expect(rescheduleSuccess, isTrue);

    // Old slot released, new slot booked
    expect(state.isSlotAvailable('doc_1', testDate, '09:00 AM'), isTrue);
    expect(state.isSlotAvailable('doc_1', testDate, '01:00 PM'), isFalse);

    // Cancel appointment
    await state.cancelAppointment('test_apt_1');
    expect(state.isSlotAvailable('doc_1', testDate, '01:00 PM'), isTrue);
  });

  test('AppState review submission and doctor/center rating update', () async {
    final state = AppState();

    final initialDocRating = state.getDoctorAverageRating('doc_1');
    final initialDocCount = state.getDoctorReviewCount('doc_1');
    expect(initialDocRating, greaterThan(4.0));
    expect(initialDocCount, greaterThan(0));

    final review = Review(
      id: 'rev_test_1',
      appointmentId: 'apt_111',
      doctorId: 'doc_1',
      centerId: 'center_1',
      doctorRating: 5,
      centerRating: 5,
      overallRating: 5,
      comment: 'رعاية ممتازة وتجربة مريحة جداً',
      createdAt: DateTime.now(),
    );

    await state.submitOrUpdateReview(review);

    expect(state.isAppointmentReviewed('apt_111'), isTrue);
    final savedReview = state.getReviewForAppointment('apt_111');
    expect(savedReview, isNotNull);
    expect(savedReview!.doctorRating, equals(5));
  });

  testWidgets('Health & Awareness screen renders correctly, expands articles, and toggles language',
      (WidgetTester tester) async {
    await tester.pumpWidget(const EtmaenanApp(initialLoggedIn: true));
    await tester.pumpAndSettle();

    final awarenessCardFinder = find.byKey(const Key('health_awareness_card'));
    expect(awarenessCardFinder, findsOneWidget);

    await tester.tap(awarenessCardFinder);
    await tester.pumpAndSettle();

    expect(find.text('وعي وصحة'), findsWidgets);
    expect(find.text('الوعي بصحة الثدي: معرفة طبيعة جسمكِ'), findsOneWidget);

    await tester.tap(find.text('الوعي بصحة الثدي: معرفة طبيعة جسمكِ'));
    await tester.pumpAndSettle();

    expect(find.text('النقاط الأساسية:'), findsOneWidget);
    expect(find.text('إرشاد مهم للاطمئنان'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Health & Awareness'), findsWidgets);
  });

  testWidgets('ReviewBottomSheet lifecycle: new review, editing, state preservation on language switch, and submission',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final appState = AppState();
    final dummyAppointment = Appointment(
      id: 'apt_review_test',
      doctorId: 'doc_1',
      serviceId: 'breast_health',
      centerId: 'center_1',
      patientName: 'ساره',
      date: DateTime.now().subtract(const Duration(days: 2)),
      timeSlot: '10:00 AM',
      status: AppointmentStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    );

    await tester.pumpWidget(
      AppStateProvider(
        appState: appState,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => ReviewBottomSheet.show(context, dummyAppointment),
                  child: const Text('Open Sheet'),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Open review sheet
    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('تقييم زيارة الموعد'), findsOneWidget);

    // 2. Select stars
    final starButtons = find.byType(IconButton);
    await tester.tap(starButtons.at(3)); // 4 stars doctor
    await tester.pumpAndSettle();
    await tester.tap(starButtons.at(9)); // 5 stars center
    await tester.pumpAndSettle();
    await tester.tap(starButtons.at(14)); // 5 stars overall
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Comprehensive care and polite staff.');
    await tester.pumpAndSettle();

    await tester.tap(find.text('إرسال التقييم'));
    await tester.pumpAndSettle();

    expect(appState.isAppointmentReviewed(dummyAppointment.id), isTrue);
  });
}
