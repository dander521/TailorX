//
//  TXWaterfallColCell.h
//  TailorX
//
//  Created by Qian Shen on 31/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TXInformationListModel.h"

#import "TXFindPictureModel.h"

@class TXWaterfallColCell;

/**
 瀑布流cell类型
 */
typedef NS_ENUM(NSUInteger, TXWaterfallColCellType) {
    TXWaterfallColCellTypeInformation, /**< 咨询cell */
    TXWaterfallColCellTypeDiscover /**< 发现cell */
};
 
@protocol TXWaterfallColCellDelegate <NSObject>

@optional

- (void)waterfallColCell:(TXWaterfallColCell*)waterfallColCell clickLikedBtn:(UIButton*)sender ofPictureListModelModel:(TXFindPictureListModel*)model;

- (void)waterfallColCell:(TXWaterfallColCell*)waterfallColCell clickDesignerBtn:(UIButton*)sender ofPictureListModelModel:(TXFindPictureListModel*)model;

- (void)waterfallColCell:(TXWaterfallColCell*)waterfallColCell clickLikedBtn:(UIButton*)sender ofInformationModel:(TXInformationListModel*)model;

@end

@interface TXWaterfallColCell : UICollectionViewCell

/** 空白处视图*/
@property (weak, nonatomic) IBOutlet UIView *sapceView;

@property (nonatomic, strong) NSURL *imageURL;
/** 商品封面*/
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** 发现模型*/
@property (nonatomic, strong) TXFindPictureListModel *pictureListModel;
/** 资讯模型*/
@property (nonatomic, strong) TXInformationListModel *infomationModel;

/** 是否收藏 (0未收藏，1已收藏)*/
@property (weak, nonatomic) IBOutlet UIButton *likedBtn;
/** 浏览量*/
@property (weak, nonatomic) IBOutlet UILabel *amountOfReadingLabel;
/** 收藏量*/
@property (weak, nonatomic) IBOutlet UILabel *popularityLabel;
/** 代理*/
@property (nonatomic, weak) id<TXWaterfallColCellDelegate> delegate;
/** cell type */
@property (nonatomic, assign) TXWaterfallColCellType cellType;

@end
