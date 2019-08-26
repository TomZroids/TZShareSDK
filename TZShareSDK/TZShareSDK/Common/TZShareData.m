//
//  TZShareData
//
//  Created by TomZRoid on 2017/12/31.
//

#import "TZShareData.h" 

@implementation TZShareData

static TZShareData* _instance;
+(instancetype) instance{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _instance = [[TZShareData alloc] init];
    });
    return _instance;
}

- (id)init
{
    _wxappid = [self getInfolistString:@"wxAppid"];
    _qqappid = [self getInfolistString:@"qqAppid"];
    return self;
}

//获取plist中的参数
-(NSString*) getInfolistString:(NSString*)key{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *appid = [dict objectForKey: [[NSString alloc] initWithUTF8String:[key UTF8String]]];
    return appid;
}


@end





