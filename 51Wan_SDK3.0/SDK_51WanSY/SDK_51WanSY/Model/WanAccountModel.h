//
//  WanAccountModel.h
//  SDK_51WanSY
//
//  Created by Star on 2018/1/26.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanBaseModel.h"
#import "WanPopModel.h"

@interface WanAccountModel : WanBaseModel

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *game_id;
@property (nonatomic, copy) NSString *valicode;
@property (nonatomic, copy) NSString *phoneNo;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *id_card;
@property (nonatomic, copy) NSString *card;
@property (nonatomic, copy) NSString *channelID;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *ticket;
@property (nonatomic, copy) NSString *isAdult;//0未成年1成年
@property (nonatomic, assign) BOOL isShowPhoneView;

@end
