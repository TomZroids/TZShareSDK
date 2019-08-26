//
//  DXShareView.m
//  SharePanel
//
//  Created by dyy on 2018/1/18.
//  Copyright © 2018年 d. All rights reserved.
//

#import "DXShareView.h"
#import "DXShareButton.h"
#import "DXSharePlatform.h"
#import "DXShareManager.h"

static CGFloat const DXShreButtonHeight = 90.f;
static CGFloat const DXShreButtonWith = 76.f;
static CGFloat const DXShreHeightSpace = 15.f;//竖间距
static CGFloat const DXShreCancelHeight = 46.f;


//屏幕宽度与高度
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width

#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface DXShareView()<UIGestureRecognizerDelegate>

//底部view
@property (nonatomic,strong) UIView *bottomPopView;

@property (nonatomic,strong) NSMutableArray *platformArray;
@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) DXShareModel *shareModel;
@property (nonatomic,assign) DXShareContentType shareConentType;
@property (nonatomic,assign) CGFloat shreViewHeight;//分享视图的高度

@end

@implementation DXShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.platformArray = [NSMutableArray array];
        self.buttonArray = [NSMutableArray array];

        //初始化分享平台
        [self setUpPlatformsItems];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        tapGestureRecognizer.delegate = self;
        [tapGestureRecognizer addTarget:self action:@selector(closeShareView)];
        
        [self addGestureRecognizer:tapGestureRecognizer];
        
        //计算分享视图的总高度
        self.shreViewHeight = DXShreHeightSpace *(self.platformArray.count /4+1 ) + DXShreButtonHeight * (self.platformArray.count /4) + DXShreCancelHeight;
        
        int columnCount=4;
        //计算间隙
        CGFloat appMargin=(SCREEN_WIDTH-columnCount*DXShreButtonWith)/(columnCount+1);
        
        for (int i=0; i<self.platformArray.count; i++) {
            DXSharePlatform *platform = self.platformArray[i];
            //计算列号和行号
            int colX=i%columnCount;
            int rowY=i/columnCount;
            //计算坐标
            CGFloat buttonX = appMargin+colX*(DXShreButtonWith+appMargin);
            CGFloat buttonY = DXShreHeightSpace+rowY*(DXShreButtonHeight+DXShreHeightSpace);
            DXShareButton *shareBut = [[DXShareButton alloc] init];
            [shareBut setTitle:platform.name forState:UIControlStateNormal];
            [shareBut setImage:[UIImage imageNamed:platform.iconStateNormal] forState:UIControlStateNormal];
            [shareBut setImage:[UIImage imageNamed:platform.iconStateHighlighted] forState:UIControlStateHighlighted];
            shareBut.frame = CGRectMake(10, 10, 76, 90);
            [shareBut addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
            shareBut.tag = platform.sharePlatform;//这句话必须写！！！
            [self.bottomPopView addSubview:shareBut];
            shareBut.frame = CGRectMake(buttonX, buttonY, DXShreButtonWith, DXShreButtonHeight);
            [self.bottomPopView addSubview:shareBut];
            [self.buttonArray addObject:shareBut];
            
        }
        
        //按钮动画
        for (DXShareButton *button in self.buttonArray) {
            NSInteger idx = [self.buttonArray indexOfObject:button];
            
            CGAffineTransform fromTransform = CGAffineTransformMakeTranslation(0, 50);
            button.transform = fromTransform;
            button.alpha = 0.3;
            
            [UIView animateWithDuration:0.9+idx*0.1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{

                button.transform = CGAffineTransformIdentity;
                button.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
            
        }
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setFrame:CGRectMake(0, self.shreViewHeight - DXShreCancelHeight, SCREEN_WIDTH, DXShreCancelHeight)];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [cancelButton addTarget:self action:@selector(closeShareView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomPopView addSubview:cancelButton];
        
        [self addSubview:self.bottomPopView];

    }
    return self;
}



#pragma mark - 点击了分享按钮
-(void)clickShare:(UIButton *)sender
{
   switch (sender.tag) {
        case DXShareTypeWechatSession://微信好友
        {
            [[DXShareManager getinstance] wt_shareWithContent:_shareModel shareType:DXShareTypeWechatSession shareResult:^(NSString *shareResult) {
                
                UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"" message:shareResult  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [msgbox show];
                
                NSLog(@"微信好友 :%@",shareResult);
            }];
            NSLog(@"DXShareTypeWechatSession");
        }
            break;
        case DXShareTypeWechatTimeline://微信朋友圈
        {
            [[DXShareManager getinstance] wt_shareWithContent:_shareModel shareType:DXShareTypeWechatTimeline shareResult:^(NSString *shareResult) {
                
                UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"" message:shareResult  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [msgbox show];
                NSLog(@"微信朋友圈 :%@",shareResult);
            }];
            NSLog(@"DXShareTypeWechatTimeline");
       }
            break;
        case DXShareTypeQQ://QQ好友
        {
            [[DXShareManager getinstance] wt_shareWithContent:_shareModel shareType:DXShareTypeQQ shareResult:^(NSString *shareResult) {
                UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"" message:shareResult  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [msgbox show];
                NSLog(@"QQ好友:%@",shareResult);
            }];
            NSLog(@"DXShareTypeQQ");
        }
            break;
        case DXShareTypeWeibo://新浪微博
       {
           [[DXShareManager getinstance] wt_shareWithContent:_shareModel shareType:DXShareTypeWeibo shareResult:^(NSString *shareResult) {
               UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"" message:shareResult  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
               [msgbox show];
               NSLog(@"新浪微博:%@",shareResult);
           }];
            NSLog(@"DXShareTypeWeibo");
        }
            break;
       default:
            break;
    }
    [self closeShareView];
}

-(UIView *)bottomPopView
{
    if (_bottomPopView == nil) {
        _bottomPopView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, self.shreViewHeight)];
//        _bottomPopView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
        _bottomPopView.backgroundColor = [UIColor redColor];
    }
    return _bottomPopView;
}

