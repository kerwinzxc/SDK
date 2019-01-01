//
//  WanPayView.m
//  SDK_51WanSY
//
//  Created by star on 2018/9/11.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanPayView.h"
#import "WanPayTableViewCell.h"

#define payTableViewCellIdentify @"WanPayTableViewCellIdentify"

@interface WanPayView()<UITableViewDelegate, UITableViewDataSource>
{
    WanLabel *_line;
    UIView *_mainView;
    UIButton *_payBtn;
    UILabel *_priceValueLabel;
    UILabel *_discountLabel;
    NSInteger _initialRowNum;
}

@property (nonatomic, assign) BOOL isShowAllPayChannel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WanPayView

-(instancetype)initWithFrame:(CGRect)frame withPayModel:(WanPayModel *)payModel{
    if (self = [super initWithFrame:frame]) {
        _payModel = payModel;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    _initialRowNum = [WanSDKConfig shareInstance].payChannelsArr.count > 2 ? 2 : [WanSDKConfig shareInstance].payChannelsArr.count;
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 325, 180*kRetio+44*_initialRowNum+32)];
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.layer.cornerRadius = 6;
    _mainView.clipsToBounds = YES;
    _mainView.center = self.center;
    [self addSubview:_mainView];
    //支付订单
    WanLabel *titleLabel = [[WanLabel alloc] initPayTitleLabelWithFrame:CGRectMake(0, 0, _mainView.width, 44*kRetio) title:@"支付订单"];
    [_mainView addSubview:titleLabel];
    //分割线
    WanLabel *lineLabel = [[WanLabel alloc] initPayLineWithFrame:CGRectMake(0, titleLabel.bottom, _mainView.width, 0.5)];
    [_mainView addSubview:lineLabel];
    //订单金额
    UILabel *orderPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, lineLabel.bottom, _mainView.width, 44*kRetio)];
    [_mainView addSubview:orderPriceLabel];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(WanPayLeftMargin, 0, (_mainView.width-2*WanPayLeftMargin)/2.0, orderPriceLabel.height)];
    priceLabel.text = @"订单金额";
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.textColor = [UIColor blackColor];
    [orderPriceLabel addSubview:priceLabel];
    
    if ([WanSDKConfig shareInstance].discount == 1) {
        _priceValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.right, 0, priceLabel.width, orderPriceLabel.height)];
        _priceValueLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.payModel.money floatValue]];;
        _priceValueLabel.textAlignment = NSTextAlignmentRight;
        _priceValueLabel.textColor = [UIColor redColor];
        [orderPriceLabel addSubview:_priceValueLabel];
    }else{
        _priceValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.right, 0, priceLabel.width, orderPriceLabel.height/2.0)];
        _priceValueLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.payModel.money floatValue]];
        _priceValueLabel.textAlignment = NSTextAlignmentRight;
        _priceValueLabel.textColor = [UIColor redColor];
        [orderPriceLabel addSubview:_priceValueLabel];
        
        _discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.right, _priceValueLabel.bottom, priceLabel.width, orderPriceLabel.height/2.0)];
        _discountLabel.text = [NSString stringWithFormat:@"优惠:  %.1f折", [WanSDKConfig shareInstance].discount];
        _discountLabel.textAlignment = NSTextAlignmentRight;
        _discountLabel.textColor = [UIColor redColor];
        [orderPriceLabel addSubview:_discountLabel];
    }
    
    //分割线
    _line = [[WanLabel alloc] initPayLineWithFrame:CGRectMake(0, orderPriceLabel.bottom, _mainView.width, 10*kRetio)];
    [_mainView addSubview:_line];
    
    [_mainView addSubview:self.tableView];
    
    _payBtn = [[UIButton alloc] initWithFrame:CGRectMake(25.0f, self.tableView.bottom + 20*kRetio, _mainView.width-2*25, 44*kRetio)];
    [_payBtn setBackgroundColor:[UIColor colorWithHexString:@"3399ff"]];
    [_payBtn setTitle:[NSString stringWithFormat:@"确认支付: ￥%.2f", [self.payModel.money floatValue]*[WanSDKConfig shareInstance].discount] forState:UIControlStateNormal];
    [_payBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _payBtn.layer.cornerRadius = 6;
    [_payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_payBtn];
}

#pragma mark ----getter selector
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _line.bottom, _mainView.width, 44*_initialRowNum+32) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = WanPayLineColor;
        _tableView.bounces = NO;
        [_tableView registerClass:[WanPayTableViewCell class] forCellReuseIdentifier:payTableViewCellIdentify];
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return _tableView;
}

#pragma mark ---<UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isShowAllPayChannel || [WanSDKConfig shareInstance].payChannelsArr.count < 2){
        return [WanSDKConfig shareInstance].payChannelsArr.count;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WanPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:payTableViewCellIdentify];
    cell.payTypeModel = [WanSDKConfig shareInstance].payChannelsArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(!_isShowAllPayChannel && [WanSDKConfig shareInstance].payChannelsArr.count > 2){
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mainView.width, 32*kRetio)];
        WanLabel *lineLabel = [[WanLabel alloc] initPayLineWithFrame:CGRectMake(0, 0, _mainView.width, 1)];
        [footView addSubview:lineLabel];
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, lineLabel.bottom, _mainView.width, 30*kRetio)];
        [moreBtn setTitle:@"查看更多支付的方式 V" forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [moreBtn setTitleColor:WanPayDescColor forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(morePayType:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:moreBtn];
        
        WanLabel *bottomLineLabel = [[WanLabel alloc] initPayLineWithFrame:CGRectMake(0, moreBtn.bottom, _mainView.width, 1)];
        [footView addSubview:bottomLineLabel];
        return footView;
    }else{
        WanLabel *bottomLineLabel = [[WanLabel alloc] initPayLineWithFrame:CGRectMake(0, 0, _mainView.width, 1)];
        return bottomLineLabel;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(!_isShowAllPayChannel){
        return 32*kRetio;
    }else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WanPayTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isChoose = YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    WanPayTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isChoose = NO;
}

#pragma mark ----self action
-(void)morePayType:(UIButton *)btn{
    _isShowAllPayChannel = YES;
    _tableView.height = [WanSDKConfig shareInstance].payChannelsArr.count >= 4 ? 44*4:44*[WanSDKConfig shareInstance].payChannelsArr.count;
    _mainView.height = 180*kRetio+_tableView.height;
    _mainView.center = self.center;
    [_tableView reloadData];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    _payBtn.top = _tableView.bottom+20;
}

-(void)pay{
    NSIndexPath *indexPath = _tableView.indexPathForSelectedRow;
    if (indexPath == nil) {
        [WanProgressHUD showMessage:@"请先选择支付方式"];
        return;
    }
    WanPayTypeModel *payTypeModel = [WanSDKConfig shareInstance].payChannelsArr[indexPath.row];
    if (self.delegate && [_delegate respondsToSelector:@selector(payWithPayTypeModel:withPayModel:)]) {
        [_delegate payWithPayTypeModel:payTypeModel withPayModel:self.payModel];
    }
}


@end
