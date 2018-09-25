//
//  WanPayTypeModel.h
//  SDK_51WanSY
//
//  Created by star on 2018/9/12.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanBaseModel.h"

@interface WanPayTypeModel : WanBaseModel

@property (nonatomic, copy) NSString *imgUrl;//支付方式图片

@property (nonatomic, copy) NSString *payTitle;//支付方式

@property (nonatomic, copy) NSString *payDesc;//支付方式描述

@property (nonatomic, assign) BOOL isHiden;//是否是隐藏

@property (nonatomic, assign) NSString *type;//支付方式type值

-(id)initWithDictionary:(NSDictionary *)dict;

@end
