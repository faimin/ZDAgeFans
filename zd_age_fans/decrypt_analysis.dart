import 'dart:convert';

/// AgeFans m3u8 链接解密分析
///
/// 通过分析多个样本,发现加密格式为:
/// age_[4位十六进制哈希][Base64URL编码的加密数据]
///
/// 可能的解密方案:
/// 1. 前4位是某种校验码或密钥提示
/// 2. 使用Base64URL解码(需要处理 padding)
/// 3. 可能使用AES或其他对称加密
/// 4. 密钥可能与哈希值相关

void main() {
  // 分析所有ffm3u8的链接,看是否有规律
  final ffm3u8Episodes = {
    '第01集': 'age_2498GyJ%2Fsiv1oq3B7wicuGF%2FNHJTkNN3ZobtVxzW%2BMloVQgHz%2BLSnSXd13bR4Li%2FgQnhIfaNW9Mq47IEu3o0i0yny00pLqVpr02d0RrThLrwms72aiPXaQTN',
    '第02集': 'age_bdc0zVn43ccSPuh3Bb0IISHToVXopMBDWOz7uWMH1pKh49xRNqV4wsekF4FvyxmJyfu4a%2B37IUCFA9z0aG%2BD4oSpfOWTNRwc9XDWIs69pX5I2CdGeb44BSD3',
    '第03集': 'age_772559Qn2OedEDPrhKcx21MajctNLt5OGpGWXY6JEsKJT57h693%2FZ8UbWoa3pQIO4b08XP4s8K8NqlkwWCI84CmOmZeRq%2BFjEd02BnlE%2F4D2vhtNffW0035B',
    '第04集': 'age_22a41ZO4aAfK55bKuQbQJOYYWMEVtJztYfX8vPsoSKhfgVy%2ByVYgDNULsz%2FKojsPuLfskHjrlYBw6jVZWWNfYCLQVrvcDvi5Lx4mvOTDeKHbM4R5BdD1zWyW',
    '第05集': 'age_8443Q%2BUnDCoNK9Ji%2FGZ86vE7XASMMpcqJVNuSikdbg4NtPvlsjzWsFjUm89AQWCYtm01qAwr5PwutxzSBMqJ4%2BHIGbqeCiTBNFnJUy%2BrTvDfXW2Sc2BgVTIq',
  };

  print('=' * 80);
  print('AgeFans 加密链接深度分析');
  print('=' * 80);

  for (var entry in ffm3u8Episodes.entries) {
    print('\n${entry.key}:');
    final parsed = parseEncryptedUrl(entry.value);
    print('  哈希: ${parsed['hash']}');
    print('  原始加密长度: ${parsed['encrypted'].length}');
    print('  URL解码后长度: ${parsed['decoded'].length}');

    // 尝试添加 padding 使其成为4的倍数
    final decoded = parsed['decoded'] as String;
    final paddingNeeded = (4 - decoded.length % 4) % 4;
    final withPadding = decoded + ('=' * paddingNeeded);
    print('  需要padding: $paddingNeeded');

    try {
      final bytes = base64.decode(withPadding);
      print('  ✓ Base64解码成功: ${bytes.length} bytes');

      // 分析字节特征
      print('  前8字节(hex): ${bytes.take(8).map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
      print('  是否16倍数: ${bytes.length % 16 == 0 ? '是(可能AES)' : '否'}');

      // 尝试简单解密: XOR with hash
      final hash = parsed['hash'] as String;
      final hashInt = int.parse(hash, radix: 16);
      final xorKey = [
        (hashInt >> 8) & 0xFF,
        hashInt & 0xFF,
      ];

      final xorResult = <int>[];
      for (var i = 0; i < bytes.length; i++) {
        xorResult.add(bytes[i] ^ xorKey[i % 2]);
      }

      // 尝试解析为URL
      final xorStr = String.fromCharCodes(xorResult);
      if (xorStr.startsWith('http') || xorStr.contains('.m3u8')) {
        print('  ✓ XOR解密成功: $xorStr');
      } else {
        print('  XOR尝试: 前20字符 ${_escapeString(xorStr.substring(0, xorStr.length > 20 ? 20 : xorStr.length))}');
      }

    } catch (e) {
      print('  ❌ Base64解码失败: $e');
    }
  }

  print('\n${'=' * 80}');
  print('尝试使用已知的 m3u8 链接特征反推密钥');
  print('=' * 80);

  // m3u8链接通常以 http 或 https 开头
  // 尝试用第一个样本推测
  final firstSample = parseEncryptedUrl(ffm3u8Episodes['第01集']!);
  final decoded = firstSample['decoded'] as String;
  final paddingNeeded = (4 - decoded.length % 4) % 4;
  final withPadding = decoded + ('=' * paddingNeeded);

  try {
    final encrypted = base64.decode(withPadding);
    print('\n分析第01集 (${encrypted.length} bytes):');

    // 假设开头是 "http" 或 "https", 尝试反推XOR密钥
    final httpBytes = utf8.encode('http');
    final httpsBytes = utf8.encode('https');

    print('尝试假设开头为 "http":');
    for (var i = 0; i < 4; i++) {
      final key = encrypted[i] ^ httpBytes[i];
      print('  位置 $i: key = ${key.toRadixString(16).padLeft(2, '0')}');
    }

    print('\n尝试假设开头为 "https":');
    for (var i = 0; i < 5; i++) {
      final key = encrypted[i] ^ httpsBytes[i];
      print('  位置 $i: key = ${key.toRadixString(16).padLeft(2, '0')}');
    }

  } catch (e) {
    print('分析失败: $e');
  }
}

Map<String, dynamic> parseEncryptedUrl(String url) {
  final withoutPrefix = url.substring(4); // 移除 'age_'
  final hash = withoutPrefix.substring(0, 4);
  final encrypted = withoutPrefix.substring(4);
  final decoded = Uri.decodeComponent(encrypted);

  return {
    'hash': hash,
    'encrypted': encrypted,
    'decoded': decoded,
  };
}

String _escapeString(String s) {
  return s.runes.map((r) {
    if (r >= 32 && r < 127) {
      return String.fromCharCode(r);
    } else {
      return '\\x${r.toRadixString(16).padLeft(2, '0')}';
    }
  }).join();
}
