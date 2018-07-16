//
//  PPUIUtils.h
//  PregnanceParter
//
//  Created by Kzzang's iMac on 14/11/29.
//  Copyright (c) 2014年 WZH Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PPUIUtils : NSObject


#pragma mark - Animation
+ (void) fadeAnimationWithView:(UIView *) animationView;

#pragma mark - Progress
+ (void)hideProgressHUD:(BOOL)animated inView:(UIView *) view;

+ (void)showMessage:(NSString *)message inView:(UIView *)view hiddenAfterDelay:(NSTimeInterval)delay;

#pragma mark - UIImageView
+ (UIImageView *) userIconRoundMask:(CGRect) userIconRect withImageName:(NSString *) imageName;

+ (void)showStateInWindow:(NSString *)string;

@end
