//
//  TXSubTotalView.m
//  TailorX
//
//  Created by RogerChen on 2017/4/10.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXSubTotalView.h"

@implementation TXSubTotalView

/**
 *  实例方法
 */
+ (instancetype)instanceView {
    TXSubTotalView *bottomView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    bottomView.subTotalLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    return bottomView;
}

@end
