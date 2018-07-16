//
//  WanRegestViewController.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/23.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanRegestViewController.h"
#import "WanRegistView.h"
#import "WanLoginViewController.h"
#import "WanServer.h"

@interface WanRegestViewController ()<WanViewActionDelegate>

@end

@implementation WanRegestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRegestView];
}

-(void)initRegestView{
    WanRegistView *regestView = [[WanRegistView alloc] initWithFrame:CGRectMake(100, 0, WanViewWidth*kRetio, 300*kRetio)];
    regestView.center = self.view.center;
    regestView.delegate = self;
    [self.view addSubview:regestView];
}

#pragma mark ---WanViewActionDelegate
-(void)viewClickActionType:(ClickButtonType)type withAccountModel:(WanAccountModel *)accountModel{
    if (type == ClickButtonTypeRegest) {
        [self regestWithModel:accountModel];
    }
    else if (type == ClickButtonTypeGotoLogin){
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void)regestWithModel:(WanAccountModel *)model{
    WanServer *server = [[WanServer alloc] init];
    [WanProgressHUD showLoading:@"开始注册..."];
    @WeakObj(self);
    [server registRequestWithUserName:model.account passWord:model.password registType:@"1" channelid:[WanUtils channelID] gameid:self.gameid success:^(NSDictionary *dict, BOOL success) {
        @StrongObj(self);
        NSString *info = [NSString stringValue:[WanUtils getResponseMsgWithDict:dict]];
        [WanProgressHUD showInfoMsg:info];
        if (success) {
            if (self.loginCompleteBlock) {
                self.loginCompleteBlock(server.accountModel, dict);
            }
        }
        [WanProgressHUD hideAfterDelay:1.5];
    } failed:^(NSError *error) {
        [WanProgressHUD hideAfterDelay:1.5];
    }];
}

@end
