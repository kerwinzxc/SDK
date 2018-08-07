  //
//  WanModdifyPasswordView.m
//  Wan669SDKDemo
//
//  Created by liuluoxing on 2017/2/21.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import "WanModdifyPasswordView.h"
#import "WanServer.h"

@interface WanModdifyPasswordView()<UITextFieldDelegate>
{
    WanTextField *_accountTextField;//账号
    WanTextField *_validTextField;//验证码
    WanTextField *_passwordTextField;//密码
    UIButton *_validCodeBtn;//获取验证码
    NSInteger _time;
}

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WanModdifyPasswordView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    //忘记密码
    WanLabel *title = [[WanLabel alloc] initTitleLabelWithFrame:CGRectMake(WanTextFieldLeftMargin, 0, 150, WanTitleLabelHeight*kRetio) title:@"忘记密码"];
    [self addSubview:title];
    
    //关闭按钮
    WanButton *closeBtn = [[WanButton alloc] initCloseBtnWithFrame:CGRectMake(self.width-WanCloseBtnWidth-WanCloseBtnMargin, WanCloseBtnMargin, WanCloseBtnWidth, WanCloseBtnWidth) target:self action:@selector(close:)];
    [self addSubview:closeBtn];
    
    //分割线条
    WanLabel *line = [[WanLabel alloc] initLineWithFrame:CGRectMake(0, title.bottom, self.width, WanLineLabelHeight)];
    [self addSubview:line];
    
    //账号
    _accountTextField = [[WanTextField alloc] initWithFrame:CGRectMake(WanTextFieldLeftMargin, line.bottom+20*kRetio, self.width-2*WanTextFieldLeftMargin, WanTextFieldHeight*kRetio)];
    [_accountTextField setPlaceHolder:@"账号"];
    [_accountTextField setLeftViewWithImageName:@"account"];
    _accountTextField.delegate = self;
    [self addSubview:_accountTextField];
    //验证码
    _validTextField = [[WanTextField alloc] initWithFrame:CGRectMake(WanTextFieldLeftMargin, _accountTextField.bottom+WanTextFieldMargin, _accountTextField.width, WanTextFieldHeight*kRetio)];
    [_validTextField setPlaceHolder:@"验证码"];
    [_validTextField setLeftViewWithImageName:@"valicode"];
    _validCodeBtn = [_validTextField setValicodeViewWithTitle:@"点击获取" target:self action:@selector(validCode:)];
    _validTextField.delegate = self;
    [self addSubview:_validTextField];
    //密码
    _passwordTextField = [[WanTextField alloc] initWithFrame:CGRectMake(_validTextField.left, _validTextField.bottom+WanTextFieldMargin, _validTextField.width, WanTextFieldHeight*kRetio)];
    [_passwordTextField setPlaceHolder:@"请输入新密码"];
    [_passwordTextField setLeftViewWithImageName:@"password"];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    [self addSubview:_passwordTextField];
    
    //确认提交
    WanButton *submitBtn = [[WanButton alloc] initWithFrame:CGRectMake(_passwordTextField.left, _passwordTextField.bottom+30*kRetio, _passwordTextField.width, 44*kRetio) title:@"确认" target:self action:@selector(moddify:) titleFoneSize:16.0 titleColor:WanWhiteColor bgColor:WanButtonBgColor];
    [self addSubview:submitBtn];
}

#pragma btn acction
-(void)validCode:(UIButton *)btn{
    if ([NSString isEmpty:_accountTextField.text]) {
        [WanProgressHUD showMessage:@"请先输入账号"];
        return;
    }
    //获取验证码
    WanServer *server = [[WanServer alloc] init];
    [server getValidCodeRequestWithPhone:@"" veriType:@"2" userName:_accountTextField.text success:^(NSDictionary *dict, BOOL success) {
        if (!success) {
            [WanProgressHUD showFailure:[WanUtils getResponseMsgWithDict:dict]];
            [self getValiCodeComplete];
        }
    } failed:^(NSError *error) {
        [self getValiCodeComplete];
        [WanProgressHUD showFailure:@"获取验证码失败，请重试"];
    }];
    
    btn.enabled = NO;
    _time = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendValidCode) userInfo:nil repeats:YES];
}

-(void)sendValidCode{
    _time--;
    if (_time >= 0) {
        [_validCodeBtn setTitle:[NSString stringWithFormat:@"倒计时(%zd)", _time] forState:UIControlStateNormal];
    }else{
        [_timer invalidate];
        _validCodeBtn.enabled = YES;
        [_validCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

-(void)getValiCodeComplete{
    [_validCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _validCodeBtn.enabled = YES;
    [_timer invalidate];
}

-(void)moddify:(UIButton *)btn{
    if ([NSString isEmpty:_accountTextField.text]) {
        [WanProgressHUD showMessage:@"请输入账号"];
        return;
    }else if([NSString isEmpty:_validTextField.text]){
        [WanProgressHUD showMessage:@"请输入验证码"];
        return;
    }else if([NSString isEmpty:_passwordTextField.text]){
        [WanProgressHUD showMessage:@"请输入密码"];
        return;
    }
    //修改密码
    [WanProgressHUD showLoading:@"修改密码..."];
    if (self.delegate && [_delegate respondsToSelector:@selector(viewClickActionType:withAccountModel:)]) {
        WanAccountModel *model = [[WanAccountModel alloc] init];
        model.account = _accountTextField.text;
        model.password = _passwordTextField.text;
        model.valicode = _validTextField.text;
        [_delegate viewClickActionType:ClickButtonTypeModdifyPassword withAccountModel:model];
    }
}

-(void)close:(UIButton *)btn{
    if (self.delegate && [_delegate respondsToSelector:@selector(viewClickActionType:withAccountModel:)]) {
        [_delegate viewClickActionType:ClickButtonTypeGotoLogin withAccountModel:nil];
    }
}

-(void)setModel:(WanAccountModel *)model{
    if (model && ![NSString isEmpty:model.account]) {
        _model = model;
        _accountTextField.text = model.account;
    }
}

#pragma mark --<UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//不能输入空格
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location>=textField.text.length && [string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

@end
