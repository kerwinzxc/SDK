//
//  WanQuickRegestView.h
//  SDK_51WanSY
//
//  Created by Star on 2018/1/23.
//  Copyright © 2018年 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WanQuickRegestView : WanBaseView

@property (nonatomic, strong) WanAccountModel *model;

@property (nonatomic, weak) id<WanViewActionDelegate> delegate;

@end
