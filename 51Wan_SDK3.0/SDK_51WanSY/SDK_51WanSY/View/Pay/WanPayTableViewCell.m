//
//  WanPayTableViewCell.m
//  SDK_51WanSY
//
//  Created by star on 2018/9/12.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanPayTableViewCell.h"

@interface WanPayTableViewCell(){
    UIImageView *_imgView;
    UILabel *_titleLabel;
    UILabel *_descLabel;
    UIImageView *_selectImgView;
}

@end

@implementation WanPayTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initUI];
    }
    return self;
}

-(void)initUI{
    //image
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(WanPayLeftMargin, 7.0, 30, 30)];
    [self addSubview:_imgView];
    //支付方式title
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.right+5, _imgView.top, 200.0, 20.0)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLabel];
    //支付方式desc
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.right+5, _titleLabel.bottom, 200.0, 10.0)];
    _descLabel.font = [UIFont systemFontOfSize:10];
    _descLabel.textColor = WanPayDescColor;
    _descLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_descLabel];
    
    //勾选按钮
    _selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-WanPayLeftMargin-18, (self.height-18)/2.0, 18, 18)];
    _selectImgView.image = [WanUtils imageInBundelWithName:@"disselected"];
//    [_selectBtn setBackgroundImage:[WanUtils imageInBundelWithName:@"disselected"] forState:UIControlStateNormal];
//    [_selectBtn setBackgroundImage:[WanUtils imageInBundelWithName:@"selected"] forState:UIControlStateSelected];
//    [_selectBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
//    _selectBtn.selected = NO;
    [self addSubview:_selectImgView];
}


-(void)setPayTypeModel:(WanPayTypeModel *)payTypeModel{
    _payTypeModel = payTypeModel;
    _imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_payTypeModel.imgUrl]]];
    _titleLabel.text = [NSString stringWithFormat:@"%@", _payTypeModel.payTitle];
    _descLabel.text = [NSString stringWithFormat:@"%@", _payTypeModel.payDesc];
}

-(void)setIsChoose:(BOOL)isChoose{
    _isChoose = isChoose;
    if (_isChoose) {
        _selectImgView.image = [WanUtils imageInBundelWithName:@"selected"];
    }else{
        _selectImgView.image = [WanUtils imageInBundelWithName:@"disselected"];
    }
}

-(void)setSelected:(BOOL)selected{
    _isChoose = selected;
    self.isChoose = selected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
