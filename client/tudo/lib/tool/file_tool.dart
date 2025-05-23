// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tudo/common/log/td_logger.dart';
import 'package:tudo/tool/encrypt_tool.dart';

/// 文件工具类
class FileTool {
  static Directory? _tempDir;
  static Directory? _appDocDir;
  static Directory? _appSupportDir;
  static Directory? _storageDir;

  FileTool._();

  static const String TAG = "FileTool";

  static init() async {
    createTempDir();
    createAppDocDir();
    createAppSupportDir();
  }

  /// 文档目录: /data/data/packageName/cache/  [getFilesDir()]
  static Future<Directory> tempDir() async {
    _tempDir ??= await getTemporaryDirectory();
    return _tempDir!;
  }

  /// 文档目录: /data/data/packageName/app_flutter/
  static Future<Directory> appDocDir() async {
    _appDocDir ??= await getApplicationDocumentsDirectory();
    return _appDocDir!;
  }

  /// 文档目录: /data/data/packageName/files/  [getFilesDir()]
  static Future<Directory> appSupportDir() async {
    _appSupportDir ??= await getApplicationSupportDirectory();
    return _appSupportDir!;
  }

  /// 文档目录: /data/data/packageName/files/  [getFilesDir()]
  static Future<Directory?> storageDir() async {
    if (_storageDir == null) {
      if (GetPlatform.isAndroid) {
        _storageDir = await getExternalStorageDirectory();
      }
    }
    return _storageDir;
  }

