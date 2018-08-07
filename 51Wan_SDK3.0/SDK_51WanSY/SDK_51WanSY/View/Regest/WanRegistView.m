//
//  WanRegistView.m
//  Wan669SDKDemo
//
//  Created by liuluoxing on 2017/2/20.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import "WanRegistView.h"
#import "UILabel+AttributeTextTapAction.h"

@interface WanRegistView()<UITextFieldDelegate>
{
    WanTextField *_accountTextField;//手机号
    WanTextField *_pdTextField;//验证码
    UIButton * _agreeBtn;//勾选框
}

@end

@implementation WanRegistView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    //快速注册
    WanLabel *title = [[WanLabel alloc] initTitleLabelWithFrame:CGRectMake(WanTextFieldLeftMargin, 0, 150, WanTitleLabelHeight*kRetio) title:@"用户注册"];
    [self addSubview:title];

    //分割线条
    WanLabel *line = [[WanLabel alloc] initLineWithFrame:CGRectMake(0, title.bottom, self.width, WanLineLabelHeight)];
    [self addSubview:line];
    
    //账号
    _accountTextField = [[WanTextField alloc] initWithFrame:CGRectMake(WanTextFieldLeftMargin, line.bottom+20*kRetio, self.width-2*WanTextFieldLeftMargin, WanTextFieldHeight*kRetio)];
    [_accountTextField setPlaceHolder:@"请输入您的用户名"];
    [_accountTextField setLeftViewWithImageName:@"account"];
    _accountTextField.delegate = self;
    [self addSubview:_accountTextField];
    
    //密码
    _pdTextField = [[WanTextField alloc] initWithFrame:CGRectMake(_accountTextField.left, _accountTextField.bottom+WanTextFieldMargin, _accountTextField.width, WanTextFieldHeight*kRetio)];
    [_pdTextField setPlaceHolder:@"请输入您的密码"];
    [_pdTextField setLeftViewWithImageName:@"password"];
    _pdTextField.secureTextEntry = YES;
    _pdTextField.delegate = self;
    [self addSubview:_pdTextField];
    
    //注册
    WanButton *loginBtn = [[WanButton alloc] initWithFrame:CGRectMake(_pdTextField.left, _pdTextField.bottom+30*kRetio, _pdTextField.width, 44*kRetio) title:@"注册" target:self action:@selector(regist:) titleFoneSize:16.0 titleColor:WanWhiteColor bgColor:WanButtonBgColor];
    [self addSubview:loginBtn];

    //协议选项
    NSString *str = @"我同意我要玩手游《新用户协议》";
    CGSize size = [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName, nil]];
    //勾选框
    _agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.width-size.width-25)/2.0, loginBtn.bottom + 15, 15, 15)];
    [_agreeBtn setImage:[WanUtils imageInBundelWithName:@"unselected"] forState:UIControlStateNormal];
    [_agreeBtn setImage:[WanUtils imageInBundelWithName:@"selected"] forState:UIControlStateSelected];
    [_agreeBtn setSelected:YES];
    [_agreeBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_agreeBtn];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#00a0e9"] range:NSMakeRange(8, 7)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#aba9ab"] range:NSMakeRange(0, 8)];
    UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_agreeBtn.right+3, _agreeBtn.top, size.width, 25)];
    agreeLabel.centerY = _agreeBtn.centerY;
    agreeLabel.textAlignment = NSTextAlignmentCenter;
    agreeLabel.attributedText = attrStr;
    agreeLabel.font = [UIFont systemFontOfSize:12];
    [agreeLabel yb_addAttributeTapActionWithStrings:@[@"《新用户协议》"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        if ([NSString isNotEmpty:[WanSDKConfig shareInstance].dealUrl]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WanSDKConfig shareInstance].dealUrl]];
        }
    }];
    [self addSubview:agreeLabel];
    
    //返回登录
    str = @"返回登录";
    size = [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-size.width-15)/2.0, agreeLabel.bottom+15*kRetio, 15, 15)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [WanUtils imageInBundelWithName:@"back"];
    [self addSubview:imageView];
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+3, imageView.top, size.width, imageView.height)];
    backLabel.text = str;
    backLabel.textColor = [UIColor whiteColor];
    backLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:backLabel];
    
    UIButton *control = [[UIButton alloc] initWithFrame:CGRectMake(imageView.left, imageView.top-5, imageView.width+backLabel.width, imageView.height+10)];
    [control addTarget:self action:@selector(backToLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
}

#pragma btn acction
//注册
-(void)regist:(UIButton *)btn{
    if ([NSString isEmpty:_accountTextField.text]) {
        [WanProgressHUD showFailure:@"请先输入账号"];
        return;
    }else if ([NSString isEmpty:_pdTextField.text]){
        [WanProgressHUD showFailure:@"请先输入密码"];
        return;
    }else if (!_agreeBtn.selected){
        [WanProgressHUD showFailure:@"请先确认新用户协议"];
        return;
    }
    //开始注册
    if (self.delegate && [_delegate respondsToSelector:@selector(viewClickActionType:withAccountModel:)]) {
        WanAccountModel *model = [[WanAccountModel alloc] init];
        model.account = _accountTextField.text;
        model.password = _pdTextField.text;
        [_delegate viewClickActionType:ClickButtonTypeRegest withAccountModel:model];
    }
}

//返回登录
-(void)backToLogin{
    if (self.delegate && [_delegate respondsToSelector:@selector(viewClickActionType:withAccountModel:)]) {
        [_delegate viewClickActionType:ClickButtonTypeGotoLogin withAccountModel:nil];
    }
}

#pragma mark --switchAction
-(void)switchAction:(UISwitch *)switchBtn{
    BOOL isButtonOn = [switchBtn isOn];
    if (isButtonOn) {
        _pdTextField.secureTextEntry = NO;
    }else {
        _pdTextField.secureTextEntry = YES;
    }
}

-(void)click:(UIButton *)btn{
    btn.selected = !btn.isSelected;
}

#pragma mark --<UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//不能输入空格
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

@end
