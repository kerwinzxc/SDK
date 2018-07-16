//
//  WanUtils.m
//  Wan669SDKDemo
//
//  Created by liuluoxing on 2017/2/20.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import "WanUtils.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

@implementation WanUtils

+(UIBezierPath *)bezierPathWithFrame:(CGRect)frame withShadowWith:(CGFloat)shadowWidth{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(frame.origin.x-shadowWidth, frame.origin.y-shadowWidth)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(frame)+shadowWidth, frame.origin.y-shadowWidth)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(frame)+shadowWidth, CGRectGetMaxY(frame)+shadowWidth)];
    [path addLineToPoint:CGPointMake(frame.origin.x-shadowWidth, CGRectGetMaxY(frame)+shadowWidth)];
    [path addLineToPoint:CGPointMake(frame.origin.x-shadowWidth, frame.origin.y-shadowWidth)];
    
    return path;
}

+(void)setShadowInView:(UIView *)view{
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowRadius = 2.5f;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowOpacity = 0.2f;
    view.layer.shadowPath = [WanUtils bezierPathWithFrame:view.frame withShadowWith:2.5f].CGPath;
}


+(BOOL)isDictionaryEmpty:(NSDictionary *)dict{
    return dict == nil || ![dict isKindOfClass:[NSDictionary class]] || dict.count == 0 || [dict isKindOfClass:[NSNull class]];
}

+(BOOL)isArrayEmpty:(NSArray *)arr{
    return arr == nil || ![arr isKindOfClass:[NSArray class]] || arr.count == 0 || [arr isKindOfClass:[NSNull class]];
}

//字典转为Json字符串
+(NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//Json字符串转为字典
+(NSDictionary *)jsonToDictionary:(NSString *)jsonString
{
    if ([NSString isEmpty:jsonString]) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(NSString *)ascendingFieldForDic:(NSDictionary *)dict{
    NSMutableArray *arr = [NSMutableArray array];
    //取出key
    for (NSString *key in dict) {
        [arr addObject:key];
    }
    //key升序排列
    NSStringCompareOptions comparisonOptions =NSCaseInsensitiveSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range =NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    
    NSArray *sortArray = [arr sortedArrayUsingComparator:sort];
    //根据升序key取值拼接字符串
    NSMutableString *ascendStr =  [[NSMutableString alloc] init];
    for (NSString *key in sortArray) {
        if ([NSString isNotEmpty:dict[key]]) {
            [ascendStr appendFormat:@"%@", [NSString stringWithFormat:@"%@=%@", key, dict[key]]];
        }
    }
    return ascendStr;
}

/**
 *  正则表达式验证手机号
 */
+(BOOL)validateMobile1:(NSString *)mobile
{
    // 130-139  150-153,155-159  180-189  145,147  170,171,173,176,177,178
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


+ (BOOL)validateMobile:(NSString *)mobile{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:mobile] == YES)
       || ([regextestcm evaluateWithObject:mobile] == YES)
       || ([regextestct evaluateWithObject:mobile] == YES)
       || ([regextestcu evaluateWithObject:mobile] == YES)){
        return YES;
    }else{
        return NO;
    }
}

+(UIImage *)imageInBundelWithName:(NSString *)imgName{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Bundle_51WanSY" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageNamed:imgName inBundle:bundle compatibleWithTraitCollection:nil];
}

