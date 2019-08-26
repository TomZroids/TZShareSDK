//
//  TZShareSDKHelper.h
//
//  Created by TomZRoid on 19/6/30.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TZShareModel : NSObject
@property (nonatomic,copy) NSString *title; //分享标题
@property (nonatomic,copy) NSString *descr; //描述内容
@property (nonatomic,strong) id thumbImage; //缩略图
@property (nonatomic,copy) NSString *url;  //链接
@property (nonatomic) int sharetype; //分享方式 0微信好友 1朋友圈2qq
@end

/*分享结果回调
 *code：“0”：成功 “1”：失败
 * msg：失败原因
 */
@protocol TZShareResultDelegate <NSObject>
@required
-(void) onShareResponse : (NSString*) code: (NSString*) msg;
@end


@interface TZShareSDKHelper : NSObject
+(TZShareSDKHelper*) Instance;
/*第三方跳转接口*/
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;

-(void)share:(TZShareModel *)shareModel:(id) shareResultListener;


@end
