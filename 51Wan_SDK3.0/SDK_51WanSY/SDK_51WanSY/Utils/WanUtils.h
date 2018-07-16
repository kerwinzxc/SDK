//
//  WanUtils.h
//  Wan669SDKDemo
//
//  Created by liuluoxing on 2017/2/20.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WanConstance.h"
#import "WanAccountModel.h"

@interface WanUtils : NSObject

+(BOOL)isDictionaryEmpty:(NSDictionary *)dict;

+(BOOL)isArrayEmpty:(NSArray *)arr;

//字典转为Json字符串
+(NSString *)dictionaryToJson:(NSDictionary *)dic;

//Json字符串转为字典
+(NSDictionary *)jsonToDictionary:(NSString *)jsonString;

+(NSString *)ascendingFieldForDic:(NSDictionary *)dict;

//正则验证手机号
+(BOOL)validateMobile:(NSString *)mobile;

+(UIImage *)imageInBundelWithName:(NSString *)imgName;

//手机类型
+(NSString *)iphoneType;

//阴影的UIBezierPath
+(UIBezierPath *)bezierPathWithFrame:(CGRect)frame withShadowWith:(CGFloat)shadowWidth;

//设置view的阴影
+(void)setShadowInView:(UIView *)view;

/*
 *获取返回结果的code码/消息/ticket/type
 */
+(NSString *)getResponseMsgWithDict:(NSDictionary *)dict;
+(NSString *)getResponseCodeWithDict:(NSDictionary *)dict;
+(NSString *)getResponseTicketWithDict:(NSDictionary *)dict;
+(NSString *)getResponseUidWithDict:(NSDictionary *)dict;
+(NSString *)getResponseTypeWithDict:(NSDictionary *)dict;
+(NSString *)getResponseKey:(NSString *)key intDataDict:(NSDictionary *)dict;
/*
 * 存储账号密码
 */
+(void)saveAccount:(NSString *)account password:(NSString *)password;
+(void)deleteAccount:(NSString *)account password:(NSString *)password;
/*
 * 获取存储的账号密码
 */
+(WanAccountModel *)getRencentlyAccount;
+(NSMutableArray *)getAllSavedAccount;

//根据Plist文件配置判断是否为上架包1：是  0否
+(BOOL)isAppStore;
//根据Plist文件配置获取渠道号
+(NSString *)channelID;
//根据key值获取Plist文件配置参数
+(NSString *)getConfigWithKey:(NSString *)key;

/*
 * 图片模糊化
 */
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
/*
 * 图片透明化
 */
+(UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image;

/*
 * 编码URLEncodedString/解码URLDecodedString
 */
+(NSString *)URLEncodedString:(NSString *)str;
+(NSString *)URLDecodedString:(NSString *)str;

@end
