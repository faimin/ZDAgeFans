import 'dart:convert';

/// 最终解密方案
/// 通过分析多个样本,尝试推导完整密钥

void main() {
  // 所有ffm3u8样本
  final samples = [
    'age_2498GyJ%2Fsiv1oq3B7wicuGF%2FNHJTkNN3ZobtVxzW%2BMloVQgHz%2BLSnSXd13bR4Li%2FgQnhIfaNW9Mq47IEu3o0i0yny00pLqVpr02d0RrThLrwms72aiPXaQTN',
    'age_bdc0zVn43ccSPuh3Bb0IISHToVXopMBDWOz7uWMH1pKh49xRNqV4wsekF4FvyxmJyfu4a%2B37IUCFA9z0aG%2BD4oSpfOWTNRwc9XDWIs69pX5I2CdGeb44BSD3',
  ];

  print('尝试使用长密钥解密');
  print('=' * 80);

  // 假设1: 所有链接都指向同一个域名开头
  // 常见的m3u8 CDN格式: https://xxxxx.com/path/to/video.m3u8
  final possibleTemplates = [
    'https://v.gsuus.com/',  // 常见的视频CDN
    'https://cdn.com/video',
    'https://m3u8.com/play',
  ];

  // 对于每个模板,尝试推导密钥
  for (var template in possibleTemplates) {
    print('\n尝试模板: "$template"');
    tryDeriveKey(samples, template);
  }

  // 假设2: 使用固定的长密钥
  print('\n\n尝试推导通用密钥');
  print('=' * 80);

  // 比较两个样本,找出可能的密钥
  final bytes1 = parseAndDecode(samples[0]);
  final bytes2 = parseAndDecode(samples[1]);

  // 如果使用相同的密钥,XOR两个密文应该等于XOR两个明文
  print('样本1长度: ${bytes1.length}');
  print('样本2长度: ${bytes2.length}');

  // 尝试一些已知的密钥模式
  final knownKeys = [
    'AGEFANS',  // 网站名
    'age2020',  // 网站名+年份
    '2233',     // 常见密码
    utf8.encode('AGEFANS').map((b) => b ^ 0xFF).toList(), // 反转
  ];

  for (var keyStr in ['AGEFANS', 'age2020', '2233', 'agefans']) {
    final key = utf8.encode(keyStr);
    print('\n尝试密钥: "$keyStr" (${key.map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(' ')})');

    for (var i = 0; i < 2; i++) {
      final result = xorDecrypt(i == 0 ? bytes1 : bytes2, key);
      final decoded = _tryDecode(result);
      print('  样本${i + 1}: ${decoded.substring(0, decoded.length > 40 ? 40 : decoded.length)}...');

      if (decoded.startsWith('http')) {
        print('  ✓✓✓ 成功!完整URL: $decoded');
        return;
      }
    }
  }

  // 尝试数字密钥
  print('\n\n尝试数字模式密钥');
  print('=' * 80);
  for (var keyPattern in [0x24, 0x98, 0x2498, 0x9824]) {
    print('\n密钥模式: 0x${keyPattern.toRadixString(16)}');
    final key = _generateKeyFromPattern(keyPattern, 32);
    for (var i = 0; i < 2; i++) {
      final result = xorDecrypt(i == 0 ? bytes1 : bytes2, key);
      final decoded = _tryDecode(result);
      if (decoded.startsWith('http')) {
        print('  ✓✓✓ 成功! URL: $decoded');
        print('  密钥: ${key.map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(' ')}');
        return;
      }
    }
  }
}

void tryDeriveKey(List<String> samples, String template) {
  final templateBytes = utf8.encode(template);
  final bytes = parseAndDecode(samples[0]);

  if (bytes.length < templateBytes.length) {
    print('  跳过: 模板太长');
    return;
  }

  // 推导密钥
  final key = <int>[];
  for (var i = 0; i < templateBytes.length; i++) {
    key.add(bytes[i] ^ templateBytes[i]);
  }

  print('  推导的密钥前${key.length}字节: ${key.map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(' ')}');

  // 尝试用这个密钥解密
  final result = xorDecrypt(bytes, key);
  final decoded = _tryDecode(result);
  print('  解密结果: ${decoded.substring(0, decoded.length > 50 ? 50 : decoded.length)}');

  if (decoded.startsWith('http') && decoded.contains('.m3u8')) {
    print('  ✓✓✓ 成功找到密钥!');
    print('  完整密钥: ${key.map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(' ')}');
    print('  完整URL: $decoded');

    // 验证其他样本
    print('  验证其他样本:');
    for (var i = 1; i < samples.length; i++) {
      final testBytes = parseAndDecode(samples[i]);
      final testResult = xorDecrypt(testBytes, key);
      final testDecoded = _tryDecode(testResult);
      print('    样本${i + 1}: $testDecoded');
    }
  }
}

List<int> parseAndDecode(String encryptedUrl) {
  final withoutPrefix = encryptedUrl.substring(4);
  final encrypted = withoutPrefix.substring(4);
  final urlDecoded = Uri.decodeComponent(encrypted);
  return base64.decode(urlDecoded);
}

List<int> xorDecrypt(List<int> data, List<int> key) {
  if (key.isEmpty) return data;
  final result = <int>[];
  for (var i = 0; i < data.length; i++) {
    result.add(data[i] ^ key[i % key.length]);
  }
  return result;
}

List<int> _generateKeyFromPattern(int pattern, int length) {
  final key = <int>[];
  var current = pattern;
  for (var i = 0; i < length; i++) {
    key.add((current >> (8 * (i % 4))) & 0xFF);
  }
  return key;
}

String _tryDecode(List<int> bytes) {
  try {
    return utf8.decode(bytes);
  } catch (e) {
    return bytes
        .map((b) => (b >= 32 && b < 127)
            ? String.fromCharCode(b)
            : '\\x${b.toRadixString(16).padLeft(2, '0')}')
        .join();
  }
}
