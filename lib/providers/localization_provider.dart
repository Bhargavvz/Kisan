import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  
  Locale get locale => _locale;

  // Supported languages
  static const List<String> supportedLanguages = [
    'en', 'hi', 'kn', 'bn', 'mr', 'ta', 'te', 'gu', 'pa', 'ml'
  ];

  // Language names mapping
  static const Map<String, String> languageNames = {
    'en': 'English',
    'hi': '?????',
    'kn': '?????',
    'bn': '?????',
    'mr': '?????',
    'ta': '?????',
    'te': '??????',
    'gu': '???????',
    'pa': '??????',
    'ml': '??????',
  };

  LocalizationProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language') ?? 'en';
      
      // Validate if the language code is supported
      if (supportedLanguages.contains(languageCode)) {
        _locale = Locale(languageCode);
      } else {
        _locale = const Locale('en');
      }
      
      notifyListeners();
    } catch (e) {
      // If there's an error, default to English
      _locale = const Locale('en');
    }
  }

  Future<void> setLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', locale.languageCode);
      _locale = locale;
      notifyListeners();
    } catch (e) {
      // Handle error if needed
      print('Error setting locale: $e');
    }
  }

  String get currentLanguageName {
    return languageNames[_locale.languageCode] ?? 'English';
  }

  bool get isEnglish => _locale.languageCode == 'en';
  bool get isHindi => _locale.languageCode == 'hi';
  bool get isKannada => _locale.languageCode == 'kn';
  bool get isBengali => _locale.languageCode == 'bn';
  bool get isMarathi => _locale.languageCode == 'mr';
  bool get isTamil => _locale.languageCode == 'ta';
  bool get isTelugu => _locale.languageCode == 'te';
  bool get isGujarati => _locale.languageCode == 'gu';
  bool get isPunjabi => _locale.languageCode == 'pa';
  bool get isMalayalam => _locale.languageCode == 'ml';

  // Get text direction based on language
  TextDirection get textDirection {
    // Most Indian languages are LTR, but you can customize this
    // if you plan to support RTL languages like Arabic or Urdu
    return TextDirection.ltr;
  }

  // Get font family based on language
  String get fontFamily {
    switch (_locale.languageCode) {
      case 'hi':
      case 'mr':
        return 'Poppins'; // Good for Devanagari script
      case 'bn':
        return 'Poppins'; // Good for Bengali script
      case 'ta':
      case 'te':
      case 'kn':
      case 'ml':
        return 'Poppins'; // Good for South Indian scripts
      case 'gu':
        return 'Poppins'; // Good for Gujarati script
      case 'pa':
        return 'Poppins'; // Good for Gurmukhi script
      default:
        return 'Poppins';
    }
  }
}
