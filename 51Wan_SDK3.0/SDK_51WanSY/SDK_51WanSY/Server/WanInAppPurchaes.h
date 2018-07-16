//
//  WanInAppPurchaes.h
//  Wan669SDKKit
//
//  Created by Star on 2017/3/16.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WanPayModel.h"
#import "WanConstance.h"

@interface WanInAppPurchaes : NSObject

@property (nonatomic, strong) WanPayModel *payModel;

+ (instancetype)instance;

-(void)buyProduction:(NSString *)productIdentifier;

//检验是否有未验证的receipt
-(void)checkReceiptWithUID:(NSString *)uid;

@end
