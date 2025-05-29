import 'package:azlistview_plus/azlistview_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tudo/pages/login/login_step/country_code/country_localizations.dart';
import 'package:tudo/pages/login/login_step/country_code/support_defalut_country.dart';

/// Country element. This is the element that contains all the information
class CountryCodeModel extends ISuspensionBean {
  /// the name of the country
  String? name;

  /// the flag of the country
  final String? flagUri;

  /// the country code (IT,AF..)
  final String? code;

  /// the dial code (+39,+93..)
  final String? dialCode;

  final String? flagUrl;

  // A-Z #
  final String? index;

  CountryCodeModel({
    this.name,
    this.flagUri,
    this.code,
    this.dialCode,
    this.flagUrl,
    this.index,
  });

  @Deprecated('Use `fromCountryCode` instead.')
  factory CountryCodeModel.fromCode(String isoCode) {
    return CountryCodeModel.fromCountryCode(isoCode);
  }

  factory CountryCodeModel.fromCountryCode(String countryCode) {
    final Map<String, String>? jsonCode = countryCodes.firstWhereOrNull(
      (code) => code['code'] == countryCode,
    );
    return CountryCodeModel.fromJson(jsonCode!);
  }

  factory CountryCodeModel.fromDialCode(String dialCode) {
    final Map<String, String>? jsonCode = countryCodes.firstWhereOrNull(
      (code) => code['dial_code'] == dialCode,
    );
    return CountryCodeModel.fromJson(jsonCode!);
  }

  CountryCodeModel localize(BuildContext context) {
    return this
      ..name = CountryLocalizations.of(context)?.translate(code) ?? name;
  }

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) {
    return CountryCodeModel(
      name: json['name'],
      code: json['code'],
      dialCode: json['dial_code'],
      index: json['index'],
      flagUrl: json['url'],
      flagUri: 'assets/flags/${json['code'].toLowerCase()}.png',
    );
  }

  @override
  String toString() => "$dialCode";

  String toLongString() => "$dialCode ${toCountryStringOnly()}";

  String toCountryStringOnly() {
    return '$_cleanName';
  }

  String? get _cleanName {
    return name?.replaceAll(RegExp(r'[[\]]'), '').split(',').first;
  }

  @override
  String getSuspensionTag() {
    return index ?? "";
  }
}
