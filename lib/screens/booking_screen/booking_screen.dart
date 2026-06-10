import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clinics_booking/providers/booking_provider.dart';
import 'package:clinics_booking/screens/booking_screen/widgets/bookings_list.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  Future<void> _refreshBookings() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      ref.read(bookingsProvider.notifier).loadBookings(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allBookings = ref.watch(bookingsProvider);
    final upcomingBookings = allBookings.where((b) {
      final status = b.status.trim().toLowerCase();
      return status == 'Pending' ||
          status == 'Confirmed' ||
          status == 'قيد الانتظار' ||
          status == 'قيد الأنتظار';
    }).toList();

    upcomingBookings.sort((a, b) => a.date.compareTo(b.date));

    final pastBookings = allBookings.where((b) {
      final status = b.status.trim();
      return status == 'Completed' ||
          status == 'Canceled' ||
          status == 'ملغي' ||
          status == 'ملغى';
    }).toList();

    pastBookings.sort((a, b) => b.date.compareTo(a.date));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            AppLocalizations.of(context)!.myAppointments,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),

            tabs: [
              Tab(text: AppLocalizations.of(context)!.upcomingAppointments),
              Tab(text: AppLocalizations.of(context)!.previousAppointments),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            BookingsList(
              bookings: upcomingBookings,
              isUpcoming: true,
              onRefresh: _refreshBookings,
            ),
            BookingsList(
              bookings: pastBookings,
              isUpcoming: false,
              onRefresh: _refreshBookings,
            ),
          ],
        ),
      ),
    );
  }
}
