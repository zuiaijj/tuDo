import 'package:flutter/material.dart';
import 'package:get/get.dart';

double get screanWidth => Get.width;
double get screanHeight => Get.height;

double get safeBottom => Get.mediaQuery.padding.bottom;
double get safeTop => Get.mediaQuery.padding.top;

bool get isDarkMode => Theme.of(Get.context!).brightness == Brightness.dark;

ColorScheme get colorScheme => Theme.of(Get.context!).colorScheme;
TextTheme get textTheme => Theme.of(Get.context!).textTheme;
