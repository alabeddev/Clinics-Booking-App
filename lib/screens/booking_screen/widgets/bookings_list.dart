import 'package:flutter/material.dart';
import 'package:clinics_booking/models/booking.dart';
import 'package:clinics_booking/screens/booking_screen/widgets/booking_card.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';

class BookingsList extends StatelessWidget {
  const BookingsList({
    super.key,
    required this.bookings,
    required this.isUpcoming,
    required this.onRefresh,
  });

  final List<BookingModel> bookings;
  final bool isUpcoming;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUpcoming
                    ? Icons.calendar_month_outlined
                    : Icons.history_rounded,
                size: 70,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              isUpcoming
                  ? AppLocalizations.of(context)!.noUpcomingAppointments
                  : AppLocalizations.of(context)!.appointmentHistoryEmpty,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              isUpcoming
                  ? AppLocalizations.of(context)!.bookNowWithBestDoctors
                  : AppLocalizations.of(context)!.noClinicVisitedYet,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return BookingCard(booking: bookings[index]);
        },
      ),
    );
  }
}
