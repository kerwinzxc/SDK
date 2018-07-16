//
//  WanPreventAddictionViewController.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/24.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanPreventAddictionViewController.h"
#import "WanPreventAddictionView.h"
#import "WanPopViewController.h"

@interface WanPreventAddictionViewController ()<WanViewActionDelegate>

@property (nonatomic, strong) WanAccountModel *accountModel;

@end

@implementation WanPreventAddictionViewController

-(instancetype)initWithModel:(WanAccountModel *)model{
    if (self = [super init]) {
        self.accountModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPreventAddictionView];
}

-(void)initPreventAddictionView{
    NSInteger i = ([NSString isEmpty:self.accountModel.phoneNo]?2:1);
    i = [WanSDKConfig shareInstance].isAdult?i+2:i;
    
    WanPreventAddictionView *view = [[WanPreventAddictionView alloc] initWithFrame:CGRectMake(0, 0, WanViewWidth*kRetio, (130+i*59)*kRetio) withModel:self.accountModel];
    view.center = self.view.center;
    view.delegate = self;
    [self.view addSubview:view];
}

#pragma mark ----WanViewActionDelegate
-(void)viewClickActionType:(ClickButtonType)type withAccountModel:(WanAccountModel *)accountModel{
    if (type == ClickButtonTypePreventAddiction) {
        [self preventAddictionWithModel:accountModel];
    }else if (type == ClickButtonTypeClose){
        [self completePreventAddition];
    }
}

-(void)preventAddictionWithModel:(WanAccountModel *)accountModel{
    WanServer *server = [[WanServer alloc] init];
    [server bindPhoneRequestWithPhoneNum:accountModel.phoneNo uid:self.accountModel.uid verify:accountModel.valicode realName:accountModel.realName idCard:accountModel.id_card  success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            [WanProgressHUD showMessage:@"绑定成功"];
            [self completePreventAddition];
        }else{
            [WanProgressHUD showMessage:[NSString stringValue:[WanUtils getResponseMsgWithDict:dict]]];
        }
        [WanProgressHUD hideAfterDelay:1.5];
    } failed:^(NSError *error) {
        [WanProgressHUD hideAfterDelay:1.5];
    }];
}

-(void)completePreventAddition{
    if ([WanSDKConfig shareInstance].isNotice && [NSString isNotEmpty:[WanSDKConfig shareInstance].popModel.content]) {
        //弹出广告弹窗
        WanPopViewController *popVC = [[WanPopViewController alloc] init];
        @WeakObj(self);
        popVC.closePopBlock = ^{
            @StrongObj(self);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginCompleteNotification" object:@{@"uid":self.accountModel.uid,@"ticket":self.accountModel.ticket, @"is_fcm":self.accountModel.isAdult}];
        };
        [self.navigationController pushViewController:popVC animated:NO];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginCompleteNotification" object:@{@"uid":self.accountModel.uid,@"ticket":self.accountModel.ticket, @"is_fcm":self.accountModel.isAdult}];
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
