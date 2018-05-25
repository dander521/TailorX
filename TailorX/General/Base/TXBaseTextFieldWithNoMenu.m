//
//  TXBaseTextFieldWithNoMenu.m
//  TailorX
//
//  Created by ZhuJian on 2017/6/7.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseTextFieldWithNoMenu.h"

@implementation TXBaseTextFieldWithNoMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu) {
        menu.menuVisible = NO;
    }
    return NO;
}

@end
