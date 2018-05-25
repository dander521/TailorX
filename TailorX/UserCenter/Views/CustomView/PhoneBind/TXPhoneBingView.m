
//
//  TXPhoneBingView.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXPhoneBingView.h"

@implementation TXPhoneBingView

/**
 *  实例方法
 */
+ (instancetype)instanceView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}

@end
