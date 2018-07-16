//
//  WanAccountCell.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/16.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanAccountCell.h"
#import "UIView+Frame.h"
#import "WanUtils.h"

@interface WanAccountCell()
{
    UIButton *_accountBtn;
    UIButton *_deleteBtn;
}


@end

@implementation WanAccountCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _deleteBtn.frame = CGRectMake(self.width-14-10, (self.height-14)/2.0, 14, 14);
}

-(void)initUI{
    self.backgroundColor = [UIColor clearColor];
    
    _accountBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, self.width-10-54, 44)];
    _accountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_accountBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_accountBtn addTarget:self action:@selector(selectAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_accountBtn];
    
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-60, (self.height-14)/2.0, 14, 14)];
    [_deleteBtn setBackgroundImage:[WanUtils imageInBundelWithName:@"delete"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
}

-(void)setAccount:(NSString *)account{
    _account = account;
    [_accountBtn setTitle:account forState:UIControlStateNormal];
}

-(void)setPassword:(NSString *)password{
    _password = password;
}

-(void)delete:(UIButton *)btn{
    [WanUtils deleteAccount:self.account password:self.password];
    if (self.deleteAccountBlock) {
        self.deleteAccountBlock();
    }
}

-(void)selectAccount:(UIButton *)btn{
    if (self.selectedAccountBlock) {
        self.selectedAccountBlock();
    }
}

@end
