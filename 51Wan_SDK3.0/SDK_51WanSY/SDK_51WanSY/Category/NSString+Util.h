//
//  NSString+Util.h
//  Wan669SDKDemo
//
//  Created by liuluoxing on 2017/2/20.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

+ (BOOL)isEmpty:(NSString *)str;

+ (BOOL)isNotEmpty:(NSString *)str;

+ (NSString *)stringValue:(NSString *)str;

//秒转换成时间格式字符串
+ (NSString *)timeformatFromSeconds:(NSInteger)seconds;

//md5加密
+(NSString *)md5:(NSString *)str;

+ (NSString *)getString:(NSString *)str;

+(CGFloat)calculateRowWidth:(NSString *)string fontSize:(CGFloat)fontSize;

+(CGFloat)calculateRowHeight:(NSString *)string fontSize:(CGFloat)fontSize;

@end
