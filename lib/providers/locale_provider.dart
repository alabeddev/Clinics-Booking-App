import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    _loadSavedLocale();
    return Locale('ar');
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString('app_language');

      if (savedLanguageCode != null) {
        state = Locale(savedLanguageCode);
      }
    } catch (e) {
      debugPrint('خطأ في تحميل اللغة المحفوظة: $e');
    }
  }

  Future<void> changeLocale(String languageCode) async {
    state = Locale(languageCode);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', languageCode);
    } catch (e) {
      debugPrint('خطأ في تغيير اللغة: $e');
    }
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
