//
//  TXRegisteredView.m
//  TailorX
//
//  Created by Qian Shen on 17/7/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXRegisteredView.h"

@implementation TXRegisteredView

+ (instancetype)creationRegisteredView {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TXRegisteredView" owner:nil options:nil];
    return  [nib objectAtIndex:0];
}

@end