-(void)showShareViewWithDXShareModel:(DXShareModel*)shareModel shareContentType:(DXShareContentType)shareContentType
{
    self.shareModel = shareModel;
    self.shareConentType = shareContentType;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3f animations:^{
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
         _bottomPopView.backgroundColor = [UIColor blueColor];
        self.bottomPopView.frame = CGRectMake(0, SCREENH_HEIGHT - self.shreViewHeight, SCREEN_WIDTH, self.shreViewHeight);
    }];
}

#pragma mark - 点击背景关闭视图
-(void)closeShareView
{
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.bottomPopView.frame = CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, self.shreViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma  mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.bottomPopView]) {
        return NO;
    }
    return YES;
}

#pragma mark 设置平台
-(void)setUpPlatformsItems
{
    //微信好友
    DXSharePlatform *wechatSessionModel = [[DXSharePlatform alloc] init];
    wechatSessionModel.iconStateNormal = @"weixin_allshare";
    wechatSessionModel.iconStateHighlighted = @"weixin_allshare_night";
    wechatSessionModel.sharePlatform = DXShareTypeWechatSession;
    wechatSessionModel.name = @"微信好友";
    [self.platformArray addObject:wechatSessionModel];
    
    //微信朋友圈
    DXSharePlatform *wechatTimeLineModel = [[DXSharePlatform alloc] init];
    wechatTimeLineModel.iconStateNormal = @"pyq_allshare";
    wechatTimeLineModel.iconStateHighlighted = @"pyq_allshare_night";
    wechatTimeLineModel.sharePlatform = DXShareTypeWechatTimeline;
    wechatTimeLineModel.name = @"微信朋友圈";
    [self.platformArray addObject:wechatTimeLineModel];

    
    //QQ好友
    DXSharePlatform *qqModel = [[DXSharePlatform alloc] init];
    qqModel.iconStateNormal = @"qq_allshare";
    qqModel.iconStateHighlighted = @"qq_allshare_night";
    qqModel.sharePlatform = DXShareTypeQQ;
    qqModel.name = @"QQ好友";
    [self.platformArray addObject:qqModel];
    
    //新浪微博
    DXSharePlatform *weiboModel = [[DXSharePlatform alloc] init];
    weiboModel.iconStateNormal = @"qqzone_allshare";
    weiboModel.iconStateHighlighted = @"qqzone_allshare_night";
    weiboModel.sharePlatform = DXShareTypeWeibo;
    weiboModel.name = @"新浪微博";
    [self.platformArray addObject:weiboModel];
}

@end
