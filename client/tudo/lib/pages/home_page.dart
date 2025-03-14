import 'package:flutter/material.dart';
import 'package:tudo/common/platform_adapter.dart';
import 'package:tudo/common/platform_features.dart';
import 'package:tudo/common/responsive_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showPlatformDialog() {
    PlatformAdapter.showAlertDialog(
      context: context,
      title: '平台信息',
      content: '当前平台: ${PlatformFeatures.platformName}\n'
          '支持右键: ${PlatformFeatures.supportsRightClick ? '是' : '否'}\n'
          '支持文件系统: ${PlatformFeatures.supportsFileSystem ? '是' : '否'}\n'
          '支持触摸输入: ${PlatformFeatures.supportsTouchInput ? '是' : '否'}\n'
          '支持键盘快捷键: ${PlatformFeatures.supportsKeyboardShortcuts ? '是' : '否'}',
      confirmText: '确定',
    );
  }

  @override
  Widget build(BuildContext context) {
    // 使用响应式布局助手获取适合当前屏幕的布局
    return ResponsiveHelper.getResponsiveLayout(
      context: context,
      // 移动设备布局
      mobileLayout: _buildMobileLayout(),
      // 平板设备布局
      tabletLayout: _buildTabletLayout(),
      // 桌面设备布局
      desktopLayout: _buildDesktopLayout(),
    );
  }

  // 移动设备布局
  Widget _buildMobileLayout() {
    return PlatformAdapter.getScaffold(
      appBar: PlatformAdapter.getAppBar(
        title: '跨平台示例 - 移动版',
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showPlatformDialog,
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }

  // 平板设备布局
  Widget _buildTabletLayout() {
    return PlatformAdapter.getScaffold(
      appBar: PlatformAdapter.getAppBar(
        title: '跨平台示例 - 平板版',
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showPlatformDialog,
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('首页'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('设置'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  // 桌面设备布局
  Widget _buildDesktopLayout() {
    return PlatformAdapter.getScaffold(
      appBar: PlatformAdapter.getAppBar(
        title: '跨平台示例 - 桌面版',
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showPlatformDialog,
          ),
        ],
      ),
      body: Row(
        children: [
          Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                    '导航菜单',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  selected: _selectedIndex == 0,
                  leading: const Icon(Icons.home),
                  title: const Text('首页'),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  selected: _selectedIndex == 1,
                  leading: const Icon(Icons.settings),
                  title: const Text('设置'),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  // 页面主体内容
  Widget _buildBody() {
    return Padding(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '欢迎使用跨平台应用',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 24),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '这是一个演示如何使用我们的跨平台适配框架的示例应用。',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16),
            ),
          ),
          const SizedBox(height: 24),
          PlatformAdapter.getTextField(
            placeholder: '请输入文本',
            controller: _textController,
          ),
          const SizedBox(height: 16),
          PlatformAdapter.getButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                PlatformAdapter.showAlertDialog(
                  context: context,
                  title: '输入内容',
                  content: '您输入的内容是：${_textController.text}',
                  confirmText: '确定',
                );
              }
            },
            child: const Text('提交'),
          ),
          const SizedBox(height: 24),
          Text(
            '当前平台：${PlatformFeatures.platformName}',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '当前设备类型：${ResponsiveHelper.isMobile(context) ? '移动设备' : ResponsiveHelper.isTablet(context) ? '平板设备' : '桌面设备'}',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16),
            ),
          ),
          const SizedBox(height: 24),
          if (_selectedIndex == 0)
            _buildHomeContent()
          else
            _buildSettingsContent(),
        ],
      ),
    );
  }

  // 首页内容
  Widget _buildHomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '首页内容',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '跨平台适配框架特点',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('• 自动适配不同平台的UI风格'),
                const Text('• 响应式布局，适配不同屏幕尺寸'),
                const Text('• 平台特定功能检测和处理'),
                const Text('• 统一的主题管理'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 设置内容
  Widget _buildSettingsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '设置',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '平台信息',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('当前平台: ${PlatformFeatures.platformName}'),
                Text('支持右键: ${PlatformFeatures.supportsRightClick ? '是' : '否'}'),
                Text('支持文件系统: ${PlatformFeatures.supportsFileSystem ? '是' : '否'}'),
                Text('支持触摸输入: ${PlatformFeatures.supportsTouchInput ? '是' : '否'}'),
                Text('支持键盘快捷键: ${PlatformFeatures.supportsKeyboardShortcuts ? '是' : '否'}'),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 