//
//  WanPayTypeModel.h
//  SDK_51WanSY
//
//  Created by star on 2018/9/12.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanBaseModel.h"

typedef NS_ENUM(NSInteger, WanPaymentType){
    WanPaymentTypeWeiXinApp          = 1,//微信app支付（原生）
    WanPaymentTypeAliPayApp          = 2,//支付宝app支付（原生）
    WanPaymentTypePlatformPay        = 3,//平台币支付（暂时未使用）
    WanPaymentTypeIAP                = 4,//苹果应用内支付
    WanPaymentTypeWeiXinH5           = 5,//微信H5支付（原生+第三方）   跳转H5页面
    WanPaymentTypeAliPayH5           = 6,//支付宝H5支付（暂未对接）
    WanPaymentTypeSFTH5              = 7,//盛付通微信H5支付（已暂停使用）
    WanPaymentTypeSFTBank            = 8,//盛付通银行卡支付   跳转H5页面
    WanPaymentTypeWechatApplet       = 9,//微信小程序支付
    WanPaymentTypeAlipayApplet       = 10,//支付宝花呗支付  不对接
    WanPaymentTypePayPale            = 11//paypale
};

@interface WanPayTypeModel : WanBaseModel

@property (nonatomic, copy) NSString *imgUrl;//支付方式图片

@property (nonatomic, copy) NSString *payTitle;//支付方式

@property (nonatomic, copy) NSString *payDesc;//支付方式描述

@property (nonatomic, assign) BOOL isHiden;//是否是隐藏

@property (nonatomic, assign) enum WanPaymentType paymentType;//支付方式type值

-(id)initWithDictionary:(NSDictionary *)dict;

@end
