//
//  TXStoreTabCell.h
//  TailorX
//
//  Created by Qian Shen on 4/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXStoreTabCell;

@protocol TXStoreTabCellDelegate <NSObject>

/**
 选择了某一个cell
 
 @param designerView self
 @param index 下标
 */
- (void)storeTabCell:(TXStoreTabCell*)cell didSelectItemOfIndex:(NSInteger)index;

@end

@interface TXStoreTabCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 查看全部*/
@property (weak, nonatomic) IBOutlet UIButton *checkAllBtn;

/** 数据源*/
@property (nonatomic, strong) NSArray *dataSource;
/** 代理*/
@property (nonatomic, weak) id<TXStoreTabCellDelegate> delegate;

@end
