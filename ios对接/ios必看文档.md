# WebView SDK 调用文档
## 一、基本调用说明
把Remote2全部导入
当其他 App 需要使用您的浏览器框架时，只需要按以下方式集成和调用：

### 1. 导入必要文件
```objective-c
#import "ViewController.h"
 ```

### 2. 调用方式 Objective-C App 调用
```objective-c
// 初始化控制器
ViewController *webViewController = [[ViewController alloc] init];

// 设置要打开的网页地址
webViewController.dic = @{
    @"url": @"https://example.com"  // 替换为实际需要打开的URL
};

// 展示网页
[self presentViewController:webViewController animated:YES completion:nil];
 ```
```
 Swift App 调用
```swift
// 初始化控制器
let webViewController = ViewController()

// 设置要打开的网页地址
webViewController.dic = [
    "url": "https://example.com"  // 替换为实际需要打开的URL
]

// 展示网页
present(webViewController, animated: true, completion: nil)
 ```
```

## 二、调用说明
1. 调用方只需要初始化 ViewController 并设置 URL 即可
2. 所有的网页功能（如 Cookie 管理、UA 设置等）都由 SDK 内部处理
3. 支持自动处理微信支付和京东支付场景
## 三、注意事项
1. URL 格式要求：
   
   - 必须是完整的 URL（包含 http:// 或 https://）
   - URL 需要进行编码处理
2. 内存管理：
   
   - SDK 会自动处理内存释放
   - 页面关闭时会自动清理相关资源
