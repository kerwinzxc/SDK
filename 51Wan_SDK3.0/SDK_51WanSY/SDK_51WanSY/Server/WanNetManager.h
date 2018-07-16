//
//  WanNetManager.h
//  Wan669SDKDemo
//
//  Created by liuluoxing on 2017/2/20.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#define domian [WanUtils getConfigWithKey:@"domain"]

#ifdef DEBUG
#define payURL [NSString stringWithFormat:@"%@%@", domian, @"/pay/h5_pay"]
#define baseUrl [NSString stringWithFormat:@"%@%@", domian, @"/Api/SdkV2/index"]
#else
#define payURL [NSString stringWithFormat:@"%@%@", domian, @"/pay/h5_pay"]
#define baseUrl [NSString stringWithFormat:@"%@%@", domian, @"/Api/SdkV2/index"]
#endif

#define serviceUrl [NSString stringWithFormat:@"%@%@", domian, @"/Api/Sdk/service"]

#define SecretKey [WanUtils getConfigWithKey:@"secretKey"]

#import <Foundation/Foundation.h>
#import "WanUtils.h"
#import "NSString+Util.h"

#define kTimeOutInterval 30 // 请求超时的时间
typedef void (^SuccessBlock)(NSDictionary *dict, BOOL success); // 访问成功block
typedef void (^AFNErrorBlock)(NSError *error); // 访问失败block

typedef NS_ENUM(NSInteger,RequestType){
    RequestTypeGET,//get请求
    RequestTypePOST//post请求
};

@interface WanNetManager : NSObject

+(instancetype)shareInstance;

//异步请求
-(void)asyn_sendRequestWithURL:(NSString *)urlPath withParams:(NSDictionary *)params method:(RequestType)type success:(SuccessBlock)successBlock faield:(AFNErrorBlock)faieldBlock;

@end
