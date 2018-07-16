//
//  WanPopView.h
//  SDK_51WanSY
//
//  Created by Star on 2018/1/30.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanBaseView.h"

@interface WanPopView : WanBaseView

@property (nonatomic, weak) id<WanViewActionDelegate> delegate;

@property (nonatomic, strong) WanAccountModel *model;

@end
