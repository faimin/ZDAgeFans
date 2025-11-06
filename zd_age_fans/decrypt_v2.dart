import 'dart:convert';

/// 尝试不同的解密方案
/// 可能性1: 密钥与4位哈希相关
/// 可能性2: 使用AES加密
/// 可能性3: 使用其他变换

void main() {
  final test = 'age_2498GyJ%2Fsiv1oq3B7wicuGF%2FNHJTkNN3ZobtVxzW%2BMloVQgHz%2BLSnSXd13bR4Li%2FgQnhIfaNW9Mq47IEu3o0i0yny00pLqVpr02d0RrThLrwms72aiPXaQTN';

  print('分析第一个样本的所有可能性');
  print('=' * 80);

  // 解析
  final withoutPrefix = test.substring(4);
  final hash = withoutPrefix.substring(0, 4);
  final encrypted = withoutPrefix.substring(4);
  final urlDecoded = Uri.decodeComponent(encrypted);
  final bytes = base64.decode(urlDecoded);

  print('哈希: $hash (0x$hash)');
  print('解密后长度: ${bytes.length} bytes');
  print('');

  // 方案1: 使用哈希作为密钥种子
  print('方案1: 使用哈希作为XOR密钥');
  tryHashAsKey(bytes, hash);

  // 方案2: 反推 - 假设开头是常见的m3u8 URL模式
  print('\n方案2: 反推密钥 (假设URL格式)');
  final possibleStarts = [
    'https://v',
    'https://m',
    'https://c',
    'http://v',
    'http://m',
    'http://c',
  ];

  for (var start in possibleStarts) {
    tryReverseEngineer(bytes, start);
  }

  // 方案3: 检查是否简单的字符替换
  print('\n方案3: 字节频率分析');
  analyzeByteFrequency(bytes);
}

void tryHashAsKey(List<int> bytes, String hash) {
  // 将十六进制哈希转为字节
  final hashInt = int.parse(hash, radix: 16);
  final key1 = [(hashInt >> 8) & 0xFF, hashInt & 0xFF];
  final key2 = utf8.encode(hash);
  final key3 = [hashInt & 0xFF, (hashInt >> 8) & 0xFF]; // 反转

  print('  密钥1 (2字节): ${key1.map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(', ')}');
  final result1 = xorDecrypt(bytes, key1);
  print('    结果: ${_preview(result1)}');

  print('  密钥2 (4字节ASCII): ${key2.map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(', ')}');
  final result2 = xorDecrypt(bytes, key2);
  print('    结果: ${_preview(result2)}');

  print('  密钥3 (2字节反转): ${key3.map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(', ')}');
  final result3 = xorDecrypt(bytes, key3);
  print('    结果: ${_preview(result3)}');
}

void tryReverseEngineer(List<int> bytes, String expectedStart) {
  if (bytes.length < expectedStart.length) return;

  final startBytes = utf8.encode(expectedStart);
  final key = <int>[];

  for (var i = 0; i < startBytes.length; i++) {
    key.add(bytes[i] ^ startBytes[i]);
  }

  print('  假设开头: "$expectedStart"');
  print('    推测密钥: ${key.map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(' ')}');

  // 检查密钥是否有规律
  if (_hasPattern(key)) {
    print('    ✓ 密钥有规律! 尝试完整解密...');
    final fullResult = xorDecrypt(bytes, key);
    final decoded = _tryDecode(fullResult);
    if (decoded.startsWith('http')) {
      print('    ✓✓ 成功! 完整URL: $decoded');
    }
  }
}

bool _hasPattern(List<int> key) {
  if (key.length < 4) return false;

  // 检查是否所有字节都相同
  if (key.toSet().length == 1) return true;

  // 检查是否是重复模式
  if (key.length >= 4) {
    final first = key[0];
    final second = key[1];
    for (var i = 2; i < key.length; i += 2) {
      if (i < key.length && key[i] != first) return false;
      if (i + 1 < key.length && key[i + 1] != second) return false;
    }
    return true;
  }

  return false;
}

void analyzeByteFrequency(List<int> bytes) {
  final freq = <int, int>{};
  for (var b in bytes) {
    freq[b] = (freq[b] ?? 0) + 1;
  }

  final sorted = freq.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  print('  前10个最常见字节:');
  for (var i = 0; i < 10 && i < sorted.length; i++) {
    final entry = sorted[i];
    print('    0x${entry.key.toRadixString(16).padLeft(2, '0')} : ${entry.value}次');
  }
}

List<int> xorDecrypt(List<int> data, List<int> key) {
  final result = <int>[];
  for (var i = 0; i < data.length; i++) {
    result.add(data[i] ^ key[i % key.length]);
  }
  return result;
}

String _preview(List<int> bytes, {int length = 30}) {
  final preview = bytes.take(length).toList();
  final decoded = _tryDecode(preview);
  return decoded.length > 25 ? '${decoded.substring(0, 25)}...' : decoded;
}

String _tryDecode(List<int> bytes) {
  try {
    final decoded = utf8.decode(bytes);
    return decoded.runes
        .map((r) => (r >= 32 && r < 127) || r == 10
            ? String.fromCharCode(r)
            : '\\x${r.toRadixString(16).padLeft(2, '0')}')
        .join();
  } catch (e) {
    return bytes
        .map((b) => (b >= 32 && b < 127)
            ? String.fromCharCode(b)
            : '\\x${b.toRadixString(16).padLeft(2, '0')}')
        .join();
  }
}
