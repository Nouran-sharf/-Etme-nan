import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../models/review.dart';
import '../state/app_state.dart';
import '../localization/app_translations.dart';
import '../theme/app_theme.dart';

/// Modal bottom sheet for rating a completed appointment.
/// Captures doctor, center, and overall experience ratings (1-5 stars) plus optional comment.
class ReviewBottomSheet extends StatefulWidget {
  final Appointment appointment;

  const ReviewBottomSheet({
    super.key,
    required this.appointment,
  });

  static Future<void> show(BuildContext context, Appointment appointment) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ReviewBottomSheet(appointment: appointment),
    );
  }

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  int _doctorRating = 0;
  int _centerRating = 0;
  int _overallRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isEditing = false;
  String? _errorMessage;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final appState = AppState.of(context);
      final existing = appState.getReviewForAppointment(widget.appointment.id);
      if (existing != null) {
        _isEditing = true;
        _doctorRating = existing.doctorRating;
        _centerRating = existing.centerRating;
        _overallRating = existing.overallRating;
        _commentController.text = existing.comment;
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;

    if (_doctorRating == 0 || _centerRating == 0 || _overallRating == 0) {
      setState(() {
        _errorMessage = AppTranslations.tr('reviewRequiredError', isArabic);
      });
      return;
    }

    final existing = appState.getReviewForAppointment(widget.appointment.id);
    final review = Review(
      id: existing?.id ??
          'rev_${DateTime.now().millisecondsSinceEpoch}_${widget.appointment.id}',
      appointmentId: widget.appointment.id,
      doctorId: widget.appointment.doctorId,
      centerId: widget.appointment.centerId,
      doctorRating: _doctorRating,
      centerRating: _centerRating,
      overallRating: _overallRating,
      comment: _commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    appState.submitOrUpdateReview(review);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppTranslations.tr('reviewSuccess', isArabic),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.primaryPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildStarPicker({
    required String label,
    required int rating,
    required ValueChanged<int> onRatingChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2036),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starNumber = index + 1;
            final isFilled = starNumber <= rating;
            return IconButton(
              iconSize: 32,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              constraints: const BoxConstraints(),
              icon: Icon(
                isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                color: isFilled ? const Color(0xFFFFB800) : Colors.grey.shade400,
              ),
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                });
                onRatingChanged(starNumber);
              },
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;
    final doctor = appState.getDoctorById(widget.appointment.doctorId);
    final center = appState.getCenterById(widget.appointment.centerId);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Title
            Text(
              AppTranslations.tr('reviewModalTitle', isArabic),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppTranslations.tr('reviewModalSubtitle', isArabic),
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 14),

            // Appointment Info Badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.softPink.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (doctor != null)
                    Row(
                      children: [
                        const Icon(Icons.person_rounded,
                            size: 16, color: AppTheme.primaryPurple),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            doctor.getName(isArabic),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppTheme.primaryPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (center != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 16, color: Color(0xFF6B5875)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            center.getName(isArabic),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B5875),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 14, color: Color(0xFF6B5875)),
                      const SizedBox(width: 6),
                      Text(
                        '${AppTranslations.formatDate(widget.appointment.date, isArabic)} • ${widget.appointment.timeSlot}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B5875),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 1. Doctor Rating
            _buildStarPicker(
              label: AppTranslations.tr('reviewDoctorRatingLabel', isArabic),
              rating: _doctorRating,
              onRatingChanged: (val) => setState(() => _doctorRating = val),
            ),
            const SizedBox(height: 14),

            // 2. Center Rating
            _buildStarPicker(
              label: AppTranslations.tr('reviewCenterRatingLabel', isArabic),
              rating: _centerRating,
              onRatingChanged: (val) => setState(() => _centerRating = val),
            ),
            const SizedBox(height: 14),

            // 3. Overall Experience Rating
            _buildStarPicker(
              label: AppTranslations.tr('reviewOverallRatingLabel', isArabic),
              rating: _overallRating,
              onRatingChanged: (val) => setState(() => _overallRating = val),
            ),
            const SizedBox(height: 16),

            // Comment Field
            Text(
              AppTranslations.tr('reviewCommentLabel', isArabic),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2036),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: AppTranslations.tr('reviewCommentHint', isArabic),
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: AppTheme.primaryPurple, width: 1.5),
                ),
              ),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                _isEditing
                    ? AppTranslations.tr('updateReview', isArabic)
                    : AppTranslations.tr('submitReview', isArabic),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