+(NSString *)iphoneType {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

+(NSString *)getResponseTypeWithDict:(NSDictionary *)dict{
    if (![WanUtils isDictionaryEmpty:dict] && ![WanUtils isDictionaryEmpty:dict[@"data"]]) {
        return [NSString stringValue:dict[@"data"][@"type"]];
    }
    return nil;
}

+(NSString *)getResponseMsgWithDict:(NSDictionary *)dict{
    if (![WanUtils isDictionaryEmpty:dict] && ![WanUtils isDictionaryEmpty:dict[@"state"]]) {
        return [NSString stringValue:dict[@"state"][@"msg"]];
    }
    return @"";
}

+(NSString *)getResponseCodeWithDict:(NSDictionary *)dict{
    if (![WanUtils isDictionaryEmpty:dict] && ![WanUtils isDictionaryEmpty:dict[@"state"]]) {
        return [NSString stringValue:dict[@"state"][@"code"]];
    }else{
        return @"";
    }
}

+(NSString *)getResponseTicketWithDict:(NSDictionary *)dict{
    if (![WanUtils isDictionaryEmpty:dict] && ![WanUtils isDictionaryEmpty:dict[@"data"]]) {
        return [NSString stringValue:dict[@"data"][@"ticket"]];
    }else{
        return @"";
    }
}

+(NSString *)getResponseUidWithDict:(NSDictionary *)dict{
    if (![WanUtils isDictionaryEmpty:dict] && ![WanUtils isDictionaryEmpty:dict[@"data"]] && ![WanUtils isDictionaryEmpty:dict[@"data"][@"user"]]) {
        return [NSString stringValue:dict[@"data"][@"user"][@"id"]];
    }else{
        return @"";
    }
}

+(NSString *)getResponseKey:(NSString *)key intDataDict:(NSDictionary *)dict{
    if (![WanUtils isDictionaryEmpty:dict] && ![WanUtils isDictionaryEmpty:dict[@"data"]]) {
        return [NSString stringValue:dict[@"data"][key]];
    }else{
        return nil;
    }
}

+(void)saveAccount:(NSString *)account password:(NSString *)password{
    if (![NSString isEmpty:account] && ![NSString isEmpty:password]) {
        NSString *accountInfo = [NSString stringWithFormat:@"%@=%@", account, password];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSMutableArray *arrayM = [userDefault objectForKey:@"Account"];
    
        if (arrayM && ![arrayM containsObject:accountInfo]) {
            arrayM = [NSMutableArray arrayWithArray:arrayM];
            if (arrayM.count > 4) {
                [arrayM removeObjectsInRange:NSMakeRange(4, arrayM.count-4)];
            }
        }else{
            arrayM = [NSMutableArray array];
        }
        [arrayM insertObject:accountInfo atIndex:0];
        [userDefault setObject:arrayM forKey:@"Account"];
        [userDefault synchronize];
    }
}

+(void)deleteAccount:(NSString *)account password:(NSString *)password{
    if (![NSString isEmpty:account] && ![NSString isEmpty:password]) {
        NSString *accountInfo = [NSString stringWithFormat:@"%@=%@", account, password];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:[userDefault objectForKey:@"Account"]];
        [arrayM removeObject:accountInfo];
        [userDefault setObject:arrayM forKey:@"Account"];
        [userDefault synchronize];
    }
}

+(NSMutableArray *)getAllSavedAccount{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrayM = [userDefault objectForKey:@"Account"];
    NSMutableArray *accountArray = [NSMutableArray array];
    for (NSString *info in arrayM) {
        NSArray *arr = [info componentsSeparatedByString:@"="];
        if (arr && arr.count > 1){
            WanAccountModel *model = [[WanAccountModel alloc] init];
            model.account = arr[0];
            model.password = arr[1];
            [accountArray addObject:model];
        }
    }
    return accountArray;
}

+(WanAccountModel *)getRencentlyAccount{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrayM = [userDefault objectForKey:@"Account"];
    NSString *info = arrayM[0];
    NSArray *arr = [info componentsSeparatedByString:@"="];
    if (arr && arr.count > 1){
        WanAccountModel *model = [[WanAccountModel alloc] init];
        model.account = arr[0];
        model.password = arr[1];
        return model;
    }
    return nil;
}

+(BOOL)isAppStore{
    NSString *isAppStore = [WanUtils getConfigWithKey:@"isAppSotre"];
    if (![NSString isEmpty:isAppStore]) {
        return [isAppStore boolValue];
    }
    return NO;
}

+(NSString *)channelID{
    return [WanUtils getConfigWithKey:@"chanelID"];
}

//根据key值获取Plist文件配置参数
+(NSString *)getConfigWithKey:(NSString *)key{
    // 获取bundle参数
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Bundle_51WanSY" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *plistPath = [bundle pathForResource:@"config" ofType:@"plist"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if (![WanUtils isDictionaryEmpty:dic]) {
        NSString *value = [dic objectForKey:key];
        return [NSString stringValue:value];
    }
    return nil;
}

+(UIImage *)coreBlurImage:(UIImage *)image
           withBlurNumber:(CGFloat)blur {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage  *inputImage=[CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

+(UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(NSString *)URLEncodedString:(NSString *)str{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)str,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    return encodedString;
}

+(NSString *)URLDecodedString:(NSString *)str{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

+(UIViewController *)rootViewController{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    rootVC.definesPresentationContext = YES;
    return rootVC;
}

@end
