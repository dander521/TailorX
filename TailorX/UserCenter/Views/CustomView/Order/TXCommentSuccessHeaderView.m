//
//  TXCommentSuccessHeaderView.m
//  TailorX
//
//  Created by RogerChen on 2017/3/30.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCommentSuccessHeaderView.h"

@implementation TXCommentSuccessHeaderView


/**
 *  实例方法
 */
+ (instancetype)instanceView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}


- (void)setHeaderType:(TXCommentSuccessHeaderType)headerType {
    _headerType = headerType;
    
    if (headerType == TXCommentSuccessHeaderTypeDefault) {
        [self.continueCommentView removeFromSuperview];
    }
}

@end
