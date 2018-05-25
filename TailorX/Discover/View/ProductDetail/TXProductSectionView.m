//
//  TXProductSectionView.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/8.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXProductSectionView.h"

@implementation TXProductSectionView

/**
 *  实例方法
 */
+ (instancetype)instanceView {
    TXProductSectionView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];

    return headerView;
}

@end
