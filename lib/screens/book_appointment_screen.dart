import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../localization/app_translations.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../widgets/app_bar_language_switch.dart';

/// Screen 4: Book / Reschedule Appointment Screen
/// Reused for both new bookings and updating existing bookings.
class BookAppointmentScreen extends StatefulWidget {
  final Doctor doctor;
  final Appointment? existingAppointment; // Non-null if rescheduling

  const BookAppointmentScreen({
    super.key,
    required this.doctor,
    this.existingAppointment,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  late final TextEditingController _patientNameController;
  late final TextEditingController _notesController;
  late DateTime _selectedDate;
  String? _selectedTimeSlot;

  String? _nameError;
  String? _slotError;
  String? _generalError;
  bool _isSubmitting = false;
  bool _initializedName = false;

  bool get isRescheduling => widget.existingAppointment != null;

  @override
  void initState() {
    super.initState();
    if (isRescheduling) {
      _patientNameController =
          TextEditingController(text: widget.existingAppointment!.patientName);
      _notesController =
          TextEditingController(text: widget.existingAppointment!.notes ?? '');
      _selectedDate = widget.existingAppointment!.date;
      _selectedTimeSlot = widget.existingAppointment!.timeSlot;
    } else {
      _patientNameController = TextEditingController();
      _notesController = TextEditingController();
      final now = DateTime.now();
      _selectedDate = DateTime(now.year, now.month, now.day);
      _selectedTimeSlot = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedName && !isRescheduling) {
      _initializedName = true;
      final appState = AppState.of(context);
      if (_patientNameController.text.isEmpty) {
        _patientNameController.text = appState.currentUserName;
      }
      final hasAvailableToday = widget.doctor.availableTimeSlots.any(
        (slot) =>
            appState.isSlotAvailable(widget.doctor.id, _selectedDate, slot),
      );
      if (!hasAvailableToday) {
        _selectedDate = _selectedDate.add(const Duration(days: 1));
      }
    }
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Open standard date picker restricted to today and the next 14 days
  Future<void> _pickDate(BuildContext context, bool isArabic) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final lastDate = firstDate.add(const Duration(days: 14));

    DateTime initial = _selectedDate;
    if (initial.isBefore(firstDate)) initial = firstDate;
    if (initial.isAfter(lastDate)) initial = lastDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: isArabic ? const Locale('ar') : const Locale('en'),
      helpText: AppTranslations.tr('appointmentDateLabel', isArabic),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.surface,
              onSurface: AppColors.darkText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
        _selectedTimeSlot = null;
        _slotError = null;
        _generalError = null;
      });
    }
  }

  /// Handle appointment form submission
  Future<void> _handleSubmit() async {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;
    final patientName = _patientNameController.text.trim();

    setState(() {
      _nameError = null;
      _slotError = null;
      _generalError = null;
    });

    bool hasError = false;

    // Validate patient name
    if (patientName.isEmpty) {
      setState(() {
        _nameError = AppTranslations.tr('patientNameRequired', isArabic);
      });
      hasError = true;
    }

    // Validate slot selection
    if (_selectedTimeSlot == null) {
      setState(() {
        _slotError = AppTranslations.tr('timeSlotRequired', isArabic);
      });
      hasError = true;
    }

    if (hasError) return;

    // Validate slot availability in state
    final isAvailable = appState.isSlotAvailable(
      widget.doctor.id,
      _selectedDate,
      _selectedTimeSlot!,
      excludeAppointmentId: widget.existingAppointment?.id,
    );

    if (!isAvailable) {
      setState(() {
        _generalError = AppTranslations.tr('duplicateBookingError', isArabic);
      });
      return;
    }

    setState(() => _isSubmitting = true);

    if (isRescheduling) {
      final success = await appState.rescheduleAppointment(
        widget.existingAppointment!.id,
        _selectedDate,
        _selectedTimeSlot!,
      );

      if (success) {
        _showSuccessAndNavigate(
          AppTranslations.tr('rescheduleSuccess', isArabic),
        );
      } else {
        setState(() {
          _isSubmitting = false;
          _generalError =
              AppTranslations.tr('duplicateBookingError', isArabic);
        });
      }
    } else {
      final newAppointment = Appointment(
        id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
        doctorId: widget.doctor.id,
        serviceId: widget.doctor.serviceId,
        centerId: widget.doctor.centerId,
        patientName: patientName,
        date: _selectedDate,
        timeSlot: _selectedTimeSlot!,
        status: AppointmentStatus.confirmed,
        createdAt: DateTime.now(),
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      final success = await appState.bookAppointment(newAppointment);

      if (success) {
        _showSuccessAndNavigate(
          AppTranslations.tr('bookingSuccess', isArabic),
        );
      } else {
        setState(() {
          _isSubmitting = false;
          _generalError =
              AppTranslations.tr('duplicateBookingError', isArabic);
        });
      }
    }
  }

  /// Show green success feedback and return to navigation shell
  void _showSuccessAndNavigate(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.elMessiri(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;
    final doctor = widget.doctor;
    final center = appState.getCenterById(doctor.centerId);
    final title = isRescheduling
        ? AppTranslations.tr('rescheduleTitle', isArabic)
        : AppTranslations.tr('bookTitle', isArabic);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.elMessiri(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        actions: const [
          AppBarLanguageSwitch(),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Doctor, Center & Service Summary Card
              _buildDoctorSummaryCard(doctor, center, isArabic),

              const SizedBox(height: 20),

              // 2. Patient Name Input (Required)
              _buildPatientNameField(isArabic),

              const SizedBox(height: 20),

              // 3. Date Selection Picker
              _buildDateSection(context, isArabic),

              const SizedBox(height: 20),

              // 4. Available Time Slots Wrap
              _buildTimeSlotsSection(appState, doctor, isArabic),

              const SizedBox(height: 20),

              // 5. Notes / Inquiry Field (Optional)
              _buildNotesField(isArabic),

              const SizedBox(height: 20),

              // 6. Live Booking Summary Card
              _buildBookingSummaryCard(doctor, center, isArabic),

              const SizedBox(height: 16),

              // Inline Error Display
              if (_generalError != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.errorBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: AppColors.error, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _generalError!,
                          style: GoogleFonts.elMessiri(
                            fontSize: 13,
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 7. Action Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor:
                      AppColors.primary.withValues(alpha: 0.6),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.white),
                        ),
                      )
                    : Text(
                        isRescheduling
                            ? AppTranslations.tr('saveChangesButton', isArabic)
                            : AppTranslations.tr(
                                'confirmBookingButton', isArabic),
                        style: GoogleFonts.elMessiri(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
              ),

              const SizedBox(height: 12),

              // Demo Reminder Note
              Center(
                child: Text(
                  AppTranslations.tr('demoNotice', isArabic),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.elMessiri(
                    fontSize: 12,
                    color: AppColors.mutedText,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Doctor and Service Summary Box with Portrait Photo
  Widget _buildDoctorSummaryCard(
      Doctor doctor, dynamic center, bool isArabic) {
    final serviceName =
        AppTranslations.tr('service_${doctor.serviceId}', isArabic);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder, width: 1.2),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              doctor.imageAsset,
              width: 58,
              height: 58,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Container(
                width: 58,
                height: 58,
                color: AppColors.softPink,
                child: const Icon(Icons.person_rounded,
                    color: AppColors.primary, size: 30),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.getName(isArabic),
                  style: GoogleFonts.elMessiri(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                Text(
                  serviceName,
                  style: GoogleFonts.elMessiri(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (center != null)
                  Text(
                    center.getName(isArabic),
                    style: GoogleFonts.elMessiri(
                      fontSize: 12,
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Required Patient Name Input
  Widget _buildPatientNameField(bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppTranslations.tr('patientNameLabel', isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '*',
              style: TextStyle(
                  color: AppColors.error,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.softPink,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                AppTranslations.tr('demoUserBadge', isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _patientNameController,
          enabled: !isRescheduling,
          onChanged: (_) {
            if (_nameError != null) setState(() => _nameError = null);
          },
          decoration: InputDecoration(
            hintText: AppTranslations.tr('patientNameHint', isArabic),
            prefixIcon: const Icon(Icons.person_outline_rounded,
                color: AppColors.primary),
            errorText: _nameError,
            errorStyle:
                GoogleFonts.elMessiri(color: AppColors.error, fontSize: 12),
          ),
        ),
      ],
    );
  }

  /// Optional Notes / Inquiries field
  Widget _buildNotesField(bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTranslations.tr('notesLabel', isArabic),
          style: GoogleFonts.elMessiri(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _notesController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: AppTranslations.tr('notesHint', isArabic),
            prefixIcon: const Icon(Icons.chat_bubble_outline_rounded,
                color: AppTheme.primaryPurple),
          ),
        ),
      ],
    );
  }

  /// Date picker section with formatted date and tap-to-select card
  Widget _buildDateSection(BuildContext context, bool isArabic) {
    final formatted = AppTranslations.formatDate(_selectedDate, isArabic);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTranslations.tr('appointmentDateLabel', isArabic),
          style: GoogleFonts.elMessiri(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppTranslations.tr('datePickerNotice', isArabic),
          style: GoogleFonts.elMessiri(
            fontSize: 12,
            color: AppColors.mutedText,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickDate(context, isArabic),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightBorder, width: 1.2),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded,
                    color: AppColors.primary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    formatted,
                    style: GoogleFonts.elMessiri(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
                Text(
                  AppTranslations.tr('tapToSelectDate', isArabic),
                  style: GoogleFonts.elMessiri(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Interactive Time Slot Chips
  Widget _buildTimeSlotsSection(
      AppState appState, Doctor doctor, bool isArabic) {
    final slots = doctor.availableTimeSlots;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppTranslations.tr('availableSlotsLabel', isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '*',
              style: TextStyle(
                  color: AppColors.error,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: slots.map((slot) {
            final isAvailable = appState.isSlotAvailable(
              doctor.id,
              _selectedDate,
              slot,
              excludeAppointmentId: widget.existingAppointment?.id,
            );
            final isSelected = _selectedTimeSlot == slot;

            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isAvailable
                        ? Icons.access_time_rounded
                        : Icons.block_rounded,
                    size: 15,
                    color: !isAvailable
                        ? Colors.grey.shade400
                        : (isSelected ? AppColors.white : AppColors.primary),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    slot,
                    style: GoogleFonts.elMessiri(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: !isAvailable
                          ? Colors.grey.shade400
                          : (isSelected
                              ? AppColors.white
                              : AppColors.darkText),
                      decoration: isAvailable
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.white,
              disabledColor: Colors.grey.shade100,
              side: BorderSide(
                color: !isAvailable
                    ? Colors.grey.shade300
                    : (isSelected
                        ? AppColors.primary
                        : AppColors.lightBorder),
                width: 1.2,
              ),
              onSelected: isAvailable
                  ? (selected) {
                      setState(() {
                        _selectedTimeSlot = selected ? slot : null;
                        _slotError = null;
                        _generalError = null;
                      });
                    }
                  : null,
            );
          }).toList(),
        ),
        if (_slotError != null) ...[
          const SizedBox(height: 6),
          Text(
            _slotError!,
            style:
                GoogleFonts.elMessiri(color: AppColors.error, fontSize: 12),
          ),
        ],
      ],
    );
  }

  /// Live Booking Summary Card
  Widget _buildBookingSummaryCard(
      Doctor doctor, dynamic center, bool isArabic) {
    final serviceName =
        AppTranslations.tr('service_${doctor.serviceId}', isArabic);
    final formattedDate = AppTranslations.formatDate(_selectedDate, isArabic);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softPink.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                AppTranslations.tr('bookingSummary', isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: AppColors.lightBorder),
          _buildSummaryRow(
            AppTranslations.tr('summaryDoctor', isArabic),
            doctor.getName(isArabic),
          ),
          const SizedBox(height: 6),
          _buildSummaryRow(
            AppTranslations.tr('summaryService', isArabic),
            serviceName,
          ),
          if (center != null) ...[
            const SizedBox(height: 6),
            _buildSummaryRow(
              AppTranslations.tr('summaryCenter', isArabic),
              center.getName(isArabic),
            ),
          ],
          const SizedBox(height: 6),
          _buildSummaryRow(
            AppTranslations.tr('summaryClinic', isArabic),
            doctor.getClinic(isArabic),
          ),
          const SizedBox(height: 6),
          _buildSummaryRow(
            AppTranslations.tr('summaryDate', isArabic),
            formattedDate,
          ),
          const SizedBox(height: 6),
          _buildSummaryRow(
            AppTranslations.tr('summaryTime', isArabic),
            _selectedTimeSlot ??
                AppTranslations.tr('tapToSelectDate', isArabic),
            highlight: _selectedTimeSlot != null,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool highlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: GoogleFonts.elMessiri(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedText,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.elMessiri(
              fontSize: 13,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
              color: highlight ? AppColors.primary : AppColors.darkText,
            ),
          ),
        ),
      ],
    );
  }
}
