//
//  WanQuickRegestViewController.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/23.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanQuickRegestViewController.h"
#import "WanQuickRegestView.h"

@interface WanQuickRegestViewController ()<WanViewActionDelegate>
{
    WanQuickRegestView *_quickRegestView;
}
@end

@implementation WanQuickRegestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initQuickRegestUI];
}

-(void)initQuickRegestUI{
    _quickRegestView = [[WanQuickRegestView alloc] initWithFrame:CGRectMake(0, 0, WanViewWidth*kRetio, 360*kRetio)];
    _quickRegestView.center = self.view.center;
    _quickRegestView.delegate = self;
    [self.view addSubview:_quickRegestView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.model && ![NSString isEmpty:self.model.account] && ![NSString isEmpty:self.model.password]) {
        _quickRegestView.model = self.model;
    }
}

#pragma mark ---WanViewActionDelegate
-(void)viewClickActionType:(ClickButtonType)type withAccountModel:(WanAccountModel *)accountModel{
    if (type == ClickButtonTypeLogin) {
        if (self.loginClickBlock) {
            self.loginClickBlock(self.model);
        }
    }
}


@end
