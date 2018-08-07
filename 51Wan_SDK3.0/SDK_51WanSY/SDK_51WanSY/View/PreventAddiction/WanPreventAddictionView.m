//
//  WanPreventAddictionView.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/23.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanPreventAddictionView.h"
#import "WanServer.h"

@interface WanPreventAddictionView()<UITextFieldDelegate>
{
    WanTextField *_phoneTextField;//手机号
    WanTextField *_validTextField;//验证码
    WanTextField *_realNameTextField;//姓名
    WanTextField *_idCardTextField;//身份证
    NSTimer *_timer;//定时器
    UIButton *_validCodeBtn;
    UIButton *_bindBtn;//绑定按钮
    NSInteger _time;
}

@property (nonatomic, strong) WanAccountModel *accountModel;

@end

@implementation WanPreventAddictionView

-(instancetype)initWithFrame:(CGRect)frame withModel:(WanAccountModel *)model{
    if (self = [super initWithFrame:frame]) {
        self.accountModel = model;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    //绑定手机or实名认证
    NSString *titleStr = [[WanSDKConfig shareInstance] isAdult]?@"实名认证":@"绑定手机";
    WanLabel *title = [[WanLabel alloc] initTitleLabelWithFrame:CGRectMake(WanTextFieldLeftMargin, 0, 150, WanTitleLabelHeight*kRetio) title:titleStr];
    [self addSubview:title];
    
    //关闭按钮
    WanButton *closeBtn = [[WanButton alloc] initCloseBtnWithFrame:CGRectMake(self.width-WanCloseBtnWidth-WanCloseBtnMargin, WanCloseBtnMargin, WanCloseBtnWidth, WanCloseBtnWidth) target:self action:@selector(close:)];
    [self addSubview:closeBtn];
    
    //分割线条
    WanLabel *line = [[WanLabel alloc] initLineWithFrame:CGRectMake(0, title.bottom, self.width, WanLineLabelHeight)];
    [self addSubview:line];
    
    NSInteger i = ([NSString isEmpty:self.accountModel.phoneNo]?2:1);
    i = [WanSDKConfig shareInstance].isAdult?i+2:i;
    
    //手机号
    _phoneTextField = [[WanTextField alloc] initWithFrame:CGRectMake(WanTextFieldLeftMargin, line.bottom+20*kRetio, self.width-2*WanTextFieldLeftMargin, WanTextFieldHeight*kRetio)];
    [_phoneTextField setPlaceHolder:@"手机号"];
    [_phoneTextField setLeftViewWithImageName:@"phone"];
    _phoneTextField.delegate = self;
    if (![NSString isEmpty:self.accountModel.phoneNo]) {
        _phoneTextField.text = self.accountModel.phoneNo;
    }
    [self addSubview:_phoneTextField];

    CGFloat orgY = _phoneTextField.bottom+WanTextFieldMargin;
    //是否需要获取手机验证码
    if ([NSString isEmpty:self.accountModel.phoneNo]) {
        //验证码
        _validTextField = [[WanTextField alloc] initWithFrame:CGRectMake(WanTextFieldLeftMargin, orgY, _phoneTextField.width, WanTextFieldHeight*kRetio)];
        [_validTextField setPlaceHolder:@"验证码"];
        [_validTextField setLeftViewWithImageName:@"valicode"];
        _validCodeBtn = [_validTextField setValicodeViewWithTitle:@"点击获取" target:self action:@selector(getValidCode:)];
        _validTextField.delegate = self;
        [self addSubview:_validTextField];
        orgY = _validTextField.bottom+WanTextFieldMargin;
    }
    
    //是否有防沉迷
    if ([WanSDKConfig shareInstance].isAdult) {
        //真实姓名
        _realNameTextField = [[WanTextField alloc] initWithFrame:CGRectMake(WanTextFieldLeftMargin, orgY, self.width-2*WanTextFieldLeftMargin, WanTextFieldHeight*kRetio)];
        [_realNameTextField setPlaceHolder:@"请输入真实姓名"];
        [_realNameTextField setLeftViewWithImageName:@"realname"];
        _realNameTextField.delegate = self;
        if (![NSString isEmpty:self.accountModel.realName]) {
            _realNameTextField.text = self.accountModel.realName;
            _realNameTextField.enabled = NO;
        }
        [self addSubview:_realNameTextField];
        
        //身份证
        _idCardTextField = [[WanTextField alloc] initWithFrame:CGRectMake(_realNameTextField.left, _realNameTextField.bottom+WanTextFieldMargin, _realNameTextField.width, WanTextFieldHeight*kRetio)];
        [_idCardTextField setPlaceHolder:@"请输入身份证号码"];
        [_idCardTextField setLeftViewWithImageName:@"idcard"];
        _idCardTextField.secureTextEntry = YES;
        _idCardTextField.delegate = self;
        if (![NSString isEmpty:self.accountModel.id_card]) {
            _idCardTextField.text = self.accountModel.id_card;
            _idCardTextField.enabled = NO;
        }
        [self addSubview:_idCardTextField];
        
        orgY = _idCardTextField.bottom+WanTextFieldMargin;
    }
    
    //确认提交
    WanButton *submitBtn = [[WanButton alloc] initWithFrame:CGRectMake(_phoneTextField.left, orgY+10*kRetio, _phoneTextField.width, 44*kRetio) title:@"确认" target:self action:@selector(bind:) titleFoneSize:16.0 titleColor:WanWhiteColor bgColor:WanButtonBgColor];
    [self addSubview:submitBtn];
}

#pragma btn acction
-(void)getValidCode:(UIButton *)btn{
    if ([NSString isEmpty:_phoneTextField.text]) {
        [WanProgressHUD showMessage:@"请先输入手机号"];
        return;
    }
    //获取验证码
    WanServer *loginServer = [[WanServer alloc] init];
    [loginServer getValidCodeRequestWithPhone:_phoneTextField.text veriType:@"1" userName:@"" success:^(NSDictionary *dict, BOOL success) {
        if (!success) {
            [WanProgressHUD showFailure:[WanUtils getResponseMsgWithDict:dict]];
            [self getValiCodeCompelete];
        }
    } failed:^(NSError *error) {
        [self getValiCodeCompelete];
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

-(void)getValiCodeCompelete{
    [_validCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _validCodeBtn.enabled = YES;
    [_timer invalidate];
}

-(void)bind:(UIButton *)btn{
    if([self checkParams]){
        //绑定手机弹窗
        if (self.delegate && [_delegate respondsToSelector:@selector(viewClickActionType:withAccountModel:)]) {
            WanAccountModel *model = [[WanAccountModel alloc] init];
            model.phoneNo = _phoneTextField.text;
            model.valicode = _validTextField.text;
            model.realName = _realNameTextField.text;
            model.id_card = _idCardTextField.text;
            [_delegate viewClickActionType:ClickButtonTypePreventAddiction withAccountModel:model];
        }
    }
}

-(BOOL)checkParams{
    if ([WanSDKConfig shareInstance].isAdult) {
        //防沉迷开启，判断是否已经绑定手机
        if (![NSString isEmpty:self.accountModel.phoneNo]){//已绑定手机，只需判断身份信息
            if ([NSString isEmpty:_realNameTextField.text]) {
                [WanProgressHUD showMessage:@"请输入真实姓名"];
                return NO;
            }
            if ([NSString isEmpty:_idCardTextField.text]) {
                [WanProgressHUD showMessage:@"请输入身份证号码"];
                return NO;
            }
        }
        else{
            if (([NSString isEmpty:_phoneTextField.text] || [NSString isEmpty:_validTextField.text])&&([NSString isEmpty:_realNameTextField.text] || [NSString isEmpty:_idCardTextField.text])) {
                [WanProgressHUD showMessage:@"请填写完整信息"];
                return NO;
            }
        }
    }else{
        //防沉迷关闭的时候，点击绑定按钮必须要填写手机号和验证码
        if ([NSString isEmpty:_phoneTextField.text]) {
            [WanProgressHUD showMessage:@"请输入手机号"];
            return NO;
        }
        if (![WanUtils validateMobile:_phoneTextField.text]) {
            [WanProgressHUD showMessage:@"您输入的手机号有误！"];
            return NO;
        }
        if([NSString isEmpty:_validTextField.text]){
            [WanProgressHUD showMessage:@"请输入验证码"];
            return NO;
        }
    }
    return YES;
}

-(void)close:(UIButton *)btn{
    if (self.delegate && [_delegate respondsToSelector:@selector(viewClickActionType:withAccountModel:)]) {
        [_delegate viewClickActionType:ClickButtonTypeClose withAccountModel:nil];
    }
}

#pragma mark --<UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *phoneNum = [textField.text stringByAppendingString:string];
    BOOL isPhoneNum = [WanUtils validateMobile:phoneNum];
    if (isPhoneNum && ![NSString isEmpty:string]) {
        textField.text = phoneNum;
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
