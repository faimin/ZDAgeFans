import 'lib/utils/age_decryptor.dart';

void main() {
  print('=' * 80);
  print('AgeFans 解密器测试');
  print('=' * 80);

  // 测试数据 - 来自stream-response.txt
  final testCases = {
    'ffm3u8-第01集': 'age_2498GyJ%2Fsiv1oq3B7wicuGF%2FNHJTkNN3ZobtVxzW%2BMloVQgHz%2BLSnSXd13bR4Li%2FgQnhIfaNW9Mq47IEu3o0i0yny00pLqVpr02d0RrThLrwms72aiPXaQTN',
    'ffm3u8-第02集': 'age_bdc0zVn43ccSPuh3Bb0IISHToVXopMBDWOz7uWMH1pKh49xRNqV4wsekF4FvyxmJyfu4a%2B37IUCFA9z0aG%2BD4oSpfOWTNRwc9XDWIs69pX5I2CdGeb44BSD3',
    'ffm3u8-第03集': 'age_772559Qn2OedEDPrhKcx21MajctNLt5OGpGWXY6JEsKJT57h693%2FZ8UbWoa3pQIO4b08XP4s8K8NqlkwWCI84CmOmZeRq%2BFjEd02BnlE%2F4D2vhtNffW0035B',
    'ffm3u8-第04集': 'age_22a41ZO4aAfK55bKuQbQJOYYWMEVtJztYfX8vPsoSKhfgVy%2ByVYgDNULsz%2FKojsPuLfskHjrlYBw6jVZWWNfYCLQVrvcDvi5Lx4mvOTDeKHbM4R5BdD1zWyW',
    'ffm3u8-第05集': 'age_8443Q%2BUnDCoNK9Ji%2FGZ86vE7XASMMpcqJVNuSikdbg4NtPvlsjzWsFjUm89AQWCYtm01qAwr5PwutxzSBMqJ4%2BHIGbqeCiTBNFnJUy%2BrTvDfXW2Sc2BgVTIq',
    'wjm3u8-第01集': 'age_52c1JFmy6XjebfgJfKORjFpU9X9OIXWfa2xDfmehiTSH1ihbV0SZp8R3uSQvKS1UAWAI74EF34467djTVsbU4JRghRTZUuTEgG10g8y6BEkplQjTZqFFAMHWFDWubDo',
    'xigua-第01集': 'age_c5270ran2gyC8KVZ5U36atpk%2FH4SBVNotzZKtduxTqKwom8Y7%2BBgekNm7hbdWkn%2FpuqS1M0dt5IgXY%2BS5olPTjQl',
  };

  var successCount = 0;
  var failCount = 0;

  for (var entry in testCases.entries) {
    print('\n${entry.key}:');
    print('  加密: ${_truncate(entry.value, 60)}');

    try {
      final decrypted = AgeDecryptor.decrypt(entry.value);
      print('  ✓ 解密成功: $decrypted');
      successCount++;

      // 验证URL格式
      if (decrypted.startsWith('http')) {
        print('  ✓ URL格式正确');
      } else {
        print('  ⚠ 警告: URL格式可能不正确');
      }
    } catch (e) {
      print('  ❌ 解密失败: $e');
      failCount++;
    }
  }

  print('\n${'=' * 80}');
  print('测试结果统计:');
  print('  成功: $successCount/${testCases.length}');
  print('  失败: $failCount/${testCases.length}');
  print('  成功率: ${(successCount * 100 / testCases.length).toStringAsFixed(1)}%');
  print('=' * 80);

  if (failCount > 0) {
    print('\n⚠ 部分解密失败,可能需要:');
    print('  1. 访问实际网站获取真实的解密算法');
    print('  2. 抓包分析网络请求中的真实m3u8 URL');
    print('  3. 查看浏览器开发者工具中的JavaScript代码');
  }
}

String _truncate(String s, int maxLength) {
  if (s.length <= maxLength) return s;
  return '${s.substring(0, maxLength)}...';
}
