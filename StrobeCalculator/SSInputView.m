//
//  SSInputView.m
//  BeautyPlus
//
//  Created by peter on 14-9-5.
//  Copyright (c) 2014年 BeautyPlus. All rights reserved.
//

#import "SSInputView.h"
#import "UIView+Additions.h"
@implementation SSInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"inputView" owner:self options:nil] firstObject];
        UIButton *btn1 = (UIButton *)[view viewWithTag:101];
        UIButton *btn2 = (UIButton *)[view viewWithTag:102];
        UIButton *btn3 = (UIButton *)[view viewWithTag:103];
        UIImageView *line = (UIImageView *)[view viewWithTag:99];
        self.frame = view.frame;
        [self addSubview:btn1];
        [self addSubview:btn2];
        [self addSubview:btn3];
        [self addSubview:line];
        line.left = 0;
        line.top = 0;
        self.backgroundColor = [UIColor whiteColor];
        self.btnHide = btn3;
        self.btnPre = btn1;
        self.btnNext = btn2;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (point.y < 0 || point.y > self.height) {
        return view;
    }
    if (view == self.btnHide || view == self.btnNext || view == self.btnPre) {
        return view;
    }
    return _touchView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
