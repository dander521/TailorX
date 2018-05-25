//
//  TXFavoriteChoiceViewController.h
//  TailorX
//
//  Created by 温强 on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXWaterfallColCell.h"

@interface TXFavoriteChoiceViewController : UIView

/** 收藏详情页类型 */
@property (nonatomic, assign) TXWaterfallColCellType viewType;

- (instancetype)initWithFrame:(CGRect)frame viewType:(TXWaterfallColCellType)type;

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@end
