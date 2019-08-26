//
//  TZShareMain.m
//  
//
//  Created by TomZRoid on 2017/4/7.
//  
//

#import "TZShareMain.h"


@implementation TZShareMain

+ (instancetype)sharedInstance
{
    static TZShareMain *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"wx share:%@",[TZShareData instance].wxappid);
        
        [WXApi registerApp:[TZShareData instance].wxappid];
        
        NSLog(@"qq share:%@",[TZShareData instance].qqappid);
        
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:[TZShareData instance].qqappid
                                            andDelegate:self];
    }
    return self;
}


- (void)share:(TZShareModel *)shareModel:(id)delegate{
    _currentType = shareModel.sharetype;
    self.shareDelegate = delegate;
    NSLog(@"shareType--- %d",_currentType);
    switch (_currentType) {
        case TZShareTypeWechatSession:
            [self wxShare:true:shareModel];
            break;
        case TZShareTypeWechatTimeline:
            [self wxShare:false:shareModel];
            break;
        case TZShareTypeQQ:
            [self qqShare:shareModel];
            break;
        case TZShareTypeWeibo:
            
            break;
            
        default:
            break;
    }
}

-(void) wxShare:(bool)isfriend:(TZShareModel *)shareModel{
    
    WXMediaMessage * message = [WXMediaMessage message];
    message.title = shareModel.title;
    NSData *thumData = UIImageJPEGRepresentation(shareModel.thumbImage, 0.25);
    
    [message setThumbImage:[UIImage imageWithData:thumData]];
    message.description = shareModel.descr;
    WXWebpageObject * ext = [WXWebpageObject object];
    ext.webpageUrl = shareModel.url;
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene =isfriend? WXSceneSession:WXSceneTimeline;
    [WXApi sendReq:req];
}

-(void) qqShare:(TZShareModel *)shareModel{
    
    QQApiNewsObject * newsObj ;
    NSData *thumData = UIImageJPEGRepresentation(shareModel.thumbImage, 0.25);
    newsObj   = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareModel.url] title:shareModel.title description:shareModel.descr previewImageData:thumData];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}


- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    
    NSLog(@"strMsg: %d",sendResult);
    
}

//分享回调
-(void) onResp:(id)resp
{
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        SendMessageToWXResp * tmpResp = (SendMessageToWXResp *)resp;
        // 判断errCode 进行回调处理
        if (tmpResp.errCode == WXSuccess)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                id<TZShareResultDelegate> delegate = self.shareDelegate;
                if(delegate && [delegate respondsToSelector:@selector(onShareResponse::)]){
                    [delegate onShareResponse:@"0" :@"success"];
                }
            }) ;
            NSLog(@"微信分享成功");
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                id<TZShareResultDelegate> delegate = self.shareDelegate;
                if(delegate && [delegate respondsToSelector:@selector(onShareResponse::)]){
                    [delegate onShareResponse:@"1" :tmpResp.errStr];
                }
            }) ;
             NSLog(@"微信分享失败");
        }
    }
    
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        SendMessageToQQResp * tmpResp = (SendMessageToQQResp *)resp;
        NSLog(@"strMsg: %d",tmpResp.type);
        if (tmpResp.type == ESHOWMESSAGEFROMQQRESPTYPE &&[tmpResp.result integerValue]==0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                id<TZShareResultDelegate> delegate = self.shareDelegate;
                if(delegate && [delegate respondsToSelector:@selector(onShareResponse::)]){
                    [delegate onShareResponse:@"0" :@"success"];
                }
            }) ;
            NSLog(@"qq分享成功");
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                id<TZShareResultDelegate> delegate = self.shareDelegate;
                if(delegate && [delegate respondsToSelector:@selector(onShareResponse::)]){
                    [delegate onShareResponse:@"1" :tmpResp.errorDescription];
                }
            }) ;
           NSLog(@"qq分享失败");
        }
    }
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if(_currentType == TZShareTypeWechatTimeline || _currentType == TZShareTypeWechatSession)
    {
        return [WXApi handleOpenURL:url delegate:self];
        
    } else  if (_currentType == TZShareTypeQQ) {
        [TencentOAuth HandleOpenURL:url];
    }
    return true;
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
   
    if(_currentType == TZShareTypeWechatTimeline || _currentType == TZShareTypeWechatSession)
    {
        return [WXApi handleOpenURL:url delegate:self];
        
    } else  if (_currentType == TZShareTypeQQ) {
        [TencentOAuth HandleOpenURL:url];
    }
    return true;
}


@end
