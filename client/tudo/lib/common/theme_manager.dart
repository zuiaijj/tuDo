import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'platform/platform_features.dart';

/// 主题管理器，用于处理不同平台的主题样式
class ThemeManager {
  /// 获取Material风格的亮色主题
  static ThemeData getLightMaterialTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorSchemeWhite,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: const CardTheme(
        elevation: 2,
        margin: EdgeInsets.all(8),
      ),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  static ColorScheme get colorSchemeBlack {
    return ColorScheme(
      surface: Colors.black,
      onSurface: Colors.white,
      brightness: Brightness.dark,
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.black,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
    );
  }

  static ColorScheme get colorSchemeWhite {
    return ColorScheme(
      surface: Colors.white,
      onSurface: Colors.black,
      brightness: Brightness.light,
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: Colors.white,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    );
  } 

  /// 获取Material风格的暗色主题
  static ThemeData getDarkMaterialTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorSchemeBlack,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: const CardTheme(
        elevation: 2,
        margin: EdgeInsets.all(8),
      ),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  static Image getThemeLogo(BuildContext context) {
    final isDark = isDarkMode(context);
    return isDark ? Image.asset('assets/base/logo_black.png') : Image.asset('assets/base/logo_white.png');
  }
} 

bool isDarkMode(BuildContext context) {
  final brightness = Theme.of(context).brightness;
  return brightness == Brightness.dark;
}

ThemeData theme(BuildContext context) => Theme.of(context);
ColorScheme colorScheme(BuildContext context) => theme(context).colorScheme;