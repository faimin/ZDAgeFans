import 'dart:convert';

/// AgeFans m3u8 链接解密算法
///
/// 加密格式: age_[4位哈希][Base64编码的XOR加密数据]
///
/// 解密步骤:
/// 1. 移除 'age_' 前缀
/// 2. 提取前4位哈希值(目前未使用,可能用于校验)
/// 3. URL解码剩余部分
/// 4. Base64解码
/// 5. 使用固定密钥进行XOR解密
///
/// XOR密钥: [0x73, 0x56, 0x0b, 0xc2, 0x58] (通过反推 "https" 得出)

void main() {
  // 测试所有 ffm3u8 的链接
  final testCases = {
    '第01集': 'age_2498GyJ%2Fsiv1oq3B7wicuGF%2FNHJTkNN3ZobtVxzW%2BMloVQgHz%2BLSnSXd13bR4Li%2FgQnhIfaNW9Mq47IEu3o0i0yny00pLqVpr02d0RrThLrwms72aiPXaQTN',
    '第02集': 'age_bdc0zVn43ccSPuh3Bb0IISHToVXopMBDWOz7uWMH1pKh49xRNqV4wsekF4FvyxmJyfu4a%2B37IUCFA9z0aG%2BD4oSpfOWTNRwc9XDWIs69pX5I2CdGeb44BSD3',
    '第03集': 'age_772559Qn2OedEDPrhKcx21MajctNLt5OGpGWXY6JEsKJT57h693%2FZ8UbWoa3pQIO4b08XP4s8K8NqlkwWCI84CmOmZeRq%2BFjEd02BnlE%2F4D2vhtNffW0035B',
    '第04集': 'age_22a41ZO4aAfK55bKuQbQJOYYWMEVtJztYfX8vPsoSKhfgVy%2ByVYgDNULsz%2FKojsPuLfskHjrlYBw6jVZWWNfYCLQVrvcDvi5Lx4mvOTDeKHbM4R5BdD1zWyW',
    '第05集': 'age_8443Q%2BUnDCoNK9Ji%2FGZ86vE7XASMMpcqJVNuSikdbg4NtPvlsjzWsFjUm89AQWCYtm01qAwr5PwutxzSBMqJ4%2BHIGbqeCiTBNFnJUy%2BrTvDfXW2Sc2BgVTIq',
  };

  print('=' * 80);
  print('AgeFans m3u8 解密测试');
  print('=' * 80);

  for (var entry in testCases.entries) {
    print('\n${entry.key}:');
    print('  加密: ${entry.value.substring(0, 50)}...');

    try {
      final decrypted = decryptAgeUrl(entry.value);
      print('  ✓ 解密: $decrypted');
    } catch (e) {
      print('  ❌ 失败: $e');
    }
  }

  // 测试其他播放源
  print('\n${'=' * 80}');
  print('测试其他播放源');
  print('=' * 80);

  final otherSources = {
    'wjm3u8': 'age_52c1JFmy6XjebfgJfKORjFpU9X9OIXWfa2xDfmehiTSH1ihbV0SZp8R3uSQvKS1UAWAI74EF34467djTVsbU4JRghRTZUuTEgG10g8y6BEkplQjTZqFFAMHWFDWubDo',
    'xigua': 'age_c5270ran2gyC8KVZ5U36atpk%2FH4SBVNotzZKtduxTqKwom8Y7%2BBgekNm7hbdWkn%2FpuqS1M0dt5IgXY%2BS5olPTjQl',
  };

  for (var entry in otherSources.entries) {
    print('\n${entry.key}:');
    try {
      final decrypted = decryptAgeUrl(entry.value);
      print('  ✓ 解密: $decrypted');
    } catch (e) {
      print('  ❌ 失败: $e');
    }
  }
}

/// 解密 AgeFans 加密的 URL
String decryptAgeUrl(String encryptedUrl) {
  // 1. 检查前缀
  if (!encryptedUrl.startsWith('age_')) {
    throw FormatException('Invalid format: missing age_ prefix');
  }

  // 2. 移除前缀
  final withoutPrefix = encryptedUrl.substring(4);

  // 3. 提取哈希值(前4位)
  if (withoutPrefix.length < 4) {
    throw FormatException('Invalid format: too short');
  }

  final hash = withoutPrefix.substring(0, 4);
  final encrypted = withoutPrefix.substring(4);

  // 4. URL解码
  final urlDecoded = Uri.decodeComponent(encrypted);

  // 5. 处理Base64 padding
  var base64Str = urlDecoded;
  final paddingNeeded = (4 - base64Str.length % 4) % 4;
  if (paddingNeeded > 0) {
    base64Str += '=' * paddingNeeded;
  }

  // 6. Base64解码
  List<int> encryptedBytes;
  try {
    encryptedBytes = base64.decode(base64Str);
  } catch (e) {
    throw FormatException('Base64 decode failed: $e');
  }

  // 7. XOR解密
  // 密钥通过反推 "https" 得出
  final xorKey = [0x73, 0x56, 0x0b, 0xc2, 0x58];
  final decryptedBytes = <int>[];

  for (var i = 0; i < encryptedBytes.length; i++) {
    decryptedBytes.add(encryptedBytes[i] ^ xorKey[i % xorKey.length]);
  }

  // 8. 转换为字符串
  try {
    return utf8.decode(decryptedBytes);
  } catch (e) {
    // 如果UTF-8解码失败,尝试Latin1
    return latin1.decode(decryptedBytes);
  }
}

/// 加密 URL (用于验证算法)
String encryptAgeUrl(String url, {String? hash}) {
  // 使用随机哈希或提供的哈希
  final h = hash ?? '0000';

  // XOR加密
  final xorKey = [0x73, 0x56, 0x0b, 0xc2, 0x58];
  final urlBytes = utf8.encode(url);
  final encrypted = <int>[];

  for (var i = 0; i < urlBytes.length; i++) {
    encrypted.add(urlBytes[i] ^ xorKey[i % xorKey.length]);
  }

  // Base64编码
  final base64Encoded = base64.encode(encrypted);

  // URL编码(只编码特殊字符)
  final urlEncoded = Uri.encodeComponent(base64Encoded);

  return 'age_$h$urlEncoded';
}
