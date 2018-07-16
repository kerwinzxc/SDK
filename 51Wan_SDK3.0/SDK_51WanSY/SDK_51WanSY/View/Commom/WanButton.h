//
//  WanButton.h
//  SDK_51WanSY
//
//  Created by Star on 2018/2/1.
//  Copyright © 2018年 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WanButton : UIButton

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action titleFoneSize:(CGFloat)fontsize titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor;

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image imgSize:(CGSize)imgsize target:(id)target action:(SEL)action titleFoneSize:(CGFloat)fontsize titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor;

-(instancetype)initCloseBtnWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

@end
