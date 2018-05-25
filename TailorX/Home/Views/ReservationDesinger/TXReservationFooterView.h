//
//  TXReservationFooterView.h
//  TailorX
//
//  Created by Qian Shen on 14/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXReservationFooterView : UIView

/** 显示图片张数*/
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
/** 上传图片集合视图*/
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 标签的背景视图*/
@property (weak, nonatomic) IBOutlet UIView *tagBgView;
/** 标签*/
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
/** 集合视图的高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;
/** 集合视图的宽度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLayout;

@end
