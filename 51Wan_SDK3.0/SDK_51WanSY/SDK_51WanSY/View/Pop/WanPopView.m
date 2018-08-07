//
//  WanPopView.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/30.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanPopView.h"

@interface WanPopView()<UIWebViewDelegate>
{
    UIWebView *_contentView;
}

@end

@implementation WanPopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    //头部图片
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-100*kRetio)/2.0, (95-72)/2.0*kRetio, 100*kRetio, 72*kRetio)];
    headImgView.backgroundColor = [UIColor clearColor];
    headImgView.image = [WanUtils imageInBundelWithName:@"notice-icon"];
    [self addSubview:headImgView];
    //关闭按钮
    WanButton *closeBtn = [[WanButton alloc] initCloseBtnWithFrame:CGRectMake(self.width-WanCloseBtnWidth-WanCloseBtnMargin, WanCloseBtnMargin, WanCloseBtnWidth, WanCloseBtnWidth) target:self action:@selector(close:)];
    [self addSubview:closeBtn];
    //线条
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 95*kRetio, self.width, 1)];
    lineLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [self addSubview:lineLabel];
    
    //内容
    _contentView = [[UIWebView alloc] initWithFrame:CGRectMake(5, lineLabel.bottom, self.width-10, self.height-headImgView.height - 90*kRetio)];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.opaque = NO;
    _contentView.delegate = self;
    _contentView.scrollView.showsVerticalScrollIndicator = YES;
    [_contentView loadHTMLString:[WanSDKConfig shareInstance].popModel.content baseURL:nil];
    [self addSubview:_contentView];

    //按钮
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _contentView.bottom+10, _contentView.width-40, 35)];
    okBtn.center = CGPointMake(self.width/2.0, okBtn.center.y);
    okBtn.layer.cornerRadius = 4.0f;
    [okBtn setTitle:@"知道了" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okBtn.backgroundColor = WanButtonBgColor;
    [okBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okBtn];
}

#pragma mark -- self action
-(void)close:(UIButton *)btn{
    if (self.delegate && [_delegate respondsToSelector:@selector(viewClickActionType:withAccountModel:)]) {
        [_delegate viewClickActionType:ClickButtonTypeClose withAccountModel:nil];
    }
}

#pragma mark ----<UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (![@"about:blank" isEqualToString: request.URL.absoluteString]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"公告窗打开网页失败：%@", error);
}

@end
