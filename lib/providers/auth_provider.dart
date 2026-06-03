import 'package:clinics_booking/data/database.dart';
import 'package:clinics_booking/models/notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinics_booking/models/user.dart';
import 'package:clinics_booking/services/notification_service.dart';
import 'package:clinics_booking/providers/notifications_provider.dart';

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<String?> authenticate({
    required bool isLogin,
    required String email,
    required String password,
    String name = '',
    String phone = '',
  }) async {
    state = true;

    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        final userSign = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        if (userSign.user == null) {
          state = false;
          throw Exception('حدث خطأ أثناء إنشاء الحساب. يرجى المحاولة لاحقاً.');
        }

        String uid = userSign.user!.uid;
        UserModel newUser = UserModel(
          id: uid,
          uname: name,
          phone: phone,
          email: email,
        );

        final welcomeNotif = NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: uid,
          title: 'مرحباً بك في عيادتنا',
          body:
              ' الاخ ${newUser.uname} , يسعدنا انضمامك الينا. نتمنى لك رحلة علاج مريحة ,',
          createdAt: DateTime.now(),
        );

        await ref
            .read(notificationProvider.notifier)
            .addNotification(welcomeNotif, uid);

        await NotificationService.showInstantNotification(
          id: 0,
          title: welcomeNotif.title,
          body: welcomeNotif.body,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(newUser.toMap());

        await DatabaseHelper.instance.insertUser(newUser);
      }
      state = false;
      return null;
    } on FirebaseAuthException catch (error) {
      state = false;

      debugPrint('Firebase Auth Error code: ${error.code}');

      switch (error.code) {
        case 'invalid-email':
          return 'صيغة البريد الألكتروني غير صحيحة.';
        case 'user-not-found':
          return 'لم يتم العثور على مستخدم بهذا البريد.';
        case 'wrong-password':
          return 'كلمة المرور غير صحيحة';
        case 'invalid-credential':
          return 'البريد الألكتروني أو كلمة المرور غير صحيحة.';
        case 'email-already-in-use':
          return 'هذا البريد الالكتروني مسجل مسبقاً';
        case 'user-disabled':
          return 'تم حظر هذا الحساب من قبل الأدارة.';
        case 'network-request-failed':
          return 'يرجى التحقق من اتصالك بالانترنت.';

        default:
          return 'حدث خطأ أثناء المصادقه, يرجى المحاولة لاحقاً';
      }
    } catch (e) {
      state = false;
      return 'حدث خطأ عام. يرجى التحقق من اتصالك بالانترنت';
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, bool>(AuthNotifier.new);
