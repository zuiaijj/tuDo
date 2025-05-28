import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tudo/common/const/sp_const.dart';
import 'package:tudo/tool/get_tool.dart';
import 'package:tudo/tool/sp_tool.dart';
import 'package:tudo/tool/system.dart';
import '../platform/platform_features.dart';

void setTheme(ThemeStatus themeStatus) async {
  await SpTool.putInt(SpConst.themeModel, themeStatus.index);
  initTheme();
}

/// 初始化主题
void initTheme() async {
  // 平台的模式
  Brightness platformBrightness =
      MediaQuery.of(Get.context!).platformBrightness;
  // 本地模式
  int? themeModel = SpTool.getInt(SpConst.themeModel);
  // TabbarController tabbarController = Get.put(TabbarController());

  bool isDarkMode = false;

  switch (themeModel) {
    case 0:

      /// 跟随系统
      // ignore: use_build_context_synchronously
      if (platformBrightness == Brightness.dark) {
        Get.changeThemeMode(ThemeMode.dark);
        isDarkMode = true;
        // tabbarController.themeModelInt.value = 1;
      } else {
        Get.changeThemeMode(ThemeMode.light);
        isDarkMode = false;
        // tabbarController.themeModelInt.value = 0;
      }
      break;
    case 1:

      /// 深色模式
      Get.changeThemeMode(ThemeMode.dark);
      isDarkMode = true;
      // tabbarController.themeModelInt.value = 1;
      break;
    case 2:

      /// 浅色模式
      Get.changeThemeMode(ThemeMode.light);
      isDarkMode = false;
      // tabbarController.themeModelInt.value = 0;
      break;
    default:

      /// 跟随系统
      // ignore: use_build_context_synchronously
      if (platformBrightness == Brightness.dark) {
        Get.changeThemeMode(ThemeMode.dark);
        isDarkMode = true;
        // tabbarController.themeModelInt.value = 1;
      } else {
        Get.changeThemeMode(ThemeMode.light);
        isDarkMode = false;
        // tabbarController.themeModelInt.value = 0;
      }
  }

  // 根据主题模式设置状态栏样式
  _updateSystemUIOverlayStyle(isDarkMode);
}

/// 更新系统UI覆盖样式（状态栏和导航栏）
void _updateSystemUIOverlayStyle(bool isDarkMode) {
  SystemChrome.setSystemUIOverlayStyle(
      SystemInfo.getStatusBarStyle(isDark: isDarkMode));
}

enum ThemeStatus {
  system,
  dark,
  light,
  autoDark,
}

