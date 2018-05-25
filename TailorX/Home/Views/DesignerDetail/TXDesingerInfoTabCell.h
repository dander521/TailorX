//
//  TXDesingerInfoTabCell.h
//  TailorX
//
//  Created by Qian Shen on 17/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXDesignerProductionListModel.h"
#import "TXProductListModel.h"

typedef NS_ENUM(NSInteger, TXDesingerInfoTabCellType) {
    TXDesingerInfoTabCellTypeDesign,
    TXDesingerInfoTabCellTypeDeal
};

@class TXDesingerInfoTabCell;

@protocol TXDesingerInfoTabCellDelegate <NSObject>

@required

/**
 点击某个cell

 @param desingerInfoTabCell self
 @param index 下标
 */
- (void)desingerInfoTabCell:(TXDesingerInfoTabCell*)desingerInfoTabCell didSelectOfIndex:(NSInteger)index type:(TXDesingerInfoTabCellType)cellType;

/**
 * 点击查看全部
 */
- (void)desingerInfoTabCell:(TXDesingerInfoTabCell*)desingerInfoTabCell clickAllBtn:(UIButton*)btn type:(TXDesingerInfoTabCellType)cellType;

@end

@interface TXDesingerInfoTabCell : UITableViewCell

/** <#description#> */
@property (nonatomic, assign) TXDesingerInfoTabCellType cellType;
/** 数据源*/
@property (nonatomic, strong) NSArray<TXDesignerProductionListModel*> *dataSource;
/** 数据源*/
@property (nonatomic, strong) NSArray<TXProductListModel*> *productDataSource;
/** 代理*/
@property (nonatomic, weak) id<TXDesingerInfoTabCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
