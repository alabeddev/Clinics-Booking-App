import 'package:clinics_booking/models/doctor.dart';
import 'package:clinics_booking/providers/booking_data_provider.dart';
import 'package:clinics_booking/providers/notifications_provider.dart';
import 'package:clinics_booking/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clinics_booking/models/booking.dart';
import 'package:clinics_booking/providers/booking_provider.dart';
import 'package:clinics_booking/screens/booking_confirmation/widgets/booking_summary_card.dart';
import 'package:clinics_booking/screens/booking_confirmation/widgets/payment_details_card.dart';
import 'package:clinics_booking/screens/booking_confirmation/widgets/notes_input_field.dart';
import 'package:clinics_booking/screens/booking_screen/widgets/status_badge.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';
import 'package:clinics_booking/services/notification_service.dart';
import 'package:clinics_booking/models/notification.dart';

class BookingConfirmation extends ConsumerStatefulWidget {
  const BookingConfirmation({
    super.key,
    required this.doctor,
    this.existingBooking,
  });

  final DoctorModel doctor;
  final BookingModel? existingBooking;

  @override
  ConsumerState<BookingConfirmation> createState() =>
      _BookingConfirmationState();
}

class _BookingConfirmationState extends ConsumerState<BookingConfirmation> {
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _confirmationBooking() async {
    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception(
          AppLocalizations.of(context)!.loginRequiredToBook,
        ); // print
      }

      final selectedDate = ref.read(selectedDateProvider);
      final selectedTime = ref.read(selectedTimeProvider);

      if (selectedDate == null || selectedTime == null) {
        throw Exception(
          AppLocalizations.of(context)!.errorReadingAppointmentData,
        );
      }

      final hour = int.parse(selectedTime.split(':')[0]);
      final minute = int.parse(selectedTime.split(':')[1]);

      final finalDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        minute,
      );

      final String generateBookingId =
          'BKG_${DateTime.now().millisecondsSinceEpoch}';

      final newBooking = BookingModel(
        id: generateBookingId,
        userId: currentUser.uid,
        doctorId: widget.doctor.id,
        date: finalDateTime,
        status: AppLocalizations.of(context)!.pending,
        price: widget.doctor.price,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      await ref.read(bookingsProvider.notifier).addBooking(newBooking);

      final user = ref.read(authStateProvider).value;

      if (user != null) {
        final confirmNotif = NotificationModel(
          id: 'CONF_${DateTime.now().millisecondsSinceEpoch}',
          userId: user.uid,
          title: '📆 تأكيد ارسال الحجز',
          body: 'تم ارسال طلب حجز موعد مع ${widget.doctor.dname} بنجاح. ',
          createdAt: DateTime.now(),
        );

        await ref
            .read(notificationProvider.notifier)
            .addNotification(confirmNotif, user.uid);

        final reminderTime = finalDateTime.subtract(Duration(hours: 2));

        if (reminderTime.isAfter(DateTime.now())) {
          final reminderRecrd = NotificationModel(
            id: 'REM_${newBooking.id.hashCode}',
            userId: user.uid,
            title: ' ⏰ تذكير مجدول',
            body:
                'تم ضبط منبه لتذكيرك بموعد مع ${widget.doctor.dname} قبل ساعتين من الحضور ',
            createdAt: DateTime.now(),
          );

          await ref
              .read(notificationProvider.notifier)
              .addNotification(reminderRecrd, user.uid);

          await NotificationService.scheduleNotification(
            id: newBooking.id.hashCode,
            title: ' ⏰ تذكير بموعدك القادم',
            body: 'لديك موعد مع ${widget.doctor.dname} بعد ساعتين من الان ',
            scheduledTime: reminderTime,
          );

          ref.read(unreadBadgeProvider.notifier).state = true;
        } else {
          await NotificationService.showInstantNotification(
            id: newBooking.id.hashCode,
            title: ' ⏰ تذكير فوري بموعدك ',
            body: 'لديك موعد قريباً جداً مع ${widget.doctor.dname} ',
          );
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.bookingRequestSentSuccess,
            ),
            backgroundColor: Colors.green,
          ),
        );

        ref.read(selectedDateProvider.notifier).state = null;
        ref.read(selectedTimeProvider.notifier).state = null;

        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isViewMode = widget.existingBooking != null;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          isViewMode
              ? AppLocalizations.of(context)!.appointmentDetails
              : AppLocalizations.of(context)!.confirmBooking,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        foregroundColor: Colors.white,
      ),

      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    AppLocalizations.of(context)!.sendingBookingRequest,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.appointmentSummary,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 10),
                  BookingSummaryCard(
                    doctor: widget.doctor,
                    existingBooking: widget.existingBooking,
                  ),

                  const SizedBox(height: 30),

                  Text(
                    AppLocalizations.of(context)!.paymentDetails,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 10),
                  PaymentDetailsCard(price: widget.doctor.price),

                  const SizedBox(height: 30),

                  if (isViewMode) ...[
                    Text(
                      AppLocalizations.of(context)!.bookingStatus,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: StatusBadge(
                        status: widget.existingBooking!.status,
                      ),
                    ),

                    if (widget.existingBooking!.notes != null &&
                        widget.existingBooking!.notes!.isNotEmpty) ...[
                      const SizedBox(height: 30),

                      Text(
                        AppLocalizations.of(context)!.clinicNotes,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade200),
                        ),

                        child: Text(
                          widget.existingBooking!.notes!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ] else ...[
                    Text(
                      AppLocalizations.of(context)!.clinicNotesOptional,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 10),
                    NotesInputField(controller: _notesController),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
      bottomNavigationBar: isViewMode || _isLoading
          ? const SizedBox.shrink()
          : Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.05),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _confirmationBooking,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        AppLocalizations.of(context)!.confirmBooking,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
    );
  }
}
