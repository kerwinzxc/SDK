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

#pragma mark ---WanViewActionDelegate
-(void)viewClickActionType:(ClickButtonType)type withAccountModel:(WanAccountModel *)accountModel{
    if (type == ClickButtonTypeLogin) {
        if (self.loginClickBlock) {
            self.loginClickBlock(self.model);
        }
    }
}

-(void)setModel:(WanAccountModel *)model{
    if (model && ![NSString isEmpty:model.account] && ![NSString isEmpty:model.password]) {
        _model = model;
        _quickRegestView.model = model;
    }
}

@end
