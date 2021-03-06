//
//  WanLabel.m
//  SDK_51WanSY
//
//  Created by Star on 2018/2/1.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanLabel.h"

@implementation WanLabel

-(instancetype)initTitleLabelWithFrame:(CGRect)frame title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentLeft;
        self.text = title;
        self.font = [UIFont systemFontOfSize:15];
        self.textColor = WanWhiteColor;
    }
    return self;
}

-(instancetype)initLineWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WanLineColor;
    }
    return self;
}

-(instancetype)initPayLineWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WanPayLineColor;
    }
    return self;
}

-(instancetype)initPayTitleLabelWithFrame:(CGRect)frame title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WanPayBgColor;
        self.textAlignment = NSTextAlignmentCenter;
        self.text = title;
        self.font = [UIFont boldSystemFontOfSize:18];
        self.textColor = WanPayTitleColor;
    }
    return self;
}

@end
