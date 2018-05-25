//
//  TXIndicatorView.m
//  TailorX
//
//  Created by Qian Shen on 13/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXIndicatorView.h"

@interface TXIndicatorView ()


/** 菊花的顶部约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;


@end

@implementation TXIndicatorView

- (void)showMaskIndicatorViewTopLayout:(CGFloat)layout inView:(UIView *)inView {
    [inView addSubview:self];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    if (layout >= SCREEN_HEIGHT - 30) {
        self.activityView.hidden = YES;
        self.topActivityView.hidden = NO;
        [self.topActivityView startAnimating];
    }else {
        self.topLayout.constant =  layout;
        [self layoutIfNeeded];
        self.activityView.hidden = NO;
        self.topActivityView.hidden = YES;
        [self.activityView startAnimating];
    }
}

- (void)hiddenMaskIndicatorView {
    self.activityView.hidden = YES;
    self.topActivityView.hidden = YES;
    self.backBtn.hidden = YES;
    [self.activityView stopAnimating];
    [self removeFromSuperview];
}

@end
