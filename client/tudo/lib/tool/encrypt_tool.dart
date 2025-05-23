import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/pointycastle.dart' as pointy;
import 'package:convert/convert.dart';
import 'package:tudo/common/log/td_logger.dart';

/// 手机对称加密
const phoneAes = "UVsSl962H2B5I1ET";

/// 文件对称加密
const fileAes = "ZaiKF5LeBYQRsht=";

/// 手机非对称加密 （秘钥在服务端）
const phoneRsa = "-----BEGIN PUBLIC KEY-----\n"
    "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDPGgMS0JDFLaR7HN7e+7fqixeT\n"
    "Mkd0Z9JN0TRgJ8ii+77/UNl9rwZaiKF5LeBYQRshtPUGa1nOXDRNWJrzPybi4MCs\n"
    "bUB2LVyzrjVInHbA4sj48b+4vxge9cTKx3j9WffcSPF2Cv2FhitIo7Kqevi4T2AW\n"
    "Ncdx50NVVs1PK86N8wIDAQAB\n"
    "-----END PUBLIC KEY-----";

const toDigits = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'a',
  'b',
  'c',
  'd',
  'e',
  'f'
];

/// 加解密工具类
class EncryptTool {
  /// AES加密， 默认文件对称秘钥
  static String aesEncrypt(String? bareData, {String aes = fileAes}) {
    if (bareData == null || bareData.isEmpty) return '';
    try {
      final key = Key.fromUtf8(aes);
      final iv = IV.fromUtf8(aes);
      final encrypt = Encrypter(AES(key, mode: AESMode.cbc));
      final encrypted = encrypt.encrypt(bareData, iv: iv);
      // logger.i("aes encrypt :${encrypted.base64}");
      return encrypted.base64;
    } catch (err) {
      TdLogger.i("aes encrypt error:$err");
      return 'error';
    }
  }

  /// AES解密
  static String aesDecrypt(String? encrypted, String aesKey) {
    if (encrypted == null || encrypted.isEmpty) return '';
    try {
      final key = Key.fromUtf8(aesKey);
      final iv = IV.fromUtf8(aesKey);
      final encrypt = Encrypter(AES(key, mode: AESMode.cbc));
      final decrypted = encrypt.decrypt64(encrypted, iv: iv);
      TdLogger.i("aes decrypt :$decrypted");
      return decrypted;
    } catch (err) {
      TdLogger.i("aes decrypt error:$err");
      return encrypted;
    }
  }

  /// RAS加密手机号
  static String rsaPhoneEncrypt(String bareData) {
    pointy.RSAPublicKey publicKey =
        RSAKeyParser().parse(phoneRsa) as pointy.RSAPublicKey;
    final encrypt = Encrypter(RSA(publicKey: publicKey));
    final encrypted = encrypt.encrypt(bareData);
    return const AsciiCodec().decode(_encodeHex(encrypted.bytes.toList()));
  }

  static List<int> _encodeHex(List<int> data) {
    int l = data.length;
    List<String> out = List.filled(l << 1, '');
    int i = 0;
    int var5 = 0;
    for (; i < l; ++i) {
      out[var5++] = toDigits[(240 & data[i]) >> 4];
      out[var5++] = toDigits[15 & data[i]];
    }
    return out.join().runes.toList();
  }

  static String getMd5(String data) {
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  // 获取文件Md5
  static Future<String> getFileMd5(File file) async {
    final fileLength = file.lengthSync();
    final sFile = await file.open();
    try {
      final output = AccumulatorSink<Digest>();
      final input = md5.startChunkedConversion(output);
      int x = 0;
      const chunkSize = 50 * 1024 * 1024;
      while (x < fileLength) {
        final tmpLen = fileLength - x > chunkSize ? chunkSize : fileLength - x;
        input.add(sFile.readSync(tmpLen));
        x += tmpLen;
      }
      input.close();

      final hash = output.events.single;
      return hash.toString();
    } finally {
      unawaited(sFile.close());
    }
  }
}
