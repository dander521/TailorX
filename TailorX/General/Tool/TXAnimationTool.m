//
//  TXAnimationTool.m
//  TailorX
//
//  Created by liuyanming on 2017/3/30.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAnimationTool.h"

@implementation TXAnimationTool

+ (void)addAnimations:(UIView *)obj {
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.1;
    pulse.repeatCount = 1;
    pulse.autoreverses = YES;
    pulse.fromValue = [NSNumber numberWithFloat:0.2];
    pulse.toValue = [NSNumber numberWithFloat:1.1];
    [obj.layer addAnimation:pulse forKey:nil];
}

@end
