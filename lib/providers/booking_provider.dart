import 'package:clinics_booking/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinics_booking/data/database.dart';
import 'package:clinics_booking/models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingNotifier extends Notifier<List<BookingModel>> {
  @override
  List<BookingModel> build() {
    ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          loadBookings(user.uid);
        } else {
          clearBookings();
        }
      });
    }, fireImmediately: true);

    return [];
  }

  Future<void> loadBookings(String uid) async {
    final dbBookings = await DatabaseHelper.instance.getUserBookings(uid);

    state = dbBookings;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: uid)
          .get();

      final List<BookingModel> cloudBookings = [];

      for (var doc in snapshot.docs) {
        final booking = BookingModel.fromMap(doc.data());

        await DatabaseHelper.instance.insertBooking(booking);

        cloudBookings.add(booking);
      }

      state = cloudBookings;
    } catch (e) {
      debugPrint("خطأ في جلب البيانات السحابيه:$e");
    }
  }

  Future<void> addBooking(BookingModel booking) async {
    try {
      await DatabaseHelper.instance.insertBooking(booking);

      state = [booking, ...state];

      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(booking.id)
          .set(booking.toMap());
    } catch (error) {
      debugPrint('فشل في رفع الحجز الى السحابة');
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

    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': newStatus});
    } catch (e) {
      debugPrint('فشل في تحديث حالة الحجز في السحابة: $e');
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    await DatabaseHelper.instance.deleteBooking(bookingId);

    state = state.where((booking) => booking.id != bookingId).toList();

    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .delete();
    } catch (e) {
      debugPrint('فشل في حذف الحجز من السحابة: $e');
    }
  }

  void clearBookings() {
    state = [];
  }
}

final bookingsProvider = NotifierProvider<BookingNotifier, List<BookingModel>>(
  BookingNotifier.new,
);
