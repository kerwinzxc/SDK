//
//  WQConstance.h
//  weiqu
//
//  Created by Star on 2017/5/9.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#ifndef WQConstance_h
#define WQConstance_h

#import "UIColor+Hex.h"
#import "UIView+Frame.h"
#import "NSString+Util.h"
#import "WanProgressHUD.h"
#import "WanUtils.h"
#import "UIAlertView+Blocks.h"
#import "WanNetManager.h"
#import "WanAccountModel.h"
#import "WanBaseViewController.h"
#import "WanBaseView.h"
#import "WanBaseModel.h"
#import "WanServer.h"
#import "WanSDKConfig.h"
#import "WanTextField.h"
#import "WanLabel.h"
#import "WanButton.h"

typedef void(^LoginCompleteBlock)(WanAccountModel *accountModel, NSDictionary *responsData);

#pragma mark ---------------颜色------------------
//按钮背景颜色(蓝色)
#define WanButtonBgColor [UIColor colorWithHexString:@"00a0e9"]
//按钮title颜色(蓝色)
#define WanButtonTitleColor [UIColor colorWithHexString:@"00a0e9"]
//字体颜色(纯白色)
#define WanWhiteColor [UIColor colorWithHexString:@"ffffff"]
//字体颜色(蓝色)
#define WanTextBuleColor [UIColor colorWithHexString:@"01b0cd"]
//分割线条颜色
#define WanLineColor [UIColor colorWithHexString:@"3c373b"]
//支付弹窗分割线条颜色
#define WanPayLineColor [UIColor colorWithHexString:@"f1f3f7"]
//支付弹窗标题颜色
#define WanPayBgColor [UIColor colorWithHexString:@"f1f3f7"]
//支付弹窗标题颜色
#define WanPayTitleColor [UIColor colorWithHexString:@"3399ff"]
//支付弹窗支付方式详细描述
#define WanPayDescColor [UIColor colorWithHexString:@"989fa5"]

#pragma mark ---------------间隔距离------------------
//关闭按钮上右间隔
#define WanCloseBtnMargin 8
//上下两个输入框之间间隔
#define WanTextFieldMargin 10
//输入框距离左右之间间隔
#define WanTextFieldLeftMargin 20
//支付弹窗左右侧margin
#define WanPayLeftMargin 15

#pragma mark ---------------view宽与高------------------
//输入框高度
#define WanTextFieldHeight 44.0
//title高度
#define WanTitleLabelHeight 50.0
//分割线高度
#define WanLineLabelHeight 1.0
//弹窗view的宽度
#define WanViewWidth 305.0
//关闭按钮的宽高
#define WanCloseBtnWidth 14.0

#ifdef DEBUG
#define NSLog(fmt,...) NSLog((@"51Wan日志信息:%s[Line %d]" fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__);
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

//#ifdef DEBUG
//#define NSLog(...) NSLog(@"51wansySDK日志信息：",__VA_ARGS__)
//#define debugMethod() NSLog(@"%s", __func__)
//#else
//#define NSLog(...)
//#define debugMethod()
//#endif

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define kRetio (([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight)?([UIScreen mainScreen].bounds.size.height/375.0):([UIScreen mainScreen].bounds.size.width/375.0))

#define UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)

#define WAN_ORIENTATION ([[UIApplication sharedApplication] statusBarOrientation])

#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#define WAN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define WAN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#endif /* WQConstance_h */
