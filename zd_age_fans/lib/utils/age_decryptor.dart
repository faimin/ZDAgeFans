import 'dart:convert';
import 'dart:typed_data';

/// AgeFans m3u8 链接解密器
///
/// 支持多种可能的解密算法:
/// 1. RC4 流加密
/// 2. XOR 加密
/// 3. 简单字节变换
class AgeDecryptor {
  /// 解密 age_ 前缀的加密 URL
  ///
  /// 格式: age_[4位哈希][Base64编码的加密数据]
  ///
  /// 示例:
  /// ```dart
  /// final encrypted = 'age_2498GyJ%2Fsiv1oq3B7wicuGF%2FNHJTkNN3ZobtVxzW...';
  /// final decrypted = AgeDecryptor.decrypt(encrypted);
  /// print(decrypted); // https://xxxxx.com/path/to/video.m3u8
  /// ```
  static String decrypt(String encryptedUrl) {
    // 1. 验证和解析
    if (!encryptedUrl.startsWith('age_')) {
      throw FormatException('Invalid format: URL must start with "age_"');
    }

    final withoutPrefix = encryptedUrl.substring(4);
    if (withoutPrefix.length < 4) {
      throw FormatException('Invalid format: URL too short');
    }

    // 2. 提取哈希和加密数据
    final hash = withoutPrefix.substring(0, 4);
    final encrypted = withoutPrefix.substring(4);

    // 3. URL解码
    final urlDecoded = Uri.decodeComponent(encrypted);

    // 4. Base64解码
    final encryptedBytes = _base64DecodeWithPadding(urlDecoded);

    // 5. 尝试不同的解密方法
    String? result;

    // 方法1: RC4 with hash-based key
    result = _tryRC4Decrypt(encryptedBytes, hash);
    if (result != null && _isValidUrl(result)) {
      return result;
    }

    // 方法2: XOR with derived key
    result = _tryXorDecrypt(encryptedBytes, hash);
    if (result != null && _isValidUrl(result)) {
      return result;
    }

    // 方法3: Simple byte transformation
    result = _trySimpleDecrypt(encryptedBytes, hash);
    if (result != null && _isValidUrl(result)) {
      return result;
    }

    // 如果所有方法都失败,抛出异常
    throw Exception(
      'Decryption failed: Unable to decrypt with known algorithms. '
      'Hash: $hash, Encrypted length: ${encryptedBytes.length} bytes',
    );
  }

  /// Base64解码并自动处理padding
  static Uint8List _base64DecodeWithPadding(String input) {
    var normalized = input;

    // 添加padding使其长度是4的倍数
    final paddingNeeded = (4 - normalized.length % 4) % 4;
    if (paddingNeeded > 0) {
      normalized += '=' * paddingNeeded;
    }

    try {
      return base64.decode(normalized);
    } catch (e) {
      throw FormatException('Base64 decode failed: $e');
    }
  }

  /// 尝试使用RC4解密
  static String? _tryRC4Decrypt(Uint8List data, String hash) {
    try {
      // 方案1: 使用哈希作为密钥
      var key = Uint8List.fromList(utf8.encode(hash));
      var result = _rc4(data, key);
      var decoded = _tryUtf8Decode(result);
      if (decoded != null) return decoded;

      // 方案2: 使用哈希的十六进制值
      var hashInt = int.parse(hash, radix: 16);
      key = Uint8List.fromList([
        (hashInt >> 8) & 0xFF,
        hashInt & 0xFF,
      ]);
      result = _rc4(data, key);
      decoded = _tryUtf8Decode(result);
      if (decoded != null) return decoded;

      // 方案3: 使用固定密钥 + 哈希
      key = Uint8List.fromList(utf8.encode('agefans$hash'));
      result = _rc4(data, key);
      decoded = _tryUtf8Decode(result);
      if (decoded != null) return decoded;

      return null;
    } catch (e) {
      return null;
    }
  }

