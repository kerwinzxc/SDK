//
//  WanServer.h
//  SDK_51WanSY
//
//  Created by Star on 2018/1/23.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanNetManager.h"
#import "WanAccountModel.h"

@interface WanServer : WanNetManager

@property (nonatomic, strong) WanAccountModel *accountModel;

//登录
-(BOOL)loginRequestWithUserName:(NSString *)userName passWord:(NSString *)password validType:(NSString *)validType loginType:(NSString *)loginType gameid:(NSString *)gameid success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield;
//是否显示注册按钮
-(BOOL)isShowRegistBtnWithGameID:(NSString *)gameid success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield;
//注册
-(BOOL)registRequestWithUserName:(NSString *)userName passWord:(NSString *)password registType:(NSString *)registType channelid:(NSString *)channelid gameid:(NSString *)gameid success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield;
//快速注册
-(BOOL)quickRegestWithType:(NSString *)registType channelid:(NSString *)channelid gameid:(NSString *)gameid success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield;
//获取验证码
-(BOOL)getValidCodeRequestWithPhone:(NSString *)phone veriType:(NSString *)veriType userName:(NSString *)userName success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield;
//修改密码
-(BOOL)moddifyRequestWithUserName:(NSString *)userName passWord:(NSString *)password validCode:(NSString *)validCode gameid:(NSString *)gameid success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield;
//绑定手机号码
-(BOOL)bindPhoneRequestWithPhoneNum:(NSString *)phoneNum uid:(NSString *)uid verify:(NSString *)verify realName:(NSString *)realName idCard:(NSString *)idcard success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield;
//上报游戏角色信息
-(BOOL)uploadUID:(NSString *)uid gameID:(NSString *)uid serverID:(NSString *)server_id serverName:(NSString *)serverName roleName:(NSString *)roleName roleLevel:(NSString *)roleLevel RequesSuccess:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield;
//获取配置信息
-(BOOL)getSDKConfigWithGameID:(NSString *)gameID RequesSuccess:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield;
//支付预订单
-(BOOL)getOrderWithPayType:(NSString *)payType goodsName:(NSString *)goodsName cpData:(NSString *)cpData money:(NSString *)money gameid:(NSString *)gameid gain:(NSString *)gain uid:(NSString *)uid serverid:(NSString *)serverid roleName:(NSString *)roleName desc:(NSString *)desc success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield;
//应用内支付验证订单
-(BOOL)checkWithOrderNo:(NSString *)orderNo receipt:(NSString *)receipt success:(SuccessBlock)successBlock failed:(AFNErrorBlock)faield;
@end
