//
//  TXDiscoveViewController.h
//  TailorX
//
//  Created by Qian Shen on 16/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseViewController.h"
#import "TXLatestReleaseViewController.h"
#import "TXHeatViewController.h"

@interface TXDiscoveViewController : TXBaseViewController

/** 最新*/
@property (nonatomic, strong) TXLatestReleaseViewController *latestReleaseView;
/** 最热*/
@property (nonatomic, strong) TXHeatViewController *heatView;
/** 当前集合视图*/
@property (nonatomic, strong) UICollectionView *currenCollectionView;

@end
