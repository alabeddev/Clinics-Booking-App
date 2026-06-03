import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinics_booking/models/user.dart';
import 'package:clinics_booking/data/database.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final userProvider = StreamProvider<UserModel?>((ref) async* {
  final authState = ref.watch(authStateProvider);

  if (authState.value == null) {
    yield null;
    return;
  }

  final uid = authState.value!.uid;

  try {
    final localUser = await DatabaseHelper.instance.getUser(uid);

    if (localUser != null) {
      yield localUser;
    }
  } catch (e) {
    debugPrint('خطأ في جلب البيانات$e');
  }

  yield* FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          final cloudUser = UserModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
          );

          try {
            DatabaseHelper.instance.insertUser(cloudUser);
          } catch (e) {
            debugPrint('خطأ في تحديث البيانات المحلية: $e');
          }

          return cloudUser;
        }
        return null;
      });
});
