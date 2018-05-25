//
//  TXSectionReusableView.m
//  TailorX
//
//  Created by Qian Shen on 16/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXSectionReusableView.h"

@interface TXSectionReusableView ()

@end


@implementation TXSectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [self.bgView addGestureRecognizer:tap];
}

- (void)click {
    if (_delegate && [_delegate respondsToSelector:@selector(sectionReusableView:clickofSection:)]) {
        [_delegate sectionReusableView:self clickofSection:_section];
    }
}

@end
