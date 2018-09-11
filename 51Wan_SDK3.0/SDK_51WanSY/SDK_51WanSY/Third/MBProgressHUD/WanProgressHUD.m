//
//  LMBProgressHUD.m
//  LMBang
//
//  Created by rao on 15/11/20.
//  Copyright © 2015年 辣妈帮. All rights reserved.
//

// 背景视图的宽度/高度
#define BGVIEW_WIDTH 100.0f
// 文字大小
#define TEXT_SIZE    16.0f

#define delaySecond 1.5f

#import "WanProgressHUD.h"

@implementation WanProgressHUD

+ (instancetype)sharedHUD {
    
    static WanProgressHUD *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow == nil?[UIApplication sharedApplication].delegate.window:[UIApplication sharedApplication].keyWindow;
        hud = [[WanProgressHUD alloc] initWithWindow:window];
    });
    return hud;
}

+ (void)showStatus:(LMBProgressHUDStatus)status text:(NSString *)text {
    
    WanProgressHUD *hud = [WanProgressHUD sharedHUD];
    [hud show:YES];
    [hud setDetailsLabelText:text];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setDetailsLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    [hud setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    
    switch (status) {
            
        case LMBProgressHUDStatusSuccess: {
            
            UIImage *sucImage = [UIImage imageNamed:@"hud_success"];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            hud.customView = sucView;
            [hud hide:YES afterDelay:delaySecond];
        }
            break;
            
        case LMBProgressHUDStatusError: {
            
            UIImage *errImage = [UIImage imageNamed:@"hud_error"];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
            hud.customView = errView;
            [hud hide:YES afterDelay:delaySecond];
        }
            break;
            
        case LMBProgressHUDStatusWaitting: {
            
            hud.mode = MBProgressHUDModeIndeterminate;
        }
            break;
            
        case LMBProgressHUDStatusInfo: {
            
            UIImage *infoImage = [UIImage imageNamed:@"hud_info"];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            hud.customView = infoView;
            [hud hide:YES afterDelay:delaySecond];
        }
            break;
            
        default:
            break;
    }
}

+ (void)showMessage:(NSString *)text {
    
    WanProgressHUD *hud = [WanProgressHUD sharedHUD];
    [hud show:YES];
    [hud setDetailsLabelText:text];
    [hud setMinSize:CGSizeZero];
    [hud setMode:MBProgressHUDModeText];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud hide:YES afterDelay:delaySecond];
}

+ (void)showInfoMsg:(NSString *)text {
    
    [self showStatus:LMBProgressHUDStatusInfo text:text];
}

+ (void)showFailure:(NSString *)text {
    
    [self showStatus:LMBProgressHUDStatusError text:text];
}

+ (void)showSuccess:(NSString *)text {
    
    [self showStatus:LMBProgressHUDStatusSuccess text:text];
}

+ (void)showLoading:(NSString *)text {
    
    [self showStatus:LMBProgressHUDStatusWaitting text:text];
}

+ (void)hide {
    [[WanProgressHUD sharedHUD] hide:YES];
}

+ (void)hideAfterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

@end
