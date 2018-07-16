//
//  WanPreventAddictionView.h
//  SDK_51WanSY
//
//  Created by Star on 2018/1/23.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanBaseView.h"

@interface WanPreventAddictionView : WanBaseView

@property (nonatomic, weak) id<WanViewActionDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame withModel:(WanAccountModel *)model;

@end
