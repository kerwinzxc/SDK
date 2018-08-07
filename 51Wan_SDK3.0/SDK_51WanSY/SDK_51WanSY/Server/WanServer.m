//
//  WanServer.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/23.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanServer.h"

@implementation WanServer

-(BOOL)loginRequestWithUserName:(NSString *)userName passWord:(NSString *)password validType:(NSString *)validType loginType:(NSString *)loginType gameid:(NSString *)gameid success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield{
    if ([NSString isEmpty:userName] || [NSString isEmpty:password]) {
        NSLog(@"账号名或密码为空！");
        return NO;
    }
    if ([NSString isEmpty:gameid]) {
        NSLog(@"gameid为空");
        return NO;
    }
    
    //data
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[NSString stringValue:userName] forKey:@"user_name"];
    [data setObject:[NSString stringValue:password] forKey:@"password"];
    [data setObject:[NSString stringValue:validType] forKey:@"valid_type"];
    [data setObject:[NSString stringValue:loginType] forKey:@"login_type"];
    [data setObject:[NSString stringValue:gameid] forKey:@"game_id"];
    
    [self requestWithData:data service:@"login" success:^(NSDictionary *dict, BOOL success) {
        NSString *code = [NSString stringValue:[WanUtils getResponseCodeWithDict:dict]];
        if (![NSString isEmpty:code] && [code isEqualToString:@"1"]) {
            //操作成功正常
            if (![WanUtils isDictionaryEmpty:dict] && ![WanUtils isDictionaryEmpty:dict[@"data"]] && ![WanUtils isDictionaryEmpty:dict[@"data"][@"user"]]) {
                self.accountModel = [[WanAccountModel alloc] initWithDictionary:dict[@"data"][@"user"]];
                self.accountModel.ticket = dict[@"data"][@"ticket"];
                self.accountModel.password = password;
            }
            successBlock(dict,YES);
        }else{
            //请求成功，code为异常状态
            successBlock(dict,NO);
        }
    } failed:^(NSError *error) {
        faield(error);
    }];
    return YES;
}

-(BOOL)isShowRegistBtnWithGameID:(NSString *)gameid success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield{
    //data
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[NSString stringValue:gameid] forKey:@"game_id"];
    
    [self requestWithData:data service:@"qiye_reg" success:successBlock failed:faield];
    return YES;
}

-(BOOL)registRequestWithUserName:(NSString *)userName passWord:(NSString *)password registType:(NSString *)registType channelid:(NSString *)channelid gameid:(NSString *)gameid success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield{
    if ([NSString isEmpty:userName] || [NSString isEmpty:password]) {
        NSLog(@"账号名或密码为空！");
        return NO;
    }
    if ([NSString isEmpty:gameid]) {
        NSLog(@"gameid为空");
        return NO;
    }
    
    //data
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[NSString stringValue:userName] forKey:@"user_name"];
    [data setObject:[NSString stringValue:password] forKey:@"password"];
    [data setObject:[NSString stringValue:registType] forKey:@"register_type"];
    [data setObject:[NSString stringValue:gameid] forKey:@"game_id"];
    [data setObject:[NSString stringValue:channelid] forKey:@"channel_id"];
    
    [self requestWithData:data service:@"register" success:^(NSDictionary *dict, BOOL success) {
        NSString *code = [NSString stringValue:[WanUtils getResponseCodeWithDict:dict]];
        if (![NSString isEmpty:code] && [code isEqualToString:@"1"]) {
            //操作成功正常
            if (![WanUtils isDictionaryEmpty:dict] && ![WanUtils isDictionaryEmpty:dict[@"data"]]) {
                self.accountModel = [[WanAccountModel alloc] initWithDictionary:dict[@"data"]];
                self.accountModel.ticket = dict[@"data"][@"ticket"];
                self.accountModel.password = password;
            }
            successBlock(dict,YES);
        }else{
            //请求成功，code为异常状态
            successBlock(dict,NO);
        }
    } failed:^(NSError *error) {
        faield(error);
    }];
    return YES;
}