/// 主题管理器，用于处理不同平台的主题样式
class ThemeManager {
  /// 获取Material风格的亮色主题
  static ThemeData getLightMaterialTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorSchemeWhite,
      appBarTheme: _getAppBarTheme(colorSchemeWhite),
      cardTheme: const CardTheme(
        elevation: 2,
        margin: EdgeInsets.all(8),
      ),
      iconTheme: IconThemeData(
        color: colorSchemeWhite.primary,
      ),
      textTheme: _getTextTheme(colorSchemeWhite),
      brightness: colorSchemeWhite.brightness,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  static ColorScheme get colorSchemeBlack {
    return ColorScheme(
        surface: Color(0xFF1B1B1B),
        surfaceBright: Color(0xFF252525),
        surfaceDim: Color(0xFF000000),
        surfaceContainer: Color(0xFF909090),
        surfaceContainerHighest: Color(0xFFFFFFFF),
        surfaceContainerHigh: Color(0xFFC6C6C6),
        surfaceContainerLow: Color(0xFF585858),
        surfaceContainerLowest: Color(0xFF323232),
        onSurfaceVariant: Color(0xFFA8A8A8),
        onSurface: Color(0xFFF5F5F5),
        brightness: Brightness.dark,
        primary: Color(0xFFFFFFFF),
        onPrimary: Color(0xFF323232),
        secondary: Color(0xFF34BAA0),
        tertiary: Color(0xFFFF7648),
        onSecondary: Color(0xFFFFFFFF),
        onTertiary: Color(0xFFFFFFFF),
        error: Color(0xFFFF0000),
        onError: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFEEEEEE),
        onPrimaryContainer: Color(0xFF323232),
        secondaryContainer: Color(0xFF45AE8C),
        tertiaryContainer: Color(0xFFF3A78D),
        errorContainer: Color(0xFFE79494),
        onSecondaryContainer: Color(0xFFFFFFFF),
        onTertiaryContainer: Color(0xFFFFFFFF),
        onErrorContainer: Color(0xFFFFFFFF),
        primaryFixed: Color(0xFFA2A2A2),
        primaryFixedDim: Color(0xFF707070),
        onPrimaryFixed: Color(0xFFFFFFFF),
        onPrimaryFixedVariant: Color(0xFFF1F1F1),
        secondaryFixed: Color(0xFF75AA99),
        secondaryFixedDim: Color(0xFF659284),
        onSecondaryFixed: Color(0xFF75AA99),
        onSecondaryFixedVariant: Color(0xFF2A3A34),
        tertiaryFixed: Color(0xFFFFCBBA),
        tertiaryFixedDim: Color(0xFFECBDAD),
        onTertiaryFixed: Color(0xFFB0654C),
        onTertiaryFixedVariant: Color(0xFF7B422F),
        inverseSurface: Color(0xFF3D3D3D),
        inversePrimary: Color(0xFF2B2B2B),
        onInverseSurface: Color(0xFF404040),
        scrim: Color(0xFFFFFFFF),
        shadow: Color(0xFF303030),
        outline: Color(0xFF868686),
        outlineVariant: Color(0xFF5A5A5A));
  }

  static ColorScheme get colorSchemeWhite {
    return ColorScheme(
        surface: Color(0xFFFAFAFA),
        surfaceBright: Color(0xFFFEFEFE),
        surfaceDim: Color(0xFFEDEDED),
        surfaceContainer: Color(0xFFA7A7A7),
        surfaceContainerHighest: Color(0xFF1E1E1E),
        surfaceContainerHigh: Color(0xFF525252),
        surfaceContainerLow: Color(0xFFD5D5D5),
        surfaceContainerLowest: Color(0xFFE6E6E6),
        onSurfaceVariant: Color(0xFFB5B5B5),
        onSurface: Color(0xFF1B1B1B),
        brightness: Brightness.light,
        primary: Color(0xFF1E1E1E),
        onPrimary: Color(0xFFFFFFFF),
        secondary: Color(0xFF34BAA0),
        tertiary: Color(0xFFFF7648),
        onSecondary: Color(0xFFFFFFFF),
        onTertiary: Color(0xFFFFFFFF),
        error: Color(0xFFFF0000),
        onError: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFF484646),
        onPrimaryContainer: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFF45AE8C),
        tertiaryContainer: Color(0xFFF3A78D),
        errorContainer: Color(0xFFE79494),
        onSecondaryContainer: Color(0xFFFFFFFF),
        onTertiaryContainer: Color(0xFFFFFFFF),
        onErrorContainer: Color(0xFFFFFFFF),
        primaryFixed: Color(0xFF5D5D5D),
        primaryFixedDim: Color(0xFF3E3E3E),
        onPrimaryFixed: Color(0xFFFFFFFF),
        onPrimaryFixedVariant: Color(0xFFF1F1F1),
        secondaryFixed: Color(0xFF75AA99),
        secondaryFixedDim: Color(0xFF659284),
        onSecondaryFixed: Color(0xFF75AA99),
        onSecondaryFixedVariant: Color(0xFF2A3A34),
        tertiaryFixed: Color(0xFFFFCBBA),
        tertiaryFixedDim: Color(0xFFECBDAD),
        onTertiaryFixed: Color(0xFFB0654C),
        onTertiaryFixedVariant: Color(0xFF7B422F),
        inverseSurface: Color(0xFF3D3D3D),
        inversePrimary: Color(0xFFDEDEDE),
        onInverseSurface: Color(0xFFDFDFDF),
        scrim: Color(0xFF000000),
        shadow: Color(0xFF303030),
        outline: Color(0xFFAFAFAF),
        outlineVariant: Color(0xFFEAEAEA));
  }

  static _getTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: TextStyle(
          fontSize: 40,
          color: colorScheme.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          height: 1.5,
          fontFamily: "SourceHanSerifCN"),
      displayMedium: TextStyle(
        fontSize: 34,
        color: colorScheme.primary,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
        height: 1.5,
        fontFamily: "SourceHanSerifCN",
      ),
      displaySmall: TextStyle(
          fontSize: 32,
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          height: 1.5),
      headlineMedium: TextStyle(
          fontSize: 28,
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          height: 1.5),
      headlineSmall: TextStyle(
          fontSize: 24,
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          height: 1.3),
      titleLarge: TextStyle(
          fontSize: 20,
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
          height: 1.2),
      titleMedium: TextStyle(
          fontSize: 17,
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
          height: 1.2),
      titleSmall: TextStyle(
          fontSize: 16,
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
          height: 1.2),
      bodyLarge: TextStyle(
          fontSize: 16,
          color: colorScheme.primary,
          fontWeight: FontWeight.normal,
          height: 1.5),
      bodyMedium: TextStyle(
          fontSize: 14,
          color: colorScheme.primary,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
          height: 1.2),
      bodySmall: TextStyle(
          fontSize: 12,
          color: colorScheme.tertiary,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
          height: 1.2),
    );
  }

  static _getAppBarTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    return AppBarTheme(
      color: colorScheme.surface,
      elevation: 0,
      iconTheme: IconThemeData(
        color: colorScheme.primary,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // 状态栏背景透明
        statusBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark, // 状态栏图标颜色
        statusBarBrightness:
            isDark ? Brightness.dark : Brightness.light, // iOS状态栏亮度
        systemNavigationBarColor: isDark
            ? const Color.fromARGB(255, 19, 19, 19)
            : const Color.fromARGB(255, 250, 250, 250), // 导航栏颜色
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark, // 导航栏图标颜色
      ),
    );
  }

  /// 获取Material风格的暗色主题
  static ThemeData getDarkMaterialTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorSchemeBlack,
      appBarTheme: _getAppBarTheme(colorSchemeBlack),
      cardTheme: const CardTheme(
        elevation: 2,
        margin: EdgeInsets.all(8),
      ),
      iconTheme: IconThemeData(
        color: colorSchemeBlack.primary,
      ),
      textTheme: _getTextTheme(colorSchemeBlack),
      brightness: colorSchemeBlack.brightness,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  /// 获取Cupertino风格的亮色主题数据
  static CupertinoThemeData getLightCupertinoTheme() {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: CupertinoColors.systemBlue,
      scaffoldBackgroundColor: CupertinoColors.systemBackground,
      barBackgroundColor: CupertinoColors.systemBackground,
      textTheme: CupertinoTextThemeData(
        primaryColor: CupertinoColors.systemBlue,
      ),
    );
  }

  /// 获取Cupertino风格的暗色主题数据
  static CupertinoThemeData getDarkCupertinoTheme() {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: CupertinoColors.systemBlue,
      scaffoldBackgroundColor: CupertinoColors.systemBackground,
      barBackgroundColor: CupertinoColors.systemBackground,
      textTheme: CupertinoTextThemeData(
        primaryColor: CupertinoColors.systemBlue,
      ),
    );
  }

  /// 获取平台适配的主题
  static ThemeData getPlatformTheme({bool isDark = false}) {
    if (PlatformFeatures.isIOS || PlatformFeatures.isMacOS) {
      // 对于iOS和macOS，我们仍然返回Material主题，但会在UI组件中使用Cupertino风格
      return isDark ? getDarkMaterialTheme() : getLightMaterialTheme();
    } else {
      return isDark ? getDarkMaterialTheme() : getLightMaterialTheme();
    }
  }

  static Image getThemeLogoTran(BuildContext context, {double size = 240}) {
    return isDarkMode
        ? Image.asset('assets/base/logo_black_tran.png',
            width: size, height: size)
        : Image.asset('assets/base/logo_white_tran.png',
            width: size, height: size);
  }
}