  /// 尝试使用XOR解密
  static String? _tryXorDecrypt(Uint8List data, String hash) {
    try {
      // 方案1: 使用哈希派生的密钥
      var hashInt = int.parse(hash, radix: 16);
      var key = Uint8List.fromList([
        (hashInt >> 8) & 0xFF,
        hashInt & 0xFF,
      ]);
      var result = _xor(data, key);
      var decoded = _tryUtf8Decode(result);
      if (decoded != null) return decoded;

      // 方案2: 使用哈希字符串作为密钥
      key = Uint8List.fromList(utf8.encode(hash));
      result = _xor(data, key);
      decoded = _tryUtf8Decode(result);
      if (decoded != null) return decoded;

      // 方案3: 使用常见密钥
      final commonKeys = ['agefans', 'age2020', 'AGEFANS'];
      for (var keyStr in commonKeys) {
        key = Uint8List.fromList(utf8.encode(keyStr));
        result = _xor(data, key);
        decoded = _tryUtf8Decode(result);
        if (decoded != null) return decoded;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// 尝试简单字节变换解密
  static String? _trySimpleDecrypt(Uint8List data, String hash) {
    try {
      // 方案1: 字节反转
      var result = Uint8List.fromList(data.reversed.toList());
      var decoded = _tryUtf8Decode(result);
      if (decoded != null) return decoded;

      // 方案2: 字节减法
      var hashInt = int.parse(hash, radix: 16);
      var offset = hashInt % 256;
      result = Uint8List.fromList(
        data.map((b) => (b - offset) & 0xFF).toList(),
      );
      decoded = _tryUtf8Decode(result);
      if (decoded != null) return decoded;

      return null;
    } catch (e) {
      return null;
    }
  }

  /// RC4 流加密算法
  static Uint8List _rc4(Uint8List data, Uint8List key) {
    if (key.isEmpty) {
      throw ArgumentError('RC4 key cannot be empty');
    }

    // KSA (Key-Scheduling Algorithm)
    final s = List<int>.generate(256, (i) => i);
    var j = 0;
    for (var i = 0; i < 256; i++) {
      j = (j + s[i] + key[i % key.length]) % 256;
      // Swap
      final temp = s[i];
      s[i] = s[j];
      s[j] = temp;
    }

    // PRGA (Pseudo-Random Generation Algorithm)
    final result = Uint8List(data.length);
    var i = 0;
    j = 0;
    for (var k = 0; k < data.length; k++) {
      i = (i + 1) % 256;
      j = (j + s[i]) % 256;
      // Swap
      final temp = s[i];
      s[i] = s[j];
      s[j] = temp;

      final keyStream = s[(s[i] + s[j]) % 256];
      result[k] = data[k] ^ keyStream;
    }

    return result;
  }

  /// XOR 加密/解密
  static Uint8List _xor(Uint8List data, Uint8List key) {
    if (key.isEmpty) {
      throw ArgumentError('XOR key cannot be empty');
    }

    final result = Uint8List(data.length);
    for (var i = 0; i < data.length; i++) {
      result[i] = data[i] ^ key[i % key.length];
    }
    return result;
  }

  /// 尝试UTF-8解码,如果失败返回null
  static String? _tryUtf8Decode(Uint8List bytes) {
    try {
      final decoded = utf8.decode(bytes, allowMalformed: false);
      // 检查是否包含太多不可打印字符
      if (_hasTooManyNonPrintable(decoded)) {
        return null;
      }
      return decoded;
    } catch (e) {
      return null;
    }
  }

  /// 检查字符串是否包含太多不可打印字符
  static bool _hasTooManyNonPrintable(String s) {
    if (s.isEmpty) return true;

    var nonPrintableCount = 0;
    for (var rune in s.runes) {
      // 允许的字符: 可打印ASCII + 常见URL字符
      if (rune < 32 || (rune > 126 && rune < 160)) {
        nonPrintableCount++;
      }
    }

    // 如果超过20%是不可打印字符,认为解密失败
    return nonPrintableCount > s.length * 0.2;
  }

  /// 验证是否是有效的URL
  static bool _isValidUrl(String url) {
    if (url.isEmpty) return false;

    // 必须以http或https开头
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return false;
    }

    // 应该包含域名
    if (!url.contains('.')) {
      return false;
    }

    // 对于m3u8链接,应该包含.m3u8扩展名或相关路径
    // 但有些链接可能是API端点,所以这个检查放宽
    return true;
  }

  /// 批量解密多个URL
  static Map<String, String> decryptBatch(Map<String, String> encryptedUrls) {
    final results = <String, String>{};
    for (var entry in encryptedUrls.entries) {
      try {
        results[entry.key] = decrypt(entry.value);
      } catch (e) {
        results[entry.key] = 'ERROR: $e';
      }
    }
    return results;
  }
}
