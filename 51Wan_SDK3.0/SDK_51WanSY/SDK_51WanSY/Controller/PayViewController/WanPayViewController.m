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
    [self.payServer getOrderWithPayType:[NSString stringWithFormat:@"%zd", payTypeModel.paymentType] goodsName:payModel.goodsName cpData:payModel.cpData money:payModel.money gameid:payModel.gameid gain:payModel.gain uid:payModel.uid serverid:payModel.serverid roleName:payModel.roleName desc:payModel.description success:^(NSDictionary *dict, BOOL success) {
        switch (payTypeModel.paymentType) {
            case WanPaymentTypeWeiXin:
                
                break;
            case WanPaymentTypeAliPay:
                
                break;
            case WanPaymentTypeUnionPay:
                
                break;
            case WanPaymentTypePayPale:
            {
                WanWebViewController *webVc = [[WanWebViewController alloc] init];
                webVc.requestUrl = dict[@"data"][@"pay_info"];
                [self.navigationController pushViewController:webVc animated:NO];
            }
                break;
            default:
                break;
        }
    } failed:^(NSError *error) {
        
    }];
    
}
#pragma mark ----getter selector
-(WanServer *)payServer{
    if (_payServer == nil) {
        _payServer = [[WanServer alloc] init];
    }
    return _payServer;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
