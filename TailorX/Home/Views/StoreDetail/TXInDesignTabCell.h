//
//  TXInDesignTabCell.h
//  TailorX
//
//  Created by Qian Shen on 10/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXGetStoreDesignerListModel.h"
@class TXInDesignTabCell;

@protocol TXInDesignTabCellDelegate <NSObject>

@required

- (void)didSelectedInDesignTabCell:(TXInDesignTabCell *)inDesignTabCell ofIndex:(NSInteger)index atItem:(NSInteger)item;

@end

@interface TXInDesignTabCell : UITableViewCell

/** 数据源*/
@property (nonatomic, strong) NSArray *dataSource;
/** 模型*/
@property (nonatomic, strong) TXGetStoreDesignerListModel *model;
/** 下标*/
@property (nonatomic, assign) NSInteger index;
@property (strong, nonatomic) UICollectionView *collectionView;
/** 代理*/
@property (nonatomic, weak) id<TXInDesignTabCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end
