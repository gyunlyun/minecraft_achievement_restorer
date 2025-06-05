import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing application language settings
class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('zh', ''), // Chinese (Simplified)
  ];

  Locale? _currentLocale;
  SharedPreferences? _prefs;

  /// Get the current locale
  Locale? get currentLocale => _currentLocale;

  /// Get the current language code
  String get currentLanguageCode => _currentLocale?.languageCode ?? 'en';

  /// Check if current language is Chinese
  bool get isChineseSelected => currentLanguageCode == 'zh';

  /// Check if current language is English
  bool get isEnglishSelected => currentLanguageCode == 'en';

  /// Initialize the language service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSavedLanguage();
  }

  /// Load saved language from preferences
  Future<void> _loadSavedLanguage() async {
    final savedLanguage = _prefs?.getString(_languageKey);
    
    if (savedLanguage != null) {
      // Use saved language
      _currentLocale = Locale(savedLanguage);
    } else {
      // Use system locale if supported, otherwise default to English
      final systemLocale = PlatformDispatcher.instance.locale;
      if (_isSupportedLocale(systemLocale)) {
        _currentLocale = systemLocale;
      } else {
        _currentLocale = const Locale('en');
      }
    }
    
    notifyListeners();
  }

  /// Check if a locale is supported
  bool _isSupportedLocale(Locale locale) {
    return supportedLocales.any((supported) => 
        supported.languageCode == locale.languageCode);
  }

  /// Change the application language
  Future<void> changeLanguage(String languageCode) async {
    if (!supportedLocales.any((locale) => locale.languageCode == languageCode)) {
      throw ArgumentError('Unsupported language code: $languageCode');
    }

    _currentLocale = Locale(languageCode);
    await _prefs?.setString(_languageKey, languageCode);
    notifyListeners();
  }

  /// Toggle between English and Chinese
  Future<void> toggleLanguage() async {
    final newLanguage = isEnglishSelected ? 'zh' : 'en';
    await changeLanguage(newLanguage);
  }

  /// Set language to English
  Future<void> setEnglish() async {
    await changeLanguage('en');
  }

  /// Set language to Chinese
  Future<void> setChinese() async {
    await changeLanguage('zh');
  }

  /// Get language display name
  String getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'zh':
        return '中文';
      default:
        return languageCode.toUpperCase();
    }
  }

  /// Get current language display name
  String get currentLanguageDisplayName {
    return getLanguageDisplayName(currentLanguageCode);
  }

  /// Get all supported languages with their display names
  Map<String, String> get supportedLanguages {
    return {
      for (final locale in supportedLocales)
        locale.languageCode: getLanguageDisplayName(locale.languageCode)
    };
  }

  /// Reset to system language
  Future<void> resetToSystemLanguage() async {
    await _prefs?.remove(_languageKey);
    await _loadSavedLanguage();
  }
}