  /// 同步创建文件夹
  static Directory? createDirSync(String? path) {
    if (path == null) return null;
    Directory dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  /// 异步创建文件夹
  static Future<Directory?> createDir(String? path) async {
    if (path == null) return null;
    Directory dir = Directory(path);
    bool exist = await dir.exists();
    if (!exist) {
      dir = await dir.create(recursive: true);
    }
    return dir;
  }

  /// get path.
  /// dir
  /// category 分类，例如：Download，Pictures, Music等等
  /// fileName 文件名
  /// format 文件格式，如果文件名包含格式，则不需要
  static String? getPath(
    Directory? dir, {
    String? category,
    String? fileName,
    String? format,
  }) {
    if (dir == null) return null;
    StringBuffer sb = StringBuffer(dir.path);
    if (category != null) sb.write("/$category");
    if (fileName != null) sb.write("/$fileName");
    if (format != null) sb.write(".$format");
    return sb.toString();
  }

  /// String path = FileTool.getTempPath(category: 'Pictures',fileName: 'demo.png');
  /// String path = FileTool.getTempPath(category: 'Pictures', fileName: 'demo', format: 'png');
  /// Android: /data/user/0/packageName/cache/Pictures/demo.png
  /// iOS: xxx;
  static String? getTempPath({
    String? category,
    String? fileName,
    String? format,
  }) {
    return getPath(_tempDir,
        category: category, fileName: fileName, format: format);
  }

  /// String path = FileTool.getAppDocPath(category: 'Pictures', fileName: 'demo.png');
  /// String path = FileTool.getAppDocPath(category: 'Pictures', fileName: 'demo', format: 'png');
  /// Android: /data/user/0/packageName/app_flutter/Pictures/demo.png
  /// iOS: xxx;
  static String? getAppDocPath({
    String? category,
    String? fileName,
    String? format,
  }) {
    return getPath(_appDocDir,
        category: category, fileName: fileName, format: format);
  }

  /// String path = FileTool.getAppSupportPath(category: 'Pictures', fileName: 'demo.png');
  /// String path = FileTool.getAppSupportPath(category: 'Pictures', fileName: 'demo', format: 'png');
  /// Android: /data/user/0/packageName/files/Pictures/demo.png
  /// iOS: xxx;
  static String? getAppSupportPath({
    String? category,
    String? fileName,
    String? format,
  }) {
    return getPath(_appSupportDir,
        category: category, fileName: fileName, format: format);
  }

  /// String path = FileTool.getStoragePath(category: 'Download', fileName: 'demo.apk';
  /// String path = FileTool.getStoragePath(category: 'Download', fileName: 'demo', format: 'apk');
  /// Android: /storage/emulated/0/Android/data/package/files/Download/demo.apk
  /// iOS: xxx;
  static String? getStoragePath(
      {String? category, String? fileName, String? format}) {
    return getPath(
      _storageDir,
      category: category,
      fileName: fileName,
      format: format,
    );
  }

  static Directory? createTempDirSync({String? category}) {
    String? path = getTempPath(category: category);
    return createDirSync(path);
  }

  static Directory? createAppDocDirSync({String? category}) {
    String? path = getAppDocPath(category: category);
    return createDirSync(path);
  }

  static Directory? createAppSupportDirSync({String? category}) {
    String? path = getAppSupportPath(category: category);
    return createDirSync(path);
  }

  static Directory? createStorageDirSync({String? category}) {
    String? path = getStoragePath(category: category);
    return createDirSync(path);
  }

  static Future<Directory?> createTempDir({String? category}) async {
    await tempDir();
    String? path = getTempPath(category: category);
    return createDir(path);
  }

  static Future<Directory?> createAppDocDir({String? category}) async {
    await appDocDir();
    String? path = getAppDocPath(category: category);
    return createDir(path);
  }

  static Future<Directory?> createAppSupportDir({String? category}) async {
    await appSupportDir();
    String? path = getAppSupportPath(category: category);
    return createDir(path);
  }

  static Future<Directory?> createStorageDir({String? category}) async {
    await storageDir();
    String? path = getStoragePath(category: category);
    return createDir(path);
  }

  /// 临时目录: /data/user/0/packageName/cache
  /// 获取一个临时目录(缓存)，系统可以随时清除。
  static Future<String?> getTempDir() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      return tempDir.path;
    } catch (err) {
      TdLogger.e(err.toString());
      return null;
    }
  }

  /// 文档目录: /data/data/packageName/app_flutter
  /// 获取应用程序的目录，用于存储只有它可以访问的文件。只有当应用程序被删除时，系统才会清除目录。
  static Future<String?> getAppDocDir() async {
    try {
      await appDocDir();
      return _appDocDir!.path;
    } catch (err) {
      TdLogger.e(err.toString());
      return null;
    }
  }

  ///初始化文件路径，默认选中应用程序的目录
  static Future<File?> getAppFile(String fileName) async {
    final filePath = await getAppDocDir();
    if (filePath == null) {
      return null;
    }
    return File("$filePath/$fileName");
  }

  /// 写入json文件，默认写到应用程序的目录 [需要重新toString]
  static Future<File?> writeJsonFile(Map? obj, String fileName) async {
    if (obj == null) {
      return null;
    }
    try {
      final file = await getAppFile(fileName);
      String content = jsonEncode(obj);
      String encrypted = EncryptTool.aesEncrypt(content);
      return await file?.writeAsString(encrypted);
    } catch (err) {
      TdLogger.e(err.toString());
      return null;
    }
  }

  ///获取存在文件中的数据，默认读到应用程序的目录
  static Future<Map<String, dynamic>?> readJsonFile(String fileName) async {
    try {
      final file = await getAppFile(fileName);
      if (file == null || !file.existsSync()) {
        return null;
      }
      String? encrypted = await file.readAsString();
      String jsonString = EncryptTool.aesDecrypt(encrypted, fileAes);
      return json.decode(jsonString);
    } catch (err) {
      TdLogger.e(err.toString());
      return null;
    }
  }

  ///利用文件存储字符串，默认写到应用程序的目录
  static Future<File?> writeStringFile(String? string, String fileName) async {
    if (string == null) {
      return null;
    }
    try {
      final file = await getAppFile(fileName);
      String encrypted = EncryptTool.aesEncrypt(string);
      return await file?.writeAsString(encrypted);
    } catch (err) {
      TdLogger.e(err.toString());
      return null;
    }
  }

  ///获取存在文件中的数据，默认读到应用程序的目录
  static Future<String?> readStringFile(String fileName) async {
    try {
      final file = await getAppFile(fileName);
      String? encrypted = await file?.readAsString();
      return EncryptTool.aesDecrypt(encrypted, fileAes);
    } catch (err) {
      TdLogger.e(err.toString());
      return null;
    }
  }

  /// 清除文件数据
  static Future<bool> clearFileData(String fileName) async {
    try {
      final file = await getAppFile(fileName);
      file?.writeAsStringSync("");
      return true;
    } catch (err) {
      TdLogger.e(err.toString());
      return false;
    }
  }

  /// 删除文件
  static Future<bool> deleteFileData(String fileName) async {
    try {
      final file = await getAppFile(fileName);
      if (file?.existsSync() == true) {
        file?.deleteSync();
        return true;
      }
      return false;
    } catch (err) {
      TdLogger.e(err.toString());
      return false;
    }
  }

  static Future deleteDirFiles(Directory dir) async {
    if (dir.existsSync()) {
      List<FileSystemEntity> files = dir.listSync();
      if (files.isNotEmpty) {
        for (var file in files) {
          file.deleteSync();
        }
      }
    }
  }

  static File? fileFromPathIfExit(String? path) {
    if (path == null) return null;
    File f = File(path);
    if (f.existsSync()) {
      return f;
    }
    return null;
  }

  static List<File?>? fileFromPathListIfExit(dynamic pathList) {
    if (pathList == null || pathList is! List) return null;
    List<File?> files = [];
    for (dynamic path in pathList) {
      if (path is String && path.isNotEmpty) {
        File f = File(path);
        files.add(f);
      }
    }
    return files;
  }

  // 转换方法
  static File? getLocalFileFromUri(String? uriPath) {
    if (uriPath == null) {
      return null;
    }
    // 解析URI并解码特殊字符
    final uri = Uri.parse(uriPath);
    String decodedPath = uri.path;

    // 处理Android平台的三斜杠问题
    if (decodedPath.startsWith('///')) {
      decodedPath = decodedPath.substring(2);
    }

    // 创建File对象
    final file = File(decodedPath);

    // 验证文件存在性
    if (!file.existsSync()) {
      return null;
    }

    return file;
  }
}
