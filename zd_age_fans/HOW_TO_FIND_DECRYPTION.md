# 如何找到 AgeFans 的真实解密算法

## 问题说明

当前我们已经分析了加密格式 (`age_[哈希][Base64数据]`),但使用常见的加密算法(RC4, XOR等)无法成功解密。这意味着AgeFans使用了自定义的加密算法。

## 方法一: 浏览器开发者工具分析 (推荐)

### 步骤1: 打开播放页面并启动开发者工具

1. 在Chrome浏览器中打开: https://www.agedm.io/play/20250193/1/1
2. 按 `F12` 打开开发者工具
3. 切换到 **Sources** (源代码) 标签

### 步骤2: 搜索解密相关代码

在 Sources 面板按 `Ctrl+Shift+F` (Mac: `Cmd+Option+F`) 打开全局搜索,搜索以下关键词:

```javascript
age_
decrypt
decode
atob
fromCharCode
String.fromCharCode
btoa
```

### 步骤3: 设置断点

找到处理 `age_` 前缀的代码后:

1. 在关键行设置断点 (点击行号)
2. 刷新页面或点击播放按钮
3. 当执行到断点时,查看变量值和执行流程

### 步骤4: 提取解密算法

关注以下几种常见模式:

#### 模式A: 简单字符串操作
```javascript
function decrypt(str) {
    var hash = str.substring(4, 8);
    var encrypted = str.substring(8);
    var decoded = atob(decodeURIComponent(encrypted));
    // 关键: 这里的变换逻辑
    return someTransform(decoded, hash);
}
```

#### 模式B: 使用第三方库
```javascript
function decrypt(str) {
    // 可能使用 CryptoJS 或其他库
    var result = CryptoJS.AES.decrypt(data, key);
    return result.toString(CryptoJS.enc.Utf8);
}
```

#### 模式C: 自定义算法
```javascript
function decrypt(str) {
    // 查找类似这样的循环操作
    for (var i = 0; i < data.length; i++) {
        result[i] = data[i] ^ key[i % key.length];
        // 或其他位操作
    }
}
```

## 方法二: 网络抓包 (最直接)

### 使用Chrome DevTools Network面板

1. 打开 https://www.agedm.io/play/20250193/1/1
2. 打开开发者工具,切换到 **Network** 标签
3. 勾选 **Preserve log** (保留日志)
4. 在筛选框输入: `m3u8`
5. 点击播放视频
6. 查找真实的 `.m3u8` 文件请求

**你会看到:**
```
Request URL: https://example.cdn.com/path/to/video.m3u8
Request Method: GET
Status Code: 200
```

这个URL就是解密后的真实地址!

### 对比分析

对比加密前后的URL:
- **加密**: `age_2498GyJ%2Fsiv1oq3B7wicuGF%2FNHJTk...`
- **解密**: `https://v.gsuus.com/20250193/1/index.m3u8`

通过对比多个样本,可以反推加密算法。

## 方法三: 使用浏览器控制台直接调用

### 步骤1: 找到解密函数

在 Console 标签中输入:

```javascript
// 查看全局变量
Object.keys(window).filter(k => k.toLowerCase().includes('decrypt'))

// 或查找包含 age_ 处理的函数
Object.keys(window).filter(k => typeof window[k] === 'function')
```

### 步骤2: 测试解密

```javascript
// 假设找到了解密函数叫 decryptUrl
var encrypted = "age_2498GyJ%2Fsiv1oq3B7wicuGF%2FNHJTkNN3ZobtVxzW...";
var decrypted = decryptUrl(encrypted);  // 或者 window.decrypt(encrypted)
console.log(decrypted);
```

### 步骤3: 查看函数实现

```javascript
// 打印函数源代码
console.log(decryptUrl.toString());
```

这会显示完整的JavaScript实现!

## 方法四: 使用Fiddler/Charles抓包

### 配置步骤

1. 安装 Fiddler (Windows) 或 Charles (Mac/Linux)
2. 配置HTTPS解密
3. 在浏览器中播放视频
4. 在抓包工具中搜索 `.m3u8`

### 查找关键请求

筛选条件:
- Host contains: `cdn`, `video`, `stream`, `m3u8`
- Response type: `application/vnd.apple.mpegurl` 或 `video/mp2t`

