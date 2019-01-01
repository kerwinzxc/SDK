//
//  WanSDKConfig.h
//  SDK_51WanSY
//
//  Created by Star on 2018/1/30.
//  Copyright © 2018年 Star. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WanPopModel.h"

@interface WanSDKConfig : NSObject

@property (nonatomic, assign) BOOL isAdult;//是否开启防沉迷
@property (nonatomic, assign) BOOL isIAP;//是否开启IAP支付
@property (nonatomic, assign) BOOL isRegister;//是否开启注册按钮
@property (nonatomic, assign) BOOL isNotice;//是否开启公告
@property (nonatomic, assign) NSString* dealUrl;//协议链接
@property (nonatomic, strong) WanPopModel *popModel;//公告model
@property (nonatomic, strong) NSMutableArray *payChannelsArr;//支付方式
@property (nonatomic, assign) CGFloat discount;//折扣

@property (nonatomic, copy) NSString *wxAppid;//微信小程序Appid
/**
 * 获取单例实体对象，所有方法都使用该实例对象进行调用
 */
+(instancetype)shareInstance;

-(void)initWithDict:(NSDictionary *)dict;

@end
