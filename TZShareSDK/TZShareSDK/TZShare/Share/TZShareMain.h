//
//  TZShareMain.h
//  
//
//  Created by TomZRoid on 2017/4/7.
//
//

#import <UIKit/UIKit.h>
#import "TZShareSDKHelper.h"
#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "TZShareData.h"

typedef NS_ENUM(NSInteger , TZShareType) {
    TZShareTypeWechatSession    = 0,               //微信好友
    TZShareTypeWechatTimeline   = 1,               //微信朋友圈
    TZShareTypeQQ               = 2,               //QQ好友
    TZShareTypeWeibo            = 3,               //新浪微博
};

@interface TZShareMain :NSObject
<QQApiInterfaceDelegate,WXApiDelegate>
@property (nonatomic, weak) id<TZShareResultDelegate> shareDelegate;
@property (nonatomic, retain)TencentOAuth *tencentOAuth;
@property int currentType;
+ (instancetype)sharedInstance;
/**
 支付
 */
- (void)share:(TZShareModel *)shareModel:(id)delegate;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;


@end
