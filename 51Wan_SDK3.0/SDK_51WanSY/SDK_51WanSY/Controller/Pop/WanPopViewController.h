//
//  WanPopViewController.h
//  SDK_51WanSY
//
//  Created by Star on 2018/1/25.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanBaseViewController.h"

typedef void(^ClosePopBlock)(void);

@interface WanPopViewController : WanBaseViewController

@property (nonatomic, copy) ClosePopBlock closePopBlock;

@end
