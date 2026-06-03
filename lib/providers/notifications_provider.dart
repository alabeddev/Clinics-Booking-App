import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinics_booking/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinics_booking/models/notification.dart';
import 'package:clinics_booking/data/database.dart';
import 'package:flutter_riverpod/legacy.dart';

class NotificationsNotifier extends Notifier<List<NotificationModel>> {
  @override
  List<NotificationModel> build() {
    ref.listen(authStateProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          loadNotifications(user.uid);
        } else {
          clearNotifications();
        }
      });
    }, fireImmediately: true);
    return [];
  }

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

      final List<NotificationModel> cloudNotifications = [];
      for (var doc in snapshot.docs) {
        final notification = NotificationModel.fromMap(doc.data());

        await DatabaseHelper.instance.insertNotification(notification);

        cloudNotifications.add(notification);
      }

      state = cloudNotifications;
    } catch (e) {
      debugPrint('خطأ في جلب الأشعارات السحابية $e ');
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
      debugPrint('خطأ في رفع الاشعار الى السحابة$e');
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
      debugPrint('خطأ في حذف الأشعار من السحابة : $e');
    }
  }

  void clearNotifications() {
    state = [];
  }
}

final notificationProvider =
    NotifierProvider<NotificationsNotifier, List<NotificationModel>>(
      NotificationsNotifier.new,
    );

final unreadBadgeProvider = StateProvider<bool>((ref) => false);
