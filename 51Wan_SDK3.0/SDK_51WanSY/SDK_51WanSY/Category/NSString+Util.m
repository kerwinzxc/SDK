//
//  NSString+Util.m
//  Wan669SDKDemo
//
//  Created by liuluoxing on 2017/2/20.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Util)

+ (BOOL)isEmpty:(NSString *)str {
    if (!str) {
        return YES;
    }
    
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if ([str isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isNotEmpty:(NSString *)str {
    return ![NSString isEmpty:str];
}


+ (NSString *)stringValue:(NSString *)str {
    if (!str) {
        return @"";
    }
    
    if ([str isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)str;
        return [number stringValue];
    }
    
    if (![str isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    return str;
}

//秒转换成时间格式字符串
+ (NSString *)timeformatFromSeconds:(NSInteger)seconds {
    NSInteger totalm = seconds / (60);
    NSInteger h = totalm / (60);
    NSInteger m = totalm % (60);
    NSInteger s = seconds % (60);
    if (h == 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)m, (long)s];
    }
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)h, (long)m, (long)s];
}

//md5加密
+(NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result[0], result[1], result[2], result[3],result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

+ (NSString *)getString:(NSString *)str	{
    if ([str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    if ([str isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%.f",[str doubleValue]];
    }
    
    if (!str) {
        return @"";
    }
    if (![str isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+(CGFloat)calculateRowWidth:(NSString *)string fontSize:(CGFloat)fontSize{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, CGFLOAT_MAX)options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

+(CGFloat)calculateRowHeight:(NSString *)string fontSize:(CGFloat)fontSize{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

@end
