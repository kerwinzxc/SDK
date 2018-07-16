//
//  WanToolItemCell.m
//  WanAppStroeSDK
//
//  Created by Star on 2017/6/9.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import "WanToolItemCell.h"
#import "WanUtils.h"
#import "UIView+Frame.h"
#import "UIImageView+AFNetworking.h"

@interface WanToolItemCell()
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
}

@end

@implementation WanToolItemCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor = [UIColor clearColor];
    //图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.bottom, self.width, 25)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_titleLabel];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setItemModel:(WanTipItemModel *)itemModel{
    if (itemModel) {
        _itemModel = itemModel;
        _imageView.image = [WanUtils imageInBundelWithName:itemModel.image];
        _imageView.highlightedImage = [WanUtils imageInBundelWithName:itemModel.selectImage];
        _titleLabel.text = itemModel.title;
    }
}

-(void)drawRect:(CGRect)rect{
    _imageView.center = CGPointMake(self.width/2.0, self.height/2.0-12.5);
    _titleLabel.top = _imageView.bottom;
    _titleLabel.center = CGPointMake(self.width/2.0, _titleLabel.centerY);
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selected) {
        _imageView.image = [WanUtils imageInBundelWithName:_itemModel.selectImage];
    }else{
        _imageView.image = [WanUtils imageInBundelWithName:_itemModel.image];
    }
}

@end
