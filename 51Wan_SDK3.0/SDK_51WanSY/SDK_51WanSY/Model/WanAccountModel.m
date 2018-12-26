//
//  WanAccountModel.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/26.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanAccountModel.h"

@implementation WanAccountModel

-(id)initWithDictionary:(NSDictionary *)dict{
    if (![WanUtils isDictionaryEmpty:dict]) {
        self.account = [NSString stringValue:dict[@"name"]];
        self.uid = [NSString stringValue:dict[@"id"]];
        self.game_id = [NSString stringValue:dict[@"game_id"]];
        self.channelID = [NSString stringValue:dict[@"channel_id"]];
        self.isAdult = [NSString stringValue:dict[@"isAdult"]];
        
        NSString *phoneNum = [NSString stringValue:dict[@"phone"]];
        if (phoneNum.length >= 7) {
            self.phoneNo = [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        
        NSString *idCardNum = [NSString stringValue:dict[@"id_card"]];
        if (idCardNum.length >= 14) {
            self.id_card = [idCardNum stringByReplacingCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
        }
        
        self.ticket = [NSString stringValue:dict[@"ticket"]];
        if ([WanUtils isDictionaryEmpty:dict[@"phone_popup"]]) {
            self.isShowPhoneView = YES;
        }
    }
    return self;
}

@end
