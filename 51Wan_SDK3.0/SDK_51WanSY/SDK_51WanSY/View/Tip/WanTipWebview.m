//
//  WanTipWebview.m
//  WanAppStroeSDK
//
//  Created by Star on 2017/6/12.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import "WanTipWebview.h"
#import <WebKit/WebKit.h>

#define headHeight ((WAN_SCREEN_HEIGHT >  WAN_SCREEN_WIDTH)?64.0*kRetio:44.0*kRetio)
#define webViewTopOrg ((WAN_SCREEN_HEIGHT >  WAN_SCREEN_WIDTH)?0:0)

@interface WanTipWebview()<WKNavigationDelegate, WKUIDelegate>{
    UILabel *_headView;
    UIButton *_backBtn;
    NSInteger _webSitePage;
}

@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, copy) NSString *firstPage;

@end

@implementation WanTipWebview

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    _headView = [[UILabel alloc] initWithFrame:CGRectMake(0, webViewTopOrg, webviewWidth, headHeight)];
    
    _headView.textAlignment = NSTextAlignmentCenter;
    _headView.font = [UIFont systemFontOfSize:18];
    //tableView添加内嵌阴影效果
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_headView.right/2.0, 0, 0.1, _headView.height)];
    [WanUtils setShadowInView:label];
    [_headView addSubview:label];
    _headView.clipsToBounds = YES;
    
    if (WAN_SCREEN_HEIGHT > WAN_SCREEN_WIDTH) {
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.textColor = [UIColor colorWithHexString:@"63535a"];
    }else{
        _headView.textColor = [UIColor colorWithHexString:@"434a54"];
        _headView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    }
    
    [self addSubview:_headView];
    
    //返回按钮
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, headHeight/2.0-12, 24, 24)];
    
    NSString *imgName = WAN_SCREEN_WIDTH > WAN_SCREEN_HEIGHT?@"wan_icon_goback":@"pra_back";
    [_backBtn setBackgroundImage:[WanUtils imageInBundelWithName:imgName] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backSite:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setHidden:YES];
    [self addSubview:_backBtn];
    //webview
    [self addSubview:self.webview];
}

#pragma mark -- getter selector
-(WKWebView *)webview{
    if (_webview == nil) {
        _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, _headView.bottom, webviewWidth, self.height-_headView.bottom)];
//        _webview.opaque = NO;
        _webview.backgroundColor = [UIColor clearColor];
        _webview.scrollView.showsHorizontalScrollIndicator = NO;
        _webview.scrollView.showsVerticalScrollIndicator = NO;
        _webview.scrollView.bounces = NO;
        [_webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        _webview.navigationDelegate = self;
        _webview.UIDelegate = self;
        if (WAN_SCREEN_WIDTH > WAN_SCREEN_HEIGHT) {
            _webview.layer.borderWidth = 1.0f;
            _webview.layer.borderColor = [UIColor colorWithHexString:@"e1e1e1"].CGColor;
        }else{
            _webview.layer.borderWidth = 1.0f;
            _webview.layer.borderColor = [UIColor colorWithHexString:@"e1e1e1"].CGColor;
        }
        [self addSubview:self.webview];
    }
    return _webview;
}

- (UIProgressView *)progressView{
    if (!_progressView){
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.webview.width, 0.5)];
        progressView.backgroundColor = [UIColor clearColor];
        progressView.tintColor = [UIColor redColor];
        progressView.trackTintColor = [UIColor colorWithHexString:@"e1e1e1"];
        [self.webview addSubview:progressView];
        self.progressView = progressView;
    }
    return _progressView;
}

#pragma mark --setter selector
-(void)setUrl:(NSString *)url{
    if (![NSString isEmpty:url]) {
        [_backBtn setHidden:YES];
        _firstPage = [url componentsSeparatedByString:@"?"][0];
        //加载链接
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}

#pragma mark --<WKNavigationDelegate>
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if (![navigationAction.request.URL.absoluteString containsString:_firstPage]) {
        [_backBtn setHidden:NO];
    }else{
        [_backBtn setHidden:YES];
    }
    NSString *url = navigationAction.request.URL.absoluteString;
    //客服QQ
    if ([navigationAction.request.URL.host isEqualToString:@"wpd.b.qq.com"] && [NSString isNotEmpty:url]) {
        NSRange range = [url rangeOfString:@"="];
        NSString *qq = [url substringWithRange:NSMakeRange(range.location+range.length, url.length-range.location-range.length)];

        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {

            NSString *qqurl = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qq];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:qqurl]];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webview && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        [self.progressView setHidden:YES];
        if (newprogress == 1) {
            [self.progressView setProgress:0 animated:NO];
            [self.progressView setHidden:YES];
        }else {
            [self.progressView setProgress:newprogress animated:NO];
        }
    }
    else if (object == self.webview && [keyPath isEqualToString:@"title"]){
        _headView.text = self.webview.title;
    }
}

//清空WKWebview缓存
-(void)clearCache{
    if ([[[UIDevice currentDevice] systemVersion] intValue ] > 8) {
        NSArray * types = @[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeCookies, WKWebsiteDataTypeLocalStorage,WKWebsiteDataTypeOfflineWebApplicationCache, WKWebsiteDataTypeSessionStorage];  // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

#pragma mark --btn selector
-(void)backSite:(UIButton *)btn{
    if (self.webview.backForwardList.backList.count>0) {
        [self.webview goToBackForwardListItem:[self.webview.backForwardList.backList lastObject]];
    }
}


-(void)dealloc{
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webview removeObserver:self forKeyPath:@"title"];
    [self clearCache];
}

@end
