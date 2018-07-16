//
//  WanModdifyPasswordViewController.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/23.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanModdifyPasswordViewController.h"
#import "WanModdifyPasswordView.h"
#import "WanLoginViewController.h"
#import "WanServer.h"

@interface WanModdifyPasswordViewController ()<WanViewActionDelegate>
{
    WanModdifyPasswordView *_moddifyView;
}
@end

@implementation WanModdifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initModdifyPasswordView];
}

-(void)initModdifyPasswordView{
    _moddifyView = [[WanModdifyPasswordView alloc] initWithFrame:CGRectMake(100, 0, WanViewWidth*kRetio, 330*kRetio)];
    _moddifyView.center = self.view.center;
    _moddifyView.delegate = self;
    [self.view addSubview:_moddifyView];
}

-(void)setModel:(WanAccountModel *)model{
    if (model && ![NSString isEmpty:model.account]) {
        _model = model;
        _moddifyView.model = model;
    }
}

#pragma mark ---WanViewActionDelegate
-(void)viewClickActionType:(ClickButtonType)type withAccountModel:(WanAccountModel *)accountModel{
    if (type == ClickButtonTypeGotoLogin) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if (type == ClickButtonTypeModdifyPassword){
        [self moddifyPasswordWithModel:accountModel];
    }
}

-(void)moddifyPasswordWithModel:(WanAccountModel *)accountModel{
    @WeakObj(self);
    [WanProgressHUD showLoading:@"修改密码..."];
    WanServer *server = [[WanServer alloc] init];
    [server moddifyRequestWithUserName:accountModel.account passWord:accountModel.password validCode:accountModel.valicode gameid:self.gameid success:^(NSDictionary *dict, BOOL success) {
        @StrongObj(self);
        if (success) {
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            NSString *info = [NSString stringValue:[WanUtils getResponseMsgWithDict:dict]];
            [WanProgressHUD showFailure:info];
        }
        [WanProgressHUD hideAfterDelay:1.0];
    } failed:^(NSError *error) {
        [WanProgressHUD hide];
    }];
}

@end
