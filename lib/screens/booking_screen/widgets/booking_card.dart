import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinics_booking/models/booking.dart';
import 'package:clinics_booking/models/doctor.dart';
import 'package:clinics_booking/providers/booking_provider.dart';
import 'package:clinics_booking/providers/doctors_provider.dart';
import 'package:clinics_booking/screens/booking_screen/widgets/status_badge.dart';
import 'package:clinics_booking/screens/booking_confirmation/booking_confirmation.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';
import 'package:clinics_booking/services/notification_service.dart';

class BookingCard extends ConsumerWidget {
  const BookingCard({super.key, required this.booking});

  final BookingModel booking;

  String _formatDateTime(DateTime dt, BuildContext context) {
    String period = dt.hour <= 12
        ? AppLocalizations.of(context)!.am
        : AppLocalizations.of(context)!.pm;
    int hour12 = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    String minute = dt.minute.toString().padLeft(2, '0');

    return '$hour12:$minute $period | ${dt.year}/${dt.month}/${dt.day} ';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allDoctors = ref.watch(doctorsProvider);
    final doctor = allDoctors.firstWhere(
      (d) => d.id == booking.doctorId,
      orElse: () => DoctorModel(
        id: '',
        dname: AppLocalizations.of(context)!.doctorNotAvailable,
        specialty: AppLocalizations.of(context)!.unknown,
        available: [],
        location: '',
        price: 0,
        details: '',
        evaluation: 0,
      ),
    );

    return InkWell(
      onTap: doctor.id.isEmpty
          ? null
          : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BookingConfirmation(
                    doctor: doctor,
                    existingBooking: booking,
                  ),
                ),
              );
            },

      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        color: Colors.white,

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      doctor.dname,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StatusBadge(status: booking.status),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                doctor.specialty,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1),
              ),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.access_time_filled,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Text(
                    _formatDateTime(booking.date, context),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const Spacer(),

                  if (booking.status ==
                          AppLocalizations.of(context)!.canceled ||
                      booking.status ==
                          AppLocalizations.of(context)!.canceledWithMaksoura)
                    IconButton(
                      onPressed: () {
                        ref
                            .read(bookingsProvider.notifier)
                            .deleteBooking(booking.id);

                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم الحذف بنجاح')),
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                ],
              ),

              if (booking.status == AppLocalizations.of(context)!.pending ||
                  booking.status ==
                      AppLocalizations.of(context)!.pendingWithHamza) ...[
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () =>
                        _showCancelDialog(context, ref, booking.id),
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                      size: 20,
                    ),
                    label: Text(
                      AppLocalizations.of(context)!.cancelAppointment,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.red.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(
    BuildContext context,
    WidgetRef ref,
    String bookingId,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 10),

            Text(AppLocalizations.of(context)!.cancelBooking),
          ],
        ),
        content: Text(
          AppLocalizations.of(context)!.cancelConfirmationMessage,
          style: TextStyle(height: 1.5),
        ),

        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.back,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(bookingsProvider.notifier)
                        .updateBookingStatus(
                          bookingId,
                          AppLocalizations.of(context)!.canceled,
                        );

                    NotificationService.cancelNotification(bookingId.hashCode);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.yesCancel,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
