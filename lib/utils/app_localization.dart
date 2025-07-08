import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String> _localizedStrings = {};

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<bool> load() async {
    try {
      String jsonString = await rootBundle
          .loadString('assets/localization/${locale.languageCode}.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });

      return true;
    } catch (e) {
      // If loading fails, try to load English as fallback
      print('Error loading localization for ${locale.languageCode}: $e');
      try {
        String jsonString = await rootBundle
            .loadString('assets/localization/en.json');
        Map<String, dynamic> jsonMap = json.decode(jsonString);

        _localizedStrings = jsonMap.map((key, value) {
          return MapEntry(key, value.toString());
        });

        return true;
      } catch (fallbackError) {
        print('Error loading fallback localization: $fallbackError');
        return false;
      }
    }
  }

  String translate(String key, {Map<String, String>? params}) {
    String translation = _localizedStrings[key] ?? key;
    
    // Handle parameter substitution
    if (params != null) {
      params.forEach((paramKey, paramValue) {
        translation = translation.replaceAll('{$paramKey}', paramValue);
      });
    }
    
    return translation;
  }

  // Helper method for easier access
  String t(String key, {Map<String, String>? params}) => translate(key, params: params);

  // Get all keys for debugging
  List<String> get keys => _localizedStrings.keys.toList();
  
  // Check if a key exists
  bool hasKey(String key) => _localizedStrings.containsKey(key);
  
  // Get current locale info
  String get languageCode => locale.languageCode;
  String get countryCode => locale.countryCode ?? '';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Support all the languages we have translation files for
    return ['en', 'hi', 'kn', 'bn', 'mr', 'ta', 'te', 'gu', 'pa', 'ml']
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Extension for easier access to translations
extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
  String t(String key, {Map<String, String>? params}) => 
      AppLocalizations.of(this).translate(key, params: params);
}

// Language utility class
class LanguageUtils {
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

  static const Map<String, String> languageFlags = {
    'en': '????',
    'hi': '????',
    'kn': '????',
    'bn': '????',
    'mr': '????',
    'ta': '????',
    'te': '????',
    'gu': '????',
    'pa': '????',
    'ml': '????',
  };

  static String getLanguageName(String code) {
    return languageNames[code] ?? 'Unknown';
  }

  static String getLanguageFlag(String code) {
    return languageFlags[code] ?? '???';
  }

  static bool isRTL(String languageCode) {
    // Add RTL language codes here if needed
    return ['ar', 'fa', 'he', 'ur'].contains(languageCode);
  }
}
