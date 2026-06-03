import 'package:clinics_booking/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinics_booking/providers/booking_data_provider.dart';
import 'package:clinics_booking/screens/doctor_details/widgets/time_slots.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';

class BookingDatePicker extends ConsumerWidget {
  const BookingDatePicker({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    //final selectedTime = ref.watch(selectedTimeProvider);

    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              final now = DateTime.now();
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: now,
                firstDate: now,
                lastDate: DateTime(now.year + 1),
                /*selectableDayPredicate: (DateTime date) =>
                    date.weekday != DateTime.friday,*/
              );
              if (pickedDate != null) {
                ref.read(selectedDateProvider.notifier).state = pickedDate;
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: selectedDate == null
                    ? Colors.white
                    : Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.05),
                border: Border.all(
                  color: selectedDate == null
                      ? Colors.grey.shade300
                      : Theme.of(context).colorScheme.primary,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedDate == null
                        ? AppLocalizations.of(context)!.selectDay
                        : '${selectedDate.day} /${selectedDate.month} /${selectedDate.year}',

                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 15),

        Expanded(child: TimeSlots(doctorId: doctor.id)),
      ],
    );
  }
}
