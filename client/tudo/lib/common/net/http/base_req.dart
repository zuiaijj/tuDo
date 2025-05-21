import 'dart:convert';

class BaseReq {

  Map<String, dynamic> get param => {};

  @override
  String toString() => jsonEncode(param);
}