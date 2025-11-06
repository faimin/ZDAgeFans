import 'dart:convert';
import 'package:convert/convert.dart';

/// 分析和解密 age_ 前缀的加密 m3u8 链接
///
/// 格式分析:
/// age_[4位哈希][Base64编码的URL编码字符串]
///
/// 示例:
/// age_2498GyJ%2Fsiv1oq3B7wicuGF%2FNHJTkNN3ZobtVxzW%2BMloVQgHz%2BLSnSXd13bR4Li%2FgQnhIfaNW9Mq47IEu3o0i0yny00pLqVpr02d0RrThLrwms72aiPXaQTN

void main() {
  // 测试不同播放源的第一集
  final testCases = {
    'ffm3u8': 'age_2498GyJ%2Fsiv1oq3B7wicuGF%2FNHJTkNN3ZobtVxzW%2BMloVQgHz%2BLSnSXd13bR4Li%2FgQnhIfaNW9Mq47IEu3o0i0yny00pLqVpr02d0RrThLrwms72aiPXaQTN',
    'wjm3u8': 'age_52c1JFmy6XjebfgJfKORjFpU9X9OIXWfa2xDfmehiTSH1ihbV0SZp8R3uSQvKS1UAWAI74EF34467djTVsbU4JRghRTZUuTEgG10g8y6BEkplQjTZqFFAMHWFDWubDo',
    'xigua': 'age_c5270ran2gyC8KVZ5U36atpk%2FH4SBVNotzZKtduxTqKwom8Y7%2BBgekNm7hbdWkn%2FpuqS1M0dt5IgXY%2BS5olPTjQl',
    'hnm3u8': 'age_fff7jc2ZxdE0q6RU8HzKgte0p62%2FjE45DHPJteftczwlyE4L2UXE2P%2FzudaScBgwd1CV4D6AtQaF2dYfav2YE2HHXruWRYu%2BE1Y',
  };

  print('=' * 80);
  print('分析加密的 m3u8 链接');
  print('=' * 80);

  for (var entry in testCases.entries) {
    print('\n播放源: ${entry.key}');
    print('原始链接: ${entry.value}');
    analyzeAndDecrypt(entry.value);
  }
}

void analyzeAndDecrypt(String encryptedUrl) {
  // 1. 移除 age_ 前缀
  if (!encryptedUrl.startsWith('age_')) {
    print('❌ 错误: 不是有效的 age_ 格式');
    return;
  }

  final withoutPrefix = encryptedUrl.substring(4);
  print('移除前缀: $withoutPrefix');

  // 2. 提取前4位哈希值
  if (withoutPrefix.length < 4) {
    print('❌ 错误: 长度不足');
    return;
  }

  final hash = withoutPrefix.substring(0, 4);
  final encrypted = withoutPrefix.substring(4);
  print('哈希值: $hash');
  print('加密内容: $encrypted');

  // 3. URL解码
  final urlDecoded = Uri.decodeComponent(encrypted);
  print('URL解码后: $urlDecoded');
  print('URL解码后长度: ${urlDecoded.length}');

  // 4. 尝试Base64解码
  try {
    final base64Decoded = base64.decode(urlDecoded);
    print('✓ Base64解码成功, 长度: ${base64Decoded.length} bytes');
    print('前16字节 (hex): ${hex.encode(base64Decoded.take(16).toList())}');
    print('前16字节 (string): ${_tryDecode(base64Decoded.take(16).toList())}');
    print('后16字节 (hex): ${hex.encode(base64Decoded.skip(base64Decoded.length - 16).toList())}');

    // 5. 尝试不同的解密方法
    print('\n尝试解密方法:');

    // 方法1: 直接解码为字符串
    try {
      final direct = utf8.decode(base64Decoded);
      print('方法1 - 直接UTF-8: $direct');
    } catch (e) {
      print('方法1 - 直接UTF-8: ❌ 失败 ($e)');
    }

    // 方法2: XOR with hash
    final xorResult = _xorDecrypt(base64Decoded, hash);
    print('方法2 - XOR with hash: ${_tryDecode(xorResult)}');

    // 方法3: 检查是否是 AES 加密 (通常是16的倍数)
    if (base64Decoded.length % 16 == 0) {
      print('方法3 - 可能是AES加密 (长度是16的倍数: ${base64Decoded.length})');
      print('  需要密钥才能解密');
    }

    // 方法4: 尝试使用hash作为简单密钥
    final hashBytes = utf8.encode(hash);
    print('方法4 - Hash bytes: ${hex.encode(hashBytes)}');

  } catch (e) {
    print('❌ Base64解码失败: $e');
  }

  print('-' * 80);
}

/// XOR 解密
List<int> _xorDecrypt(List<int> data, String key) {
  final keyBytes = utf8.encode(key);
  final result = <int>[];
  for (var i = 0; i < data.length; i++) {
    result.add(data[i] ^ keyBytes[i % keyBytes.length]);
  }
  return result;
}

/// 尝试解码为字符串
String _tryDecode(List<int> bytes) {
  try {
    final decoded = utf8.decode(bytes);
    // 只显示可打印字符
    if (decoded.runes.every((r) => r >= 32 && r < 127 || r == 10 || r == 13)) {
      return decoded;
    }
    return '(不可打印)';
  } catch (e) {
    return '(解码失败)';
  }
}
