import 'package:flutter/material.dart';
import 'package:tudo/pages/login/login_step/country_code/support_defalut_country.dart';

class CountryLocalizations {
  final Locale locale;

  CountryLocalizations(this.locale);

  static CountryLocalizations? of(BuildContext context) {
    return Localizations.of<CountryLocalizations>(
      context,
      CountryLocalizations,
    );
  }

  static const LocalizationsDelegate<CountryLocalizations> delegate =
      _CountryLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    _localizedStrings = countryCodeLang.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  String? translate(String? key) {
    return _localizedStrings[key!];
  }
}

class _CountryLocalizationsDelegate
    extends LocalizationsDelegate<CountryLocalizations> {
  const _CountryLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      "af",
      "am",
      "ar",
      "az",
      "be",
      "bg",
      "bn",
      "bs",
      "ca",
      "cs",
      "da",
      "de",
      "el",
      "en",
      "es",
      "et",
      "fa",
      "fi",
      "fr",
      "gl",
      "ha",
      "he",
      "hi",
      "hr",
      "hu",
      "hy",
      "id",
      "is",
      "it",
      "ja",
      "ka",
      "kk",
      "km",
      "ko",
      "ku",
      "ky",
      "lt",
      "lv",
      "mk",
      "ml",
      "mn",
      "ms",
      "nb",
      "nl",
      "nn",
      "no",
      "pl",
      "ps",
      "pt",
      "ro",
      "ru",
      "sd",
      "sk",
      "sl",
      "so",
      "sq",
      "sr",
      "sv",
      "ta",
      "tg",
      "th",
      "tk",
      "tr",
      "tt",
      "uk",
      "ug",
      "ur",
      "uz",
      "vi",
      "zh",
    ].contains(locale.languageCode);
  }

  @override
  Future<CountryLocalizations> load(Locale locale) async {
    CountryLocalizations localizations = CountryLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_CountryLocalizationsDelegate old) => false;
}
