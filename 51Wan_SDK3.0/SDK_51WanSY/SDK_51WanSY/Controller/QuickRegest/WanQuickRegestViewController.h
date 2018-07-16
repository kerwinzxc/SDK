//
//  WanQuickRegestViewController.h
//  SDK_51WanSY
//
//  Created by Star on 2018/1/23.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanBaseViewController.h"

typedef void(^LoginClickBlock)(WanAccountModel *model);

@interface WanQuickRegestViewController : WanBaseViewController

@property (nonatomic, strong) WanAccountModel *model;
@property (nonatomic, copy) LoginClickBlock loginClickBlock;
@end
