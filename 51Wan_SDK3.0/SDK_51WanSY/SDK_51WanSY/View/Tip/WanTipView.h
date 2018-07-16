//
//  WanTipWebView.h
//  WanAppStroeSDK
//
//  Created by Star on 2017/5/26.
//  Copyright © 2017年 liuluox ing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WanTipView : UIView

//显示服务窗点击图标
-(void)showTipWithGameid:(NSString *)gameid uid:(NSString *)uid;
//隐藏服务窗点击图标
-(void)hidenTip;

@end
