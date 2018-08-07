
//
//  WanLoginView.m
//  Wan669SDK
//
//  Created by liuluoxing on 2017/2/17.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//



#import "WanLoginView.h"
#import "WanAccountCell.h"

#define WanCellHeight 44.0f

@interface WanLoginView()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    WanTextField *_accountTextField;//账号
    WanTextField *_passwordTextField;//密码
    UIButton *_chooseAccountBtn;
}

@property (nonatomic, strong) UITableView *accountTable;

@property (nonatomic, strong) NSMutableArray *accountArray;

@end


@implementation WanLoginView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    //用户登录
    WanLabel *title = [[WanLabel alloc] initTitleLabelWithFrame:CGRectMake(WanTextFieldLeftMargin, 0, 150, WanTitleLabelHeight*kRetio) title:@"用户登录"];
    [self addSubview:title];
    
    //关闭按钮
    WanButton *closeBtn = [[WanButton alloc] initCloseBtnWithFrame:CGRectMake(self.width-WanCloseBtnWidth-WanCloseBtnMargin, WanCloseBtnMargin, WanCloseBtnWidth, WanCloseBtnWidth) target:self action:@selector(close:)];
    [self addSubview:closeBtn];
    
    //分割线条
    WanLabel *line = [[WanLabel alloc] initLineWithFrame:CGRectMake(0, title.bottom, self.width, WanLineLabelHeight)];
    [self addSubview:line];
    
    //账号
    _accountTextField = [[WanTextField alloc] initWithFrame:CGRectMake(WanTextFieldLeftMargin, line.bottom+20*kRetio, self.width-2*WanTextFieldLeftMargin, WanTextFieldHeight*kRetio)];
    [_accountTextField setPlaceHolder:@"请输入您的用户名"];
    [_accountTextField setLeftViewWithImageName:@"account"];
    _chooseAccountBtn = [_accountTextField setChooseBtnWithImage:[WanUtils imageInBundelWithName:@"up"] selectedImage:[WanUtils imageInBundelWithName:@"down"] target:self action:@selector(chooseAccount:)];
    _accountTextField.delegate = self;
    [self addSubview:_accountTextField];
    
    //密码
    _passwordTextField = [[WanTextField alloc] initWithFrame:CGRectMake(_accountTextField.left, _accountTextField.bottom+WanTextFieldMargin, _accountTextField.width, WanTextFieldHeight*kRetio)];
    [_passwordTextField setPlaceHolder:@"请输入您的密码"];
    [_passwordTextField setLeftViewWithImageName:@"password"];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    [self addSubview:_passwordTextField];
    
    //上次登录的账号密码
    WanAccountModel *rencentModel = [WanUtils getRencentlyAccount];
    _accountTextField.text = rencentModel.account;
    _passwordTextField.text = rencentModel.password;
    
    //忘记密码
    WanButton *frogetBtn = [[WanButton alloc] initWithFrame:CGRectMake(_passwordTextField.left, _passwordTextField.bottom+10*kRetio, _passwordTextField.width/2.0, 16*kRetio) title:@"忘记密码？" target:self action:@selector(forgetPd:) titleFoneSize:13.0 titleColor:WanButtonTitleColor bgColor:[UIColor clearColor]];
    frogetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:frogetBtn];
    
    //注册新账号
    WanButton *registBtn = [[WanButton alloc] initWithFrame:CGRectMake(frogetBtn.right, frogetBtn.top, frogetBtn.width, frogetBtn.height) title:@"新注册" target:self action:@selector(regist:) titleFoneSize:13.0 titleColor:WanButtonTitleColor bgColor:[UIColor clearColor]];
    registBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    registBtn.hidden = ![WanSDKConfig shareInstance].isRegister;
    [self addSubview:registBtn];
    
    //登录
    WanButton *loginBtn = [[WanButton alloc] initWithFrame:CGRectMake(frogetBtn.left, frogetBtn.bottom+30*kRetio, _passwordTextField.width, 44*kRetio) title:@"登录" target:self action:@selector(login:) titleFoneSize:16.0 titleColor:WanWhiteColor bgColor:WanButtonBgColor];
    [self addSubview:loginBtn];
    
    //快速试玩
    NSString *str = @"一键注册";
    CGSize size = [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil]];
    
    UILabel *quickRegestLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width-size.width-15)/2.0, loginBtn.bottom+15*kRetio, size.width, 15)];
    quickRegestLabel.text = str;
    quickRegestLabel.textColor = [UIColor whiteColor];
    quickRegestLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:quickRegestLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(quickRegestLabel.right+3, quickRegestLabel.top, 15, 15)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [WanUtils imageInBundelWithName:@"start"];
    [self addSubview:imageView];
    
    UIButton *control = [[UIButton alloc] initWithFrame:CGRectMake(quickRegestLabel.left, quickRegestLabel.top-5, imageView.width+quickRegestLabel.width, imageView.height+10)];
    [control addTarget:self action:@selector(qucikRegest:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
}

#pragma mark --getter
-(NSMutableArray *)accountArray{
    if (_accountArray == nil) {
        _accountArray = [NSMutableArray array];
        _accountArray = [WanUtils getAllSavedAccount];
        WanAccountModel *recentModel = [WanUtils getRencentlyAccount];
        for (WanAccountModel *model in _accountArray) {
            if ([model.account isEqualToString:recentModel.account]) {
                [_accountArray removeObject:model];
                break;
            }
        }
    }
    return _accountArray;
}

-(UITableView *)accountTable{
    if (_accountTable == nil) {
        CGFloat height = self.accountArray.count>3?WanCellHeight*3*kRetio:WanCellHeight*self.accountArray.count*kRetio;
        _accountTable = [[UITableView alloc] initWithFrame:CGRectMake(_accountTextField.left, _accountTextField.bottom, _accountTextField.width, height) style:UITableViewStylePlain];
        _accountTable.backgroundColor = [UIColor colorWithHexString:@"15161a"];
        _accountTable.delegate = self;
        _accountTable.dataSource = self;
        _accountTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _accountTable.separatorColor = [UIColor colorWithWhite:1 alpha:0.3];
        _accountTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _accountTable.width, 0.01)];
        [_accountTable registerClass:[WanAccountCell class] forCellReuseIdentifier:@"AccountCell"];
    }
    return _accountTable;
}

