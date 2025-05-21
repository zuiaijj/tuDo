import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// sp存储工具类，适合存储轻量级数据，不建议存储json长字符串
class SpTool {
  SpTool._();

  static late SharedPreferences _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool hasKey(String key) {
    Set keys = getKeys();
    return keys.contains(key);
  }

  static Future<bool> putObject(String key, Object? value) {
    return putString(key, value == null ? "" : json.encode(value));
  }

  static Map getObject(String key) {
    String data = getString(key);
    return (data.isEmpty) ? null : json.decode(data);
  }

  static Future<bool> putObjectList(String key, List<Object>? list) {
    List<String>? dataList = list?.map((value) => json.encode(value)).toList();
    return _prefs.setStringList(key, dataList ?? []);
  }

  static List<Map>? getObjectList(String key) {
    List<String>? dataLis = _prefs.getStringList(key);
    return dataLis?.map<Map>((value) => json.decode(value)).toList();
  }

  static String getString(String key, {String defValue = ''}) {
    return _prefs.getString(key) ?? defValue;
  }

  static Future<bool> putString(String key, String value) {
    return _prefs.setString(key, value);
  }

  static bool getBool(String key, {bool defValue = false}) {
    return _prefs.getBool(key) ?? defValue;
  }

  static Future<bool> putBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  static int getInt(String key, {int defValue = 0}) {
    return _prefs.getInt(key) ?? defValue;
  }

  static Future<bool> putInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  static double getDouble(String key, {double defValue = 0.0}) {
    return _prefs.getDouble(key) ?? defValue;
  }

  static Future<bool> putDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }

  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    return _prefs.getStringList(key) ?? defValue;
  }

  static Future<bool> putStringList(String key, List<String> value) {
    return _prefs.setStringList(key, value);
  }

  static Map getStringMap(String key) {
    var jsonString = getString(key);
    Map map = json.decode(jsonString);
    return map;
  }

  /// 存储sp中key的map值
  static Future<bool> putStringMap(String key, Map value) {
    var jsonMapString = jsonEncode(value);
    return putString(key, jsonMapString);
  }

  static Future<bool> putList(String key, List value) {
    var jsonMapString = jsonEncode(value);
    return putString(key, jsonMapString);
  }

  static dynamic getDynamic(String key, {required Object defValue}) {
    return _prefs.get(key) ?? defValue;
  }

  static Set<String> getKeys() {
    return _prefs.getKeys();
  }

  static Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  static Future<bool> clear() {
    return _prefs.clear();
  }
}
