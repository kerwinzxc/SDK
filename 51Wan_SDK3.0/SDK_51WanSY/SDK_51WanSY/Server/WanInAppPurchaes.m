//
//  WanInAppPurchaes.m
//  Wan669SDKKit
//
//  Created by Star on 2017/3/16.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import "WanInAppPurchaes.h"
#import "StoreKit/StoreKit.h"
#import "WanProgressHUD.h"
#import "NSString+Base64.h"
#import "WanServer.h"

#define AppStoreInfoLocalFilePath [NSString stringWithFormat:@"%@/%@/", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],@"EACEF35FE363A75A"]

@interface WanInAppPurchaes() <SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic, copy) NSString *receipt;

@property (nonatomic, strong) WanServer *payserver;

@property (nonatomic, copy) NSString *orderNo;

@end

@implementation WanInAppPurchaes

-(WanServer *)payserver{
    if (_payserver ==nil) {
        _payserver = [[WanServer alloc] init];
    }
    return _payserver;
}

+ (instancetype)instance
{
    static WanInAppPurchaes *sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[WanInAppPurchaes alloc] init];
    }
    return sharedInstance;
}

-(instancetype)init{
    if (self = [super init]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

#pragma mark--1.判断能否购买
-(void)buyProduction:(NSString *)productIdentifier{
    if ([SKPaymentQueue canMakePayments] && ![self isJailBreak]) {
        [self getOrderWith:productIdentifier];
    } else {
        [WanProgressHUD showFailure:@"用户禁止应用内付费购买"];
    }
}

#pragma mark--2.请求服务器生成预订单
-(void)getOrderWith:(NSString *)productIdentifier{
    [WanProgressHUD showLoading:@"正在购买，请稍后..."];
    NSString *money = [NSString stringWithFormat:@"%.0f",[_payModel.money floatValue]*100];
    [self.payserver getOrderWithPayType:@"4" goodsName:_payModel.goodsName cpData:_payModel.cpData money:money gameid:_payModel.gameid gain:_payModel.gain uid:_payModel.uid serverid:_payModel.serverid roleName:_payModel.roleName desc:_payModel.desc success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            //获取订单号,开始支付
            self.orderNo = dict[@"data"][@"order_no"];
            [self getProductInfo:productIdentifier];
        }else{
            [WanProgressHUD showMessage:[WanUtils getResponseMsgWithDict:dict]];
        }
    } failed:^(NSError *error) {
        [WanProgressHUD showFailure:@"生成订单失败"];
        [WanProgressHUD hide];
    }];
}

#pragma mark--3.从Apple查询用户点击购买的产品的信息
- (void)getProductInfo:(NSString *)productIdentifier {
    NSArray *product = [[NSArray alloc] initWithObjects:productIdentifier, nil];
    NSSet *set = [NSSet setWithArray:product];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

#pragma mark--<SKProductsRequestDelegate>
// 查询成功后的回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        [WanProgressHUD showFailure:@"无法获取产品信息，请重试"];
        return;
    }
    //购买
    SKMutablePayment * payment = [SKMutablePayment paymentWithProduct:myProduct[0]];
    payment.applicationUsername = self.orderNo;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [WanProgressHUD hide];
    [WanProgressHUD showFailure:[error localizedDescription]];
}

#pragma mark--4.购买操作后的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
            {
                [WanProgressHUD showMessage:@"购买完成..."];
                
                NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                self.receipt = [NSString base64StringFromData:receiptData length:[receiptData length]];
                
                [self checkReceiptIsValid:self.receipt orederNo:self.orderNo uid:_payModel.uid];//把receipt发送到服务器验证是否有效
                [self completeTransaction:transaction];
            }
                break;
                
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored://已经购买过该商品
//                [WanProgressHUD showMessage:@"恢复购买成功"];
                [self restoreTransaction:transaction];
                break;
                
            case SKPaymentTransactionStatePurchasing://商品添加进列表
//                [WanProgressHUD showMessage:@"正在请求付费信息，请稍后"];
                break;
                
            default:
                break;
        }
    }
}


- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

//购买失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        [WanProgressHUD showMessage:@"购买失败，请重试"];
    } else {
        [WanProgressHUD showMessage:@"用户取消交易"];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark--5.向服务器端验证购买凭证的有效性
- (void)checkReceiptIsValid:(NSString *)receipt orederNo:(NSString *)orderNo uid:(NSString *)uid{
    
    if ([NSString isEmpty:receipt] || [NSString isEmpty:orderNo]) {
        return;
    }
    
    [_payserver checkWithOrderNo:self.orderNo receipt:receipt success:^(NSDictionary *dict, BOOL success) {
        //发送成功就OK了，后台验证机制
    } failed:^(NSError *error) {
        [self saveReceipt:receipt orderNo:orderNo uid:uid];
    }];
}

#pragma mark--6.持久化存储用户购买凭证
-(void)saveReceipt:(NSString *)receipt orderNo:(NSString *)orderNo uid:(NSString *)uid{
    
    if ([NSString isEmpty:orderNo] || [NSString isEmpty:receipt] || [NSString isEmpty:uid])
        return;
    
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSDictionary *receiptDic = [userDefault objectForKey:_payModel.uid];
    NSMutableDictionary *dicM;
    if (receiptDic == nil) {
        dicM = [NSMutableDictionary dictionary];
    }else{
        dicM = [[NSMutableDictionary alloc] initWithDictionary:receiptDic];
    }
    [dicM setValue:self.receipt forKey:self.orderNo];
    
    [userDefault setObject:dicM forKey:_payModel.uid];
    [userDefault synchronize];
}

//检查是否有未提交检验的receipt
-(void)checkReceiptWithUID:(NSString *)uid{
    if ([NSString isEmpty:uid])
        return;
    
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSDictionary *receiptDic = [userDefault objectForKey:uid];
    [userDefault removeObjectForKey:uid];
    
    if (![WanUtils isDictionaryEmpty:receiptDic]) {
        for (NSString *key in receiptDic) {
            [self checkReceiptIsValid:[receiptDic objectForKey:key] orederNo:key uid:uid];
        }
    }
}

//判断是否越狱
- (BOOL)isJailBreak{
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]) {
        return YES;
    }
    return NO;
}

//移除监听
-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


@end
