//
//  TXCustomNavView.m
//  TailorX
//
//  Created by Qian Shen on 7/6/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCustomNavView.h"

@implementation TXCustomNavView


+ (instancetype)getCustomNavView {
    TXCustomNavView * nav = [[NSBundle mainBundle] loadNibNamed:@"TXCustomNavView" owner:nil options:nil].firstObject;
    nav.bottomView.layer.shadowOffset = CGSizeMake(1, 1);
    nav.bottomView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    nav.bottomView.layer.shadowOpacity = 0.5;
    return nav;
}

@end
