import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tudo/tool/enum_tool.dart';

enum Env {
  test,
  online,
}

class EnvManager {
  static Env? _env;

  static bool get isOnline => _env == Env.online;

  static bool get isTest => _env == Env.test;

  static bool isLocal = false;

  static init() async {
    try {
      await dotenv.load(fileName: 'assets/.env');
      _env = enumFromName(Env.values, dotenv.env['env'] ?? '');
      isLocal = dotenv.env['local'] == '1';
    } catch (e) {
      print('env load error: $e');
    }
  }
}
