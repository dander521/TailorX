//
//  TXFavoriteViewController.h
//  TailorX
//
//  Created by 倩倩 on 17/3/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXFavoriteViewController : UIViewController

/** 当前集合视图*/
@property (nonatomic, strong) UICollectionView *currenCollectionView;


- (void)cancelNavigationControllerDelegate;

@end
