//
//  WanPayViewController.m
//  SDK_51WanSY
//
//  Created by star on 2018/9/11.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanPayViewController.h"
#import "WanPayView.h"
#import "WanServer.h"
#import "WanWebViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

//支付宝返回结果code码
typedef NS_ENUM(NSInteger, AlipayResultCode){
    AlipayResultCodePaySuccess        = 9000,//订单支付成功
    AlipayResultCodePayProcessing     = 8000,//正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
    AlipayResultCodePayFailed         = 4000,//订单支付失败
    AlipayResultCodePayRepeat         = 5000,//重复请求
    AlipayResultCodePayCancel         = 6001,//用户中途取消
    AlipayResultCodePayNetError       = 6002,//网络连接出错
    AlipayResultCodePayUnKnow         = 6004//支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
};

@interface WanPayViewController ()<WanPayActionDelegate>{
    WanPayView *_payView;
}

@property (nonatomic, strong) WanServer *payServer;

@end

@implementation WanPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setPayModel:(WanPayModel *)payModel{
    _payModel = payModel;
    _payView = [[WanPayView alloc] initWithFrame:self.view.bounds withPayModel:_payModel];
    _payView.delegate = self;
    [self.view addSubview:_payView];
}

#pragma mark ----WanPayActionDelegate
-(void)payWithPayTypeModel:(WanPayTypeModel *)payTypeModel withPayModel:(WanPayModel *)payModel{
    [WanProgressHUD showLoading:@"创建订单..."];
    [self.payServer getOrderWithPayType:[NSString stringWithFormat:@"%zd", payTypeModel.paymentType] goodsName:payModel.goodsName cpData:payModel.cpData money:payModel.money gameid:payModel.gameid gain:payModel.gain uid:payModel.uid serverid:payModel.serverid roleName:payModel.roleName desc:payModel.description success:^(NSDictionary *dict, BOOL success) {
        [WanProgressHUD hide];
        if (success) {
            switch (payTypeModel.paymentType) {
                case WanPaymentTypeAliPayApp:
                {
                    NSString *pay_info = [WanUtils getResponseKey:@"pay_info" intDataDict:dict];
                    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
                    [[AlipaySDK defaultService] payOrder:pay_info fromScheme:bundleID callback:^(NSDictionary *resultDic) {
                        
                    }];
                }
                    break;
                case WanPaymentTypeWeiXinH5:
                case WanPaymentTypeSFTBank:{
                    NSString *pay_info = [WanUtils getResponseKey:@"pay_info" intDataDict:dict];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pay_info]];
                }
                    break;
                case WanPaymentTypeWechatApplet:
                {
                    [WXApi registerApp:[WanSDKConfig shareInstance].wxAppid];
//                    [WXApi registerApp:@"wx93f0cc9580ac0e9d"];
                    NSString *pay_info = [WanUtils getResponseKey:@"pay_info" intDataDict:dict];
                    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
                    launchMiniProgramReq.userName = @"gh_74ea4ac015e2";  //拉起的小程序的username
                    launchMiniProgramReq.path = pay_info;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
                    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
                    [WXApi sendReq:launchMiniProgramReq];
                }
                    break;
                case WanPaymentTypePayPale:
                {
                    WanWebViewController *webVc = [[WanWebViewController alloc] init];
                    webVc.requestUrl = [WanUtils getResponseKey:@"pay_info" intDataDict:dict];
                    [self.navigationController pushViewController:webVc animated:NO];
                }
                    break;
                default:
                    break;
            }
        }else{
            NSString *info = [NSString stringValue:[WanUtils getResponseMsgWithDict:dict]];
            [WanProgressHUD showInfoMsg:info];
        }
    } failed:^(NSError *error) {
        [WanProgressHUD hide];
    }];
    
}
#pragma mark ----getter selector
-(WanServer *)payServer{
    if (_payServer == nil) {
        _payServer = [[WanServer alloc] init];
    }
    return _payServer;
}

#pragma mark -----alipay openURl-------
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication{
    if ([url.host isEqualToString:@"safepay"]) {
        [self alipayCallBackUrl:url];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication
         annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        [self alipayCallBackUrl:url];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    if ([url.host isEqualToString:@"safepay"]) {
        [self alipayCallBackUrl:url];
    }
    return YES;
}

-(void)alipayCallBackUrl:(NSURL *)url {
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"支付宝支付结果:%@", resultDic);
        if (resultDic) {
            NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
            switch (resultStatus) {
                case AlipayResultCodePaySuccess:
                {
                    [WanProgressHUD showMessage:@"支付成功"];
                }
                    break;
                    
                case AlipayResultCodePayCancel:
                {
                    [WanProgressHUD showMessage:@"支付取消"];
                }
                    break;
                    
                default:
                {
                    [WanProgressHUD showMessage:@"支付失败"];
                }
                    break;
            }
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
