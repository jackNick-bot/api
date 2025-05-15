
#import <WebKit/WebKit.h>
#import "weakWebViewScriptMessageDelegate.h"
#import "ViewController.h"
#import "WKWebView+YCCookie.h"
//#import "JDPayViewController.h"

@interface ViewController ()<WKScriptMessageHandler , WKUIDelegate , WKNavigationDelegate,YCWkWebViewCookieDelegate>

@property (nonatomic, strong) WKWebView *  webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self print2Log:@"view did load ..."];
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    
    config.preferences = preference;
    
    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    if (@available(iOS 10.0, *)) {
        config.mediaTypesRequiringUserActionForPlayback = YES;
    } else {
        // Fallback on earlier versions
    }
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback = YES;
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    config.applicationNameForUserAgent = @"ChinaDailyForiPad";
    
    //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
    weakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[weakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
    
    //这个类主要用来做native与JavaScript的交互管理
    WKUserContentController * wkUController = [[WKUserContentController alloc] init];
    //    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //    [configuration.userContentController addScriptMessageHandler:self name:@"app_util"];
    ////
    //注册一个name为jsToOcNoPrams的js方法 设置处理接收JS方法的对象
    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"request"];
    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"setCookie"];
    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"removeAllCookie"];
    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"setUserAgent"];
    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"loadUrl"];
    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"getUserAgent"];
    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"getScreenResolution"];
    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"logging"];

    
    
    config.userContentController = wkUController;
  
    //以下代码适配文本大小
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

    //用于进行JavaScript注入
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:wkUScript];
    
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width ,self.view.frame.size.height-65) configuration:config];
    // UI代理
    _webView.UIDelegate = self;
    _webView.cookieDelegate = self;
    [_webView setupCustomCookie];
    //_webView.inspectable = YES;
        // 导航代理
    _webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = NO;
    //可返回的页面列表, 存储已打开过的网页index
    WKBackForwardList * backForwardList = [self.webView backForwardList];
    
    
    if (YES) {
        NSString * url =@"http://www.";
        NSLog(@"dic is %@",self.dic);
        if (self.dic!=nil) {
            url = self.dic[@"url"];
        }else{
  
        }
        NSLog(@"%@",url);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:request];
        
    }else{
        NSString*  url = @"https://wwww";
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    }
    if (@available(iOS 11.0,*)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
    }
    _webView.scrollView.bounces=NO;
    [self.view addSubview:_webView];
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(40, 40, 100, 100)];
    btn.backgroundColor =[UIColor redColor];
    [btn addTarget:self action:@selector(clervvvv:) forControlEvents:UIControlEventTouchDown];
}

-(void)clervvvv:(UIButton *)s
{
    ViewController *jdPayVC = [[ViewController alloc] init];
    
        jdPayVC.dic  = @{
            @"url":@"https://baidu.com"
        };
    
        // 使用导航控制器进行跳转
    [self presentViewController:jdPayVC animated:YES completion:nil];
    
    
}



- (void) topay:(NSDictionary*)dic {
    
    NSLog(@"do to pay ");

}


