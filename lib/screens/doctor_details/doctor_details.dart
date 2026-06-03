import 'package:clinics_booking/models/doctor.dart';
import 'package:clinics_booking/providers/booking_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinics_booking/screens/doctor_details/widgets/booking_date_picker.dart';
import 'package:clinics_booking/screens/doctor_details/widgets/doctor_header.dart';
import 'package:clinics_booking/screens/booking_confirmation/booking_confirmation.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';

class DoctorDetailsScreen extends ConsumerWidget {
  const DoctorDetailsScreen({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.doctorDetails),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoctorHeader(doctor: doctor),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.clinicLocation,
                      style: TextStyle(color: Colors.grey),
                    ),
                    subtitle: Text(
                      doctor.location,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const Divider(),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.availableTimes,
                      style: TextStyle(color: Colors.grey),
                    ),
                    subtitle: Text(
                      doctor.available.toString(),
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const Divider(),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.payment_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.bookingPrice,
                      style: TextStyle(color: Colors.grey),
                    ),
                    subtitle: Text(
                      ' ${doctor.price} ريال يمني ',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const Divider(),
                  const SizedBox(height: 10),

                  Text(
                    AppLocalizations.of(context)!.aboutDoctor,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    doctor.details,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Text(
                    AppLocalizations.of(context)!.selectBookingDate,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 15),

                  BookingDatePicker(doctor: doctor),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            final date = ref.read(selectedDateProvider);
            final time = ref.read(selectedTimeProvider);

            if (date == null || time == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.pleaseSelectDateAndTimeFirst,
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
              return;
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BookingConfirmation(doctor: doctor),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.continueBooking,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
