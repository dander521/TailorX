//
//  TXFashionViewController.h
//  TailorX
//
//  Created by Qian Shen on 15/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseViewController.h"

@interface TXFashionViewController : TXBaseViewController

/** 集合ID*/
@property (nonatomic, strong) NSString *infoGroupId;
/** 导航栏文字 */
@property (nonatomic, strong) NSString *naviTitle;
/** 列表*/
@property (nonatomic, strong) UICollectionView *collectionView;

@end
