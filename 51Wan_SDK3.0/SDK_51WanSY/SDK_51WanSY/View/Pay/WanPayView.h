//
//  WanPayView.h
//  SDK_51WanSY
//
//  Created by star on 2018/9/11.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanBaseView.h"
#import "WanPayModel.h"

@interface WanPayView : WanBaseView

@property (nonatomic, strong) WanPayModel *payModel;

@property (nonatomic, weak) id<WanPayActionDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame withPayModel:(WanPayModel *)payModel;

@end
