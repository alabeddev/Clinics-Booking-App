import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorDateParams {
  DoctorDateParams({required this.doctorId, required this.date});

  final String doctorId;
  final DateTime date;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorDateParams &&
          doctorId == other.doctorId &&
          date.year == other.date.year &&
          date.month == other.date.month &&
          date.day == other.date.day;

  @override
  int get hashCode =>
      doctorId.hashCode ^
      date.year.hashCode ^
      date.month.hashCode ^
      date.day.hashCode;
}

final bookedTimesProvider = StreamProvider.family
    .autoDispose<List<String>, DoctorDateParams>((ref, params) {
      return FirebaseFirestore.instance
          .collection('bookings')
          .where('doctorId', isEqualTo: params.doctorId)
          .snapshots()
          .map((snapshots) {
            List<String> bookedTimes = [];
            for (var doc in snapshots.docs) {
              final data = doc.data();

              if (data['date'] != null) {
                final dateString = doc.data()['date'] as String;
                final bookingDateTime = DateTime.parse(dateString);
                final status = (data['status'] ?? '').toString().trim();

                if (bookingDateTime.year == params.date.year &&
                    bookingDateTime.month == params.date.month &&
                    bookingDateTime.day == params.date.day &&
                    status != 'ملغي' &&
                    status != 'ملغى' &&
                    status != 'cancelled') {
                  final hour = bookingDateTime.hour.toString().padLeft(2, '0');
                  final minute = bookingDateTime.minute.toString().padLeft(
                    2,
                    '0',
                  );

                  bookedTimes.add('$hour:$minute');
                }
              }
            }
            return bookedTimes;
          });
    });
