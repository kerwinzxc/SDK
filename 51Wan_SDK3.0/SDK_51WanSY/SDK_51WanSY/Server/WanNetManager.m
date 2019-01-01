//
//  WanNetManager.m
//  Wan669SDKDemo
//
//  Created by liuluoxing on 2017/2/20.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//


#import "WanNetManager.h"
#import "AFNetworking.h"

@implementation WanNetManager

+(instancetype)shareInstance{
    static WanNetManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[WanNetManager alloc] init];
    });
    return _manager;
}

#pragma mark - 创建请求者
-(AFHTTPSessionManager *)sessionManagerIsJSONResponse:(BOOL)isJSONResponse
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;

    if (isJSONResponse) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }else{
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    
    return manager;
}

-(void)asyn_sendRequestWithURL:(NSString *)urlPath withParams:(NSDictionary *)params method:(RequestType)type success:(SuccessBlock)successBlock faield:(AFNErrorBlock)faieldBlock{
    if ([NSString isEmpty:urlPath]) {
        NSLog(@"请求路径错误!");
        return;
    }
    
    NSDictionary *paramsDic = [self addParams:params];
    
    AFHTTPSessionManager *mgr = [self sessionManagerIsJSONResponse:YES];
    //GET请求
    if (type == RequestTypeGET) {
        [mgr GET:urlPath parameters:paramsDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求成功！data=%@",responseObject);
            if (successBlock) {
                successBlock(responseObject, YES);
            }
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
            NSLog(@"请求失败！%@", error);
            if (faieldBlock) {
                faieldBlock(error);
            }
        }];
    }
    //POST请求
    else{
        [mgr POST:urlPath parameters:paramsDic progress:^(NSProgress * _Nonnull uploadProgress) {
   
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求成功！data=%@",responseObject);
            if (successBlock) {
                successBlock(responseObject, YES);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败！%@", error);
            if (faieldBlock) {
                faieldBlock(error);
            }
        }];
    }
}

- (void)AFNetworkStatus{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                break;
            default:
                break;
        }
    }] ;
}

-(NSDictionary *)addParams:(NSDictionary *)params{
    //防止出问题，在不改动其他接口代码的情况下加参数
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:params];
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:params[@"data"]];
    //是否企业包，1为上架AppStore的包，0为企业包
    if ([WanUtils isAppStore]) {
        [data setObject:@"1" forKey:@"isAppStore"];
    }else{
        [data setObject:@"0" forKey:@"isAppStore"];
    }
    //系统版本
    [data setObject:[[UIDevice currentDevice] systemVersion] forKey:@"system_version"];
    //手机型号
    [data setObject:[WanUtils iphoneType] forKey:@"phone_type"];
    //SDK版本
    NSDictionary *infoDictionary = [[NSBundle bundleForClass:[self class]] infoDictionary];
    [data setObject:[infoDictionary objectForKey:@"CFBundleShortVersionString"] forKey:@"sdk_version"];
    //设备号UDID
    [data setObject:[NSString stringValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString]] forKey:@"udid"];
    
    [paramsDic setObject:data forKey:@"data"];
    NSString *dataStr = [WanUtils ascendingFieldForDic:data];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@", params[@"service"], params[@"time"], dataStr,SecretKey] ;
    [paramsDic setObject:[[NSString md5:sign] lowercaseStringWithLocale:[NSLocale currentLocale]] forKey:@"sign"];
    return paramsDic;
}

@end
