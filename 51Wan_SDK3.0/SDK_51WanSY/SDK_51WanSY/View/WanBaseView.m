//
//  WanBaseView.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/23.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanBaseView.h"

@implementation WanBaseView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.65].CGColor;
        self.layer.cornerRadius = 4.0f;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.65];
    }
    return self;
}

@end
