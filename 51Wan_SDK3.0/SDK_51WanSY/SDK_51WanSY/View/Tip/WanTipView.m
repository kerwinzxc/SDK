//
//  WanTipWebView.m
//  WanAppStroeSDK
//
//  Created by Star on 2017/5/26.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import "WanTipView.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
#import "WanTipWebViewController.h"
#import "WanTipPorWebViewController.h"

#define autoHidenTime 6.0
#define hidenScale 0.5

@interface WanTipView(){
    NSTimer *_timer;
}

@property (nonatomic, strong) UIImageView *tipImgView;
@property (nonatomic, assign) NSInteger halfHidenTime;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *gameid;

@end

@implementation WanTipView

-(instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTipImgView) name:@"Wan_HidenTipWebviewNotificaton" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(motionShake) name:@"Wan_MotionShakeNotificaton" object:nil];
    }
    return self;
}

#pragma mark --getter selector
-(UIImageView *)tipImgView{
    if (_tipImgView == nil) {
        _tipImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, WAN_SCREEN_HEIGHT/4.0, 50, 50)];
        _tipImgView.image = [WanUtils imageInBundelWithName:@"tip_image"];
        _tipImgView.userInteractionEnabled = YES;
        _tipImgView.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [_tipImgView addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_tipImgView addGestureRecognizer:tap];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_tipImgView];
    }
    return _tipImgView;
}

#pragma mark myslef action
//点击显示服务窗
-(void)tap:(UITapGestureRecognizer *)tap{
    //当tipView半隐藏状态时，不让点击显示悬浮窗,但是让其出现
    if (self.tipImgView.frame.origin.x<0 || CGRectGetMaxX(self.tipImgView.frame)> WAN_SCREEN_WIDTH) {
        if (self.tipImgView.frame.origin.x<0) {
            self.tipImgView.left = 0;
        }else{
            self.tipImgView.right = WAN_SCREEN_WIDTH;
        }
        self.tipImgView.image = [WanUtils imageInBundelWithName:@"tip_image"];
        return;
    }
    
    //显示左侧工具栏
    if (WAN_SCREEN_WIDTH > WAN_SCREEN_HEIGHT) {
        WanTipWebViewController *tipWebVC = [[WanTipWebViewController alloc] init];
        tipWebVC.gameid = self.gameid;
        tipWebVC.uid = self.uid;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:tipWebVC animated:NO completion:nil];
    }else{
        WanTipPorWebViewController *tipProWebVC = [[WanTipPorWebViewController alloc] init];
        tipProWebVC.gameid = self.gameid;
        tipProWebVC.uid = self.uid;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:tipProWebVC animated:NO completion:nil];
    }
    
    _halfHidenTime = autoHidenTime;
    self.tipImgView.image = [WanUtils imageInBundelWithName:@"tip_image"];
    [self.tipImgView setHidden:YES];
}

//tip视图移动手势
-(void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint panPoint = [pan locationInView:[UIApplication sharedApplication].keyWindow];
    CGPoint tipPoint = panPoint;
    if (panPoint.x < _tipImgView.frame.size.width/2.0) {
        tipPoint.x = _tipImgView.frame.size.width/2.0;
    }
    if (panPoint.x > WAN_SCREEN_WIDTH - _tipImgView.frame.size.width/2.0) {
        tipPoint.x = WAN_SCREEN_WIDTH - _tipImgView.frame.size.width/2.0;
    }
    if (panPoint.y < _tipImgView.frame.size.width/2.0) {
        tipPoint.y = _tipImgView.frame.size.width/2.0;
    }
    if (panPoint.y > WAN_SCREEN_HEIGHT - _tipImgView.frame.size.width/2.0) {
        tipPoint.y = WAN_SCREEN_HEIGHT - _tipImgView.frame.size.width/2.0;
    }
    _tipImgView.center = tipPoint;
    
    //停止之后靠边停靠
    CGPoint endPoint = _tipImgView.center;
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (_tipImgView.center.x < WAN_SCREEN_WIDTH/2.0) {
            endPoint.x = _tipImgView.frame.size.width/2.0;
        }else{
            endPoint.x = WAN_SCREEN_WIDTH - _tipImgView.frame.size.width/2.0;
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _tipImgView.center = endPoint;
    }];
    
    _halfHidenTime = autoHidenTime;
    self.tipImgView.image = [WanUtils imageInBundelWithName:@"tip_image"];
}

#pragma mark
-(void)showTipWithGameid:(NSString *)gameid uid:(NSString *)uid{
    self.gameid = gameid;
    self.uid = uid;

    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [[self activityViewController] becomeFirstResponder];
    
    [self resolveInstanceMethod];
    
    [self.tipImgView setHidden:NO];
    _halfHidenTime = autoHidenTime;
    self.tipImgView.image = [WanUtils imageInBundelWithName:@"tip_image"];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(halfHiden) userInfo:nil repeats:YES];
    [_timer fire];
}

- (BOOL)resolveInstanceMethod{
    class_addMethod([[self activityViewController] class], @selector(motionBegan:withEvent:), class_getMethodImplementation([self class], @selector(motionBegan:withEvent:)), "v@:");
    class_addMethod([[self activityViewController] class], @selector(motionCancelled:withEvent:), class_getMethodImplementation([self class], @selector(motionCancelled:withEvent:)), "v@:");
    class_addMethod([[self activityViewController] class], @selector(motionEnded:withEvent:), class_getMethodImplementation([self class], @selector(motionEnded:withEvent:)), "v@:");
    return YES;
}

//半隐藏悬浮窗
-(void)halfHiden{
    _halfHidenTime--;
    if (_halfHidenTime == 0) {
        [UIView animateWithDuration:1 animations:^{
            if (self.tipImgView.frame.origin.x <= 0) {
                self.tipImgView.frame = CGRectMake(-self.tipImgView.frame.size.width*(1-hidenScale), self.tipImgView.frame.origin.y, self.tipImgView.frame.size.width, self.tipImgView.frame.size.height);
            }else{
                self.tipImgView.frame = CGRectMake(self.tipImgView.frame.origin.x+self.tipImgView.frame.size.width*hidenScale, self.tipImgView.frame.origin.y, self.tipImgView.frame.size.width, self.tipImgView.frame.size.height);
            }
        } completion:^(BOOL finished) {
            if (_tipImgView) {
                self.tipImgView.image = [WanUtils imageByApplyingAlpha:0.5 image:[WanUtils imageInBundelWithName:@"tip_image"]];
            }
        }];
    }
}

-(void)hidenTip{
    [self.tipImgView removeFromSuperview];
    _tipImgView = nil;

    if (_timer) {
        [_timer invalidate];
    }
}

// 获取当前处于activity状态的view controller
- (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}

//接收通知方法
-(void)showTipImgView{
    [self.tipImgView setHidden:NO];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark---摇一摇方法
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    return;
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
    return;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Wan_MotionShakeNotificaton" object:nil];
    }
    return;
}

-(void)motionShake{
    if(self.tipImgView.left < 0 || self.tipImgView.right > WAN_SCREEN_WIDTH){
        self.tipImgView.hidden = !self.tipImgView.hidden;
    }
}

@end
