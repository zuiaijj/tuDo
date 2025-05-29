import 'package:tudo/pages/login/login_step/country_code/country_code_model.dart';
import 'package:tudo/pages/login/login_step/country_code/support_defalut_country.dart';

class CountryCodeInfo {
  List<CountryCodeModel> list = [];
  List<CountryCodeModel> recommend = [];

  CountryCodeInfo();

  CountryCodeInfo.defaultList() {
    list = countryCodes.map((json) => CountryCodeModel.fromJson(json)).toList();
    recommend = [];
  }
}
