import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ar')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('app_language');

    if (savedLanguageCode != null) {
      state = Locale(savedLanguageCode);
    }
  }

  Future<void> changeLocale(String languageCode) async {
    state = Locale(languageCode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
