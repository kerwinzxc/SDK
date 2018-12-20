//
//  WanPayViewController.m
//  SDK_51WanSY
//
//  Created by star on 2018/9/11.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanPayViewController.h"
#import "WanPayView.h"

@interface WanPayViewController (){
    WanPayView *_payView;
}

@end

@implementation WanPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setPayModel:(WanPayModel *)payModel{
    _payModel = payModel;
    _payView = [[WanPayView alloc] initWithFrame:self.view.bounds withPayModel:_payModel];
    [self.view addSubview:_payView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
