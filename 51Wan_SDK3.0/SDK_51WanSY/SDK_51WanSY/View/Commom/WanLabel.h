//
//  WanLabel.h
//  SDK_51WanSY
//
//  Created by Star on 2018/2/1.
//  Copyright © 2018年 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WanLabel : UILabel

/*
 * 登录等弹窗的标题Label
 **/
-(instancetype)initTitleLabelWithFrame:(CGRect)frame title:(NSString *)title;

/*
 * 登录等弹窗的标题分割线Label
 **/
-(instancetype)initLineWithFrame:(CGRect)frame;

/*
 * 支付弹窗的标题Label
 **/
-(instancetype)initPayTitleLabelWithFrame:(CGRect)frame title:(NSString *)title;

@end
