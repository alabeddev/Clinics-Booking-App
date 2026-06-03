import 'package:flutter/material.dart';
import 'package:clinics_booking/screens/auth/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';
import 'package:clinics_booking/providers/locale_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:clinics_booking/theme/app_theme.dart';
import 'package:clinics_booking/providers/user_provider.dart';
import 'package:clinics_booking/screens/tab.dart';
import 'package:clinics_booking/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await NotificationService.init();
    await NotificationService.requestPermissions();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint("فشل في التهئية : $e");
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [Locale('ar'), Locale('en')],
      home: authState.when(
        data: (user) {
          if (user != null) {
            return const TabScreen();
          }

          return const LoginScreen();
        },
        error: (err, stack) =>
            Scaffold(body: Center(child: Text(' حدث خطأ في النظام '))),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
