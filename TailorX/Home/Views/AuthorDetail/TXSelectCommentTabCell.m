//
//  TXSelectCommentTabCell.m
//  TailorX
//
//  Created by Qian Shen on 12/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXSelectCommentTabCell.h"

@implementation TXSelectCommentTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showSubViews:(BOOL)isShow {
    if (isShow) {
        for (UIView *subView in self.contentView.subviews) {
            subView.hidden = NO;
        }
    }else {
        for (UIView *subView in self.contentView.subviews) {
            subView.hidden = YES;
        }
    }
}

@end
