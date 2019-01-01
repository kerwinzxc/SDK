//
//  WanSDKConfig.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/30.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanSDKConfig.h"
#import "WanPayTypeModel.h"

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
        self.dealUrl = [NSString stringValue:data[@"dealUrl"]];
        self.discount = [[NSString stringValue:data[@"discount"]] floatValue];
        self.wxAppid = [NSString stringValue:data[@"wx_developers_appid"]];
        
        if (![WanUtils isDictionaryEmpty:data[@"noticePopup"]]) {
            self.popModel = [[WanPopModel alloc] initWithDictionary:data[@"noticePopup"]];
        }
        
        NSArray *arr = data[@"payChannel"];
        if (![WanUtils isArrayEmpty:arr]) {
            //遍历支付方式
            NSMutableArray *channelsArr = [NSMutableArray array];
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *channelDict = arr[i];
                WanPayTypeModel *model = [[WanPayTypeModel alloc] initWithDictionary:channelDict];
                [channelsArr addObject:model];
            }
            
            self.payChannelsArr = channelsArr;
        }
    }
}

@end
