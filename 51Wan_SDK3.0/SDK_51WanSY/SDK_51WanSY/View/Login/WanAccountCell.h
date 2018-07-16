//
//  WanAccountCell.h
//  SDK_51WanSY
//
//  Created by Star on 2018/1/16.
//  Copyright © 2018年 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WanAccountCell : UITableViewCell

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) void(^deleteAccountBlock)(void);
@property (nonatomic, copy) void(^selectedAccountBlock)(void);
@end