-(BOOL)quickRegestWithType:(NSString *)registType channelid:(NSString *)channelid gameid:(NSString *)gameid success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield{
    if ([NSString isEmpty:gameid]) {
        NSLog(@"gameid为空");
        return NO;
    }
    
    //data
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[NSString stringValue:registType] forKey:@"register_type"];
    [data setObject:[NSString stringValue:gameid] forKey:@"game_id"];
    [data setObject:[NSString stringValue:channelid] forKey:@"channel_id"];
    
    [self requestWithData:data service:@"quick_reg" success:successBlock failed:faield];
    return YES;
}

-(BOOL)getValidCodeRequestWithPhone:(NSString *)phone veriType:(NSString *)veriType userName:(NSString *)userName success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield
{
    //data
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (![NSString isEmpty:veriType] && [veriType isEqualToString:@"1"]) {
        if ([NSString isEmpty:phone]) {
            NSLog(@"手机号为空！");
            return NO;
        }
        [data setObject:[NSString stringValue:phone] forKey:@"phone"];
    }else{
        if ([NSString isEmpty:userName]) {
            NSLog(@"账号为空！");
            return NO;
        }
        [data setObject:[NSString stringValue:userName] forKey:@"username"];
    }
    [data setObject:[NSString stringValue:veriType] forKey:@"type"];
    
    [self requestWithData:data service:@"send_phone_verify" success:successBlock failed:faield];
    return YES;
}

-(BOOL)moddifyRequestWithUserName:(NSString *)userName passWord:(NSString *)password validCode:(NSString *)validCode gameid:(NSString *)gameid success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield{
    if ([NSString isEmpty:userName] || [NSString isEmpty:password]) {
        NSLog(@"账号名或密码为空！");
        return NO;
    }
    if ([NSString isEmpty:gameid]) {
        NSLog(@"gameid为空");
        return NO;
    }
    if ([NSString isEmpty:validCode]) {
        NSLog(@"validCode为空");
        return NO;
    }
    
    //data
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[NSString stringValue:userName] forKey:@"username"];
    [data setObject:[NSString stringValue:password] forKey:@"password"];
    [data setObject:[NSString stringValue:validCode] forKey:@"verify"];
    [data setObject:[NSString stringValue:gameid] forKey:@"game_id"];
    
    [self requestWithData:data service:@"set_pwd" success:successBlock failed:faield];
    

    return YES;
}

-(BOOL)bindPhoneRequestWithPhoneNum:(NSString *)phoneNum uid:(NSString *)uid verify:(NSString *)verify realName:(NSString *)realName idCard:(NSString *)idcard success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield{
    
    if ([NSString isEmpty:uid]) {
        NSLog(@"uid为空！");
        return NO;
    }

    //data
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[NSString stringValue:phoneNum] forKey:@"phone"];
    [data setObject:[NSString stringValue:uid] forKey:@"uid"];
    [data setObject:[NSString stringValue:verify] forKey:@"verify"];
    [data setObject:[NSString stringValue:realName] forKey:@"realname"];
    [data setObject:[NSString stringValue:idcard] forKey:@"idcard"];
     [self requestWithData:data service:@"set_phone" success:successBlock failed:faield];
    return YES;
}

//获取配置信息
-(BOOL)getSDKConfigWithGameID:(NSString *)gameID RequesSuccess:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield{
    if ([NSString isEmpty:gameID]) {
        NSLog(@"gameid为空！");
        return NO;
    }
    //data
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[NSString stringValue:gameID] forKey:@"game_id"];
    [self requestWithData:data service:@"get_config" success:successBlock failed:faield];
    return YES;
}

