import 'package:clinics_booking/models/booking.dart';
import 'package:clinics_booking/models/doctor.dart';
import 'package:clinics_booking/providers/booking_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';

class BookingSummaryCard extends ConsumerWidget {
  const BookingSummaryCard({
    super.key,
    required this.doctor,
    this.existingBooking,
  });

  final DoctorModel doctor;
  final BookingModel? existingBooking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String dateString = AppLocalizations.of(context)!.notSpecified;
    String displayTimeText = AppLocalizations.of(context)!.notSpecified;

    if (existingBooking != null) {
      final dt = existingBooking!.date;
      dateString = '${dt.year}/${dt.month}/${dt.day}';

      String period = dt.hour <= 12
          ? AppLocalizations.of(context)!.am
          : AppLocalizations.of(context)!.pm;
      int hour12 = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      String minute = dt.minute.toString().padLeft(2, '0');

      displayTimeText = '$hour12:$minute $period';
    } else {
      final date = ref.watch(selectedDateProvider);
      final time = ref.watch(selectedTimeProvider);

      if (date != null) {
        dateString = '${date.year}/${date.month}/${date.day}';
      }

      if (time != null && time.toString().contains(':')) {
        final parts = time.toString().split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final formattedMinute = minute.toString().padLeft(2, '0');
        final period = hour < 12
            ? AppLocalizations.of(context)!.am
            : AppLocalizations.of(context)!.pm;
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

        displayTimeText = '$displayHour:$formattedMinute $period';
      } else {
        displayTimeText =
            time?.toString() ?? AppLocalizations.of(context)!.notSpecified;
      }
    }

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow(
              context,
              Icons.person,
              AppLocalizations.of(context)!.doctor,
              doctor.dname,
            ),

            const Divider(height: 24),

            _buildSummaryRow(
              context,
              Icons.medical_services,
              AppLocalizations.of(context)!.specialty,
              doctor.specialty,
            ),

            const Divider(height: 24),

            _buildSummaryRow(
              context,
              Icons.location_on,
              AppLocalizations.of(context)!.location,
              doctor.location,
            ),

            const Divider(height: 24),

            _buildSummaryRow(
              context,
              Icons.calendar_today,
              AppLocalizations.of(context)!.bookingDate,
              dateString,
            ),

            const Divider(height: 24),

            _buildSummaryRow(
              context,
              Icons.access_time_filled_outlined,
              AppLocalizations.of(context)!.hour,
              displayTimeText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    IconData icon,
    String title,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          size: 22,
        ),
        const SizedBox(width: 12),

        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),

        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            /*Directionality.of(context) == TextDirection.rtl
                ? TextAlign.start
                : TextAlign.end, */
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 16,
              color: isHighlight
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black87,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
