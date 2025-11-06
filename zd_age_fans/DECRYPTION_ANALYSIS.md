# AgeFans M3U8 加密链接解密分析报告

## 1. 加密格式分析

### 1.1 基本结构
```
age_[4位十六进制哈希][URL编码的Base64字符串]
```

### 1.2 示例
```
age_2498GyJ%2Fsiv1oq3B7wicuGF%2FNHJTkNN3ZobtVxzW%2BMloVQgHz%2BLSnSXd13bR4Li%2FgQnhIfaNW9Mq47IEu3o0i0yny00pLqVpr02d0RrThLrwms72aiPXaQTN
```

**组成部分:**
- 前缀: `age_`
- 哈希: `2498` (4位十六进制)
- 加密数据: `GyJ%2Fsiv1oq3B...` (URL编码 + Base64)

## 2. 解密步骤

### 2.1 第一步: 解析结构
```dart
String encryptedUrl = "age_2498GyJ%2Fsiv1...";

// 1. 移除前缀
String withoutPrefix = encryptedUrl.substring(4);  // "2498GyJ%2Fsiv1..."

// 2. 提取哈希值
String hash = withoutPrefix.substring(0, 4);  // "2498"

// 3. 提取加密数据
String encrypted = withoutPrefix.substring(4);  // "GyJ%2Fsiv1..."
```

### 2.2 第二步: URL解码
```dart
String urlDecoded = Uri.decodeComponent(encrypted);
// 结果: "GyJ/siv1oq3B7wicuGF/NHJTkNN3ZobtVxzW+MloVQgHz..."
```

### 2.3 第三步: Base64解码
```dart
// 处理padding (使长度成为4的倍数)
int paddingNeeded = (4 - urlDecoded.length % 4) % 4;
String withPadding = urlDecoded + ('=' * paddingNeeded);

// Base64解码
List<int> encryptedBytes = base64.decode(withPadding);
// 结果: 87字节的二进制数据
```

## 3. 加密算法分析

### 3.1 数据特征
- **长度**: 所有ffm3u8第1-5集解密后都是87字节 (非16的倍数, 排除纯AES)
- **不同集数**: 哈希值不同,但密文长度相同
  - 第01集: hash=2498, 87 bytes
  - 第02集: hash=bdc0, 87 bytes
  - 第03集: hash=7725, 87 bytes
  - 第04集: hash=22a4, 87 bytes
  - 第05集: hash=8443, 87 bytes

### 3.2 可能的加密方案

#### 方案A: XOR加密 (最可能)
通过假设URL以 "https://" 开头,反推出可能的XOR密钥前缀:
```
0x73 0x56 0x0b 0xc2 0x58 0xcf 0x8d 0x82 ...
```

**问题**: 密钥长度未知,后续字节无法准确推导

#### 方案B: AES加密 + 自定义填充
虽然长度不是16的倍数,但可能使用了非标准填充

#### 方案C: RC4或其他流加密
流加密算法可以产生任意长度的密文

#### 方案D: 自定义算法
网站可能使用了混合算法或自定义加密

### 3.3 哈希值的作用
4位十六进制哈希值可能用于:
1. **密钥派生**: 与主密钥组合生成实际加密密钥
2. **校验**: 用于验证解密是否正确
3. **变体标识**: 标识使用的加密变体或版本
4. **随机化**: 使相同明文产生不同密文

## 4. 推荐的解密实现方案

### 方案1: 查找官方JavaScript代码
最可靠的方法是找到 AgeFans 网站的播放器 JavaScript 代码,其中必然包含解密逻辑。

**搜索关键词:**
- `age_`
- `decrypt`
- `XOR`
- `atob` (JavaScript的Base64解码)

### 方案2: 动态分析
1. 在浏览器中打开 AgeFans 网站
2. 打开开发者工具,设置断点
3. 播放视频时捕获解密后的真实 m3u8 URL
4. 对比加密和解密后的数据,反推算法

