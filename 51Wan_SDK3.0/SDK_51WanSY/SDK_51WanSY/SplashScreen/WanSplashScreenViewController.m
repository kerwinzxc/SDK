//
//  WanSplashScreenViewController.m
//  SDK_51WanSY
//
//  Created by Star on 2018/1/30.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanSplashScreenViewController.h"
#import<AVFoundation/AVFoundation.h>

@interface WanSplashScreenViewController ()

@end

@implementation WanSplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPlayer];
}

-(void)addPlayer{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://baobab.wdjcdn.com/1455782903700jy.mp4"]];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:playerLayer];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [player play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"item 有误");
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准好播放了");
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                break;
            default:
                break;
        }
    }
}

-(void)dealloc{
    //移除监听（观察者）
//    [object removeObserver:self forKeyPath:@"status"];
}

@end
