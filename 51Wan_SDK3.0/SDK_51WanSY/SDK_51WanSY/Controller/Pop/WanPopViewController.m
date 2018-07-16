//
//  WanPopViewController.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/25.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanPopViewController.h"
#import "WanPopView.h"

@interface WanPopViewController ()<WanViewActionDelegate>

@end

@implementation WanPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPopView];
}

-(void)initPopView{
    WanPopView *popView;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ((orientation == UIDeviceOrientationLandscapeRight) ||  (orientation == UIDeviceOrientationLandscapeLeft)) {
        popView = [[WanPopView alloc] initWithFrame:CGRectMake(0, 0, 425*kRetio, WanViewWidth*kRetio)];
    }else{
        popView = [[WanPopView alloc] initWithFrame:CGRectMake(0, 0, WanViewWidth*kRetio, 435*kRetio)];
    }
    popView.center = self.view.center;
    popView.delegate = self;
    [self.view addSubview:popView];
}

#pragma mark -----WanViewActionDelegate
-(void)viewClickActionType:(ClickButtonType)type withAccountModel:(WanAccountModel *)accountModel{
    if (self.closePopBlock) {
        self.closePopBlock();
    }
}

@end
