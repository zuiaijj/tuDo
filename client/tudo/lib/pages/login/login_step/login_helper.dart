import 'package:tudo/tool/string_tool.dart';

const int _minPhoneNumberLen = 7;
const int _maxPhoneNumberLen = 13;

isValidPhoneNumber(String phoneNumber, {String? areaCode}) {
  int max = _maxPhoneNumberLen;
  int min = _minPhoneNumberLen;
  if (areaCode.isSafeNotEmpty && areaCode == "84") {
    max = 10;
    min = 9;
  }
  return phoneNumber.isSafeNotEmpty &&
      phoneNumber.length >= min &&
      phoneNumber.length <= max;
}
