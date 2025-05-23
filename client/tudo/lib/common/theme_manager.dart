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
    final isDark = isDarkMode(context);
    return isDark
        ? Image.asset('assets/base/logo_black_tran.png',
            width: size, height: size)
        : Image.asset('assets/base/logo_white_tran.png',
            width: size, height: size);
  }
}

bool isDarkMode(BuildContext context) {
  final brightness = Theme.of(context).brightness;
  return brightness == Brightness.dark;
}

ThemeData theme(BuildContext context) => Theme.of(context);
ColorScheme colorScheme(BuildContext context) => theme(context).colorScheme;
