import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinics_booking/providers/booking_data_provider.dart';
import 'package:clinics_booking/providers/booked_times_provider.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';

const List<String> kTimeSlots = [
  '08:00',
  '08:30',
  '09:00',
  '09:30',
  '10:00',
  '10:30',
  '11:00',
  '11:30',
  '12:00',
  '12:30',
  '15:00',
  '15:30',
  '16:00',
  '16:30',
  '17:00',
  '17:30',
  '18:00',
  '18:30',
  '19:00',
  '19:30',
];

String formatTime(String slot, BuildContext context) {
  final hour = int.parse(slot.split(':')[0]);
  final minute = int.parse(slot.split(':')[1]);
  final formattedMinute = minute.toString().padLeft(2, '0');
  final period = hour < 12
      ? AppLocalizations.of(context)!.am
      : AppLocalizations.of(context)!.pm;
  final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

  return '$displayHour:$formattedMinute $period';
}

class TimeSlots extends ConsumerWidget {
  const TimeSlots({super.key, required this.doctorId});

  final String doctorId;

  void _showTimePickerModel(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedDate,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (context, modalRef, child) {
            final bookedTimesAsync = modalRef.watch(
              bookedTimesProvider(
                DoctorDateParams(doctorId: doctorId, date: selectedDate),
              ),
            );

            final selectedTime = modalRef.watch(selectedTimeProvider);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    AppLocalizations.of(context)!.selectBookingTime,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 24),

                  bookedTimesAsync.when(
                    data: (bookedTimes) {
                      final allSlots = kTimeSlots;

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: allSlots.map((slot) {
                          final isBooked = bookedTimes.contains(slot);
                          final isSelected = selectedTime == slot;

                          final displayTime = formatTime(slot, context);

                          return InkWell(
                            onTap: isBooked
                                ? null
                                : () {
                                    modalRef
                                            .read(selectedTimeProvider.notifier)
                                            .state =
                                        slot;
                                    Navigator.of(context).pop();
                                  },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width:
                                  (MediaQuery.of(context).size.width - 72) / 3,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isBooked
                                    ? Colors.grey.shade100
                                    : isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white,

                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isBooked
                                      ? Colors.transparent
                                      : isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade300,
                                ),
                              ),

                              child: Center(
                                child: Text(
                                  displayTime,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: isBooked
                                        ? Colors.grey.shade400
                                        : isSelected
                                        ? Colors.white
                                        : Colors.black87,

                                    decoration: isBooked
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                    error: (e, st) => Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        AppLocalizations.of(
                          context,
                        )!.errorFetchingTimesCheckInternet,
                      ),
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedTime = ref.watch(selectedTimeProvider);

    String displayTimeText = AppLocalizations.of(context)!.selectHour;

    if (selectedTime != null) {
      displayTimeText = formatTime(selectedTime, context);
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (selectedDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.pleaseSelectDateFirst,
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }

        _showTimePickerModel(context, ref, selectedDate);
      },

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selectedTime == null
              ? Colors.white
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selectedTime == null
                ? Colors.grey.shade300
                : Theme.of(context).colorScheme.primary,
          ),
        ),

        child: Column(
          children: [
            Icon(
              Icons.access_time,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),

            Text(
              displayTimeText,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
