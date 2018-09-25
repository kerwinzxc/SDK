//
//  WanPayTableViewCell.h
//  SDK_51WanSY
//
//  Created by star on 2018/9/12.
//  Copyright © 2018年 Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WanPayTypeModel.h"

@interface WanPayTableViewCell : UITableViewCell

@property (nonatomic, strong) WanPayTypeModel *payTypeModel;

@property (nonatomic, assign) BOOL isChoose;

@end
