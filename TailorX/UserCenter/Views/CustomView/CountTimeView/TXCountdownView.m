//
//  CountdownView.m
//  iOS开发常见技术-每日一记
//
//  Created by Qian Shen on 2017/3/13.
//  Copyright © 2017年 Qian Shen. All rights reserved.
//

#import "TXCountdownView.h"

typedef void(^completeBlock)(void);

@interface TXCountdownView ()


/** 显示Label的背景视图的中心x约束，用于改变计时结束后，更新DescLabel的位置*/

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewCenterXConstraint;


@end

@implementation TXCountdownView

+ (instancetype)setupTXCountdownView {
    TXCountdownView *countView = [[NSBundle mainBundle] loadNibNamed:@"TXCountdownView" owner:nil options:nil].lastObject;
    countView.hourLabel.backgroundColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    countView.minutesLabel.backgroundColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    countView.secondsLabel.backgroundColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    return countView;
}

- (instancetype)initWithAllReverseTime:(int)reverseTime {
    TXCountdownView *countView = [[NSBundle mainBundle] loadNibNamed:@"TXCountdownView" owner:nil options:nil].lastObject;
    countView.reverseTime = reverseTime;
    return countView;
}

- (void)startTimeCompleteBlock:(completeBlock)block{
    __block int timeOut = self.reverseTime;
    __weak typeof(self) weakSelf = self;
    //倒计时时间
    if(timeOut <= 0){
        [weakSelf updateUI];
        block();
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateUI];
                block();
            });
        } else {
           
            int h = timeOut / 3600;
            int m = timeOut % 3600 / 60;
            int s = timeOut % 3600 % 60;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.hourLabel.text = [NSString stringWithFormat:@"%0.2d",h];
                weakSelf.minutesLabel.text = [NSString stringWithFormat:@"%0.2d",m];
                weakSelf.secondsLabel.text = [NSString stringWithFormat:@"%0.2d",s];
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

- (void)updateUI {
    self.space_firstLabel.text = @"";
    self.spce_twoLabel.text = @"";
    self.hourLabel.text = @"";
    self.minutesLabel.text = @"";
    self.secondsLabel.text = @"";
    [self layoutIfNeeded];
    CGFloat leftWidth = CGRectGetWidth(self.hourLabel.frame) + CGRectGetWidth(self.minutesLabel.frame) + CGRectGetWidth(self.secondsLabel.frame);
    self.bgViewCenterXConstraint.constant -= leftWidth /2.0;
}



@end
