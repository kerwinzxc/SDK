//
//  WanTipWebview.h
//  WanAppStroeSDK
//
//  Created by Star on 2017/6/12.
//  Copyright © 2017年 liuluoxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WanConstance.h"

#define webviewWidth ((WAN_SCREEN_HEIGHT >  WAN_SCREEN_WIDTH)?(WAN_SCREEN_WIDTH):(305*kRetio))

@interface WanTipWebview : UIView

@property (nonatomic, strong) NSString *url;

@end