-(BOOL)uploadUID:(NSString *)uid gameID:(NSString *)gameid serverID:(NSString *)server_id serverName:(NSString *)serverName roleName:(NSString *)roleName roleLevel:(NSString *)roleLevel RequesSuccess:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield{
    if ([NSString isEmpty:uid] || [NSString isEmpty:gameid] || [NSString isEmpty:server_id] || [NSString isEmpty:serverName] || [NSString isEmpty:roleName] || [NSString isEmpty:roleLevel]) {
        NSLog(@"缺少参数！");
    }
    
    //data
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[NSString stringValue:uid] forKey:@"user_id"];
    [data setObject:[NSString stringValue:gameid] forKey:@"game_id"];
    [data setObject:[NSString stringValue:server_id] forKey:@"server_id"];
    [data setObject:@"1" forKey:@"type"];
    [data setObject:[NSString stringValue:serverName] forKey:@"server_name"];
    [data setObject:[NSString stringValue:roleName] forKey:@"role_name"];
    [data setObject:[NSString stringValue:roleLevel] forKey:@"role_level"];
    
    [self requestWithData:data service:@"get_role_sdk" success:successBlock failed:faield];
    return YES;
}

-(BOOL)getOrderWithPayType:(NSString *)payType goodsName:(NSString *)goodsName cpData:(NSString *)cpData money:(NSString *)money gameid:(NSString *)gameid gain:(NSString *)gain uid:(NSString *)uid serverid:(NSString *)serverid roleName:(NSString *)roleName desc:(NSString *)desc success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield{
    //data
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[NSString stringValue:payType] forKey:@"payment_type"];
    [data setObject:[NSString stringValue:goodsName] forKey:@"goods_name"];
    [data setObject:[NSString stringValue:cpData] forKey:@"cp_data"];
    [data setObject:[NSString stringValue:money] forKey:@"money"];
    [data setObject:[NSString stringValue:gameid] forKey:@"game_id"];
    [data setObject:[NSString stringValue:gain] forKey:@"gain"];
    [data setObject:[NSString stringValue:uid] forKey:@"uid"];
    [data setObject:[NSString stringValue:serverid] forKey:@"server_id"];
    [data setObject:[NSString stringValue:roleName] forKey:@"role_name"];
    [data setObject:[NSString stringValue:desc] forKey:@"desc"];
    [data setObject:@"IOS" forKey:@"device"];
    
    [self requestWithData:data service:@"orderCreate" success:successBlock failed:faield];
    return YES;
}

-(BOOL)checkWithOrderNo:(NSString *)orderNo receipt:(NSString *)receipt success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield{
    //data
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[NSString stringValue:receipt] forKey:@"receipt"];
    [data setObject:[NSString stringValue:orderNo] forKey:@"orderNo"];
    [self requestWithData:data service:@"getReceiptData" success:successBlock failed:faield];

    return YES;
}

-(void)requestWithData:(NSDictionary *)data service:(NSString *)service success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:data forKey:@"data"];
    [params setObject:service forKey:@"service"];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    [params setObject:[NSString stringWithFormat:@"%.0f", time] forKey:@"time"];
    NSString *dataStr = [WanUtils ascendingFieldForDic:data];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@", service, [NSString stringWithFormat:@"%.0f", time], dataStr,SecretKey] ;
    [params setObject:[[NSString md5:sign] lowercaseStringWithLocale:[NSLocale currentLocale]] forKey:@"sign"];
    
    WanNetManager *manager = [WanNetManager shareInstance];
    
    [manager asyn_sendRequestWithURL:baseUrl withParams:params method:RequestTypePOST success:^(NSDictionary *dict, BOOL success) {
        NSString *code = [NSString stringValue:[WanUtils getResponseCodeWithDict:dict]];
        if (![NSString isEmpty:code] && [code isEqualToString:@"1"]) {
            //操作成功正常
            successBlock(dict,YES);
        }else{
            //请求成功，code为异常状态
            successBlock(dict,NO);
        }
    } faield:^(NSError *error) {
        faield(error);
    }];
}

//获取网络北京时间
- (NSDate *)getInternetDate
{
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 2];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: netDate];
    NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSTimeZone *systemZone = [NSTimeZone systemTimeZone];
    
    return localeDate;
}


@end
