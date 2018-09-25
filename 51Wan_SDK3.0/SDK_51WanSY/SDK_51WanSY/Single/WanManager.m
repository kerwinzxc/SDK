//
//  WanManager.m
//  WanAppStroeSDK
//
//  Created by Star on 2017/5/17.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import "WanManager.h"
#import "WanLoginViewController.h"
#import "WanPayViewController.h"
#import "WanTipView.h"
#import "WanServer.h"
#import "WanInAppPurchaes.h"

@interface WanManager()

@property (nonatomic, weak) id<WanManagerDelegate> wanDelegate;
@property (nonatomic, copy) NSString *gameID;

@property (nonatomic, strong) WanTipView *tipView;
@property (nonatomic, strong) WanServer *server;

@end

@implementation WanManager

//单例对象
+(instancetype)shareInstance{
    static WanManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[WanManager alloc] init];
    });
    return _manager;
}

-(void)initSDKWithGameID:(NSString *)gameid delegate:(id<WanManagerDelegate>)wanDelegate{
    if ([NSString isEmpty:gameid]) {
        NSLog(@"gameid不能为空！");
    }
    self.wanDelegate = wanDelegate;
    self.gameID = gameid;
    [WanProgressHUD showLoading:@"正在初始化SDK,请稍等..."];
    [self.server getSDKConfigWithGameID:self.gameID RequesSuccess:^(NSDictionary *dict, BOOL success) {
        [[WanSDKConfig shareInstance] initWithDict:dict];
        NSLog(@"SDK初始化完成：%@",dict);
        if (self.wanDelegate && [_wanDelegate respondsToSelector:@selector(wanSDKReturnResult:forType:)]) {
            [WanProgressHUD showSuccess:@"初始化完成"];
            [self.wanDelegate wanSDKReturnResult:dict forType:WanSDKReturnResultTypeSDKConfig];
        }
    } failed:^(NSError *error) {
        [WanProgressHUD showFailure:@"获取配置信息失败，请重新进入"];
        NSLog(@"初始化失败：%@",error);
    }];
}

-(void)showLoginView{
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    rootVc.definesPresentationContext = YES;
    
    WanLoginViewController *loginVc = [[WanLoginViewController alloc] init];
    loginVc.gameid = self.gameID;
    loginVc.delegate = self.wanDelegate;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
    rootVc.definesPresentationContext = YES;
    UIColor *color = [UIColor blackColor];
    nav.view.backgroundColor = [color colorWithAlphaComponent:0.0];
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [rootVc presentViewController:nav animated:NO completion:nil];
}

/**
 * 支付窗口
 * @view  支付窗口所在父视图
 * @payModel 支付model
 */
-(void)payWithPayModel:(WanPayModel *)payModel{
    if ([WanUtils isAppStore] && [WanSDKConfig shareInstance].isIAP) {
        [self IAPPayWithModel:payModel];
    }else{
        [self payWithModel:payModel];
    }
}

/**
 * 显示服务窗点击图标
 * @pragram gameid 游戏ID
 * @pragram uid 用户id(此ID为登录后获取的uid)
 */
-(void)showTipWithUid:(NSString *)uid{
    [self.tipView showTipWithGameid:self.gameID uid:uid];
}

/**
 *隐藏服务窗点击图标
 */
-(void)hidenTip{
    [self.tipView hidenTip];
}

/**
 * 上传游戏数据
 *  @uid 用户id，注意：这个ID为SDK登录后获取的UID
 *  @gameid 游戏ID
 *  @server_id 区服ID
 *  @serverName 区服名
 *  @roleName 角色名
 *  @roleLevel 角色等级
 *  @faildBlock 上传失败后回调
 */
-(void)uploadUid:(NSString *)uid serverID:(NSString *)server_id serverName:(NSString *)serverName roleName:(NSString *)roleName roleLevel:(NSString *)roleLevel{
    [self.server uploadUID:uid gameID:self.gameID serverID:server_id serverName:serverName roleName:roleName roleLevel:roleLevel RequesSuccess:^(NSDictionary *dict, BOOL success) {
        if (self.wanDelegate &&[_wanDelegate respondsToSelector:@selector(wanSDKReturnResult:forType:)]) {
            [_wanDelegate wanSDKReturnResult:@{@"code":[WanUtils getResponseCodeWithDict:dict], @"msg":[WanUtils getResponseMsgWithDict:dict]} forType:WanSDKReturnResultTypeSubmitInfo];
        }
    } failed:^(NSError *error) {
        NSLog(@"上传角色信息error:%@", error);
    }];
}

#pragma mark ---pay module
-(void)IAPPayWithModel:(WanPayModel *)payModel{
    [WanInAppPurchaes instance].payModel = payModel;
    [[WanInAppPurchaes instance] buyProduction:payModel.productID];
}

-(void)payWithModel:(WanPayModel *)payModel{
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    rootVc.definesPresentationContext = YES;
    
    WanPayViewController *payVc = [[WanPayViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVc];
    rootVc.definesPresentationContext = YES;
    UIColor *color = [UIColor blackColor];
    nav.view.backgroundColor = [color colorWithAlphaComponent:0.0];
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [rootVc presentViewController:nav animated:NO completion:nil];
//    NSString *urlStr = [NSString stringWithFormat:@"%@?uid=%@&cp_data=%@&desc=%@&gain=%@&goods_name=%@&money=%.0f&payment_type=5&role_name=%@&game_id=%@&server_id=%@", payURL, payModel.uid, payModel.cpData, payModel.desc, payModel.gain, payModel.goodsName, [payModel.money doubleValue]*100, payModel.roleName, payModel.gameid, payModel.serverid];
//    NSString *encodedUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodedUrlStr]];
}

//检查应用内支付的receipt
-(void)checkReceiptWithUID:(NSString *)uid{
    [[WanInAppPurchaes instance] checkReceiptWithUID:uid];
}

#pragma mark --getter
-(WanTipView *)tipView{
    if (_tipView == nil) {
        _tipView  = [[WanTipView alloc] init];
    }
    return _tipView;
}

-(WanServer *)server{
    if (_server == nil) {
        _server = [[WanServer alloc] init];
    }
    return _server;
}

@end
