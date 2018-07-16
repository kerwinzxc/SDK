//
//  WanSDKConfig.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/30.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanSDKConfig.h"

@implementation WanSDKConfig

+(instancetype)shareInstance{
    static WanSDKConfig *_sdkConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sdkConfig = [[WanSDKConfig alloc] init];
    });
    return _sdkConfig;
}

-(void)initWithDict:(NSDictionary *)dict{
    if (![WanUtils isDictionaryEmpty:dict] && ![WanUtils isDictionaryEmpty:dict[@"data"]]) {
        NSDictionary *data = dict[@"data"];
        self.isAdult = [@"0" isEqualToString:data[@"isAdult"]]?NO:YES;
        self.isIAP = [@"0" isEqualToString:data[@"isIAP"]]?YES:NO;
        self.isRegister = [@"1" isEqualToString:data[@"isRegister"]]?NO:YES;
        self.isNotice = [@"0" isEqualToString:data[@"isNotice"]]?NO:YES;
        if (![WanUtils isDictionaryEmpty:data[@"noticePopup"]]) {
            self.popModel = [[WanPopModel alloc] initWithDictionary:data[@"noticePopup"]];
        }
    }
}

@end
