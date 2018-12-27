//
//  ViewController.m
//  SDK_51WanSY_Test
//
//  Created by Star on 2018/1/2.
//  Copyright © 2018年 Star. All rights reserved.
//
#import "ViewController.h"
#import "SDK_51WanSY/SDK_51WanSY.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <WanManagerDelegate>
{
    UIButton *registBtn1;
    UIButton *registBtn2;
}

@property (nonatomic, copy)  NSString *gameID;
@property (nonatomic, copy)  NSString *uid;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameID = @"30";
    self.uid = @"246360";
    [self initUI];
}

-(void)initUI{
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *initBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 100, 30)];
    [initBtn setTitle:@"初始化SDK" forState:UIControlStateNormal];
    [initBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    initBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [initBtn addTarget:self action:@selector(initSDK:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:initBtn];
    
    UIButton *registBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 80, 100, 30)];
    [registBtn setTitle:@"登录测试" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [registBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    registBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 120, 100, 30)];
    [registBtn1 setTitle:@"显示悬浮窗" forState:UIControlStateNormal];
    [registBtn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    registBtn1.titleLabel.font = [UIFont systemFontOfSize:15];
    [registBtn1 addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn1];
    
    registBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(300, 120, 100, 30)];
    [registBtn2 setTitle:@"关闭悬浮窗" forState:UIControlStateNormal];
    [registBtn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    registBtn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [registBtn2 addTarget:self action:@selector(hiden:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn2];
    
    UIButton *registBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(100, 160, 100, 30)];
    [registBtn4 setTitle:@"支付测试" forState:UIControlStateNormal];
    [registBtn4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    registBtn4.titleLabel.font = [UIFont systemFontOfSize:15];
    [registBtn4 addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn4];
    
    UIButton *registBtn5 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 30)];
    [registBtn5 setTitle:@"上传游戏数据" forState:UIControlStateNormal];
    [registBtn5 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    registBtn5.titleLabel.font = [UIFont systemFontOfSize:15];
    [registBtn5 addTarget:self action:@selector(uploadData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn5];
}

-(void)initSDK:(UIButton *)btn{
    [[WanManager shareInstance] initSDKWithGameID:self.gameID delegate:self];
}

-(void)login:(UIButton *)btn{
    [[WanManager shareInstance] showLoginView];
}

-(void)hiden:(UIButton *)btn{
    [[WanManager shareInstance] hidenTip];
    registBtn1.enabled = YES;
}

-(void)show:(UIButton *)btn{
    [[WanManager shareInstance] showTipWithUid:self.uid];
    btn.enabled = NO;
}

-(void)pay{
    //com.669.zhanqiankun.60
    WanPayModel *payModel = [[WanPayModel alloc] init];
    payModel.goodsName = @"商品名称";//商品名称
    payModel.money = @"0.01";//充值金额
    payModel.balance = @"0";//余额
    payModel.cpData = @"ry9tkf7nrqw86bm2mbtb4ynanxnncqum";//厂商透传信息
    payModel.gameid = self.gameID;//游戏id
    payModel.gain= @"60";//元宝数
    payModel.uid= self.uid;//用户id
    payModel.serverid = @"0";//区服id
    payModel.roleName = @"刘落星";//游戏角色名
    payModel.desc = @"aa";//商品描述
    payModel.productID = @"com.669.zhanqiankun.60";//产品在iTunes中的id
    [[WanManager shareInstance] payWithPayModel:payModel];
}

-(void)uploadData:(UIButton *)btn{
    [[WanManager shareInstance] uploadUid:self.uid serverID:@"1" serverName:@"asdfaf" roleName:@"asdfa" roleLevel:@"17"];
}


-(void)wanSDKReturnResult:(NSDictionary *)result forType:(WanSDKReturnResultType)type{
    NSLog(@"result = %@,type = %zd", result, type);
    if (type == WanSDKReturnResultTypeSDKConfig) {
        
    }
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

/**
 *  设置特殊的界面支持的方向
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

//- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    NSLog(@"----开始摇动");
//    return;
//}
//
//- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    NSLog(@"----取消摇动");
//    return;
//}
//
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
//        NSLog(@"----摇动结束");
//    }
//    return;
//}

@end
