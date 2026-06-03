import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinics_booking/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinics_booking/models/notification.dart';
import 'package:clinics_booking/data/database.dart';
import 'package:flutter_riverpod/legacy.dart';

class NotificationsNotifier extends StateNotifier<List<NotificationModel>> {
  NotificationsNotifier() : super([]);

  Future<void> loadNotifications(String uid) async {
    final dbNotification = await DatabaseHelper.instance.getUserNotifications(
      uid,
    );

    state = dbNotification;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .get();

      final cloudNotifications = snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data());
      }).toList();

      state = cloudNotifications;
    } catch (e) {
      print('خطأ في جلب الأشعارات السحابية $e ');
    }
  }

  Future<void> addNotification(
    NotificationModel notification,
    String uid,
  ) async {
    try {
      await DatabaseHelper.instance.insertNotification(notification);

      state = [notification, ...state];

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(notification.id)
          .set(notification.toMap());
    } catch (e) {
      print('خطأ في رفع الاشعار الى السحابة$e');
    }
  }

  Future<void> deleteNotification(String notificationId, String uid) async {
    try {
      await DatabaseHelper.instance.deleteNotification(notificationId);

      state = state
          .where((notification) => notification.id != notificationId)
          .toList();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      print('خطأ في حذف الأشعار من السحابة : $e');
    }
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationsNotifier, List<NotificationModel>>((
      ref,
    ) {
      final authState = ref.watch(authStateProvider);
      final notifier = NotificationsNotifier();

      authState.whenData((user) {
        if (user != null) {
          notifier.loadNotifications(user.uid);
        }
      });
      return notifier;
    });

final unreadBadgeProvider = StateProvider<bool>((ref) => false);
