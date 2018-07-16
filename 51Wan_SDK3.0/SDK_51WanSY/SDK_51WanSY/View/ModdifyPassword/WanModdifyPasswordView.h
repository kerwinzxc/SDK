//
//  WanModdifyPasswordView.h
//  Wan669SDKDemo
//
//  Created by liuluoxing on 2017/2/21.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WanModdifyPasswordView : WanBaseView

@property (nonatomic, weak) id<WanViewActionDelegate> delegate;
@property (nonatomic, strong) WanAccountModel *model;

@end
