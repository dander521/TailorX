//
//  TXGradientLabel.m
//  TailorX
//
//  Created by Qian Shen on 12/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXGradientLabel.h"

@implementation TXGradientLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //1:设置自身的属性
        self.font = [UIFont systemFontOfSize:15];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = RGB(204, 204, 204);
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)setSca:(CGFloat)sca {
    _sca = sca;
    CGFloat fontScale = 1 - sca *0.3;
    // self.transform = CGAffineTransformMakeScale(fontScale, fontScale);
    NSLog(@"%lf---",fontScale);
    self.textColor = RGBA(46, 46, 46, fontScale);
}

@end
