//
//  PPUIUtils.m
//  PregnanceParter
//
//  Created by Kzzang's iMac on 14/11/29.
//  Copyright (c) 2014年 WZH Tech. All rights reserved.
//

#import "PPUIUtils.h"
#import "MBProgressHUD.h"
#define kTagForProgress             78776

@implementation PPUIUtils

#pragma mark -About Button and barbutton

+ (UIButton *) imageButtonWithNormalImageName:(NSString *) normalImageName
                           HighlightImageName:(NSString *) highlightImageName
                                       Target:(id)target
                                     selector:(SEL) selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage    = [UIImage imageNamed:normalImageName];
    UIImage *highLightImage = [UIImage imageNamed:highlightImageName];
    btn.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    if(highLightImage)[btn setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
    if(target)[btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - UIImageView

+ (UIImageView *) userIconRoundMask:(CGRect) userIconRect withImageName:(NSString *) imageName{
    
    UIImageView *userIconMask = [[UIImageView alloc] initWithFrame:userIconRect];
    userIconMask.image = [UIImage imageNamed:imageName];
    return userIconMask;
}

#pragma mark - Animation

+ (void) fadeAnimationWithView:(UIView *) animationView {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.33f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = @"fade";
    transition.subtype = kCATransitionFromRight;
    [animationView.layer addAnimation:transition forKey:nil];
}


#pragma mark - Progress
+ (void)showMessage:(NSString *)message inView:(UIView *)view hiddenAfterDelay:(NSTimeInterval)delay {
    if (!view) {
        return;
    }
    
    MBProgressHUD *progressHUD = (MBProgressHUD *)[view viewWithTag:kTagForProgress];
    if (!progressHUD) {
        progressHUD = [[MBProgressHUD alloc] initWithView:view];
        
        progressHUD.mode = MBProgressHUDModeText;
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.minShowTime = 1.5f;
        progressHUD.labelColor = [UIColor whiteColor];
        progressHUD.labelFont = [UIFont systemFontOfSize:15];
        progressHUD.margin = 15.0f;
        progressHUD.color = [UIColor blackColor];
        progressHUD.removeFromSuperViewOnHide = YES;
        progressHUD.tag = kTagForProgress;
        [view addSubview:progressHUD];
    }
    
    if (message && [message isKindOfClass:[NSString class]]) {
        progressHUD.labelText = message;
    }
    
    [progressHUD show:YES];
    [progressHUD hide:YES afterDelay:delay];
}
+ (void)hideProgressHUD:(BOOL)animated inView:(UIView *) view{
    MBProgressHUD *progressHUD = (MBProgressHUD *)[view viewWithTag:kTagForProgress];
    [progressHUD hide:animated];
}

+ (void)showStateInWindow:(NSString *)string
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    
    
    MBProgressHUD  * hud = [[MBProgressHUD alloc] init];
    hud.frame = CGRectMake(60, [UIScreen mainScreen].bounds.size.height-100, 200, 30);
    hud.mode = MBProgressHUDModeText;
    hud.labelText = string;
    hud.animationType = MBProgressHUDAnimationZoom;                   //  初始化并显示 加载 效果
    
    [window addSubview:hud];
    [hud show:NO];
    [hud hide:NO afterDelay:1.5];
}

@end
