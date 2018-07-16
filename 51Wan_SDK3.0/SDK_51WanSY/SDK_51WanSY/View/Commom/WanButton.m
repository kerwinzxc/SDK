//
//  WanButton.m
//  SDK_51WanSY
//
//  Created by Star on 2018/2/1.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanButton.h"

@implementation WanButton

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action titleFoneSize:(CGFloat)fontsize titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor{
    if (self == [super initWithFrame:frame]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        [self setBackgroundColor:bgColor];
        self.layer.cornerRadius = 4.0;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:fontsize];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image imgSize:(CGSize)imgsize target:(id)target action:(SEL)action titleFoneSize:(CGFloat)fontsize titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor{
    if (self = [super initWithFrame:frame]) {
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        [self setBackgroundColor:bgColor];
        self.titleLabel.font = [UIFont systemFontOfSize:fontsize];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return self;
}

-(instancetype)initCloseBtnWithFrame:(CGRect)frame target:(id)target action:(SEL)action{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundImage:[WanUtils imageInBundelWithName:@"close_btn"] forState:UIControlStateNormal];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@end
