//
//  WanBaseModel.m
//  Wan669SDKDemo
//
//  Created by liuluoxing on 2017/2/21.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import "WanBaseModel.h"

@implementation WanBaseModel

-(id)initWithDictionary:(NSDictionary *)dict {
    if ( self = [super init]) {
        NSEnumerator *enumerator = [dict keyEnumerator];
        id key;
        while ((key = [enumerator nextObject])) {
            id object = dict[key];
            if (object && ![object isKindOfClass:[NSNull class]]) {
                if ([key isEqualToString:@"id"]) {
                    [self setValue:object forKey:[NSString stringWithFormat:@"%@", @"uid"]];
                } else if ([key isEqualToString:@"name"]) {
                    [self setValue:object forKey:[NSString stringWithFormat:@"%@", @"account"]];
                } else
                    [self setValue:object forKey:[NSString stringWithFormat:@"%@", key]];
            }
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    NSLog(@"Undefined Key: %@", key);
}

@end
