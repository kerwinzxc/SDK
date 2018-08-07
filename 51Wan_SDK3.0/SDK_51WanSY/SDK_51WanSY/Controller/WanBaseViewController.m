//
//  WanBaseViewController.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/22.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanBaseViewController.h"
#import "WanTipWebViewController.h"
#import "WanTipPorWebViewController.h"

@interface WanBaseViewController ()

@end

@implementation WanBaseViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)addGestureRecognizer{
    if (![self isKindOfClass:[WanTipWebViewController class]] && ![self isKindOfClass:[WanTipPorWebViewController class]]) {
        //点击退出编辑手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.view addGestureRecognizer:tap];
    }
}

#pragma mark self action
-(void)tap:(UIButton *)btn{
    
    [self.view endEditing:YES];
}

@end
