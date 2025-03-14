# 跨平台应用框架

这是一个基于Flutter的跨平台应用框架，支持Android、iOS、macOS和Windows平台。

## 特点

- 自动适配不同平台的UI风格（Material Design和Cupertino）
- 响应式布局，适配不同屏幕尺寸（手机、平板和桌面）
- 平台特定功能检测和处理
- 统一的主题管理

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── pages/                    # 页面
│   └── home_page.dart        # 主页示例
└── utils/                    # 工具类
    ├── platform_adapter.dart # 平台适配器
    ├── platform_features.dart # 平台特定功能
    ├── responsive_helper.dart # 响应式布局助手
    └── theme_manager.dart    # 主题管理器
```

## 如何使用

### 平台适配器

平台适配器提供了一系列静态方法，用于根据当前平台返回相应的UI组件。

```dart
// 获取平台适配的应用栏
final appBar = PlatformAdapter.getAppBar(
  title: '标题',
  actions: [
    IconButton(
      icon: const Icon(Icons.info_outline),
      onPressed: () {},
    ),
  ],
);

// 获取平台适配的按钮
final button = PlatformAdapter.getButton(
  onPressed: () {},
  child: const Text('按钮'),
);

// 获取平台适配的文本输入框
final textField = PlatformAdapter.getTextField(
  placeholder: '请输入文本',
  controller: textController,
);

// 显示平台适配的对话框
PlatformAdapter.showAlertDialog(
  context: context,
  title: '标题',
  content: '内容',
  confirmText: '确定',
  cancelText: '取消',
  onConfirm: () {},
  onCancel: () {},
);
```

### 响应式布局助手

响应式布局助手提供了一系列静态方法，用于根据当前屏幕尺寸返回相应的布局。

```dart
// 获取基于屏幕宽度的响应式布局
final layout = ResponsiveHelper.getResponsiveLayout(
  context: context,
  mobileLayout: MobileLayout(),
  tabletLayout: TabletLayout(),
  desktopLayout: DesktopLayout(),
);

// 获取基于屏幕宽度的响应式值
final padding = ResponsiveHelper.getResponsiveValue<EdgeInsets>(
  context: context,
  mobile: const EdgeInsets.all(16),
  tablet: const EdgeInsets.all(24),
  desktop: const EdgeInsets.all(32),
);

// 获取基于屏幕宽度的响应式字体大小
final fontSize = ResponsiveHelper.getResponsiveFontSize(
  context,
  baseFontSize: 16,
);
```

### 平台特定功能

平台特定功能提供了一系列静态属性，用于检测当前平台支持的功能。

```dart
// 判断当前平台是否支持鼠标右键
final supportsRightClick = PlatformFeatures.supportsRightClick;

// 判断当前平台是否支持文件系统访问
final supportsFileSystem = PlatformFeatures.supportsFileSystem;

// 获取当前平台名称
final platformName = PlatformFeatures.platformName;
```

### 主题管理器

主题管理器提供了一系列静态方法，用于获取不同平台的主题样式。

```dart
// 获取平台适配的主题
final theme = ThemeManager.getPlatformTheme(isDark: false);
```

## 运行项目

确保已安装Flutter SDK，然后运行以下命令：

```bash
# 获取依赖
flutter pub get

# 运行应用（自动检测连接的设备）
flutter run

# 运行在特定平台
flutter run -d windows  # Windows
flutter run -d macos    # macOS
flutter run -d ios      # iOS
flutter run -d android  # Android
```

## 构建项目

```bash
# 构建Android APK
flutter build apk

# 构建iOS应用
flutter build ios

# 构建macOS应用
flutter build macos

# 构建Windows应用
flutter build windows
```
