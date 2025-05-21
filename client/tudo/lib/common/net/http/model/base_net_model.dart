class BaseNetRes {
  int code = -1;
  String message = '';
  Map<String, dynamic> resMap = {};

  bool get isSuccess => code == 0;

  dynamic get data => resMap['data'];

  BaseNetRes();

  BaseNetRes.error(this.message);

  BaseNetRes.fromJson(Map<String, dynamic> json) {
    code = json['dm_error'];
    message = json['error_msg'];
    resMap = json;
  }

  Map<String, dynamic> toJson() {
    return resMap;
  }
}
