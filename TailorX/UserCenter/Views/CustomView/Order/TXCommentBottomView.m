//
//  TXCommentBottomView.m
//  TailorX
//
//  Created by 程荣刚 on 2017/7/6.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCommentBottomView.h"

@implementation TXCommentBottomView

+ (instancetype)instanceView {
    TXCommentBottomView *instance = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];

    return instance;
}

- (IBAction)touchShowCommentDetailButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchShowCommentDetail)]) {
        [self.delegate touchShowCommentDetail];
    }
}


@end
