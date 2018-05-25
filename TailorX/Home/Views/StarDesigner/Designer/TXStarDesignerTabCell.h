//
//  TXStarDesignerTabCell.h
//  TailorX
//
//  Created by Qian Shen on 4/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXStarDesignerTabCell;

@protocol TXStarDesignerTabCellDelegate <NSObject>

/**
 选择了某一个cell
 
 @param designerView self
 @param index 下标
 */
- (void)starDesignerTabCell:(TXStarDesignerTabCell*)cell didSelectItemOfIndex:(NSInteger)index;

- (void)touchAllDesignerButton;

@end

@interface TXStarDesignerTabCell : UITableViewCell

/** 查看全部*/
@property (weak, nonatomic) IBOutlet UIButton *checkAllBtn;
/** 列表*/
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 数据源*/
@property (nonatomic, strong) NSArray *dataSource;
/** 代理*/
@property (nonatomic, weak) id<TXStarDesignerTabCellDelegate> delegate;

@end