#pragma mark--js交互
//被自定义的WKScriptMessageHandler在回调方法里通过代理回调回来，绕了一圈就是为了解决内存不释放的问题
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
//    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    //用message.body获得JS传出的参数体
    
    //JS调用OC
    if([message.name isEqualToString:@"request"]){
        NSLog(@"request----%@",message.body);
        [self print2Log:[NSString stringWithFormat:@"request----%@",message.body]];
         
        
        NSDictionary *bodyDict = message.body;
        NSString *url = bodyDict[@"url"];
        NSString *method = bodyDict[@"method"];
        NSString *data = bodyDict[@"data"];
        NSDictionary *headers = bodyDict[@"headers"];
        NSURL *requestURL = [NSURL URLWithString:url];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestURL];
        NSLog(@"Received request from JavaScript: %@", bodyDict);
        urlRequest.HTTPMethod = method;
        if (headers) {
            for (NSString *key in headers) {
                [urlRequest setValue:headers[key] forHTTPHeaderField:key];
            }
        }
        if (data) {
            urlRequest.HTTPBody = [data dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Request error: %@", error);
                [self print2Log:[NSString stringWithFormat:@"Request error: %@", error]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSData *data = [@ "{\"code\": 10032}" dataUsingEncoding:NSUTF8StringEncoding]; // 要编码的数据
                    NSString*  responseString = [data base64EncodedStringWithOptions:0]; // 使用新方法进行 Base64 编码
                    NSLog(@"Base64 Encoded String: %@", responseString);
                    NSString *jsCallback = [NSString stringWithFormat:@"window.jsback(\"%@\")", responseString];
                    [self.webView evaluateJavaScript:jsCallback completionHandler:nil];
                });
                
            } else {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"Response from request: %@", responseString);
                [self print2Log:[NSString stringWithFormat:@"Response from request: %@", responseString]];
                if (true) {
                    NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding]; // 要编码的数据
                    responseString = [data base64EncodedStringWithOptions:0]; // 使用新方法进行 Base64 编码
                    NSLog(@"Base64 Encoded String: %@", responseString);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *jsCallback = [NSString stringWithFormat:@"window.jsback(\"%@\")", responseString];
                    [self.webView evaluateJavaScript:jsCallback completionHandler:nil];
                });
                
            }
        }];
        [task resume];
        return;
    }
    
    if([message.name isEqualToString:@"logging"]){
        NSLog(@"logging----%@",message.body);
    }
    
    
    if([message.name isEqualToString:@"removeAllCookie"]) {
        NSLog(@"removeAllCookie----%@", message.body);
        
        // 获取 WKWebView 的 HTTP cookie 存储
        WKHTTPCookieStore *cookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
        
        // 获取所有 cookies
        [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> *cookies) {
            // 遍历并删除每一个 cookie
            for (NSHTTPCookie *cookie in cookies) {
                [cookieStore deleteCookie:cookie completionHandler:^{
                    NSLog(@"Deleted cookie: %@", cookie.name);
                }];
            }
            
            // 也可以直接清除所有网站数据（包括 cookies）
            NSSet *websiteDataTypes = [NSSet setWithObject:WKWebsiteDataTypeCookies];
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                                       modifiedSince:dateFrom
                                                   completionHandler:^{
                NSLog(@"All cookies cleared");
            }];
        }];
    }
    if([message.name isEqualToString:@"loadUrl"]){
        NSLog(@"loadUrl----%@",message.body);
        
        [self print2Log:[NSString stringWithFormat:@"loadUrl----%@",message.body]];
        
        NSDictionary *bodyDict = message.body;
        NSString *url = bodyDict[@"url"];
        NSString *cookie = bodyDict[@"cookie"];
        
        NSArray *cookieArray = [cookie componentsSeparatedByString:@";"];
        for (NSString *cookieStr in cookieArray) {
            NSArray *pair = [cookieStr componentsSeparatedByString:@"="];
             
            if ([pair count] >= 2 ) {
                NSString *key = [pair[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSString *value = [pair[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [_webView addCookieWithKey:key value:value];
            }
        }
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:request];
    }
    if ([message.name isEqualToString:@"getUserAgent"]) {
        NSLog(@"setUserAgent----%@", message.body);
        [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if (!error) {
                NSString *userAgent = result;
                NSLog(@"当前 UserAgent: %@", userAgent);
                NSString *js = [NSString stringWithFormat:@"window.receiveUserAgent('%@')", userAgent];
                [self.webView evaluateJavaScript:js completionHandler:nil];
            } else {
                NSLog(@"获取 UserAgent 失败: %@", error);
            }
        }];
    }
     if ([message.name isEqualToString:@"getScreenResolution"]) {
        NSLog(@"收到获取屏幕分辨率请求");
        NSString *resolution = [ViewController getScreenResolution];
        NSString *js = [NSString stringWithFormat:@"window.receiveScreenResolution('%@')", resolution];
        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if (error) {
                NSLog(@"回调分辨率失败: %@", error);
            }
        }];
    }
    
    if([message.name isEqualToString:@"loadUrl"]){
        NSLog(@"loadUrl----%@",message.body);
        
        [self print2Log:[NSString stringWithFormat:@"loadUrl----%@",message.body]];
        
        NSDictionary *bodyDict = message.body;
        NSString *url = bodyDict[@"url"];
        NSString *cookie = bodyDict[@"cookie"];
        
        NSArray *cookieArray = [cookie componentsSeparatedByString:@";"];
        for (NSString *cookieStr in cookieArray) {
            NSArray *pair = [cookieStr componentsSeparatedByString:@"="];
             
            if ([pair count] >= 2 ) {
                NSString *key = [pair[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSString *value = [pair[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [_webView addCookieWithKey:key value:value];
            }
        }
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:request];
    }
    
    
}


+ (NSString *)getScreenResolution {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGFloat screenWidth = screenBounds.size.width * screenScale;
    CGFloat screenHeight = screenBounds.size.height * screenScale;
    
    return [NSString stringWithFormat:@"%.0fx%.0f", screenWidth, screenHeight];
}

-(void)print2Log:(NSString*)log{
//    self.logTxt
    if(self.logTxt!=nil){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.logTxt.text = [NSString stringWithFormat:@"   %@%@",self.logTxt.text,log];
        });
        
    }
  
}


#pragma mark - YCWkWebViewCookieDelegate
- (NSDictionary *)webviewCookies {
    
    NSDictionary * dic = @{
        @"ck":@"pt_key=;pt_pin="
    };
    return nil;
}

- (void)dealloc{
    //移除注册的js方法
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"request"];
    [[_webView configuration].userContentController
        removeScriptMessageHandlerForName:@"removeAllCookie"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"setUserAgent"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"loadUrl"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"setCookie"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"setUserAgent"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"getScreenResolution"];
   
}





