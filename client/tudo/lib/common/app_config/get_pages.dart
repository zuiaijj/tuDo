import 'package:get/get.dart';
import 'package:tudo/common/const/root_const.dart';
import 'package:tudo/pages/root/root_page.dart';

class GlobalPages {
  static final pages = [
    GetPage(
      name: RouteConst.root,
      page: () => const RootPage(),
    ),
  ];
}