#pragma mark ----btn acction
//登录
-(void)login:(UIButton *)btn{
    if ([NSString isEmpty:_accountTextField.text]) {
        [WanProgressHUD showFailure:@"请先输入账号"];
        return;
    }else if([NSString isEmpty:_passwordTextField.text]){
        [WanProgressHUD showFailure:@"请先输入密码"];
        return;
    }
    
    if (self.delegate && [_delegate respondsToSelector:@selector(viewClickActionType:withAccountModel:)]) {
        WanAccountModel *model = [[WanAccountModel alloc] init];
        model.account = _accountTextField.text;
        model.password = _passwordTextField.text;
        [_delegate viewClickActionType:ClickButtonTypeLogin withAccountModel:model];
    }
}

//注册
-(void)regist:(UIButton *)btn{
    if (self.delegate && [_delegate respondsToSelector:@selector(viewClickActionType:withAccountModel:)]) {
        [_delegate viewClickActionType:ClickButtonTypeGotoRegest withAccountModel:nil];
    }
}

//忘记密码
-(void)forgetPd:(UIButton *)btn{
    if (self.delegate && [_delegate respondsToSelector:@selector(viewClickActionType:withAccountModel:)]) {
        WanAccountModel *model = [[WanAccountModel alloc] init];
        model.account = _accountTextField.text;
        model.password = _passwordTextField.text;
        [_delegate viewClickActionType:ClickButtonTypeGotoModdifyPassword withAccountModel:model];
    }
}

//快速注册
-(void)qucikRegest:(UIButton *)btn{
    if (self.delegate && [_delegate respondsToSelector:@selector(viewClickActionType:withAccountModel:)]) {
        [_delegate viewClickActionType:ClickButtonTypeQuickRegest withAccountModel:nil];
    }
}

//点击关闭按钮
-(void)close:(UIButton *)btn{
    if (self.delegate && [_delegate respondsToSelector:@selector(viewClickActionType:withAccountModel:)]) {
        [_delegate viewClickActionType:ClickButtonTypeClose withAccountModel:nil];
    }
}

//选择账号
-(void)chooseAccount:(UIButton *)btn{
    [self endEditing:YES];
    if (_chooseAccountBtn.selected) {
        [self.accountTable removeFromSuperview];
    }else{
        [self addSubview:self.accountTable];
    }
    _chooseAccountBtn.selected = !_chooseAccountBtn.selected;
}

-(void)switchAction:(UISwitch *)switchBtn{
    BOOL isButtonOn = [switchBtn isOn];
    if (isButtonOn) {
        _passwordTextField.secureTextEntry = NO;
    }else {
        _passwordTextField.secureTextEntry = YES;
    }
}

#pragma mark ----<UITextFieldDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_accountTable) {
        [_accountTable removeFromSuperview];
    }
    _chooseAccountBtn.selected = NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ---<UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.accountArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WanAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell"];
    WanAccountModel *model = self.accountArray[indexPath.row];
    cell.account = model.account;
    cell.password = model.password;
    @WeakObj(self);
    cell.deleteAccountBlock = ^{
        @StrongObj(self);
        self.accountArray = nil;
        [self.accountTable reloadData];
        self.accountTable.height = self.accountArray.count>3?WanCellHeight*3*kRetio:WanCellHeight*self.accountArray.count*kRetio;
    };
    //因手势冲突，改为点击事件
    cell.selectedAccountBlock = ^{
        @StrongObj(self);
        WanAccountModel *model = self.accountArray[indexPath.row];
        _accountTextField.text = model.account;
        _passwordTextField.text = model.password;
        _chooseAccountBtn.selected = NO;
        [_accountTable removeFromSuperview];
    };
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WanCellHeight;
}

@end
