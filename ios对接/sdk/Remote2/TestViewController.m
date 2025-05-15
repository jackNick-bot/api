#import "TestViewController.h"
#import "ViewController.h"

@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *input;
@property (weak, nonatomic) IBOutlet UITextView *logTxt;


@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.logTxt.text =@"3232";
    
}
- (IBAction)dopay:(id)sender {
    NSLog(@"do pay ,,,,,,,");

    NSString* inTxt = @"https://baidu.com?params=28YByhMJXxNgjhZ2eOv0z3UItNKjFxXcZCVRjqad8DRwhBUrnAHlwY+JXxeq+MEnQHKz2jfILdEzAcnKtYIphkkxJEj3jlBWgeXTdKwJP4UHXUANBZX4dTjsD87qTcoBx1yfCjVormIXHIplPetlMJhsfiAjUvktirbibjht3wzEazjwJ99di17Nh6mvKae5004Nsb84xrn+N3m5n5p8kqFADvthBEgoP1xiD+mWGuLyDdGdeSkJWh/i9IzsR0LUrlgSAW0CbGx6lgo1KID1KpHXBg0p40jnZ5ZqXFhXONV/Owbf8i8JYBCn1ZXEpbcRbt1Ed0I6bfVWe83aBlproqXhXIpEYVCPwcpJy71kKkGqmucOPOu0QeS/ohNxJqgTUR2FnVU/0Gm54Gv1f1OVerwC93CATNJMF3y/1MDZM0ahTGbDkoCN+ziDUCwjectH";
    NSLog(@"%lu",(unsigned long)self.input.text.length);
    
    if(self.input.text.length>0){
        inTxt = self.input.text;
    }
    
    ViewController *jdPayVC = [[ViewController alloc] init];
        jdPayVC.dic  = @{
            @"url":[NSString  stringWithFormat:@"%@",inTxt]
        };
    jdPayVC.logTxt = self.logTxt;
    
        // 使用导航控制器进行跳转
    [self presentViewController:jdPayVC animated:YES completion:nil];
}



- (NSString *)urlEncode2:(NSString *)string {
        NSMutableString *result = [NSMutableString string];
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSMutableCharacterSet *mutableSet = [set mutableCopy];
        [mutableSet removeCharactersInString:@"!'\"();:@&=+$,/?%#[]% "];
        for (NSUInteger i = 0; i < [string length]; i++) {
            unichar character = [string characterAtIndex:i];
            NSString *charString = [NSString stringWithCharacters:&character length:1];
            if ([charString isEqualToString:@" "]) {
                [result appendString:@"+"];
            } else {
                NSString *encodedChar = [charString stringByAddingPercentEncodingWithAllowedCharacters:mutableSet];
                [result appendString:(encodedChar ? encodedChar : charString)];
            }
        }
        return result;
}

@end
