import 'package:get/get.dart';
import 'package:tudo/pages/splash.dart';

const String defaultPage = '/';


class GlobalPages {
  static final pages = [
    GetPage(
      name: defaultPage,
      page: () => const SplashPage(),
    ),
  ];
}