## 方法五: 逆向工程 (高级)

如果JavaScript代码被混淆,可以:

1. **美化代码**: 使用在线工具如 https://beautifier.io/
2. **反混淆**: 使用工具如 https://deobfuscate.io/
3. **手动分析**: 跟踪变量流转,理解算法逻辑

## 示例: 典型的视频网站解密模式

### 示例1: 简单XOR + Base64
```javascript
function decrypt(encryptedUrl) {
    // 移除前缀
    var data = encryptedUrl.substring(4);
    var hash = data.substring(0, 4);
    var encrypted = data.substring(4);

    // URL解码 + Base64解码
    var decoded = atob(decodeURIComponent(encrypted));

    // XOR解密
    var key = "SECRET_KEY";
    var result = "";
    for (var i = 0; i < decoded.length; i++) {
        result += String.fromCharCode(
            decoded.charCodeAt(i) ^ key.charCodeAt(i % key.length)
        );
    }

    return result;
}
```

### 示例2: 哈希派生密钥
```javascript
function decrypt(encryptedUrl) {
    var hash = encryptedUrl.substring(4, 8);
    var encrypted = encryptedUrl.substring(8);

    // 从哈希生成密钥
    var hashInt = parseInt(hash, 16);
    var key = [
        (hashInt >> 8) & 0xFF,
        hashInt & 0xFF
    ];

    var decoded = atob(decodeURIComponent(encrypted));
    var bytes = [];
    for (var i = 0; i < decoded.length; i++) {
        bytes.push(decoded.charCodeAt(i) ^ key[i % key.length]);
    }

    return String.fromCharCode.apply(null, bytes);
}
```

### 示例3: 使用CryptoJS
```javascript
function decrypt(encryptedUrl) {
    var data = encryptedUrl.substring(4);
    var hash = data.substring(0, 4);
    var encrypted = data.substring(4);

    var key = CryptoJS.enc.Utf8.parse(hash);
    var decrypted = CryptoJS.AES.decrypt(
        decodeURIComponent(encrypted),
        key,
        {
            mode: CryptoJS.mode.ECB,
            padding: CryptoJS.pad.Pkcs7
        }
    );

    return decrypted.toString(CryptoJS.enc.Utf8);
}
```

## 实施建议

### 最快的方法 (5分钟)
1. 打开播放页面
2. F12 → Network → 筛选 m3u8
3. 播放视频,复制真实URL
4. 对比加密URL分析规律

### 最完整的方法 (30分钟)
1. 打开播放页面
2. F12 → Sources → 全局搜索 "age_"
3. 找到解密函数,设置断点
4. 单步调试,理解算法
5. 用Dart重新实现

## 转换为Dart代码

找到JavaScript解密算法后,按以下模板转换:

```dart
import 'dart:convert';
import 'dart:typed_data';

class AgeFansDecryptor {
  static String decrypt(String encryptedUrl) {
    // 1. 解析结构
    final hash = encryptedUrl.substring(4, 8);
    final encrypted = encryptedUrl.substring(8);

    // 2. URL解码 + Base64解码
    final urlDecoded = Uri.decodeComponent(encrypted);
    final base64Decoded = base64.decode(urlDecoded);

    // 3. 应用从JavaScript找到的解密算法
    // TODO: 在这里实现从浏览器找到的算法

    return '解密后的URL';
  }
}
```

## 测试验证

获得真实URL后,验证方法:

```bash
# 使用curl测试m3u8链接是否有效
curl -I "https://example.com/video.m3u8"

# 应该返回 200 OK
HTTP/1.1 200 OK
Content-Type: application/vnd.apple.mpegurl
```

## 注意事项

1. **URL时效性**: m3u8链接可能有时效限制
2. **防盗链**: 可能需要特定的Referer或Token
3. **域名变化**: CDN域名可能经常更换
4. **加密更新**: 网站可能定期更新加密算法

## 需要帮助?

如果按照以上步骤仍无法找到算法,可以:

1. 截图浏览器Network面板的m3u8请求
2. 截图Sources面板中疑似解密的代码
3. 提供完整的加密URL样本
4. 说明遇到的具体问题

我可以帮助分析具体的实现细节。
