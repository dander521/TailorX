//
//  TXRulesView.m
//  TailorX
//
//  Created by Qian Shen on 29/6/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXRulesView.h"

@implementation TXRulesView

+ (instancetype)creationRulesView {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TXRulesView" owner:nil options:nil];
    return  [nib objectAtIndex:0];
}

@end
