import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/state/app_state.dart';
import 'package:flutter_application_1/models/appointment.dart';
import 'package:flutter_application_1/models/review.dart';
import 'package:flutter_application_1/widgets/review_bottom_sheet.dart';
import 'package:flutter_application_1/data/mock_data.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Etmaenan smoke test and language toggle', (WidgetTester tester) async {
    // Build Etmaenan application
    await tester.pumpWidget(const EtmaenanApp());
    await tester.pumpAndSettle();

    // Verify initial launch is in Arabic with all 4 navigation tabs
    expect(find.text('اطمئنان'), findsWidgets);
    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.text('الخدمات والأطباء'), findsOneWidget);
    expect(find.text('المراكز الطبية'), findsOneWidget);
    expect(find.text('مواعيدي'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    // Tap language toggle button
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    // Verify application switches immediately to English
    expect(find.text('Etme\'nan'), findsWidgets);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Services & Doctors'), findsOneWidget);
    expect(find.text('Medical Centers'), findsOneWidget);
    expect(find.text('My Appointments'), findsOneWidget);
    expect(find.text('العربية'), findsOneWidget);
  });

  testWidgets('No horizontal overflow on narrow screens and large text scale', (WidgetTester tester) async {
    // Test on a very narrow mobile screen width (320px) with increased font scaling (1.4x)
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
        child: const EtmaenanApp(),
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
    expect(find.text('Manage in My Appointments'), findsWidgets);

    // Switch repeatedly back and forth
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Doctor cards on Services & Doctors screen do not overflow on narrow screens with large font scale', (WidgetTester tester) async {
    // Narrow 320px screen width with 1.4x font scaling
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
        child: const EtmaenanApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Navigate to Services & Doctors tab in Arabic
    await tester.tap(find.text('الخدمات والأطباء'));
    await tester.pumpAndSettle();

    // Verify Arabic doctor cards render without overflow
    expect(tester.takeException(), isNull);

    // Scroll through the doctor cards list to layout all doctors and centers
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // 2. Switch to English (LTR)
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    // Verify English doctor cards render with wrapped medical center names without overflow
    expect(tester.takeException(), isNull);
    expect(find.text('Services & Doctors'), findsWidgets);

    // Scroll through English doctor cards
    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
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

    // Duplicate booking on the same doctor/date/time should now be rejected
    expect(state.isSlotAvailable('doc_1', testDate, '09:00 AM'), isFalse);
    final duplicate = await state.bookAppointment(appointment.copyWith(id: 'test_apt_2'));
    expect(duplicate, isFalse);

    // Reschedule appointment to another slot
    final rescheduleSuccess = await state.rescheduleAppointment('test_apt_1', testDate, '01:00 PM');
    expect(rescheduleSuccess, isTrue);

    // Old slot is released
    expect(state.isSlotAvailable('doc_1', testDate, '09:00 AM'), isTrue);
    // New slot is now booked
    expect(state.isSlotAvailable('doc_1', testDate, '01:00 PM'), isFalse);

    // Cancel appointment
    await state.cancelAppointment('test_apt_1');
    // Released slot should be available again
    expect(state.isSlotAvailable('doc_1', testDate, '01:00 PM'), isTrue);
  });

  test('AppState review submission and doctor/center rating update', () async {
    final state = AppState();

    // Verify initial doctor rating is defined
    final initialDocRating = state.getDoctorAverageRating('doc_1');
    final initialDocCount = state.getDoctorReviewCount('doc_1');
    expect(initialDocRating, greaterThan(4.0));
    expect(initialDocCount, greaterThan(0));

    // Submit a review for completed appointment apt_111
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

  testWidgets('Health & Awareness screen renders correctly, expands articles, and toggles language', (WidgetTester tester) async {
    await tester.pumpWidget(const EtmaenanApp());
    await tester.pumpAndSettle();

    // 1. Locate the Health & Awareness dedicated card on Home
    final awarenessCardFinder = find.byKey(const Key('health_awareness_card'));
    expect(awarenessCardFinder, findsOneWidget);

    // 2. Tap to navigate to HealthAwarenessScreen
    await tester.tap(awarenessCardFinder);
    await tester.pumpAndSettle();

    // 3. Verify HealthAwarenessScreen elements in Arabic
    expect(find.text('وعي وصحة'), findsWidgets);
    expect(
      find.text('معلومات توعوية وتثقيفية، ولا تُعد بديلاً عن الاستشارة الطبية المتخصصة.'),
      findsOneWidget,
    );
    expect(find.text('الوعي بصحة الثدي: معرفة طبيعة جسمكِ'), findsOneWidget);

    // 4. Tap the first article to expand it
    await tester.tap(find.text('الوعي بصحة الثدي: معرفة طبيعة جسمكِ'));
    await tester.pumpAndSettle();

    // Verify expanded content: Key points, advice, verified source (WHO), date checked
    expect(find.text('النقاط الأساسية:'), findsOneWidget);
    expect(find.text('إرشاد مهم للاطمئنان'), findsOneWidget);
    expect(find.text('منظمة الصحة العالمية (WHO)'), findsOneWidget);
    expect(find.text('تاريخ التحقق: أكتوبر 2024'), findsOneWidget);
    expect(find.text('الاطلاع على المصدر المعتمد'), findsOneWidget);

    // 5. Test language switch in HealthAwarenessScreen
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Health & Awareness'), findsWidgets);
    expect(
      find.text('Educational information, not a substitute for medical consultation.'),
      findsOneWidget,
    );
    expect(find.text('Breast Awareness: Knowing What Is Normal for You'), findsOneWidget);
    expect(find.text('Date Checked: October 2024'), findsOneWidget);
    expect(find.text('Visit Official Reference'), findsOneWidget);
  });

  testWidgets('ReviewBottomSheet lifecycle: new review, editing, state preservation on language switch, and submission', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final appState = AppState();

    // Build ReviewBottomSheet within AppStateProvider
    await tester.pumpWidget(
      AppStateProvider(
        appState: appState,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final unreviewedAppointment = appState.appointments.firstWhere(
                  (a) => a.status == AppointmentStatus.completed && !appState.isAppointmentReviewed(a.id),
                  orElse: () => generateInitialAppointments().firstWhere((a) => a.id == 'apt_113'),
                );
                return ElevatedButton(
                  onPressed: () => ReviewBottomSheet.show(context, unreviewedAppointment),
                  child: const Text('Open Sheet'),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final unreviewedAppointment = appState.appointments.firstWhere(
      (a) => a.status == AppointmentStatus.completed && !appState.isAppointmentReviewed(a.id),
      orElse: () => generateInitialAppointments().firstWhere((a) => a.id == 'apt_113'),
    );

    // 1. Open a NEW review bottom sheet - must NOT crash with initState InheritedWidget error!
    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('تقييم زيارة الموعد'), findsOneWidget);
    expect(find.text('إرسال التقييم'), findsOneWidget);

    // 2. Validation error when submitting with 0 stars
    await tester.tap(find.text('إرسال التقييم'));
    await tester.pumpAndSettle();
    expect(find.text('يرجى تحديد جميع التقييمات بالنجوم (1-5 نجوم) للمتابعة.'), findsOneWidget);

    // 3. Select stars: Doctor = 4, Center = 5, Overall = 5
    // There are 15 star icon buttons in total (3 rows of 5 stars)
    final starButtons = find.byType(IconButton);
    await tester.tap(starButtons.at(3)); // Doctor: 4th star
    await tester.pumpAndSettle();
    await tester.tap(starButtons.at(9)); // Center: 5th star
    await tester.pumpAndSettle();
    await tester.tap(starButtons.at(14)); // Overall: 5th star
    await tester.pumpAndSettle();

    // 4. Enter a comment
    final commentField = find.byType(TextField);
    await tester.enterText(commentField, 'تجربة ممتازة ورعاية طبية راقية ومطمئنة.');
    await tester.pumpAndSettle();

    // 5. Test state preservation across dependency changes & language toggle
    // Toggle language while the sheet is actively open
    appState.toggleLocale(); // Now English
    await tester.pumpAndSettle();

    // Verify labels reactively updated to English
    expect(find.text('Rate Appointment Visit'), findsOneWidget);
    expect(find.text('Submit Review'), findsOneWidget);

    // Verify selected stars and typed comment were NOT reset or lost
    final commentFieldAfterToggle = tester.widget<TextField>(find.byType(TextField));
    expect(commentFieldAfterToggle.controller?.text, 'تجربة ممتازة ورعاية طبية راقية ومطمئنة.');

    // 6. Test Cancelling / Dismissing sheet
    Navigator.of(tester.element(find.byType(ReviewBottomSheet))).pop();
    await tester.pumpAndSettle();
    expect(find.text('Rate Appointment Visit'), findsNothing);

    // 7. Reopen sheet and submit
    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    final reopenedStarButtons = find.byType(IconButton);
    await tester.tap(reopenedStarButtons.at(3)); // 4 stars
    await tester.pumpAndSettle();
    await tester.tap(reopenedStarButtons.at(9)); // 5 stars
    await tester.pumpAndSettle();
    await tester.tap(reopenedStarButtons.at(14)); // 5 stars
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Comprehensive care and polite staff.');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Submit Review'));
    await tester.pumpAndSettle();

    // Verify sheet closed and review saved in AppState
    expect(find.text('Rate Appointment Visit'), findsNothing);
    expect(appState.isAppointmentReviewed(unreviewedAppointment.id), isTrue);
    final savedReview = appState.getReviewForAppointment(unreviewedAppointment.id);
    expect(savedReview, isNotNull);
    expect(savedReview!.doctorRating, equals(4));
    expect(savedReview.centerRating, equals(5));
    expect(savedReview.overallRating, equals(5));
    expect(savedReview.comment, 'Comprehensive care and polite staff.');

    // 8. Reopen the sheet for the SAME appointment -> Now in EDIT mode!
    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    expect(find.text('Update Review'), findsOneWidget);
    final editCommentField = tester.widget<TextField>(find.byType(TextField));
    expect(editCommentField.controller?.text, 'Comprehensive care and polite staff.');

    // Update rating and comment
    final editStarButtons = find.byType(IconButton);
    await tester.tap(editStarButtons.at(4)); // Change Doctor rating to 5 stars
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Updated: Outstanding experience from start to finish.');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Update Review'));
    await tester.pumpAndSettle();

    // Verify updated values persisted in AppState
    final updatedReview = appState.getReviewForAppointment(unreviewedAppointment.id);
    expect(updatedReview!.doctorRating, equals(5));
    expect(updatedReview.comment, 'Updated: Outstanding experience from start to finish.');
  });
}
