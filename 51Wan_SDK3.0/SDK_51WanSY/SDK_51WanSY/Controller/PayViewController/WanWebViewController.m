//
//  NIWebViewController.m
//  MuyuMall
//
//  Created by admin on 2018/4/24.
//  Copyright © 2018年 YunchenGroup. All rights reserved.
//

#import "WanWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WanProgressHUD.h"

@interface WanWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
    
@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView * progressView;
@property (strong, nonatomic) WKWebView * wkWebView;
@property (strong, nonatomic) WKWebViewConfiguration *config;
@property (nonatomic ,strong) WKUserContentController * userContentController;
    
@end

@implementation WanWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI {
    _config = [[WKWebViewConfiguration alloc] init];
    _config.preferences = [[WKPreferences alloc] init];
    _config.preferences.minimumFontSize = 10;
    _config.preferences.javaScriptEnabled = YES;
    _config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    _config.userContentController = [[WKUserContentController alloc] init];
    self.userContentController = _config.userContentController;
    _config.processPool = [[WKProcessPool alloc] init];
    
    UILabel * topView =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, WAN_SCREEN_WIDTH, 44)];
    topView.backgroundColor = [UIColor orangeColor];
    topView.text = @"Pay pale";
    topView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:topView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15 , 6, 32, 32);
    [backBtn setImage:[WanUtils imageInBundelWithName:@"wan_icon_goback"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 44, WAN_SCREEN_WIDTH, WAN_SCREEN_HEIGHT - 44) configuration:_config];
    //记得实现对应协议,不然方法不会实现.
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate =self;
    self.wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.wkWebView];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_requestUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
    [self.wkWebView loadRequest:request];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 44, WAN_SCREEN_WIDTH, 0)];
    progressView.tintColor = [UIColor blueColor];
    progressView.trackTintColor = [UIColor lightGrayColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    // **************** 此处划重点 **************** //
    //添加注入js方法, oc与js端对应实现
//    [config.userContentController addScriptMessageHandler:self name:@"collectIsLogin"];
}

- (void)backBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
//    [self.userContentController removeScriptMessageHandlerForName:@"collectIsLogin"];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - WKScriptMessageHandler
//实现js注入方法的协议方法
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    //找到对应js端的方法名,获取messge.body
//    if ([message.name isEqualToString:@"collectIsLogin"]) {
//
//        NSLog(@"%@", message.body);
//
//
//    }
}

#pragma mark ---------  WKNavigationDelegate  --------------
// 加载成功,传递值给js
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    //获取userId
//    //传递userId给 js端
//    NSString * userId = DEF_GET_OBJECT(UserID);
//    NSString * jsUserId;
//    if (!userId) {
//        jsUserId =@"";
//    }else{
//        jsUserId =userId;
//    }
//    //之所以给userId重新赋值,貌似是如果userId为空null 那么传给js端,js说无法判断,只好说,如果userId为null,重新定义为空字符串.如果大家有好的建议,可以在下方留言.
//    //同时,这个地方需要注意的是,js端并不能查看我们给他传递的是什么值,也无法打印,貌似是语言问题? 还是js骗我文化低,反正,咱们把值传给他,根据双方商量好的逻辑,给出判断,如果正常,那就ok了.
//    NSString * jsStr  =[NSString stringWithFormat:@"sendKey('%@')",jsUserId];
//    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        //此处可以打印error.
//    }];
//    //js端获取传递值代码实现实例(此处为js端实现代码给大家粘出来示范的!!!):
//    //function sendKey(user_id){
//
//    $("#input").val(user_id);
//}

}
////依然是这个协议方法,获取注入方法名对象,获取js返回的状态值.
//#pragma mark - WKScriptMessageHandler
//- (void)userContentController:(WKUserContentController *)userContentController       didReceiveScriptMessage:(WKScriptMessage *)message {

//    //js端判断如果userId为空,则返回字符串@"toLogin"  ,或者返回其它值.  js端代码实现实例(此处为js端实现代码给大家粘出来示范的!!!):
//    function collectIsLogin(goods_id){
//        if (/(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent)) {
//
//            try {
//
//                if( $("#input").val()){
//
//                    window.webkit.messageHandlers.collectGzhu.postMessage({body: "'"+goods_id+"'"});
//
//                }else {
//                    window.webkit.messageHandlers.collectGzhu.postMessage({body: 'toLogin'});
//
//                }
//
//
//            }catch (e){
//                //浏览器
//                alert(e);
//            }
//
//            //oc原生处理:
//
//            if ([message.name isEqualToString:@"collectIsLogin"]) {
//
//                NSDictionary * messageDict = (NSDictionary *)message.body;
//                if ([messageDict[@"body"] isEqualToString:@"toLogin"]) {
//                    NSLog(@"登录");
//
//
//
//                }else{
//                    NSLog(@"正常跳转");
//                    NSLog(@"mess --- id == %@",message.body);
//
//                }
//            }
//        }
//}
//        3.在交互中,关于alert (单对话框)函数、confirm(yes/no对话框)函数、prompt(输入型对话框)函数时,实现代理协议 WKUIDelegate ,则系统方法里有三个对应的协议方法.大家可以进入WKUIDelegate 协议类里面查看.下面具体协议方法实现,也给大家粘出来,以供参考.

#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView
{
            NSLog(@"%s", __FUNCTION__);
    
}

// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//            NSLog(@"%s", __FUNCTION__);
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//            }]];
//    
//            [self presentViewController:alert animated:YES completion:NULL];
//            NSLog(@"%@", message);
    completionHandler();
//    [ProgressHUD showError:message];
    
}
// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"%s", __FUNCTION__);

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];

    NSLog(@"%@", message);
}

// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"%@", prompt);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 获取完整url并进行UTF-8转码
    decisionHandler(WKNavigationActionPolicyAllow);
//    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
//    if ([strRequest containsString:@"http://com.iwanxiyou5.www/?/tag=success"]) {
//        [ProgressHUD show:@"充值成功"];
//        [self performSelector:@selector(hidenHud) withObject:nil afterDelay:1.0];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }else if([strRequest containsString:@"http://com.iwanxiyou5.www/?/tag=fail"]){
//        [ProgressHUD show:@"充值失败"];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [self performSelector:@selector(hidenHud) withObject:nil afterDelay:1.0];
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }else {
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
}

-(void)hidenHud{
    [WanProgressHUD hide];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
