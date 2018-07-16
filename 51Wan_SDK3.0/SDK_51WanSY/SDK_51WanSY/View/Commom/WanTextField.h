//
//  WanTextField.h
//  SDK_51WanSY
//
//  Created by Star on 2018/2/1.
//  Copyright © 2018年 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WanTextField : UITextField

-(void)setLeftViewWithImageName:(NSString *)imgName;

-(void)setPlaceHolder:(NSString *)placeholer;

-(UIButton *)setValicodeViewWithTitle:(NSString *)title target:(id)target action:(SEL)action;

-(UIButton *)setChooseBtnWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImg target:(id)target action:(SEL)action;

@end
