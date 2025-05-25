import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin ThemeMixin<T extends StatefulWidget> on State<T> {
  ThemeData get theme {
    return Theme.of(context);
  }

  ThemeData get themeData {
    return theme;
  }

  TextTheme get textTheme {
    return theme.textTheme;
  }

  ColorScheme get colorScheme {
    return theme.colorScheme;
  }
}

mixin ThemeMixin2<T extends StatelessWidget> on StatelessWidget {
  ThemeData get theme {
    return Theme.of(Get.context!);
  }

  TextTheme get textTheme {
    return theme.textTheme;
  }

  ColorScheme get colorScheme {
    return theme.colorScheme;
  }

  ThemeData get themeData {
    return theme;
  }
}
