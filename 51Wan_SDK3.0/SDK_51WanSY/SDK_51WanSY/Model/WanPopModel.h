//
//  WanPopModel.h
//  SDK_51WanSY
//
//  Created by Star on 2018/1/24.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanBaseModel.h"

@interface WanPopModel : WanBaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *img_url;

@property (nonatomic, copy) NSString *jump_url;

@property (nonatomic, copy) NSString *memo;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
