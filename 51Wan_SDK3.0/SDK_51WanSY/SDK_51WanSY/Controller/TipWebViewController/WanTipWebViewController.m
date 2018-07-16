//
//  WanTipWebViewController.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/30.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanTipWebViewController.h"
#import "WanTipItemModel.h"
#import "WanToolItemCell.h"
#import "WanTipWebview.h"

#define toolItemCellID @"toolItemCell"
#define tableHeaderHeight 44.0

@interface WanTipWebViewController ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *itemArray;

@property (nonatomic, strong) UITableView *toolItemTable;

@property (nonatomic, strong) WanTipWebview *tipWebview;

@end

@implementation WanTipWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTap];
    [self.view addSubview:self.toolItemTable];
}

-(void)addTap{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

#pragma mark ---getter
-(NSMutableArray *)itemArray{
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
        NSArray *imageArr = @[@"my", @"raiders", @"server", @"gift"];
        NSArray *selectImageArr = @[@"my_down", @"raiders_down", @"server_down", @"gift_down"];
        NSArray *nameArr = @[@"我的", @"攻略", @"客服", @"礼包"];
        NSArray *serverArr = @[@"user", @"introduction", @"customer", @"card"];
        for (int i = 0; i < imageArr.count; i++) {
            WanTipItemModel *model = [[WanTipItemModel alloc] init];
            model.title = nameArr[i];
            model.image = imageArr[i];
            model.selectImage = selectImageArr[i];
            model.server = serverArr[i];
            [_itemArray addObject:model];
        }
    }
    return _itemArray;
}

-(UITableView *)toolItemTable{
    if (_toolItemTable == nil) {
        _toolItemTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 70, self.view.height)];
        _toolItemTable.delegate = self;
        _toolItemTable.dataSource = self;
        _toolItemTable.separatorColor = [UIColor colorWithHexString:@"#b63111"];
        _toolItemTable.scrollEnabled = NO;
        _toolItemTable.bounces = NO;
        [_toolItemTable registerClass:[WanToolItemCell class] forCellReuseIdentifier:toolItemCellID];
        //设置渐变背景色
        UIImage *bgImg = [UIColor gradientColorImageFromColors:@[[UIColor colorWithHexString:@"f87045"], [UIColor colorWithHexString:@"dd4341"],[UIColor colorWithHexString:@"c41a3f"]] gradientType:GradientTypeTopToBottom imgSize:_toolItemTable.size];
        _toolItemTable.backgroundColor = [UIColor colorWithPatternImage:bgImg];
        _toolItemTable.clipsToBounds = false;
        
        //设置表头
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _toolItemTable.width, tableHeaderHeight)];
        tableHeaderView.backgroundColor = [UIColor clearColor];
        //图片
        UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
        [imageBtn setImage:[WanUtils imageInBundelWithName:@"tip_nav"] forState:UIControlStateNormal];
        imageBtn.center = tableHeaderView.center;
//        [imageBtn addTarget:self action:@selector(hidenWebView:) forControlEvents:UIControlEventTouchUpInside];
        [tableHeaderView addSubview:imageBtn];
        //分割线条
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tableHeaderView.height-0.5, tableHeaderView.width, 0.5)];
        lineLabel.backgroundColor = [UIColor colorWithHexString:@"b63111"];
        [tableHeaderView addSubview:lineLabel];
        _toolItemTable.tableHeaderView = tableHeaderView;
        
        UILabel *footLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tableHeaderView.height-0.5, tableHeaderView.width, 0.5)];
        footLineLabel.backgroundColor = [UIColor colorWithHexString:@"#b63111"];
        _toolItemTable.tableFooterView = footLineLabel;
    }
    return _toolItemTable;
}

-(WanTipWebview *)tipWebview{
    if (!_tipWebview) {
        _tipWebview = [[WanTipWebview alloc] initWithFrame:CGRectMake(self.toolItemTable.right, 0, webviewWidth, self.view.height)];
        _tipWebview.hidden = YES;
        [self.view addSubview:_tipWebview];
    }
    return _tipWebview;
}

#pragma mark --self  action
-(void)tapBgView:(UITapGestureRecognizer *)tap{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Wan_HidenTipWebviewNotificaton" object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark --<UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WanToolItemCell *cell = [tableView dequeueReusableCellWithIdentifier:toolItemCellID];
    cell.itemModel = self.itemArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (self.view.height-tableHeaderHeight)/self.itemArray.count;
}

//设置分割线的位置
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//点击cell,显示webview
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tipWebview.hidden = NO;
    WanTipItemModel *itemModel = self.itemArray[indexPath.row];
    
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *signStr = [NSString stringWithFormat:@"service=%@&request_time=%@&game_id=%@&uid=%@&key=%@", itemModel.server, timestamp, self.gameid, self.uid, @"86b070f9bcc5a83178fd4ed51ec7fd6b"];
    NSString *sign = [NSString md5:signStr];
    NSString *urlStr = [NSString stringWithFormat:@"%@/mobile/quickV2/transform?service=%@&sign=%@&request_time=%@&game_id=%@&uid=%@",domian, itemModel.server, sign, timestamp, self.gameid, self.uid];
    
    [self.tipWebview setUrl:urlStr];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.view) {
        CGPoint point = [touch locationInView:self.view];
        if (point.x > self.tipWebview.right || (_tipWebview.hidden == YES && point.x > self.toolItemTable.right)) {
            return YES;
        }
    }
    return NO;
}

@end
