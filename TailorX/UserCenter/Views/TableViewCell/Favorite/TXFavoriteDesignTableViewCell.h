//
//  TXFavoriteDesignTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/8/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXFavoriteDesignerListModel.h"
#import "TXFindPictureDetailModel.h"

@class TXFavoriteDesignTableViewCell;

@protocol TXFavoriteDesignTableViewCellDelegate <NSObject>

@optional

- (void)tapImageViewWithIndex:(NSUInteger)index photoArray:(NSArray *)photoArray cell:(TXFavoriteDesignTableViewCell *)cell;

- (void)cancelSaveDesignerWithDesignerModel:(TXFavoriteDesignerListModel *)designerModel;

- (void)cancelSaveDesignerWithDesignerId:(NSString *)designerId ofLikeBtn:(UIButton*)sender;

@end

@interface TXFavoriteDesignTableViewCell : TXSeperateLineCell

/** 右侧箭头 */
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
/** 代理 */
@property (nonatomic, assign) id <TXFavoriteDesignTableViewCellDelegate> delegate;

/** 设计师模型 */
@property (nonatomic, strong) TXFavoriteDesignerListModel *designerModel;
/** 发现详情模型*/
@property (nonatomic, strong) TXFindPictureDetailModel *pictureDetailModel;
@property (weak, nonatomic) IBOutlet UIImageView *designerOpusImg1;
@property (weak, nonatomic) IBOutlet UIImageView *designerOpusImg2;
@property (weak, nonatomic) IBOutlet UIImageView *designerOpusImg3;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
