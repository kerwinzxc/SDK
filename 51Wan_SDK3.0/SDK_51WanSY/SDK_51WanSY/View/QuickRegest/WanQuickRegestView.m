//
//  WanQuickRegestView.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/23.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanQuickRegestView.h"

@interface WanQuickRegestView(){
    WanTextField *_accountTextField;
    WanTextField *_passwordTextField;
}

@end

@implementation WanQuickRegestView

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
    
    //分割线条
    WanLabel *line = [[WanLabel alloc] initLineWithFrame:CGRectMake(0, title.bottom, self.width, WanLineLabelHeight)];
    [self addSubview:line];
    
    //账号
    _accountTextField = [[WanTextField alloc] initWithFrame:CGRectMake(WanTextFieldLeftMargin, line.bottom+20*kRetio, self.width-2*WanTextFieldLeftMargin, WanTextFieldHeight*kRetio)];
    [_accountTextField setLeftViewWithImageName:@"account"];
    _accountTextField.enabled = NO;
    [self addSubview:_accountTextField];
    
    //密码
    _passwordTextField = [[WanTextField alloc] initWithFrame:CGRectMake(_accountTextField.left, _accountTextField.bottom+WanTextFieldMargin, _accountTextField.width, WanTextFieldHeight*kRetio)];
    [_passwordTextField setLeftViewWithImageName:@"password"];
    _passwordTextField.enabled = NO;
    [self addSubview:_passwordTextField];

    //提示
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(_passwordTextField.left, _passwordTextField.bottom+13, _passwordTextField.width, 45*kRetio)];
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"温馨提示：请记住您的账号密码，以便再次登录。建议截屏保存，可以找回您的密码。";
    tipLabel.textColor = [UIColor colorWithHexString:@"b9b9b9"];
    tipLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:tipLabel];
    
    //截屏保存
    WanButton *screenShotBtn = [[WanButton alloc] initWithFrame:CGRectMake(25, tipLabel.bottom+10, self.width-50, 45*kRetio) title:@"截屏保存" target:self action:@selector(screenshot:) titleFoneSize:15.0 titleColor:WanWhiteColor bgColor:WanButtonBgColor];
    screenShotBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [screenShotBtn addTarget:self action:@selector(screenshot:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:screenShotBtn];
    
    //快速试玩
    CGSize imgsize = CGSizeMake(15, 15);
    WanButton *quickPlayBtn = [[WanButton alloc] initWithFrame:CGRectMake(screenShotBtn.left, screenShotBtn.bottom+15*kRetio, screenShotBtn.width, 25.0) title:@"快速试玩" image:[WanUtils imageInBundelWithName:@"start"] imgSize:imgsize target:self action:@selector(startPlay:) titleFoneSize:15.0 titleColor:WanWhiteColor bgColor:[UIColor clearColor]];
    CGFloat titleWidth = [NSString calculateRowWidth:@"快速试玩" fontSize:15.0];
    quickPlayBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imgsize.width, 0, imgsize.width);
    quickPlayBtn.imageEdgeInsets = UIEdgeInsetsMake(0,titleWidth,0,-titleWidth);
    [self addSubview:quickPlayBtn];
}

#pragma mark ---截屏
-(void)screenshot:(UIButton *)btn{
    [WanProgressHUD showLoading:@"开始截屏，请稍后..."];
    //截取当前界面图片
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:contextRef];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //保存图片
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

#pragma mark ---开始试玩
-(void)startPlay:(UIButton *)btn{
    if (self.delegate && [_delegate respondsToSelector:@selector(viewClickActionType:withAccountModel:)]) {
        WanAccountModel *model = [[WanAccountModel alloc] init];
        model.account = self.model.account;
        model.password = self.model.password;
        [_delegate viewClickActionType:ClickButtonTypeLogin withAccountModel:model];
    }
}

#pragma mark --setter
-(void)setModel:(WanAccountModel *)model{
    _model = model;
    if (model && ![NSString isEmpty:model.account] && ![NSString isEmpty:model.password]) {
        _accountTextField.text = model.account;
        _passwordTextField.text = model.password;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error == nil) {
        [WanProgressHUD showInfoMsg:@"截屏完成，已保存至相册！"];
    }else{
        [WanProgressHUD showFailure:@"截屏保存失败！"];
    }
}

@end
