//
//  WanLoginViewController.h
//  SDK_51WanSY
//
//  Created by Star on 2018/1/22.
//  Copyright © 2018年 Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WanBaseViewController.h"
#import "WanManagerDelegate.h"

@interface WanLoginViewController : WanBaseViewController

@property (nonatomic, copy) NSString *gameid;
@property (nonatomic, weak) id<WanManagerDelegate> delegate;

@end
