//
//  WanPayTypeModel.m
//  SDK_51WanSY
//
//  Created by star on 2018/9/12.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanPayTypeModel.h"

@implementation WanPayTypeModel

-(id)initWithDictionary:(NSDictionary *)dict{
    if (![WanUtils isDictionaryEmpty:dict]) {
        self.imgUrl = [NSString stringValue:dict[@"icon"]];
        self.payTitle = [NSString stringValue:dict[@"title"]];
        self.payDesc = [NSString stringValue:dict[@"desc"]];
        self.isHiden = [NSString stringValue:dict[@"ishidden"]];
        self.type = [NSString stringValue:dict[@"payment_type"]];
    }
    return self;
}

@end
