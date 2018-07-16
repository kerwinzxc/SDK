//
//  WanBaseViewController.h
//  SDK_51WanSY
//
//  Created by Star on 2018/1/22.
//  Copyright © 2018年 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ClickButtonType){
    ClickButtonTypeClose = 0,
    ClickButtonTypeLogin,
    ClickButtonTypeRegest,
    ClickButtonTypeModdifyPassword,
    ClickButtonTypeQuickRegest,
    ClickButtonTypePreventAddiction,
    ClickButtonTypeGotoRegest,
    ClickButtonTypeGotoModdifyPassword,
    ClickButtonTypeGotoLogin
};

#pragma mark ---WanLoginViewActionDelegate
@protocol WanViewActionDelegate <NSObject>

-(void)viewClickActionType:(ClickButtonType)type withAccountModel:(WanAccountModel *)accountModel;

@end

@interface WanBaseViewController : UIViewController


@end
