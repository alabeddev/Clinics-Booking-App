import 'package:clinics_booking/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:clinics_booking/data/database.dart';
import 'package:clinics_booking/models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingNotifier extends StateNotifier<List<BookingModel>> {
  BookingNotifier() : super([]);

  Future<void> loadBookings(String uid) async {
    final dbBookings = await DatabaseHelper.instance.getUserBookings(uid);

    state = dbBookings;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: uid)
          .get();

      final cloudBookings = snapshot.docs.map((doc) {
        return BookingModel.fromMap(doc.data());
      }).toList();

      state = cloudBookings;
    } catch (e) {
      print("خطأ في جلب البيانات السحابيه:$e");
    }
  }

  Future<void> addBooking(BookingModel booking) async {
    try {
      await DatabaseHelper.instance.insertBooking(booking);

      state = [...state, booking];

      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(booking.id)
          .set(booking.toMap());
    } catch (error) {
      print('فشل في رفع الحجز الى السحابة');
    }
  }

  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    await DatabaseHelper.instance.updateBookingStatus(bookingId, newStatus);

    state = state.map((booking) {
      if (booking.id == bookingId) {
        return booking.copyWith(status: newStatus);
      }
      return booking;
    }).toList();

    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({'status': newStatus});
  }

  Future<void> deleteBooking(String bookingId) async {
    await DatabaseHelper.instance.deleteBooking(bookingId);

    state = state.where((booking) => booking.id != bookingId).toList();

    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .delete();
  }
}

final bookingsProvider =
    StateNotifierProvider<BookingNotifier, List<BookingModel>>((ref) {
      final authState = ref.watch(authStateProvider);
      final notifier = BookingNotifier();

      authState.whenData((user) {
        if (user != null) {
          notifier.loadBookings(user.uid);
        }
      });

      return notifier;
    });
