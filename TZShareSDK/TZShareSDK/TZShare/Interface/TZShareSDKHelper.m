//
//  TZShareSDKHelper.m
//  TZShareSDKHelper
//
//  Created by TomZRoid on 19/6/30.
// 
//


#import "TZShareSDKHelper.h"
#import "TZShareMain.h"

@implementation TZShareSDKHelper

+(TZShareSDKHelper*) Instance
{
    static TZShareSDKHelper* sTZShareSDKHelper = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sTZShareSDKHelper = [[[self class] alloc] init];
    });
    return sTZShareSDKHelper;
}


-(void) share: (TZShareModel*)shareModel:(id) shareResultListener{
    [[TZShareMain sharedInstance] share:shareModel:shareResultListener];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
     return [[TZShareMain sharedInstance]application:application openURL:url sourceApplication:sourceApplication annotation:application];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [[TZShareMain sharedInstance] application:application handleOpenURL:url];
}


@end