### 方案3: XOR暴力破解 (有限可行)
如果确定是XOR加密,可以:
1. 假设明文格式: `https://[domain]/[path]/[file].m3u8`
2. 尝试常见的域名模式
3. 反推完整密钥
4. 验证其他集数

## 5. 示例代码框架

```dart
/// AgeFans URL解密器
class AgeFansDecryptor {
  /// 解密加密的 m3u8 URL
  static String decrypt(String encryptedUrl) {
    // 1. 解析
    if (!encryptedUrl.startsWith('age_')) {
      throw FormatException('Invalid format');
    }

    final withoutPrefix = encryptedUrl.substring(4);
    final hash = withoutPrefix.substring(0, 4);
    final encrypted = withoutPrefix.substring(4);

    // 2. URL解码
    final urlDecoded = Uri.decodeComponent(encrypted);

    // 3. Base64解码
    final paddingNeeded = (4 - urlDecoded.length % 4) % 4;
    final withPadding = urlDecoded + ('=' * paddingNeeded);
    final encryptedBytes = base64.decode(withPadding);

    // 4. 解密 (需要找到正确的算法)
    final key = _deriveKey(hash);  // 从哈希派生密钥
    final decryptedBytes = _decrypt(encryptedBytes, key);

    // 5. 转换为字符串
    return utf8.decode(decryptedBytes);
  }

  /// 从哈希值派生密钥 (待实现)
  static List<int> _deriveKey(String hash) {
    // TODO: 实现正确的密钥派生逻辑
    throw UnimplementedError('需要找到正确的密钥派生算法');
  }

  /// 解密数据 (待实现)
  static List<int> _decrypt(List<int> data, List<int> key) {
    // TODO: 实现正确的解密算法 (XOR/AES/RC4/自定义)
    throw UnimplementedError('需要找到正确的解密算法');
  }
}
```

## 6. 下一步建议

### 6.1 立即可行
1. **检查网络请求**: 在 Chrome DevTools 中查看视频播放时的真实 m3u8 URL
2. **查找源码**: 在项目中搜索是否有遗漏的解密代码
3. **查看API文档**: `/v2/detail/` API 是否有相关参数说明

### 6.2 需要更多信息
1. **获取官方播放器代码**: 需要访问 AgeFans 网站的前端代码
2. **咨询API提供方**: 如果有API文档或技术支持
3. **社区搜索**: 查找是否有其他开发者已经实现了解密

### 6.3 备用方案
如果无法解密,可以考虑:
1. **使用代理服务**: 通过服务端解密后返回真实URL
2. **使用 WebView**: 直接使用官方网页播放器
3. **联系官方**: 申请官方 API 或 SDK

## 7. 技术栈建议

当前项目已有的依赖:
```yaml
dependencies:
  crypto: ^3.0.3  # 已安装但未使用,支持AES/MD5/SHA等
```

如果需要更多加密算法支持:
```yaml
dependencies:
  pointycastle: ^3.7.3  # 全功能加密库,支持RC4/DES等
  encrypt: ^5.0.1       # 更简单的加密API
```

## 8. 测试数据

完整测试数据见 `stream-response.txt` 文件,包含:
- ffm3u8: 5集
- wjm3u8: 5集
- xigua: 5集
- hnm3u8: 5集
- 等多个播放源

## 9. 结论

**当前状态**:
- ✅ 已理解加密格式
- ✅ 已实现URL解码和Base64解码
- ❌ 未找到正确的解密算法
- ❌ 哈希值的具体作用未明

**最关键的缺失信息**:
需要找到真实的解密算法。最可靠的方法是获取AgeFans官方播放器的JavaScript代码,或通过浏览器开发者工具动态分析。

**预估难度**:
- 如果是简单XOR: ⭐⭐ (2/5)
- 如果是标准AES: ⭐⭐⭐ (3/5)
- 如果是自定义算法: ⭐⭐⭐⭐⭐ (5/5)
