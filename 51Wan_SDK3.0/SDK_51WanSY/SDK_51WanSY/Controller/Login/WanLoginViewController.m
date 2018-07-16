  //
//  WanLoginViewController.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/22.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanLoginViewController.h"
#import "NSString+Util.h"
#import "WanLoginView.h"
#import "WanServer.h"
#import "WanQuickRegestViewController.h"
#import "WanRegestViewController.h"
#import "WanModdifyPasswordViewController.h"
#import "WanPreventAddictionViewController.h"
#import "WanPopViewController.h"

@interface WanLoginViewController () <WanViewActionDelegate>

@property (nonatomic, strong) WanServer *loginViewServer;

@end

@implementation WanLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLoginUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginComplete:) name:@"loginCompleteNotification" object:nil];
}

-(void)initLoginUI{
    WanLoginView *loginView = [[WanLoginView alloc] initWithFrame:CGRectMake(0, 0, WanViewWidth*kRetio, 330*kRetio)];
    loginView.center = self.view.center;
    loginView.delegate = self;
    [self.view addSubview:loginView];
}

#pragma mark ----<WanLoginViewActionDelegate>
-(void)viewClickActionType:(ClickButtonType)type withAccountModel:(WanAccountModel *)accountModel{
    //登录
    if (type == ClickButtonTypeLogin) {
        [self loginWithModel:accountModel];
    }
    //跳转到注册
    else if (type == ClickButtonTypeGotoRegest){
        [self gotoRegestWithModel:accountModel];
    }
    //跳转到修改密码
    else if (type == ClickButtonTypeGotoModdifyPassword){
        [self goToModdifyPasswordWithModel:accountModel];
    }
    //一键注册
    else if (type == ClickButtonTypeQuickRegest){
        [self quickRegestWithModel:accountModel];
    }
    //关闭窗口
    else if (type == ClickButtonTypeClose){
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark ----登录
-(void)loginWithModel:(WanAccountModel *)model{
    @WeakObj(self);
    [WanProgressHUD showLoading:@"登录..."];
    [self.loginViewServer loginRequestWithUserName:model.account passWord:model.password validType:@"1" loginType:@"1" gameid:self.gameid success:^(NSDictionary *dict, BOOL success) {
        NSString *msg = [WanUtils getResponseMsgWithDict:dict];
        NSString *code = [WanUtils getResponseCodeWithDict:dict];
        @StrongObj(self);
        if ([@"105" isEqualToString:code]) {
            [WanProgressHUD hide];
            [UIAlertView showForgetPasswordWithTitle:@"" message:@"用户名或者密码不正确" handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [alertView removeFromSuperview];
                }else{
                    [self goToModdifyPasswordWithModel:model];
                }
            }];
        }else{
            [WanProgressHUD showInfoMsg:msg];
        }
        
        if (success) {
            [WanProgressHUD showInfoMsg:msg];
            [self loginSuccessWith:self.loginViewServer.accountModel  responseData:dict];
        }
        [WanProgressHUD hideAfterDelay:1.5];
    } failed:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark ----注册
-(void)gotoRegestWithModel:(WanAccountModel *)model{
    WanRegestViewController *regestVc = [[WanRegestViewController alloc] init];
    regestVc.gameid = self.gameid;
    @WeakObj(self);
    regestVc.loginCompleteBlock = ^(WanAccountModel *accountModel, NSDictionary *responsData) {
        @StrongObj(self);
        [self loginSuccessWith:accountModel  responseData:responsData];
    };
    [self.navigationController pushViewController:regestVc animated:NO];
}

#pragma mark ----快速注册
-(void)quickRegestWithModel:(WanAccountModel *)model{
    @WeakObj(self);
    [WanProgressHUD showLoading:@"快速注册..."];
    [self.loginViewServer quickRegestWithType:@"1" channelid:[WanUtils channelID] gameid:self.gameid success:^(NSDictionary *dict, BOOL success) {
        @StrongObj(self);
        NSString *info = [NSString stringValue:[WanUtils getResponseMsgWithDict:dict]];
        [WanProgressHUD showInfoMsg:info];
        if (success) {
            WanAccountModel *model = [[WanAccountModel alloc] init];
            model.account = [WanUtils getResponseKey:@"name" intDataDict:dict];
            model.password = [WanUtils getResponseKey:@"password" intDataDict:dict];
            WanQuickRegestViewController *quickRegestVC = [[WanQuickRegestViewController alloc] init];
            quickRegestVC.model = model;
            quickRegestVC.loginClickBlock = ^(WanAccountModel *accountModel) {
                [self loginWithModel:accountModel];
            };
            [self.navigationController pushViewController:quickRegestVC animated:NO];
        }else{
            [WanProgressHUD showFailure:@"一键注册失败，请重试！"];
        }
        [WanProgressHUD hideAfterDelay:1.5];
    } failed:^(NSError *error) {
        [WanProgressHUD hideAfterDelay:1.5];
    }];
}

#pragma mark ----修改账号密码
-(void)goToModdifyPasswordWithModel:(WanAccountModel *)model{
    WanModdifyPasswordViewController *moddifyVC = [[WanModdifyPasswordViewController alloc] init];
    moddifyVC.gameid = self.gameid;
    [self.navigationController pushViewController:moddifyVC animated:NO];
}

#pragma mark --setter 
-(WanServer *)loginViewServer{
    if (_loginViewServer == nil) {
        _loginViewServer = [[WanServer alloc] init];
    }
    return _loginViewServer;
}

-(void)loginSuccessWith:(WanAccountModel *)accountModel responseData:(NSDictionary *)dict{
    //登录成功保存账号密码
    [WanUtils saveAccount:accountModel.account password:accountModel.password];
    //当1.未绑定手机 2.开启防沉迷而用户未绑定身份证 的时候弹出
    if (accountModel != nil && (accountModel.isShowPhoneView || ([WanSDKConfig shareInstance].isAdult && [NSString isEmpty:accountModel.realName] && [NSString isEmpty:accountModel.id_card])))
    {
        //跳转至绑定手机页面
        WanPreventAddictionViewController *preventAdditionVC = [[WanPreventAddictionViewController alloc] initWithModel:accountModel];
        [self.navigationController pushViewController:preventAdditionVC animated:NO];
    }else if([WanSDKConfig shareInstance].isNotice == YES && [NSString isNotEmpty:[WanSDKConfig shareInstance].popModel.content]) {
        //显示弹窗
        WanPopViewController *popVc = [[WanPopViewController alloc] init];
        @WeakObj(self);
        popVc.closePopBlock = ^{
            @StrongObj(self);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginCompleteNotification" object:@{@"uid":self.loginViewServer.accountModel.uid,@"ticket":self.loginViewServer.accountModel.ticket,@"is_fcm":self.loginViewServer.accountModel.isAdult}];
        };
        [self.navigationController pushViewController:popVc animated:NO];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginCompleteNotification" object:@{@"uid":accountModel.uid,@"ticket":accountModel.ticket, @"is_fcm":accountModel.isAdult}];
    }
}

-(void)loginComplete:(NSNotification *)notify{
    //登录成功回调
    if (self.delegate && [_delegate respondsToSelector:@selector(wanSDKReturnResult:forType:)]) {
        [_delegate wanSDKReturnResult:notify.object forType:WanSDKReturnResultTypeLogin];
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
