//
//  WanPayViewController.h
//  SDK_51WanSY
//
//  Created by star on 2018/9/11.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanBaseViewController.h"
#import "WanPayModel.h"

@interface WanPayViewController : WanBaseViewController

@property (nonatomic, strong) WanPayModel *payModel;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication
         annotation:(id)annotation;
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;

@end