#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSString *currentURL = webView.URL.absoluteString;
    NSLog(@"开始加载页面 - URL: %@", currentURL);
    [self print2Log:[NSString stringWithFormat:@"开始加载页面: %@", currentURL]];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"页面加载失败: %@", error);
    [self print2Log:[NSString stringWithFormat:@"页面加载失败: %@", error.localizedDescription]];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"页面加载失败(Provisional): %@", error);
    [self print2Log:[NSString stringWithFormat:@"页面加载失败(Provisional): %@", error.localizedDescription]];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *currentURL = webView.URL.absoluteString;
    NSLog(@"页面加载完成回调被触发 - URL: %@", currentURL);
    [self print2Log:[NSString stringWithFormat:@"页面加载完成: %@", currentURL]];
    
    if ([currentURL containsString:@"https://mpay.m.jd.com/mpay."]) {
        NSLog(@"检测到京东支付页面，准备检查CSS文件");
        __block NSInteger checkCount = 0;
        __block NSTimer *cssCheckTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
            checkCount++;
            NSString *checkCssCode = @"(function() { var found = false; document.querySelectorAll('link[rel=\"stylesheet\"]').forEach(function(link) { if (link.href.includes('/css/mpay/NutPopup.9911329e637c36c7d815.css')) { found = true; } }); return found; })()";
            
            [webView evaluateJavaScript:checkCssCode completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                if (!error && [result boolValue]) {
                    NSLog(@"检测到目标CSS文件，准备注入JS代码");
                    [cssCheckTimer invalidate];
                    cssCheckTimer = nil;
                    // 确保DOM完全加载
                    NSString *jsCode = @"function injectPaymentLogic(){console.log('开始注入支付逻辑');try{const elementsToHide=['.jdPayWrap','div[data-v-4e8a79e1]','.otherPayOutWrap','.cutdownTimeWrap','.telChargeWrap','.netWorkErrBtnWrap'];elementsToHide.forEach(selector=>{const elements=document.querySelectorAll(selector);elements.forEach(el=>{el.style.display='none';console.log('已隐藏元素:',selector)})});function hideWxDialog(){const wxDialogWrapper=document.querySelector('.nut-dialog-wrapper');if(wxDialogWrapper){wxDialogWrapper.style.display='none';console.log('已隐藏微信支付确认弹窗')}}setTimeout(()=>{const cardTexts=document.querySelectorAll('.cardText');let wechatPay=null;for(const cardText of cardTexts){if(cardText.textContent.includes('微信支付')){wechatPay=cardText.closest('.cardPayWrap');break}}if(wechatPay){wechatPay.click();console.log('已自动选择微信支付');hideWxDialog();const checkInterval=setInterval(()=>{hideWxDialog()},300);setTimeout(()=>{clearInterval(checkInterval);console.log('停止监控弹窗')},10000)}else{console.log('未找到微信支付选项')}},1000)}catch(error){console.error('注入支付逻辑时发生错误:',error)}}if(document.readyState==='complete'){injectPaymentLogic()}else{document.addEventListener('DOMContentLoaded',injectPaymentLogic)};";
                    
                    [webView evaluateJavaScript:jsCode completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                        if (error) {
                            NSLog(@"JavaScript注入失败: %@", error);
                            [self print2Log:[NSString stringWithFormat:@"JavaScript注入失败: %@", error.localizedDescription]];
                        } else {
                            NSLog(@"JavaScript注入成功");
                            [self print2Log:@"JavaScript注入成功"];
                        }
                    }];
                } else {
                    NSLog(@"第%ld次检测：未检测到目标CSS文件，继续检测...", (long)checkCount);
                    [self print2Log:[NSString stringWithFormat:@"第%ld次检测：未检测到目标CSS文件，继续检测...", (long)checkCount]];
                    if (checkCount >= 30) { // 设置最大检测次数为30次
                        NSLog(@"达到最大检测次数，停止检测");
                        [self print2Log:@"达到最大检测次数，停止检测"];
                        [cssCheckTimer invalidate];
                        cssCheckTimer = nil;
                    }
                }
            }];
        }];
    } else {
        NSLog(@"当前页面不是京东支付页面，URL: %@", currentURL);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {

    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    // 拦截的url字符串
    NSString *urlString = navigationAction.request.URL.absoluteString;
    urlString = [urlString stringByRemovingPercentEncoding];
    NSURL *url = [NSURL URLWithString:urlString]; // 将字符串转换为 NSURL 对象
    if([urlString containsString:@"weixin://wap/pay?"]) {
        actionPolicy = WKNavigationActionPolicyCancel; // 不允许webView加载

        // 判断是否安装微信
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"未检测到微信客户端，请安装后重试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:sureAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            
            decisionHandler(actionPolicy);
            return;
        }
        if (@available(iOS 10.0, *)) { // 10.0以上的版本
            if([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:nil];
            }
        } else { // 10.0以下的版本
      
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:)]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    
    if([urlString containsString:@"https://mpay.m.jd.com/mpay."]) {
        NSLog(@"实际加载的URL: %@", urlString);
    }
          
    
    
    decisionHandler(actionPolicy);
}



@end
