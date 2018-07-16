//
//  WanTipPorWebViewController.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/31.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanTipPorWebViewController.h"
#import "WanTipWebview.h"

#define tabbarViewHeight 49.0

@interface WanTipPorWebViewController ()<UIGestureRecognizerDelegate>
{
    UIButton *_selectedBtn;
}
@property (nonatomic, strong) UIView *tabbarView;
@property (nonatomic, strong) WanTipWebview *tipWebview;

@end

@implementation WanTipPorWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTap];
    [self.view addSubview:self.tabbarView];
}

#pragma mark --getter selector
-(WanTipWebview *)tipWebview{
    if (!_tipWebview) {
        _tipWebview = [[WanTipWebview alloc] initWithFrame:CGRectMake(0, self.tabbarView.top-470*kRetio, WAN_SCREEN_WIDTH, 470*kRetio)];
        _tipWebview.hidden = YES;
        [self.view addSubview:_tipWebview];
        [self.view bringSubviewToFront:self.tabbarView];
    }
    return _tipWebview;
}

-(UIView *)tabbarView{
    if (_tabbarView == nil) {
        _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, WAN_SCREEN_HEIGHT-tabbarViewHeight, WAN_SCREEN_WIDTH, tabbarViewHeight)];
        UIImage *bgImg = [UIColor gradientColorImageFromColors:@[[UIColor colorWithHexString:@"c41a3f"], [UIColor colorWithHexString:@"dd4341"], [UIColor colorWithHexString:@"f87045"]] gradientType:GradientTypeLeftToRight imgSize:_tabbarView.size];
        _tabbarView.backgroundColor = [UIColor colorWithPatternImage:bgImg];
        
        NSArray *imageArr = @[@"pra_my", @"pra_raiders", @"center", @"pra_server", @"pra_gift"];
        NSArray *selectImageArr = @[@"pra_my_down", @"pra_raiders_down", @"center",  @"pra_server_down", @"pra_gift_down"];
        NSArray *nameArr = @[@"我的", @"攻略", @"游戏", @"客服", @"礼包"];
        
        CGFloat leftMargin = 25.0f;
        CGFloat itemWidth = 30.0f;
        CGFloat magin = (WAN_SCREEN_WIDTH-25*2-itemWidth*5)/4.0;
        CGFloat lblWidth = WAN_SCREEN_WIDTH/5.0f;
        for (int i = 0; i < imageArr.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin+(itemWidth+magin)*i, 5.0f, itemWidth, itemWidth)];
            if (i==2) {
                btn.frame = CGRectMake(btn.left-0.2*itemWidth, btn.top-0.4*itemWidth, 1.4*itemWidth, 1.4*itemWidth);
            }
            
            btn.tag = 150+i;
            [btn setBackgroundImage:[WanUtils imageInBundelWithName:imageArr[i]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[WanUtils imageInBundelWithName:selectImageArr[i]] forState:UIControlStateSelected];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lblWidth, 14)];
            lbl.center = CGPointMake(btn.centerX, btn.bottom+lbl.height/2.0);
            lbl.text = nameArr[i];
            lbl.font = [UIFont systemFontOfSize:11];
            lbl.textColor = [UIColor whiteColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            
            UIControl *ctorl = [[UIControl alloc] initWithFrame:CGRectMake(lbl.left, btn.top, lbl.width, lbl.bottom-btn.top)];
            ctorl.tag = 250+i;
            [ctorl addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_tabbarView addSubview:btn];
            [_tabbarView addSubview:lbl];
            [_tabbarView addSubview:ctorl];
        }
    }
    return _tabbarView;
}

#pragma mark --self  action
-(void)btnClick:(UIControl *)ctrol{
    UIButton *btn = [self.tabbarView viewWithTag:ctrol.tag-100];
    btn.selected = YES;
    _selectedBtn.selected = NO;
    _selectedBtn = btn;
    
    NSInteger index = btn.tag-150;
    
    if (index == 2) {
        [self hidenTip];
    }else{
        NSArray *serverArr = @[@"user", @"introduction", @"",  @"customer", @"card"];
        self.tipWebview.hidden = NO;
        
        NSString *timestamp = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
        NSString *signStr = [NSString stringWithFormat:@"service=%@&request_time=%@&game_id=%@&uid=%@&key=%@", serverArr[index], timestamp, self.gameid, self.uid, @"86b070f9bcc5a83178fd4ed51ec7fd6b"];
        NSString *sign = [NSString md5:signStr];
        NSString *urlStr = [NSString stringWithFormat:@"%@/mobile/quickV2/transform?service=%@&sign=%@&request_time=%@&game_id=%@&uid=%@",domian, serverArr[index], sign, timestamp, self.gameid, self.uid];
        
        [self.tipWebview setUrl:urlStr];
    }
}

-(void)tapBgView:(UITapGestureRecognizer *)tap{
    [self hidenTip];
}

-(void)addTap{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

-(void)hidenTip{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Wan_HidenTipWebviewNotificaton" object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.view) {
        CGPoint point = [touch locationInView:self.view];
        if (point.y < self.tipWebview.top || (self.tipWebview.hidden == YES && point.y < self.tabbarView.top)) {
            return YES;
        }
    }
    return NO;
}

@end
