//
//  WanRegistView.m
//  Wan669SDKDemo
//
//  Created by liuluoxing on 2017/2/20.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import "WanRegistView.h"

@interface WanRegistView()<UITextFieldDelegate>
{
    WanTextField *_accountTextField;//手机号
    WanTextField *_pdTextField;//验证码
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

    //返回登录
    WanButton *backLoginBtn = [[WanButton alloc] initWithFrame:CGRectMake(loginBtn.left, loginBtn.bottom+15*kRetio, loginBtn.width, 25.0) title:@"返回登录" image:[WanUtils imageInBundelWithName:@"back"] imgSize:CGSizeMake(15, 15) target:self action:@selector(backToLogin:) titleFoneSize:15.0 titleColor:WanWhiteColor bgColor:[UIColor clearColor]];
    [self addSubview:backLoginBtn];
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
-(void)backToLogin:(UIButton *)btn{
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
