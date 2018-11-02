//
//  WanPayViewController.m
//  SDK_51WanSY
//
//  Created by star on 2018/9/11.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanPayViewController.h"
#import "WanPayView.h"

@interface WanPayViewController ()

@end

@implementation WanPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPayView];
}

-(void)initPayView{
    WanPayView *payView = [[WanPayView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:payView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end