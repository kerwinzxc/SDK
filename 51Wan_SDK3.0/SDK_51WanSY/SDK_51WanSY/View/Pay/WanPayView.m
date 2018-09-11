//
//  WanPayView.m
//  SDK_51WanSY
//
//  Created by star on 2018/9/11.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanPayView.h"

@interface WanPayView()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WanPayView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    //支付订单
    WanLabel *titleLabel = [[WanLabel alloc] initPayTitleLabelWithFrame:CGRectMake(0, 0, self.width, 44*kRetio) title:@"支付订单"];
    [self addSubview:titleLabel];
    //分割线
    WanLabel *lineLabel = [[WanLabel alloc] initLineWithFrame:CGRectMake(0, titleLabel.bottom, self.width, 0.5)];
    [self addSubview:lineLabel];
    //订单金额
    UILabel *orderPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, lineLabel.bottom, self.width, 44*kRetio)];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(WanPayLeftMargin, 0, (self.width-2*WanPayLeftMargin)/2.0, orderPriceLabel.height)];
    priceLabel.text = @"订单金额";
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.textColor = [UIColor blackColor];
    [orderPriceLabel addSubview:priceLabel];
    
    UILabel *priceValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.right, 0, priceLabel.width, orderPriceLabel.height)];
    priceValueLabel.text = @"￥1000.00";
    priceValueLabel.textAlignment = NSTextAlignmentRight;
    priceValueLabel.textColor = [UIColor blackColor];
    [orderPriceLabel addSubview:priceValueLabel];
    
    //分割线
    lineLabel = [[WanLabel alloc] initLineWithFrame:CGRectMake(0, orderPriceLabel.bottom, self.width, 10*kRetio)];
    [self addSubview:lineLabel];
    
    
}

#pragma mark ----getter selector
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [UITableView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    }
    return _tableView;
}

@end
