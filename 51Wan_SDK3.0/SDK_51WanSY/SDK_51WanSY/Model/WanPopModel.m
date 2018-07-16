//
//  WanPopModel.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/24.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanPopModel.h"

@implementation WanPopModel

-(id)initWithDictionary:(NSDictionary *)dict{
    if (![WanUtils isDictionaryEmpty:dict]) {
        self.content = [NSString stringValue:dict[@"content"]];
        self.img_url = [NSString stringValue:dict[@"img_url"]];
        self.jump_url = [NSString stringValue:dict[@"jump_url"]];
        self.title = [NSString stringValue:dict[@"title"]];
        self.memo = [NSString stringValue:dict[@"memo"]];
    }
    return self;
}

@end
