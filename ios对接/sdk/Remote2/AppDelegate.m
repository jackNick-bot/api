#import "AppDelegate.h"
#import "TestViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    TestViewController *customViewController = [[TestViewController alloc] init]; // 实例化你的自定义视图控制器
    self.window.rootViewController = customViewController; // 将自定义视图控制器设置为根视图控制器
    [self.window makeKeyAndVisible];
    return YES;
}


@end
