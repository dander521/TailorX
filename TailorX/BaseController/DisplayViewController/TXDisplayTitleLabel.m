//
//  TXDisplayTitleLabel.m
//  TailorX
//
//  Created by Qian Shen on 31/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDisplayTitleLabel.h"

@implementation TXDisplayTitleLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [_fillColor set];
    
    rect.size.width = rect.size.width * _progress;
    
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.userInteractionEnabled = YES;
        
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}


@end
