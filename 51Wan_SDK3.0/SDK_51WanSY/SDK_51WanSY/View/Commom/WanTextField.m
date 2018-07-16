//
//  WanTextField.m
//  SDK_51WanSY
//
//  Created by Star on 2018/2/1.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "WanTextField.h"

#define WanRightButtonWidth 100

@implementation WanTextField

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initTextFieldUI];
    }
    return self;
}

-(void)initTextFieldUI{
    self.layer.cornerRadius = 4.0f;
    self.returnKeyType = UIReturnKeyDone;
    [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.08]];
    self.textColor = [UIColor whiteColor];
}

-(void)setLeftViewWithImageName:(NSString *)imgName{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imgView.image = [WanUtils imageInBundelWithName:imgName];
    
    self.leftView = imgView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(UIButton *)setValicodeViewWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIButton *sendCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WanRightButtonWidth, self.height)];
    [sendCodeBtn setTitle:title forState:UIControlStateNormal];
    sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    sendCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sendCodeBtn setTitleColor:WanButtonTitleColor forState:UIControlStateNormal];
    [sendCodeBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.rightView = sendCodeBtn;
    self.rightViewMode = UITextFieldViewModeAlways;
    return sendCodeBtn;
}

-(UIButton *)setChooseBtnWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImg target:(id)target action:(SEL)action{
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WanRightButtonWidth, self.height)];
    
    UIButton *chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(WanRightButtonWidth-15, (self.height-18)/2.0, 18, 18)];
    [chooseBtn setBackgroundImage:image forState:UIControlStateNormal];
    [chooseBtn setBackgroundImage:selectedImg forState:UIControlStateSelected];
    [chooseBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:chooseBtn];
    
    self.rightView = rightView;
    self.rightViewMode = UITextFieldViewModeAlways;
    return chooseBtn;
}

-(void)setPlaceHolder:(NSString *)placeholer{
    //设置placeholder的字体与颜色
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholer attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.5], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    return CGRectMake(10, (self.height-20)/2.0, 20, 20);
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    return CGRectMake(self.width-WanRightButtonWidth-10, 0, WanRightButtonWidth, self.height);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    return CGRectMake(40, 0, self.width-40, self.height);
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectMake(40, 0, self.width-40, self.height);
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectMake(40, bounds.origin.y, bounds.size.width-40, bounds.size.height);
}

@end
